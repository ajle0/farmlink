<?php
require_once( APPPATH .'libraries/REST_Controller.php' );
require_once( APPPATH .'libraries/braintree_lib/autoload.php' );
require_once(APPPATH . 'libraries/PayPal-PHP-SDK/paypal/rest-api-sdk-php/sample/bootstrap.php');
require_once( APPPATH .'libraries/stripe_lib/autoload.php' );



use PayPal\Api\Amount;
use PayPal\Api\RefundRequest;
use PayPal\Api\Sale;
/**
 * REST API for Transaction Header
 */
class Refunds extends API_Controller
{
    public $_api_context;

    /**
     * Constructs Parent Constructor
     */
    function __construct()
    {
        parent::__construct( 'Transactionheader' );

        $this->load->model('paypal_model');


    }


    function cancel_order_refund_post(){

        error_reporting(0);
        
        //var_dump(\Stripe\Stripe::VERSION);die;

		$rules = array(
			array(
				'field' => 'transaction_header_id',
				'rules' => 'required'
			),
		);

		// exit if there is an error in validation,
        if ( !$this->is_valid( $rules )) exit;
        
        $transaction_header_id = $this->post('transaction_header_id');

        $payment_method = $this->Transactionheader->get_one($transaction_header_id)->payment_method;

        $trans_status_id = $this->Transactionheader->get_one($transaction_header_id)->trans_status_id;
        $is_refundable = $this->Transactionstatus->get_one($trans_status_id)->is_refundable;

        $conds['transactions_header_id'] = $transaction_header_id;
        $payment_status = $this->Transaction_payment->get_one_by($conds)->payment_status;


        if ($is_refundable == '0' ) {
            $this->error_response( get_msg( 'cannot_refund_stage' ), 503);
        } elseif ( $payment_method == "COD" || $payment_method == "Pick Up" || $payment_method == "Razor" || $payment_method == "BANK" || $payment_method == "Paystack" || $payment_method == "Flutter Wave") {
            $this->error_response( get_msg( 'cannot_refund_payment' ), 503);
        } elseif ($payment_status == 'refunded') {
            $this->error_response( get_msg( 'already_refunded' ), 503);
        } else {

            if ($payment_method == 'STRIPE') {
                $conds['transactions_header_id'] = $transaction_header_id;
                $charge_id = $this->Transaction_payment->get_one_by($conds)->charge_id;
                $amount = $this->Transaction_payment->get_one_by($conds)->amount;
                $shop_id = $this->Transaction_payment->get_one_by($conds)->shop_id;

                $shop_info = $this->Shop->get_one($shop_id);
                try {
                    \Stripe\Stripe::setApiKey( trim($shop_info->stripe_secret_key) );

                    //refund amount
                    $refund = \Stripe\Refund::create([
                        'amount' => $amount,
                        'payment_intent' => $charge_id
                    ]);

                    //update refunded record at transaction payment log
                    $id = $this->Transaction_payment->get_one_by($conds)->id;
                    if ($refund->status == "succeeded") {
                        //update transaction payment log

                        $data = array(
                            "refund_id" => $refund->id,
                            "refund_amount" => $amount,
                            'payment_status' => 'refunded'
                        );
                        $this->Transaction_payment->save($data,$id);

                        //update transaction status and payment status at transaction header

                        $trans_data = array(
                            "trans_status_id" => 'trans_sts47fe98346e0f80d844d307981eaef7ec',
                            "payment_status_id" => '3'

                        );
                        $this->Transactionheader->save($trans_data,$transaction_header_id);

                    }

                    //send refund email to user

                    $to_who = "user";
                    $subject = get_msg('order_refund_subject');
                    send_refund_order_email( $transaction_header_id, $to_who, $subject, $amount );


                    $trans_header_obj = $this->Transactionheader->get_one($transaction_header_id);

                    $this->custom_response($trans_header_obj);
                }

                catch(exception $e) {
                    //echo json_encode(array('error' => get_msg( 'stripe_transaction_failed' )));
                    $this->error_response( get_msg( 'stripe_refund_failed' ), 500);

                }

            } elseif ($payment_method == "PAYPAL") {


                $conds['transactions_header_id'] = $transaction_header_id;
                $saleId = $this->Transaction_payment->get_one_by($conds)->txn_id;
                $amount = $this->Transaction_payment->get_one_by($conds)->amount;
                $shop_id = $this->Transaction_payment->get_one_by($conds)->shop_id;

                $paypal_client_id = $this->Shop->get_one($shop_id)->paypal_client_id;
                $paypal_secret_key = $this->Shop->get_one($shop_id)->paypal_secret_key;


                $this->_api_context = new \PayPal\Rest\ApiContext(
                    new \PayPal\Auth\OAuthTokenCredential(
                        $paypal_client_id, $paypal_secret_key
                    )
                );

                $paymentValue =  (string) round($amount,2);

                $amt = new Amount();
                $amt->setCurrency('SGD')
                    ->setTotal($paymentValue);

                $refundRequest = new RefundRequest();
                $refundRequest->setAmount($amt);

                $sale = new Sale();
                $sale->setId($saleId);
                try {
                    // Refund the sale
                    $refundedSale = $sale->refundSale($refundRequest, $this->_api_context);

                    //update refunded record at transaction payment log
                    $id = $this->Transaction_payment->get_one_by($conds)->id;
                    if ($refundedSale->state == "completed") {
                        //update transaction payment log

                        $data = array(
                            "refund_id" => $refundedSale->id,
                            "refund_amount" => $amount,
                            'payment_status' => 'refunded'
                        );
                        $this->Transaction_payment->save($data,$id);

                        //update transaction status and payment status at transaction header

                        $trans_data = array(
                            "trans_status_id" => 'trans_sts47fe98346e0f80d844d307981eaef7ec',
                            "payment_status_id" => '3'

                        );
                        $this->Transactionheader->save($trans_data,$transaction_header_id);

                    }

                    //send refund email to user

                    $to_who = "user";
                    $subject = get_msg('order_refund_subject');
                    send_refund_order_email( $transaction_header_id, $to_who, $subject, $amount );


                    $trans_header_obj = $this->Transactionheader->get_one($transaction_header_id);

                    $this->custom_response($trans_header_obj);


                } catch (Exception $ex) {
                    //ResultPrinter::printError("Refund Sale", "Sale", null, $refundRequest, $ex);
                    $this->error_response( get_msg( 'paypal_refund_failed' ), 500);
                }

                //ResultPrinter::printResult("Refund Sale", "Sale", $refundedSale->getId(), $refundRequest, $refundedSale);

                //return $refundedSale;
            }
        }


    }
}