<?php
require_once( APPPATH .'libraries/REST_Controller.php' );


/**
 * REST API for Schedule Header
 */
class Schedule_headers extends API_Controller
{

	/**
	 * Constructs Parent Constructor
	 */
	function __construct()
	{
		parent::__construct( 'Schedule_header' );
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
			$conds['order_by_type'] = "asc";
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

		$this->ps_adapter->convert_schedule_header( $obj );
		
	}

	/**
	* Edit pause schedule order by user from app
	*/

	function update_schedule_order_status_post() 
	{	

		// set the add flag for custom response
		$this->is_add = true;

		if ( !$this->is_valid( $this->create_validation_rules )) {
		// if there is an error in validation,
			
			return;
		}
		
		$id = $this->post('id');
		$data['schedule_status'] = $this->post( 'schedule_status' );


		if( !$this->Schedule_header->save($data,$id) ) {
			// rollback the schedule order
			$this->error_response( get_msg( 'err_model' ), 500);
		}


		if ($this->db->trans_status() === FALSE) {
			$this->db->trans_rollback();
			$this->error_response( get_msg( 'err_model' ), 500);
		} else {
			$this->db->trans_commit();
		}

		$conds1['sch_header_ids'] = $id;

		if ($this->db->trans_status() === FALSE) {
			$this->db->trans_rollback();
			$this->error_response( get_msg( 'err_model' ), 500);
		} else {
			$this->db->trans_commit();
		}

		$schedule_header_obj = $this->Schedule_header->get_all_by($conds1)->result();


		$this->convert_object($schedule_header_obj);

		$this->custom_response($schedule_header_obj);


	}

	/**
	* When user create schedule order from app
	*/
	function add_post() 
	{	

		$schedule_details = $this->post( 'details' );

		for($i=0; $i<count($schedule_details); $i++) 
		{

			//for prd checking unpublish, delete and available
			$product_id = $schedule_details[$i]['product_id'];
			$product_data = $this->Product->get_one($product_id);

			if ( $product_data->is_empty_object == 1 || $product_data->status == 0 || $product_data->is_available == 0 ) {
				$this->error_response( get_msg( 'trans_prd_checkout' ) );
				exit;
			}

			//for shop checking unpublish and delete
			$shop_id = $schedule_details[$i]['shop_id'];
			$shop_data = $this->Shop->get_one($shop_id);

			if ( $shop_data->is_empty_object == 1 || $shop_data->status == 0 ) {
				$this->error_response( get_msg( 'trans_shop_checkout' ) );
				exit;
			}
		}
		$user_id = $this->post( 'user_id' );
		$users = global_user_check($user_id);
		$payment_method = "";
		$cod_result = 0;


		$shop_id = $this->post('shop_id');
		//print_r($shop_id);die;
		//$shop_obj = $this->Shop->get_all()->result();


		//$shop_id = $shop_obj[0]->id;


		if($this->post( 'is_cod' ) == 1) {

			//User Using COD 
			$payment_method = "COD";


			$cod_result = 1;

		} else if($this->post( 'is_pickup' ) == 1) {

			//User Using COD 
			$payment_method = "Pick Up";


			$pickup_result = 1;

		} else {

			//Not selected to payment 
			$this->error_response( get_msg( 'payment_not_select' ) );
		}

		

		if( $cod_result == 1 ) {

			//echo $payment_method; die;

			$this->db->trans_start();

			//First Time
	 		$schedule_row_count = $this->Schedule_header->count_all();
	 		$current_date_month = date("Ym");
	 		$current_date_time = date("Y-m-d H:i:s"); 

	 		$conds['code'] = $current_date_month;
	 		$trans_code_checking =  $this->Code->get_one_by($conds)->code;

	 		$id = false;


	 		if($trans_code_checking == "") {
	 			//New record for this year--mm, need to insert as inside the core_code_generator table
				$data['type']  =  "schedule_order";
		 		$data['code']  =  $today = date("Ym"); ;
		 		$data['count'] = $schedule_row_count + 1;
		 		$data['added_user_id'] = $this->post( 'user_id' );
		 		$data['added_date'] = date("Y-m-d H:i:s"); 
		 		$data['updated_date'] = date("Y-m-d H:i:s"); 
		 		$data['updated_user_id'] = 0;
		 		$data['updated_flag'] = 0;

	 			if( !$this->Code->save($data, $id) ) {
					// rollback the schedule_order
					$this->db->trans_rollback();
					$this->error_response( get_msg( 'err_model' ), 500);
	 			}

	 			// get inserted id
				if ( !$id ) $id = $data['id']; 

				if($id) {
					$trans_code = $this->Code->get_one($id)->code;
				}


				
	 		} else {
	 			//record is already exist so just need to update for count field only
	 			$data['count'] = $schedule_row_count + 1;

	 			$core_code_generator_id =  $this->Code->get_one_by($conds)->id;

	 			if( !$this->Code->save($data, $core_code_generator_id) ) {
					// rollback the schedule order
					$this->db->trans_rollback();
					$this->error_response( get_msg( 'err_model' ), 500);
	 			}

	 			$conds['id'] = $core_code_generator_id;
	 			$trans_code =  $this->Code->get_one_by($conds)->code . ($schedule_row_count + 1);


	 		}

	 		// trans_status_id

	 		$conds_stage['start_stage'] = '1';
			$trans_data = $this->Transactionstatus->get_one_by($conds_stage);
			$trans_status_id = $trans_data->id;
			$payment_status = 1;

			$pre_schedule_days = $this->post( 'schedule_day');
			$pre_schedule_times = $this->post( 'schedule_time' );

			$days = explode(",",$pre_schedule_days);
			$times = explode(",",$pre_schedule_times);
			// print_r($days);die;
			$ids = [];
			$id_check = $this->post('id');
			if($id_check == ""){

				foreach($days as $index => $value) {
				
					$schedule_day = substr($days[$index], 0, 3);
					$schedule_time = $times[$index];

					//Need to save inside schedule order header table 
					$schedule_header = array(
						'user_id' 				=> $this->post( 'user_id' ),
						'shop_id' 				=> $this->post( 'shop_id' ),
						'sub_total_amount' 		=> $this->post( 'sub_total_amount' ),
						'tax_amount' 			=> $this->post( 'tax_amount' ),
						'shipping_amount' 		=> $this->post( 'shipping_amount' ),
						'balance_amount' 		=> $this->post( 'balance_amount' ),
						'total_item_amount' 	=> $this->post( 'total_item_amount' ),
						'total_item_count' 	    => $this->post( 'total_item_count' ),
						'contact_name' 		    => $this->post( 'contact_name' ),
						'contact_phone' 		=> $this->post( 'contact_phone' ),
						'contact_email' 		=> $this->post( 'contact_email' ),
						'contact_address' 		=> $this->post( 'contact_address' ),
						'contact_area_id' 		=> $this->post( 'contact_area_id' ),
						'payment_method' 		=> $payment_method,
						'trans_status_id' 		=> $trans_status_id,
						'discount_amount'       => $this->post( 'discount_amount'),
						'coupon_discount_amount'=> $this->post( 'coupon_discount_amount'),
						'trans_code'            => $trans_code,
						'added_date'            => $current_date_time,
						'added_user_id'         => $this->post( 'user_id' ),
						'updated_date'          => $current_date_time,
						'updated_user_id'       => "0",
						'updated_flag'          => "0",
						'currency_symbol'       => $this->post( 'currency_symbol'),
						'currency_short_form'   => $this->post( 'currency_short_form'),
						'shipping_tax_percent'  => $this->post( 'shipping_tax_percent'),
						'tax_percent'  			=> $this->post( 'tax_percent'),
						'memo'   				=> $this->post( 'memo'),
						'sch_lat'   			=> $this->post( 'sch_lat'),
						'sch_lng'   			=> $this->post( 'sch_lng'),
						'pick_at_shop'   		=> $this->post( 'pick_at_shop'),
						'payment_status_id'		=> $payment_status,
						'delivery_pickup_date'	=> $this->post( 'delivery_pickup_date'),
						'delivery_pickup_time'	=> $this->post( 'delivery_pickup_time'),
						'schedule_day'			=> $schedule_day,
						'schedule_time' 		=> $schedule_time,
						'schedule_status' 		=> $this->post( 'schedule_status' )

					);

					
					$id = $this->post('id');
					//print_r($id);die;

					if ($id == "") {
						//add schedule

						$schedule_header_id = false;

						if( !$this->Schedule_header->save($schedule_header) ) {
							// rollback the schedule order
							$this->error_response( get_msg( 'err_model' ), 500);
						}

						
						$schedule_header_id = $schedule_header['id'];
						array_push($ids,$schedule_header_id);



					} else {
						//edit schedule

						if( !$this->Schedule_header->save($schedule_header,$id) ) {
							// rollback the schedule order
							$this->error_response( get_msg( 'err_model' ), 500);
						}

						$schedule_header_id = $id;
					}

					$schedule_details = $this->post( 'details' );

					// delete the existing shcedule detail by schedule header id
					$conds_sch_header['schedule_header_id'] = $schedule_header_id;
					$this->Schedule_detail->delete_by($conds_sch_header);

					for($i=0; $i<count($schedule_details); $i++) 
					{
						// print_r($schedule_details);die;
						$schedule_detail[ 'shop_id' ]           			= $schedule_details[$i]['shop_id'];
						$schedule_detail[ 'product_id' ]           			= $schedule_details[$i]['product_id'];
						$schedule_detail[ 'product_name' ]                 	= $schedule_details[$i]['product_name'];
						$schedule_detail[ 'product_customized_id' ]        	= $schedule_details[$i]['product_customized_id'];
						$schedule_detail[ 'product_customized_name' ]      	= $schedule_details[$i]['product_customized_name'];
						$schedule_detail[ 'product_customized_price' ]     	= $schedule_details[$i]['product_customized_price'];
						$schedule_detail[ 'product_addon_id' ]         		= $schedule_details[$i]['product_addon_id'];
						$schedule_detail[ 'product_addon_name' ]       		= $schedule_details[$i]['product_addon_name'];
						$schedule_detail[ 'product_addon_price' ]      		= $schedule_details[$i]['product_addon_price'];
						$schedule_detail[ 'original_price' ]               	= $schedule_details[$i]['original_price'];
						$schedule_detail[ 'price' ]                   		= $schedule_details[$i]['unit_price'];
						$schedule_detail[ 'product_color_id' ]             	= $schedule_details[$i]['product_color_id'];
						$schedule_detail[ 'product_color_code' ]           	= $schedule_details[$i]['product_color_code'];
						$schedule_detail[ 'qty' ]                          	= $schedule_details[$i]['qty'];
						$schedule_detail[ 'discount_value' ]               	= $schedule_details[$i]['discount_value'];
						$schedule_detail[ 'discount_percent' ]             	= $schedule_details[$i]['discount_percent'];
						$schedule_detail[ 'discount_amount' ]              	= $schedule_details[$i]['discount_amount'];
						$schedule_detail['schedule_header_id']         		= $schedule_header_id;
						$schedule_detail['added_date']             			= $current_date_time;
						$schedule_detail['added_user_id']          			= $this->post( 'user_id' );
						$schedule_detail['updated_date']           			= $current_date_time;
						$schedule_detail['updated_user_id']        			= "0";
						$schedule_detail['updated_flag']           			= "0";
						$schedule_detail['currency_short_form']            	= $schedule_details[$i]['currency_short_form'];
						$schedule_detail['currency_symbol']           	    = $schedule_details[$i]['currency_symbol'];
						$schedule_detail['product_unit']					= $schedule_details[$i]['product_unit'];
						$schedule_detail['product_unit_value']				= $schedule_details[$i]['product_unit_value'];
						

						if ( !$this->Schedule_detail->save( $schedule_detail )) {
							// if error in saving review rating,
							$this->db->trans_rollback();
							$this->error_response( get_msg( 'err_model' ), 500);
						}

					}
			}
		} else {

			$id = $this->post('id');
			$schedule_header = array(
				'schedule_status' 		=> $this->post( 'schedule_status' )

			);


			if( !$this->Schedule_header->save($schedule_header,$id) ) {
				// rollback the schedule order
				$this->error_response( get_msg( 'err_model' ), 500);
			}

			$schedule_header_id = $id;
			array_push($ids,$schedule_header_id);

		}

			$conds1['sch_header_ids'] = $ids;

			// print_r($ids);die;

			if ($this->db->trans_status() === FALSE) {
	        	$this->db->trans_rollback();
	        	$this->error_response( get_msg( 'err_model' ), 500);
	    	} else {
				$this->db->trans_commit();
			}

			// $schedule_header_obj = $this->Schedule_header->get_one($schedule_header_id);
			$schedule_header_obj = $this->Schedule_header->get_all_by($conds1)->result();

			//Sending Email to shop
			$to_who = "shop";
			$subject = get_msg('order_receive_subject');
			send_schedule_order_emails( $schedule_header_id, $to_who, $subject );

			$to_who = "user";
			$subject = get_msg('order_receive_subject');
			send_schedule_order_emails( $schedule_header_id, $to_who, $subject );

			$this->convert_object($schedule_header_obj);

			$this->custom_response($schedule_header_obj);
	
		}


	}

	/**
	* Delete schedule by user
	*/
	function delete_post(){

		$id = $this->post('id');

		// delete record from schedule header table

		// check id is valid or not

		$sch_data = $this->Schedule_header->get_one($id);

		if($sch_data->is_empty_object == 1){
			$this->error_response( get_msg( 'err_sch_id_not_found' ), 404);
		} else {

			if ($this->Schedule_header->delete($id)) {
			$conds['schedule_header_id'] = $id;

		    if($this->Schedule_detail->delete_by($conds)){
		    	$this->success_response( get_msg( 'success_user_sch_delete' ), 200);
		    } else {
		    	$this->error_response( get_msg( 'err_delete_sch_detail' ), 503);
		    }

			} else {
				$this->error_response( get_msg( 'err_delete_sch' ), 503);
			}

		}
		

		

	}

}