<div class="table-responsive animated fadeInRight" style="padding: 10px 30px 10px 30px;">
    <table class="table m-0 table-striped">

        <tr>
            <th><?php echo get_msg('no')?></th>
            <th><?php echo get_msg('user_name')?></th>
            <th><?php echo get_msg('user_email')?></th>
            <th><?php echo get_msg('user_phone_label')?></th>
            <th><?php echo get_msg('overall_rating')?></th>

            <?php if ( $this->ps_auth->has_access( EDIT )): ?>

                <th><?php echo get_msg('btn_view')?></th>

            <?php endif;?>

        </tr>

        <?php $count = $this->uri->segment(4) or $count = 0; ?>

        <?php if ( !empty( $deliboys ) && count( $deliboys->result()) > 0 ): ?>

            <?php foreach($deliboys->result() as $deliboy): ?>

                <tr>
                    <td><?php echo ++$count;?></td>
                    <td><?php echo $deliboy->user_name;?></td>
                    <td><?php echo $deliboy->user_email;?></td>
                    <td><?php echo $deliboy->user_phone;?></td>
                    <td>

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

                    </td>

                    <?php if ( $this->ps_auth->has_access( EDIT )): ?>

                        <td>
                            <a href='<?php echo $module_site_url .'/edit/'. $deliboy->user_id; ?>'>
                                <i class='fa fa-eye'></i>
                            </a>
                        </td>

                    <?php endif; ?>

                </tr>

            <?php endforeach; ?>

        <?php else: ?>

            <?php $this->load->view( $template_path .'/partials/no_data' ); ?>

        <?php endif; ?>

    </table>
</div>
