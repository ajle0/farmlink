<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Model class for mobile config table
 */
class Mobile_setting extends PS_Model {

	/**
	 * Constructs the required data
	 */
	function __construct() 
	{
		parent::__construct( 'rt_app_settings', 'id', 'mb1' );
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
	}
}