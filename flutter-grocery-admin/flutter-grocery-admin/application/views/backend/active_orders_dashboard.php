<div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true" class="table-responsive animated fadeInRight" style="padding-top: 10px;">
	<input type="hidden" name="noti_time" id="noti_time" value="<?php echo $this->Backend_config->get_one('be1')->transaction_noti_sound_refresh_time ?>">
    <input type="hidden" name="page_time" id="page_time" value="<?php echo $this->Backend_config->get_one('be1')->transaction_page_refresh_time ?>">
  		
	<!-- New Orders  -->

	<legend class="ml-3 mt-3 mb-5 font-weight-bold"><u><?php echo get_msg('new_orders')?></u></legend>
			
	<table class="table m-0 table-striped">
		<?php 
			$selected_shop_id = $this->session->userdata('selected_shop_id');
          	$shop_id = $selected_shop_id['shop_id'];
		?>
		<tr>
			<th><?php echo get_msg('no'); ?></th>
			<th><?php echo get_msg('trans_code'); ?></th>
			<th><?php echo get_msg('user_name'); ?></th>
			<th><?php echo get_msg('user_phone_label'); ?></th>
			<th><?php echo get_msg('total_amount_label') . ' (' . $this->Shop->get_one($shop_id)->currency_symbol . ')'; ?></th>
			<th><?php echo get_msg('date'); ?></th>

			<?php if ( $this->ps_auth->has_access( EDIT )): ?>
				
				<th><span class="th-title"><?php echo get_msg('accept_order_label')?></span></th>
			
			<?php endif; ?>


			<?php if ( $this->ps_auth->has_access( EDIT )): ?>
				
				<th><span class="th-title"><?php echo get_msg('reject_order_label')?></span></th>
			
			<?php endif; ?>
			
			<?php if ( $this->ps_auth->has_access( EDIT )): ?>
				
				<th><span class="th-title"><?php echo get_msg('order_detail_label')?></span></th>
			
			<?php endif; ?>

		</tr>

		<?php $count = 0; ?>

		<?php 
			$conds['shop_id'] = $shop_id;
          	$conds['trans_status_id'] = 'trans_sts29a4b0cd2fa6ae0449e47e9568320f3a';

          	$new_orders = $this->Transactionheader->get_all_by($conds)->result();
			
			if ( !empty( $new_orders ) && count( $new_orders ) > 0 ): ?>

				<?php foreach($new_orders as $new_order): ?>
					
					<tr>
						<td><?php echo ++$count;?></td>
						<td><?php echo $new_order->trans_code;?></td>
						<td><?php echo $this->User->get_one($new_order->user_id)->user_name;?></td>
						<td><?php echo $this->User->get_one($new_order->user_id)->user_phone;?></td>
						<td><?php echo $new_order->total_item_amount;?></td>
						<td><?php echo $new_order->added_date;?></td>
						<?php if ( $this->ps_auth->has_access( EDIT )): ?>
					
							<td>
								<a class="btn btn-sm btn-success" href="<?php echo $module_site_url . "/accept_order/" . $new_order->id;?>">
									<?php echo get_msg('btn_accept') ?>

								</a>
							</td>
						
						<?php endif; ?>

						<?php if ( $this->ps_auth->has_access( EDIT )): ?>
					
							<td>
								<a class="btn btn-sm btn-danger" href="<?php echo $module_site_url . "/reject_order/" . $new_order->id;?>">
									<?php echo get_msg('btn_reject') ?>

								</a>
							</td>
						
						<?php endif; ?>

						<?php if ( $this->ps_auth->has_access( EDIT )): ?>
							
							<td>
								<a class="btn btn-sm btn-primary" href="<?php echo $module_site_url . "/detail/" . $new_order->id;?>">
									<?php echo get_msg('btn_detail') ?>

								</a>
							</td>
						
						
						<?php endif; ?>

					</tr>

				<?php endforeach; ?>

			<?php else: ?>
					
				<?php $this->load->view( $template_path .'/partials/no_data' ); ?>

			<?php endif; ?>		

	</table>

	<br>
	<hr width="100%" class="bg-dark">

	<!-- Ongoing Orders  -->

	<legend class="ml-3 mt-3 mb-5 font-weight-bold"><u><?php echo get_msg('ongoing_orders')?></u></legend>
			
		<table class="table m-0 table-striped">
			<?php 
				$selected_shop_id = $this->session->userdata('selected_shop_id');
	          	$shop_id = $selected_shop_id['shop_id'];
			?>
			<tr>
				<th><?php echo get_msg('no'); ?></th>
				<th><?php echo get_msg('trans_code'); ?></th>
				<th><?php echo get_msg('user_name'); ?></th>
				<th><?php echo get_msg('user_phone_label'); ?></th>
				<th><?php echo get_msg('delivery_boy_name_label'); ?></th>
				<th><?php echo get_msg('delivery_phone_label'); ?></th>
				<th><?php echo get_msg('total_amount_label') . ' (' . $this->Shop->get_one($shop_id)->currency_symbol . ')'; ?></th>
				<th><?php echo get_msg('date'); ?></th>
				<th><?php echo get_msg('order_status_label'); ?></th>

				<?php if ( $this->ps_auth->has_access( EDIT )): ?>
					
					<th><span class="th-title"><?php echo get_msg('retrigger_label')?></span></th>
				
				<?php endif; ?>
				
				<?php if ( $this->ps_auth->has_access( EDIT )): ?>
					
					<th><span class="th-title"><?php echo get_msg('order_detail_label')?></span></th>
				
				<?php endif; ?>

				<?php if ( $this->ps_auth->has_access( EDIT )): ?>
					
					<th><span class="th-title"><?php echo get_msg('assign_to_delivery_boy_label')?></span></th>
				
				<?php endif; ?>

			</tr>

			<?php $count = 0; ?>

			<?php 
				$conds1['shop_id'] = $shop_id;

	          	$ongoing_order = $this->Transactionheader->get_all_by($conds1)->result();


				if ( !empty( $ongoing_order ) && count( $ongoing_order ) > 0 ): ?>

					<?php foreach($ongoing_order as $ongoing): 

						$start_stage = $this->Transactionstatus->get_one($ongoing->trans_status_id)->start_stage;
						$final_stage = $this->Transactionstatus->get_one($ongoing->trans_status_id)->final_stage;
						$is_optional = $this->Transactionstatus->get_one($ongoing->trans_status_id)->is_optional;
						$title = $this->Transactionstatus->get_one($ongoing->trans_status_id)->title;

					?>

						<?php if( $start_stage == "0" && $final_stage == "0" && $is_optional == "0") : ?>
						
							<tr>
								<td><?php echo ++$count;?></td>
								<td><?php echo $ongoing->trans_code;?></td>
								<td><?php echo $this->User->get_one($ongoing->user_id)->user_name;?></td>
								<td><?php echo $this->User->get_one($ongoing->user_id)->user_phone;?></td>
								<td><?php echo $this->User->get_one($ongoing->delivery_boy_id)->user_name;?></td>
								<td><?php echo $this->User->get_one($ongoing->delivery_boy_id)->user_phone;?></td>
								<td><?php echo $ongoing->total_item_amount;?></td>
								<td><?php echo $ongoing->added_date;?></td>
								<td>
									<?php if ($ongoing->trans_status_id == 'trans_stsabda7751186eb039c98f7602553a0ba0') { ?>
						                <span class="badge badge-success">
						                  <?php echo $title; ?>
						                </span>
						            <?php } elseif ($ongoing->trans_status_id == 'trans_sts3e03079b68d8c052480c22d91ca2a0b9') { ?>
						                <span class="badge badge-warning">
						                  <?php echo $title; ?>
						                </span>
						            <?php } elseif ($ongoing->trans_status_id == 'trans_sts8a3df6bad54007f1db11ed9531828112') { ?>
						                <span class="badge badge-info">
						                  <?php echo $title; ?>
						                </span>  
						            <?php } ?>  
						        </td>        
								<?php if ( $this->ps_auth->has_access( EDIT )): ?>
							
									<td>
										<?php if(($ongoing->delivery_boy_id == "" || $ongoing->delivery_boy_id == "0") && $this->Shop->get_one($shop_id)->deli_auto_assign == 1): ?>
											<a class="btn btn-sm btn-info" href="<?php echo $module_site_url . "/retrigger/" . $new_order->id;?>">
												<?php echo get_msg('btn_retrigger') ?>
											</a>
										<?php else: ?>
											<button class="btn btn-sm btn-info" href="<?php echo $module_site_url . "/retrigger/" . $new_order->id;?>" disabled>
												<?php echo get_msg('btn_retrigger') ?>
											</button>
										<?php endif; ?>
									</td>
								
								<?php endif; ?>

								<?php if ( $this->ps_auth->has_access( EDIT )): ?>
									
									<td>
										<a class="btn btn-sm btn-primary" href="<?php echo $module_site_url . "/detail/" . $ongoing->id;?>">
											<?php echo get_msg('btn_detail') ?>

										</a>
									</td>
								
								
								<?php endif; ?>

								<?php if ( $this->ps_auth->has_access( EDIT )): ?>
									
									<td>
										<?php if(($ongoing->delivery_boy_id == "" || $ongoing->delivery_boy_id == "0") && $this->Shop->get_one($shop_id)->deli_manual_assign == 1): ?>
											<a herf='#' class='btn btn-sm btn-warning btn-assign' data-toggle="modal" data-target="#assignDeliboyModal" id="<?php echo "$ongoing->id";?>">
												<?php echo get_msg('btn_assign_to_deliboy') ?>
											</a>
										<?php else: ?>
											<button class='btn btn-sm btn-warning btn-assign' data-toggle="modal" data-target="#assignDeliboyModal" id="<?php echo "$ongoing->id";?>" disabled>
												<?php echo get_msg('btn_assign_to_deliboy') ?>
										</button>
										<?php endif; ?>
									</td>
								
								
								<?php endif; ?>

							</tr>
						<?php endif; ?>	

					<?php endforeach; ?>

				<?php else: ?>
						
					<?php $this->load->view( $template_path .'/partials/no_data' ); ?>

				<?php endif; ?>		

		</table>

</div>	
<script>
	    // Initial call i make so user do not wait 2 seconds for messages to show
		function refresh() {
        $.ajax({
            method: 'GET',
            dataType: 'JSON',
            url:  '<?php echo $module_site_url . '/get_all_new_orders/';?>',
            cache: false,
            success:function(msg){

                if ( msg == true) {
                    var audio = new Audio("<?php echo base_url('assets/backend/audio.mp3'); ?>");
                    audio.play();

                    //setTimeout("location.reload(true);", 3000);

                }


            }
        });

    }
    //autorefresh sound every 2 seconds
    var noti_time = document.getElementById("noti_time").value ;
    setInterval(function () {
        refresh();
    }, noti_time);

    //autorefresh page every 10 seconds
    var page_time = document.getElementById("page_time").value ;
    window.setTimeout(function () {
        window.location.reload();
    }, page_time);


	$('.btn-assign').click(function(){
		
		// get id and links
		var id = $(this).attr('id');
		var formLink = $('#assign-deliboy-form').attr('action');

		// modify link with id
		$('#assign-deliboy-form').attr( 'action', formLink + id );
	});
</script>

<?php
	// Assign Delivery Boy Modal
	$data = array(
		'title' => get_msg( 'assign_deliboy' )
	);
	
	$this->load->view( $template_path .'/components/assign_deliboy_modal', $data );
?>