<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Model class for category table
 */
class Schedule extends PS_Model {

	/**
	 * Constructs the required data
	 */
	function __construct() 
	{
		parent::__construct( 'rt_shop_schedule', 'id', 'sch' );
	}

	/**
	 * Implement the where clause
	 *
	 * @param      array  $conds  The conds
	 */
	function custom_conds( $conds = array())
	{

		// days_of_week condition
		if ( isset( $conds['days_of_week'] )) {
			$this->db->where( 'days_of_week', $conds['days_of_week'] );
		}

		// open_hour condition
		if ( isset( $conds['open_hour'] )) {
			$this->db->where( 'open_hour', $conds['open_hour'] );
		}

		// open_hour condition
		if ( isset( $conds['open_hour'] )) {
			$this->db->where( 'open_hour', $conds['open_hour'] );
		}

		// close_hour condition
		if ( isset( $conds['close_hour'] )) {
			$this->db->where( 'close_hour', $conds['close_hour'] );
		}

		// is_open condition
		if ( isset( $conds['is_open'] )) {
			$this->db->where( 'is_open', $conds['is_open'] );
		}

		// shop_id condition
		if ( isset( $conds['shop_id'] )) {
			$this->db->where( 'shop_id', $conds['shop_id'] );
		}


		$this->db->order_by( 'added_date', 'desc' );
	}
}