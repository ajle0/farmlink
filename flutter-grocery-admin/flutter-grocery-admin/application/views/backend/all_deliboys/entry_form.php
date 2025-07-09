<?php
$attributes = array('id' => 'user-form');
echo form_open( '', $attributes );
?>

    <div class="container-fluid">
        <div class="col-12"  style="padding: 30px 20px 20px 20px;">
            <?php flash_msg(); ?>
            <div class="card earning-widget">
                <div class="card-header" style="border-top: 2px solid red;">
                    <h3 class="card-title"><?php echo get_msg('user_info')?></h3>
                </div>

                <div class="card-body">
                    <div class="row">
                        <div class="col-md-6">
                            <div class="form-group">
                                <label><?php echo get_msg('user_name'); ?></label>
                                <?php echo form_input( array(
                                    'name' => 'user_name',
                                    'value' => set_value( 'user_name', show_data( @$deliboy->user_name ), false ),
                                    'class' => 'form-control form-control-sm',
                                    'placeholder' => get_msg( 'user_name' ),
                                    'id' => 'user_name',
                                    'readonly' => "true"
                                )); ?>
                            </div>
                            <div class="form-group">
                                <label><?php echo get_msg('user_email'); ?></label>
                                <?php echo form_input( array(
                                    'name' => 'user_email',
                                    'value' => set_value( 'user_email', show_data( @$deliboy->user_email ), false ),
                                    'class' => 'form-control form-control-sm',
                                    'placeholder' => get_msg( 'user_email' ),
                                    'id' => 'user_email',
                                    'readonly' => "true"
                                )); ?>
                            </div>

                            <div class="form-group">
                                <label><?php echo get_msg('phone_label'); ?></label>
                                <?php echo form_input( array(
                                    'name' => 'user_phone',
                                    'value' => set_value( 'user_phone', show_data( @$deliboy->user_phone ), false ),
                                    'class' => 'form-control form-control-sm',
                                    'placeholder' => get_msg( 'phone_label' ),
                                    'id' => 'user_phone',
                                    'readonly' => "true"
                                )); ?>
                            </div>

                            <div class="form-group">
                                <label><?php echo get_msg('rating_by_how_many_people'); ?></label>
                                <?php
                                $conds['to_user_id'] = $deliboy->user_id;
                                $rating_count = $this->Deliboy_Rate->count_all_by($conds);

                                echo form_input( array(
                                    'name' => 'rating_count',
                                    'value' => set_value( 'rating_count', show_data( @$rating_count ), false ),
                                    'class' => 'form-control form-control-sm',
                                    'placeholder' => get_msg( 'rating_by_how_many_people' ),
                                    'id' => 'rating_count',
                                    'readonly' => "true"
                                ));
                                ?>
                            </div>
                        </div>

                        <div class="col-md-6">
                            <div class="form-group">
                                <label><?php echo get_msg('address_label'); ?></label>
                                <?php echo form_input( array(
                                    'name' => 'user_address',
                                    'value' => set_value( 'user_address', show_data( @$deliboy->user_address ), false ),
                                    'class' => 'form-control form-control-sm',
                                    'placeholder' => get_msg( 'address_label' ),
                                    'id' => 'user_address',
                                    'readonly' => "true"
                                )); ?>
                            </div>

                            <div class="form-group">
                                <label><?php echo get_msg('about_me'); ?></label>
                                <?php echo form_input( array(
                                    'name' => 'user_about_me',
                                    'value' => set_value( 'user_about_me', show_data( @$user->user_about_me ), false ),
                                    'class' => 'form-control form-control-sm',
                                    'placeholder' => get_msg( 'about_me' ),
                                    'id' => 'user_about_me',
                                    'readonly' => "true"
                                )); ?>
                            </div>

                            <div class="form-group">
                                <label><?php echo get_msg('overall_rating'); ?></label><br>
                                <?php
                                $rating = $deliboy->overall_rating;

                                for( $x = 0; $x < 5; $x++ )
                                {
                                    if( floor( $rating )-$x >= 1 )
                                    { echo '<i class="fa fa-star" style="color: orange; padding-right : 1px;"></i>'; }
                                    elseif( $rating-$x > 0 )
                                    { echo '<i class="fa fa-star-half-o" style="color: orange; padding-right : 1px;"></i>'; }
                                    else
                                    { echo '<i class="fa fa-star-o" style="color: orange; padding-right : 1px;"></i>'; }
                                }
                                ?>
                            </div>

                            <div class="form-group">
                                <label>
                                    <?php echo get_msg('review_label')?>
                                </label>

                                <?php

                                $conds['to_user_id'] = $deliboy->user_id;
                                $review = $this->Deliboy_Rate->get_one_by($conds)->description;

                                echo form_textarea( array(
                                    'name' => 'review',
                                    'value' => set_value( 'info', show_data( @$review ), false ),
                                    'class' => 'form-control form-control-sm',
                                    'placeholder' => get_msg('review_label'),
                                    'id' => 'info',
                                    'rows' => "3",
                                    'readonly' => 'true'
                                ));

                                ?>

                            </div>

                        </div>
                    </div>
                </div>
                <!-- /.card-body -->

                <div class="card-footer">

                    <a href="<?php echo $module_site_url; ?>" class="btn btn-sm btn-primary">
                        <?php echo get_msg('btn_back')?>
                    </a>
                </div>
            </div>
        </div>
    </div>

<?php echo form_close(); ?>