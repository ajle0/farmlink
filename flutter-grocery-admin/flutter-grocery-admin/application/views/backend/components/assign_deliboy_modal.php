<div class="modal fade"  id="assignDeliboyModal">

	<div class="modal-dialog">

		<div class="modal-content">

			<div class="modal-header text-center">
				
				<h4 class="modal-title"><?php echo $title; ?></h4>
				
				<button class="close" data-dismiss="modal">					
					<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
				</button>

			</div>
			<?php
				$attributes = array('id' => 'assign-deliboy-form','enctype' => 'multipart/form-data');
				echo form_open( $module_site_url . '/assign_delivery_boy/', $attributes);
			?>
			
				<div class="modal-body">

					<div class="form-row my-3">

						<label class="form-control-label col-md-4"><?php echo get_msg('select_deli_boy')?></label>
						
						<select name="delivery_boy_id" class="form-control col-md-8">

							<option value="0"><?php echo get_msg('select_deli_boy'); ?></option>
							<?php
								$conds['role_id'] = 5;
								$conds['status']= 1;
								$deli_boys = $this->User->get_all_by($conds);
								foreach ($deli_boys->result() as $boy)
								{
									echo "<option value='".$boy->user_id."'>" .$boy->user_name."</option>";
								}
							?>
						</select>

					</div>
 
					
				</div>

				<div class="modal-footer">

					<input type="submit" value="<?php echo get_msg('btn_yes') ?>" class="btn btn-sm btn-primary btn-yes"/>

					<a href='#' class="btn btn-sm btn-primary" data-dismiss="modal"><?php echo get_msg('btn_cancel')?></a>

				</div>
			
				<?php echo form_close(); ?>

		</div>

	</div>

</div>