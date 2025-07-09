<script>
	function jqvalidate() {

		$(document).ready(function(){
			$('#apikey-form').validate({
				rules:{
					key:{
						required: true,
						minlength: 4
					}
				},
				messages:{
					key:{
						required: "<?php echo get_msg( 'err_title' ) ;?>.",
						minlength: "<?php echo get_msg( 'err_len_title' ) ;?>."
					}
				}
			});
		});
	}

</script>