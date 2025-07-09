<script>

	<?php if ( $this->config->item( 'client_side_validation' ) == true ): ?>

	function jqvalidate() {

		$('#language-form').validate({
			rules:{
				symbol:{
					remote: "<?php echo $module_site_url .'/ajx_exists/'.@$lang->id; ?>",
					blankCheck : "",
					minlength: 3,
				},
				name:{
					blankCheck : "",
					minlength: 3,
					remote: "<?php echo $module_site_url .'/ajx_exists/'.@$lang->id; ?>"
				}
			},
			messages:{
				symbol:{
					remote: "<?php echo get_msg( 'err_symbol_exist' ) ;?>.",
					blankCheck : "<?php echo get_msg( 'err_lang_sym' ) ;?>",
					minlength: "<?php echo get_msg( 'err_lang_sym_len' ) ;?>"
				},
				name:{
					blankCheck : "<?php echo get_msg( 'err_lang_name' ) ;?>",
					minlength: "<?php echo get_msg( 'err_lang_len' ) ;?>",
					remote: "<?php echo get_msg( 'err_lang_exist' ) ;?>."
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
		})
	}

	<?php endif; ?>

</script>