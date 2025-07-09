<?php
require_once( APPPATH .'libraries/REST_Controller.php' );

/**
 * REST API for News
 */
class Shops extends API_Controller
{

	/**
	 * Constructs Parent Constructor
	 */
	function __construct()
	{
		parent::__construct( 'Shop' );
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
			// $setting = $this->Api->get_one_by( array( 'api_constant' => GET_ALL_CATEGORIES ));

			$conds['order_by'] = 1;
			$conds['order_by_field'] = 'added_date'; // safe default
			$conds['order_by_type'] = 'desc';        // safe default
		}

		if ( $this->is_search ) {
			
			$this->search_shop_post();

		}

		// print_r($conds); die;
		return $conds;
	}



	/**
	 * Convert Object
	 */
	function convert_object( &$obj )
	{
		// call parent convert object
		parent::convert_object( $obj );

		// convert customize shop object
		$this->ps_adapter->convert_shop( $obj );
	}

	/**
	 * API endpoint for all shops (GET)
	 */
	public function all_get()
	{
		// Fetch all active shops
		$shops = $this->Shop->get_all();
		$shop_list = array();
		foreach ($shops->result() as $shop) {
			$this->convert_object($shop);
			$shop_list[] = $shop;
		}
		$this->response([
			'status' => true,
			'data' => $shop_list
		], 200);
	}

	/**
	 * API endpoint for get individual shop (GET)
	 */
	public function get_get()
	{
		// Get shop ID from URL parameters
		$shop_id = $this->get('id');
		
		if (!$shop_id) {
			$this->response([
				'status' => false,
				'message' => 'Shop ID is required'
			], 400);
			return;
		}

		// Fetch shop by ID
		$shop = $this->Shop->get_one($shop_id);
		
		if ($shop) {
			$this->convert_object($shop);
			$this->response([
				'status' => true,
				'data' => $shop
			], 200);
		} else {
			$this->response([
				'status' => false,
				'message' => 'Shop not found'
			], 404);
		}
	}

	/**
	 * API endpoint for searching shops (GET)
	 */
	public function search_get()
	{
		try {
			// Set content type to JSON to prevent HTML error pages
			header('Content-Type: application/json');
			
			// Debug logging
			log_message('debug', 'Shops::search_get called');
			
			// Get limit and offset from URL parameters
			$limit = $this->get('limit') ? $this->get('limit') : 10;
			$offset = $this->get('offset') ? $this->get('offset') : 0;

			// Set conditions
			$conds = array();
			$conds['limit'] = $limit;
			$conds['offset'] = $offset;
			$conds['order_by'] = 1;
			$conds['order_by_field'] = 'added_date';
			$conds['order_by_type'] = 'desc';

			log_message('debug', 'Shops::search_get conditions: ' . json_encode($conds));

			// Fetch shops
			$shops = $this->Shop->get_all($conds);
			log_message('debug', 'Shops::search_get result: ' . ($shops ? 'found' : 'null'));
			
			$shop_list = array();
			
			if ($shops && $shops->result()) {
				foreach ($shops->result() as $shop) {
					$this->convert_object($shop);
					$shop_list[] = $shop;
				}
			}
			
			log_message('debug', 'Shops::search_get returning ' . count($shop_list) . ' shops');
			$this->response([
				'status' => true,
				'data' => $shop_list
			], 200);
		} catch (Exception $e) {
			log_message('error', 'Shops::search_get exception: ' . $e->getMessage());
			$this->response([
				'status' => false,
				'error' => $e->getMessage()
			], 500);
		}
	}

}