<?php
	$attributes = array( 'id' => 'transtatus-form', 'enctype' => 'multipart/form-data');
	echo form_open( '', $attributes);
?>
	
<div class="container-fluid">
	<div class="col-6" style="padding: 30px 20px 20px 20px;">
		<div class="card earning-widget">
		    <div class="card-header" style="border-top: 2px solid red;">
		        <h3 class="card-title"><?php echo get_msg('trans_status_info')?></h3>
		    </div>
	        <!-- /.card-header -->
	        <div class="card-body">
	            <div class="row">
	             	<div class="col-md-12">
	            		
	              		<div class="form-group">
	                   		<label>
								<?php echo get_msg('deli_status_title')?>
								<a href="#" class="tooltip-ps" data-toggle="tooltip" title="<?php echo get_msg('deli_status_title')?>">
									<span class='glyphicon glyphicon-info-sign menu-icon'>
								</a>
							</label>

							<?php echo form_input( array(
								'name' => 'title',
								'value' => set_value( 'title', show_data( @$trans_status->title ), false ),
								'class' => 'form-control form-control-sm',
								'placeholder' => get_msg( 'deli_status_title' ),
								'id' => 'title'
							)); ?>
	              		</div>
	              	</div>        		
	            </div>
	            <!-- /.row -->

	            <div class="row">
	             	<div class="col-md-12">
	            		
	              		<div class="form-group">
	                   		<label>
								<?php echo get_msg('deli_status_ordering')?>
								<a href="#" class="tooltip-ps" data-toggle="tooltip" title="<?php echo get_msg('deli_status_ordering')?>">
									<span class='glyphicon glyphicon-info-sign menu-icon'>
								</a>
							</label>

							<?php echo form_input( array(
								'name' => 'ordering',
								'value' => set_value( 'ordering', show_data( @$trans_status->ordering ), false ),
								'class' => 'form-control form-control-sm',
								'placeholder' => get_msg( 'deli_status_ordering' ),
								'id' => 'ordering'
							)); ?>
	              		</div>
	              	</div>        		
	            </div>

	            <div class="row">
	             	<div class="col-md-12">

			          	<div class="form-group" id="color-picker-group">
		                    <label><?php echo get_msg('color_code')?>
								<a href="#" class="tooltip-ps" data-toggle="tooltip" title="<?php echo get_msg('color_code')?>">
									<span class='glyphicon glyphicon-info-sign menu-icon'>
								</a>
							</label>
							
							<div class="input-group my-colorpicker2">
								<?php echo form_input(array(
									'name' => 'color_value' . $i,
									'value' => $trans_status->color_value,
									'class' => 'form-control form-control-sm mt-1',
									'placeholder' => "",
									'id' => 'color_value' .$i,
								)); ?>
								<div class="input-group-addon mt-1"><i></i></div>
									
		          			</div>
		          		</div>	
		          	</div>
		        </div>

				<div class="row">
      				<div class="col-md-3">
      					<div class="form-group">
                            <label><input type="radio" name="status" value="start_stage" id="main_stage" <?php
                                $start_stage = $trans_status->start_stage;
						        if ($start_stage == 1) echo "checked"; ?> >
						          Start Stage </label>
						</div>
					</div>
					<div class="col-md-3">
      					<div class="form-group">
                            <label><input type="radio" name="status" value="final_stage" id="main_stage" <?php
                                $final_stage = $trans_status->final_stage;
						        if ($final_stage == 1) echo "checked"; ?> > Final Stage </label>
						</div>
					</div>

                    <div class="col-md-3">
                        <div class="form-group">
                            <label><input type="radio" name="status" value="is_optional" <?php
                                $is_optional = $trans_status->is_optional;
                                if ($is_optional == 1) echo "checked"; ?> > Optional </label>
                        </div>
                    </div>

                    <?php
                    if($is_optional == 0) {
                        $display = "block";
                    } else {
                        $display = "none";
                    }

                    ?>

                    <div class="main_stage box" style="display: <?php echo $display; ?> ">

                        <div class="form-check">

                            <label class="form-check-label">

                                <?php echo form_checkbox( array(
                                    'name' => 'is_refundable',
                                    'id' => 'is_refundable',
                                    'value' => 'accept',
                                    'checked' => set_checkbox('is_refundable', 1, ( @$trans_status->is_refundable == 1 )? true: false ),
                                    'class' => 'form-check-input'
                                ));	?>
                                <label><?php echo get_msg( 'is_refundable_label' ); ?></label>
                            </label>
                        </div>
                    </div>
                </div>


                <!-- /.card-body -->
	    	</div>
            <br>
			<div class="card-footer">
	            <button type="submit" class="btn btn-sm btn-primary">
					<?php echo get_msg('btn_save')?>
				</button>

				<a href="<?php echo $module_site_url; ?>" class="btn btn-sm btn-primary">
					<?php echo get_msg('btn_cancel')?>
				</a>
	        </div>
	       
	    <!-- card info -->
	</div>
</section>
				
<?php echo form_close(); ?>