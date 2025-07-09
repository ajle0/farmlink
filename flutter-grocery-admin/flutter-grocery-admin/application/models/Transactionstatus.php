<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Model class for Transactionstatus table
 */
class Transactionstatus extends PS_Model {

	/**
	 * Constructs the required data
	 */
	function __construct() 
	{
		parent::__construct( 'rt_transactions_status', 'id', 'trans_sts' );
	}

	/**
	 * Implement the where clause
	 *
	 * @param      array  $conds  The conds
	 */
	function custom_conds( $conds = array())
	{
		// transaction status id condition
		if ( isset( $conds['id'] )) {
			$this->db->where( 'id', $conds['id'] );
		}

		//title
		if ( isset( $conds['title'] )) {
			$this->db->where( 'title', $conds['title'] );
		}

		//ordering
		if ( isset( $conds['ordering'] )) {
			$this->db->where( 'ordering', $conds['ordering'] );
		}

		// color value
		if ( isset( $conds['color_value'] )) {
			$this->db->where( 'color_value', $conds['color_value'] );
		}

		// start_stage
		if ( isset( $conds['start_stage'] )) {
			$this->db->where( 'start_stage', $conds['start_stage'] );
		}

		// final_stage
		if ( isset( $conds['final_stage'] )) {
			$this->db->where( 'final_stage', $conds['final_stage'] );
		}

        // is_optional
        if ( isset( $conds['is_optional'] )) {
            $this->db->where( 'is_optional', $conds['is_optional'] );
        }

        // is_refundable
        if ( isset( $conds['is_refundable'] )) {
            $this->db->where( 'is_refundable', $conds['is_refundable'] );
        }

		// searchterm
		if ( isset( $conds['searchterm'] )) {
			$this->db->group_start();
			$this->db->like( 'title', $conds['searchterm'] );
			$this->db->or_like( 'title', $conds['searchterm'] );
			$this->db->group_end();
		}

		if ( isset( $conds['optional'] ) &&  isset( $conds['start'] ) && isset( $conds['final'] )) {
			// $this->db->group_start();
			$this->db->where( 'is_optional', $conds['optional'] );
			$this->db->or_where( 'start_stage', $conds['start'] );
			$this->db->or_where( 'final_stage', $conds['final'] );
			// $this->db->group_end();
			
		}

		$this->db->order_by("ordering", "asc");

	}
}