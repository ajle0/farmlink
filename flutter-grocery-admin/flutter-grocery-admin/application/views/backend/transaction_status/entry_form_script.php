<script>

	<?php if ( $this->config->item( 'client_side_validation' ) == true ): ?>

	function jqvalidate() {

		$('#transtatus-form').validate({
			rules:{
				
				title:{
					blankCheck : "",
					minlength: 3,
					remote: "<?php echo $module_site_url .'/ajx_exists/'.@$trans_status->id; ?>"
				},
				color_value:{
					blankCheck : "",
				}
			},
			messages:{
				
				title:{
					blankCheck : "<?php echo get_msg( 'err_trans_status_name' ) ;?>",
					minlength: "<?php echo get_msg( 'err_trans_status_len' ) ;?>",
					remote: "<?php echo get_msg( 'err_trans_status_exist' ) ;?>."
				},
				color_value:{
					blankCheck : "<?php echo get_msg( 'err_trans_status_color' ) ;?>",
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

	function runAfterJQ() {

		// colorpicker
		$('.my-colorpicker2').colorpicker()

      	
	}

</script>

<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>

<script type="text/javascript">
    $(document).ready(function(){
        $('input[type="radio"]').click(function(){
            var inputValue = $(this).attr("id");
            var targetBox = $("." + inputValue);
            $(".box").not(targetBox).hide();
            $(targetBox).show();
        });
    });




</script>




</script>