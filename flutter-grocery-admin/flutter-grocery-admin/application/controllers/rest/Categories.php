<?php
require_once( APPPATH .'libraries/REST_Controller.php' );

/**
 * REST API for News
 */
class Categories extends API_Controller
{

	/**
	 * Constructs Parent Constructor
	 */
	function __construct()
	{
		parent::__construct( 'Category' );
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

			// get default setting for GET_ALL_CATEGORIES
			$setting = $this->Api->get_one_by( array( 'api_constant' => "GET_ALL_CATEGORIES" ));

			$conds['order_by'] = 1;
			$conds['order_by_field'] = 'added_date'; // safe default
			$conds['order_by_type'] = 'desc';        // safe default
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

		// convert customize category object
		$this->ps_adapter->convert_category( $obj );
	}

	/**
	 * API endpoint for all categories (GET)
	 */
	public function all_get()
	{
		// Fetch all active categories
		$categories = $this->Category->get_all();
		$category_list = array();
		foreach ($categories->result() as $category) {
			$this->convert_object($category);
			$category_list[] = $category;
		}
		$this->response([
			'status' => true,
			'data' => $category_list
		], 200);
	}

	/**
	 * API endpoint for search categories (GET)
	 */
	public function search_cat_get()
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

		// Fetch categories
		$categories = $this->Category->get_all($conds);
		$category_list = array();
		
		foreach ($categories->result() as $category) {
			$this->convert_object($category);
			$category_list[] = $category;
		}
		
		$this->response([
			'status' => true,
			'data' => $category_list
		], 200);
	}

	/**
	 * API endpoint for search categories (POST)
	 */
	public function search_cat_post()
	{
		try {
			// Set content type to JSON to prevent HTML error pages
			header('Content-Type: application/json');
			
			// Debug logging
			log_message('debug', 'Categories::search_cat_post called');
			
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

			log_message('debug', 'Categories::search_cat_post conditions: ' . json_encode($conds));

			// Fetch categories
			$categories = $this->Category->get_all($conds);
			log_message('debug', 'Categories::search_cat_post categories result: ' . ($categories ? 'found' : 'null'));
			
			$category_list = array();
			
			if ($categories && $categories->result()) {
				foreach ($categories->result() as $category) {
					$this->convert_object($category);
					$category_list[] = $category;
				}
			}
			
			log_message('debug', 'Categories::search_cat_post returning ' . count($category_list) . ' categories');
			$this->response([
				'status' => true,
				'data' => $category_list
			], 200);
		} catch (Exception $e) {
			log_message('error', 'Categories::search_cat_post exception: ' . $e->getMessage());
			$this->response([
				'status' => false,
				'error' => $e->getMessage()
			], 500);
		}
	}
}