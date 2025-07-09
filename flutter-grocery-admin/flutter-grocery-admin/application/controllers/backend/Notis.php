<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Notis Controller
 */
class Notis extends BE_Controller {

	/**
	 * Construt required variables
	 */
	function __construct() {

		parent::__construct( MODULE_CONTROL, 'NOTIS' );
		///start allow module check by MN
		$selected_shop_id = $this->session->userdata('selected_shop_id');
		$shop_id = $selected_shop_id['shop_id'] ?? null;
		
		$conds_mod['module_name'] = $this->router->fetch_class();
		$module_id = $this->Module->get_one_by($conds_mod)->module_id;
		
		$logged_in_user = $this->ps_auth->get_user_info();

		$user_id = $logged_in_user->user_id;
		if($logged_in_user->user_is_sys_admin!=1){
			return redirect( site_url('/admin/dashboard/index/'.$shop_id) );
		}
		///end check
	}

	/**
	* Load Notification Sending Form
	*/
	function index() {
		$this->data['action_title'] = get_msg('push_noti');
		$conds = array();
		// get rows count
		$this->data['rows_count'] = $this->Noti->count_all_by( $conds );

		// get notimsgs
		$this->data['notimsgs'] = $this->Noti->get_all_by( $conds , $this->pag['per_page'], $this->uri->segment( 4 ) );

		// load index logic
		parent::notilist();
	}

	/**
      * Searches for the first match.
    */
    function search() {

        // breadcrumb urls
        $this->data['action_title'] = get_msg( 'noti_search' );

        // condition with search term
        $conds = array( 'searchterm' => $this->searchterm_handler( $this->input->post( 'searchterm' )) );
        // no publish filter
        $conds['no_publish_filter'] = 1;

        // get rows count
		$this->data['rows_count'] = $this->Noti->count_all_by( $conds );

		// get notimsgs
		$this->data['notimsgs'] = $this->Noti->get_all_by( $conds , $this->pag['per_page'], $this->uri->segment( 4 ) );

        // load add list
        parent::notisearch();
    }

	/**
	 * Create new one
	 */
	function add() {

		// breadcrumb urls
		$this->data['action_title'] = get_msg( 'cat_add' );

		// call the core add logic
		$this->load_template('notis/entry_form', $this->data, true );
	}

	/**
	* Sending Push Notification Message
	*/
	function push_message() {

		if ( $this->input->server( 'REQUEST_METHOD' ) == "POST" ) {
				
			$message = htmlspecialchars_decode($this->input->post( 'message' ));

			$error_msg = "";
			$success_device_log = "";


			$data['message'] = $message;
			$data['flag'] = 'broadcast';
			// Android Push Notification
			$devices = $this->Notitoken->get_all()->result();

			$device_ids = array();
			if ( count( $devices ) > 0 ) {
				foreach ( $devices as $device ) {
					$device_ids[] = $device->device_id;
				}
			}

			$platform_names = array();
			if ( count( $devices ) > 0 ) {
				foreach ( $devices as $platform ) {
					$platform_names[] = $platform->platform_name;
				}
			}

			$status = send_android_fcm( $device_ids, $data, $platform_names );
			if ( !$status ) $error_msg .= get_msg('fail_push_all_devices') . "<br/>";

			// // IOS Push Notification
			// $devices = $this->Notitoken->get_all_by(array('os_type' => 'IOS'))->result();
			
			// if ( count( $devices ) > 0 ) {
			// 	foreach ( $devices as $device ) {
			// 		if ( ! $this->send_ios_apns( $device->device_id, $message )) {
			// 			$error_msg .= "Fail to push ios device named ". $device->device_id ."<br/>";
			// 		} else {
			// 			$success_device_log .= " Device Id : " . $device->device_id . "<br>";
			// 		}
			// 	}
			// }
			// start the transaction
		$this->db->trans_start();
		$logged_in_user = $this->ps_auth->get_user_info();
		/** 
		 * Insert Notification Records 
		 */
		$data = array();

		// prepare noti name zawgyi
		if ( $this->has_data( 'message' )) {
			$data['message'] = $this->get_data( 'message' );
		}

		// prepare description zawgyi
		if ( $this->has_data( 'description' )) {
			$data['description'] = $this->get_data( 'description' );
		}

		$data['added_user_id'] = $logged_in_user->user_id;
		if($id == "") {
			//save
			$data['added_date'] = date("Y-m-d H:i:s");
		  } 
		// save notification
		if ( ! $this->Noti->save( $data, $id )) {
		// if there is an error in inserting user data,	

			// rollback the transaction
			$this->db->trans_rollback();

			// set error message
			$this->data['error'] = get_msg( 'err_model' );
			
			return;
		}
		/** 
		 * Upload Image Records 
		*/
	
		if ( !$id ) {
		// if id is false, this is adding new record

			if ( ! $this->insert_images( $_FILES, 'noti', $data['id'] )) {
		
			}

			
		}
			

			// commit the transaction
		if ( ! $this->check_trans()) {
        	
			// set flash error message
			$this->set_flash_msg( 'error', get_msg( 'err_model' ));
		} else {

			if ( $id ) {
			// if user id is not false, show success_add message
				
				//$this->set_flash_msg( 'success', get_msg( 'success_cat_edit' ));
			} else {
			// if user id is false, show success_edit message

				$this->set_flash_msg( 'success', get_msg( 'success_noti_add' ));
			}
		}

		}

		// $this->data['action_title'] = "Push Notification";
		redirect( $this->module_site_url());
	}

	/**
	* Sending Push Notification for flutter
	*/
	function push_message_flutter() { 

		if ( $this->input->server( 'REQUEST_METHOD' ) == "POST" ) {
			
			$description = htmlspecialchars_decode($this->input->post( 'description' ));
			$message = htmlspecialchars_decode($this->input->post( 'message' ));

			// $noti_message = array('description' => $description, 'message' => $message);

			$error_msg = "";
			$success_device_log = "";

			// Android Push Notification
			
			/*
			$devices = $this->Notitoken->get_all_by(array('os_type' => 'ANDROID'))->result();

			$device_ids = array();
			if ( count( $devices ) > 0 ) {
				foreach ( $devices as $device ) {
					$device_ids[] = $device->device_id;
				}
			}
			*/

			//$status = $this->send_android_fcm( $device_ids, array( "title" => $title ));
			
			// Push Notification for FE
			// $dyn_link_deep_url = $this->Backend_config->get_one('be1')->dyn_link_deep_url;

			// $prj_url = explode('/', $dyn_link_deep_url);
			// $i = count($prj_url)-3;
			// $prj_name = $prj_url[$i];

			$data['desc'] = $description;
			$data['message'] = $message;
			$data['push'] = 1;

			$status = send_android_fcm_topics_subscribe( $data );
			if ( !$status ) $error_msg .= get_msg('fail_push_all_android_ios') . "<br/>";

			// $status_fe = send_android_fcm_topics_subscribe_fe( $data, $prj_name );
			// if ( !$status_fe ) $error_msg .= "Fail to push all websties <br/>";

			// // IOS Push Notification
			// $devices = $this->Notitoken->get_all_by(array('os_type' => 'IOS'))->result();
			
			// if ( count( $devices ) > 0 ) {
			// 	foreach ( $devices as $device ) {
			// 		if ( ! $this->send_ios_apns( $device->device_id, $title )) {
			// 			$error_msg .= "Fail to push ios device named ". $device->device_id ."<br/>";
			// 		} else {
			// 			$success_device_log .= " Device Id : " . $device->device_id . "<br>";
			// 		}
			// 	}
			// }
			// start the transaction
		$this->db->trans_start();
		$logged_in_user = $this->ps_auth->get_user_info();
		/** 
		 * Insert Notification Records 
		 */
		$data = array();

		// prepare noti name zawgyi
		if ( $this->has_data( 'description' )) {
			$data['description'] = $this->get_data( 'description' );
		}

		// prepare message zawgyi
		if ( $this->has_data( 'message' )) {
			$data['message'] = $this->get_data( 'message' );
		}

		$data['added_user_id'] = $logged_in_user->user_id;
		if($id == "") {
			//save
			$data['added_date'] = date("Y-m-d H:i:s");
		  } 
		// save notification
		if ( ! $this->Noti->save( $data, $id )) {
		// if there is an error in inserting user data,	

			// rollback the transaction
			$this->db->trans_rollback();

			// set error title
			$this->data['error'] = get_msg( 'err_model' );
			
			return;
		}
		/** 
		 * Upload Image Records 
		*/
	
		if ( !$id ) {
		// if id is false, this is adding new record

			if ( ! $this->insert_images( $_FILES, 'noti', $data['id'] )) {
			
			}

			
		}
			

			// commit the transaction
		if ( ! $this->check_trans()) {
        	
			// set flash error title
			$this->set_flash_msg( 'error', get_msg( 'err_model' ));
		} else {

			if ( $id ) {
			// if user id is not false, show success_add title
				
				//$this->set_flash_msg( 'success', get_msg( 'success_cat_edit' ));
			} else {
			// if user id is false, show success_edit title

				$this->set_flash_msg( 'success', get_msg( 'success_noti_add' ));
			}
		}

		}

		// $this->data['action_title'] = "Push Notification";
		redirect( $this->module_site_url());
	}

    /**
	* Sending Message From APNS For iOS
	*/
    function send_ios_apns($tokenId, $message) 
	{
		ini_set('display_errors','On'); 
		//error_reporting(E_ALL);
		// Change 1 : No braces and no spaces
		$deviceToken= $tokenId;
		//'fe2df8f5200b3eb133d84f73cc3ea4b9065b420f476d53ad214472359dfa3e70'; 
		// Change 2 : If any
		$passphrase = 'teamps'; 
		$ctx = stream_context_create();
		// Change 3 : APNS Cert File name and location.
		stream_context_set_option($ctx, 'ssl', 'local_cert', realpath('assets').'/apns/psnews_apns_cert.pem'); 
		stream_context_set_option($ctx, 'ssl', 'passphrase', $passphrase);
		// Open a connection to the APNS server
		$fp = stream_socket_client( 
		    'ssl://gateway.sandbox.push.apple.com:2195', $err,
		    $errstr, 60, STREAM_CLIENT_CONNECT|STREAM_CLIENT_PERSISTENT, $ctx);
		if (!$fp)
		    exit("Failed to connect: $err $errstr" . PHP_EOL);
		// Create the payload body
		$body['aps'] = array(
		    'alert' => $message,
		    'sound' => 'default'
		    );
		// Encode the payload as JSON
		$payload = json_encode($body);
		// Build the binary notification
		$msg = chr(0) . pack('n', 32) . pack('H*', $deviceToken) . pack('n', strlen($payload)) . $payload;
		// Send it to the server
		$result = fwrite($fp, $msg, strlen($msg));
		// Close the connection to the server
		fclose($fp);
		if (!$result) 
		    return false;

		return true;
	}

	/**
	 * Delete the record
	 * 1) delete notification
	 * 2) delete image from folder and table
	 * 3) check transactions
	 */
	function delete( $id ) {

		// start the transaction
		$this->db->trans_start();

		// check access
		$this->check_access( DEL );
		
		// delete categories and images
		if ( !$this->ps_delete->delete_noti( $id )) {

			// set error message
			$this->set_flash_msg( 'error', get_msg( 'err_model' ));

			// rollback
			$this->trans_rollback();

			// redirect to list view
			redirect( $this->module_site_url());
		}
			
		/**
		 * Check Transcation Status
		 */
		if ( !$this->check_trans()) {

			$this->set_flash_msg( 'error', get_msg( 'err_model' ));	
		} else {
        	
			$this->set_flash_msg( 'success', get_msg( 'success_noti_delete' ));
		}
		
		redirect( $this->module_site_url());
	}

	/**
	 * Determines if valid input.
	 *
	 * @return     boolean  True if valid input, False otherwise.
	 */
	function is_valid_input( $id = 0 ) 
	{

		$rule = 'required|callback_is_valid_name['. $id  .']';

		$this->form_validation->set_rules( 'message', get_msg( 'message' ), $rule);
		
		if ( $this->form_validation->run() == FALSE ) {
		// if there is an error in validating,

			return false;
		}

		return true;
	}

	/**
	 * Determines if valid name.
	 *
	 * @param      <type>   $name  The  name
	 * @param      integer  $id     The  identifier
	 *
	 * @return     boolean  True if valid name, False otherwise.
	 */
	function is_valid_name( $name, $id = 0 )
	{		
		 $conds['message'] = $name;
			if ( strtolower( $this->Noti->get_one( $id )->message ) == strtolower( $name )) {
			// if the name is existing name for that user id,
				return true;
			} else if ( $this->Noti->exists( ($conds ))) {
			// if the name is existed in the system,
				$this->form_validation->set_message('is_valid_name', get_msg( 'err_dup_name' ));
				return false;
			}
			return true;
	}

	/**
	 * Check category name via ajax
	 *
	 * @param      boolean  $cat_id  The cat identifier
	 */
	function ajx_exists( $id = false )
	{
		// get message
		$name = $_REQUEST['message'];

		if ( $this->is_valid_name( $name, $id )) {
		// if the message is valid,
			
			echo "true";
		} else {
		// if invalid message
			
			echo "false";
		}
	}
}