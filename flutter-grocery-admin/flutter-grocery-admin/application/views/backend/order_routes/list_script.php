<script>

	// Delete Trigger
	$('.btn-delete').click(function(){
		
		// get id and links
		var id = $(this).attr('id');
		var btnYes = $('.btn-yes').attr('href');
		var btnNo = $('.btn-no').attr('href');

		// modify link with id
		$('.btn-yes').attr( 'href', btnYes + id );
		$('.btn-no').attr( 'href', btnNo + id );
	});

</script>

<?php
	// Delete Confirm Message Modal
	$data = array(
		'title' => get_msg( 'delete_order_route_label' ),
		'message' =>  get_msg( 'order_route_yes_all_message' ),
		'no_only_btn' => get_msg( 'order_route_no_only_label' )
	);
	
	$this->load->view( $template_path .'/components/delete_confirm_modal', $data );

	
?>

<script>
	// Send Order Route
	$('.btn-order-route').click(function(){
		
		// get id and links
		var id = $(this).attr('id');
		var btnYes = $('.btn-yes').attr('href');
		var btnNo = $('.btn-no').attr('href');

		// modify link with id
		$('.btn-yes').attr( 'href', btnYes + id );
		$('.btn-no').attr( 'href', btnNo + id );
	});
</script>

<?php
	// Send Order Route Confirm Message Modal
	$data1 = array(
		'title' => get_msg( 'send_order_route_label' ),
		'message' =>  get_msg( 'send_order_route_message' ),
		'no_only_btn' => get_msg( 'order_route_no_only_label' )
	);
	
	$this->load->view( $template_path .'/components/send_route_order_confirm_modal', $data1 );
?>