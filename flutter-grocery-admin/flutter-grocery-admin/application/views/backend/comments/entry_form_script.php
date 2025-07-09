<script>
	<?php if ( $this->config->item( 'client_side_validation' ) == true ): ?>

	function jqvalidate() {

		$('#comm-form').validate({
			rules:{
				detail_comment:{
					required: true,
					minlength: 1
				}
			},
			messages:{
				detail_comment_desc:{
					required: "<?php echo get_msg( 'err_push_msg' ) ;?>.",
					minlength: "<?php echo get_msg( 'err_len_push_msg' ) ;?>."
				}
			}
		});

	}

<?php endif; ?>
		

		var textFieldInFocus;
		function handleOnFocus(form_element)
		{
		   textFieldInFocus = form_element;
		}
		function handleOnBlur()
		{
		   textFieldInFocus = null;
		}

</script>