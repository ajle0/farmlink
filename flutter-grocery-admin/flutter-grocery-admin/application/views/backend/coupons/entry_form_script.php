<script>

	<?php if ( $this->config->item( 'client_side_validation' ) == true ): ?>

	function jqvalidate() {

		$('#coupon-form').validate({
			rules:{
				coupon_name:{
					blankCheck : "",
					minlength: 3,
					remote: "<?php echo $module_site_url .'/ajx_exists/'.@$coupon->id; ?>"
					
				},
				coupon_code:{
					blankCheck : "",
					minlength: 4,
				},
				coupon_amount:{
					blankCheck : "",
					indexCheck : "",
					minlength: 2,
				}
				
			},
			messages:{
				coupon_name:{
					blankCheck : "<?php echo get_msg( 'err_coupon_name' ) ;?>",
					minlength: "<?php echo get_msg( 'err_coupon_len' ) ;?>",
					remote: "<?php echo get_msg( 'err_coupon_exist' ) ;?>."
				},
				coupon_code:{
					blankCheck : "<?php echo get_msg( 'err_coupon_code_blank' ) ;?>",
					minlength: "<?php echo get_msg( 'err_coupon_code_len' ) ;?>",
				},
				coupon_amount:{
					blankCheck : "<?php echo get_msg( 'err_coupon_amount_blank' ) ;?>",
					minlength: "<?php echo get_msg( 'err_coupon_amount_len' ) ;?>",
					indexCheck: "<?php echo get_msg('coupon_amount_cannot_zero'); ?>"
 				}
				
			}

		});
			// custom validation
		jQuery.validator.addMethod("blankCheck",function( value, element ) {
			
			   if(value == "") {
			    	return false;
			   } else {
			   	 	return true;
			   }
		});

		jQuery.validator.addMethod("indexCheck",function( value, element ) {
			
			if(value == 0) {
				 return false;
			} else {
				 return true;
			};
			
	 	});

	}
	

	<?php endif; ?>
	$('input[name="coupon_amount"]').keyup(function(e) {
		  if (/[^\d.-]/g.test(this.value))
		  {
		    // Filter non-digits from input value.
		    this.value = this.value.replace(/[^\d.-]/g, '');
		  }
	});
</script>

