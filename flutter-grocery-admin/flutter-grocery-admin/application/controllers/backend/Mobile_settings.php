<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Mobile settings Controller
 */


class Mobile_settings extends BE_Controller {
	
	/**
	 * Construt required variables
	 */
	protected $languages = array(
		array('language_code'=> 'en', 'country_code' => 'US', 'name' => 'English'),
		array('language_code'=> 'ar', 'country_code' => 'DZ', 'name' => 'Arabic'),
		array('language_code'=> 'hi', 'country_code' => 'IN', 'name' => 'Hindi'),
		array('language_code'=> 'de', 'country_code' => 'DE', 'name' => 'German'),
		array('language_code'=> 'es', 'country_code' => 'ES', 'name' => 'Spainish'),
		array('language_code'=> 'fr', 'country_code' => 'FR', 'name' => 'French'),
		array('language_code'=> 'id', 'country_code' => 'ID', 'name' => 'Indonesian'),
		array('language_code'=> 'it', 'country_code' => 'IT', 'name' => 'Italian'),
		array('language_code'=> 'ja', 'country_code' => 'JP', 'name' => 'Japanese'),
		array('language_code'=> 'ko', 'country_code' => 'KR', 'name' => 'Korean'),
		array('language_code'=> 'ms', 'country_code' => 'MY', 'name' => 'Malay'),
		array('language_code'=> 'pt', 'country_code' => 'PT', 'name' => 'Portuguese'),
		array('language_code'=> 'ru', 'country_code' => 'RU', 'name' => 'Russian'),
		array('language_code'=> 'th', 'country_code' => 'TH', 'name' => 'Thai'),
		array('language_code'=> 'tr', 'country_code' => 'TR', 'name' => 'Turkish'),
		array('language_code'=> 'zh', 'country_code' => 'CN', 'name' => 'Chinese'),
	);

	function __construct() {

		parent::__construct( MODULE_CONTROL, 'mobile_setting_module' );
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
	 * Load About Entry Form
	 */

	function index( $id = "mb1" ) {

		if ( $this->is_POST()) {
		// if the method is post

			// server side validation
			if ( $this->is_valid_input()) {

				// save user info
				$this->save( $id );
			}
		}

		//Get Mobile_setting Object
		$this->data['app'] = $this->Mobile_setting->get_one( $id );

		$this->data['languages'] = $this->languages;

		$this->load_template( 'mobile_settings/entry_form',$this->data, true );

	}

	/**
	 * Update the existing one
	 */
	function edit( $id = "mb1") {


		// load user
		$this->data['app'] = $this->Mobile_setting->get_one( $id );

		// call the parent edit logic
		parent::mobile_edit( $id );
	}

	/**
	 * Saving Logic
	 * 1) save about data
	 * 2) check transaction status
	 *
	 * @param      boolean  $id  The about identifier
	 */
	function save( $id = false ) {

		// start the transaction
		$this->db->trans_start();
		
		// prepare data for save
		$data = array();

		// lat
		if ( $this->has_data( 'lat' )) {
			$data['lat'] = $this->get_data( 'lat' );
		}

		// lng
		if ( $this->has_data( 'lng' )) {
			$data['lng'] = $this->get_data( 'lng' );
		}

		// google_playstore_url
		if ( $this->has_data( 'google_playstore_url' )) {
			$data['google_playstore_url'] = $this->get_data( 'google_playstore_url' );
		}

		// apple_appstore_url
		if ( $this->has_data( 'apple_appstore_url' )) {
			$data['apple_appstore_url'] = $this->get_data( 'apple_appstore_url' );
		}

		// default_language
		if ( $this->has_data( 'default_language' )) {
			$data['default_language'] = $this->get_data( 'default_language' );
		}

		// exclude language
		$exclude_language = "";
		foreach($this->languages as $language){
			if ( $this->has_data( $language['language_code'] )) {
				continue;
			}else{
				$exclude_language .= $language['language_code'] . ',';
			}
		}
		$data['exclude_language'] = substr($exclude_language, 0, -1);

		// print_r(substr($exclude_language, 0, -1	)); die;
		
		// price_format
		if ( $this->has_data( 'price_format' )) {
			$data['price_format'] = $this->get_data( 'price_format' );
		}

		// date_format
		if ( $this->has_data( 'date_format' )) {
			$data['date_format'] = $this->get_data( 'date_format' );
		}

		// default_order_time
		if ( $this->has_data( 'default_order_time' )) {
			$data['default_order_time'] = $this->get_data( 'default_order_time' );
		}

		// ios_appstore_id
		if ( $this->has_data( 'ios_appstore_id' )) {
			$data['ios_appstore_id'] = $this->get_data( 'ios_appstore_id' );
		}

		// fb_key
		if ( $this->has_data( 'fb_key' )) {
			$data['fb_key'] = $this->get_data( 'fb_key' );
		}

		// default_loading_limit
		if ( $this->has_data( 'default_loading_limit' )) {
			$data['default_loading_limit'] = $this->get_data( 'default_loading_limit' );
		}

		// category_loading_limit
		if ( $this->has_data( 'category_loading_limit' )) {
			$data['category_loading_limit'] = $this->get_data( 'category_loading_limit' );
		}

		// collection_product_loading_limit
		if ( $this->has_data( 'collection_product_loading_limit' )) {
			$data['collection_product_loading_limit'] = $this->get_data( 'collection_product_loading_limit' );
		}

		// discount_product_loading_limit
		if ( $this->has_data( 'discount_product_loading_limit' )) {
			$data['discount_product_loading_limit'] = $this->get_data( 'discount_product_loading_limit' );
		}

		// feature_product_loading_limit
		if ( $this->has_data( 'feature_product_loading_limit' )) {
			$data['feature_product_loading_limit'] = $this->get_data( 'feature_product_loading_limit' );
		}

		// latest_product_loading_limit
		if ( $this->has_data( 'latest_product_loading_limit' )) {
			$data['latest_product_loading_limit'] = $this->get_data( 'latest_product_loading_limit' );
		}

		// trending_product_loading_limit
		if ( $this->has_data( 'trending_product_loading_limit' )) {
			$data['trending_product_loading_limit'] = $this->get_data( 'trending_product_loading_limit' );
		}

		// shop_loading_limit
		if ( $this->has_data( 'shop_loading_limit' )) {
			$data['shop_loading_limit'] = $this->get_data( 'shop_loading_limit' );
		}

		// default_razor_currency
		if ( $this->has_data( 'default_razor_currency' )) {
			$data['default_razor_currency'] = $this->get_data( 'default_razor_currency' );
		}

		// default_flutter_wave_currency
		if ( $this->has_data( 'default_flutter_wave_currency' )) {
			$data['default_flutter_wave_currency'] = $this->get_data( 'default_flutter_wave_currency' );
		}

		// if use_thumbnail_as_placeholder is checked
		if ( $this->has_data( 'is_use_thumbnail_as_placeholder' )) {
			$data['is_use_thumbnail_as_placeholder'] = 1;
		} else {
			$data['is_use_thumbnail_as_placeholder'] = 0;
		}
	
		// if is_show_token_id is checked
		if ( $this->has_data( 'is_show_token_id' )) {
			$data['is_show_token_id'] = 1;
		} else {
			$data['is_show_token_id'] = 0;
		}

		// if is_show_subcategory is checked
		if ( $this->has_data( 'is_show_subcategory' )) {
			$data['is_show_subcategory'] = 1;
		} else {
			$data['is_show_subcategory'] = 0;
		}

		// if is_show_admob is checked
		if ( $this->has_data( 'is_show_admob' )) {
			$data['is_show_admob'] = 1;
		} else {
			$data['is_show_admob'] = 0;
		}

		// if show_facebook_login is checked
		if ( $this->has_data( 'show_facebook_login' )) {
			$data['show_facebook_login'] = 1;
		} else {
			$data['show_facebook_login'] = 0;
		}

		// if show_google_login is checked
		if ( $this->has_data( 'show_google_login' )) {
			$data['show_google_login'] = 1;
		} else {
			$data['show_google_login'] = 0;
		}

		// if show_phone_login is checked
		if ( $this->has_data( 'show_phone_login' )) {
			$data['show_phone_login'] = 1;
		} else {
			$data['show_phone_login'] = 0;
		}

		// if show_main_menu is checked
		if ( $this->has_data( 'show_main_menu' )) {
			$data['show_main_menu'] = 1;
		} else {
			$data['show_main_menu'] = 0;
		}

		// if show_special_collections is checked
		if ( $this->has_data( 'show_special_collections' )) {
			$data['show_special_collections'] = 1;
		} else {
			$data['show_special_collections'] = 0;
		}

		// if show_featured_items is checked
		if ( $this->has_data( 'show_featured_items' )) {
			$data['show_featured_items'] = 1;
		} else {
			$data['show_featured_items'] = 0;
		}

		// if show_best_choice_slider is checked
		if ( $this->has_data( 'show_best_choice_slider' )) {
			$data['show_best_choice_slider'] = 1;
		} else {
			$data['show_best_choice_slider'] = 0;
		}

		// if is_razor_support_multi_currency is checked
		if ( $this->has_data( 'is_razor_support_multi_currency' )) {
			$data['is_razor_support_multi_currency'] = 1;
		} else {
			$data['is_razor_support_multi_currency'] = 0;
		}


		// save mobile config
		if ( ! $this->Mobile_setting->save( $data, $id )) {
		// if there is an error in inserting user data,	

			// rollback the transaction
			$this->db->trans_rollback();

			// set error message
			$this->data['error'] = get_msg( 'err_model' );
			
			return;
		}

		// commit the transaction
		if ( ! $this->check_trans()) {
        	
			// set flash error message
			$this->set_flash_msg( 'error', get_msg( 'err_model' ));
		} else {

			if ( $id ) {
			// if user id is not false, show success_add message
				
				$this->set_flash_msg( 'success', get_msg( 'success_mobile_edit' ));
			} else {
			// if user id is false, show success_edit message

				$this->set_flash_msg( 'success', get_msg( 'success_mobile_add' ));
			}
		}
		
		redirect( site_url('/admin/mobile_settings') );

	}

	 /**
	 * Determines if valid input.
	 *
	 * @return     boolean  True if valid input, False otherwise.
	 */
	function is_valid_input( $id = 0 ) {
 		return true;
	}

}