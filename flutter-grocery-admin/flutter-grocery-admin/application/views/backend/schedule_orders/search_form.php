<div class='row my-3'>
	<div class='col-9'>
		<?php
			if (!isset($trans_status_id)) { $trans_status_id = ""; }
			if (!isset($date)) { $date = ""; }
			$attributes = array('class' => 'form-inline');
			echo form_open( $module_site_url .'/search', $attributes);
		?>
		
		<div class="form-group mr-3">

			<?php echo form_input(array(
				'name' => 'searchterm',
				'value' => set_value( 'searchterm' ),
				'class' => 'form-control form-control-sm',
				'placeholder' => get_msg( 'btn_search' )
			)); ?>

	  	</div>

		<div class="form-group">

			<?php
				echo get_msg( 'trans_status_label' );

				$options=array();
				$options[0]=get_msg('select_order');

				foreach ($this->Transactionstatus->get_all()->result() as $status) {

					$options[$status->id]=$status->title;
								
				}
				echo form_dropdown(
					'trans_status_id',
					$options,
					set_value( 'trans_status_id', show_data( $trans_status_id), false ),
					'class="form-control form-control-sm mr-3 ml-3" id="trans_status_id"'
				);
			?>

			</div>

	  	<div class="input-group mr-3">
		    <div class="input-group-prepend">
		      <span class="input-group-text">
		        <i class="fa fa-calendar"></i>
		      </span>
		    </div>
			   <?php echo form_input(array(
					'name' => 'date',
					'value' => set_value( 'date' , $date ),
					'class' => 'form-control form-control-sm',
					'placeholder' => '',
					'id' => 'datepicker-13',
					'size' => '20',
					'readonly' => 'readonly'
				)); ?>

 		</div>

	  	<div class="form-group" style="padding-right: 2px;">
		  	<button type="submit" name="submit" value="submit" class="btn btn-sm btn-primary">
		  		<?php echo get_msg( 'btn_search' )?>
		  	</button>
	  	</div>

	  	<div class="form-group">
		  	<a href='<?php echo $module_site_url; ?>' class='btn btn-sm btn-primary'>
				<?php echo get_msg( 'btn_reset' )?>
			</a>
	  	</div>

	<?php echo form_close(); ?>

	</div>	

	<div class='col-3'>
		<a href='<?php echo site_url() . '/admin/order_routes/index/' ?>' class='btn btn-sm btn-primary pull-right'>
			<span class='fa fa-arrow-right'></span> 
			<?php echo get_msg( 'go_route_to_deliver_order_label' )?>
		</a>
	</div>

</div>

