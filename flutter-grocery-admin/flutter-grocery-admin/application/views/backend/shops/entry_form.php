<?php
if (!isset($readonly_demo)) { $readonly_demo = ''; }
$attributes = array('id' => 'shop-form','enctype' => 'multipart/form-data');
echo form_open( '', $attributes);
$logged_in_user = $this->ps_auth->get_user_info();

if($logged_in_user->role_id != 1) {
	$readonly = "readonly";
	$disabled = "disabled";
	$readonly_demo = "readonly";
	$disabled_demo = "disabled";
} else if ($this->config->item("is_demo") == 1) {
	$readonly_demo = "readonly";
	$disabled_demo = "disabled";
} else {
	$readonly = "";
	$disabled = "";
}

if (!isset($shop)) {
    $shop = null;
}

if (!isset($current_tab)) {
    $current_tab = '';
}

if (!isset($active_tab_payment)) { $active_tab_payment = ''; }
if (!isset($active_tab_currency)) { $active_tab_currency = ''; }
if (!isset($active_tab_sender)) { $active_tab_sender = ''; }
if (!isset($active_tab_tax)) { $active_tab_tax = ''; }
if (!isset($active_tab_policy)) { $active_tab_policy = ''; }
if (!isset($active_tab_order)) { $active_tab_order = ''; }
if (!isset($active_tab_delivery)) { $active_tab_delivery = ''; }
if (!isset($active_tab_checkout)) { $active_tab_checkout = ''; }

if (!isset($monday)) { $monday = 0; }
if (!isset($tuesday)) { $tuesday = 0; }
if (!isset($wednesday)) { $wednesday = 0; }
if (!isset($thursday)) { $thursday = 0; }
if (!isset($friday)) { $friday = 0; }
if (!isset($saturday)) { $saturday = 0; }
if (!isset($sunday)) { $sunday = 0; }
if (!isset($from_monday)) { $from_monday = ''; }
if (!isset($to_monday)) { $to_monday = ''; }
if (!isset($from_tuesday)) { $from_tuesday = ''; }
if (!isset($to_tuesday)) { $to_tuesday = ''; }
if (!isset($from_wednesday)) { $from_wednesday = ''; }
if (!isset($to_wednesday)) { $to_wednesday = ''; }
if (!isset($from_thursday)) { $from_thursday = ''; }
if (!isset($to_thursday)) { $to_thursday = ''; }
if (!isset($from_friday)) { $from_friday = ''; }
if (!isset($to_friday)) { $to_friday = ''; }
if (!isset($from_saturday)) { $from_saturday = ''; }
if (!isset($to_saturday)) { $to_saturday = ''; }
if (!isset($from_sunday)) { $from_sunday = ''; }
if (!isset($to_sunday)) { $to_sunday = ''; }

if (!isset($disabled_demo)) { $disabled_demo = ''; }

?>

<section class="content animated fadeInRight" style="padding: 30px 20px 20px 20px;">
	<div class="card">
	    <div class="card-header" style="border-top: 2px solid red;">
	    	<?php if ( $shop ) { ?>
		        <h3 class="card-title"><?php echo get_msg('shop_info')?>
	  			<a href="<?php echo site_url('admin/dashboard/index/'. $shop->id);?>">(<?php echo get_msg('go_to_dashboard'); ?>)</a>
				</h3>
			<?php } else{ ?>
				<h3 class="card-title"><?php echo get_msg('shop_info')?></h3>
			<?php } ?>
	    </div>	    <ul class="nav nav-tabs" id="myTab">

	    	<?php
	    		$active_tab_shopinfo="";
	    		if($current_tab == "shopinfo") {
	    			$active_tab_shopinfo = "active";
	    		}
	    		
	    		if($current_tab == "payment") {
	    			$active_tab_payment = "active";
	    		}

	    		if($current_tab == "currency") {
	    			$active_tab_currency = "active";
	    		}

	    		if($current_tab == "sender") {
	    			$active_tab_sender = "active";
	    		}

	    		if($current_tab == "tax") {
	    			$active_tab_tax = "active";
	    		}

	    		if($current_tab == "policy") {
	    			$active_tab_policy = "active";
	    		}

	    		if($current_tab == "order") {
	    			$active_tab_order = "active";
	    		}

	    		if($current_tab == "delivery") {
	    			$active_tab_delivery = "active";
	    		}

	    		if($current_tab == "checkout") {
	    			$active_tab_checkout = "active";
	    		}


	    		if($active_tab_shopinfo == "" && $active_tab_payment == "" &&  $active_tab_currency == "" && $active_tab_sender == "" && $active_tab_tax == "" && $active_tab_policy == "" && $active_tab_order == "" && $active_tab_delivery == "" && $active_tab_checkout == "") {

	    			$active_tab_shopinfo = "active";
	    		}  

	    	?>

            <li class="nav-item"><a class="nav-link <?php echo $active_tab_shopinfo;?>" href="#shopinfo" value="shopinfo" data-toggle="tab"><?php echo get_msg('shop_info'); ?></a></li>
            <li class="nav-item"><a class="nav-link <?php echo $active_tab_payment;?>" href="#payment"  value="payment" data-toggle="tab"><?php echo get_msg('payment_setting'); ?></a></li>
            <li class="nav-item"><a class="nav-link <?php echo $active_tab_currency;?>" href="#currency" value="currency" data-toggle="tab"><?php echo get_msg('currency_setting'); ?></a></li>
            <li class="nav-item"><a class="nav-link <?php echo $active_tab_sender;?>" href="#sender" value="sender" data-toggle="tab"><?php echo get_msg('sending_email_setting'); ?></a></li>
            <li class="nav-item"><a class="nav-link <?php echo $active_tab_tax;?>" href="#tax" value="tax" data-toggle="tab"><?php echo get_msg('tax_label'); ?></a></li>
            <li class="nav-item"><a class="nav-link <?php echo $active_tab_policy;?>" href="#policy" value="policy" data-toggle="tab"><?php echo get_msg('policy_and_terms'); ?></a></li>
            <li class="nav-item"><a class="nav-link <?php echo $active_tab_order;?>" href="#order" value="order" data-toggle="tab"><?php echo get_msg('order_setting'); ?></a></li>
            <li class="nav-item"><a class="nav-link <?php echo $active_tab_delivery;?>" href="#delivery" value="delivery" data-toggle="tab"><?php echo get_msg('delivery_setting'); ?></a></li>
            <li class="nav-item"><a class="nav-link <?php echo $active_tab_checkout;?>" href="#checkout" value="checkout" data-toggle="tab"><?php echo get_msg('checkout_setting'); ?></a></li>
             
        </ul>
        <!-- /.card-header -->
        <div class="card-body">
          	<div class="tab-content">
            	<div class="tab-pane <?php echo $active_tab_shopinfo;?>" id="shopinfo">
            		<div class="row">
			
						<div class="col-md-6">
							
							<br>

							<div class="form-group">
								<label>
									<span style="font-size: 17px; color: red;">*</span>
									<?php echo get_msg('name_label') ?>
									<a href="#" class="tooltip-ps" data-toggle="tooltip" 
										title="<?php echo get_msg('shop_name_tooltips')?>">
										<span class='glyphicon glyphicon-info-sign menu-icon'>
									</a>
								</label>

								<input class="form-control" type="text" placeholder="<?php echo get_msg('name_label') ?>" name='name' id='name' <?php echo $readonly; ?>
								value="<?php echo $shop ? $shop->name : ''; ?>">
							</div>

							<div class="form-group">
								<label>
									<span style="font-size: 17px; color: red;">*</span>
									<?php echo get_msg('description_label') ?>
									<a href="#" class="tooltip-ps" data-toggle="tooltip" title="<?php echo get_msg('shop_desc_tooltips')?>">
										<span class='glyphicon glyphicon-info-sign menu-icon'>
									</a>
								</label>

								<textarea class="form-control" name="description" <?php echo $readonly; ?> placeholder="<?php echo get_msg('description_label') ?>" rows="9"><?php echo $shop ? $shop->description : ''; ?></textarea>
							</div>

			                <div class="form-group">
			                  	<label>
			                  		<span style="font-size: 17px; color: red;">*</span>
			                  		<?php echo get_msg('shop_tags') ?>
									<a href="#" class="tooltip-ps" data-toggle="tooltip" title="<?php echo get_msg('shop_tags')?>">
										<span class='glyphicon glyphicon-info-sign menu-icon'>
									</a>
								</label>

								<select class="form-control select2" multiple="multiple" name="shoptag" id="shoptag" <?php echo $disabled; ?>
				                          style="width: 100%;">
			                       	<?php
										//$options=array();
										$tags = $this->Tag->get_all()->result();

										$i = 1;
										foreach ($tags as $tag) {

											if($shop && $shop->id != "") {
												$conds['shop_id'] = $shop->id;
											} else {
												$conds['shop_id'] = '0';
											}
											
											$conds['tag_id'] = $tag->id;


												
											$shop_tags_id = $this->Shoptag->get_one_by($conds)->tag_id;
											
											$selected_value = "";
											if($shop_tags_id == "" ) {
												$selected_value = "";
											} else {
												$selected_value = "selected";
											}
											echo $selected_value . $i;
											echo '<option  '.$selected_value.' name="'.$tag->name.'" value="'.$tag->id.'">'.$tag->name.'</option>';

											$i++;
										}

										if($shop && $shop->id != "") {
												$conds1['shop_id'] = $shop->id;
											} else {
												$conds1['shop_id'] = '0';
											}
											
										$shop_tags_ids = $this->Shoptag->get_all_by($conds1)->result();
										$existing_tag_ids = "";
										
										foreach ($shop_tags_ids as $shop_tag) {

											$existing_tag_ids .= $shop_tag->tag_id .",";


										}

									?>
									<input type="hidden"  id="tagselect" name="tagselect">
									<input type="hidden"  id="existing_tagselect" name="existing_tagselect" value="<?php echo $existing_tag_ids; ?>">
				                </select>

			                </div>

							<div class="form-group">
								<label><input type="checkbox" name="status" <?php echo $disabled; ?> value="1" <?php if($shop && $shop->status == 1) echo "checked";?> >&nbsp;&nbsp;Status For Publish</label>
							</div>

							<?php $logged_in_user = $this->ps_auth->get_user_info(); ?>
							
								<?php if($logged_in_user->user_is_sys_admin == 1): ?>

									<div class="form-group">
									<div class="form-check">
										<label>
										
										<?php echo form_checkbox( array(
											'name' => 'is_featured',
											'id' => 'is_featured',
											'value' => 'accept',
											'checked' => set_checkbox('is_featured', 1, ( $shop && @$shop->is_featured == 1 )? true: false ),
											'class' => 'form-check-input',
											$disabled => $disabled
										));	?>

										<?php echo get_msg( 'is_featured' ); ?>

										</label>
									</div>
								</div>

									
							<?php  endif; ?>
							

							<div class="form-group">
								<label><?php echo get_msg('contact_email_label')?>
									<a href="#" class="tooltip-ps" data-toggle="tooltip" title="<?php echo get_msg('shop_email_tooltips')?>">
										<span class='glyphicon glyphicon-info-sign menu-icon'>
									</a>
								</label>
								
								<input class="form-control" type="text" placeholder="<?php echo get_msg('contact_email_label')?>" name='email' <?php echo $readonly; ?> id='email'
								value="<?php echo $shop ? $shop->email : ''; ?>">
							</div>

							<div class="form-group">
								<label>
									<?php echo get_msg('price_level')?>
								</label>

								<select id="price_level" name="price_level" <?php echo $disabled; ?> class="form-control">
								   <?php if ($shop && $shop->price_level == "Low") { ?> 
								   		<option value="1" selected><?php echo get_msg('low_label'); ?></option>
								   		<option value="2"><?php echo get_msg('medium_label'); ?></option>
								   		<option value="3"><?php echo get_msg('high_label'); ?></option>
								   <?php }else if ($shop && $shop->price_level == "Medium") { ?>
								   		<option value="1"><?php echo get_msg('low_label'); ?></option>
								   		<option value="2"  selected><?php echo get_msg('medium_label'); ?></option>
								   		<option value="3"><?php echo get_msg('high_label'); ?></option>
								   <?php }else{  ?>
								  		<option value="1"><?php echo get_msg('low_label'); ?></option>
								   		<option value="2"><?php echo get_msg('medium_label'); ?></option>
								   		<option value="3" selected><?php echo get_msg('high_label'); ?></option>
								   <?php } ?>
								</select>

							</div>

							<div class="form-group">
								<label><?php echo get_msg('highlighted_info')?>
									<a href="#" class="tooltip-ps" data-toggle="tooltip" title="<?php echo get_msg('highlighted_info')?>">
										<span class='glyphicon glyphicon-info-sign menu-icon'>
									</a>
								</label>
								
								
								<input class="form-control" type="text" placeholder="<?php echo get_msg('highlighted_info') ?>" name='highlighted_info' <?php echo $readonly; ?> id='highlighted_info' value="<?php echo $shop ? $shop->highlighted_info : ''; ?>">
							</div>

							<?php if ( !isset( $shop )): ?>
								<div class="form-group">
								
									<label><?php echo get_msg('shop_cover_photo_label')?>
										<a href="#" class="tooltip-ps" data-toggle="tooltip" title="<?php echo get_msg('shop_photo_tooltips')?>">
											<span class='glyphicon glyphicon-info-sign menu-icon'>
										</a>
									</label>

									<br>

									<?php echo get_msg('shop_image_recommended_size')?>

									<input class="btn btn-sm" type="file" name="cover" id="cover">
								</div>

								<?php else: ?>

									<label><?php echo get_msg('shop_cover_photo_label')?>
										<a href="#" class="tooltip-ps" data-toggle="tooltip" title="<?php echo get_msg('shop_photo_tooltips')?>">
											<span class='glyphicon glyphicon-info-sign menu-icon'>
										</a>
									</label>

									<br>

									<?php echo get_msg('shop_image_recommended_size')?>

									<a class="btn btn-primary btn-upload pull-right" data-toggle="modal" data-target="#uploadImage">
										<?php echo get_msg('btn_replace_photo')?> 
									</a>

									<hr/>	
									<?php
										$conds = array( 'img_type' => 'shop', 'img_parent_id' => $shop->id );
				
										$images = $this->Image->get_all_by( $conds )->result();
									?>
				
									<?php if ( count($images) > 0 ): ?>
				
										<div class="row">

										<?php $i = 0; foreach ( $images as $img ) :?>

											<?php if ($i>0 && $i%3==0): ?>
													
										</div><div class='row'>
											
											<?php endif; ?>
												
											<div class="col-md-4" style="height:100">

												<div class="thumbnail">
													<?php
														if( $img->img_path !="" ) {
													?>
														<img src="<?php echo $this->ps_image->upload_thumbnail_url . $img->img_path; ?>">
													<?php } else if (!file_exists(img_url( 'thumbnail/'. $img->img_path )) || $img->img_path  == "") { ?>
							        	 				<img src="<?php echo img_url( 'thumbnail/avatar.png'); ?>" alt="User Image" style="width: 50px;">
							        				<?php } ?>
													<br/>
													
													<p class="text-center">
														
														<a data-toggle="modal" data-target="#deletePhoto" class="delete-img" id="<?php echo $img->img_id; ?>"   
															image="<?php echo $img->img_path; ?>">
															<?php echo get_msg('remove_label'); ?>
														</a>
													</p>

												</div>

											</div>

										<?php endforeach;?>

										</div>

									
									<?php endif; ?>
								<?php endif; ?>	
								<!-- Icon  -->
								<?php if ( !isset( $shop )): ?>
								<div class="form-group">
								
									<label><?php echo get_msg('shop_icon_photo_label')?>
										<a href="#" class="tooltip-ps" data-toggle="tooltip" title="<?php echo get_msg('shop_photo_tooltips')?>">
											<span class='glyphicon glyphicon-info-sign menu-icon'>
										</a>
									</label>

									<br>

									<?php echo get_msg('shop_image_recommended_size_icon')?>

									<input class="btn btn-sm" type="file" name="icon" id="icon">
								</div>

								<?php else: ?>

									<label><?php echo get_msg('shop_icon_photo_label')?>
										<a href="#" class="tooltip-ps" data-toggle="tooltip" title="<?php echo get_msg('shop_photo_tooltips')?>">
											<span class='glyphicon glyphicon-info-sign menu-icon'>
										</a>
									</label>

									<br>

									<?php echo get_msg('shop_image_recommended_size_icon')?>

									<a class="btn btn-primary btn-upload pull-right" data-toggle="modal" data-target="#uploadIcon">
										<?php echo get_msg('btn_replace_icon')?> 
									</a>

									<hr/>	
									<?php
										$conds = array( 'img_type' => 'shop-icon', 'img_parent_id' => $shop->id );
				
										$images = $this->Image->get_all_by( $conds )->result();
									?>
				
									<?php if ( count($images) > 0 ): ?>
				
										<div class="row">

										<?php $i = 0; foreach ( $images as $img ) :?>

											<?php if ($i>0 && $i%3==0): ?>
													
										</div><div class='row'>
											
											<?php endif; ?>
												
											<div class="col-md-4" style="height:100">

												<div class="thumbnail">

													<img src="<?php echo $this->ps_image->upload_thumbnail_url . $img->img_path; ?>">

													<br/>
													
													<p class="text-center">
														
														<a data-toggle="modal" data-target="#deleteIcon" class="delete-img" id="<?php echo $img->img_id; ?>"   
															image="<?php echo $img->img_path; ?>">
															<?php echo get_msg('remove_label'); ?>
														</a>
													</p>

												</div>

											</div>

										<?php endforeach;?>

										</div>

									
									<?php endif; ?>
								<?php endif; ?>	

						</div>

						<div class="col-md-6">
							<br/>

							<div class="form-group">
								<label>
									<?php echo get_msg('phone_label') ?>
									<a href="#" class="tooltip-ps" data-toggle="tooltip" 
										title="<?php echo get_msg('shop_name_tooltips')?>">
										<span class='glyphicon glyphicon-info-sign menu-icon'>
									</a>
								</label>

								<input class="form-control" type="text" placeholder="<?php echo get_msg('phone_label') ?>" name='about_phone1' <?php echo $readonly; ?> id='about_phone1' value="<?php echo $shop ? $shop->about_phone1 : ''; ?>">
							</div>

							<div class="form-group">
								<label>
									<?php echo get_msg('phone_label2') ?>
									<a href="#" class="tooltip-ps" data-toggle="tooltip" 
										title="<?php echo get_msg('shop_name_tooltips')?>">
										<span class='glyphicon glyphicon-info-sign menu-icon'>
									</a>
								</label>

								<input class="form-control" type="text" placeholder="<?php echo get_msg('phone_label2') ?>" name='about_phone2' <?php echo $readonly; ?> id='about_phone2' value="<?php echo $shop ? $shop->about_phone2 : ''; ?>">
							</div>

							<div class="form-group">
								<label>
									<?php echo get_msg('phone_label3') ?>
									<a href="#" class="tooltip-ps" data-toggle="tooltip" 
										title="<?php echo get_msg('shop_name_tooltips')?>">
										<span class='glyphicon glyphicon-info-sign menu-icon'>
									</a>
								</label>

								<input class="form-control" type="text" placeholder="<?php echo get_msg('phone_label') ?>" name='about_phone3' <?php echo $readonly; ?> id='about_phone3' value="<?php echo $shop ? $shop->about_phone3 : ''; ?>">
							</div>
								
							<div class="form-group">
								<label><?php echo get_msg('address_label1')?>
									<a href="#" class="tooltip-ps" data-toggle="tooltip" title="<?php echo get_msg('shop_address_tooltips')?>">
										<span class='glyphicon glyphicon-info-sign menu-icon'>
									</a>
								</label>
								<textarea class="form-control" name="address1" <?php echo $readonly; ?> placeholder="<?php echo get_msg('address_label1')?>" rows="5"><?php echo $shop ? $shop->address1 : ''; ?></textarea>
							</div>

							<div class="form-group">
								<label><?php echo get_msg('address_label2')?>
									<a href="#" class="tooltip-ps" data-toggle="tooltip" title="<?php echo get_msg('shop_address_tooltips')?>">
										<span class='glyphicon glyphicon-info-sign menu-icon'>
									</a>
								</label>
								<textarea class="form-control" name="address2" <?php echo $readonly; ?> placeholder="<?php echo get_msg('address_label2')?>" rows="5"><?php echo $shop ? $shop->address2 : ''; ?></textarea>
							</div>

							<div class="form-group">
								<label><?php echo get_msg('address_label3')?>
									<a href="#" class="tooltip-ps" data-toggle="tooltip" title="<?php echo get_msg('shop_address_tooltips')?>">
										<span class='glyphicon glyphicon-info-sign menu-icon'>
									</a>
								</label>
								<textarea class="form-control" name="address3" <?php echo $readonly; ?> placeholder="<?php echo get_msg('address_label3')?>" rows="5"><?php echo $shop ? $shop->address3 : ''; ?></textarea>
							</div>

							<div class="form-group">
								<label><?php echo get_msg('about_website_label')?></label>
								<?php 
									echo form_input( array(
										'type' => 'text',
										'name' => 'about_website',
										'id' => 'about_website',
										'class' => 'form-control',
										'placeholder' => get_msg('about_website_label'),
										'value' => set_value( 'about_website', show_data( @$shop->about_website ), false ),
										$readonly => $readonly
									));
								?>
							</div>

						</div>

					</div>
					<div class="row">

						<legend><?php echo get_msg('about_social_section')?></legend>

						<div class="col-6">

							<div class="form-group">
								<label><?php echo get_msg('about_facebook_label')?></label>
								
								<?php 
									echo form_input( array(
										'type' => 'text',
										'name' => 'facebook',
										'id' => 'facebook',
										'class' => 'form-control',
										'placeholder' => get_msg('about_facebook_label'),
										'value' => set_value( 'facebook', show_data( @$shop->facebook ), false ),
										$readonly => $readonly
									));
								?>
							</div>

							<div class="form-group">
								<label><?php echo get_msg('about_gplus_label')?></label>
								
								<?php 
									echo form_input( array(
										'type' => 'text',
										'name' => 'google_plus',
										'id' => 'google_plus',
										'class' => 'form-control',
										'placeholder' => get_msg('about_gplus_label'),
										'value' => set_value( 'google_plus', show_data( @$shop->google_plus ), false ),
										$readonly => $readonly
									));
								?>
							</div>

							<div class="form-group">
								<label><?php echo get_msg('about_instagram_label')?></label>
								
								<?php 
									echo form_input( array(
										'type' => 'text',
										'name' => 'instagram',
										'id' => 'instagram',
										'class' => 'form-control',
										'placeholder' => get_msg('about_instagram_label'),
										'value' => set_value( 'instagram', show_data( @$shop->instagram ), false ),
										$readonly => $readonly
									));
								?>
							</div>

						</div>

						<div class="col-6">

							<div class="form-group">
								<label><?php echo get_msg('about_youtube_label')?></label>
								
								<?php 
									echo form_input( array(
										'type' => 'text',
										'name' => 'youtube',
										'id' => 'youtube',
										'class' => 'form-control',
										'placeholder' => get_msg('about_youtube_label'),
										'value' => set_value( 'youtube', show_data( @$shop->youtube ), false ),
										$readonly => $readonly
									));
								?>
							</div>

							<div class="form-group">
								<label><?php echo get_msg('about_pinterest_label')?></label>
								
								<?php 
									echo form_input( array(
										'type' => 'text',
										'name' => 'pinterest',
										'id' => 'pinterest',
										'class' => 'form-control',
										'placeholder' => get_msg('about_pinterest_label'),
										'value' => set_value( 'pinterest', show_data( @$shop->pinterest ), false ),
										$readonly => $readonly
									));
								?>
							</div>

							<div class="form-group">
								<label><?php echo get_msg('about_twitter_label')?></label>
								
								<?php 
									echo form_input( array(
										'type' => 'text',
										'name' => 'twitter',
										'id' => 'twitter',
										'class' => 'form-control',
										'placeholder' => get_msg('about_twitter_label'),
										'value' => set_value( 'twitter', show_data( @$shop->twitter ), false ),
										$readonly => $readonly
									));
								?>
							</div>
						</div>
					</div>
					
					<div class="row">

						<legend><?php echo get_msg('about_chart_section')?></legend>

						<div class="col-6">

							<div class="form-group">
								<label>
									<?php echo get_msg('whapsapp_no_label') ?>
									<a href="#" class="tooltip-ps" data-toggle="tooltip" 
										title="<?php echo get_msg('shop_name_tooltips')?>">
										<span class='glyphicon glyphicon-info-sign menu-icon'>
									</a>
								</label>

								<input class="form-control" type="text" placeholder="<?php echo get_msg('whapsapp_no_label') ?>" name='whapsapp_no' <?php echo $readonly; ?> id='whapsapp_no' value="<?php echo $shop ? $shop->whapsapp_no : ''; ?>">
							</div>

						</div>

						<div class="col-6">

							<div class="form-group">
								<label><?php echo get_msg('about_mess_label')?></label>
								
								<?php 
									echo form_input( array(
										'type' => 'text',
										'name' => 'messenger',
										'id' => 'messenger',
										'class' => 'form-control',
										'placeholder' => get_msg('about_mess_label'),
										'value' => set_value( 'messenger', show_data( @$shop->messenger ), false ),
										$readonly => $readonly
									));
								?>
							</div>
						</div>
					</div>

					<div class="row">

						<legend><?php echo get_msg('about_location_section')?></legend>
						<div class="col-6">

				          	<div id="restaurant_map" style="width: 100%; height: 300px;"></div>

				          	<div class="clearfix">&nbsp;</div>
								
							<div class="form-group">
								<label>
									<?php echo get_msg('rest_lat_label') ?>
					              	<a href="#" class="tooltip-ps" data-toggle="tooltip" title="<?php echo get_msg('rest_lat_label')?>">
					              		<span class='glyphicon glyphicon-info-sign menu-icon'>
					              	</a>
				              	</label>

								<br>

								<?php 
									echo form_input( array(
										'type' => 'text',
										'name' => 'lat',
										'id' => 'lat',
										'class' => 'form-control',
										'placeholder' => '',
										'value' => set_value( 'lat', show_data( @$shop->lat ), false ),
										$readonly => $readonly
									));
								?>
							</div>

							<div class="form-group">
								<label>
									<?php echo get_msg('rest_lng_label') ?>
									<a href="#" class="tooltip-ps" data-toggle="tooltip" 
										title="<?php echo get_msg('rest_lng_label')?>">
										<span class='glyphicon glyphicon-info-sign menu-icon'>
									</a>
								</label>

								<br>

								<?php 
									echo form_input( array(
										'type' => 'text',
										'name' => 'lng',
										'id' => 'lng',
										'class' => 'form-control',
										'placeholder' => '',
										'value' =>  set_value( 'lng', show_data( @$shop->lng ), false ),
										$readonly => $readonly
									));
								?>
							</div>

						</div>

						<div class="col-6">
							<legend class="ml-3"><?php echo get_msg('shop_schedule_label')?></legend><br>
							<div class="row">
								<!-- Monday -->
								<div class="col-md-4">
									<div class="form-check">
										<label><input type="checkbox" name="monday" id="monday" <?php echo $disabled; ?> value="1" <?php if($monday == 1) echo "checked";?> >&nbsp;&nbsp;<?php echo get_msg('monday_label') ?></label>
									</div>

								</div>
									
								<div class="col-md-4">
									<?php echo get_msg( 'from' ); ?>
									<input type="time" class="timepicker" name="from_monday" id="from_monday" value="<?php echo $from_monday;?>" />
								</div>

								<div class="col-md-4">
									<?php echo get_msg( 'to' ); ?>
									<input type="time" class="timepicker" name="to_monday" id="to_monday" value="<?php echo $to_monday;?>" />
								</div>

								<br><br>

								<!-- Tuesday -->

								<div class="col-md-4">
									<div class="form-check">
										<label><input type="checkbox" name="tuesday" id="tuesday" <?php echo $disabled; ?> value="1" <?php if($tuesday == 1) echo "checked";?> >&nbsp;&nbsp;<?php echo get_msg('tuesday_label') ?></label>
									</div>

								</div>
									
								<div class="col-md-4">
									<?php echo get_msg( 'from' ); ?>
									<input type="time" class="timepicker" name="from_tuesday" id="from_tuesday" value="<?php echo $from_tuesday;?>" />
								</div>

								<div class="col-md-4">
									<?php echo get_msg( 'to' ); ?>
									<input type="time" class="timepicker" name="to_tuesday" id="to_tuesday" value="<?php echo $to_tuesday;?>" />
								</div>

								<br><br>

								<!-- Wednesday -->

								<div class="col-md-4">
									<div class="form-check">
										<label><input type="checkbox" name="wednesday" id="wednesday" <?php echo $disabled; ?> value="1" <?php if($wednesday == 1) echo "checked";?> >&nbsp;&nbsp;<?php echo get_msg('wednesday_label') ?></label>
									</div>

								</div>
									
								<div class="col-md-4">
									<?php echo get_msg( 'from' ); ?>
									<input type="time" class="timepicker" name="from_wednesday" id="from_wednesday" value="<?php echo $from_wednesday;?>" />
								</div>

								<div class="col-md-4">
									<?php echo get_msg( 'to' ); ?>
									<input type="time" class="timepicker" name="to_wednesday" id="to_wednesday" value="<?php echo $to_wednesday;?>" />
								</div>

								<br><br>

								<!-- Thursday -->

								<div class="col-md-4">
									<div class="form-check">
										<label class="form-check-label">
											<label><input type="checkbox" name="thursday" id="thursday" <?php echo $disabled; ?> value="1" <?php if($thursday == 1) echo "checked";?> >&nbsp;&nbsp;<?php echo get_msg('thursday_label') ?></label>
										</label>
									</div>

								</div>
									
								<div class="col-md-4">
									<?php echo get_msg( 'from' ); ?>
									<input type="time" class="timepicker" name="from_thursday" id="from_thursday" value="<?php echo $from_thursday;?>" />
								</div>

								<div class="col-md-4">
									<?php echo get_msg( 'to' ); ?>
									<input type="time" class="timepicker" name="to_thursday" id="to_thursday" value="<?php echo $to_thursday;?>" />
								</div>

								<br><br>

								<!-- Friday -->

								<div class="col-md-4">
									<div class="form-check">
										<label class="form-check-label">
											<label><input type="checkbox" name="friday" id="friday" <?php echo $disabled; ?> value="1" <?php if($friday == 1) echo "checked";?> >&nbsp;&nbsp;<?php echo get_msg('friday_label') ?></label>
										</label>
									</div>

								</div>
									
								<div class="col-md-4">
									<?php echo get_msg( 'from' ); ?>
									<input type="time" class="timepicker" name="from_friday" id="from_friday" value="<?php echo $from_friday;?>" />
								</div>

								<div class="col-md-4">
									<?php echo get_msg( 'to' ); ?>
									<input type="time" class="timepicker" name="to_friday" id="to_friday" value="<?php echo $to_friday;?>" />
								</div>

								<br><br>

								<!-- Saturday -->

								<div class="col-md-4">
									<div class="form-check">
										<label class="form-check-label">
											<label><input type="checkbox" name="saturday" id="saturday" <?php echo $disabled; ?> value="1" <?php if($saturday == 1) echo "checked";?> >&nbsp;&nbsp;<?php echo get_msg('saturday_label') ?></label>
										</label>
									</div>

								</div>
									
								<div class="col-md-4">
									<?php echo get_msg( 'from' ); ?>
									<input type="time" class="timepicker" name="from_saturday" id="from_saturday" value="<?php echo $from_saturday;?>" />
								</div>

								<div class="col-md-4">
									<?php echo get_msg( 'to' ); ?>
									<input type="time" class="timepicker" name="to_saturday" id="to_saturday" value="<?php echo $to_saturday;?>" />
								</div>

								<br><br>

								<!-- Sunday -->

								<div class="col-md-4">
									<div class="form-check">
										<label class="form-check-label">
											<label><input type="checkbox" name="sunday" id="sunday" <?php echo $disabled; ?> value="1" <?php if($sunday == 1) echo "checked";?> >&nbsp;&nbsp;<?php echo get_msg('sunday_label') ?></label>
										</label>
									</div>

								</div>
									
								<div class="col-md-4">
									<?php echo get_msg( 'from' ); ?>
									<input type="time" class="timepicker" name="from_sunday" id="from_sunday" value="<?php echo $from_sunday;?>" />
								</div>

								<div class="col-md-4">
									<?php echo get_msg( 'to' ); ?>
									<input type="time" class="timepicker" name="to_sunday" id="to_sunday" value="<?php echo $to_sunday;?>" />
								</div>
								
							</div>	
						</div>
					</div>
					
          		</div>
                
          		<div class="tab-pane <?php echo $active_tab_payment;?>" id="payment">
           			<div class="form-group">
		
						<br>

						<label><?php echo get_msg('stripe_label')?></label>
						
						<br>

						<label><?php echo get_msg('stripe_publishable_key')?>

							<a href="#" class="tooltip-ps" data-toggle="tooltip" title="<?php echo get_msg('stripe_publishable_key_tooltips')?>">
								<span class='glyphicon glyphicon-info-sign menu-icon'>
							</a>
							
							
							
						</label>
						
							<input class="form-control" type="text" placeholder="<?php echo get_msg('stripe_publishable_key')?>" <?php echo $disabled_demo; ?> name='stripe_publishable_key' id='stripe_publishable_key'
								value="<?php echo $shop ? $shop->stripe_publishable_key : ''; ?>">
								<br>
						
						<label><?php echo get_msg('stripe_secret_key')?>
					
							<a href="#" class="tooltip-ps" data-toggle="tooltip" title="<?php echo get_msg('stripe_secret_key_tooltips')?>">
								<span class='glyphicon glyphicon-info-sign menu-icon'>
							</a>
							
						</label>

						<input class="form-control" type="text" placeholder="Secret Key" <?php echo $disabled_demo; ?> name='stripe_secret_key' id='stripe_secret_key'
							 value="<?php echo $shop ? $shop->stripe_secret_key : ''; ?>">
							 <br>

						<div class="form-group">
							<div class="form-check">
								<label>
								
								<?php echo form_checkbox( array(
									'name' => 'stripe_enabled',
									'id' => 'stripe_enabled',
									'value' => 'accept',
									'checked' => set_checkbox('stripe_enabled', 1, ( @$shop->stripe_enabled == 1 )? true: false ),
									'class' => 'form-check-input',
									$disabled_demo => $disabled_demo
								));	?>

								<?php echo get_msg( 'stripe_enable_label' ); ?>

								</label>
							</div>
						</div>

						<br>

						<hr>

						<label><?php echo get_msg('paypal_label')?></label>

						<br>

						<label><?php echo get_msg('paypal_env_label')?>
							<a href="#" class="tooltip-ps" data-toggle="tooltip" title="<?php echo get_msg('paypal_env_label')?>">
								<span class='glyphicon glyphicon-info-sign menu-icon'>
							</a>
						</label>

						<input class="form-control" type="text" placeholder="<?php echo get_msg('paypal_env_label')?>" <?php echo $disabled_demo; ?> name='paypal_environment' id='paypal_environment'
						value="<?php echo $shop ? $shop->paypal_environment : ''; ?>">

						<br>

						<label><?php echo get_msg('paypal_merchant_label')?>
							<a href="#" class="tooltip-ps" data-toggle="tooltip" title="<?php echo get_msg('paypal_merchant_label')?>">
								<span class='glyphicon glyphicon-info-sign menu-icon'>
							</a>  	
						</label>

						<input class="form-control" type="text" placeholder="<?php echo get_msg('paypal_merchant_label')?>" name='paypal_merchant_id' <?php echo $disabled_demo; ?> id='paypal_merchant_id'
						value="<?php echo $shop ? $shop->paypal_merchant_id : ''; ?>">

						<br>

						<label><?php echo get_msg('paypal_pub_label')?>
							<a href="#" class="tooltip-ps" data-toggle="tooltip" title="<?php echo get_msg('paypal_pub_label')?>">
								<span class='glyphicon glyphicon-info-sign menu-icon'>
							</a>
						</label>

						<input class="form-control" type="text" placeholder="<?php echo get_msg('paypal_pub_label')?>" <?php echo $disabled_demo; ?> name='paypal_public_key' id='paypal_public_key'
						value="<?php echo $shop ? $shop->paypal_public_key : ''; ?>">

						<br>

						<label><?php echo get_msg('paypal_pri_label')?>
							<a href="#" class="tooltip-ps" data-toggle="tooltip" title="<?php echo get_msg('paypal_pri_label')?>">
								<span class='glyphicon glyphicon-info-sign menu-icon'>
							</a>
						</label>

						<input class="form-control" type="text" placeholder="<?php echo get_msg('paypal_pri_label')?>" name='paypal_private_key' <?php echo $disabled_demo; ?> id='paypal_private_key'
						value="<?php echo $shop ? $shop->paypal_private_key : ''; ?>">

                        <br>

                        <label><?php echo get_msg('paypal_client_id_label')?>
                            <a href="#" class="tooltip-ps" data-toggle="tooltip" title="<?php echo get_msg('paypal_client_id_label')?>">
								<span class='glyphicon glyphicon-info-sign menu-icon'>
                            </a>
                        </label>

                        <input class="form-control" type="text" placeholder="<?php echo get_msg('paypal_client_id_label')?>" name='paypal_client_id' <?php echo $disabled_demo; ?> id='paypal_client_id'
                               value="<?php echo $shop ? $shop->paypal_client_id : ''; ?>">

                        <br>

                        <label><?php echo get_msg('paypal_secret_key_label')?>
                            <a href="#" class="tooltip-ps" data-toggle="tooltip" title="<?php echo get_msg('paypal_secret_key_label')?>">
								<span class='glyphicon glyphicon-info-sign menu-icon'>
                            </a>
                        </label>

                        <input class="form-control" type="text" placeholder="<?php echo get_msg('paypal_secret_key_label')?>" name='paypal_secret_key' <?php echo $disabled_demo; ?> id='paypal_secret_key'
                        value="<?php echo $shop ? $shop->paypal_secret_key : ''; ?>">
						<br>

						<div class="form-group">
							<div class="form-check">
								<label>
								
								<?php echo form_checkbox( array(
									'name' => 'paypal_enabled',
									'id' => 'paypal_enabled',
									'value' => 'accept',
									'checked' => set_checkbox('paypal_enabled', 1, ( @$shop->paypal_enabled == 1 )? true: false ),
									'class' => 'form-check-input',
									$disabled_demo => $disabled_demo
								));	?>

								<?php echo get_msg( 'paypal_enabled_label' ); ?>

								</label>
							</div>
						</div>

						<br>

						<hr>

						<label><?php echo get_msg('bank_transfer_label')?></label>

						<br>

						<label><?php echo get_msg('bank_account_label')?>
							<a href="#" class="tooltip-ps" data-toggle="tooltip" title="<?php echo get_msg('bank_account_label')?>">
								<span class='glyphicon glyphicon-info-sign menu-icon'>
							</a>
						</label>

						<input class="form-control" type="text" placeholder="<?php echo get_msg('bank_account_label')?>" name='bank_account' <?php echo $disabled_demo; ?> id='bank_account'
						value="<?php echo $shop ? $shop->bank_account : ''; ?>">

						<br>

						<label><?php echo get_msg('bank_name_label')?>
							<a href="#" class="tooltip-ps" data-toggle="tooltip" title="<?php echo get_msg('bank_name_label')?>">
								<span class='glyphicon glyphicon-info-sign menu-icon'>
							</a>  	
						</label>

						<input class="form-control" type="text" placeholder="<?php echo get_msg('bank_name_label')?>" name='bank_name' <?php echo $disabled_demo; ?> id='bank_name'
						value="<?php echo $shop ? $shop->bank_name : ''; ?>">

						<br>

						<label><?php echo get_msg('bank_code_label')?>
							<a href="#" class="tooltip-ps" data-toggle="tooltip" title="<?php echo get_msg('bank_code_label')?>">
								<span class='glyphicon glyphicon-info-sign menu-icon'>
							</a>
						</label>

						<input class="form-control" type="text" placeholder="<?php echo get_msg('bank_code_label')?>" name='bank_code' <?php echo $disabled_demo; ?> id='bank_code'
						value="<?php echo $shop ? $shop->bank_code : ''; ?>">

						<br>

						<label><?php echo get_msg('branch_code_label')?>
							<a href="#" class="tooltip-ps" data-toggle="tooltip" title="<?php echo get_msg('branch_code_label')?>">
								<span class='glyphicon glyphicon-info-sign menu-icon'>
							</a>
						</label>

						<input class="form-control" type="text" placeholder="<?php echo get_msg('branch_code_label')?>" name='branch_code' <?php echo $disabled_demo; ?> id='branch_code'
						value="<?php echo $shop ? $shop->branch_code : ''; ?>">

						<br>

						<label><?php echo get_msg('swift_code_label')?>
							<a href="#" class="tooltip-ps" data-toggle="tooltip" title="<?php echo get_msg('swift_code_label')?>">
								<span class='glyphicon glyphicon-info-sign menu-icon'>
							</a>
						</label>

						<input class="form-control" type="text" placeholder="<?php echo get_msg('swift_code_label')?>" name='swift_code' <?php echo $disabled_demo; ?> id='swift_code'
						value="<?php echo $shop ? $shop->swift_code : ''; ?>">

						<br>

						<div class="form-group">
							<div class="form-check">
								<label>
								
								<?php echo form_checkbox( array(
									'name' => 'banktransfer_enabled',
									'id' => 'banktransfer_enabled',
									'value' => 'accept',
									'checked' => set_checkbox('banktransfer_enabled', 1, ( @$shop->banktransfer_enabled == 1 )? true: false ),
									'class' => 'form-check-input',
									$disabled_demo => $disabled_demo
								));	?>

								<?php echo get_msg( 'banktransfer_label' ); ?>

								</label>
							</div>
						</div>

						<hr>

						<label><?php echo get_msg('cod_label')?></label>

						<br>

						<label><?php echo get_msg('cod_email_label')?>
							<a href="#" class="tooltip-ps" data-toggle="tooltip" title="<?php echo get_msg('code_email_tooltips')?>">
								<span class='glyphicon glyphicon-info-sign menu-icon'>
							</a>
						</label>

						<input class="form-control" type="text" placeholder="<?php echo get_msg('cod_email_label')?>" <?php echo $disabled_demo; ?> name='cod_email' id='cod_email'
						value="<?php echo $shop ? $shop->cod_email : ''; ?>">
						
						<br>

						<div class="form-group">
							<div class="form-check">
								<label>
								
								<?php echo form_checkbox( array(
									'name' => 'cod_enabled',
									'id' => 'cod_enabled',
									'value' => 'accept',
									'checked' => set_checkbox('cod_enabled', 1, ( @$shop->cod_enabled == 1 )? true: false ),
									'class' => 'form-check-input',
									$disabled_demo => $disabled_demo
								));	?>

								<?php echo get_msg( 'cod_enable_label' ); ?>

								</label>
							</div>
						</div>

						<br>

						<hr>

						<label><?php echo get_msg('razor_label')?></label>

						<br>

						<label><?php echo get_msg('razor_key_label')?>
							<a href="#" class="tooltip-ps" data-toggle="tooltip" title="<?php echo get_msg('razor_key_tooltips')?>">
								<span class='glyphicon glyphicon-info-sign menu-icon'>
							</a>
						</label>

						<input class="form-control" type="text" placeholder="<?php echo get_msg('razor_key_label')?>" <?php echo $disabled_demo; ?> name='razor_key' id='razor_key'
						value="<?php echo $shop ? $shop->razor_key : ''; ?>">
						
						<br>

						<div class="form-group">
							<div class="form-check">
								<label>
								
								<?php echo form_checkbox( array(
									'name' => 'razor_enabled',
									'id' => 'razor_enabled',
									'value' => 'accept',
									'checked' => set_checkbox('razor_enabled', 1, ( @$shop->razor_enabled == 1 )? true: false ),
									'class' => 'form-check-input',
									$disabled_demo => $disabled_demo
								));	?>

								<?php echo get_msg( 'razor_enabled_label' ); ?>

								</label>
							</div>
						</div> 

						<hr width="100%" size="8">
				        <div class="col-md-6">
				        	<label><?php echo get_msg('pickup_label')?></label>

							<br>

							<label><?php echo get_msg('pickup_message')?>
								<a href="#" class="tooltip-ps" data-toggle="tooltip" title="<?php echo get_msg('message_tooltips')?>">
									<span class='glyphicon glyphicon-info-sign menu-icon'>
								</a>
							</label>

							<?php echo form_textarea( array(
								'name' => 'pickup_message',
								'value' => set_value( 'pickup_message', show_data( @$shop->pickup_message ), false ),
								'class' => 'form-control form-control-sm',
								'placeholder' => get_msg( 'pickup_message' ),
								'rows' => '5',
								'id' => 'pickup_message',
								$readonly_demo => $readonly_demo
							)); ?>
							
							<br>

							<div class="form-group">
								<div class="form-check">
									<label>
									
									<?php echo form_checkbox( array(
										'name' => 'pickup_enabled',
										'id' => 'pickup_enabled',
										'value' => 'accept',
										'checked' => set_checkbox('pickup_enabled', 1, ( @$shop->pickup_enabled == 1 )? true: false ),
										'class' => 'form-check-input',
										$disabled_demo => $disabled_demo
									));	?>

									<?php echo get_msg( 'pickup_enabled_label' ); ?>

									</label>
								</div>
							</div> 
				        </div>

				        <hr>

						<label><?php echo get_msg('paystack_label')?></label>

						<br>

						<label><?php echo get_msg('paystack_key_label')?>
							<a href="#" class="tooltip-ps" data-toggle="tooltip" title="<?php echo get_msg('paystack_key_tooltips')?>">
								<span class='glyphicon glyphicon-info-sign menu-icon'>
							</a>
						</label>

						<input class="form-control" type="text" placeholder="<?php echo get_msg('paystack_key_label')?>" <?php echo $disabled_demo; ?> name='paystack_key' id='paystack_key'
						value="<?php echo $shop ? $shop->paystack_key : ''; ?>">
						
						<br>

						<div class="form-group">
							<div class="form-check">
								<label>
								
								<?php echo form_checkbox( array(
									'name' => 'paystack_enabled',
									'id' => 'paystack_enabled',
									'value' => 'accept',
									'checked' => set_checkbox('paystack_enabled', 1, ( @$shop->paystack_enabled == 1 )? true: false ),
									'class' => 'form-check-input',
									$disabled_demo => $disabled_demo
								));	?>

								<?php echo get_msg( 'paystack_enabled_label' ); ?>

								</label>
							</div>
						</div> 

						<hr>

						<br>

						<label><?php echo get_msg('flutter_wave_label')?></label>
						
						<br>

						<label><?php echo get_msg('flutter_wave_publishable_key')?>

							<a href="#" class="tooltip-ps" data-toggle="tooltip" title="<?php echo get_msg('flutter_wave_publishable_key_tooltips')?>">
								<span class='glyphicon glyphicon-info-sign menu-icon'>
							</a>
							
							
							
						</label>
						
						<input class="form-control" type="text" placeholder="<?php echo get_msg('flutter_wave_publishable_key') ?>" <?php echo $disabled_demo; ?> name='flutter_wave_publishable_key' id='flutter_wave_publishable_key'
							 value="<?php echo $shop ? $shop->flutter_wave_publishable_key : ''; ?>">
							 <br>
						
						
						<label><?php echo get_msg('flutter_wave_encryption_key')?>
					
							<a href="#" class="tooltip-ps" data-toggle="tooltip" title="<?php echo get_msg('flutter_wave_encryption_key_tooltips')?>">
								<span class='glyphicon glyphicon-info-sign menu-icon'>
							</a>
							
						</label>

						<input class="form-control" type="text" placeholder="<?php echo get_msg('flutter_wave_encryption_key') ?>" <?php echo $disabled_demo; ?> name='flutter_wave_encryption_key' id='flutter_wave_encryption_key'
							 value="<?php echo $shop ? $shop->flutter_wave_encryption_key : ''; ?>">
							 <br>

						<div class="form-group">
							<div class="form-check">
								<label>
								
								<?php echo form_checkbox( array(
									'name' => 'flutter_wave_enabled',
									'id' => 'flutter_wave_enabled',
									'value' => 'accept',
									'checked' => set_checkbox('flutter_wave_enabled', 1, ( @$shop->flutter_wave_enabled == 1 )? true: false ),
									'class' => 'form-check-input',
									$disabled_demo => $disabled_demo
								));	?>

								<?php echo get_msg( 'flutter_wave_enable_label' ); ?>

								</label>
							</div>
						</div>


					</div>
          		</div>
                  
          		<div class="tab-pane <?php echo $active_tab_currency;?>" id="currency">
           			<br>
		
					<div class="col-sm-6">
						<div class="form-group">
							<label><span style="font-size: 17px; color: red;">*</span><?php echo get_msg('currency_symbol_label')?> 
								<a href="#" class="tooltip-ps" data-toggle="tooltip" \
									title="<?php echo get_msg('currency_symbol_tooltips')?>">
									<span class='glyphicon glyphicon-info-sign menu-icon'>
								</a>
							</label>

							<input class="form-control" type="text" placeholder="<?php echo get_msg('currency_symbol_label')?>" name='currency_symbol' <?php echo $readonly; ?> id='currency_symbol'
							value="<?php echo $shop ? $shop->currency_symbol : ''; ?>">
						</div>

						<div class="form-group">
							<label><span style="font-size: 17px; color: red;">*</span><?php echo get_msg('currency_form_label')?> 
								<a href="#" class="tooltip-ps" data-toggle="tooltip" title="<?php echo get_msg('currency_form_tooltips')?>">
									<span class='glyphicon glyphicon-info-sign menu-icon'>
								</a>
							</label>

							<input class="form-control" type="text" placeholder="<?php echo get_msg('currency_form_label')?> " name='currency_short_form' <?php echo $readonly; ?> id='currency_short_form'
							value="<?php echo $shop ? $shop->currency_short_form : ''; ?>">

						</div>
					</div>
          		</div>
                  
           		<div class="tab-pane <?php echo $active_tab_sender;?>" id="sender">
            		
					<br>

					<div class="col-sm-6">
						<div class="form-group">
							<label><?php echo get_msg('sender_email_label')?> 
								<a href="#" class="tooltip-ps" data-toggle="tooltip" title="<?php echo get_msg('sender_email_tooltips')?>">
									<span class='glyphicon glyphicon-info-sign menu-icon'>
								</a>
							</label>

							<input class="form-control" type="text" placeholder="<?php echo get_msg('sender_email_label')?>" name='sender_email' id='sender_email' <?php echo $readonly; ?> value="<?php echo $shop ? $shop->sender_email : ''; ?>">
						</div>
					</div>
          		</div>

          		<div class="tab-pane <?php echo $active_tab_tax;?>" id="tax">
          			<div class="row">
          				<div class="col-md-6">
          					<div class="form-group">
								<label>
									<?php echo get_msg('overall_tax_label') ?>
									<a href="#" class="tooltip-ps" data-toggle="tooltip" 
										title="<?php echo get_msg('shop_name_tooltips')?>">
									</a>
								</label>

								<input class="form-control" type="text" placeholder="<?php echo get_msg('overall_tax_label');?>" name='overall_tax_label' <?php echo $readonly; ?> id='overall_tax_label'
								value="<?php echo $shop ? $shop->overall_tax_label : ''; ?>">
							</div>
						</div>
						<div class="col-md-6">
							<div class="form-group">
								<label>
									<?php echo get_msg('shipping_tax_label') ?>
									<a href="#" class="tooltip-ps" data-toggle="tooltip" 
										title="<?php echo get_msg('shop_name_tooltips')?>">
										<span class='glyphicon glyphicon-info-sign menu-icon'>
									</a>
								</label>

								<input class="form-control" type="text" placeholder="<?php echo get_msg('shipping_tax_label');?>" name='shipping_tax_label' <?php echo $readonly; ?> id='shipping_tax_label'
								value="<?php echo $shop ? $shop->shipping_tax_label : ''; ?>">
							</div>
						</div>	
          			</div>
          		</div>

          		<div class="tab-pane <?php echo $active_tab_policy;?>" id="policy">
          			<div class="row">
          				<div class="col-md-6">
      						<div class="form-group">
								<label>
									<?php echo get_msg('refund_policy_label') ?>
									<a href="#" class="tooltip-ps" data-toggle="tooltip" 
										title="<?php echo get_msg('shop_name_tooltips')?>">
										<span class='glyphicon glyphicon-info-sign menu-icon'>
									</a>
								</label>

								<textarea class="form-control" name="refund_policy" <?php echo $readonly; ?> placeholder="<?php echo get_msg('refund_policy_label') ?>" rows="5"><?php echo $shop ? $shop->refund_policy : ''; ?></textarea>
								
							</div>
          				</div>

          				<div class="col-md-6">
      						<div class="form-group">
								<label>
									<?php echo get_msg('terms_label') ?>
									<a href="#" class="tooltip-ps" data-toggle="tooltip" 
										title="<?php echo get_msg('shop_name_tooltips')?>">
										<span class='glyphicon glyphicon-info-sign menu-icon'>
									</a>
								</label>

								<textarea class="form-control" name="terms" <?php echo $readonly; ?> placeholder="<?php echo get_msg('terms_label') ?>" rows="5"><?php echo $shop ? $shop->terms : ''; ?></textarea>
								
							</div>
          				</div>
          			</div>
          		</div>

          	  	<div class="tab-pane <?php echo $active_tab_order;?>" id="order">
          			<div class="row">
          				<div class="col-md-6">
          					<div class="form-group">
								<label>
									<?php echo get_msg('minimum_order_amount') ?>
									<a href="#" class="tooltip-ps" data-toggle="tooltip" 
										title="<?php echo get_msg('shop_name_tooltips')?>">
									</a>
								</label>

								<input class="form-control" type="text" placeholder="<?php echo get_msg('minimum_order_amount');?>" name='minimum_order_amount' <?php echo $readonly; ?> id='minimum_order_amount'
								value="<?php echo $shop ? $shop->minimum_order_amount : ''; ?>">
							</div>
						</div>	
          			</div>
          		</div>

          		<!-- delivery setting -->

          		<div class="tab-pane <?php echo $active_tab_delivery;?>" id="delivery">
				  	<h4 class="font-weight-bold mb-5"><?php echo get_msg('deliboy_cost_setting')?></h4>
          			<div class="row">
          				<div class="col-md-4">
          					<div class="row">
	          					<div class="form-group">
									<label>
										<?php echo get_msg('deliver_distance_label') ?>
										<a href="#" class="tooltip-ps" data-toggle="tooltip" 
											title="<?php echo get_msg('shop_name_tooltips')?>">
										</a>
									</label>

									<input class="form-control" type="text" size="68" placeholder="<?php echo get_msg('deliver_distance_label');?>" <?php echo $disabled; ?> name='deliver_distance' id='deliver_distance'
									value="<?php echo $shop ? $shop->deliver_distance : ''; ?>">


								</div>


								<div class="form-group ml-2">
									<label>
										<?php echo get_msg('deliver_unit_label')?>
									</label>

									<select id="deliver_unit" name="deliver_unit" <?php echo $disabled; ?> class="form-control">
									   <?php if ($shop->deliver_unit == "Mile") { ?> 
									   		<option value="1" selected>Mile</option>
									   		<option value="2">Km</option>
									   <?php }else{  ?>
									  		<option value="1">Mile</option>
									   		<option value="2" selected>Km</option>
									   <?php } ?>
									</select>

								</div>
							</div>
						</div>	

						<div class="col-md-4">
							<div class="form-group">
								<label>
									<?php echo get_msg('deli_charges_label') ?>
									<a href="#" class="tooltip-ps" data-toggle="tooltip" 
										title="<?php echo get_msg('shop_name_tooltips')?>">
									</a>
								</label>

								<input class="form-control" type="text" placeholder="<?php echo get_msg('deli_charges_label');?>" <?php echo $disabled; ?> name='deli_charges' id='deli_charges'
								value="<?php echo $shop ? $shop->deli_charges : ''; ?>">
							</div>
						</div>	

						<div class="col-md-4">
							<div class="form-group">
								<label>
									<?php echo get_msg('fixed_deli_fee_label') ?>
									<a href="#" class="tooltip-ps" data-toggle="tooltip" 
										title="<?php echo get_msg('shop_name_tooltips')?>">
									</a>
								</label>

								<input class="form-control" type="text" placeholder="<?php echo get_msg('fixed_deli_fee_label');?>" <?php echo $disabled; ?> name='fixed_deli_fee' id='fixed_deli_fee'
								value="<?php echo $shop ? $shop->fixed_deli_fee : ''; ?>">
							</div>
						</div>	
          			</div>


					<hr>

						<div class="row">
								<div class="col-md-3">
							        <label><input type="radio" <?php echo $disabled; ?> name="deliRadio" value="is_area" <?php 
							       		$is_area = $shop ? $shop->is_area : 0;
							        if ($is_area == 1) echo "checked"; ?> >
							          <?php echo get_msg('is_area_label'); ?> </label>
							    </div>
								<div class="col-md-3">
							        <label><input type="radio" <?php echo $disabled; ?> name="deliRadio" value="deli_fee_by_distance" <?php 
							       		$deli_fee_by_distance = $shop ? $shop->deli_fee_by_distance : 0;
							        if ($deli_fee_by_distance == 1) echo "checked"; ?> >
							          <?php echo get_msg('deli_fee_by_distance_label'); ?> </label>
							    </div> 
							    <div class="col-md-3">     
							        <label><input type="radio" <?php echo $disabled; ?> name="deliRadio" value="fixed_delivery" <?php 
							       		$fixed_delivery = $shop ? $shop->fixed_delivery : 0;
							        if ($fixed_delivery == 1) echo "checked"; ?> > <?php echo get_msg('fixed_delivery_label'); ?> </label>
							    </div>
							    <div class="col-md-3">    
							        <label><input type="radio" <?php echo $disabled; ?> name="deliRadio" value="free_delivery" <?php 
							       		$free_delivery = $shop ? $shop->free_delivery : 0;
							        if ($free_delivery == 1) echo "checked"; ?> > <?php echo get_msg('free_delivery_label'); ?> 
							    </label>
							    </div>

							    <?php 
							    	if($shop && $shop->is_area == 1) {
							    		$display = "block";
							    	} else {
							    		$display = "none";
							    	}
							    ?>

							    <div class="is_area box" style="display: <?php echo $display; ?> ">

							    	<?php echo get_msg('you_selected')?> <b> <?php echo get_msg('is_area_label'); ?> </b> <?php echo get_msg("not_calculate_deli_fee"); ?> <br> <br>

								</div>

							    
							    <?php 
							    	if($shop && $shop->deli_fee_by_distance == 1) {
							    		$display = "block";
							    	} else {
							    		$display = "none";
							    	}
							    ?>

							    <div class="deli_fee_by_distance box col-md-3 offset-md-3" style="display: <?php echo $display; ?> "> 
							    	<?php echo get_msg('you_selected')?> <b> <?php echo get_msg('deli_fee_by_distance_label'); ?> </b> <br> <br>

									<label>
							    	
									 <?php echo get_msg('deli_fee_formula'); ?>

									<label>
							    </div>
							    
							    <?php 
							    	if($shop && $shop->fixed_delivery == 1) {
							    		$display = "block";
							    	} else {
							    		$display = "none";
							    	}
							    ?>

							    <div class="fixed_delivery box col-md-3 offset-md-6" style="display: <?php echo $display; ?> ">
							    	<?php echo get_msg('you_selected')?> <b> <?php echo get_msg('fixed_delivery_label'); ?> </b> <br> <br>

							    	<label>
										<?php echo get_msg('fixed_delivery_fee') . ' ' . ($shop ? $shop->fixed_deli_fee : ''); ?>
									</label> 
								</div>	

							    
								<?php 
							    	if($shop && $shop->free_delivery == 1) {
							    		$display = "block";
							    	} else {
							    		$display = "none";
							    	}
							    ?>

							    <div class="free_delivery box col-md-3 offset-md-9" style="display: <?php echo $display; ?> ">

							    	<?php echo get_msg('you_selected')?> <b> <?php echo get_msg('free_delivery_label'); ?> </b> <br> <br>

								</div>

							</div>

							<hr class="bg-dark my-4">
							<h4 class="font-weight-bold mb-3"><?php echo get_msg('deliboy_ass_setting')?></h4>
							<div class="row">
								<div class="col-md-6">
									<div class="form-group" style="padding-top: 30px;">
										<div class="form-check">

											<label class="form-check-label">
											
												<?php echo form_radio( array(
													'name' => 'deli_assign_setting',
													'id' => 'deli_manual_assign',
													'value' => 'deli_manual_assign',
													'checked' => set_radio('deli_manual_assign', 1, ( @$shop->deli_manual_assign == 1 )? true: false ),
													'class' => 'form-check-input',
													$disabled => $disabled
												));	?>
												<?php echo get_msg( 'deli_manual_assign' ); ?>
											</label>
										
										</div>
									</div>
									

								</div>

								  <div class="col-md-6">
									<div class="form-group" style="padding-top: 30px;">
										<div class="form-check">

											<label class="form-check-label">
											
												<?php echo form_radio( array(
													'name' => 'deli_assign_setting',
													'id' => 'deli_auto_assign',
													'value' => 'deli_auto_assign',
													'checked' => set_radio('deli_auto_assign', 1, ( @$shop->deli_auto_assign == 1 )? true: false ),
													'class' => 'form-check-input',
													$disabled => $disabled
												));	?>
												<?php echo get_msg( 'deli_auto_assign' ); ?>
											</label>
										
										</div>
									</div>
									<div class="form-group d-flex align-items-center ml-5 mt-3">
										<label id="how_many_deli_to_broadcast_label" class="<?php echo ($shop && $shop->deli_auto_assign == 1) ? '' : 'd-none' ?>">
											<?php echo get_msg('how_many_deli_to_broadcast') ?>
											<a href="#" class="tooltip-ps" data-toggle="tooltip" 
												title="<?php echo get_msg('how_many_deli_to_broadcast')?>">
											</a>
										</label>

										<input id="how_many_deli_to_broadcast_input" class="form-control <?php echo ($shop && $shop->deli_auto_assign == 1) ? '' : 'd-none' ?>" type="text" placeholder="<?php echo get_msg('how_many_deli_to_broadcast'); ?>" <?php echo $disabled; ?> name='how_many_deli_to_broadcast' id='how_many_deli_to_broadcast'
										value="<?php echo $shop ? $shop->how_many_deli_to_broadcast : ''; ?>">
									</div>
          						</div>

							</div>
							
          		</div>

          		<!-- checkout setting -->
          		<div class="tab-pane <?php echo $active_tab_checkout;?>" id="checkout">
          			<div class="row">
          				<div class="col-md-6">
          					<div class="form-group" style="padding-top: 30px;">
								<div class="form-check">

									<label class="form-check-label">
									
										<?php echo form_radio( array(
											'name' => 'checkout_setting',
											'id' => 'checkout_with_whatsapp',
											'value' => 'checkout_with_whatsapp',
											'checked' => set_radio('checkout_with_whatsapp', 1, ( @$shop->checkout_with_whatsapp == 1 )? true: false ),
											'class' => 'form-check-input',
											$disabled => $disabled
										));	?>
										<?php echo get_msg( 'checkout_with_whatsapp' ); ?>
									</label>
									<small class="d-block mt-2 font-weight-bold">
										(<?php echo get_msg( 'checkout_with_whatsapp_des' ); ?>)
									</small>
								</div>
							</div>
          				</div>

          				<div class="col-md-6">
          					<div class="form-group" style="padding-top: 30px;">
								<div class="form-check">

									<label class="form-check-label">
									
										<?php echo form_radio( array(
											'name' => 'checkout_setting',
											'id' => 'checkout_with_email',
											'value' => 'checkout_with_email',
											'checked' => set_radio('checkout_with_email', 1, ( @$shop->checkout_with_email == 1 )? true: false ),
											'class' => 'form-check-input',
											$disabled => $disabled
											// 'disabled' => $shop->checkout_with_whatsapp == 1 ? 'disabled' : '',
										));	?>
										<?php echo get_msg( 'checkout_with_email' ); ?>
									</label>
									<small class="d-block mt-2 font-weight-bold">
										(<?php echo get_msg( 'checkout_with_email_des' ); ?>)
									</small>
									
								</div>
							</div>
							<div id="ways_for_email" class="row ml-5 <?php echo ($shop && $shop->checkout_with_email == 1) ? '' : 'd-none' ?>">
								<div class="col-12">
									<div class="form-group" style="padding-top: 10px;">
										<div class="form-check">
										
											<label class="form-check-label">
											
												<?php echo form_radio( array(
													'name' => 'normal_checkout_setting',
													'id' => 'one_page_checkout',
													'value' => 'one_page_checkout',
													'checked' => set_radio('one_page_checkout', 1, ( @$shop->one_page_checkout == 1 )? true: false ),
													'class' => 'form-check-input',
													$disabled => $disabled
													// 'disabled' => $shop->checkout_with_whatsapp == 1 ? 'disabled' : '',
												));	?>
												<?php echo get_msg( 'one_page_checkout' ); ?> 
											</label>
											<small class="d-block mt-2 font-weight-bold">
												(<?php echo get_msg( 'one_page_checkout_des' ); ?>)
											</small>
										</div>
									</div>
								</div>
								<div class="col-12">
									<div class="form-group" style="padding-top: 3px;">
										<div class="form-check">

											<label class="form-check-label">
											
												<?php echo form_radio( array(
													'name' => 'normal_checkout_setting',
													'id' => 'multi_page_checkout',
													'value' => 'multi_page_checkout',
													'checked' => set_radio('multi_page_checkout', 1, ( @$shop->multi_page_checkout == 1 )? true: false ),
													'class' => 'form-check-input',
													$disabled => $disabled
													// 'disabled' => $shop->checkout_with_whatsapp == 1 ? 'disabled' : '',
												));	?>
												<?php echo get_msg( 'multi_page_checkout' ); ?>
											</label>
											<small class="d-block mt-2 font-weight-bold">
												(<?php echo get_msg( 'multi_page_checkout_des' ); ?>)
											</small>
										</div>
									</div>
								</div>
							</div>
          				</div>

          				
          			</div>
          		</div>
            </div>
            <!-- /.tab-content -->
        </div>
        <!-- /.card-body -->
        <input type="hidden" id="is_featured_stage" name="is_featured_stage" value="<?php echo @$shop->is_featured; ?>">
        <?php if($logged_in_user->role_id == 1) { ?>
		<div class="card-footer">
			
           <button type="submit" name="save" class="btn btn-primary">
				<?php echo get_msg('btn_save')?>
			</button>
				
			<a href="<?php echo site_url('admin/shops');?>" class="btn btn-primary"><?php echo get_msg('btn_cancel'); ?></a>

        </div>
       	<?php } ?>
    </div>
    <!-- card info -->

    <input type="hidden"  id="current_tab" name="current_tab" value="current_tab">

</section>
<?php echo form_close(); ?>

<div class="modal fade"  id="deleteShop">
		
	<div class="modal-dialog">
		
		<div class="modal-content">
		
			<div class="modal-header">
				<h4 class="modal-title"><?php echo get_msg('delete_shop_label')?></h4>

				<button type="button" class="close" data-dismiss="modal">
					<span aria-hidden="true">&times;</span><span class="sr-only">Close</span>
				</button>

			</div>

			<div class="modal-body">
				<p><?php echo get_msg('delete_shop_confirm_message')?></p>
				<p>1. <?php echo get_msg('prd_dis_module'); ?></p>
				<p>2. <?php echo get_msg('prd_collect_module'); ?></p>
				<p>3. <?php echo get_msg('news_feed_module'); ?></p>
				<p>4. <?php echo get_msg('shipping_method_module'); ?></p>
				<p>5. <?php echo get_msg('watch_list'); ?></p>
				<p>6. <?php echo get_msg('comments_module'); ?></p>
				<p>7. <?php echo get_msg('transaction_module'); ?></p>
				<p>8. <?php echo get_msg('reports_group'); ?></p>
				<p>9. <?php echo get_msg('usr_shop_module'); ?></p>
				<p>10. <?php echo get_msg('shop_tags'); ?></p>
				<p>11. <?php echo get_msg('like_module'); ?></p>
				<p>12. <?php echo get_msg('favourites_module'); ?></p>
				<p>13. <?php echo get_msg('coupon_module'); ?></p>
			</div>

			<div class="modal-footer">
				<a type="button" class="btn btn-default btn-delete-shop"><?php echo get_msg('btn_yes'); ?></a>
				<a type="button" class="btn btn-default" data-dismiss="modal"><?php echo get_msg('btn_cancel'); ?></a>
			</div>

		</div>
	
	</div>			
		
</div>


<script>
	<?php
			if (isset($shop)) {
				$lat = $shop->lat;
				$lng = $shop->lng;
		?>
				var citymap = L.map('restaurant_map').setView([<?php echo $lat;?>, <?php echo $lng;?>], 5);
		<?php
			} else {
		?>
				var citymap = L.map('restaurant_map').setView([0, 0], 5);
		<?php
			}
		?>

		const city_attribution =
		'&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors';
		const city_tileUrl = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
		const city_tiles = L.tileLayer(city_tileUrl, { city_attribution });
		city_tiles.addTo(citymap);
		<?php if(isset($shop)) {?>
			var marker2 = new L.Marker(new L.LatLng(<?php echo $lat;?>, <?php echo $lng;?>));
			citymap.addLayer(marker2);
			// results = L.marker([<?php echo $lat;?>, <?php echo $lng;?>]).addTo(mymap);

		<?php } else { ?>
			var marker2 = new L.Marker(new L.LatLng(0, 0));
			//mymap.addLayer(marker2);
		<?php } ?>
		var searchControl = L.esri.Geocoding.geosearch().addTo(citymap);
		var results = L.layerGroup().addTo(citymap);

		searchControl.on('results',function(data){
			results.clearLayers();

			for(var i= data.results.length -1; i>=0; i--) {
				citymap.removeLayer(marker2);
				results.addLayer(L.marker(data.results[i].latlng));
				var search_str = data.results[i].latlng.toString();
				var search_res = search_str.substring(search_str.indexOf("(") + 1, search_str.indexOf(")"));
				var searchArr = new Array();
				searchArr = search_res.split(",");

				document.getElementById("lat").value = searchArr[0].toString();
				document.getElementById("lng").value = searchArr[1].toString(); 
				
			}
		})
		var popup = L.popup();

		function onMapClick(e) {

			var str = e.latlng.toString();
			var str_res = str.substring(str.indexOf("(") + 1, str.indexOf(")"));
			citymap.removeLayer(marker2);
			results.clearLayers();
			results.addLayer(L.marker(e.latlng));   

			var tmpArr = new Array();
			tmpArr = str_res.split(",");

			document.getElementById("lat").value = tmpArr[0].toString(); 
			document.getElementById("lng").value = tmpArr[1].toString();
		}

		citymap.on('click', onMapClick);
	</script>
