<?php
require_once( APPPATH .'libraries/REST_Controller.php' );

/**
 * REST API for News
 */
class Subcategories extends API_Controller
{

	/**
	 * Constructs Parent Constructor
	 */
	function __construct()
	{
		parent::__construct( 'Subcategory' );
	}

	/**
	 * Default Query for API
	 * @return [type] [description]
	 */
	function default_conds()
	{
		$conds = array();

		if ( $this->is_get ) {
		// if is get record using GET method

			// get default setting for GET_ALL_SUBCATEGORIES
			$setting = $this->Api->get_one_by( array( 'api_constant' => "GET_ALL_SUBCATEGORIES" ));

			$conds['order_by'] = 1;
			$conds['order_by_field'] = $setting->order_by_field;
			$conds['order_by_type'] = $setting->order_by_type;
		}

		if ( $this->is_search ) {
			
			if($this->post('searchterm') != "") {
				$conds['keyword'] = $this->post('searchterm');
			}

			$conds['order_by']       = $this->post('order_by');
			
			if($conds['order_by'] == "added_date") {

				$conds['order_by_field'] = "added_date";
				$conds['order_by_type'] = $this->post('order_type');
				
			} else if($conds['order_by'] == "touch_count") {

				$conds['order_by_field'] = "touch_count";
				$conds['order_by_type'] = $this->post('order_type');

			}

		}
        // print_r($conds);die;

		return $conds;
	}

	/**
	 * Convert Object
	 */
	function convert_object( &$obj )
	{
		// call parent convert object
		parent::convert_object( $obj );

		// convert customize sub category object
		$this->ps_adapter->convert_sub_category( $obj );
	}
}