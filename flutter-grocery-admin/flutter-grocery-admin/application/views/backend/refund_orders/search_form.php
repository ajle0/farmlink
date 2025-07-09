<div class='row my-3'>

    <div class='col-md-12'>
        <?php
            if (!isset($search_term)) { $search_term = ""; }
            if (!isset($date)) { $date = ""; }
            $attributes = array('class' => 'form-inline');
            echo form_open( $module_site_url .'/search', $attributes);
        ?>
        <div class="form-group">

            <?php echo form_input(array(
                'name' => 'search_term',
                'value' => set_value( 'search_term', $search_term ),
                'class' => 'form-control form-control',
                'placeholder' => get_msg('btn_search'),
                'id' => '',
                'style' => 'float: left; margin-right: 10px;'
            )); ?>
        </div>


        <div class="form-group mr-3">
            <div class="input-group">
                <div class="input-group-prepend">
			      <span class="input-group-text">
			        <i class="fa fa-calendar"></i>
			      </span>
                </div>
                <?php echo form_input(array(
                    'name' => 'date',
                    'value' => set_value( 'date', $date ),
                    'class' => 'form-control',
                    'placeholder' => '',
                    'id' => 'reservation',
                    'size' => '30',
                    'readonly' => 'readonly',
                    'style' => 'float: left; margin-right: 10px;'
                )); ?>

            </div>
        </div>


        <div class="form-group">
            <button type="submit" name="submit" value="submit" class="btn btn-sm btn-primary">
                <?php echo get_msg( 'btn_search' )?>
            </button>
        </div>

        <div class="form-group ml-3">
            <a href="<?php echo $module_site_url; ?>" class="btn btn-sm btn-primary">
                <?php echo get_msg( 'btn_reset' ); ?>
            </a>
        </div>
    </div>

    <?php echo form_close(); ?>
</div>