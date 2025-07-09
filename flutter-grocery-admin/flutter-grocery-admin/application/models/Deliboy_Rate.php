<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Model class for touch table
 */
class Deliboy_Rate extends PS_Model {

    /**
     * Constructs the required data
     */
    function __construct()
    {
        parent::__construct( 'rt_deliboy_ratings', 'id', 'deli_rat' );
    }

    /**
     * Implement the where clause
     *
     * @param      array  $conds  The conds
     */
    function custom_conds( $conds = array())
    {
        // rating_id condition
        if ( isset( $conds['id'] )) {
            $this->db->where( 'id', $conds['id'] );
        }

        // transactions_header_id condition
        if ( isset( $conds['transactions_header_id'] )) {
            $this->db->where( 'transactions_header_id', $conds['transactions_header_id'] );
        }

        // from_user_id condition
        if ( isset( $conds['from_user_id'] )) {
            $this->db->where( 'from_user_id', $conds['from_user_id'] );
        }

        // to_user_id condition
        if ( isset( $conds['to_user_id'] )) {
            $this->db->where( 'to_user_id', $conds['to_user_id'] );
        }

        // rating condition
        if ( isset( $conds['rating'] )) {
            $this->db->where( 'rating', $conds['rating'] );
        }

        // title condition
        if ( isset( $conds['title'] )) {
            $this->db->where( 'title', $conds['title'] );
        }

        // description condition
        if ( isset( $conds['description'] )) {
            $this->db->where( 'description', $conds['description'] );
        }

        $this->db->order_by( 'added_date', 'desc' );
    }
}