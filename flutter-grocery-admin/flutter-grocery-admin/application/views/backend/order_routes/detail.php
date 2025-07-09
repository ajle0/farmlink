<div class="invoice p-4 mb-5 shadow-sm rounded">
  	<!-- title row -->
  	<div class="row">
    	<div class="col-12">
      		<h4>
        	<?php echo get_msg('shcedule_detail'); ?>
			<span class="font-weight-bold float-right"><?php echo get_msg('invoice_label'); ?> <?php echo $schedule_order->trans_code?></span><br>
			<small class="float-right pt-3"><?php echo get_msg('trans_date_label'); ?>: <?php echo $schedule_order->added_date; ?></small><br>
      		</h4>
    	</div>
		
    <!-- /.col -->
  	</div>
  <!-- info row -->
	<div class="row invoice-info mt-4">

		<div class="col-sm-6 invoice-col">
			<b><u><?php echo get_msg('cust_info'); ?></u></b> <br><br>
			<address>
				<p><?php echo get_msg('name_label'); ?>: <?php echo $schedule_order->contact_name; ?></p>
				<p><?php echo get_msg('email_label'); ?>: <?php echo $schedule_order->contact_email; ?></p>
				<p><?php echo get_msg('phone_label'); ?>: <?php echo $schedule_order->contact_phone;?></p>
				<p><?php echo get_msg('address_label'); ?>: <?php echo $schedule_order->contact_address;?></p>
			</address>
			
			<?php if($schedule_order->user_id == '-1'): ?>
			<span class="text-danger"><?php echo get_msg("deleted_user"); ?></span>
			<?php endif; ?>
		</div>
		<!-- /.col -->
		<div class="col-sm-6 invoice-col">
			<b><u><?php echo get_msg('cust_loc'); ?></u></b> <br><br>
			<div id="schedule_order_map" style="height: 150px;" class="col-8"></div>

			<div class="clearfix">&nbsp;</div>
		</div>
	</div>

	<div class="row">
		<div class="col-12 table-responsive">
		  <table class="table table-striped">
		    <thead>
			    <tr>
			      	<th><?php echo get_msg('Prd_name'); ?></th>
					<th><?php echo get_msg('Prd_price'); ?></th>
					<th><?php echo get_msg('Prd_qty'); ?></th>
					<th><?php echo get_msg('Prd_dis'); ?></th>
					<th><?php echo get_msg('Prd_amt'); ?></th>
			    </tr>
		    </thead>
		    <tbody>
		    	<?php 
					$conds['schedule_header_id'] = $schedule_order->id;
					$all_detail =  $this->Schedule_detail->get_all_by( $conds );
					
					foreach($all_detail->result() as $schedule_order_detail):

				?>
				<tr>
					<td>
						<?php 

						
						$att_name_info  = explode("#", $schedule_order_detail->product_customized_name);
						$att_price_info = explode("#", $schedule_order_detail->product_customized_price);

						$addon_name_info  = explode("#", $schedule_order_detail->product_addon_name);
						$addon_price_info = explode("#", $schedule_order_detail->product_addon_price);


						$att_info_str = "";
						$att_flag = 0;
						if( $att_name_info[0]!= '' ) {

							//loop attribute info
							for($k = 0; $k < count($att_name_info); $k++) {
								
								if($att_name_info[$k] != "") {
									$att_flag = 1;
									$att_info_str .= $att_name_info[$k] . " : " . $att_price_info[$k] . "(". $schedule_order->currency_symbol ."),";

								}
							}


						} else {
							$att_info_str = "";
						}

						$att_info_str = rtrim($att_info_str, ","); 


						///addon

						$addon_info_str = "";
						$addon_flag = 0;
						if( $addon_name_info[0] != '' ) {

							//loop attribute info
							for($k = 0; $k < count($addon_name_info); $k++) {
								
								if($addon_name_info[$k] != "") {
									$addon_flag = 1;
									$addon_info_str .= $addon_name_info[$k] . " : " . $addon_price_info[$k] . "(". $schedule_order->currency_symbol ."),";

								}
							}


						} else {
							$addon_info_str = "";
						}

						$addon_info_str = rtrim($addon_info_str, ","); 

						///end addon	
						
						if( $att_flag == 1 || $addon_flag == 1 ) {

							echo $schedule_order_detail->product_name .'<br> '  . $att_info_str  .'<br>' . $addon_info_str  .'<br>'; 

						} else {

							echo $schedule_order_detail->product_name .'<br> ';

						}

						if ($schedule_order_detail->product_color_id != "") {
							echo get_msg('color_label') . " :";
							$color_value =  $this->Color->get_one($schedule_order_detail->product_color_id)->color_value . '}';
						} 
						
						?>

						<div style="background-color:<?php echo  $this->Color->get_one($schedule_order_detail->product_color_id)->color_value ; ?>; width: 20px; height: 20px; margin-top: -20px; margin-left: 50px;"> 
						</div>
						<?php echo get_msg('prd_unit') . " : " . $schedule_order_detail->product_unit_value . " " . $schedule_order_detail->product_unit; ?> <br>
						<?php echo $schedule_order_detail->original_price == 0 ? "<small class='text-danger font-weight-bold'>(".get_msg("prd_not_available").")</small><br>" : ""; ?>
					</td>

					<td><?php echo $schedule_order_detail->original_price ." ". $schedule_order->currency_symbol; ?></td>
					
					<td>

						<?php
							$attributes = array( 'id' => 'qty-update-form', 'enctype' => 'multipart/form-data');
							$update_qty_url = $module_site_url .'/update_qty/' . $schedule_order_detail->product_id . '/' .$schedule_order_detail->schedule_header_id ;
							if(isset($route_id)){
								if($route_id != ''){
									$update_qty_url = $update_qty_url . '/' . $route_id;
								}
							}
							echo form_open( $update_qty_url , $attributes);
						?>
						<?php if($schedule_order_detail->original_price == 0) : ?>
							<div class="input-group">
								<input type="text" class="form-control" id="qty" name="qty" value="<?php echo $schedule_order_detail->qty ?>" style="width:30px" <?php echo $this->Order_route->get_one($route_id)->updated_flag==1? 'disabled' : ''; ?> disabled>
								<input type="hidden" name="prd_id" id="prd_id" value="<?php echo $schedule_order_detail->product_id; ?>" disabled>
								<div class="input-group-append">
									<button type="submit" class="btn btn-secondary btn-sm" id="<?php echo $schedule_order_detail->product_id; ?>" <?php echo $this->Order_route->get_one($route_id)->updated_flag==1? 'disabled' : ''; ?> disabled><?php echo get_msg('btn_update')?></button>
								</div>
							</div>
						<?php else: ?>
							<div class="input-group">
								<input type="text" class="form-control" id="qty" name="qty" value="<?php echo $schedule_order_detail->qty ?>" style="width:30px" <?php echo $this->Order_route->get_one($route_id)->updated_flag==1? 'disabled' : ''; ?>>
								<input type="hidden" name="prd_id" id="prd_id" value="<?php echo $schedule_order_detail->product_id; ?>">
								<div class="input-group-append">
									<button type="submit" class="btn btn-secondary btn-sm" id="<?php echo $schedule_order_detail->product_id; ?>" <?php echo $this->Order_route->get_one($route_id)->updated_flag==1? 'disabled' : ''; ?> ><?php echo get_msg('btn_update')?></button>
								</div>
							</div>
						<?php endif; ?>

						<?php echo form_close(); ?>

					</td>

                    <?php if ($schedule_order_detail->discount_amount == 0) { ?>
                         <td> <p class="ml-5"><?php echo "-";  ?></p> </td>
                    <?php } else { ?>
                        <td>
							<?php echo "-" . ($schedule_order_detail->discount_amount) . $schedule_order->currency_symbol . " (" . $schedule_order_detail->discount_percent . "% off)"; ?></td>
                    <?php } ?>

					<td>
						<?php echo $schedule_order_detail->qty * $schedule_order_detail->price  ." ". $schedule_order->currency_symbol; ?>
					</td>
				</tr>

					<?php endforeach; ?>
		    </tbody>
		  </table>
		</div>
	<!-- /.col -->
	</div>
<?php if(isset($route_id)) $url = 'edit/'. $route_id; else $url = 'add' ; ?>
	<a href="<?php echo $module_site_url . '/' . $url; ?>" class="btn btn-primary mt-4"><?php echo get_msg('btn_back')?></a>
</div>


<script>

<?php
	if (isset($schedule_order)) {
		$lat = $schedule_order->sch_lat;
		$lng = $schedule_order->sch_lng;
?>
		var sch_map = L.map('schedule_order_map').setView([<?php echo $lat;?>, <?php echo $lng;?>], 5);
<?php
	} else {
?>
		var sch_map = L.map('schedule_order_map').setView([0, 0], 5);
<?php
	}
?>

const sch_attribution =
'&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors';
const sch_tileUrl = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
const sch_tiles = L.tileLayer(sch_tileUrl, { sch_attribution });
sch_tiles.addTo(sch_map);
<?php if(isset($schedule_order)) {?>
	var sch_marker = new L.Marker(new L.LatLng(<?php echo $lat;?>, <?php echo $lng;?>));
	sch_map.addLayer(sch_marker);
	// results = L.marker([<?php echo $lat;?>, <?php echo $lng;?>]).addTo(mymap);

<?php } else { ?>
	var sch_marker = new L.Marker(new L.LatLng(0, 0));
	//mymap.addLayer(marker2);
<?php } ?>
var sch_searchControl = L.esri.Geocoding.geosearch().addTo(sch_map);
var results = L.layerGroup().addTo(sch_map);

sch_searchControl.on('results',function(data){
	results.clearLayers();

	for(var i= data.results.length -1; i>=0; i--) {
		sch_map.removeLayer(sch_marker);
		results.addLayer(L.marker(data.results[i].latlng));
		var sch_search_str = data.results[i].latlng.toString();
		var sch_search_res = sch_search_str.substring(sch_search_str.indexOf("(") + 1, sch_search_str.indexOf(")"));
		var sch_searchArr = new Array();
		sch_searchArr = sch_search_res.split(",");

		document.getElementById("lat").value = sch_searchArr[0].toString();
		document.getElementById("lng").value = sch_searchArr[1].toString(); 
	   
	}
})
var popup = L.popup();

function onMapClick(e) {

	var sch = e.latlng.toString();
	var sch_res = sch.substring(sch.indexOf("(") + 1, sch.indexOf(")"));
	sch_map.removeLayer(sch_marker);
	results.clearLayers();
	results.addLayer(L.marker(e.latlng));   

	var sch_tmpArr = new Array();
	sch_tmpArr = sch_res.split(",");

	document.getElementById("lat").value = sch_tmpArr[0].toString(); 
	document.getElementById("lng").value = sch_tmpArr[1].toString();
}

sch_map.on('click', onMapClick);
</script>

