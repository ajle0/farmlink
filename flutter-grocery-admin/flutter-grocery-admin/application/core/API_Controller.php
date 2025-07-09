<?php
defined('BASEPATH') or exit('No direct script access allowed');

/**
 * Main Controller for API classes
 */
class API_Controller extends REST_Controller
{
	// model to access database
	protected $model;

	// validation rule for new record
	protected $create_validation_rules;

	// validation rule for update record
	protected $update_validation_rules;

	// validation rule for delete record
	protected $delete_validation_rules;

	// is adding record?
	protected $is_add;

	// is updating record?
	protected $is_update;

	// is deleting record?
	protected $is_delete;

	// is get record using GET method?
	protected $is_get;

	// is search record using GET method?
	protected $is_search;

	// login user id API parameter key name
	protected $login_user_key;

	// login user id
	protected $login_user_id;

	// if API allowed zero login user id,
	protected $is_login_user_nullable;

	// default value to ignore user id
	protected $ignore_user_id;

	/**
	 * construct the parent 
	 */
	function __construct($model, $is_login_user_nullable = false)
	{
		// header('Access-Control-Allow-Origin: *');
		// header("Access-Control-Allow-Methods: GET, POST, OPTIONS, PUT, DELETE");

		parent::__construct();

		// set the model object
		$this->model = $this->{$model};

		// load security library
		$this->load->library('PS_Security');

		// load the adapter library
		$this->load->library('PS_Adapter');

		// set the login user nullable
		$this->is_login_user_nullable = $is_login_user_nullable;

		// login user id key
		$this->login_user_key = "login_user_id";

		// default value to ignore user id for API
		$this->ignore_user_id = "nologinuser";

		if ($this->is_logged_in()) {
			// if login user id is existed, pass the id to the adapter

			$this->login_user_id = $this->get_login_user_id();

			if (!$this->User->is_exist($this->login_user_id) && !$this->is_login_user_nullable) {
				// if login user id not existed in system,

				$this->error_response(get_msg('invalid_login_user_id'), 400);
			}

			$this->ps_adapter->set_login_user_id($this->login_user_id);
		}

		// load the mail library
		$this->load->library('PS_Mail');

		if (!$this->is_valid_api_key()) {
			// if invalid api key

			$this->response(array(
				'status' => 'error',
				'message' => get_msg('invalid_api_key')
			), 404);
		}

		// default validation rules
		$this->default_validation_rules();
	}

	/**
	 * Determines if logged in.
	 *
	 * @return     boolean  True if logged in, False otherwise.
	 */
	function is_logged_in()
	{
		// it is login user if the GET login_user_id is not null and default key
		// it is login user if the POST login_user_id is not null
		// it is login user if the PUT login_user_id is not null
		return ($this->get($this->login_user_key) != null && $this->get($this->login_user_key) != $this->ignore_user_id) ||
			($this->post($this->login_user_key) != null) ||
			($this->put($this->login_user_key) != null);
	}

	/**
	 * Gets the login user identifier.
	 */
	function get_login_user_id()
	{
		/**
		 * GET['login_user_id'] will create POST['user_id']
		 * POST['login_user_id'] will create POST['user_id'] and remove POST['login_user_id']
		 * PUT['login_user_id'] will create PUT['user_id'] and remove PUT['login_user_id']
		 */
		// if exist in get variable,
		if ($this->get($this->login_user_key) != null) {

			// get user id
			$login_user_id = $this->get($this->login_user_key);

			// replace user_id
			$this->_post_args['user_id'] = $this->get($this->login_user_key);

			return $this->get($this->login_user_key);
		}

		// if exist in post variable,
		if ($this->post($this->login_user_key) != null) {

			// get user id
			$login_user_id = $this->post($this->login_user_key);

			// replace user_id
			$this->_post_args['user_id'] = $this->post($this->login_user_key);
			unset($this->_post_args[$this->login_user_key]);

			return $login_user_id;
		}

		// if exist in put variable,
		if ($this->put($this->login_user_key) != null) {

			// get user id
			$login_user_id = $this->put($this->login_user_key);

			// replace user_id
			$this->_put_args['user_id'] = $this->put($this->login_user_key);
			unset($this->_put_args[$this->login_user_key]);

			return $login_user_id;
		}
	}

	/**
	 * Convert logged in user id to user_id
	 */
	function get_similar_key($actual, $similar)
	{
		if (empty(parent::post($actual)) && empty(parent::put($actual))) {
			// if actual key is not existed in POST and PUT, return similar

			return $similar;
		}

		// else, just return normal key
		return $actual;
	}

	/**
	 * Override Get variables
	 *
	 * @param      <type>  $key    The key
	 */
	function get($key = NULL, $xss_clean = true)
	{
		return $this->ps_security->clean_input(parent::get($key, $xss_clean));
	}

	/**
	 * Override Post variables
	 *
	 * @param      <type>  $key    The key
	 */
	function post($key = NULL, $xss_clean = true)
	{
		if ($key == 'user_id') {
			// if key is user_id and user_id is not in variable, get the similar key

			$key = $this->get_similar_key('user_id', $this->login_user_key);
		}

		return $this->ps_security->clean_input(parent::post($key, $xss_clean));
	}

	/**
	 * Override Put variables
	 *
	 * @param      <type>  $key    The key
	 */
	function put($key = NULL, $xss_clean = true)
	{
		if ($key == 'user_id') {
			// if key is user_id and user_id is not in variable, get the similar key

			$key = $this->get_similar_key('user_id', $this->login_user_key);
		}

		return $this->ps_security->clean_input(parent::put($key, $xss_clean));
	}

	/**
	 * Determines if valid api key.
	 *
	 * @return     boolean  True if valid api key, False otherwise.
	 */
	function is_valid_api_key()
	{
		$client_api_key = $this->get('api_key');

		if ($client_api_key == NULL) {
			// if API key is null, return false;

			return false;
		}

		$server_api_key = $this->Api_key->get_one('apikey1')->key;

		if ($client_api_key != $server_api_key) {
			// if API key is different with server api key, return false;

			return false;
		}

		return true;
	}

	/**
	 * Convert Object
	 */
	function convert_object(&$obj)
	{
		// convert added_date date string
		if (isset($obj->added_date)) {

			// added_date timestamp string
			$obj->added_date_str = ago($obj->added_date);
		}

		$temp_obj_id = $obj->id;

		$obj_id = explode('_', $temp_obj_id);

		//refund status and rating status will return at transaction header and detail objects only

		if (($obj_id[0] == "trans" && $obj_id[1] == "hdr") || ($obj_id[0] == "trans" && $obj_id[1] == "det")) {
			//refund status
			$transaction_header_id = $obj->id;
			//print_r($transaction_header_id);die;
			$trans_status_id = $this->Transactionheader->get_one($transaction_header_id)->trans_status_id;
			$payment_method = $this->Transactionheader->get_one($transaction_header_id)->payment_method;
			$refund_status = $this->Transactionstatus->get_one($trans_status_id)->is_refundable;
			$conds['transactions_header_id'] = $transaction_header_id;
			$payment_status = $this->Transaction_payment->get_one_by($conds)->payment_status;
			//print_r($payment_status);die;

			if ($payment_status == "refunded") {
				$refund_status = 2; // 2 for refunded
			}

			if ($payment_method == "COD" || $payment_method == "Pick Up" || $payment_method == "Razor" || $payment_method == "BANK" || $payment_method == "Paystack") {
				$refund_status = 0; // 0 for not refundable (due to payment method or transation status stage)
			}

			$obj->refund_status = $refund_status; // 1 for refundable

			//rating_status
			$delivery_boy_id = $this->Transactionheader->get_one($transaction_header_id)->delivery_boy_id;
			$final_stage = $this->Transactionstatus->get_one($trans_status_id)->final_stage;


			if ($final_stage == '0'  || ($delivery_boy_id == "" || $delivery_boy_id == '0')) {
				//deli boy not yet assigned and not final stage
				//not able to rate
				$obj->rating_status = 0;
			} else {
				//deli boy already assigned and reached final stage

				$conds_deli['to_user_id'] = $delivery_boy_id;
				$conds_deli['transactions_header_id'] = $transaction_header_id;
				$deli_rating_id = $this->Deliboy_Rate->get_one_by($conds_deli)->id;
				if ($deli_rating_id != "") {
					//already rated
					$obj->rating_status = 0;
				} else {
					$obj->rating_status = 1;
				}
			}
		}

		if (isset($obj->trans_status_id)) {
			$trans_status = $this->Transactionstatus->get_one($obj->trans_status_id);

			$this->ps_adapter->convert_transaction_status($trans_status);

			$obj->transaction_status = $trans_status;
		}

		if (isset($obj->shop_id)) {
			$trans_shop = $this->Shop->get_one($obj->shop_id);

			$this->ps_adapter->convert_shop($trans_shop);

			$obj->shop = $trans_shop;
		}
	}

	/**
	 * Gets the default photo.
	 *
	 * @param      <type>  $id     The identifier
	 * @param      <type>  $type   The type
	 */
	function get_default_photo($id, $type)
	{
		$default_photo = "";

		// get all images
		$img = $this->Image->get_all_by(array('img_parent_id' => $id, 'img_type' => $type))->result();

		if (count($img) > 0) {
			// if there are images for news,

			$default_photo = $img[0];
		} else {
			// if no image, return empty object

			$default_photo = $this->Image->get_empty_object();
		}

		return $default_photo;
	}

	/**
	 * Response Error
	 *
	 * @param      <type>  $msg    The message
	 */
	function error_response($msg, $code = false)
	{
		if (!$code) $code = 404;
		$this->response(array(
			'status' => 'error',
			'message' => $msg
		), $code);
	}

	/**
	 * Response Success
	 *
	 * @param      <type>  $msg    The message
	 */
	function success_response($msg, $code = false)
	{
		if (!$code) $code = 200;
		$this->response(array(
			'status' => 'success',
			'message' => $msg
		), $code);
	}

	/**
	 * Custome Response return 404 if not data found
	 *
	 * @param      <type>  $data   The data
	 */
	function custom_response($data, $offset = false, $require_convert = true)
	{
		if (empty($data)) {
			// if there is no data, return error

			$offset = $this->get('offset');

			if (empty($data) && $offset == 0) {


				$this->error_response(get_msg('record_not_found'), 404);
			} else if (empty($data) && $offset > 0) {
				$this->error_response(get_msg('record_no_pagination'), 404);
			}
		} else if ($require_convert) {
			// if there is data, return the list
			if (is_array($data)) {
				// if the data is array
				
				foreach ($data as $obj) {

					// convert object for each obj
					$this->convert_object($obj);
				}
			} else {

				$this->convert_object($data);
			}
		}

		$data = $this->ps_security->clean_output($data);

		$this->response($data);
	}


	/**
	 * Custome Response return 404 if not data found
	 *
	 * @param      <type>  $data   The data
	 */
	function custom_fail_response($data, $require_convert = true, $message = "")
	{
		if (empty($data)) {
			// if there is no data, return error

			$this->error_response(get_msg('no_record'), 500);
		} else if ($require_convert) {
			// if there is data, return the list

			if (is_array($data)) {
				// if the data is array

				foreach ($data as $obj) {

					// convert object for each obj
					//$this->convert_object( $obj );
					$obj->trans_status = $message;
					$this->ps_adapter->convert_product($obj);
				}
			} else {
				$data->trans_status = $message;
				//$this->convert_object( $data );
				$this->ps_adapter->convert_product($data);
			}
		}

		$data = $this->ps_security->clean_output($data);

		$this->response($data);
		// $this->response( array(
		// 	'status' => $message,
		// 	'data' => $data
		// ));
	}

	/**
	 * Default Validation Rules
	 */
	function default_validation_rules()
	{
		// default rules
		$rules = array(
			array(
				'field' => $this->model->primary_key,
				'rules' => 'required|callback_id_check'
			)
		);

		// set to update validation rules
		$this->update_validation_rules = $rules;

		// set to delete_validation_rules
		$this->delete_validation_rules = $rules;
	}

	/**
	 * Id Checking
	 *
	 * @param      <type>  $id     The identifier
	 *
	 * @return     <type>  ( description_of_the_return_value )
	 */
	function id_check($id, $model_name = false)
	{
		$tmp_model = $this->model;

		if ($model_name != false) {
			$tmp_model = $this->{$model_name};
		}

		if (!$tmp_model->is_exist($id)) {

			$this->form_validation->set_message('id_check', 'Invalid {field}');
			return false;
		}

		return true;
	}

	/**
	 * { function_description }
	 *
	 * @param      <type>   $conds  The conds
	 *
	 * @return     boolean  ( description_of_the_return_value )
	 */
	function is_valid($rules)
	{
		if (empty($rules)) {
			// if rules is empty, no checking is required

			return true;
		}

		// GET data
		$user_data = array_merge($this->get(), $this->post(), $this->put());

		$this->form_validation->set_data($user_data);
		$this->form_validation->set_error_delimiters('', '');
		$this->form_validation->set_rules($rules);

		if ($this->form_validation->run() == FALSE) {
			// if there is an error in validating,

			$errors = $this->form_validation->error_array();

			if (count($errors) == 1) {
				// if error count is 1, remove '\n'

				$this->error_response(trim(validation_errors()), 400);
			}

			$this->error_response(validation_errors(), 400);
		}

		return true;
	}

	/**
	 * Returns default condition like default order by
	 * @return array custom_condition_array
	 */
	function default_conds()
	{
		return array();
	}

	/**
	 * Get all or Get One
	 */
	function get_get()
	{
		log_message('debug', 'API_Controller::get_get - Called from: ' . get_class($this));
		
		// add flag for default query
		$this->is_get = true;

		// get id
		$id = $this->get('id');
		$shop_id = $this->get('shop_id');
		$is_all = $this->get('is_all');

		log_message('debug', 'API_Controller::get_get - Parameters: id=' . $id . ', shop_id=' . $shop_id . ', is_all=' . $is_all);

		if ($id) {
			// if 'id' is existed, get one record only
			$data = $this->model->get_one($id, $shop_id);

			if (isset($data->is_empty_object)) {
				// if the id is not existed in the return object, the object is empty

				$data = array();
			}

			$this->custom_response($data);
		}

		// get limit & offset
		$limit = $this->get('limit');
		$offset = $this->get('offset');

		// get search criteria
		$default_conds = $this->default_conds();
		$user_conds = $this->get();
		$conds = array_merge($default_conds, $user_conds);

		log_message('debug', 'API_Controller::get_get - Conditions: ' . print_r($conds, true));

		// Ensure 'shop_id' and 'feed_status' keys exist to prevent undefined array key warning
		if (!array_key_exists('shop_id', $conds)) {
			$conds['shop_id'] = "";
		}
		if (!array_key_exists('feed_status', $conds)) {
			$conds['feed_status'] = "";
		}

		if ($conds['shop_id'] == "" && $conds['feed_status'] == 1) {
			$conds_status['no_publish_filter'] = 0;
			$unplish_shop = $this->Shop->get_one_by($conds_status);
			$shop_id = $unplish_shop->id;
			if ($shop_id != " ") {
				$conds['check_status'] = 1;
				$conds['shop_id'] = $shop_id;
			}
		}
		if ($is_all == "" || $is_all == 0) {
			$conds['is_optional'] = 0;
		}

		if ($limit) {
			unset($conds['limit']);
		}

		if ($offset) {
			unset($conds['offset']);
		}
		unset($conds['is_all']);

		log_message('debug', 'API_Controller::get_get - Final conditions: ' . print_r($conds, true));

		if (count($conds) == 0) {
			// if 'id' is not existed, get all	

			log_message('debug', 'API_Controller::get_get - No conditions, getting all products');

			if (!empty($limit) && !empty($offset)) {
				// if limit & offset is not empty

				$data = $this->model->get_all($limit, $offset)->result();
			} else if (!empty($limit)) {
				// if limit is not empty

				$data = $this->model->get_all($limit)->result();
			} else {
				// if both are empty

				$data = $this->model->get_all()->result();
			}

			$this->custom_response($data, $offset);
		} else {
			// Ensure 'collection_get' and 'blog_get' keys exist to prevent undefined array key warning
			if (!array_key_exists('collection_get', $conds)) {
				$conds['collection_get'] = 0;
			}
			if (!array_key_exists('blog_get', $conds)) {
				$conds['blog_get'] = 0;
			}
			if ($conds['collection_get'] == 1 || $conds['blog_get'] == 1) {
				$conds['shop_status'] = 1;
				if (!empty($limit) && !empty($offset)) {
					// if limit & offset is not empty

					$data = $this->model->get_all_by($conds, $limit, $offset)->result();
				} else if (!empty($limit)) {
					// if limit is not empty

					$data = $this->model->get_all_by($conds, $limit)->result();
				} else {
					// if both are empty

					$data = $this->model->get_all_by($conds)->result();
				}
			} else {
				if (!empty($limit) && !empty($offset)) {
					// if limit & offset is not empty

					$data = $this->model->get_all_by($conds, $limit, $offset)->result();
				} else if (!empty($limit)) {
					// if limit is not empty

					$data = $this->model->get_all_by($conds, $limit)->result();
				} else {
					// if both are empty

					$data = $this->model->get_all_by($conds)->result();
				}
			}

			log_message('debug', 'API_Controller::get_get - Returning ' . count($data) . ' products');

			$this->custom_response($data, $offset);
		}
	}

	/**
	 * Get all or Get One
	 */
	function get_favourite_get()
	{
		// add flag for default query
		$this->is_get = true;

		// get limit & offset
		$limit = $this->get('limit');
		$offset = $this->get('offset');

		// get search criteria
		$default_conds = $this->default_conds();
		$user_conds = $this->get();
		$conds = array_merge($default_conds, $user_conds);
		$conds['user_id'] = $this->get_login_user_id();
		if ($limit) {
			unset($conds['limit']);
		}

		if ($offset) {
			unset($conds['offset']);
		}

		if (!empty($limit) && !empty($offset)) {
			// if limit & offset is not empty

			$data = $this->model->get_product_favourite($conds, $limit, $offset)->result();
		} else if (!empty($limit)) {
			// if limit is not empty

			$data = $this->model->get_product_favourite($conds, $limit)->result();
		} else {
			// if both are empty
			$data = $this->model->get_product_favourite($conds)->result();
		}

		$this->custom_response($data, $offset);
	}

	/**
	 * Get Like by user_id
	 */
	function get_like_get()
	{
		// add flag for default query
		$this->is_get = true;

		// get limit & offset
		$limit = $this->get('limit');
		$offset = $this->get('offset');

		// get search criteria
		$default_conds = $this->default_conds();
		$user_conds = $this->get();
		$conds = array_merge($default_conds, $user_conds);
		$conds['user_id'] = $this->get('user_id');

		if ($limit) {
			unset($conds['limit']);
		}

		if ($offset) {
			unset($conds['offset']);
		}

		if (!empty($limit) && !empty($offset)) {
			// if limit & offset is not empty

			$data = $this->model->get_product_like($conds, $limit, $offset)->result();
		} else if (!empty($limit)) {
			// if limit is not empty

			$data = $this->model->get_product_like($conds, $limit)->result();
		} else {
			// if both are empty
			$data = $this->model->get_product_like($conds)->result();
		}

		$this->custom_response($data, $offset);
	}

	function trending_category_get()
	{
		// add flag for default query
		$this->is_get = true;

		// get limit & offset
		$limit = $this->get('limit');
		$offset = $this->get('offset');

		// get search criteria
		$default_conds = $this->default_conds();
		$user_conds = $this->get();
		$conds = array_merge($default_conds, $user_conds);

		if ($limit) {
			unset($conds['limit']);
		}

		if ($offset) {
			unset($conds['offset']);
		}

		if (!empty($limit) && !empty($offset)) {
			// if limit & offset is not empty

			$data = $this->model->get_all_trending_category($conds, $limit, $offset)->result();
		} else if (!empty($limit)) {
			// if limit is not empty

			$data = $this->model->get_all_trending_category($conds, $limit)->result();
		} else {
			// if both are empty
			$data = $this->model->get_all_trending_category($conds)->result();
		}

		$this->custom_response($data, $offset);
	}

	function related_product_trending_get()
	{
		// add flag for default query
		$this->is_get = true;

		$current_product_id = $this->get('id');
		$current_cat_id 	= $this->get('cat_id');


		// get limit & offset
		$limit = $this->get('limit');
		$offset = $this->get('offset');

		// get search criteria
		$default_conds = $this->default_conds();
		$user_conds = $this->get();
		$conds = array_merge($default_conds, $user_conds);

		if ($limit) {
			unset($conds['limit']);
		}

		if ($offset) {
			unset($conds['offset']);
		}

		if (!empty($limit) && !empty($offset)) {
			// if limit & offset is not empty

			$data = $this->model->get_all_related_product_trending($conds, $limit, $offset)->result();
		} else if (!empty($limit)) {
			// if limit is not empty

			$data = $this->model->get_all_related_product_trending($conds, $limit)->result();
		} else {
			// if both are empty
			$data = $this->model->get_all_related_product_trending($conds)->result();
		}

		$this->custom_response($data, $offset);
	}

	function all_collection_products_get($conds = array(), $limit = false, $offset = false)
	{
		$this->is_get = true;

		// get limit & offset
		$limit = $this->get('limit');
		$offset = $this->get('offset');

		// get search criteria
		$default_conds = $this->default_conds();
		$user_conds = $this->get();
		$conds = array_merge($default_conds, $user_conds);

		if ($limit) {
			unset($conds['limit']);
		}

		if ($offset) {
			unset($conds['offset']);
		}

		$collection_id = $this->get('id');

		if (!empty($limit) && !empty($offset)) {
			// if limit & offset is not empty
			$data = $this->model->all_products_by_collection($conds, $limit, $offset)->result();
		} else if (!empty($limit)) {
			// if limit is not empty

			$data = $this->model->all_products_by_collection($conds, $limit)->result();
		} else {
			// if both are empty
			$data = $this->model->all_products_by_collection($conds)->result();
		}
		$this->custom_response($data, $offset);
	}

	function get_shop_tag_id_get()
	{
		// add flag for default query
		$this->is_get = true;

		// get limit & offset
		$limit = $this->get('limit');
		$offset = $this->get('offset');

		// get search criteria
		$default_conds = $this->default_conds();
		$user_conds = $this->get();
		$conds = array_merge($default_conds, $user_conds);
		$conds['tag_id'] = $this->get('tag_id');

		if ($limit) {
			unset($conds['limit']);
		}

		if ($offset) {
			unset($conds['offset']);
		}

		if (!empty($limit) && !empty($offset)) {
			// if limit & offset is not empty

			$data = $this->model->get_all_shop_by_tag_id($conds, $limit, $offset)->result();
		} else if (!empty($limit)) {
			// if limit is not empty

			$data = $this->model->get_all_shop_by_tag_id($conds, $limit)->result();
		} else {
			// if both are empty
			$data = $this->model->get_all_shop_by_tag_id($conds)->result();
		}


		$this->custom_response($data, $offset);
	}

	//search by keyword in shop, category, product

	function search_shop_post()
	{
		$limit = $this->get('limit');
		$offset = $this->get('offset');

		if ($this->post('searchterm') != "") {
			$conds['keyword']   = $this->post('searchterm');
		}

		if ($this->post('searchterm') != "") {
			$conds2['keyword']   = $this->post('searchterm');
		}

		if ($this->post('is_featured') != "") {
			$conds['is_featured']   = $this->post('is_featured');
		}


		if ($this->post('lat') != "") {
			$conds['lat']   = $this->post('lat');
		}

		if ($this->post('lng') != "") {
			$conds['lng']   = $this->post('lng');
		}

		if ($this->post('miles') != "") {
			$conds['miles']   = $this->post('miles');
		}

		// $conds['order_by'] = 1;

		$conds1['order_by_field']       = $this->post('order_by');
		$conds1['order_type']       = $this->post('order_type');

		if ($this->post('searchterm') != "") {
			$tags = $this->Tag->get_all_by($conds2)->result();
		}

		$shopsByNameAndDesc = $this->Shop->get_all_by($conds)->result();

		foreach ($shopsByNameAndDesc as $shop) {
			$shopIdsByNameAndDesc .= $shop->id . ",";
		}


		$shopIdsByNameAndDescCormaRemove = rtrim($shopIdsByNameAndDesc, ",");
		$shopIdsArrByNameAndDesc = explode(",", $shopIdsByNameAndDescCormaRemove);


		foreach ($tags as $tag) {

			$conds3['tag_id'] = $tag->id;

			//get data from shoptag table by tag_id
			$shopTags = $this->Shoptag->get_all_by($conds3)->result();

			foreach ($shopTags as $shopTag) {

				$shopIds .= $shopTag->shop_id . ",";
			}
		}

		$shopIdsRemoveCorma = rtrim($shopIds, ",");
		$shopIdsArr = explode(",", $shopIdsRemoveCorma);

		$allShopIds = array_unique(array_merge($shopIdsArrByNameAndDesc, $shopIdsArr));

		$conds1['shop_ids'] = $allShopIds;

		$shops = $this->Shop->get_all_by($conds1, $limit, $offset)->result();

		//search in shop end

		// $obj = new stdClass();

		// $obj->shops = $shops;


		$this->custom_response($shops, $offset);
	}

	function search_keyword_in_shop_post()
	{
		$offset = $this->get('offset');

		if ($this->post('searchterm') != "") {

			$searchterm = $this->post('searchterm');
			$conds['keyword'] = $searchterm;

			$tags = $this->Tag->get_all_by($conds)->result();

			//filter for search
			$search_in_shop = $this->Backend_config->get_all()->result()[0]->search_in_shop;
			$search_in_category = $this->Backend_config->get_all()->result()[0]->search_in_category;
			$search_in_product = $this->Backend_config->get_all()->result()[0]->search_in_product;
			$search_in_subcategory = $this->Backend_config->get_all()->result()[0]->search_in_subcategory;

			//limit for search
			$search_in_shop_limit = $this->Backend_config->get_all()->result()[0]->search_in_shop_limit;
			$search_in_category_limit = $this->Backend_config->get_all()->result()[0]->search_in_category_limit;
			$search_in_product_limit = $this->Backend_config->get_all()->result()[0]->search_in_product_limit;
			$search_in_subcategory_limit = $this->Backend_config->get_all()->result()[0]->search_in_subcategory_limit;

			//search in product start
			$products = $this->Product->get_all_by($conds, $search_in_product_limit, $offset)->result();
			//search in product end

			//search in category start
			$categories = $this->Category->get_all_by($conds, $search_in_category_limit, $offset)->result();
			//search in category end

			//search in subcategory start
			$subcategories = $this->Subcategory->get_all_by($conds, $search_in_subcategory_limit, $offset)->result();
			//search in subcategory end

			//search in shop start
			$shopsByNameAndDesc = $this->Shop->get_all_by($conds)->result();

			foreach ($shopsByNameAndDesc as $shop) {
				$shopIdsByNameAndDesc .= $shop->id . ",";
			}


			$shopIdsByNameAndDescCormaRemove = rtrim($shopIdsByNameAndDesc, ",");
			$shopIdsArrByNameAndDesc = explode(",", $shopIdsByNameAndDescCormaRemove);


			foreach ($tags as $tag) {

				$conds['tag_id'] = $tag->id;

				//get data from shoptag table by tag_id
				$shopTags = $this->Shoptag->get_all_by($conds)->result();

				foreach ($shopTags as $shopTag) {

					$shopIds .= $shopTag->shop_id . ",";
				}
			}

			$shopIdsRemoveCorma = rtrim($shopIds, ",");
			$shopIdsArr = explode(",", $shopIdsRemoveCorma);

			$allShopIds = array_unique(array_merge($shopIdsArrByNameAndDesc, $shopIdsArr));

			$conds1['shop_ids'] = $allShopIds;

			$shops = $this->Shop->get_all_by($conds1, $search_in_shop_limit, $offset)->result();

			//search in shop end


			if ($search_in_shop !== "1") {

				//not search in shop

				$obj = new stdClass();
				$obj->products = $products;
				$obj->categories = $categories;
				$obj->subcategories = $subcategories;
			} else if ($search_in_shop !== "1" && $search_in_category !== "1") {

				//not search in shop and category

				$obj = new stdClass();
				$obj->products = $products;
				$obj->subcategories = $subcategories;
			} else if ($search_in_shop !== "1" && $search_in_product !== "1") {

				//not search in shop and product

				$obj = new stdClass();
				$obj->categories = $categories;
				$obj->subcategories = $subcategories;
			} else if ($search_in_shop !== "1" && $search_in_subcategory !== "1") {

				//not search in shop and subcategory

				$obj = new stdClass();
				$obj->categories = $categories;
				$obj->products = $products;
			} else if ($search_in_shop !== "1" && $search_in_category !== "1" && $search_in_product !== "1") {

				//not search in shop and category and product

				$obj = new stdClass();
				$obj->subcategories = $subcategories;
			} else if ($search_in_shop !== "1" && $search_in_category !== "1" && $search_in_subcategory !== "1") {

				//not search in shop and category and subcategory

				$obj = new stdClass();
				$obj->products = $products;
			} else if ($search_in_shop !== "1" && $search_in_product !== "1" && $search_in_subcategory !== "1") {

				//not search in shop and product and subcategory

				$obj = new stdClass();
				$obj->categories = $categories;
			} else if ($search_in_category !== "1") {

				//not search in category

				$obj = new stdClass();
				$obj->products = $products;
				$obj->shops = $shops;
				$obj->subcategories = $subcategories;
			} else if ($search_in_category !== "1" && $search_in_subcategory !== "1") {

				//not search in category and subcategory

				$obj = new stdClass();
				$obj->shops = $shops;
				$obj->products = $products;
			} else if ($search_in_category !== "1" && $search_in_product !== "1") {

				//not search in category and product

				$obj = new stdClass();
				$obj->shops = $shops;
				$obj->subcategories = $subcategories;
			} else if ($search_in_product !== "1") {

				//not search in product

				$obj = new stdClass();
				$obj->categories = $categories;
				$obj->shops = $shops;
				$obj->subcategories = $subcategories;
			} else if ($search_in_product !== "1" && $search_in_subcategory !== "1") {

				//not search in product and subcategory

				$obj = new stdClass();
				$obj->shops = $shops;
				$obj->categories = $categories;
			} else if ($search_in_subcategory !== "1") {

				//not search in subcategory

				$obj = new stdClass();
				$obj->categories = $categories;
				$obj->shops = $shops;
				$obj->products = $products;
			} else {

				//search in shop, category, shop, subcategory

				$obj = new stdClass();
				$obj->products = $products;
				$obj->categories = $categories;
				$obj->shops = $shops;
				$obj->subcategories = $subcategories;
			}
		}

		$this->custom_response($obj, $offset);
	}

	/**
	 * Search API
	 */
	function search_post()
	{
		// add flag for default query
		$this->is_search = true;

		// add default conds
		$default_conds = $this->default_conds();
		$user_conds = $this->get();
		$conds = array_merge($default_conds, $user_conds);

		// check empty condition
		$final_conds = array();
		foreach ($conds as $key => $value) {
			if (!empty($value)) {
				$final_conds[$key] = $value;
			}
		}
		$conds = $final_conds;

		$limit = $this->get('limit');
		$offset = $this->get('offset');

		if ($conds['prd_search'] == 1) {
			$conds['shop_status'] = 1;

			if (!empty($limit) && !empty($offset)) {
				// if limit & offset is not empty

				$data = $this->model->get_all_by($conds, $limit, $offset)->result();
			} else if (!empty($limit)) {
				// if limit is not empty
				$data = $this->model->get_all_by($conds, $limit)->result();
			} else {
				// if both are empty

				$data = $this->model->get_all_by($conds)->result();
			}
		} else {

			if (!empty($limit) && !empty($offset)) {
				// if limit & offset is not empty

				$data = $this->model->get_all_by($conds, $limit, $offset)->result();
			} else if (!empty($limit)) {
				// if limit is not empty
				$data = $this->model->get_all_by($conds, $limit)->result();
			} else {
				// if both are empty

				$data = $this->model->get_all_by($conds)->result();
			}
		}

		$this->custom_response($data, $offset);
	}

	//product_count
	function get_collection_id()
	{

		$collection_id = $this->get('collection_id');

		return $collection_id;
	}


	/**
	 * Custome Response return 404 if not data found
	 *
	 * @param      <type>  $data   The data
	 */
	function custom_response_noti($data, $offset = false, $require_convert = true)
	{
		if (empty($data)) {
			// if there is no data, return error
			if (empty($data) && $offset == 0) {
				$this->error_response(get_msg('record_not_found'), 404);
			} else if (empty($data) && $offset > 0) {
				$this->error_response(get_msg('record_no_pagination'), 404);
			}
		} else if ($require_convert) {
			// if there is data, return the list
			if (is_array($data)) {
				// if the data is array
				foreach ($data as $obj) {
					// convert object for each obj
					if ($this->get_login_user_id() != "") {
						$noti_user_data = array(
							"noti_id" => $obj->id,
							"user_id" => $this->get_login_user_id(),
							"device_token" => $this->post('device_token')
						);
						if (!$this->Notireaduser->exists($noti_user_data)) {
							$obj->is_read = 88;
						} else {
							$obj->is_read = 100;
						}
					}

					$this->convert_object($obj);
				}
			} else {
				if ($this->get_login_user_id() != "") {
					$noti_user_data = array(
						"noti_id" => $data->id,
						"user_id" => $this->get_login_user_id(),
						"device_token" => $this->post('device_token')
					);
					if (!$this->Notireaduser->exists($noti_user_data)) {
						$data->is_read = 99;
					} else {
						$data->is_read = 100;
					}
				}

				$this->convert_object($data);
			}
		}
		$data = $this->ps_security->clean_output($data);



		$this->response($data);
	}

	/**
	 * Adds a post.
	 */
	function add_post()
	{
		// set the add flag for custom response
		$this->is_add = true;

		if (!$this->is_valid($this->create_validation_rules)) {
			// if there is an error in validation,

			return;
		}

		// get the post data
		$data = $this->post();

		if ($data['shop_id'] != "") {
			$data['shop_id'] = $this->post('shop_id');
		}

		if (!$this->model->save($data)) {
			$this->error_response(get_msg('err_model'), 500);
		}

		// response the inserted object	
		$obj = $this->model->get_one($data[$this->model->primary_key]);

		$this->custom_response($obj);
	}

	/**
	 * Adds a post.
	 */
	function add_rating_post()
	{
		// set the add flag for custom response
		$this->is_add = true;

		if (!$this->is_valid($this->create_validation_rules)) {
			// if there is an error in validation,

			return;
		}

		// get the post data
		$data = $this->post();
		$user_id = $data['user_id'];

		$users = global_user_check($user_id);

		$conds['user_id'] = $user_id;
		$conds['product_id'] = $data['product_id'];

		$id = $this->model->get_one_by($conds)->id;

		$rating = $data['rating'];
		if ($id) {

			$this->model->save($data, $id);

			// response the inserted object	
			$obj = $this->model->get_one($id);
		} else {
			$this->model->save($data);

			// response the inserted object	
			$obj = $this->model->get_one($data[$this->model->primary_key]);
		}

		//Need to update rating value at product
		$conds_rating['product_id'] = $obj->product_id;

		$total_rating_count = $this->Rate->count_all_by($conds_rating);
		$sum_rating_value = $this->Rate->sum_all_by($conds_rating)->result()[0]->rating;

		if ($total_rating_count > 0) {
			$total_rating_value = number_format((float) ($sum_rating_value  / $total_rating_count), 1, '.', '');
		} else {
			$total_rating_value = 0;
		}

		$item_data['overall_rating'] = $total_rating_value;
		$this->Product->save($item_data, $obj->product_id);


		//$obj_item = $this->Product->get_one( $obj->product_id );
		$obj_rating = $this->Rate->get_one($obj->id);

		$this->ps_adapter->convert_rating($obj_rating);
		$this->custom_response($obj_rating);
	}

	/**
	 * Adds a post.
	 */
	function add_touch_post()
	{
		// set the add flag for custom response
		$this->is_add = true;

		if (!$this->is_valid($this->create_validation_rules)) {
			// if there is an error in validation,

			return;
		}

		// get the post data
		$data = $this->post();
		$data['shop_id'] = $this->post('shop_id');
		if (!$this->model->save($data)) {
			$this->error_response(get_msg('err_model'), 500);
		}

		// response the inserted object	
		$obj = $this->model->get_one($data[$this->model->primary_key]);

		if ($obj->type_name == "product") {
			//Need to update touch count value at product
			$conds_rating['type_id'] = $obj->type_id;

			$total_touch_count = $this->Touch->count_all_by($conds_rating);

			$item_data['touch_count'] = $total_touch_count;
			$this->Product->save($item_data, $obj->type_id);
		} else if ($obj->type_name == "category") {
			//Need to update touch count value at category
			$conds_rating['type_id'] = $obj->type_id;

			$total_touch_count = $this->Touch->count_all_by($conds_rating);

			$cat_data['touch_count'] = $total_touch_count;
			$this->Category->save($cat_data, $obj->type_id);
		} else {
			//Need to update touch count value at shop
			$conds_rating['type_id'] = $obj->type_id;

			$total_touch_count = $this->Touch->count_all_by($conds_rating);

			$shop_data['touch_count'] = $total_touch_count;
			$this->Shop->save($shop_data, $obj->type_id);
		}
		$this->custom_response($obj);
	}

	/**
	 * Adds a post.
	 */
	function update_put()
	{
		// set the add flag for custom response
		$this->is_update = true;

		if (!$this->is_valid($this->update_validation_rules)) {
			// if there is an error in validation,

			return;
		}

		// get the post data
		$data = $this->put();

		// get id
		$id = $this->get($this->model->primary_key);

		if (!$this->model->save($data, $id)) {
			// error in saving, 

			$this->error_response(get_msg('err_model'), 500);
		}

		// response the inserted object	
		$obj = $this->model->get_one($id);

		$this->custom_response($obj);
	}

	/**
	 * Delete the record
	 */
	function delete_delete()
	{
		// set the add flag for custom response
		$this->is_delete = true;

		if (!$this->is_valid($this->delete_validation_rules)) {
			// if there is an error in validation,

			return;
		}

		// get id
		$id = $this->get($this->model->primary_key);

		if (!$this->model->delete($id)) {
			// error in saving, 

			$this->error_response(get_msg('err_model'), 500);
		}

		$this->success_response(get_msg('success_delete'), 201);
	}


	/**
	 * Get Delete Product By Date Range.
	 */
	function get_delete_product_post()
	{
		$start = $this->post('start_date');
		$end   = $this->post('end_date');

		$conds['start_date'] = $start;
		$conds['end_date']   = $end;
		$conds['type_name']  = "product";


		//$deleted_product_ids = $this->Product_delete->get_all_by($conds)->result();
		$deleted_product_ids = $this->Delete_history->get_all_by($conds)->result();

		$this->custom_response($deleted_product_ids, false);
	}

	/**
	 * Get Delete Shop By Date Range.
	 */
	function get_delete_shop_post()
	{

		$start = $this->post('start_date');
		$end   = $this->post('end_date');

		$conds['start_date'] = $start;
		$conds['end_date']   = $end;


		$deleted_shop_ids = $this->Shop_delete->get_all_by($conds)->result();

		$this->custom_response($deleted_shop_ids, false);
	}

	function get_token_get()
	{

		$shop_obj = $this->Shop->get_all()->result();


		$environment = $shop_obj[0]->paypal_environment;
		$merchantId  = $shop_obj[0]->paypal_merchant_id;
		$publicKey   = $shop_obj[0]->paypal_public_key;
		$privateKey  = $shop_obj[0]->paypal_private_key;


		//echo ">>" . $environment . " - " . $merchantId . " - " . $publicKey . " - " . $privateKey; die;

		$gateway = new Braintree_Gateway([
			'environment' => 'sandbox',
			'merchantId' => 'h6ggypvjgt4tzz2k',
			'publicKey' => '256y6grqr936tpjf',
			'privateKey' => '0d6aadf4b586a84844ceadc834dc851f'
		]);

		$clientToken = $gateway->clientToken()->generate();

		//$this->custom_response( $clientToken );

		if ($clientToken != "") {
			$this->response(array(
				'status' => 'success',
				'message' => $clientToken
			));
		} else {
			$this->error_response(get_msg('token_not_round'), 500);
		}
	}




	/**
	 * Get Delete History By Date Range.
	 */
	function get_delete_history_post()
	{


		$start = $this->post('start_date');
		$end   = $this->post('end_date');
		$user_id = $this->post('user_id');

		if ($start != "" && $start != '0') {
			$conds['start_date'] = $start;
		}

		if ($end != "" && $end != '0') {
			$conds['end_date']   = $end;
		}

		$conds['order_by'] = 1;
		$conds['order_by_field'] = "type_name";
		$conds['order_by_type'] = "desc";


		//$deleted_his_ids = $this->Delete_history->get_all_history_by($conds)->result();
		$deleted_his_ids = $this->Delete_history->get_all_by($conds)->result();

		$this->custom_response_history($deleted_his_ids, $user_id, false);
	}


	/**
	 * Custome Response return 404 if not data found
	 *
	 * @param      <type>  $data   The data
	 */
	function custom_response_history($data, $user_id, $require_convert = true)
	{


		$version_object = new stdClass;
		//version obj
		$version_object->version_no           = $this->Version->get_one("1")->version_no;
		$version_object->version_force_update = $this->Version->get_one("1")->version_force_update;
		$version_object->version_title        = $this->Version->get_one("1")->version_title;
		$version_object->version_message      = $this->Version->get_one("1")->version_message;
		$version_object->version_need_clear_data      = $this->Version->get_one("1")->version_need_clear_data;

		//deliboy version obj
		$deliboy_version_object = new stdClass;
		$deliboy_version_object->deli_boy_version_no           = $this->Version->get_one("1")->deli_boy_version_no;
		$deliboy_version_object->deli_boy_version_force_update = $this->Version->get_one("1")->deli_boy_version_force_update;
		$deliboy_version_object->deli_boy_version_title        = $this->Version->get_one("1")->deli_boy_version_title;
		$deliboy_version_object->deli_boy_version_message      = $this->Version->get_one("1")->deli_boy_version_message;
		$deliboy_version_object->deli_boy_version_need_clear_data      = $this->Version->get_one("1")->deli_boy_version_need_clear_data;

		$app_object = new stdClass;
		$app_config = $this->Mobile_setting->get_one('mb1');
		$app_object->lat = $app_config->lat;
		$app_object->lng = $app_config->lng;
		$app_object->google_playstore_url = $app_config->google_playstore_url;
		$app_object->apple_appstore_url = $app_config->apple_appstore_url;
		$app_object->price_format = $app_config->price_format;
		$app_object->date_format = $app_config->date_format;
		$app_object->default_order_time = $app_config->default_order_time;
		$app_object->ios_appstore_id = $app_config->ios_appstore_id;
		$app_object->is_use_thumbnail_as_placeholder = $app_config->is_use_thumbnail_as_placeholder;
		$app_object->is_show_token_id = $app_config->is_show_token_id;
		$app_object->is_show_subcategory = $app_config->is_show_subcategory;
		$app_object->fb_key = $app_config->fb_key;
		$app_object->is_show_admob = $app_config->is_show_admob;
		$app_object->default_loading_limit = $app_config->default_loading_limit;
		$app_object->category_loading_limit = $app_config->category_loading_limit;
		$app_object->collection_product_loading_limit = $app_config->collection_product_loading_limit;
		$app_object->discount_product_loading_limit = $app_config->discount_product_loading_limit;
		$app_object->feature_product_loading_limit = $app_config->feature_product_loading_limit;
		$app_object->latest_product_loading_limit = $app_config->latest_product_loading_limit;
		$app_object->trending_product_loading_limit = $app_config->trending_product_loading_limit;
		$app_object->shop_loading_limit = $app_config->shop_loading_limit;
		$app_object->show_facebook_login = $app_config->show_facebook_login;
		$app_object->show_google_login = $app_config->show_google_login;
		$app_object->show_phone_login = $app_config->show_phone_login;
		$app_object->show_main_menu = $app_config->show_main_menu;
		$app_object->show_special_collections = $app_config->show_special_collections;
		$app_object->show_featured_items = $app_config->show_featured_items;
		$app_object->show_best_choice_slider = $app_config->show_best_choice_slider;
		$app_object->is_razor_support_multi_currency = $app_config->is_razor_support_multi_currency;
		$app_object->default_razor_currency = $app_config->default_razor_currency;
		$app_object->default_flutter_wave_currency = $app_config->default_flutter_wave_currency;

		$languages = array(
			array('language_code' => 'en', 'country_code' => 'US', 'name' => 'English'),
			array('language_code' => 'ar', 'country_code' => 'DZ', 'name' => 'Arabic'),
			array('language_code' => 'hi', 'country_code' => 'IN', 'name' => 'Hindi'),
			array('language_code' => 'de', 'country_code' => 'DE', 'name' => 'German'),
			array('language_code' => 'es', 'country_code' => 'ES', 'name' => 'Spainish'),
			array('language_code' => 'fr', 'country_code' => 'FR', 'name' => 'French'),
			array('language_code' => 'id', 'country_code' => 'ID', 'name' => 'Indonesian'),
			array('language_code' => 'it', 'country_code' => 'IT', 'name' => 'Italian'),
			array('language_code' => 'ja', 'country_code' => 'JP', 'name' => 'Japanese'),
			array('language_code' => 'ko', 'country_code' => 'KR', 'name' => 'Korean'),
			array('language_code' => 'ms', 'country_code' => 'MY', 'name' => 'Malay'),
			array('language_code' => 'pt', 'country_code' => 'PT', 'name' => 'Portuguese'),
			array('language_code' => 'ru', 'country_code' => 'RU', 'name' => 'Russian'),
			array('language_code' => 'th', 'country_code' => 'TH', 'name' => 'Thai'),
			array('language_code' => 'tr', 'country_code' => 'TR', 'name' => 'Turkish'),
			array('language_code' => 'zh', 'country_code' => 'CN', 'name' => 'Chinese'),
		);

		$default_language = array();
		$exclude_language = array();
		$exclude_lang = explode(',', trim($app_config->exclude_language));
		$default_lang = trim($app_config->default_language);

		foreach ($languages as $language) {
			if (in_array($language['language_code'], $exclude_lang)) {
				$exclude_language[] = array('language_code' => $language['language_code'], 'country_code' => $language['country_code'], 'name' => $language['name']);
			}

			if ($language['language_code'] == $default_lang) {
				$default_language = array('language_code' => $language['language_code'], 'country_code' => $language['country_code'], 'name' => $language['name']);
			}
		}

		$app_object->default_language = $default_language;
		$app_object->exclude_language = $exclude_language;

		$user_object = new stdClass;
		$is_banned = $this->User->get_one($user_id)->is_banned;
		$user_object->user_status = $this->User->get_one($user_id)->status;

		$user_data = $this->User->get_one($user_id);
		//($user_data->status);die;

		if ($user_id == "nologinuser") {
			$user_object->user_status = "nologinuser";
		} elseif ($user_data->is_empty_object == 1) {
			$user_object->user_status = "deleted";
		} elseif ($is_banned == 1) {
			$user_object->user_status = "banned";
		} elseif ($user_object->user_status == 1) {
			$user_object->user_status = "active";
		} elseif ($user_object->user_status == 2) {
			$user_object->user_status = "pending";
		} elseif ($user_object->user_status == 0) {
			$user_object->user_status = "unpublished";
		}

		//shop
		$conds['status'] = 1;

		$shop_count = $this->Shop->count_all_by($conds);
		$shop_object = new stdClass;
		if ($shop_count == 1) {
			$shop_object->is_multi = 0;
			$shop_id = $this->Shop->get_one_by($conds)->id;
			// $shop = $this->Shop->get_one($shop_id);

			$tmp_shop = $this->Shop->get_one( $shop_id );

			$this->ps_adapter->convert_shop( $tmp_shop );

			$shop_object->shop = $tmp_shop;

			
		} elseif ($shop_count > 1) {
			$shop_object->is_multi = 1;
			$shop_id = $this->Shop->get_one_by($conds)->id;
			// $shop_object->shop = $this->Shop->get_one($shop_id);

			$tmp_shop = $this->Shop->get_one( $shop_id );

			$this->ps_adapter->convert_shop( $tmp_shop );

			$shop_object->shop = $tmp_shop;
			
		}

		$final_data = new stdClass;
		$final_data->version = $version_object;
		$final_data->deliboy_version = $deliboy_version_object;
		$final_data->mobile_setting = $app_object;
		$final_data->user_info = $user_object;
		$final_data->delete_history = $data;
		//$final_data->enable_comment = $this->App_config->get_one("app_set1")->enable_comment;
		//$final_data->enable_review = $this->App_config->get_one("app_set1")->enable_review; 
		$final_data->contact_phone = $this->About->get_one("abt1")->about_phone;
		$final_data->contact_email = $this->About->get_one("abt1")->about_email;
		$final_data->contact_website = $this->About->get_one("abt1")->about_website;
		$final_data->shop_obj = $shop_object;




		$final_data = $this->ps_security->clean_output($final_data);


		$this->response($final_data);
	}

	/**
	 * Adds a post.
	 */
	function add_shop_rating_post()
	{
		// set the add flag for custom response
		$this->is_add = true;

		if (!$this->is_valid($this->create_validation_rules)) {
			// if there is an error in validation,

			return;
		}

		// get the post data
		$data = $this->post();
		$user_id = $data['user_id'];

		$users = global_user_check($user_id);

		$conds['user_id'] = $user_id;
		$conds['shop_id'] = $data['shop_id'];
		$id = $this->model->get_one_by($conds)->id;
		$rating = $data['rating'];
		if ($id) {

			$this->model->save($data, $id);

			// response the inserted object	
			$obj = $this->model->get_one($id);
		} else {
			$this->model->save($data);

			// response the inserted object	
			$obj = $this->model->get_one($data[$this->model->primary_key]);
		}

		//Need to update rating value at product
		$conds_rating['shop_id'] = $obj->shop_id;

		$total_rating_count = $this->Shop_rate->count_all_by($conds_rating);
		$sum_rating_value = $this->Shop_rate->sum_all_by($conds_rating)->result()[0]->rating;

		if ($total_rating_count > 0) {
			$total_rating_value = number_format((float) ($sum_rating_value  / $total_rating_count), 1, '.', '');
		} else {
			$total_rating_value = 0;
		}

		//print_r($total_rating_value);die;

		$shop_data['overall_rating'] = $total_rating_value;
		$this->Shop->save($shop_data, $obj->shop_id);


		$obj_shop = $this->Shop->get_one($obj->shop_id);

		$this->ps_adapter->convert_shop($obj_shop);
		$this->custom_response($obj_shop);
	}

	function convert_shop_for_info_api($shop_id)
	{

		// set default photo
		$shop_object->default_photo = $this->get_default_photo($shop_id, 'shop');

		// set default icon 
		$shop_object->default_icon = $this->get_default_photo($shop_id, 'shop-icon');

		// touch count
		$shop_object->touch_count =  $this->Touch->count_all_by(array("type_id" => $shop_id, "type_name" => "shop"));

		//rating details 

		// $shop_object->like_count = $this->Like->count_all_by(array("product_id" => $shop_id));


		$total_rating_count = 0;
		$total_rating_value = 0;

		$five_star_count = 0;
		$five_star_percent = 0;

		$four_star_count = 0;
		$four_star_percent = 0;

		$three_star_count = 0;
		$three_star_percent = 0;

		$two_star_count = 0;
		$two_star_percent = 0;

		$one_star_count = 0;
		$one_star_percent = 0;

		//Rating Total how much ratings for this product
		$conds_rating['shop_id'] = $shop_id;
		$total_rating_count = $this->Shop_rate->count_all_by($conds_rating);
		$sum_rating_value = $this->Shop_rate->sum_all_by($conds_rating)->result()[0]->rating;

		//Rating Value such as 3.5, 4.3 and etc
		if ($total_rating_count > 0) {
			$total_rating_value = number_format((float) ($sum_rating_value  / $total_rating_count), 1, '.', '');
		} else {
			$total_rating_value = 0;
		}

		//For 5 Stars rating

		$conds_five_star_rating['rating'] = 5;
		$conds_five_star_rating['shop_id'] = $shop_id;
		$five_star_count = $this->Shop_rate->count_all_by($conds_five_star_rating);
		if ($total_rating_count > 0) {
			$five_star_percent = number_format((float) ((100 / $total_rating_count) * $five_star_count), 1, '.', '');
		} else {
			$five_star_percent = 0;
		}

		//For 4 Stars rating
		$conds_four_star_rating['rating'] = 4;
		$conds_four_star_rating['shop_id'] = $shop_id;
		$four_star_count = $this->Shop_rate->count_all_by($conds_four_star_rating);
		if ($total_rating_count > 0) {
			$four_star_percent = number_format((float) ((100 / $total_rating_count) * $four_star_count), 1, '.', '');
		} else {
			$four_star_percent = 0;
		}


		//For 3 Stars rating
		$conds_three_star_rating['rating'] = 3;
		$conds_three_star_rating['shop_id'] = $shop_id;
		$three_star_count = $this->Shop_rate->count_all_by($conds_three_star_rating);
		if ($total_rating_count > 0) {
			$three_star_percent = number_format((float) ((100 / $total_rating_count) * $three_star_count), 1, '.', '');
		} else {
			$three_star_percent = 0;
		}


		//For 2 Stars rating
		$conds_two_star_rating['rating'] = 2;
		$conds_two_star_rating['shop_id'] = $shop_id;
		$two_star_count = $this->Shop_rate->count_all_by($conds_two_star_rating);

		if ($total_rating_count > 0) {
			$two_star_percent = number_format((float) ((100 / $total_rating_count) * $two_star_count), 1, '.', '');
		} else {
			$two_star_percent = 0;
		}

		//For 1 Stars rating
		$conds_one_star_rating['rating'] = 1;
		$conds_one_star_rating['shop_id'] = $shop_id;
		$one_star_count = $this->Shop_rate->count_all_by($conds_one_star_rating);

		if ($total_rating_count > 0) {
			$one_star_percent = number_format((float) ((100 / $total_rating_count) * $one_star_count), 1, '.', '');
		} else {
			$one_star_percent = 0;
		}


		$rating_std = new stdClass();
		$rating_std->five_star_count = $five_star_count;
		$rating_std->five_star_percent = $five_star_percent;

		$rating_std->four_star_count = $four_star_count;
		$rating_std->four_star_percent = $four_star_percent;

		$rating_std->three_star_count = $three_star_count;
		$rating_std->three_star_percent = $three_star_percent;

		$rating_std->two_star_count = $two_star_count;
		$rating_std->two_star_percent = $two_star_percent;

		$rating_std->one_star_count = $one_star_count;
		$rating_std->one_star_percent = $one_star_percent;

		$rating_std->total_rating_count = $total_rating_count;
		$rating_std->total_rating_value = $total_rating_value;


		$shop_object->rating_details = $rating_std;

		// shop schedule obj
		$shop_sch = new stdClass();
		$schedules = $this->Schedule->get_all_by($conds_rating)->result();

		for ($i = 0; $i < count($schedules); $i++) {
			//print_r($schedules[$i]->days_of_week);die;

			if ($schedules[$i]->days_of_week == get_msg('monday_label')) {
				if ($schedules[$i]->is_open == '1') {
					$shop_sch->is_monday_open = '1';
					$shop_sch->monday_open_hour = $schedules[$i]->open_hour;
					$shop_sch->monday_close_hour = $schedules[$i]->close_hour;
				} else {
					$shop_sch->is_monday_open = '0';
					$shop_sch->monday_open_hour = '00:00';
					$shop_sch->monday_close_hour = '00:00';
				}
			}

			if ($schedules[$i]->days_of_week == get_msg('tuesday_label')) {
				if ($schedules[$i]->is_open == '1') {
					$shop_sch->is_tuesday_open = '1';
					$shop_sch->tuesday_open_hour = $schedules[$i]->open_hour;
					$shop_sch->tuesday_close_hour = $schedules[$i]->close_hour;
				} else {
					$shop_sch->is_tuesday_open = '0';
					$shop_sch->tuesday_open_hour = '00:00';
					$shop_sch->tuesday_close_hour = '00:00';
				}
			}

			if ($schedules[$i]->days_of_week == get_msg('wednesday_label')) {
				if ($schedules[$i]->is_open == '1') {
					$shop_sch->is_wednesday_open = '1';
					$shop_sch->wednesday_open_hour = $schedules[$i]->open_hour;
					$shop_sch->wednesday_close_hour = $schedules[$i]->close_hour;
				} else {
					$shop_sch->is_wednesday_open = '0';
					$shop_sch->wednesday_open_hour = '00:00';
					$shop_sch->wednesday_close_hour = '00:00';
				}
			}

			if ($schedules[$i]->days_of_week == get_msg('thursday_label')) {
				if ($schedules[$i]->is_open == '1') {
					$shop_sch->is_thursday_open = '1';
					$shop_sch->thursday_open_hour = $schedules[$i]->open_hour;
					$shop_sch->thursday_close_hour = $schedules[$i]->close_hour;
				} else {
					$shop_sch->is_thursday_open = '0';
					$shop_sch->thursday_open_hour = '00:00';
					$shop_sch->thursday_close_hour = '00:00';
				}
			}

			if ($schedules[$i]->days_of_week == get_msg('friday_label')) {
				if ($schedules[$i]->is_open == '1') {
					$shop_sch->is_friday_open = '1';
					$shop_sch->friday_open_hour = $schedules[$i]->open_hour;
					$shop_sch->friday_close_hour = $schedules[$i]->close_hour;
				} else {
					$shop_sch->is_friday_open = '0';
					$shop_sch->friday_open_hour = '00:00';
					$shop_sch->friday_close_hour = '00:00';
				}
			}

			if ($schedules[$i]->days_of_week == get_msg('saturday_label')) {
				if ($schedules[$i]->is_open == '1') {
					$shop_sch->is_saturday_open = '1';
					$shop_sch->saturday_open_hour = $schedules[$i]->open_hour;
					$shop_sch->saturday_close_hour = $schedules[$i]->close_hour;
				} else {
					$shop_sch->is_saturday_open = '0';
					$shop_sch->saturday_open_hour = '00:00';
					$shop_sch->saturday_close_hour = '00:00';
				}
			}

			if ($schedules[$i]->days_of_week == get_msg('sunday_label')) {
				if ($schedules[$i]->is_open == '1') {
					$shop_sch->is_sunday_open = '1';
					$shop_sch->sunday_open_hour = $schedules[$i]->open_hour;
					$shop_sch->sunday_close_hour = $schedules[$i]->close_hour;
				} else {
					$shop_sch->is_sunday_open = '0';
					$shop_sch->sunday_open_hour = '00:00';
					$shop_sch->sunday_close_hour = '00:00';
				}
			}
			$shop_object->shop_schedules = $shop_sch;
		}



		// grocery branch object
		if (isset($shop_id)) {
			$conds['shop_id'] = $shop_id;
			$tmp_grocery_branch_count = $this->Grocery_branch->count_all_by($conds);
			if ($tmp_grocery_branch_count > 0) {
				$tmp_grocery_branch = $this->Grocery_branch->get_all_by($conds)->result();
			} else {
				$tmp_grocery_branch[] = $this->Grocery_branch->get_empty_object();
			}
			$shop_object->grocery_branch = $tmp_grocery_branch;
		}
	}

	// search category

	function search_cat_post()
	{
		// add flag for default query
		$this->is_search = true;

		// add default conds
		$default_conds = $this->default_conds();
		$user_conds = $this->get();
		$conds = array_merge($default_conds, $user_conds);

		// check empty condition
		$final_conds = array();
		foreach ($conds as $key => $value) {
			if (!empty($value)) {
				$final_conds[$key] = $value;
			}
		}
		$conds = $final_conds;

		$limit = $this->get('limit');
		$offset = $this->get('offset');

		$conds['shop_id'] = $this->post('shop_id');

		if ($conds['shop_id'] == "") {
			if (!empty($limit) && !empty($offset)) {
				// if limit & offset is not empty

				$data = $this->model->get_category($conds, $limit, $offset)->result();
			} else if (!empty($limit)) {
				// if limit is not empty
				$data = $this->model->get_category($conds, $limit)->result();
			} else {
				// if both are empty

				$data = $this->model->get_category($conds)->result();
			}
		} else {

			if (!empty($limit) && !empty($offset)) {
				// if limit & offset is not empty

				$data = $this->model->get_category($conds, $limit, $offset)->result();
			} else if (!empty($limit)) {
				// if limit is not empty
				$data = $this->model->get_category($conds, $limit)->result();
			} else {
				// if both are empty

				$data = $this->model->get_category($conds)->result();
			}
		}

		$this->custom_response($data);
	}
}
