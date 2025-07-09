<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Model class for shop table
 */
class Shop extends PS_Model {

	/**
	 * Constructs the required data
	 */
	function __construct() 
	{
		parent::__construct( 'rt_shops', 'id', 'shop' );
	}

	/**
	 * Implement the where clause
	 *
	 * @param      array  $conds  The conds
	 */
	function custom_conds( $conds = array())
	{
		// default where clause
		if ( isset( $conds['no_publish_filter'] )) {
			$this->db->where( 'status', $conds['no_publish_filter'] );
		} else {
			$this->db->where('status',1);
		}

		// order by
		if ( isset( $conds['order_by_field']) && isset( $conds['order_by_type'])) {
			
			$order_by_field = $conds['order_by_field'];
			$order_by_type = $conds['order_by_type'];
			
			$this->db->order_by( 'rt_shops.'.$order_by_field, $order_by_type);
		}
	
		// id condition
		if ( isset( $conds['id'] )) {
			$this->db->where( 'id', $conds['id'] );
		}

		// is_featured condition
		if ( isset( $conds['is_featured'] )) {
			$this->db->where( 'is_featured', $conds['is_featured'] );
		}

		// shop_id condition
		if ( isset( $conds['name'] )) {
			$this->db->where( 'name', $conds['name'] );
		}


		// // lat condition
		// if ( isset( $conds['lat'] )) {
		// 	$this->db->where( 'lat', $conds['lat'] );
		// }

		// // lng condition
		// if ( isset( $conds['lng'] )) {
		// 	$this->db->where( 'lng', $conds['lng'] );
		// }

		// checkout_with_whatsapp condition
		if ( isset( $conds['checkout_with_whatsapp'] )) {
			$this->db->where( 'checkout_with_whatsapp', $conds['checkout_with_whatsapp'] );
		}

		// checkout_with_email condition
		if ( isset( $conds['checkout_with_email'] )) {
			$this->db->where( 'checkout_with_email', $conds['checkout_with_email'] );
		}

		// transaction_on condition
		if ( isset( $conds['transaction_on'] )) {
			$this->db->where( 'transaction_on', $conds['transaction_on'] );
		}

		// transaction_off condition
		if ( isset( $conds['transaction_off'] )) {
			$this->db->where( 'transaction_off', $conds['transaction_off'] );
		}


		// searchterm
		if ( isset( $conds['searchterm'] )) {
			$this->db->group_start();
			$this->db->like( 'name', $conds['searchterm'] );
			$this->db->or_like( 'name', $conds['searchterm'] );
			$this->db->group_end();
		}

		if ( isset( $conds['shop_ids'] )) {

            $this->db->where_in( 'id', $conds['shop_ids'] );
        }

		//  search name and description by keyword
		if ( isset( $conds['keyword'] )) {
			$this->db->like( 'name', $conds['keyword'] );
			$this->db->or_like( 'description', $conds['keyword'] );
		}

		if (isset($conds['order_type']) && $conds['order_type'] != "") {
			$this->db->order_by( 'added_date', $conds['order_type'] );
		} else {
			$this->db->order_by( 'added_date', 'desc' );
		}
	}
	
}
?>