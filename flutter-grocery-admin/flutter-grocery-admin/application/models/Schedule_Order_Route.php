<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Model class for category table
 */
class Schedule_Order_Route extends PS_Model {

	/**
	 * Constructs the required data
	 */
	function __construct() 
	{
		parent::__construct( 'rt_schedule_order_routes', 'id', 'sch_rou' );
	}

	/**
	 * Implement the where clause
	 *
	 * @param      array  $conds  The conds
	 */
	function custom_conds( $conds = array())
	{
		
		// id 
		if ( isset( $conds['id'] )) {
			$this->db->where( 'id', $conds['id'] );
		}

		// route id 
		if ( isset( $conds['route_id'] )) {
			$this->db->where( 'route_id', $conds['route_id'] );
		}

		// schedule_header_id
		if ( isset( $conds['schedule_header_id'] )) {
			$this->db->where( 'schedule_header_id', $conds['schedule_header_id'] );
		}

	}


	 public function get_discounts( $conds = array() )
     {
     	$this->db->where( 'shop_id', $conds['shop_id']);

     	$this->db->order_by('is_discount',DESC);
        return $this->db->get("rt_products");
     }
	 
}