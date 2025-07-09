<?php
defined('BASEPATH') OR exit('No direct script access allowed');

/**
 * User Model for core_USERS table
 */
class Deliboy extends PS_Model {

    // table name for module
    protected $module_table_name;

    // table name for permission
    protected $permission_table_name;

    // table name for role access
    protected $role_access_table_name;

    /**
     * Constructs the required data
     */
    function __construct()
    {
        parent::__construct( 'core_users', 'user_id', 'usr' );

        // initialize table names
        $this->module_table_name = "core_modules";
        $this->permission_table_name = "core_permissions";
        $this->role_access_table_name = "core_role_access";
    }

    /**
     * Implement the where clause
     *
     * @param      array  $conds  The conds
     */
    function custom_conds( $conds = array())
    {

        // status condition
        if ( isset( $conds['status'] )) {
            $this->db->where( 'status', $conds['status'] );
        } else {
            //$this->db->where( 'status', 1 );
        }
        if ( isset( $conds['status_not'] )) {
            $this->db->where( 'status !=', $conds['status_not'] );
        }


        // user_id condition
        if ( isset( $conds['user_id'] )) {
            $this->db->where( $this->primary_key, $conds['user_id'] );
        }

        // system_role_id condition
        if ( isset( $conds['system_role_id'] )) {
            $this->db->where( 'role_id !=', $conds['system_role_id'] );
        }

        // normal_role_id condition
        if ( isset( $conds['register_role_id'] )) {
            $this->db->where( 'role_id', $conds['register_role_id'] );
        }

        // deli_role_id condition
        if ( isset( $conds['deli_role_id'] )) {
            $this->db->where( 'role_id !=', $conds['deli_role_id'] );
        }

        // role_id condition
        if ( isset( $conds['role_id'] )) {
            $this->db->where( 'role_id', $conds['role_id'] );
        }

        // user_email condition
        if ( isset( $conds['user_email'] )) {
            $this->db->where( 'user_email', $conds['user_email'] );
        }

        // user_name condition
        if ( isset( $conds['user_name'] )) {
            $this->db->where( 'user_name', $conds['user_name'] );
        }

        // user_phone condition
        if ( isset( $conds['user_phone'] )) {
            $this->db->where( 'user_phone', $conds['user_phone'] );
        }

        // user_pass condition
        if ( isset( $conds['user_password'] )) {
            $this->db->where( 'user_password', md5( $conds['user_password'] ));
        }

        // searchterm
        // if ( isset( $conds['searchterm'] )) {
        // 	$this->db->like( 'user_name', $conds['searchterm'] );
        // 	$this->db->or_like( 'user_email', $conds['searchterm'] );
        // }

        // // searchterm
        // if ( isset( $conds['searchterm'] )) {
        // 	$this->db->like( 'user_email', $conds['searchterm'] );
        // 	$this->db->or_like( 'user_email', $conds['searchterm'] );
        // }

        // user_is_sys_admin condition
        if ( isset( $conds['user_is_sys_admin'] )) {
            $this->db->where( 'user_is_sys_admin', $conds['user_is_sys_admin'] );
        }

        // is_banned condition
        if ( isset( $conds['is_banned'] )) {
            $this->db->where( 'is_banned', $conds['is_banned'] );
        }

        // code condition
        if ( isset( $conds['code'] )) {
            $this->db->where( 'code', $conds['code'] );
        }

        // country_id condition
        if ( isset( $conds['country_id'] )) {
            $this->db->where( 'country_id', $conds['country_id'] );
        }

        // city_id condition
        if ( isset( $conds['city_id'] )) {
            $this->db->where( 'city_id', $conds['city_id'] );
        }

        // google_id condition
        if ( isset( $conds['google_id'] )) {
            $this->db->where( 'google_id', $conds['google_id'] );
        }

        // facebook_id condition
        if ( isset( $conds['facebook_id'] )) {
            $this->db->where( 'facebook_id', $conds['facebook_id'] );
        }

        // phone_id condition
        if ( isset( $conds['phone_id'] )) {
            $this->db->where( 'phone_id', $conds['phone_id'] );
        }

        if ( isset( $conds['searchterm'] ) || isset( $conds['date'] ) ) {
            $dates = $conds['date'];

            if ($dates != "") {
                $vardate = explode('-',$dates,2);

                $temp_mindate = $vardate[0];
                $temp_maxdate = $vardate[1];

                $temp_startdate = new DateTime($temp_mindate);
                $mindate = $temp_startdate->format('Y-m-d');

                $temp_enddate = new DateTime($temp_maxdate);
                $maxdate = $temp_enddate->format('Y-m-d');
            } else {
                $mindate = "";
                $maxdate = "";
            }

            if ($conds['searchterm'] == "" && $mindate != "" && $maxdate != "") {
                //got 2dates
                if ($mindate == $maxdate ) {

                    $this->db->where("core_users.updated_date BETWEEN DATE('".$mindate."') AND DATE('". $maxdate."' + INTERVAL 1 DAY)");

                } else {

                    $today_date = date('Y-m-d');
                    if($today_date == $maxdate) {
                        $current_time = date('H:i:s');
                        $maxdate = $maxdate . " ". $current_time;
                    }

                    $this->db->where( 'date(core_users.updated_date) >=', $mindate );
                    $this->db->where( 'date(core_users.updated_date) <=', $maxdate );

                }
                $this->db->like( '(user_name', $conds['searchterm'] );
                $this->db->or_like( 'user_name)', $conds['searchterm'] );
            } else if ($conds['searchterm'] != "" && $mindate != "" && $maxdate != "") {
                //got name and 2dates
                if ($mindate == $maxdate ) {

                    $this->db->where("core_users.updated_date BETWEEN DATE('".$mindate."') AND DATE('". $maxdate."' + INTERVAL 1 DAY)");

                } else {

                    $today_date = date('Y-m-d');
                    if($today_date == $maxdate) {
                        $current_time = date('H:i:s');
                        $maxdate = $maxdate . " ". $current_time;
                    }

                    $this->db->where( 'date(core_users.updated_date) >=', $mindate );
                    $this->db->where( 'date(core_users.updated_date) <=', $maxdate );

                }
                $this->db->group_start();
                $this->db->like( 'user_name', $conds['searchterm'] );
                $this->db->or_like( 'user_name', $conds['searchterm'] );
                $this->db->group_end();
            } else {
                //only name
                $this->db->group_start();
                $this->db->like( 'user_name', $conds['searchterm'] );
                $this->db->or_like( 'user_name', $conds['searchterm'] );
                $this->db->group_end();
            }

        }

        // overall_rating not zero

        if ( isset( $conds['overall_rating_not'] )) {
            $this->db->where( 'overall_rating !=', $conds['overall_rating_not'] );
            $this->db->order_by( 'overall_rating', 'desc' );
        }

        // overall_rating sorting
        if ( isset( $conds['overall_rating'] )) {
            if ($conds['overall_rating'] == 'desc') {
                $this->db->order_by( 'overall_rating', 'desc' );
            }
        }
    }

}