<div class="panel-group" id="accordion" role="tablist" aria-multiselectable="true" class="table-responsive animated fadeInRight">
			
	<div class="card-body table-responsive p-0">
        <?php 
            $be_config = $this->Backend_config->get_one('be1');
        ?>
        <input type="hidden" name="noti_time" id="noti_time" value="<?php echo isset($be_config->schedule_order_noti_sound_refresh_time) ? $be_config->schedule_order_noti_sound_refresh_time : 30; ?>">
        <input type="hidden" name="page_time" id="page_time" value="<?php echo isset($be_config->schedule_order_page_refresh_time) ? $be_config->schedule_order_page_refresh_time : 30; ?>">
  		<table class="table m-0 table-striped">
			<?php $count = $this->uri->segment(4) or $count = 0; ?>

			<?php if ( !empty( $schedule_orders ) && count( $schedule_orders->result()) > 0 ): ?>
				<?php foreach($schedule_orders->result() as $schedule_order): ?>
					
		  					<tbody style="font-size: 16px;">
			  					<tr>	
			  						<td style="width: 30%;">
			  							<?php
											echo $schedule_order->contact_name . "<br>( Contact: " . $schedule_order->contact_phone . " )";
										?>
									</td>
									<td style="width: 8%;">
			  							<?php
											echo $schedule_order->trans_code;
										?>
									</td>
									<td style="width: 10%;">
										<?php 
										$conds['id'] = $schedule_order->trans_status_id;
										$title = $this->Transactionstatus->get_one_by($conds)->title;
										if ($schedule_order->trans_status_id == 'trans_sts29a4b0cd2fa6ae0449e47e9568320f3a') { ?>
							                <span class="badge badge-secondary">
							                  <?php echo $title; ?>
							                </span>
							            <?php } elseif ($schedule_order->trans_status_id == 'trans_stsabda7751186eb039c98f7602553a0ba0') { ?>
							                <span class="badge badge-success">
							                  <?php echo $title; ?>
							                </span>
							            <?php } elseif ($schedule_order->trans_status_id == 'trans_sts3e03079b68d8c052480c22d91ca2a0b9') { ?>
							                <span class="badge badge-warning">
							                  <?php echo $title; ?>
							                </span>
							            <?php } elseif ($schedule_order->trans_status_id == 'trans_sts8a3df6bad54007f1db11ed9531828112') { ?>
							                <span class="badge badge-info">
							                  <?php echo $title; ?>
							                </span>
                                        <?php } elseif ($schedule_order->trans_status_id == 'trans_sts47fe98346e0f80d844d307981eaef7ec') { ?>
                                            <span class="badge" style="background-color : #FF7B7B;">
							                  <?php echo $title; ?>
							                </span>
										<?php } elseif ($schedule_order->trans_status_id == 'trans_sts1432c4708d810e38dc04f017c0b329dc') { ?>
                                            <span class="badge" style="background-color : #FF5252;">
							                  <?php echo $title; ?>
							                </span>
                                        <?php } elseif ($schedule_order->trans_status_id == 'trans_stsef071eefcc46df677fe52e7afe414199') { ?>
                                            <span class="badge" style="background-color : #FFBEAF;">
							                  <?php echo $title; ?>
							                </span>
                                        <?php } else { ?>
							                <span class="badge badge-primary" style="background-color: #53D1FF;">
							                  <?php echo $title; ?>
							                </span>
						            	<?php } ?>
									</td>
									<td style="width: 10%;">
										<?php
											
											$conds_hdr['schedule_header_id'] = $schedule_order->id;
											$schedule_details =  $this->Schedule_detail->get_all_by($conds_hdr);
											$total_item_count = 0;

											foreach($schedule_details->result() as $schedule_detail){
												if($schedule_detail->qty_modify == 0){
													$total_item_count += $schedule_detail->qty;
												}else{
													$total_item_count += $schedule_detail->qty_modify;
												}
											}

											echo "<div class='text-center'><small>" . $total_item_count . " Foods </small></div>";
									 	?>
									</td>
									<td style="width: 20%;">
										<?php echo date("Y-m-d",strtotime($schedule_order->added_date)); ?>
									</td>
									<td style="width: 22%;">

										<a herf='#' class='btn-delete btn btn-sm btn-danger text-white' data-toggle="modal" data-target="#reportsmodal" id="<?php echo "$schedule_order->id";?>">
										<?php echo get_msg('btn_delete'); ?>
										</a>
				
										<?php if ( @$schedule_order->schedule_status == 1): ?>
											<button class="btn btn-success unpublish btn-sm" id='<?php echo $schedule_order->id;?>'>
											<?php echo get_msg('btn_proceed'); ?></button>
										<?php else:?>
											<?php if ( @$schedule_order->user_id == '-1'): ?>												
												<button class="btn btn-warning btn-sm disabled" id='<?php echo $schedule_order->id;?>'>
												<?php echo get_msg('btn_paused'); ?></button>
											<?php else: ?>
												<button class="btn btn-warning publish btn-sm" id='<?php echo $schedule_order->id;?>'>
												<?php echo get_msg('btn_paused'); ?></button>
											<?php endif;?>
										<?php endif;?>
										<a class="btn btn-primary btn-sm" href="<?php echo $module_site_url . "/detail/" . $schedule_order->id;?>">
											<?php echo get_msg('view'); ?>
										</a>

									</td>
								</tr>
							</tbody>
						
			
			<?php endforeach; ?>
			<?php else: ?>
					
				<?php $this->load->view( $template_path .'/partials/no_data' ); ?>

			<?php endif; ?>
		</table>
	</div>
</div>
