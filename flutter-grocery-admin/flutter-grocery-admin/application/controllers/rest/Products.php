<?php
require_once( APPPATH .'libraries/REST_Controller.php' );

/**
 * REST API for News
 */
class Products extends API_Controller
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
				$conds['keyword']   = $this->post('searchterm');
			}

			if($this->post('cat_id') != "") {
				$conds['cat_id']   = $this->post('cat_id');
			}

			if($this->post('sub_cat_id') != "") {
				$conds['sub_cat_id']   = $this->post('sub_cat_id');
			}

			if($this->post('is_featured') != "") {
				$conds['is_featured']   = $this->post('is_featured');
			}

			if($this->post('is_discount') != "") {
				$conds['is_discount']   = $this->post('is_discount');
			}

			if($this->post('is_available') != "") {
				$conds['is_available']   = $this->post('is_available');
			}			

			if($this->post('min_price') != "") {
				$conds['min_price']   = $this->post('min_price');
			}

			if($this->post('max_price') != "") {
				$conds['max_price']   = $this->post('max_price');
			}


			if($this->post('rating_value') != "") {
				$conds['rating_value']   = $this->post('rating_value');
			}

			if($this->post('shop_id') != "") {
				$conds['shop_id']   = $this->post('shop_id');
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

		// convert customize product object
		$this->ps_adapter->convert_product( $obj );
	}

	/**
	 * Override get_get method to ensure category filtering is applied
	 */
	public function get_get()
	{
		header('Content-Type: application/json');
		
		// Get category ID from GET parameters
		$cat_id = $this->get('cat_id');
		
		// If cat_id is present, use our search_get logic
		if ($cat_id && !empty($cat_id)) {
			log_message('debug', 'Products::get_get - cat_id found, redirecting to search_get logic');
			
			// Get limit & offset
			$limit = $this->get('limit');
			$offset = $this->get('offset');
			
			// Build conditions
			$conds = array();
			$conds['cat_id'] = $cat_id;
			
			if ($limit) {
				$conds['limit'] = $limit;
			}
			if ($offset) {
				$conds['offset'] = $offset;
			}

			log_message('debug', 'Products::get_get conditions: ' . print_r($conds, true));

			$products = $this->Product->get_all_by($conds, $limit, $offset)->result();
			$this->convert_objects($products);
			$this->custom_response(true, $products);
			return;
		}
		
		// Otherwise, call parent method
		parent::get_get();
	}

	/**
	 * API endpoint for all products (GET)
	 */
	public function all_get()
	{
		// Fetch all active products
		$products = $this->Product->get_all();
		$product_list = array();
		foreach ($products->result() as $product) {
			$this->convert_object($product);
			$product_list[] = $product;
		}
		$this->response([
			'status' => true,
			'data' => $product_list
		], 200);
	}

	/**
	 * API endpoint for searching products (POST)
	 */
	public function search_post()
	{
		header('Content-Type: application/json');
		try {
			$limit = $this->post('limit');
			$offset = $this->post('offset');
			$conds = $this->post(); // Get all POST data

			// PATCH: Ensure cat_id is set in $conds if present in POST
			if (isset($conds['cat_id']) && !empty($conds['cat_id'])) {
				$conds['cat_id'] = $conds['cat_id'];
			} else {
				unset($conds['cat_id']);
			}

			log_message('debug', 'Products::search_post conditions: ' . print_r($conds, true));

			$products = $this->Product->get_all_by($conds, $limit, $offset)->result();
			$this->convert_objects($products);
			$this->custom_response(true, $products);
		} catch (Exception $e) {
			$this->custom_response(false, [], $e->getMessage());
		}
	}

	/**
	 * API endpoint for searching products (GET)
	 */
	public function search_get()
	{
		header('Content-Type: application/json');
		try {
			// Handle URL parameters like /limit/30/offset/0/cat_id/VALUE
			$limit = $this->uri->segment(5); // rest/products/search/api_key/KEY/limit/VALUE
			$offset = $this->uri->segment(7); // rest/products/search/api_key/KEY/limit/VALUE/offset/VALUE
			$cat_id = $this->uri->segment(9); // rest/products/search/api_key/KEY/limit/VALUE/offset/VALUE/cat_id/VALUE
			
			// Get all GET parameters
			$conds = $this->get();
			
			// Add URL parameters to conditions
			if ($limit) {
				$conds['limit'] = $limit;
			}
			if ($offset) {
				$conds['offset'] = $offset;
			}
			if ($cat_id) {
				$conds['cat_id'] = $cat_id;
			}

			log_message('debug', 'Products::search_get URL segments: ' . print_r($this->uri->segments, true));
			log_message('debug', 'Products::search_get conditions: ' . print_r($conds, true));

			$products = $this->Product->get_all_by($conds, $limit, $offset)->result();
			$this->convert_objects($products);
			$this->custom_response(true, $products);
		} catch (Exception $e) {
			log_message('error', 'Products::search_get exception: ' . $e->getMessage());
			$this->custom_response(false, [], $e->getMessage());
		}
	}

	/**
	 * Debug remap to catch all method calls and log them
	 */
	public function _remap($method, $params = array())
	{
		$http_method = strtolower($_SERVER['REQUEST_METHOD']);
		$full_url = $_SERVER['REQUEST_URI'];
		$ci_method = $method . '_' . $http_method;
		
		log_message('debug', 'Products::_remap - Method: ' . $method . ', HTTP: ' . $http_method . ', Full URL: ' . $full_url . ', CI Method: ' . $ci_method);
		
		if (method_exists($this, $ci_method)) {
			log_message('debug', 'Products::_remap - Calling method: ' . $ci_method);
			call_user_func_array(array($this, $ci_method), $params);
		} else {
			log_message('error', 'Products::_remap - Method not found: ' . $ci_method);
			$this->response(['status' => false, 'error' => 'Unknown method: ' . $ci_method], 404);
		}
	}
}