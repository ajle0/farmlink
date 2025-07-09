<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Categories Controller
 */
class Categories extends BE_Controller {

	/**
	 * Construt required variables
	 */
	function __construct() {

		parent::__construct( MODULE_CONTROL, 'CATEGORIES' );
		$this->load->library('uploader');
		$this->load->library('csvimport');
		///start allow module check by MN
		$selected_shop_id = $this->session->userdata('selected_shop_id');
		$shop_id = (is_array($selected_shop_id) && isset($selected_shop_id['shop_id'])) ? $selected_shop_id['shop_id'] : null;
		
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
	 * List down the registered users
	 */
	function index() {
		
		// no delete flag
		// no publish filter
		$conds['no_publish_filter'] = 1;
		
		// get rows count
		$this->data['rows_count'] = $this->Category->count_all_by( $conds );

		// get categories
		$this->data['categories'] = $this->Category->get_all_by( $conds , $this->pag['per_page'], $this->uri->segment( 4 ) );

		// load index logic
		parent::catlist();
	}

	/**
	 * Searches for the first match.
	 */
	function search() {
		

		// breadcrumb urls
		$this->data['action_title'] = get_msg( 'cat_search' );
		
		// condition with search term
		$conds = array( 'searchterm' => $this->searchterm_handler( $this->input->post( 'searchterm' )) );
		// no publish filter
		$conds['no_publish_filter'] = 1;

		$selected_shop_id = $this->session->userdata('selected_shop_id');
		$shop_id = $selected_shop_id['shop_id'];

		$conds['shop_id'] = $shop_id;


		// pagination
		$this->data['rows_count'] = $this->Category->count_all_by( $conds );

		// search data

		$this->data['categories'] = $this->Category->get_all_by( $conds, $this->pag['per_page'], $this->uri->segment( 4 ) );
		
		// load add list
		parent::catsearch();
	}

	/**
	 * Create new one
	 */
	function add() {

		// breadcrumb urls
		$this->data['action_title'] = get_msg( 'cat_add' );

		// call the core add logic
		parent::catadd();
	}

	
	/**
	 * Saving Logic
	 * 1) upload image
	 * 2) save category
	 * 3) save image
	 * 4) check transaction status
	 *
	 * @param      boolean  $id  The user identifier
	 */
	function save( $id = false ) {

		// start the transaction
		$this->db->trans_start();
		$logged_in_user = $this->ps_auth->get_user_info();
		
		/** 
		 * Insert Category Records 
		 */
		$data = array();

		// prepare cat name
		if ( $this->has_data( 'name' )) {
			$data['name'] = $this->get_data( 'name' );
		}

		// prepare category order
		if ( $this->has_data( 'ordering' )) {
			$data['ordering'] = $this->get_data( 'ordering' );
		}

		// if 'status' is checked,
		if ( $this->has_data( 'status' )) {
			$data['status'] = 1;
		} else {
			$data['status'] = 0;
		}
		
		// set timezone
		$data['added_user_id'] = $logged_in_user->user_id;

		if($id == "") {
			//save
			$data['added_date'] = date("Y-m-d H:i:s");
		} else {
			//edit
			unset($data['added_date']);
			$data['updated_date'] = date("Y-m-d H:i:s");
			$data['updated_user_id'] = $logged_in_user->user_id;
		}
		//save category
		if ( ! $this->Category->save( $data, $id )) {
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
			if ( ! $this->insert_images_icon_and_cover( $_FILES, 'category', $data['id'], "cover" )) {
				// if error in saving image

				// commit the transaction
				$this->db->trans_rollback();
				
				return;
			}


			if ( ! $this->insert_images_icon_and_cover( $_FILES, 'category-icon', $data['id'], "icon" )) {
			// if error in saving image

				// commit the transaction
				$this->db->trans_rollback();
				
				return;
			}
		
		}

		/** 
		 * Check Transactions 
		 */

		// commit the transaction
		if ( ! $this->check_trans()) {
        	
			// set flash error message
			$this->set_flash_msg( 'error', get_msg( 'err_model' ));
		} else {

			if ( $id ) {
			// if user id is not false, show success_add message
				
				$this->set_flash_msg( 'success', get_msg( 'success_cat_edit' ));
			} else {
			// if user id is false, show success_edit message

				$this->set_flash_msg( 'success', get_msg( 'success_cat_add' ));
			}
		}

		redirect( $this->module_site_url());
	}

	/**
 	* Update the existing one
	*/
	function edit( $id ) 
	{

		// breadcrumb urls
		$this->data['action_title'] = get_msg( 'cat_edit' );

		// load user
		$this->data['category'] = $this->Category->get_one( $id );

		// call the parent edit logic
		parent::catedit( $id );

	}

	/**
	 * Delete the record
	 * 1) delete category
	 * 2) delete image from folder and table
	 * 3) check transactions
	 */
	function delete( $category_id ) {

		// start the transaction
		$this->db->trans_start();

		// check access
		$this->check_access( DEL );

		// delete categories and images
		$enable_trigger = true; 
		
		// delete categories and images
		$type = "category";
		//if ( !$this->ps_delete->delete_category( $category_id, $enable_trigger )) {
		if ( !$this->ps_delete->delete_history( $category_id, $type, $enable_trigger )) {

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
        	
			$this->set_flash_msg( 'success', get_msg( 'success_cat_delete' ));
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

		$this->form_validation->set_rules( 'name', get_msg( 'name' ), $rule);
		
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
	function is_valid_name( $name, $id = 0, $shop_id = 0 )
	{		
		 $conds['name'] = $name;
		 $selected_shop_id = $this->session->userdata('selected_shop_id');
		 $shop_id = $selected_shop_id['shop_id'];
		 $conds['shop_id'] = $shop_id;

			if ( strtolower( $this->Category->get_one( $id )->name ) == strtolower( $name )) {
			// if the name is existing name for that user id,
				return true;
			} else if ( $this->Category->exists( ($conds ))) {
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
		// get category name
		$cat_name = $_REQUEST['name'];

		//get shop_id
		$selected_shop_id = $this->session->userdata('selected_shop_id');
		$shop_id = $selected_shop_id['shop_id'];

		if ( $this->is_valid_name( $cat_name, $id, $shop_id )) {
		// if the category name is valid,
			
			echo "true";
		} else {
		// if invalid category name,
			
			echo "false";
		}
	}

	/**
	 * Publish the record
	 *
	 * @param      integer  $category_id  The category identifier
	 */
	function ajx_publish( $category_id = 0 )
	{
		// check access
		$this->check_access( PUBLISH );
		
		// prepare data
		$category_data = array( 'status'=> 1 );
			
		// save data
		if ( $this->Category->save( $category_data, $category_id )) {
			echo true;
		} else {
			echo false;
		}
	}
	
	/**
	 * Unpublish the records
	 *
	 * @param      integer  $category_id  The category identifier
	 */
	function ajx_unpublish( $category_id = 0 )
	{
		// check access
		$this->check_access( PUBLISH );
		
		// prepare data
		$category_data = array( 'status'=> 0 );
			
		// save data
		if ( $this->Category->save( $category_data, $category_id )) {
			echo true;
		} else {
			echo false;
		}
	}

	function upload() {
		
		if ( $this->is_POST()) {


		$file = $_FILES['file']['name'];
		
		$ext = substr(strrchr($file, '.'), 1);
		//print_r($ext); die;
		



        if(strtolower($ext) == "csv") {

        	 	$upload_data = $this->uploader->upload($_FILES);
				
				if (!isset($upload_data['error'])) {
					foreach ($upload_data as $upload) {
						
						$file_data = $this->upload->data();
		            	$file_path =  './uploads/'.$file_data['file_name'];
		            	if ($this->csvimport->get_array($file_path)) {

							//get data from imported csv file
			                $csv_array = $this->csvimport->get_array($file_path);

			                $i = 0; $s = 0; $f=0;
			                $fail_records = "";
			                foreach ($csv_array as $row) {
			                    
			                

			                     if($row['cat_name'] || $row['photo_name']) {
			                     	// print_r($row['photo_name']); die;

			                     	//Get Category Id 
			                     	$conds_cat['cat_name'] = trim($row['cat_name']);
									$cat_name =  trim($row['cat_name']);
									// print_r($cat_name); die;
									//Get Image Info 

									$data_img = getimagesize(base_url() . "uploads/" . $row['photo_name']);

									$data_icon = getimagesize(base_url() . "uploads/" . $row['icon_name']);

									
									if( count($data_img) != 1) {

										$data = getimagesize(base_url() . "uploads/" . $row['photo_name']);
										$img_width_cover = $data[0];
										$img_height_cover = $data[1];

									} 

									
									if( count($data_icon) != 1) {

										$data = getimagesize(base_url() . "uploads/" . $row['icon_name']);
										$img_width_icon = $data[0];
										$img_height_icon = $data[1];

									} 
									

									if( count($data_img) != 1 ) {
										
										if( count($data_icon) != 1 ) {
										
										
										//Wallpaper must have category
										if($cat_name != "") {

											$data = array(
												
												'name'     		=>	trim($row['cat_name']),
												'status'   			=>  trim($row['status']),
											
											);

												$id = 0;
												
												if($this->Category->save($data, $id)) {
							                    	
														$id = ( !$id )? $data['id']: $id ;
														// print_r($data['id']); die();
														$image = array(

															'img_parent_id' => $id,
															'img_type' 		=> "category",
															'img_desc' => "",
															'img_path' 		=> trim($row['photo_name']),
															'img_width'     => $img_width_cover,
															'img_height'    => $img_height_cover
														);

														//cover photo path
														$path = "uploads/" . $row['photo_name'];
														$this->ps_image->create_thumbnail($path);

														$image_icon = array(

															'img_parent_id' => $id,
															'img_type' 		=> "category-icon",
															'img_desc' => "",
															'img_path' 		=> trim($row['icon_name']),
															'img_width'     => $img_width_icon,
															'img_height'    => $img_height_icon
														);

														//icon photo path
														$path_icon = "uploads/" . $row['icon_name'];
														$this->ps_image->create_thumbnail($path_icon);
														$this->Image->save($image_icon);
														
								                    	if($this->Image->save($image)) {
							                    		//both success

							                    		$s++;	

							                    	}

							                    } else {
							                    	$f++;
						                			$fail_records .= " - " . $row['cat_name'] . " " . get_msg('because_db_err') . "<br>";
							                    }


											} else {
												//Category Missing
												$f++;
					                			$fail_records .= " - " . $row['cat_name'] . " " . get_msg('because_miss_cat') ."<br>";
											}	

										} else {
											//thumbnail missing 
											$f++;
				                			$fail_records .= " - " . $row['cat_name'] . " " . get_msg('because_miss_cat_thumb_upload') ."<br>";
										} 


									} else {
										//image at uploads missing 
										$f++;
				                			$fail_records .= " - " . $row['cat_name'] . " ". get_msg("because_miss_cat_upload") . "<br>";
									}


				                    
			                	} else {
			                		$f++;
			                		$fail_records .= " - " . $row['cat_name'] . " " . get_msg("because_miss_cat_name") . "<br>";
			                	}



			                	$i++;

			                }

			                $result_str = get_msg('total_cat') . $i . "<br>";
			                $result_str .= get_msg('success_cat') . $s . "<br>";
			                $result_str .= get_msg('fail_cat') . $f .  "<br>" . $fail_records;
			                
			                // print_r($result_str); die;

			                $this->data['message'] = $result_str;
			                $this->set_flash_msg( 'success', $result_str);

			            	redirect( $this->module_site_url());
							

			                //$this->session->set_flashdata('success', $result_str);

			                //$content['content'] = $this->load->view('items/import_items',$data,true);		
							//$this->load_template($content, false);

			            } else {

			            	//echo "Something wrong in your uploaded data.";
			                
			            	$this->set_flash_msg( 'error', get_msg( 'something_wrong_upload' ));

			            	redirect( $this->module_site_url());

			    //             $data['error'] = "Something wrong in your uploaded data.";
			    //             $this->session->set_flashdata('error', $data['error']);
			    //              $content['content'] = $this->load->view('items/import_items',$data,true);		
							// $this->load_template($content, false);
			            }


					}
				} else {
					// $data['error'] = $upload_data['error'];

					// $this->session->set_flashdata('error', $data['error']);
		   //          $content['content'] = $this->load->view('items/import_items',$data,true);		
					// $this->load_template($content, false);

					//print_r($upload_data['error']);

					$this->set_flash_msg( 'error', $upload_data['error']);

					redirect( $this->module_site_url());
				}

        } else {

        	//print_r('Please upload CSV file only.');

        	$this->set_flash_msg( 'error',  get_msg( 'pls_upload_csv' ));

			redirect( $this->module_site_url());

   //          $this->session->set_flashdata('error', 'Please upload CSV file only.');

   //          $content['content'] = $this->load->view('items/import_items',$data,true);		
			// $this->load_template($content, false);

        }



		} else {
			redirect( $this->module_site_url());
		}
		

	}

}