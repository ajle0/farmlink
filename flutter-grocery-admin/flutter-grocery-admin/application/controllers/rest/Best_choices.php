<?php
require_once( APPPATH .'libraries/REST_Controller.php' );

/**
 * REST API for Collections
 */
class Best_choices extends API_Controller
{

	/**
	 * Constructs Parent Constructor
	 */
	function __construct()
	{
		parent::__construct( 'Best_choice' );
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
	 * API endpoint for getting best choices (GET)
	 */
	public function get_get()
	{
		try {
			// Set content type to JSON to prevent HTML error pages
			header('Content-Type: application/json');
			
			// Debug logging
			log_message('debug', 'Best_choices::get_get called');
			
			// Get conditions
			$conds = $this->default_conds();
			log_message('debug', 'Best_choices::get_get conditions: ' . json_encode($conds));

			// Fetch best choices
			$best_choices = $this->Best_choice->get_all($conds);
			log_message('debug', 'Best_choices::get_get result: ' . ($best_choices ? 'found' : 'null'));
			
			$best_choice_list = array();
			
			if ($best_choices && $best_choices->result()) {
				foreach ($best_choices->result() as $best_choice) {
					$this->convert_object($best_choice);
					$best_choice_list[] = $best_choice;
				}
			}
			
			log_message('debug', 'Best_choices::get_get returning ' . count($best_choice_list) . ' best choices');
			$this->response([
				'status' => true,
				'data' => $best_choice_list
			], 200);
		} catch (Exception $e) {
			log_message('error', 'Best_choices::get_get exception: ' . $e->getMessage());
			$this->response([
				'status' => false,
				'error' => $e->getMessage()
			], 500);
		}
	}

}