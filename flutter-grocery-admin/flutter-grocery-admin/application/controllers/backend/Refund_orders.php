<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * Refund_orders Controller
 */
class Refund_orders extends BE_Controller {

    /**
     * Construt required variables
     */
    function __construct() {

        parent::__construct( MODULE_CONTROL, 'Refunded Orders' );
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
    }

    /**
     * List down the registered users
     */
    function index() {

        // no publish filter
        //$conds['no_publish_filter'] = 1;

        $selected_shop_id = $this->session->userdata('selected_shop_id');
        $shop_id = $selected_shop_id['shop_id'];
        $conds['shop_id'] = $shop_id;
        $conds['payment_status'] = 'refunded';

        $this->data['selected_shop_id'] = $shop_id;

        // get rows count
        $this->data['rows_count'] = $this->Transaction_payment->count_all_by($conds);
        // get categories
        $this->data['refunds'] = $this->Transaction_payment->get_all_by( $conds , $this->pag['per_page'], $this->uri->segment( 4 ) );

        // load index logic
        parent::index();
    }

    /**
     * Searches for the first match.
     */
    function search() {


        // breadcrumb urls
        $this->data['action_title'] = get_msg( 'refunded_orders_search' );

        // condition with search term
        if ($this->input->post('submit') != NULL ) {

            $conds = array( 'search_term' => $this->searchterm_handler( $this->input->post( 'search_term' )));

            // condition passing date
            $conds['date'] = $this->input->post( 'date' );

            if($this->input->post('search_term') != "") {
                $conds['search_term'] = $this->input->post('search_term');
                $this->data['search_term'] = $this->input->post('search_term');
                $this->session->set_userdata(array("search_term" => $this->input->post('search_term')));
            } else {

                $this->session->set_userdata(array("search_term" => NULL));
            }

            if($this->input->post('date') != "") {
                $conds['date'] = $this->input->post('date');
                $this->data['date'] = $this->input->post('date');
                $this->session->set_userdata(array("date" => $this->input->post('date')));
            } else {

                $this->session->set_userdata(array("date" => NULL));
            }


            // no publish filter
            $conds['no_publish_filter'] = 1;

        } else {
            //read from session value
            if($this->session->userdata('search_term') != NULL){
                $conds['search_term'] = $this->session->userdata('search_term');
                $this->data['search_term'] = $this->session->userdata('search_term');
            }


            if($this->session->userdata('date') != NULL){
                $conds['date'] = $this->session->userdata('date');
                $this->data['date'] = $this->session->userdata('date');
            }

            // no publish filter
            $conds['no_publish_filter'] = 1;
        }

        $selected_shop_id = $this->session->userdata('selected_shop_id');
        $shop_id = $selected_shop_id['shop_id'];
        $conds['shop_id'] = $shop_id;

        $this->data['selected_shop_id'] = $shop_id;

        // condition passing date
        $conds['date'] = $this->input->post( 'date' );
        $conds['payment_status'] = 'refunded';


        // pagination
        $this->data['rows_count'] = $this->Transaction_payment->count_all_by( $conds );

        // search data
        $this->data['refunds'] = $this->Transaction_payment->get_all_by( $conds, $this->pag['per_page'], $this->uri->segment( 4 ) );

        // load add list
        parent::search();
    }

}