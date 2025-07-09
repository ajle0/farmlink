<?php
require_once( APPPATH .'libraries/REST_Controller.php' );

/**
 * REST API for Collections
 */
class Collections extends API_Controller
{

	/**
	 * Constructs Parent Constructor
	 */
	function __construct()
	{
		parent::__construct( 'Collection' );
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
			$conds['collection_get'] = 1;
			$conds['order_by'] = 1;
			$conds['order_by_field'] = "added_date";
			$conds['order_by_type'] = "desc";
			

			if($this->get('product_limit') != "") {
				$conds['product_limit'] = $this->get('product_limit');
			}

			
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
		
		// convert customize category object
		$this->ps_adapter->convert_collection( $obj );
	}

	/**
	 * API endpoint for get collections (GET)
	 */
	public function get_get()
	{
		// Get limit and offset from URL parameters
		$limit = $this->get('limit') ? $this->get('limit') : 10;
		$offset = $this->get('offset') ? $this->get('offset') : 0;
		$shop_id = $this->get('shop_id') ? $this->get('shop_id') : null;

		// Set conditions
		$conds = array();
		$conds['limit'] = $limit;
		$conds['offset'] = $offset;
		
		if ($shop_id) {
			$conds['shop_id'] = $shop_id;
		}

		// Fetch collections
		$collections = $this->Collection->get_all($conds);
		$collection_list = array();
		
		foreach ($collections->result() as $collection) {
			$this->convert_object($collection);
			$collection_list[] = $collection;
		}

		$this->response([
			'status' => true,
			'data' => $collection_list
		], 200);
	}

}