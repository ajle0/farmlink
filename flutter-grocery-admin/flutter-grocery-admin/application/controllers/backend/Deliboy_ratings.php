<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * deliboys crontroller for BE_deliboyS table
 */
class Deliboy_ratings extends BE_Controller {

    /**
     * Constructs required variables
     */
    function __construct() {
        parent::__construct( MODULE_CONTROL, 'DELIBOY RATINGS' );
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
     * List down the registered deliboys
     */
    function index() {

        //registered deliboys filter
        $conds = array( 'role_id' => 5 );

        $conds['status'] = 1;

        $conds['overall_rating_not'] = 0;


        // get rows count
        $this->data['rows_count'] = $this->Deliboy->count_all_by($conds);

        // get deliboys
        $this->data['deliboys'] = $this->Deliboy->get_all_by($conds, $this->pag['per_page'], $this->uri->segment( 4 ) );

        // load index logic
        parent::deliboy_ratings_index();
    }

    /**
     * Searches for the first match in system deliboys
     */
    function search() {

        // breadcrumb urls
        $data['action_title'] = get_msg( 'deliboy_search' );

        $conds['status'] = 1;


        // condition with search term
        if($this->input->post('submit') != NULL ){

            $conds = array( 'searchterm' => $this->searchterm_handler( $this->input->post( 'searchterm' )));

            if($this->input->post('searchterm') != "") {
                $conds['searchterm'] = $this->input->post('searchterm');
                $this->data['searchterm'] = $this->input->post('searchterm');
                $this->session->set_userdata(array("searchterm" => $this->input->post('searchterm')));
            } else {

                $this->session->set_userdata(array("searchterm" => NULL));
            }
        } else {
            //read from session value
            if($this->session->userdata('searchterm') != NULL){
                $conds['searchterm'] = $this->session->userdata('searchterm');
                $this->data['searchterm'] = $this->session->userdata('searchterm');
            }
        }

        $conds['date'] = $this->input->post( 'date' );

        $conds['role_id'] = 5;
        $conds['overall_rating_not'] = 0;


        $this->data['rows_count'] = $this->Deliboy->count_all_by( $conds );

        $this->data['deliboys'] = $this->Deliboy->get_all_by( $conds, $this->pag['per_page'], $this->uri->segment( 4 ));

        parent::deliboy_ratings_search();
    }


    /**
     * Update the deliboy
     */
    function edit( $user_id ) {

        // breadcrumb
        $this->data['action_title'] = get_msg( 'deliboy_edit' );

        // load deliboy
        $this->data['deliboy'] = $this->Deliboy->get_one( $user_id );

        // call update logic
        parent::deliboy_ratings_edit( $user_id );
    }

}