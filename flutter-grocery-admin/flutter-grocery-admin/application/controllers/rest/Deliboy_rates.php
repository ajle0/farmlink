<?php
require_once( APPPATH .'libraries/REST_Controller.php' );

/**
 * REST API for News
 */
class Deliboy_rates extends API_Controller
{

    /**
     * Constructs Parent Constructor
     */
    function __construct()
    {
        parent::__construct( 'Rate' );

        // set the validation rules for create and update
        $this->validation_rules();
    }

    /**
     * Default Query for API
     * @return [type] [description]
     */
    function default_conds()
    {
        $conds = array();

        if ( $this->is_get ) {
            // if is get record using GET method

            // get default setting for GET_ALL_CATEGORIES
            $setting = $this->Api->get_one_by( array( 'api_constant' => "GET_ALL_CATEGORIES" ));

            $conds['order_by'] = 1;
            $conds['order_by_field'] = $setting->order_by_field;
            $conds['order_by_type'] = $setting->order_by_type;
        }

        return $conds;
    }

    /**
     * Determines if valid input.
     */
    function validation_rules()
    {
        // validation rules for create
        $this->create_validation_rules = array(
            array(
                'field' => 'transactions_header_id',
                'rules' => 'required'
            ),
            array(
                'field' => 'rating',
                'rules' => 'required'
            ),
            array(
                'field' => 'title',
                'rules' => 'required'
            ),
            array(
                'field' => 'description',
                'rules' => 'required'
            )
        );
    }

    /**
     * Adds a post.
     */
    function add_rating_deliboy_post()
    {

        // set the add flag for custom response
        $this->is_add = true;

        if ( !$this->is_valid( $this->create_validation_rules )) {
            // if there is an error in validation,

            return;
        }

        // get the post data
        $data = $this->post();
        $transactions_header_id = $data['transactions_header_id'];

        $user_id = $this->Transactionheader->get_one($transactions_header_id)->user_id; // from user
        //$users = global_user_check($user_id);


        $delivery_boy_id = $this->Transactionheader->get_one($transactions_header_id)->delivery_boy_id;

        if ($delivery_boy_id == "" || $delivery_boy_id == '0') {
            $this->error_response( get_msg('not_yet_assigned_deliboy'), 503);
        } else {
            $users = global_user_check($delivery_boy_id);
        }


        //check transaction status
        $trans_status_id = $this->Transactionheader->get_one($transactions_header_id)->trans_status_id;
        $final_stage = $this->Transactionstatus->get_one( $trans_status_id )->final_stage;

        $conds['from_user_id'] = $user_id;
        $conds['to_user_id'] = $delivery_boy_id;
        $conds['transactions_header_id'] = $transactions_header_id;

        $id = $this->Deliboy_Rate->get_one_by($conds)->id;

        $rating = $data['rating'];
        $data['from_user_id'] = $user_id;
        $data['to_user_id'] = $delivery_boy_id;
        if ( $id ) {

            $this->error_response( get_msg('already_rating_deliboy'), 503);

        } elseif ($final_stage == '0') {
            $this->error_response( get_msg('not_final_stage'), 503);
        } else {

            $this->Deliboy_Rate->save( $data );

            // response the inserted object
            $obj = $this->Deliboy_Rate->get_one( $data['id'] );
        }
       
        //// Start - Send Noti to to_user_id when reviewed ////
        
        $data['message'] = htmlspecialchars_decode($this->post( 'title' ));
        $data['description'] = $this->post( 'description' );
        $data['rating'] = $this->post('rating');
        $data['flag'] = 'rating';
        $data['trans_header_id'] = $transactions_header_id;
        $data['delivery_boy_id'] = $delivery_boy_id;

		$devices = $this->Notitoken->get_all_device_in($delivery_boy_id)->result();

		$device_ids = array();
		if ( count( $devices ) > 0 ) {
			foreach ( $devices as $device ) {
				$device_ids[] = $device->device_id;
			}
		}

		$platform_names = array();
		if ( count( $devices ) > 0 ) {
			foreach ( $devices as $platform ) {
				$platform_names[] = $platform->platform_name;
			}
		}

		$status = send_android_fcm( $device_ids, $data, $platform_names );

		//// End - Send Noti /////

        //Need to update rating value at user
        // $conds_rating['to_user_id'] = $obj->to_user_id;

        // $total_rating_count = $this->Deliboy_Rate->count_all_by($conds_rating);
        // $sum_rating_value = $this->Deliboy_Rate->sum_all_by($conds_rating)->result()[0]->rating;

        // if($total_rating_count > 0) {
        // 	$total_rating_value = number_format((float) ($sum_rating_value  / $total_rating_count), 1, '.', '');
        // } else {
        // 	$total_rating_value = 0;
        // }

        $user_data['overall_rating'] = $obj->rating;
        $this->User->save($user_data, $obj->to_user_id);

        //$obj_item = $this->Product->get_one( $obj->product_id );
        $obj_deliboy_rating = $this->Deliboy_Rate->get_one( $obj->id );

        $this->ps_adapter->convert_rating_user( $obj_deliboy_rating);
        $this->custom_response( $obj_deliboy_rating );
    }


    /**
     * Convert Object
     */
    function convert_object( &$obj )
    {
        // call parent convert object
        parent::convert_object( $obj );

        $this->ps_adapter->convert_rating_user( $obj );

    }

}