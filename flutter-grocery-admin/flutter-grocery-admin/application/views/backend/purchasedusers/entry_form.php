<?php
	$attributes = array( 'id' => 'purchasedcategory-form', 'enctype' => 'multipart/form-data');
	echo form_open( '', $attributes);
?>
	
	
	<div class="row my-4 animated fadeInRight">
		<div class="col-md-12">
			
			<div class="card card-info">
              <div class="card-header">
                <h3 class="card-title"><?php echo get_msg('user_info')?></h3>
              </div>

                <div class="card-body">

                	<div class="row">
 
	                	<div class="col-md-6">
	                		<div class="form-group">
								<label>
									<?php echo get_msg('user_name') . ' : ' ?>
								</label>
								<br><br>
								<label>
									<?php echo get_msg('user_email') . ' : ' ?>
								</label>
								<br><br>
								<label>
									<?php echo get_msg('user_phone_label')  . ' : ' ?>
								</label>
								<br><br>
								<label>
									<?php echo get_msg('branch_address_label')  . ' : ' ?>
								</label>
								<br><br>
								<label>
									<?php echo get_msg('about_me') . ' : ' ?>
								</label>
								<br><br>
								<label>
									<?php echo get_msg('role_label')  . ' : ' ?>
								</label>
								<br><br>
								<label>
									<?php echo get_msg('profile_img') . ' : ' ?>
								</label>
							</div>
	                		
	                	</div>
						
	                	<div class="col-md-6">
	                		<div class="form-group">
								<label>
									<?php echo $purchaseduser->user_name; ?>
								</label>
								<br><br>
								<label>
									<?php echo $purchaseduser->user_email; ?>
								</label>
								<br><br>
								<label>
									<?php echo $purchaseduser->user_phone; ?>
								</label>
								<br><br>
								<label>
									<?php echo $purchaseduser->user_address; ?>
								</label>
								<br><br>
								<label>
									<?php echo $purchaseduser->user_about_me; ?>
								</label>
								<br><br>
								<label>
									<?php 
										$role_id = $purchaseduser->role_id;
										echo $this->Role->get_one($role_id)->role_name; ?>
								</label>
								<br><br>
								<div class="col-md-4" style="height:100">

									<div class="thumbnail">

										<img src="<?php echo $this->ps_image->upload_thumbnail_url . $purchaseduser->user_profile_photo; ?>">

										<br/>
										
										
									</div>

								</div>
							</div>
	                		
	                	</div>
	                </div>	
		
				</div>

				<div class="card-footer text-center">
					<a class="btn btn-primary" href="<?php echo $module_site_url ?>" class="btn"><?php echo get_msg('back_button')?></a>
				</div>

			</div>
		</div>
	</div>

<?php echo form_close(); ?>

