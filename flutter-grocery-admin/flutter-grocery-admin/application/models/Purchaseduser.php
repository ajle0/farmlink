<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Model class for product table
 */
class Purchaseduser extends PS_Model {

	/**
	 * Constructs the required data
	 */
	function __construct() 
	{
		parent::__construct( 'core_users', 'user_id', 'usr' );
	}

	/**
	 * Implement the where clause
	 *
	 * @param      array  $conds  The conds
	 */
	function custom_conds( $conds = array())
	{
		// default where clause
		if ( !isset( $conds['no_publish_filter'] )) {
			$this->db->where( 'status', 1 );
		}
		
		// product user_id condition
		if ( isset( $conds['user_id'] )) {
			$this->db->where( 'user_id', $conds['user_id'] );	
		}

		// shop id condition
		// if ( isset( $conds['shop_id'] )) {
		// 	$this->db->where( 'shop_id', $conds['shop_id'] );	
		// }

		$this->db->order_by( 'added_date', 'desc' );
	}



}