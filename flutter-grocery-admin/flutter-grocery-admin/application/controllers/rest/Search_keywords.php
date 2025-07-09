<?php
require_once( APPPATH .'libraries/REST_Controller.php' );

/**
 * REST API for News
 */
class Search_keywords extends API_Controller
{

	/**
	 * Constructs Parent Constructor
	 */
	function __construct()
	{
	parent::__construct( 'Product' );
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

			// get default setting for GET_ALL_PRODUCTS
			$setting = $this->Api->get_one_by( array( 'api_constant' => "GET_ALL_PRODUCTS" ));

		}

		if ( $this->is_search ) {

			//$setting = $this->Api->get_one_by( array( 'api_constant' => SEARCH_WALLPAPERS ));

			if($this->post('searchterm') != "") {
				$conds['searchterm']   = $this->post('searchterm');
			}


			$conds['prd_search'] = 1;
			$conds['order_by'] = 1;
			$conds['order_by_field']    = $this->post('order_by');
			$conds['order_by_type']     = $this->post('order_type');
				
		}

		

		return $conds;
	}

	/**
	 * Convert Object
	 */
	function convert_object( &$obj )
	{
		// call parent convert object
		parent::convert_object( $obj );

		// foreach($obj->categories as $cat){
		// 	print_r($cat);die;
			
		// }

		// convert customize product object
		$this->ps_adapter->convert_product_shop_category_by_keyword( $obj );
	}
}