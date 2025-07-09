<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Schedule_orders Controller
 */
class Schedule_orders extends BE_Controller {

	/**
	 * Construt required variables
	 */
	function __construct() {

		parent::__construct( MODULE_CONTROL, 'SCHEDULE ORDERS' );
		///start allow module check by MN
		$selected_shop_id = $this->session->userdata('selected_shop_id');
		$shop_id = $selected_shop_id['shop_id'];
		
		$conds_mod['module_name'] = $this->router->fetch_class();
		$module_id = $this->Module->get_one_by($conds_mod)->module_id;
		
		$logged_in_user = $this->ps_auth->get_user_info();

		$user_id = $logged_in_user->user_id;
		if(empty($this->User->has_permission( $module_id,$user_id )) && $logged_in_user->user_is_sys_admin!=1){
			return redirect( site_url('/admin/dashboard/index/'.$shop_id) );
		}
		///end check

		// load the mail library
		$this->load->library( 'PS_Mail' );
	}

	/**
	 * List down the registered users
	 */
	function index() {
		
		// no publish filter
		$conds['no_publish_filter'] = 1;

		$selected_shop_id = $this->session->userdata('selected_shop_id');
		$shop_id = $selected_shop_id['shop_id'];

		$conds['shop_id'] = $shop_id;

		//show today schedule orders as default
		$current_date = date("Y-m-d"); 

		$timestamp = strtotime($current_date);

		$day = date('D', $timestamp);

		$conds['schedule_day'] = $day;

		// get rows count
		$this->data['rows_count'] = $this->Schedule_header->count_all_by( $conds );
        $_SESSION['trans_rows_count'] = $this->data['rows_count'];

		// get schedule_orders
		$this->data['schedule_orders'] = $this->Schedule_header->get_all_by( $conds , $this->pag['per_page'], $this->uri->segment( 4 ) );

		// load index logic
		parent::index();
	}

	/**
	 * Searches for the first match.
	 */
	function search($status_id = 0) {

		// breadcrumb urls
		$this->data['action_title'] = get_msg( 'schedule_orders_search' );
		
		// condition with search term
		if($this->input->post('submit') != NULL ){

			$conds = array( 'searchterm' => $this->searchterm_handler( $this->input->post( 'searchterm' )));

			// condition passing date
			$date = $this->input->post( 'date' );

			$timestamp = strtotime($date);

			$day = date('D', $timestamp);
			//print_r($day);die;

			$conds['schedule_day'] = $day;

			// no publish filter
			$conds['no_publish_filter'] = 1;

			if($this->input->post('searchterm') != "") {
				$conds['searchterm'] = $this->input->post('searchterm');
				$this->data['searchterm'] = $this->input->post('searchterm');
				$this->session->set_userdata(array("searchterm" => $this->input->post('searchterm')));
			} else {
				
				$this->session->set_userdata(array("searchterm" => NULL));
			}

			if($this->input->post('date') != "") {
				$conds['schedule_day'] = $day;
				$this->data['schedule_day'] = $day;
				$this->session->set_userdata(array("schedule_day" => $day));
			} else {
				
				$this->session->set_userdata(array("schedule_day" => NULL));
			}
		
			if($this->input->post('trans_status_id') != "") {
				$conds['trans_status_id'] = $this->input->post('trans_status_id');
				$this->data['trans_status_id'] = $this->input->post('trans_status_id');
				$this->session->set_userdata(array("trans_status_id" => $this->input->post('trans_status_id')));
			} else {
				
				$this->session->set_userdata(array("trans_status_id" => NULL));
			}
		
		
		} else {
			//$conds['no_publish_filter'] = 1;

			//read from session value
			if($this->session->userdata('searchterm') != NULL){
				//echo "7";die;
				$conds['searchterm'] = $this->session->userdata('searchterm');
				$this->data['searchterm'] = $this->session->userdata('searchterm');
			}
			
			if($this->session->userdata('schedule_day') != NULL){
				$conds['schedule_day'] = $this->session->userdata('schedule_day');
				$this->data['schedule_day'] = $this->session->userdata('schedule_day');
			}
			
			if($this->session->userdata('trans_status_id') != NULL){
				
				$this->data['trans_status_id'] = $this->session->userdata('trans_status_id');
				$conds['trans_status_id'] = $this->session->userdata('trans_status_id');

			} 

		}

		$selected_shop_id = $this->session->userdata('selected_shop_id');
		$shop_id = $selected_shop_id['shop_id'];

		$conds['shop_id'] = $shop_id;
		//print_r($conds);die;
		// pagination
		$this->data['rows_count'] = $this->Schedule_header->count_all_by( $conds );

		// search data
		$this->data['schedule_orders'] = $this->Schedule_header->get_all_by( $conds, $this->pag['per_page'], $this->uri->segment( 4 ) );

		$this->data['selected_shop_id'] = $shop_id;
		
		// load add list
		parent::search();
	}

	/**
	* Update the existing one
	*/
	function edit( $id ) {

		// load user
		$this->data['schedule_order'] = $this->Schedule_header->get_one( $id );

		redirect(site_url('admin/schedule_orders/'));
	}

	/**
	 	* Update the existing one
		*/
	function deliver() {
		

		$id = $this->input->post('schedule_header_id');
		$status_id = $this->input->post('trans_status_id');
		$payment_id = $this->get_data('payment_status_id');
		$delivery_boy_id = $this->get_data( 'delivery_boy_id' );

		//get the existing data from schedule header table
		$conds['id'] = $id;

		$schedule_orders = $this->Schedule_header->get_one_by($conds);
		//print_r($schedule_orders);die;

		//get current date time
		$current_date_time = date("Y-m-d H:i:s");           

		// get login user id
		$logged_in_user = $this->ps_auth->get_user_info();

		$login_user_id = $logged_in_user->user_id;

		//save record at transaction header table when order is delivered

		$trans_header = array(
 			'user_id' 				=> $schedule_orders->user_id,
 			'shop_id' 				=> $schedule_orders->shop_id,
 			'sub_total_amount' 		=> $schedule_orders->sub_total_amount,
 			'tax_amount' 			=> $schedule_orders->tax_amount,
 			'shipping_amount' 		=> $schedule_orders->shipping_amount,
 			'balance_amount' 		=> $schedule_orders->balance_amount,
 			'total_item_amount' 	=> $schedule_orders->total_item_amount,
 			'total_item_count' 	    => $schedule_orders->total_item_count,
 			'contact_name' 		    => $schedule_orders->contact_name,
 			'contact_phone' 		=> $schedule_orders->contact_phone,
 			'contact_email' 		=> $schedule_orders->contact_email,
 			'contact_address' 		=> $schedule_orders->contact_address,
 			'contact_area_id' 		=> $schedule_orders->contact_area_id,
 			'payment_method' 		=> $schedule_orders->payment_method,
 			'trans_status_id' 		=> $status_id,
 			'razor_id' 				=> "",
			'flutter_wave_id' 		=> "",
 			'discount_amount'       => $schedule_orders->discount_amount,
 			'coupon_discount_amount'=> $schedule_orders->coupon_discount_amount,
 			'trans_code'            => $schedule_orders->trans_code,
 			'added_date'            => $current_date_time,
 			'added_user_id'         => $login_user_id,
 			'updated_date'          => $current_date_time,
 			'updated_user_id'       => $login_user_id,
 			'updated_flag'          => "0",
 			'currency_symbol'       => $schedule_orders->currency_symbol,
 			'currency_short_form'   => $schedule_orders->currency_short_form,
			'shipping_tax_percent'  => $schedule_orders->shipping_tax_percent,
			'tax_percent'  			=> $schedule_orders->tax_percent,
			'memo'   				=> $schedule_orders->memo,
			'trans_lat'   			=> $schedule_orders->sch_lat,
			'trans_lng'   			=> $schedule_orders->sch_lng,
			'pick_at_shop'   		=> $schedule_orders->pick_at_shop,
			'payment_status_id'		=> $payment_id,
			'delivery_pickup_date'	=> $schedule_orders->delivery_pickup_date,
		    'delivery_pickup_time'	=> $schedule_orders->delivery_pickup_time,
		    'delivery_boy_id'		=> $delivery_boy_id

 		);

		if( !$this->Transactionheader->save($trans_header) ) {
			// rollback the transaction
			$this->error_response( get_msg( 'err_model' ) );
		} else {
			// save schedule detail at transaction detail table

			$conds_detail['schedule_header_id'] = $id;
			$trans_details = $this->Schedule_detail->get_all_by($conds_detail)->result();
			//print_r($trans_details);die;

			$trans_header_id = $trans_header['id'];

			for($i=0; $i<count($trans_details); $i++) 
			{
				// print_r($trans_details);die;
			       
			    $trans_detail = array(
		       		'shop_id' 						=> $trans_details[$i]->shop_id,
		       		'product_id' 					=> $trans_details[$i]->product_id,
		       		'product_name' 					=> $trans_details[$i]->product_name,
		       		'product_customized_id' 		=> $trans_details[$i]->product_customized_id,
		       		'product_customized_name' 		=> $trans_details[$i]->product_customized_name,
		       		'product_customized_price' 		=> $trans_details[$i]->product_customized_price,
		       		'product_addon_id' 				=> $trans_details[$i]->product_addon_id,
		       		'product_addon_name' 			=> $trans_details[$i]->product_addon_name,
		       		'product_addon_price' 			=> $trans_details[$i]->product_addon_price,
		       		'original_price' 				=> $trans_details[$i]->original_price,
		       		'price' 						=> $trans_details[$i]->price,
		       		'product_color_id' 				=> $trans_details[$i]->product_color_id,
		       		'product_color_code' 			=> $trans_details[$i]->product_color_code,
		       		'qty' 							=> $trans_details[$i]->qty,
		       		'discount_value' 				=> $trans_details[$i]->discount_value,
		       		'discount_percent' 				=> $trans_details[$i]->discount_percent,
		       		'discount_amount' 				=> $trans_details[$i]->discount_amount,
		       		'transactions_header_id' 		=> $trans_header_id,
		       		'added_date' 					=> $current_date_time,
		       		'added_user_id' 				=> $login_user_id,
		       		'updated_date' 					=> $current_date_time,
		       		'updated_user_id' 				=> $login_user_id,
		       		'updated_flag' 					=> "0",
		       		'currency_short_form' 			=> $trans_details[$i]->currency_short_form,
		       		'currency_symbol' 				=> $trans_details[$i]->currency_symbol,
		       		'product_unit' 					=> $trans_details[$i]->product_unit,
		       		'product_unit_value' 			=> $trans_details[$i]->product_unit_value

		       );
			    
			    if ( !$this->Transactiondetail->save( $trans_detail )) {
			        // if error in saving review rating,
			        $this->db->trans_rollback();
			        $this->error_response( get_msg( 'err_model' ) );
			    }

			    //Need to update schedule transaction junction table
				
				$trans_sch['schedule_header_id'] = $id;
				$trans_sch['transactions_header_id'] = $trans_header_id;
				$trans_sch['added_date'] = $current_date_time;

				if ( !$this->Trans_schedule->save( $trans_sch )) {
			          // if error in saving review rating,
			        $this->db->trans_rollback();
			        $this->error_response( get_msg( 'err_model' ) );

			    }


			}
		}

		// //get device token from user
		// $device_token = $this->User->get_one($user_id)->device_token;

		// $device_tokens[] = $device_token;

		// send schedule email to user

		$to_who = "user";
		$subject = get_msg('order_receive_subject');
		send_transaction_order_emails( $trans_header_id, $to_who, $subject );

		redirect(site_url() . "/admin/schedule_orders/detail/" . $id);
	}
    
	/**
	* View Schedule order Detail
	*/
	function detail($id)
	{
		// breadcrumb urls
		$this->data['action_title'] = get_msg( 'sch_detail' );

		$detail = $this->Schedule_header->get_one( $id );
		$this->data['schedule_order'] = $detail;

		$this->load_detail( $this->data );
	}

	/**
	 * Saving Logic
	 * 1) upload image
	 * 2) save attribute
	 * 3) save image
	 * 4) check transaction status
	 *
	 * @param      boolean  $id  The user identifier
	 */
	// function save( $id  = false, $status_id = 0, $payment_id = 0, $delivery_boy_id = 0 ) {
	// 	// save Transaction

	// 	$data['trans_status_id'] = $status_id;
	// 	$data['payment_status_id'] = $payment_id;
	// 	$data['delivery_boy_id'] = $delivery_boy_id;
	// 	$data['updated_date'] = date("Y-m-d H:i:s");

	// 	if ( ! $this->Schedule_header->save( $data, $id )) {
	// 		// if there is an error in inserting user data,	
				
	// 			// rollback the transaction
	// 		$this->db->trans_rollback();

	// 			// set error message
	// 		$this->data['error'] = get_msg( 'err_model' );
				
	// 		return;
	// 		}
	// 		// commit the transaction
	// 		if ( ! $this->check_trans()) {
	        	
	// 			// set flash error message
	// 			$this->set_flash_msg( 'error', get_msg( 'err_model' ));
	// 		} else {

	// 			if ( $id ) {
	// 			// if user id is not false, show success_add message
					
	// 				$this->set_flash_msg( 'success', get_msg( 'success_trans_edit' ));
	// 			}
	// 		}


	// 		redirect(site_url() . "/admin/schedule_orders/detail/" . $id);
	// }

	function filter_from_dashboard($status_id) {
		
		$this->session->set_userdata("trans_status_id", $status_id);

		redirect(site_url() . "/admin/schedule_orders/search");

	}

	/**
	 * Delete the record
	 * 1) delete category
	 * 2) delete image from folder and table
	 * 3) check schedule_orders
	 */
	function delete( $id ) {

		// start the transaction
		$this->db->trans_start();

		// check access
		$this->check_access( DEL );

		// delete categories and images
		$enable_trigger = true; 
		
		if ( !$this->ps_delete->delete_schedule_order( $id, $enable_trigger )) {

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
        	
			$this->set_flash_msg( 'success', get_msg( 'success_trans_delete' ));
		}
		
		redirect( $this->module_site_url());
	}

    function get_all_activetask() {

        // no publish filter
        $conds['no_publish_filter'] = 1;
        $selected_shop_id = $this->session->userdata('selected_shop_id');
        $shop_id = $selected_shop_id['shop_id'];

        $conds['shop_id'] = $shop_id;

        // get rows count
        $old_count = $_SESSION['trans_rows_count'];
        $rows_count = $this->Schedule_header->count_all_by( $conds );

        if ( $old_count < $rows_count) {
            echo 'true';
        }

    }


	/**
	 * Proceed the schedule order
	 */
	function ajx_publish( $id = 0 )
	{
		// check access
		$this->check_access( PUBLISH );
		
		// prepare data
		$schedule_data = array( 'schedule_status'=> 1 );
			
		// save data
		if ( $this->Schedule_header->save( $schedule_data, $id )) {
			echo true;
		} else {
			echo false;
		}
	}
	
	/**
	 * Paused the schedule order
	 */
	function ajx_unpublish( $id = 0 )
	{
		// check access
		$this->check_access( PUBLISH );
		
		// prepare data
		$schedule_data = array( 'schedule_status'=> 0 );
			
		// save data
		if ( $this->Schedule_header->save( $schedule_data, $id )) {
			echo true;
		} else {
			echo false;
		}
	}

	

}