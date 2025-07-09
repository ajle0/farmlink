<div class="table-responsive animated fadeInRight">
	<table class="table m-0 table-striped">
		<tr>
			<th><?php echo get_msg('no'); ?></th>
			<th><?php echo get_msg('route_name_label'); ?></th>
			<th><?php echo get_msg('delivery_boy_label'); ?></th>
			<th><?php echo get_msg('total_amount_label'); ?></th>
			<th><?php echo get_msg('added_date_label'); ?></th>
			
			<?php if ( $this->ps_auth->has_access( EDIT )): ?>
				
				<th><span class="th-title"><?php echo get_msg('btn_edit')?></span></th>
			
			<?php endif; ?>
			
			<?php if ( $this->ps_auth->has_access( DEL )): ?>
				
				<th><span class="th-title"><?php echo get_msg('btn_delete')?></span></th>
			
			<?php endif; ?>

			<?php if ( $this->ps_auth->has_access( EDIT )): ?>
				
				<th><span class="th-title"><?php echo get_msg('send_with_this_route')?></span></th>

			<?php endif; ?>
			

		</tr>
		
	
	<?php $count = $this->uri->segment(4) or $count = 0; ?>

	<?php if ( !empty( $routes ) && count( $routes->result()) > 0 ): ?>

		<?php foreach($routes->result() as $route): ?>
			
			<tr>
				<td><?php echo ++$count;?></td>
				<td><?php echo $route->name;?></td>
				<td><?php echo $route->delivery_boy_id == '-1'? "<span class='text-danger'>".get_msg('deleted_deliboy')."</span>": $this->User->get_one($route->delivery_boy_id)->user_name;?></td>
				<td><?php echo $route->total_amount;?></td>
				<td><?php echo $route->added_date;?></td>

				<?php if ( $this->ps_auth->has_access( EDIT )): ?>
			
					<td>
						<a href='<?php echo $module_site_url .'/edit/'. $route->id; ?>'>
							<i class='fa fa-pencil-square-o'></i>
						</a>
					</td>
				
				<?php endif; ?>
				
				<?php if ( $this->ps_auth->has_access( DEL )): ?>
					
					<td>
						<a herf='#' class='btn-delete' data-toggle="modal" data-target="#myModal" id="<?php echo "$route->id";?>">
							<i class='fa fa-trash-o'></i>
						</a>
					</td>
				
				<?php endif; ?>
				
				<?php if ( $this->ps_auth->has_access( EDIT )): ?>
					
					<td>
						<?php if($this->Order_route->get_one($route->id)->updated_flag==0): ?>
							<button class="btn btn-sm btn-success btn-order-route" id='<?php echo $route->id;?>' data-toggle="modal" data-target="#modalOrderRoute" ><?php echo get_msg('btn_send'); ?></button>
						<?php else: ?>
							<button class="btn btn-sm btn-success btn-order-route" id='<?php echo $route->id;?>' disabled><?php echo get_msg('btn_delivered'); ?></button>
						<?php endif; ?>
					</td>
				
				<?php endif; ?>

			</tr>

		<?php endforeach; ?>


	<?php else: ?>
			
		<?php $this->load->view( $template_path .'/partials/no_data' ); ?>

	<?php endif; ?>

</table>
</div>

