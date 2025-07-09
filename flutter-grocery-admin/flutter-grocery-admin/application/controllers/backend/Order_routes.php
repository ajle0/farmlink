<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Brands Controller
 */
class Order_routes extends BE_Controller {

	/**
	 * Construt required variables
	 */
	function __construct() {

		parent::__construct( MODULE_CONTROL, 'Order Routes' );
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

		// get rows count
		$this->data['rows_count'] = $this->Order_route->count_all_by( $conds );

		//print_r($this->uri->segment( 4 ));die;
		$routes = $this->Order_route->get_all_by( $conds);
		//show today schedule orders as default
		$current_date = date("Y-m-d"); 

		$timestamp = strtotime($current_date);

		$day = date('D', $timestamp);

		foreach($routes->result() as $route){
			
			if($route->updated_flag == 1 && date("Y-m-d") > $route->updated_date){
				
				$conds1['route_id'] = $route->id;
				$sch_orders = $this->Schedule_Order_Route->get_all_by($conds1);
				foreach($sch_orders->result() as $sch_order){
					$sch = $this->Schedule_header->get_one($sch_order->schedule_header_id);
					if($day == $sch->schedule_day){
						$data['updated_flag'] = 0;
						$this->Order_route->save($data, $route->id);
					}
				}
			}
		}

		// get brands
		$this->data['routes'] = $this->Order_route->get_all_by( $conds , $this->pag['per_page'], $this->uri->segment( 4 ) );

		// load index logic
		parent::order_route_index();
	}

	/**
	 * Searches for the first match.
	 */
	function search() {

		// breadcrumb urls
		$this->data['action_title'] = get_msg( 'route_order_search' );
		
		// condition with search term
		if($this->input->post('submit') != NULL ){
			
			$conds = array( 'searchterm' => $this->searchterm_handler( $this->input->post( 'searchterm' )));

			// condition passing date
			$conds['date'] = $this->input->post( 'date' );

			if($this->input->post('searchterm') != "") {
				$conds['searchterm'] = $this->input->post('searchterm');
				$this->data['searchterm'] = $this->input->post('searchterm');
				$this->session->set_userdata(array("searchterm" => $this->input->post('searchterm')));
			} else {
				
				$this->session->set_userdata(array("searchterm" => NULL));
			}

			if($this->input->post('date') != "") {
				$conds['date'] = $this->input->post('date');
				$this->data['date'] = $this->input->post('date');
				$this->session->set_userdata(array("date" => $this->input->post('date')));
			} else {
				
				$this->session->set_userdata(array("date" => NULL));
			}

		} else {

			if($this->session->userdata('searchterm') != NULL){
				$conds['searchterm'] = $this->session->userdata('searchterm');
				$this->data['searchterm'] = $this->session->userdata('searchterm');
			}

			if($this->session->userdata('date') != NULL){
				$conds['date'] = $this->session->userdata('date');
				$this->data['date'] = $this->session->userdata('date');
			}

		}

		// pagination
		$this->data['rows_count'] = $this->Order_route->count_all_by( $conds );

		// search data
		$this->data['routes'] = $this->Order_route->get_all_by( $conds, $this->pag['per_page'], $this->uri->segment( 4 ) );
		
		// load add list
		parent::ord_route_search( );
	}

	/**
	 * Create new one
	 */
	function add() {
		
		$this->data['action_title'] = get_msg( 'order_route_add' );

		//special case
		parent::order_route_add();

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
		
	function save( $id = false ) {
		$need_to_deliver = false;
		if ( $this->has_data( 'deliver_order_route' )) {
			if($id){
				redirect( $this->module_site_url( 'deliver_to_user/' .$id ));
			}else{
				$need_to_deliver = true;
			}
		}

		$data['prdcheck'] = explode(",", $this->get_data( 'newchkval' ));

		$prdcheck = ""; $total_amount = 0;

		if($id == "") {
			//for first time save 
			$prdcheck = $data['prdcheck'][1];
		
		} else {
			//for edit case
			$prdcheck = $data['prdcheck'][0];

		}

		if($prdcheck != "") {

			$logged_in_user = $this->ps_auth->get_user_info();
			$data = array();
				$selected_shop_id = $this->session->userdata('selected_shop_id');

			if($id) {
				$check_count = $this->get_data( 'prdcheck' );
				$edit_route_id = $id;
			}

			// prepare name
			if ( $this->has_data( 'name' )) {
				$data['name'] = $this->get_data( 'name' );
			}

			// prepare delivery_boy_id
			if ( $this->has_data( 'delivery_boy_id' )) {
				$data['delivery_boy_id'] = $this->get_data( 'delivery_boy_id' );
			}

			// prepare note
			if ( $this->has_data( 'note' )) {
				$data['note'] = $this->get_data( 'note' );
			}

			$data['shop_id'] = $selected_shop_id['shop_id'];

			// set timezone
			$data['added_user_id'] = $logged_in_user->user_id;

			//update shop status
			$shop_id = $selected_shop_id['shop_id'];

			if($id == "") {
				//save
				$data['added_date'] = date("Y-m-d H:i:s");
			} else {
				//edit
				unset($data['added_date']);
				$data['updated_date'] = date("Y-m-d H:i:s");
				$data['updated_user_id'] = $logged_in_user->user_id;
			}

			// save route
			if ( ! $this->Order_route->save( $data, $id )) {
			// if there is an error in inserting user data,	

				// rollback the transaction
				$this->db->trans_rollback();

				// set error message
				$this->data['error'] = get_msg( 'err_model' );
				
				return;
			}

			//get inserted collection id
			$id = ( !$id )? $data['id']: $id ;

			// prepare product checkbox
			if ( $id ) {
				$data['prdcheck'] = explode(",", $this->get_data( 'newchkval' ));

				if(!$this->ps_delete->delete_schedule_order_route( $id )) {
				//loop
					for($i=0; $i<count($data['prdcheck']);$i++) {
						if($data['prdcheck'][$i] != "") {
							$check_data['route_id'] = $id;
							$check_data['schedule_header_id'] = $data['prdcheck'][$i];
							$check_data['added_date'] = date("Y-m-d H:i:s");
							$check_data['added_user_id'] = $logged_in_user->user_id;

							$this->Schedule_Order_Route->save($check_data);

							$total_amount += (float)$this->Schedule_header->get_one($check_data['schedule_header_id'])->total_item_amount;
						}

					}
					
					if($total_amount > 0){
						$data1['total_amount'] = $total_amount;
						$this->Order_route->save( $data1, $id);
					}

				}
			
			}

			if($need_to_deliver){
				redirect( $this->module_site_url( 'deliver_to_user/' . $id ));
			}

			// need to update total amout at route

			// commit the transaction
			if ( ! $this->check_trans()) {
	        	
				// set flash error message
				$this->set_flash_msg( 'error', get_msg( 'err_model' ));
			} else {

				if ( $id  ) {
				// if user id is not false, show success_add message
					
					$this->set_flash_msg( 'success', get_msg( 'success_route_edit' ));
				} else {
				// if user id is false, show success_edit message
					
					$this->set_flash_msg( 'success', get_msg( 'success_route_add' ));
				}

				redirect( site_url('/admin/order_routes') );
			}

			redirect( $this->module_site_url());
		} else {
			// set flash error message
			$this->set_flash_msg( 'error', get_msg( 'please_select_order' ) );
			if ( !$id ){
				redirect( site_url() . '/admin/order_routes/add');
			} else {
				redirect( site_url() . '/admin/order_routes/edit/' . $id);
			}
		}

	}

	/**
	 * Determines if valid input.
	 *
	 * @return     boolean  True if valid input, False otherwise.
	 */
	function is_valid_input( $id = 0 ) {

		return true;
	}


	/**
	 * Get schedule orders for route
	 */
	function get_all_schedule_orders_for_route($route_id='000') 
 	{
 	
	 	if ($route_id=='000') {
			// Datatables Variables
			$draw = intval($this->input->get("draw"));
			$start = intval($this->input->get("start"));
			$length = intval($this->input->get("length"));

			$selected_shop_id = $this->session->userdata('selected_shop_id');
			$shop_id = $selected_shop_id['shop_id'];
			$conds['shop_id'] = $shop_id;
		
			//// Start - Filter schedule orders inside other route ////
			$conds2['route_id'] = $route_id;
			$schedule_orders_from_other = $this->Schedule_Order_Route->get_all_not_in_schedule_orders($conds2)->result();

			$result_others = "";
			foreach ($schedule_orders_from_other as $sch_orders) {
				$result_others .= "'".$sch_orders->schedule_header_id ."'" .",";
				
			}

			$schedule_ids_from_other = rtrim($result_others,",");

			$conds['schedule_ids_from_other'] = $schedule_ids_from_other;

			//// End - Filter schedule orders inside other route ///	

			//show today schedule orders as default
			$current_date = date("Y-m-d"); 

			$timestamp = strtotime($current_date);

			$day = date('D', $timestamp);

			$conds['schedule_day'] = $day;
			
			$schedule_ids = $this->Schedule_header->get_all_schedule_orders($conds);

			$schedule_order_data = array();
			$data = array();
			foreach($schedule_ids->result() as $sch) {	

				$schedule_order_data = array();
				$schedule_order_data[] = $sch->id;
				$schedule_order_data[] = $sch->trans_code;
				$schedule_order_data[] = $sch->contact_name;
				$schedule_order_data[] = $sch->contact_phone;
				$schedule_order_data[] = $sch->total_item_count;
				$schedule_order_data[] = $sch->sub_total_amount;
				$schedule_order_data[] = $sch->schedule_status == 1 ? '<span class="badge badge-success">'. get_msg('proceed_label') .'</span>' : '<span class="badge badge-warning">'. get_msg('paused_label') .'</span>';
				$schedule_order_data[] = '<a class="btn btn-primary btn-sm" href="'. $this->module_site_url() . "/detail/" . $sch->id. '">'. get_msg('btn_edit') .'</a>';

				$data[] = $schedule_order_data;

			}
				
			$output = array(
				"draw" => $draw,
				"recordsTotal" => $schedule_ids->num_rows(),
				"recordsFiltered" => $schedule_ids->num_rows(),
				"data" => $data

			);
			echo json_encode($output);
			exit();
	 	} else {
	 		// Datatables Variables
	        $draw = intval($this->input->get("draw"));
	        $start = intval($this->input->get("start"));
	        $length = intval($this->input->get("length"));

	        $selected_shop_id = $this->session->userdata('selected_shop_id');
			$shop_id = $selected_shop_id['shop_id'];
			$conds['shop_id'] = $shop_id;   

			$conds1['route_id'] = $route_id;
			$schedule_order_route = $this->Schedule_Order_Route->get_all_in_schedule_order($conds1)->result();

				  
			//// Start - Filter schedule orders insde current route (To see on top)  ////	
			$result = "";
			foreach ($schedule_order_route as $ord_route) {
				$result .= "'".$ord_route->schedule_header_id ."'" .",";
			}

			$schedule_ids_from_route = rtrim($result,",");

			$conds['schedule_ids_from_route'] = $schedule_ids_from_route;

			//// End - Filter schedule orders insde current route (To see on top)  ////


			//// Start - Filter schedule orders from other route ////

			$conds2['route_id'] = $route_id;
			$schedule_orders_from_other = $this->Schedule_Order_Route->get_all_not_in_schedule_orders($conds2)->result();

			$result_others = "";
			foreach ($schedule_orders_from_other as $ord_route) {
				$result_others .= "'".$ord_route->schedule_header_id ."'" .",";
				  
			}

			$schedule_ids_from_other = rtrim($result_others,",");

			$conds['schedule_ids_from_other'] = $schedule_ids_from_other;

			//// End - Filter schedule order from other route ///	

			
			//show today schedule orders as default
			$current_date = date("Y-m-d"); 
			$timestamp = strtotime($current_date);
			$day = date('D', $timestamp);

			$conds['schedule_day'] = $day;
			
		    $schedule_ids = $this->Schedule_header->get_all_schedule_orders($conds);
			
		    $schedule_order_data = array();
			$data = array();
		    foreach($schedule_ids->result() as $sch) {
				
		        $schedule_order_data = array();
				$schedule_order_data[] = $sch->id;
				$schedule_order_data[] = $sch->trans_code;
				$schedule_order_data[] = $sch->contact_name;
				$schedule_order_data[] = $sch->contact_phone;
				$schedule_order_data[] = $sch->total_item_count;
				$schedule_order_data[] = $sch->sub_total_amount;
				$schedule_order_data[] = $sch->schedule_status == 1 ? '<span class="badge badge-success">'. get_msg('proceed_label') .'</span>' : '<span class="badge badge-warning">'. get_msg('paused_label') .'</span>';
				if($this->Order_route->get_one($route_id)->updated_flag == '1'){
					$schedule_order_data[] = '<a class="btn btn-primary btn-sm disabled" href="'. $this->module_site_url() . "/detail/" . $sch->id.'/'. $route_id .'">' . get_msg("btn_edit") .'</a>';
				}else{
					$schedule_order_data[] = '<a class="btn btn-primary btn-sm" href="'. $this->module_site_url() . "/detail/" . $sch->id.'/'. $route_id .'">' . get_msg("btn_edit") .'</a>';
				}

				$data[] = $schedule_order_data;
		    }

		    $output = array(
              "draw" => $draw,
              "recordsTotal" => $schedule_ids->num_rows(),
              "recordsFiltered" => $schedule_ids->num_rows(),
              "data" => $data

		    );
			
		    echo json_encode($output);
		    exit();

	 	}
	   
 	}

	/**
	* Update the existing one
	*/
	function edit( $id ) {

		// breadcrumb urls
		$this->data['action_title'] = get_msg( 'route_edit' );

		// load user
		$this->data['route'] = $this->Order_route->get_one( $id );

		parent::edit($id);
	}

 	// edit schedule order in route

 	function edit_sch_order( $sch_id )
    {
    	$data = $this->Schedule_header->get_one( $sch_id );
		 
        $output['trans_code'] = $data->trans_code;  
        $date_tmp = $data->added_date;
        $added_date = explode(' ', $date_tmp);
        $output['added_date'] = $added_date[0];
        $user_id = $data->user_id;
        $output['user_name'] = $this->User->get_one($user_id)->user_name;
        $output['user_email'] = $this->User->get_one($user_id)->user_email;
        $output['user_phone'] = $this->User->get_one($user_id)->user_phone;
        $output['user_address'] = $this->User->get_one($user_id)->user_address;
        $output['memo'] = $data->memo;
		$output['sch_lat'] = $data->sch_lat;
		$output['sch_lng'] = $data->sch_lng;

		$conds_detail['schedule_header_id'] = $sch_id;
		$sch_details = $this->Schedule_detail->get_all_by($conds_detail)->result();
		
		for ($i=0; $i <count(sch_details) ; $i++) { 
			$output['prd_name'] = $sch_details[$i]->product_name;
			$output['price'] = $sch_details[$i]->price;
			$output['qty'] = $sch_details[$i]->qty;
			$output['prd_id'] = $sch_details[$i]->product_id;
			
		}

                  
        echo json_encode($output);    
    }

	// update qty from schedule order detail each product
	function update_qty($product_id, $header_id, $route = false) {
		
		$conds['product_id'] = $product_id;
		$conds['schedule_header_id'] = $header_id;
		$update_qty = $this->get_data('qty');

		$sch_data = $this->Schedule_detail->get_one_by($conds);

		$id = $sch_data->id;
		
		if($sch_data->qty_modify == 0){
			$data['qty_modify'] = $sch_data->qty;
		}
		$data['qty'] = $update_qty;

		if($this->Schedule_detail->save($data,$id)){
			
			// update total amount and total count in schedule header
			$sch_header = $this->Schedule_header->get_one($header_id);
			$data_count['total_item_count'] = $sch_header->total_item_count - $sch_data->qty + $update_qty;
			$data_count['sub_total_amount'] = $sch_header->sub_total_amount - ($sch_data->qty * $sch_data->price) + ($update_qty * $sch_data->price);
			$data_count['total_item_amount'] = $data_count['sub_total_amount'] + ($sch_header->tax_amount + $sch_header->shipping_amount + ($sch_header->shipping_amount * $sch_header->shipping_tax_percent)); 
			$data_count['balance_amount'] = $data_count['sub_total_amount'] + ($sch_header->tax_amount + $sch_header->shipping_amount + ($sch_header->shipping_amount * $sch_header->shipping_tax_percent)); 
			$this->Schedule_header->save($data_count,$header_id);

			// update total amount in main route
			$route_id = $this->Schedule_Order_Route->get_one_by(['schedule_header_id' => $header_id])->route_id;
			$total_amount = $this->Order_route->get_one($route_id)->total_amount;
			$total_amount = (float)$total_amount - ($sch_data->qty * $sch_data->price ) + $data_count['sub_total_amount'];
			$data1['total_amount'] = $total_amount;
			$this->Order_route->save($data1, $route_id);

			$this->set_flash_msg( 'success', get_msg( 'success_qty_edit' ));

		}else{
			$this->set_flash_msg( 'error', get_msg( 'err_qty_edit' ));
		}

		if($route){
			$this->data['route_id'] = $route;
		}

		$detail = $this->Schedule_header->get_one( $header_id );
		$this->data['schedule_order'] = $detail;

		// return redirect( site_url() . '/admin/order_routes/detail/' . $header_id, $this->data);

		$this->load_detail( $this->data );
	}

	/**
	* View Schedule order Detail
	*/
	function detail($id, $route_id = false)
	{
		// breadcrumb urls
		$this->data['action_title'] = get_msg( 'order_route_sch_detail' );

		$detail = $this->Schedule_header->get_one( $id );
		$this->data['schedule_order'] = $detail;
		
		if($route_id){
			$this->data['route_id'] = $route_id;
		}

		$this->load_detail( $this->data );
	}
	
	/**
	 * Delete the record
	 * 1) delete order route
	 * 3) check transactions
	 */
	function delete( $id ) 
	{

		// start the transaction
		$this->db->trans_start();

		// check access
		$this->check_access( DEL );

		// delete order route
		$enable_trigger = true; 

		if ( !$this->ps_delete->delete_order_route( $id, $enable_trigger )) {

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
        	
			$this->set_flash_msg( 'success', get_msg( 'success_route_delete' ));
		}
		
		redirect( $this->module_site_url());
	}

	/**
	 * Deliver to user
	 * 1) Save updated_flag = 1
	 * 2) Save transaction
	 * 3) Change transaction status
	 * 4) Send noti to deliboy and user
	 */
	function deliver_to_user($id = false){
		$conds1['updated_flag'] = 1;
		$conds1['updated_date'] = date('Y-m-d H:i:s');

		// get route info 
		$route = $this->Order_route->get_one($id); 
		$delivery_boy_id = $route->delivery_boy_id;
		$status_id = 'trans_sts3e03079b68d8c052480c22d91ca2a0b9';

		//get current date time
		$current_date_time = date("Y-m-d H:i:s");           
	
		// get login user id
		$logged_in_user = $this->ps_auth->get_user_info();
		$login_user_id = $logged_in_user->user_id;

		// check schedule header paused or proceed 
		$deli_send_status = array();

		$schedule_orders = $this->Schedule_Order_Route->get_all_by(['route_id'=> $id]);

		foreach($schedule_orders->result() as $schedule_order){
			
			// save schedule detail at transaction detail table
			$schedule_headers = $this->Schedule_header->get_all_by(['id' => $schedule_order->schedule_header_id]);
			
			foreach($schedule_headers->result() as $schedule_header){

				if($schedule_header->schedule_status == 1 ){
					$deli_send_status[] = "proceed";

					//save record at transaction header table when order is delivered
					$trans_header = array(
						'user_id' 				=> $schedule_header->user_id,
						'shop_id' 				=> $schedule_header->shop_id,
						'sub_total_amount' 		=> $schedule_header->sub_total_amount,
						'tax_amount' 			=> $schedule_header->tax_amount,
						'shipping_amount' 		=> $schedule_header->shipping_amount,
						'balance_amount' 		=> $schedule_header->balance_amount,
						'total_item_amount' 	=> $schedule_header->total_item_amount,
						'total_item_count' 	    => $schedule_header->total_item_count,
						'contact_name' 		    => $schedule_header->contact_name,
						'contact_phone' 		=> $schedule_header->contact_phone,
						'contact_email' 		=> $schedule_header->contact_email,
						'contact_address' 		=> $schedule_header->contact_address,
						'contact_area_id' 		=> $schedule_header->contact_area_id,
						'payment_method' 		=> $schedule_header->payment_method,
						'trans_status_id' 		=> $status_id,
						'razor_id' 				=> "",
						'flutter_wave_id' 		=> "",
						'discount_amount'       => $schedule_header->discount_amount,
						'coupon_discount_amount'=> $schedule_header->coupon_discount_amount,
						'trans_code'            => $schedule_header->trans_code,
						'added_date'            => $current_date_time,
						'added_user_id'         => $login_user_id,
						'updated_date'          => $current_date_time,
						'updated_user_id'       => $login_user_id,
						'updated_flag'          => "0",
						'currency_symbol'       => $schedule_header->currency_symbol,
						'currency_short_form'   => $schedule_header->currency_short_form,
						'shipping_tax_percent'  => $schedule_header->shipping_tax_percent,
						'tax_percent'  			=> $schedule_header->tax_percent,
						'memo'   				=> $schedule_header->memo,
						'trans_lat'   			=> $schedule_header->sch_lat,
						'trans_lng'   			=> $schedule_header->sch_lng,
						'pick_at_shop'   		=> $schedule_header->pick_at_shop,
						'payment_status_id'		=> "1",
						'delivery_pickup_date'	=> $schedule_header->delivery_pickup_date,
						'delivery_pickup_time'	=> $schedule_header->delivery_pickup_time,
						'delivery_boy_id'		=> $delivery_boy_id
		
					);
					

					if( !$this->Transactionheader->save($trans_header) ) {
						// rollback the transaction
						$this->error_response( get_msg( 'err_model' ) );
					} else {
					
						$schedule_details = $this->Schedule_detail->get_all_by(['schedule_header_id' => $schedule_header->id]);
						foreach($schedule_details->result() as $schedule_detail){
							$trans_header_id = $trans_header['id'];
							$trans_detail = array(
								'shop_id' 						=> $schedule_detail->shop_id,
								'product_id' 					=> $schedule_detail->product_id,
								'product_name' 					=> $schedule_detail->product_name,
								'product_customized_id' 		=> $schedule_detail->product_customized_id,
								'product_customized_name' 		=> $schedule_detail->product_customized_name,
								'product_customized_price' 		=> $schedule_detail->product_customized_price,
								'product_addon_id' 				=> $schedule_detail->product_addon_id,
								'product_addon_name' 			=> $schedule_detail->product_addon_name,
								'product_addon_price' 			=> $schedule_detail->product_addon_price,
								'original_price' 				=> $schedule_detail->original_price,
								'price' 						=> $schedule_detail->price,
								'product_color_id' 				=> $schedule_detail->product_color_id,
								'product_color_code' 			=> $schedule_detail->product_color_code,
								'qty' 							=> $schedule_detail->qty,
								'discount_value' 				=> $schedule_detail->discount_value,
								'discount_percent' 				=> $schedule_detail->discount_percent,
								'discount_amount' 				=> $schedule_detail->discount_amount,
								'transactions_header_id' 		=> $trans_header_id,
								'added_date' 					=> $current_date_time,
								'added_user_id' 				=> $login_user_id,
								'updated_date' 					=> $current_date_time,
								'updated_user_id' 				=> $login_user_id,
								'updated_flag' 					=> "0",
								'currency_short_form' 			=> $schedule_detail->currency_short_form,
								'currency_symbol' 				=> $schedule_detail->currency_symbol,
								'product_unit' 					=> $schedule_detail->product_unit,
								'product_unit_value' 			=> $schedule_detail->product_unit_value
		
							);
							
							if ( !$this->Transactiondetail->save( $trans_detail )) {
								// if error in saving review rating,
								$this->db->trans_rollback();
								$this->error_response( get_msg( 'err_model' ) );
							}

							//Need to update order route transaction junction table
							$trans_sch['route_id'] = $id;
							$trans_sch['schedule_header_id'] = $schedule_header->id;
							$trans_sch['transactions_header_id'] = $trans_header_id;
							$trans_sch['added_date'] = $current_date_time;
							
							if ( !$this->Trans_schedule->save( $trans_sch )) {
								// if error in saving review rating,
								$this->db->trans_rollback();
								$this->error_response( get_msg( 'err_model' ) );
							}

							if($schedule_detail->qty_modify != 0){
								$data_detail['qty_modify'] = 0;
								$data_detail['qty'] = $schedule_detail->qty_modify;
								
								$data['total_item_count'] = $schedule_header->total_item_count - $schedule_header->qty + $sch_header->qty_modify;
								$data['sub_total_amount'] = $sch_header->sub_total_amount - ($schedule_detail->qty * $schedule_detail->price) + ($schedule_detail->qty_modify * $schedule_detail->price);
								$data['total_item_amount'] = $data['sub_total_amount'] + ($schedule_header->tax_amount + $schedule_header->shipping_amount + ($schedule_header->shipping_amount * $schedule_header->shipping_tax_percent)); 
								$data['balance_amount'] = $data['sub_total_amount'] + ($schedule_header->tax_amount + $schedule_header->shipping_amount + ($schedule_header->shipping_amount * $schedule_header->shipping_tax_percent)); 
								
								$this->Schedule_detail->save($data_detail, $schedule_detail->id);
								$this->Schedule_header->save($data,$schedule_header->id);
							}

						}

						//// Start - Send Noti /////
						$message = get_msg('sch_order_arrive_soon') ;

						$data['message'] = $message;
						$data['flag'] = "transaction";
						$data['trans_header_id'] = $trans_header_id;

						$devices = $this->Notitoken->get_all_device_in($id)->result();

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

						//// End - Send Noti /////


						// send schedule email to user
						$to_who = "user";
						$subject = get_msg('order_receive_subject');
						send_transaction_order_emails( $trans_header_id, $to_who, $subject ) ;
						

						//Sending Email to shop
						$to_who = "shop";
						$subject = get_msg('order_receive_subject');
						send_transaction_order_emails( $trans_header_id, $to_who, $subject );

					}
				}else{
					$deli_send_status[] = 'paused';
				}
			}
		}
		
		if(in_array('proceed', $deli_send_status)){
			
			$this->Order_route->save($conds1, $id);

			//// Start - Send Noti to Delivery Boy/////
			$message = "You have the order to deliver to " . $route->name ;

			$data['message'] = $message;
			$data['flag'] = "route_order";
			$data['route_id'] = $id;


			//// Start - Send Noti to Delivery Boy /////
			$message = get_msg('deliver_order_receive') ." " . $route->name ;

			$data['message'] = $message;
			$data['flag'] = "route_order";
			$data['route_id'] = $id;

			$devices = $this->Notitoken->get_all_device_in($id)->result();

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

			//// End - Send Noti to Delivery Boy/////


			$this->set_flash_msg( 'success', get_msg( 'success_route_order_send' ));
		}else{
			$this->set_flash_msg( 'error', get_msg( 'paused_all_route' ));
		}

		redirect( $this->module_site_url());
	}
    
}