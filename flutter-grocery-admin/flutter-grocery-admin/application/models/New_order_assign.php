<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Model class for category table
 */
class New_order_assign extends PS_Model {

	/**
	 * Constructs the required data
	 */
	function __construct() 
	{
		parent::__construct( 'rt_new_order_assign_log', 'id', 'ord_ass' );
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

        // delivery_boy_id condition
		if ( isset( $conds['delivery_boy_id'] )) {
			$this->db->where( 'delivery_boy_id', $conds['delivery_boy_id'] );
		}

        // trans_header_id condition
		if ( isset( $conds['trans_header_id'] )) {
			$this->db->where( 'trans_header_id', $conds['trans_header_id'] );
		}
	}
}