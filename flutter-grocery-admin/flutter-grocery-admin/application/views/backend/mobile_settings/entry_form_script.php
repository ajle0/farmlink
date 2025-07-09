<script>
	function jqvalidate() {

		$(document).ready(function(){
			$('#app-form').validate({
				rules:{
					lat:{
						blankCheck : "",
						indexCheck : "",
						validChecklat : ""
					},
					lng:{
						blankCheck : "",
						indexCheck : "",
						validChecklng : ""
					},
					default_language:{
						indexCheck : "",
					},
					default_loading_limit:{
						blankCheck : "",
						indexCheck : ""
					},
					category_loading_limit:{
						blankCheck : "",
						indexCheck : ""
					},
					collection_product_loading_limit:{
						blankCheck : "",
						indexCheck : ""
					},
					discount_product_loading_limit:{
						blankCheck : "",
						indexCheck : ""
					},
					feature_product_loading_limit:{
						blankCheck : "",
						indexCheck : ""
					},
					latest_product_loading_limit:{
						blankCheck : "",
						indexCheck : ""
					},
					shop_loading_limit:{
						blankCheck : "",
						indexCheck : ""
					},
					trending_product_loading_limit:{
						blankCheck : "",
						indexCheck : ""
					},
					google_playstore_url:{
						blankCheck : ""
					},
					apple_appstore_url:{
						blankCheck : ""
					},
					ios_appstore_id:{
						blankCheck : ""
					},
					fb_key:{
						blankCheck : ""
					},
					date_format:{
						blankCheck : ""
					},
					price_format:{
						blankCheck : ""
					},
					default_order_time:{
						blankCheck : "",
						indexCheck : ""
					},
				},
				messages:{
					lat:{
						blankCheck : "<?php echo get_msg( 'err_lat' ) ;?>",
						indexCheck : "<?php echo get_msg( 'err_lat_lng' ) ;?>",
						validChecklat : "<?php echo get_msg( 'lat_invlaid' ) ;?>"
					},
					lng:{
						blankCheck : "<?php echo get_msg( 'err_lng' ) ;?>",
						indexCheck : "<?php echo get_msg( 'err_lat_lng' ) ;?>",
						validChecklng : "<?php echo get_msg( 'lng_invlaid' ) ;?>"
					},
					default_language:{
						indexCheck : "<?php echo get_msg( 'err_default_lang' ) ;?>",
					},
					default_loading_limit:{
						indexCheck : "<?php echo get_msg( 'err_default_loading_limit_zero' ) ;?>",
						blankCheck : "<?php echo get_msg( 'err_default_loading_limit' ) ;?>",
					},
					category_loading_limit:{
						indexCheck : "<?php echo get_msg( 'err_category_loading_limit_zero' ) ;?>",
						blankCheck : "<?php echo get_msg( 'err_category_loading_limit' ) ;?>",
					},
					collection_product_loading_limit:{
						indexCheck : "<?php echo get_msg( 'err_collection_product_loading_limit_zero' ) ;?>",
						blankCheck : "<?php echo get_msg( 'err_collection_product_loading_limit' ) ;?>",
					},
					discount_product_loading_limit:{
						indexCheck : "<?php echo get_msg( 'err_discount_product_loading_limit_zero' ) ;?>",
						blankCheck : "<?php echo get_msg( 'err_discount_product_loading_limit' ) ;?>",
					},
					feature_product_loading_limit:{
						indexCheck : "<?php echo get_msg( 'err_feature_product_loading_limit_zero' ) ;?>",
						blankCheck : "<?php echo get_msg( 'err_feature_product_loading_limit' ) ;?>",
					},
					latest_product_loading_limit:{
						indexCheck : "<?php echo get_msg( 'err_latest_product_loading_limit_zero' ) ;?>",
						blankCheck : "<?php echo get_msg( 'err_latest_product_loading_limit' ) ;?>",
					},
					shop_loading_limit:{
						indexCheck : "<?php echo get_msg( 'err_shop_loading_limit_zero' ) ;?>",
						blankCheck : "<?php echo get_msg( 'err_shop_loading_limit' ) ;?>",
					},
					trending_product_loading_limit:{
						indexCheck : "<?php echo get_msg( 'err_trending_product_loading_limit_zero' ) ;?>",
						blankCheck : "<?php echo get_msg( 'err_trending_product_loading_limit' ) ;?>",
					},
					default_order_time:{
						indexCheck : "<?php echo get_msg( 'err_default_order_time_zero' ) ;?>",
						blankCheck : "<?php echo get_msg( 'err_default_order_time' ) ;?>",
					},
					google_playstore_url:{
						blankCheck : "<?php echo get_msg( 'err_google_playstore_url' ) ;?>",
					},
					apple_appstore_url:{
						blankCheck : "<?php echo get_msg( 'err_apple_appstore_url' ) ;?>",
					},
					ios_appstore_id:{
						blankCheck : "<?php echo get_msg( 'err_ios_appstore_id' ) ;?>",
					},
					price_format:{
						blankCheck : "<?php echo get_msg( 'err_price_format' ) ;?>",
					},
					date_format:{
						blankCheck : "<?php echo get_msg( 'err_date_format' ) ;?>",
					},
					fb_key:{
						blankCheck : "<?php echo get_msg( 'err_fb_key' ) ;?>",
					},
				}
			});

			// default language is selected, available language is auto on
			var default_language = $('#default_language').val();
			const language_codes = ['en', 'ar', 'hi', 'de', 'es', 'fr', 'id', 'it', 'ja', 'ko', 'ms', 'pt', 'ru', 'th', 'tr', 'zh'];

			for(let x in language_codes){
				
				if(language_codes[x] == default_language){
					$('#'+default_language).attr('checked', true);
					$('#'+default_language).attr('disabled', true);
				}else{
					$('#'+language_codes[x]).attr('disabled', false);
				}
			}
		});

		jQuery.validator.addMethod("indexCheck",function( value, element ) {
			if(value == 0) {
					return false;
			} else {
					return true;
			};
	 	});

		jQuery.validator.addMethod("blankCheck",function( value, element ) {
			if(value == "") {
				return false;
			} else {
				return true;
			}
		});
		
		jQuery.validator.addMethod("validChecklat",function( value, element ) {
			if (value < -90 || value > 90) {
				return false;
			} else {
				return true;
			}
		});

		jQuery.validator.addMethod("validChecklng",function( value, element ) {
			if (value < -180 || value > 180) {
				return false;
			} else {
				return true;
			}
		});
	}

	function runAfterJQ() {

		$('#default_language').on('change', function() {

			var default_language = $(this).val();

			const language_codes = ['en', 'ar', 'hi', 'de', 'es', 'fr', 'id', 'it', 'ja', 'ko', 'ms', 'pt', 'ru', 'th', 'tr', 'zh'];

			for(let x in language_codes){
				
				if(language_codes[x] == default_language){
					$('#'+default_language).attr('checked', true);
					$('#'+default_language).attr('disabled', true);
				}else{
					$('#'+language_codes[x]).attr('disabled', false);
				}
			}
		});
	}

	$('input[name="ios_appstore_id"]').keyup(function(e) {
		if (/[^\d.-]/g.test(this.value))
		{
		// Filter non-digits from input value.
		this.value = this.value.replace(/[^\d.-]/g, '');
		}
	});

	$('input[name="fb_key"]').keyup(function(e) {
		if (/[^\d.-]/g.test(this.value))
		{
		// Filter non-digits from input value.
		this.value = this.value.replace(/[^\d.-]/g, '');
		}
	});
	
	$('input[name="default_order_time"]').keyup(function(e) {
		if (/[^\d.-]/g.test(this.value))
		{
		// Filter non-digits from input value.
		this.value = this.value.replace(/[^\d.-]/g, '');
		}
	});

	$('input[name="default_loading_limit"]').keyup(function(e) {
		if (/[^\d.-]/g.test(this.value))
		{
		// Filter non-digits from input value.
		this.value = this.value.replace(/[^\d.-]/g, '');
		}
	});

	$('input[name="category_loading_limit"]').keyup(function(e) {
		if (/[^\d.-]/g.test(this.value))
		{
		// Filter non-digits from input value.
		this.value = this.value.replace(/[^\d.-]/g, '');
		}
	});

	$('input[name="collection_product_loading_limit"]').keyup(function(e) {
		if (/[^\d.-]/g.test(this.value))
		{
		// Filter non-digits from input value.
		this.value = this.value.replace(/[^\d.-]/g, '');
		}
	});

	$('input[name="discount_product_loading_limit"]').keyup(function(e) {
		if (/[^\d.-]/g.test(this.value))
		{
		// Filter non-digits from input value.
		this.value = this.value.replace(/[^\d.-]/g, '');
		}
	});

	$('input[name="feature_product_loading_limit"]').keyup(function(e) {
		if (/[^\d.-]/g.test(this.value))
		{
		// Filter non-digits from input value.
		this.value = this.value.replace(/[^\d.-]/g, '');
		}
	});

	$('input[name="latest_product_loading_limit"]').keyup(function(e) {
		if (/[^\d.-]/g.test(this.value))
		{
		// Filter non-digits from input value.
		this.value = this.value.replace(/[^\d.-]/g, '');
		}
	});

	$('input[name="shop_loading_limit"]').keyup(function(e) {
		if (/[^\d.-]/g.test(this.value))
		{
		// Filter non-digits from input value.
		this.value = this.value.replace(/[^\d.-]/g, '');
		}
	});

	$('input[name="trending_product_loading_limit"]').keyup(function(e) {
		if (/[^\d.-]/g.test(this.value))
		{
		// Filter non-digits from input value.
		this.value = this.value.replace(/[^\d.-]/g, '');
		}
	});

</script>