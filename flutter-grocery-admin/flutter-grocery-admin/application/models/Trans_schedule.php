<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Model class for Trans_schedule table
 */
class Trans_schedule extends PS_Model {

	/**
	 * Constructs the required data
	 */
	function __construct() 
	{
		parent::__construct( 'rt_trans_schedules', 'id', 'trans_sch' );
	}

	/**
	 * Implement the where clause
	 *
	 * @param      array  $conds  The conds
	 */
	function custom_conds( $conds = array())
	{
		// about_id condition
		if ( isset( $conds['id'] )) {
			$this->db->where( 'id', $conds['id'] );
		}

		// route_id condition
		if ( isset( $conds['route_id'] )) {
			$this->db->where( 'route_id', $conds['route_id'] );
		}

		// schedule_header_id condition
		if ( isset( $conds['schedule_header_id'] )) {
			$this->db->where( 'schedule_header_id', $conds['schedule_header_id'] );
		}

        // transactions_header_id condition
        if ( isset( $conds['transactions_header_id'] )) {
            $this->db->where( 'transactions_header_id', $conds['transactions_header_id'] );
        }

        // added_date condition
        if ( isset( $conds['added_date'] )) {
            $this->db->where( 'added_date', $conds['added_date'] );
        }
		
	}
}