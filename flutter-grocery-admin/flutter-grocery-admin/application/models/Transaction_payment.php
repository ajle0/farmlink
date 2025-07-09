<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Model class for about table
 */
class Transaction_payment extends PS_Model {

    /**
     * Constructs the required data
     */
    function __construct()
    {
        parent::__construct( 'rt_payment_transaction_logs', 'id', 'pyt' );
    }

    /**
     * Implement the where clause
     *
     * @param      array  $conds  The conds
     */
    function custom_conds( $conds = array())
    {
        // id condition
        if ( isset( $conds['id'] )) {
            $this->db->where( 'id', $conds['id'] );
        }

        // transactions_header_id condition
        if ( isset( $conds['transactions_header_id'] )) {
            $this->db->where( 'transactions_header_id', $conds['transactions_header_id'] );
        }

        // shop_id condition
        if ( isset( $conds['shop_id'] )) {
            $this->db->where( 'shop_id', $conds['shop_id'] );
        }

        // charge_id condition
        if ( isset( $conds['charge_id'] )) {
            $this->db->where( 'charge_id', $conds['charge_id'] );
        }

        // txn_id condition
        if ( isset( $conds['txn_id'] )) {
            $this->db->where( 'txn_id', $conds['txn_id'] );
        }

        // refund_id condition
        if ( isset( $conds['refund_id'] )) {
            $this->db->where( 'refund_id', $conds['refund_id'] );
        }

        // amount condition
        if ( isset( $conds['amount'] )) {
            $this->db->where( 'amount', $conds['amount'] );
        }

        // refund_amount condition
        if ( isset( $conds['refund_amount'] )) {
            $this->db->where( 'refund_amount', $conds['refund_amount'] );
        }

        // payment_method condition
        if ( isset( $conds['payment_method'] )) {
            $this->db->where( 'payment_method', $conds['payment_method'] );
        }

        // payment_status condition
        if ( isset( $conds['payment_status'] )) {
            $this->db->where( 'payment_status', $conds['payment_status'] );
        }

        // added_user_id condition
        if ( isset( $conds['added_user_id'] )) {
            $this->db->where( 'added_user_id', $conds['added_user_id'] );
        }

        if ( isset( $conds['searchterm'] ) || isset( $conds['date'] )) {


            $dates = $conds['date'];
            if ($dates != "") {
                $vardate = explode('-',$dates,2);

                $temp_mindate = $vardate[0];
                $temp_maxdate = $vardate[1];

                $temp_startdate = new DateTime($temp_mindate);
                $mindate = $temp_startdate->format('Y-m-d');

                $temp_enddate = new DateTime($temp_maxdate);
                $maxdate = $temp_enddate->format('Y-m-d');
            } else {
                $mindate = "";
                $maxdate = "";
            }

            if ($conds['search_term'] == "" && $mindate != "" && $maxdate != "") {
                //got 2dates
                if ($mindate == $maxdate ) {

                    $this->db->where("added_date BETWEEN DATE('".$mindate."' - INTERVAL 1 DAY) AND DATE('". $maxdate."' + INTERVAL 1 DAY)");

                } else {

                    $today_date = date('Y-m-d');
                    if($today_date == $maxdate) {
                        $current_time = date('H:i:s');
                        $maxdate = $maxdate . " ". $current_time;
                    }

                    $this->db->where( 'date(added_date) >=', $mindate );
                    $this->db->where( 'date(added_date) <=', $maxdate );

                }
                $this->db->group_start();
                $this->db->or_like( 'trans_code', $conds['search_term'] );
                $this->db->group_end();
            } else if ($conds['search_term'] != "" && $mindate != "" && $maxdate != "") {
                if ($mindate == $maxdate ) {

                    $this->db->where("added_date BETWEEN DATE('".$mindate."' - INTERVAL 1 DAY) AND DATE('". $maxdate."' + INTERVAL 1 DAY)");

                } else {

                    $today_date = date('Y-m-d');
                    if($today_date == $maxdate) {
                        $current_time = date('H:i:s');
                        $maxdate = $maxdate . " ". $current_time;
                    }

                    $this->db->where( 'date(added_date) >=', $mindate );
                    $this->db->where( 'date(added_date) <=', $maxdate );

                }
                $this->db->group_start();
                $this->db->or_like( 'trans_code', $conds['search_term'] );
                $this->db->group_end();
            } else {
                //only name
                $this->db->group_start();
                $this->db->or_like( 'trans_code', $conds['search_term'] );
                $this->db->group_end();

            }


        }

        $this->db->order_by( 'added_date', 'desc' );


    }
}