<div class="invoice p-3 mb-3 shadow-sm rounded">
  	<!-- title row -->
  	<div class="row">
    	<div class="col-12">
      		<h4>
        	<?php echo ucwords($action_title) ?>
        	<small class="float-right">Date: <?php echo $transaction->added_date; ?></small>
      		</h4>
    	</div>
    <!-- /.col -->
  	</div>
  <!-- info row -->
	<div class="row invoice-info">

		<div class="col-sm-4 invoice-col">
			<b><u><?php echo get_msg('cust_info'); ?></u></b> <br><br>
			 	<address>
				 	<?php echo get_msg('name_label'); ?>: <?php echo $transaction->contact_name; ?><br>
				    <?php echo get_msg('email_label'); ?>: <?php echo $transaction->contact_email; ?><br>
				    <?php echo get_msg('phone_label'); ?>: <?php echo $transaction->contact_phone;?><br>
				    <?php echo get_msg('address_label'); ?>: <?php echo $transaction->contact_address;?>
			 	</address>
		</div>
		<!-- /.col -->
		<div class="col-sm-4 invoice-col">
		  	<b><u><?php echo get_msg('cust_loc'); ?></u></b> <br><br>
		  		<div id="transaction_map" style="width: 200px; height: 150px;"></div>

				<div class="clearfix">&nbsp;</div>
		</div>
	
		<div class="col-sm-4 invoice-col">
            <b><?php echo get_msg('invoice_label'); ?> <?php echo $transaction->trans_code?></b><br>
            <br>
		  	
            <div class="table-responsive">
                <table class="table">
                    <tr>
                        <th><?php echo get_msg('status_label'); ?>:</th>
                        <td>
                            <?php echo $this->Transactionstatus->get_one($transaction->trans_status_id)->title; ?>
                        </td>
                    </tr>
                    <tr>
                        <th><?php echo get_msg('payment_status_label'); ?>:</th>
                        <td>
                            <?php echo $this->Paymentstatus->get_one($transaction->payment_status_id)->title; ?>
                        </td>
                    </tr>
                    <?php if($transaction->pick_at_shop != 1 && $transaction->trans_status_id != 'trans_sts29a4b0cd2fa6ae0449e47e9568320f3a') { ?>
                        <tr>
                            <th><?php echo get_msg('delivery_boy_label'); ?>:</th>
                            <td>
                                <?php echo $this->User->get_one($transaction->delivery_boy_id)->user_name; ?>
                                
                            </td>
                        </tr>
                    <?php } ?>
                </table>
                <input type="hidden" name="trans_header_id" value=<?php  echo $transaction->id;  ?>>
            </div>

		  	<b><?php echo get_msg('account_label'); ?>:</b> <?php echo $transaction->sub_total_amount ." ". $transaction->currency_short_form; ?>		
		</div>	
	</div>

	<div class="row">
		<div class="col-12 table-responsive">
		  <table class="table table-striped">
		    <thead>
			    <tr>
			      	<th><?php echo get_msg('Prd_name'); ?></th>
					<th><?php echo get_msg('Prd_price'); ?></th>
					<!-- <th><?php echo get_msg('Prd_dis_price'); ?></th> -->
					<th><?php echo get_msg('Prd_qty'); ?></th>
					<th><?php echo get_msg('Prd_dis'); ?></th>
					<th><?php echo get_msg('Prd_amt'); ?></th>
			    </tr>
		    </thead>
		    <tbody>
		    	<?php 
					$conds['transactions_header_id'] = $transaction->id;
					$all_detail =  $this->Transactiondetail->get_all_by( $conds );
					
					foreach($all_detail->result() as $transaction_detail):

				?>
				<tr>
					<td>
						<?php 

						
						$att_name_info  = explode("#", $transaction_detail->product_customized_name);
						$att_price_info = explode("#", $transaction_detail->product_customized_price);

						$addon_name_info  = explode("#", $transaction_detail->product_addon_name);
						$addon_price_info = explode("#", $transaction_detail->product_addon_price);


						$att_info_str = "";
						$att_flag = 0;
						if( $att_name_info[0] != '' ) {

							//loop attribute info
							for($k = 0; $k < count($att_name_info); $k++) {
								
								if($att_name_info[$k] != "") {
									$att_flag = 1;
									$att_info_str .= $att_name_info[$k] . " : " . $att_price_info[$k] . "(". $transaction->currency_symbol ."),";

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
									$addon_info_str .= $addon_name_info[$k] . " : " . $addon_price_info[$k] . "(". $transaction->currency_symbol ."),";

								}
							}


						} else {
							$addon_info_str = "";
						}

						

						$addon_info_str = rtrim($addon_info_str, ","); 

						///end addon


						if( $att_flag == 1 || $addon_flag == 1 ) {

							echo $transaction_detail->product_name .'<br> ' . $att_info_str  .'<br>' . $addon_info_str  .'<br>'; 

						} else {

							echo $transaction_detail->product_name .'<br>';

						}

						if ($transaction_detail->product_color_id != "") {

							echo "Color:";

							$color_value =  $this->Color->get_one($transaction_detail->product_color_id)->color_value . '}';
							

							} 

						?>

						<div style="background-color:<?php echo  $this->Color->get_one($transaction_detail->product_color_id)->color_value ; ?>; width: 20px; height: 20px; margin-top: -20px; margin-left: 50px;"> 
						</div>
						<?php echo get_msg('prd_unit') . " : " . $transaction_detail->product_unit_value . " " . $transaction_detail->product_unit; ?> <br>


					</td>
					<td><?php echo $transaction_detail->original_price ." ". $transaction->currency_symbol; ?></td>
					<!-- <td><?php echo $transaction_detail->price ." ". $transaction->currency_symbol; ?></td> -->
					<td><?php echo $transaction_detail->qty ?></td>
					<td><?php echo "-" . $transaction_detail->discount_amount . $transaction->currency_symbol . " (" .$transaction_detail->discount_percent . "% off)"; ?></td>

					<td>
						<?php 

							echo $transaction_detail->qty * $transaction_detail->original_price  ." ". $transaction->currency_symbol; 
						?>
					</td>
				</tr>

					<?php endforeach; ?>
		    </tbody>
		  </table>
		</div>
	<!-- /.col -->
	</div>

	<div class="row">
        <!-- accepted payments column -->
       
        <div class="col-6">
        	 <br>
          <p><?php echo get_msg('trans_payment_method'); ?>

          <?php 

          echo $transaction->payment_method; 

          if($transaction->razor_id != "") {
          	echo "( ". get_msg('id_label') . " : " . $transaction->razor_id . " )";
          }

          if($transaction->flutter_wave_id != "") {
            echo "(  ". get_msg('id_label') . " : " . $transaction->flutter_wave_id . " )";
          }

          ?>
          	

          </p>

          <p> <?php echo get_msg('trans_memo'); ?> <?php echo $transaction->memo; ?></p>

          <?php if($transaction->pick_at_shop == 1) { ?>
          <p><?php echo get_msg('cus_pick_up_order'); ?></p>
      	  <?php } ?>

         <p> <?php echo get_msg('trans_delivery_pickup_date'); ?> <?php echo $transaction->delivery_pickup_date; ?></p>

         <p> <?php echo get_msg('trans_delivery_pickup_time'); ?> <?php echo $transaction->delivery_pickup_time; ?></p>
        </div>

        <!-- /.col -->
        <div class="col-6">
         

          <div class="table-responsive">
            <table class="table">

              <tr>
                <th><?php echo get_msg('trans_coupon_discount_amount'); ?></th>
                <td><?php echo $transaction->coupon_discount_amount . " ". $transaction->currency_symbol;; ?></td>
              </tr>	

              <tr>
                <th style="width:50%"><?php echo get_msg('trans_item_sub_total'); ?></th>
                <td><?php echo $transaction->sub_total_amount . " ". $transaction->currency_symbol; ?></td>
              </tr>

              <tr>
                <th><?php echo get_msg('trans_overall_tax'); ?> <?php echo "(" . $transaction->tax_percent * 100 . "%)"  ?> : (+)</th>
                <td><?php echo $transaction->tax_amount . " ". $transaction->currency_symbol;; ?></td>
              </tr>
              <tr>
                <th><?php echo get_msg('trans_shipping_cost'); ?><?php echo $transaction->shipping_method_name ?>): (+)</th>
                <td><?php echo $transaction->shipping_amount . " ". $transaction->currency_symbol;; ?></td>
              </tr>
              <tr>
                <th><?php echo get_msg('trans_shipping_tax'); ?> <?php echo "(" . $transaction->shipping_tax_percent * 100 . ")"  ?>% : (+)</th>
                <td><?php echo $transaction->shipping_amount * $transaction->shipping_tax_percent . " ". $transaction->currency_symbol;; ?></td>
              </tr>
            
              
              <tr>
                <th><?php echo get_msg('trans_total_balance_amount'); ?></th>
                <td>
                	
                	<?php 

                	//balance_amount = total_item_amount - coupon_discont + (overall_tax + shipping_cost + shipping_tax (based on shipping cost)) 

                	echo  ($transaction->sub_total_amount + ($transaction->tax_amount + $transaction->shipping_amount + ($transaction->shipping_amount * $transaction->shipping_tax_percent)) );  
                	echo " ". $transaction->currency_symbol;
                	?>
                </td>
              </tr>
            </table>
          </div>
        </div>
        <!-- /.col -->
    </div>
</div>

<script>
	<?php
		if (isset($transaction)) {
			$lat = $transaction->trans_lat;
			$lng = $transaction->trans_lng;
	?>
			var trans_map = L.map('transaction_map').setView([<?php echo $lat;?>, <?php echo $lng;?>], 5);
	<?php
		} else {
	?>
			var trans_map = L.map('transaction_map').setView([0, 0], 5);
	<?php
		}
	?>

	const trans_attribution =
	'&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors';
	const trans_tileUrl = 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png';
	const trans_tiles = L.tileLayer(trans_tileUrl, { trans_attribution });
	trans_tiles.addTo(trans_map);
	<?php if(isset($transaction)) {?>
		var trans_marker = new L.Marker(new L.LatLng(<?php echo $lat;?>, <?php echo $lng;?>));
		trans_map.addLayer(trans_marker);
		// results = L.marker([<?php echo $lat;?>, <?php echo $lng;?>]).addTo(mymap);

	<?php } else { ?>
		var trans_marker = new L.Marker(new L.LatLng(0, 0));
		//mymap.addLayer(marker2);
	<?php } ?>
	var trans_searchControl = L.esri.Geocoding.geosearch().addTo(trans_map);
	var results = L.layerGroup().addTo(trans_map);

	trans_searchControl.on('results',function(data){
		results.clearLayers();

		for(var i= data.results.length -1; i>=0; i--) {
			trans_map.removeLayer(trans_marker);
			results.addLayer(L.marker(data.results[i].latlng));
			var trans_search_str = data.results[i].latlng.toString();
			var trans_search_res = trans_search_str.substring(trans_search_str.indexOf("(") + 1, trans_search_str.indexOf(")"));
			var trans_searchArr = new Array();
			trans_searchArr = trans_search_res.split(",");

			document.getElementById("lat").value = trans_searchArr[0].toString();
			document.getElementById("lng").value = trans_searchArr[1].toString(); 
			
		}
	})
	var popup = L.popup();

	function onMapClick(e) {

		var trans = e.latlng.toString();
		var trans_res = trans.substring(trans.indexOf("(") + 1, trans.indexOf(")"));
		trans_map.removeLayer(trans_marker);
		results.clearLayers();
		results.addLayer(L.marker(e.latlng));   

		var trans_tmpArr = new Array();
		trans_tmpArr = trans_res.split(",");

		document.getElementById("lat").value = trans_tmpArr[0].toString(); 
		document.getElementById("lng").value = trans_tmpArr[1].toString();
	}

	trans_map.on('click', onMapClick);
</script>