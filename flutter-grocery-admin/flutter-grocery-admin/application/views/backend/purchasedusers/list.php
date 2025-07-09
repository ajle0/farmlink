<div class="table-responsive animated fadeInRight">
	<table class="table m-0 table-striped">
		<tr>
			<th><?php echo get_msg('no'); ?></th>
			<th><?php echo get_msg('user_name'); ?></th>
			<th><?php echo get_msg('user_email'); ?></th>
			<th><?php echo get_msg('user_phone_label'); ?></th>
			<th><span class="th-title"><?php echo get_msg('view'); ?></span></th>
		</tr>

	<?php $count = $this->uri->segment(4) or $count = 0; ?>

	<?php if ( !empty( $purchasedusers ) && count( $purchasedusers->result()) > 0 ): ?>

		<?php foreach($purchasedusers->result() as $purchaseduser): ?>
			<tr>
				<td><?php echo ++$count;?></td>
				<td><?php echo $purchaseduser->user_name;?></td>
				<td><?php echo $purchaseduser->user_email;?></td>
				<td><?php echo $purchaseduser->user_phone;?></td>

				<?php if ( $this->ps_auth->has_access( EDIT )): ?>
			
					<td>
						<a href='<?php echo $module_site_url .'/edit/'. $purchaseduser->user_id; ?>'>
							<i class='fa fa-eye'></i>
						</a>
					</td>
				
				<?php endif; ?>
			</tr>

		<?php endforeach; ?>

	<?php else: ?>
			
		<?php $this->load->view( $template_path .'/partials/no_data' ); ?>

	<?php endif; ?>

</table>
</div>
