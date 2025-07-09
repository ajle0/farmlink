<?php
$attributes = array('id' => 'app-form','enctype' => 'multipart/form-data');
echo form_open( '', $attributes);
?>

<div class="container-fluid">
    <div class="col-12"  style="padding: 30px 20px 20px 20px;">
    	<div class="card earning-widget">
	    	<div class="card-header" style="border-top: 2px solid red;">
	    		<h3 class="card-title"><?php echo get_msg('app_config_info_lable')?></h3>
			</div>
        <!-- /.card-header -->
        	<div class="card-body">
		        <div class="row">
		
					<div class="col-md-6">						
						<div class="form-group">
							<label><?php echo get_msg('google_playstore_url') ?>
								<a href="#" class="tooltip-ps" data-toggle="tooltip" 
									title="<?php echo get_msg('google_playstore_url')?>">
									<span class='glyphicon glyphicon-info-sign menu-icon'>
								</a>
							</label><br>
							<?php 
								echo form_input( array(
									'type' => 'text',
									'name' => 'google_playstore_url',
									'id' => 'google_playstore_url',
									'class' => 'form-control',
									'placeholder' => get_msg('google_playstore_url'),
									'value' =>  set_value( 'google_playstore_url', show_data( @$app->google_playstore_url ), false ),
								));
							?>
						</div>
					</div>

					<div class="col-md-6">
						<div class="form-group">
							<label><?php echo get_msg('apple_appstore_url') ?>
								<a href="#" class="tooltip-ps" data-toggle="tooltip" 
									title="<?php echo get_msg('apple_appstore_url')?>">
									<span class='glyphicon glyphicon-info-sign menu-icon'>
								</a>
							</label><br>
							<?php 
								echo form_input( array(
									'type' => 'text',
									'name' => 'apple_appstore_url',
									'id' => 'apple_appstore_url',
									'class' => 'form-control',
									'placeholder' => get_msg('apple_appstore_url'),
									'value' =>  set_value( 'apple_appstore_url', show_data( @$app->apple_appstore_url ), false ),
								));
							?>
						</div>		
					</div>

					<div class="col-md-6">						
						<div class="form-group">
							<label><?php echo get_msg('ios_appstore_id') ?>
								<a href="#" class="tooltip-ps" data-toggle="tooltip" 
									title="<?php echo get_msg('ios_appstore_id')?>">
									<span class='glyphicon glyphicon-info-sign menu-icon'>
								</a>
							</label><br>
							<?php 
								echo form_input( array(
									'type' => 'text',
									'name' => 'ios_appstore_id',
									'id' => 'ios_appstore_id',
									'class' => 'form-control',
									'placeholder' => get_msg('ios_appstore_id'),
									'value' =>  set_value( 'ios_appstore_id', show_data( @$app->ios_appstore_id ), false ),
								));
							?>
						</div>
					</div>

					<div class="col-md-6">						
						<div class="form-group">
							<label><?php echo get_msg('fb_key') ?>
								<a href="#" class="tooltip-ps" data-toggle="tooltip" 
									title="<?php echo get_msg('fb_key')?>">
									<span class='glyphicon glyphicon-info-sign menu-icon'>
								</a>
							</label><br>
							<?php 
								echo form_input( array(
									'type' => 'text',
									'name' => 'fb_key',
									'id' => 'fb_key',
									'class' => 'form-control',
									'placeholder' => get_msg('fb_key'),
									'value' =>  set_value( 'fb_key', show_data( @$app->fb_key ), false ),
								));
							?>
						</div>
					</div>
					
					<div class="col-md-6">
						<div class="form-group">
							<label><?php echo get_msg('price_format') ?><br> <small><?php echo get_msg('price_format_desc') ?></small>
								<a href="#" class="tooltip-ps" data-toggle="tooltip" 
									title="<?php echo get_msg('price_format')?>">
									<span class='glyphicon glyphicon-info-sign menu-icon'>
								</a>
							</label><br>
							<?php 
								echo form_input( array(
									'type' => 'text',
									'name' => 'price_format',
									'id' => 'price_format',
									'class' => 'form-control',
									'placeholder' => get_msg('price_format'),
									'value' =>  set_value( 'price_format', show_data( @$app->price_format ), false ),
								));
							?>
						</div>
					</div>

					<div class="col-md-6">						
						<div class="form-group">
							<label><?php echo get_msg('date_format') ?><br> <small><?php echo get_msg('date_format_desc') ?></small>
								<a href="#" class="tooltip-ps" data-toggle="tooltip" 
									title="<?php echo get_msg('date_format')?>">
									<span class='glyphicon glyphicon-info-sign menu-icon'>
								</a>
							</label><br>
							<?php 
								echo form_input( array(
									'type' => 'text',
									'name' => 'date_format',
									'id' => 'date_format',
									'class' => 'form-control',
									'placeholder' => get_msg('date_format'),
									'value' =>  set_value( 'date_format', show_data( @$app->date_format ), false ),
								));
							?>
						</div>
					</div>

					<div class="col-md-6">						
						<div class="form-group">
							<label><?php echo get_msg('default_order_time') ?>
								<a href="#" class="tooltip-ps" data-toggle="tooltip" 
									title="<?php echo get_msg('default_order_time')?>">
									<span class='glyphicon glyphicon-info-sign menu-icon'>
								</a>
							</label><br>
							<?php 
								echo form_input( array(
									'type' => 'text',
									'name' => 'default_order_time',
									'id' => 'default_order_time',
									'class' => 'form-control',
									'placeholder' => get_msg('default_order_time'),
									'value' =>  set_value( 'default_order_time', show_data( @$app->default_order_time ), false ),
								));
							?>
						</div>
					</div>

					<div class="col-md-6">
						<div class="form-group">
							<div class="form-check">
								<label class="form-check-label">
								<?php echo form_checkbox( array(
									'name' => 'is_show_token_id',
									'id' => 'is_show_token_id',
									'value' => 'accept',
									'checked' => set_checkbox('is_show_token_id', 1, ( @$app->is_show_token_id == 1 )? true: false ),
									'class' => 'form-check-input'
								));	?>
								<?php echo get_msg( 'is_show_token_id' ); ?>
								</label>
							</div>
						</div>
					</div>

					<div class="col-md-6">
						<div class="form-group">
							<div class="form-check">
								<label class="form-check-label">
								<?php echo form_checkbox( array(
									'name' => 'is_show_subcategory',
									'id' => 'is_show_subcategory',
									'value' => 'accept',
									'checked' => set_checkbox('is_show_subcategory', 1, ( @$app->is_show_subcategory == 1 )? true: false ),
									'class' => 'form-check-input'
								));	?>
								<?php echo get_msg( 'is_show_subcategory' ); ?>
								</label>
							</div>
						</div>
					</div>

					<div class="col-md-6">
						<div class="form-group">
							<div class="form-check">
								<label class="form-check-label">
								<?php echo form_checkbox( array(
									'name' => 'is_use_thumbnail_as_placeholder',
									'id' => 'is_use_thumbnail_as_placeholder',
									'value' => 'accept',
									'checked' => set_checkbox('is_use_thumbnail_as_placeholder', 1, ( @$app->is_use_thumbnail_as_placeholder == 1 )? true: false ),
									'class' => 'form-check-input'
								));	?>
								<?php echo get_msg( 'is_use_thumbnail_as_placeholder' ); ?>
								</label>
							</div>
						</div>
					</div>

					<hr width="100%" class="my-5">

					<legend class="mx-3 mb-4 font-weight-bold"><?php echo get_msg('loc_section')?></legend>
					<div class="col-md-6">
					  	<div id="app_location" style="width: 100%; height: 250px;"></div>
            			<div class="clearfix">&nbsp;</div>
					</div>
					
		          	<div class="col-md-6">
						<div class="form-group">
							<label><?php echo get_msg('shop_lat_label') ?>
								<a href="#" class="tooltip-ps" data-toggle="tooltip" title="<?php echo get_msg('shop_lat_label')?>">
									<span class='glyphicon glyphicon-info-sign menu-icon'>
								</a>
							</label><br>
							<?php 
								echo form_input( array(
									'type' => 'text',
									'name' => 'lat',
									'id' => 'lat',
									'class' => 'form-control',
									'placeholder' => get_msg('shop_lat_label'),
									'value' => set_value( 'lat', show_data( @$app->lat ), false ),
								));
							?>
						</div>
						
						<div class="form-group">
							<label><?php echo get_msg('shop_lng_label') ?>
								<a href="#" class="tooltip-ps" data-toggle="tooltip" 
									title="<?php echo get_msg('shop_lng_label')?>">
									<span class='glyphicon glyphicon-info-sign menu-icon'>
								</a>
							</label><br>
							<?php 
								echo form_input( array(
									'type' => 'text',
									'name' => 'lng',
									'id' => 'lng',
									'class' => 'form-control',
									'placeholder' => get_msg('shop_lng_label'),
									'value' =>  set_value( 'lng', show_data( @$app->lng ), false ),
								));
							?>
						</div>
					</div>
					
					<hr width="100%" class="my-5">

					<legend class="mx-3 mb-4 font-weight-bold"><?php echo get_msg('admob_section')?></legend>
					<div class="col-md-6">	
						<div class="form-group">
							<div class="form-check">
								<label class="form-check-label">
								<?php echo form_checkbox( array(
									'name' => 'is_show_admob',
									'id' => 'is_show_admob',
									'value' => 'accept',
									'checked' => set_checkbox('is_show_admob', 1, ( @$app->is_show_admob == 1 )? true: false ),
									'class' => 'form-check-input'
								));	?>
								<?php echo get_msg( 'is_show_admob' ); ?>
								</label>
							</div>
						</div>
					</div>

					<hr width="100%" class="my-5">

					<legend class="mx-3 mb-4 font-weight-bold"><?php echo get_msg('lang_section')?></legend>
					<div class="col-md-6">
						<div class="form-group">
							<label><?php echo get_msg('default_language') ?>
								<a href="#" class="tooltip-ps" data-toggle="tooltip" 
									title="<?php echo get_msg('default_language')?>">
									<span class='glyphicon glyphicon-info-sign menu-icon'>
								</a>
							</label><br>
							
							<?php
								$options[0]=get_msg('default_lang_select');
								foreach($languages as $language) {
									$options[$language['language_code']]=$language['name'];
								}
								echo form_dropdown(
									'default_language',
									$options,
									set_value( 'default_language', show_data( @$app->default_language), false ),
									'class="form-control form-control-sm mr-3" id="default_language"'
								);
							?>
						</div>
					</div>
					<div class="col-12 mt-3">							
						<div class="form-group">
							<label><?php echo get_msg('exclude_language') ?>
								<a href="#" class="tooltip-ps" data-toggle="tooltip" 
									title="<?php echo get_msg('exclude_language')?>">
									<span class='glyphicon glyphicon-info-sign menu-icon'>
								</a>
							</label><br><?php echo get_msg('exclude_lang_desc') ?>
						</div>

						<div class="row">
							<?php 
								$exclude_language = explode(',' ,trim($app->exclude_language));
								foreach($languages as $language): ?>
									<div class="col-6">
										<div class="form-group">
											<div class="form-check">
												<label class="form-check-label">
												<?php echo form_checkbox( array(
													'name' => $language['language_code'],
													'id' => $language['language_code'],
													'value' => 'accept',
													'checked' => set_checkbox($language['language_code'], 1, ( in_array($language['language_code'], $exclude_language))? false: true ),
													'class' => 'form-check-input'
												));	?>
												<?php echo $language['name'] . "( " . $language['language_code'] . '_' . $language['country_code'] . " )" ; ?>
												</label>
											</div>
										</div>
									</div>
								<?php endforeach; ?>
						</div>
					</div>

					<hr width="100%" class="my-5">

					<legend class="mx-3 mb-4 font-weight-bold"><?php echo get_msg('default_currency_section')?></legend>					
					<div class="col-md-6">
						<div class="form-group">
							<label><?php echo get_msg('default_razor_currency') ?>
								<a href="#" class="tooltip-ps" data-toggle="tooltip" 
									title="<?php echo get_msg('default_razor_currency')?>">
									<span class='glyphicon glyphicon-info-sign menu-icon'>
								</a>
							</label><br>
							<?php 
								echo form_input( array(
									'type' => 'text',
									'name' => 'default_razor_currency',
									'id' => 'default_razor_currency',
									'class' => 'form-control',
									'placeholder' => get_msg('default_razor_currency'),
									'value' =>  set_value( 'default_razor_currency', show_data( @$app->default_razor_currency ), false ),
								));
							?>
						</div>
					</div>

					<div class="col-md-6">
						<div class="form-group">
							<label><?php echo get_msg('default_flutter_wave_currency') ?>
								<a href="#" class="tooltip-ps" data-toggle="tooltip" 
									title="<?php echo get_msg('default_flutter_wave_currency')?>">
									<span class='glyphicon glyphicon-info-sign menu-icon'>
								</a>
							</label><br>
							<?php 
								echo form_input( array(
									'type' => 'text',
									'name' => 'default_flutter_wave_currency',
									'id' => 'default_flutter_wave_currency',
									'class' => 'form-control',
									'placeholder' => get_msg('default_flutter_wave_currency'),
									'value' =>  set_value( 'default_flutter_wave_currency', show_data( @$app->default_flutter_wave_currency ), false ),
								));
							?>
						</div>
		          	</div>

					<div class="col-md-6">
						<div class="form-group">
							<div class="form-check">
								<label class="form-check-label">
								<?php echo form_checkbox( array(
									'name' => 'is_razor_support_multi_currency',
									'id' => 'is_razor_support_multi_currency',
									'value' => 'accept',
									'checked' => set_checkbox('is_razor_support_multi_currency', 1, ( @$app->is_razor_support_multi_currency == 1 )? true: false ),
									'class' => 'form-check-input'
								));	?>
								<?php echo get_msg( 'is_razor_support_multi_currency' ); ?>
								</label>
							</div>
						</div>
					</div>

					<hr width="100%" class="my-5">

					<legend class="mx-3 mb-4 font-weight-bold"><?php echo get_msg('login_section')?></legend>
					<div class="col-md-6">
						<div class="form-group">
							<div class="form-check">
								<label class="form-check-label">
								<?php echo form_checkbox( array(
									'name' => 'show_facebook_login',
									'id' => 'show_facebook_login',
									'value' => 'accept',
									'checked' => set_checkbox('show_facebook_login', 1, ( @$app->show_facebook_login == 1 )? true: false ),
									'class' => 'form-check-input'
								));	?>
								<?php echo get_msg( 'show_facebook_login' ); ?>
								</label>
							</div>
						</div>
					</div>

					<div class="col-md-6">
						<div class="form-group">
							<div class="form-check">
								<label class="form-check-label">
								<?php echo form_checkbox( array(
									'name' => 'show_phone_login',
									'id' => 'show_phone_login',
									'value' => 'accept',
									'checked' => set_checkbox('show_phone_login', 1, ( @$app->show_phone_login == 1 )? true: false ),
									'class' => 'form-check-input'
								));	?>
								<?php echo get_msg( 'show_phone_login' ); ?>
								</label>
							</div>
						</div>
					</div>

					<div class="col-md-6">
						<div class="form-group">
							<div class="form-check">
								<label class="form-check-label">
								<?php echo form_checkbox( array(
									'name' => 'show_google_login',
									'id' => 'show_google_login',
									'value' => 'accept',
									'checked' => set_checkbox('show_google_login', 1, ( @$app->show_google_login == 1 )? true: false ),
									'class' => 'form-check-input'
								));	?>
								<?php echo get_msg( 'show_google_login' ); ?>
								</label>
							</div>
						</div>
					</div>

					<hr width="100%" class="my-5">

					<legend class="mx-3 mb-4 font-weight-bold"><?php echo get_msg('dashboard_section')?></legend>
					<div class="col-md-6">
						<div class="form-group">
							<div class="form-check">
								<label class="form-check-label">
								<?php echo form_checkbox( array(
									'name' => 'show_main_menu',
									'id' => 'show_main_menu',
									'value' => 'accept',
									'checked' => set_checkbox('show_main_menu', 1, ( @$app->show_main_menu == 1 )? true: false ),
									'class' => 'form-check-input'
								));	?>
								<?php echo get_msg( 'show_main_menu' ); ?>
								</label>
							</div>
						</div>
					</div>

					<div class="col-md-6">
						<div class="form-group">
							<div class="form-check">
								<label class="form-check-label">
								<?php echo form_checkbox( array(
									'name' => 'show_special_collections',
									'id' => 'show_special_collections',
									'value' => 'accept',
									'checked' => set_checkbox('show_special_collections', 1, ( @$app->show_special_collections == 1 )? true: false ),
									'class' => 'form-check-input'
								));	?>
								<?php echo get_msg( 'show_special_collections' ); ?>
								</label>
							</div>
						</div>
					</div>

					<div class="col-md-6">
						<div class="form-group">
							<div class="form-check">
								<label class="form-check-label">
								<?php echo form_checkbox( array(
									'name' => 'show_featured_items',
									'id' => 'show_featured_items',
									'value' => 'accept',
									'checked' => set_checkbox('show_featured_items', 1, ( @$app->show_featured_items == 1 )? true: false ),
									'class' => 'form-check-input'
								));	?>
								<?php echo get_msg( 'show_featured_items' ); ?>
								</label>
							</div>
						</div>
					</div>

					<div class="col-md-6">
						<div class="form-group">
							<div class="form-check">
								<label class="form-check-label">
								<?php echo form_checkbox( array(
									'name' => 'show_best_choice_slider',
									'id' => 'show_best_choice_slider',
									'value' => 'accept',
									'checked' => set_checkbox('show_best_choice_slider', 1, ( @$app->show_best_choice_slider == 1 )? true: false ),
									'class' => 'form-check-input'
								));	?>
								<?php echo get_msg( 'show_best_choice_slider' ); ?>
								</label>
							</div>
						</div>
					</div>

					<hr width="100%" class="my-5">

					<legend class="mx-3 mb-4 font-weight-bold"><?php echo get_msg('default_limit_section')?></legend>
					<div class="col-md-6">
						<div class="form-group">
							<label><?php echo get_msg('default_loading_limit') ?>
								<a href="#" class="tooltip-ps" data-toggle="tooltip" 
									title="<?php echo get_msg('default_loading_limit')?>">
									<span class='glyphicon glyphicon-info-sign menu-icon'>
								</a>
							</label><br>
							<?php 
								echo form_input( array(
									'type' => 'text',
									'name' => 'default_loading_limit',
									'id' => 'default_loading_limit',
									'class' => 'form-control',
									'placeholder' => get_msg('default_loading_limit'),
									'value' =>  set_value( 'default_loading_limit', show_data( @$app->default_loading_limit ), false ),
								));
							?>
						</div>
					</div>

					<div class="col-md-6">
						<div class="form-group">
							<label><?php echo get_msg('category_loading_limit') ?>
								<a href="#" class="tooltip-ps" data-toggle="tooltip" 
									title="<?php echo get_msg('category_loading_limit')?>">
									<span class='glyphicon glyphicon-info-sign menu-icon'>
								</a>
							</label><br>
							<?php 
								echo form_input( array(
									'type' => 'text',
									'name' => 'category_loading_limit',
									'id' => 'category_loading_limit',
									'class' => 'form-control',
									'placeholder' => get_msg('category_loading_limit'),
									'value' =>  set_value( 'category_loading_limit', show_data( @$app->category_loading_limit ), false ),
								));
							?>
						</div>
					</div>

					<div class="col-md-6">						
						<div class="form-group">
							<label><?php echo get_msg('collection_product_loading_limit') ?>
								<a href="#" class="tooltip-ps" data-toggle="tooltip" 
									title="<?php echo get_msg('collection_product_loading_limit')?>">
									<span class='glyphicon glyphicon-info-sign menu-icon'>
								</a>
							</label><br>
							<?php 
								echo form_input( array(
									'type' => 'text',
									'name' => 'collection_product_loading_limit',
									'id' => 'collection_product_loading_limit',
									'class' => 'form-control',
									'placeholder' => get_msg('collection_product_loading_limit'),
									'value' =>  set_value( 'collection_product_loading_limit', show_data( @$app->collection_product_loading_limit ), false ),
								));
							?>
						</div>
					</div>

					<div class="col-md-6">
						<div class="form-group">
							<label><?php echo get_msg('discount_product_loading_limit') ?>
								<a href="#" class="tooltip-ps" data-toggle="tooltip" 
									title="<?php echo get_msg('discount_product_loading_limit')?>">
									<span class='glyphicon glyphicon-info-sign menu-icon'>
								</a>
							</label><br>
							<?php 
								echo form_input( array(
									'type' => 'text',
									'name' => 'discount_product_loading_limit',
									'id' => 'discount_product_loading_limit',
									'class' => 'form-control',
									'placeholder' => get_msg('discount_product_loading_limit'),
									'value' =>  set_value( 'discount_product_loading_limit', show_data( @$app->discount_product_loading_limit ), false ),
								));
							?>
						</div>
					</div>

					<div class="col-md-6">						
						<div class="form-group">
							<label><?php echo get_msg('feature_product_loading_limie') ?>
								<a href="#" class="tooltip-ps" data-toggle="tooltip" 
									title="<?php echo get_msg('feature_product_loading_limie')?>">
									<span class='glyphicon glyphicon-info-sign menu-icon'>
								</a>
							</label><br>
							<?php 
								echo form_input( array(
									'type' => 'text',
									'name' => 'feature_product_loading_limit',
									'id' => 'feature_product_loading_limit',
									'class' => 'form-control',
									'placeholder' => get_msg('feature_product_loading_limie'),
									'value' =>  set_value( 'feature_product_loading_limit', show_data( @$app->feature_product_loading_limit ), false ),
								));
							?>
						</div>
					</div>

					<div class="col-md-6">
						<div class="form-group">
							<label><?php echo get_msg('latest_product_loading_limit') ?>
								<a href="#" class="tooltip-ps" data-toggle="tooltip" 
									title="<?php echo get_msg('latest_product_loading_limit')?>">
									<span class='glyphicon glyphicon-info-sign menu-icon'>
								</a>
							</label><br>
							<?php 
								echo form_input( array(
									'type' => 'text',
									'name' => 'latest_product_loading_limit',
									'id' => 'latest_product_loading_limit',
									'class' => 'form-control',
									'placeholder' => get_msg('latest_product_loading_limit'),
									'value' =>  set_value( 'latest_product_loading_limit', show_data( @$app->latest_product_loading_limit ), false ),
								));
							?>
						</div>
					</div>

					<div class="col-md-6">
						<div class="form-group">
							<label><?php echo get_msg('shop_loading_limit') ?>
								<a href="#" class="tooltip-ps" data-toggle="tooltip" 
									title="<?php echo get_msg('shop_loading_limit')?>">
									<span class='glyphicon glyphicon-info-sign menu-icon'>
								</a>
							</label><br>
							<?php 
								echo form_input( array(
									'type' => 'text',
									'name' => 'shop_loading_limit',
									'id' => 'shop_loading_limit',
									'class' => 'form-control',
									'placeholder' => get_msg('shop_loading_limit'),
									'value' =>  set_value( 'shop_loading_limit', show_data( @$app->latest_product_loading_limit ), false ),
								));
							?>
						</div>
					</div>

					<div class="col-md-6">
						<div class="form-group">
							<label><?php echo get_msg('trending_product_loading_limit') ?>
								<a href="#" class="tooltip-ps" data-toggle="tooltip" 
									title="<?php echo get_msg('trending_product_loading_limit')?>">
									<span class='glyphicon glyphicon-info-sign menu-icon'>
								</a>
							</label><br>
							<?php 
								echo form_input( array(
									'type' => 'text',
									'name' => 'trending_product_loading_limit',
									'id' => 'trending_product_loading_limit',
									'class' => 'form-control',
									'placeholder' => get_msg('trending_product_loading_limit'),
									'value' =>  set_value( 'trending_product_loading_limit', show_data( @$app->trending_product_loading_limit ), false ),
								));
							?>
						</div>
					</div>

		    </div>
	        <!-- /.card-body -->
	        <div class="card-footer">
				<button type="submit" name="save" class="btn btn-sm btn-primary">
					<?php echo get_msg('btn_save')?>
				</button>

				<a href="<?php echo $module_site_url; ?>" class="btn btn-sm btn-primary">
					<?php echo get_msg('btn_cancel')?>
				</a>
			</div>
			<!-- /.card footer-->
	    
        </div>
    </div>
</div>

<?php echo form_close(); ?>


        
<script>
            <?php
             if (isset($app)) {
                $lat = $app->lat;
                $lng = $app->lng;
        ?>
                var app_map = L.map('app_location').setView([<?php echo $lat;?>, <?php echo $lng;?>], 5);
        <?php
            } else {
        ?>
                var app_map = L.map('app_location').setView([0, 0], 5);
                <?php
                }
            ?>
const app_attribution =
            '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors';
            const app_tileUrl = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
            const app_tiles = L.tileLayer(app_tileUrl, { app_attribution });
            app_tiles.addTo(app_map);
            <?php if(isset($app)) {?>
                var app_marker = new L.Marker(new L.LatLng(<?php echo $lat;?>, <?php echo $lng;?>));
                app_map.addLayer(app_marker);
                // results = L.marker([<?php echo $lat;?>, <?php echo $lng;?>]).addTo(mymap);

            <?php } else { ?>
                var app_marker = new L.Marker(new L.LatLng(0, 0));
                //mymap.addLayer(marker2);
            <?php } ?>
            var app_searchControl = L.esri.Geocoding.geosearch().addTo(app_map);
            var results = L.layerGroup().addTo(app_map);

            app_searchControl.on('results',function(data){
                results.clearLayers();

                for(var i= data.results.length -1; i>=0; i--) {
                    app_map.removeLayer(app_marker);
                    results.addLayer(L.marker(data.results[i].latlng));
                    var app_search_str = data.results[i].latlng.toString();
                    var app_search_res = app_search_str.substring(app_search_str.indexOf("(") + 1, app_search_str.indexOf(")"));
                    var app_searchArr = new Array();
                    app_searchArr = app_search_res.split(",");

                    document.getElementById("lat").value = app_searchArr[0].toString();
                    document.getElementById("lng").value = app_searchArr[1].toString(); 
                }
            });
            var popup = L.popup();

            function onMapClick(e) {
                var app = e.latlng.toString();
                var app_res = app.substring(app.indexOf("(") + 1, app.indexOf(")"));
                app_map.removeLayer(app_marker);
                results.clearLayers();
                results.addLayer(L.marker(e.latlng));   

                var app_tmpArr = new Array();
                app_tmpArr = app_res.split(",");

                document.getElementById("lat").value = app_tmpArr[0].toString(); 
                document.getElementById("lng").value = app_tmpArr[1].toString();
            }

            app_map.on('click', onMapClick);
        </script>