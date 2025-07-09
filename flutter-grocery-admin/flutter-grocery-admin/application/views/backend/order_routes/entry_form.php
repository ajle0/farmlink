<?php
	$attributes = array( 'id' => 'route-form', 'enctype' => 'multipart/form-data');
	echo form_open( '', $attributes);
?>

<section class="content animated fadeInRight">
	<div class="card card-info">
	    <div class="card-header">
	        <h3 class="card-title"><?php echo get_msg('order_route_info_label')?></h3>
	    </div>
        <!-- /.card-header -->
        <div class="card-body">
			
            <div class="row">
				<div class="col-12">
					<div class="float-right">
						<?php if($route->updated_flag == 0): ?>
							<button type="submit" name="deliver_order_route" id="deliver_order_route" class="btn btn-outline-dark">
            					<?php echo get_msg('deliver_to_user'); ?>
         					</button>
						<?php else: ?>
							<button type="submit" name="deliver_order_route" id="deliver_order_route" class="btn btn-dark disabled">
								<?php echo get_msg('delivered_to_user') ?>
         					</button>
						<?php endif; ?>
					</div>
				</div>
             	<div class="col-md-6">
					<div class="form-group">
                   		<label> <span style="font-size: 17px; color: red;">*</span>
							<?php echo get_msg('route_name_label')?>
							<a href="#" class="tooltip-ps" data-toggle="tooltip" title="<?php echo get_msg('name_tooltips')?>">
								<span class='glyphicon glyphicon-info-sign menu-icon'>
							</a>
						</label>
						<?php echo form_input( array (
							'name' => 'name',
							'value' => set_value( 'name', show_data(@$route->name),false),
							'class' => 'form-control form-control-sm',
							'placeholder' => get_msg('route_name_label'),
							'id' => 'name',
						)); ?>
					</div>	
					
					<div class="form-group">

						<label> <span style="font-size: 17px; color: red;">*</span>
							<?php echo get_msg('select_deli_boy')?>
						</label>
						<br>

						<select  name="delivery_boy_id" id="delivery_boy_id" class="form-control">
                            <option value="0"><?php echo get_msg('select_deli_boy'); ?></option>
                            <?php
                            $conds['role_id'] = 5;
                            $conds['status']= 1;
                            $deli_boys = $this->User->get_all_by($conds);
                            foreach ($deli_boys->result() as $boy)
                            {
                                echo "<option value='".$boy->user_id."'";
                                if($route->delivery_boy_id == $boy->user_id)
                                {
                                    echo " selected ";
                                }
                                echo ">".$boy->user_name."</option>";
                            }
                            ?>
                        </select>
						<?php if($route->delivery_boy_id == '-1'): ?>
						<span class="text-danger"><?php echo get_msg("deliboy_trans_deleted"); ?></span>
						<?php endif; ?>
					</div>						
				</div>	
				<div class="col-md-6">
					<div class="form-group mt-2">
						<label>
							<?php echo get_msg('note_label')?>
						</label>

						<?php echo form_textarea( array(
							'name' => 'note',
							'value' => set_value( 'info', show_data( @$route->note), false ),
							'class' => 'form-control form-control-sm p-2',
							'placeholder' => get_msg('note_label'),
							'id' => 'info',
							'rows' => "5"
						)); ?>

					</div>
				</div>	
			</div>	
			<hr>

			<div class="table-responsive" style="padding: 10px 20px 5px 10px;">
			   
			    <div class="col-md-12">
					<table id="order-table" class="table table-bordered table-striped table-hover">
						
						<thead>
							<tr>
								<?php 
									$selected_shop_id = $this->session->userdata('selected_shop_id');
									$shop_id = $selected_shop_id['shop_id']; 
								?>
								<th><input name="select_all" value="1" type="checkbox"></th>
								<th><?php echo get_msg('trans_code_label'); ?></th>
								<th><?php echo get_msg('contact_name'); ?></th>
								<th><?php echo get_msg('phone_label'); ?></th>
								<th><?php echo get_msg('qty_label'); ?></th>
								<th><?php echo get_msg('price_label') . '(' . $this->Shop->get_one($shop_id)->currency_symbol . ')' ; ?></th>
								<th><?php echo get_msg('schedule_status_label'); ?></th>
								<th><span class="th-title"><?php echo get_msg('btn_edit')?></span></th>
							</tr>
						</thead>

						<tbody>
						</tbody>
					</table>
				</div>
			</div>
		</div>
		<div class="card-footer">
			<?php if($route->updated_flag == 1): ?>
				<a href="<?php echo $module_site_url; ?>" class="btn btn-primary"><?php echo get_msg('btn_back')?></a>
			<?php else: ?>
			<button type="submit" class="btn btn-sm btn-primary save" >
				<?php echo get_msg('btn_save')?> 
			</button>

			<a href="<?php echo $module_site_url; ?>" class="btn btn-sm btn-primary">
				<?php echo get_msg('btn_cancel')?>
			</a>
			<?php endif; ?>
			<div id="divCheckbox" style="display: none;"> 
				<p><b><?php echo get_msg('selected_row_data')?>:</b></p>
				<pre id="example-console-rows"></pre>

				<p><b><?php echo get_msg('form_data_submit_server')?>:</b></p>
				<pre id="example-console-form"></pre>

				<input type="text" name="newchkval" id="newchkval" size="300">

			</div> 
		</div>
	</div>
</section>

<?php echo form_close(); ?>
