<?php
require_once( APPPATH .'libraries/REST_Controller.php' );

/**
 * REST API for About
 */
class Appinfo extends REST_Controller
{
	/**
	 * Constructs Parent Constructor
	 */
	function __construct()
	{
		parent::__construct();
	}

	/**
	 * API endpoint for get_delete_history
	 */
	public function delete_history_get()
	{
		$this->response([
			'status' => true,
			'message' => 'delete_history endpoint is working!'
		], 200);
	}

}