<script>
	<?php if ( $this->config->item( 'client_side_validation' ) == true ): ?>

	function updateDataTableSelectAllCtrl(table){
		var $table             = table.table().node();
		var $chkbox_all        = $('tbody input[type="checkbox"]', $table);
		var $chkbox_checked    = $('tbody input[type="checkbox"]:checked', $table);
		var chkbox_select_all  = $('thead input[name="select_all"]', $table).get(0);

		// If none of the checkboxes are checked
		if($chkbox_checked.length === 0){
			chkbox_select_all.checked = false;
			if('indeterminate' in chkbox_select_all){
				chkbox_select_all.indeterminate = false;
			}

		// If all of the checkboxes are checked
		} else if ($chkbox_checked.length === $chkbox_all.length){
			chkbox_select_all.checked = true;
			if('indeterminate' in chkbox_select_all){
				chkbox_select_all.indeterminate = false;
			}

		// If some of the checkboxes are checked
		} else {
			chkbox_select_all.checked = true;
			
			if('indeterminate' in chkbox_select_all){
				chkbox_select_all.indeterminate = true;
			}
		}
	}

	function jqvalidate() {

		$('#route-form').validate({
			rules:{
				name:{
					required : true,
					blankCheck : "",
					minlength: 3
					//remote: "<?php echo $module_site_url .'/ajx_exists/'.@$route->id; ?>"
				},
				delivery_boy_id:{
					indexCheck : ""
				}
			},
			messages:{
				name:{
					blankCheck : "<?php echo get_msg( 'err_dis_name' ) ;?>",
					minlength: "<?php echo get_msg( 'err_dis_len' ) ;?>"
					//remote: "<?php echo get_msg( 'err_dis_exist' ) ;?>."
				}, 
				delivery_boy_id : {
					indexCheck : "<?php echo get_msg( 'err_deli_boy' ) ;?>",
				}
			}
		});

		jQuery.validator.addMethod("blankCheck",function( value, element ) {
			
			   if(value == "") {
			    	return false;
			   } else {
			   	 	return true;
			   }
		});

		jQuery.validator.addMethod("indexCheck",function( value, element ) {
			
			if(value == 0) {
				 return false;
			} else {
				 return true;
			};
			
	 	});
		
	}

	<?php endif; ?>

	function runAfterJQ() {
		
		var rows_selected = [<?php 

			if(isset($route->id)) {
				if ( $route->id == "" ){
					$conds['route_id'] = "000";
				} else {
					$conds['route_id'] = $route->id;
					
				}
			} else {
				$conds['route_id'] = "000";
			}

			$ord_routes = $this->Schedule_Order_Route->get_all_by($conds)->result();
			
			$oldchkval = "";
			foreach ($ord_routes as $ord_route)
			{
					$oldchkval = $oldchkval . $ord_route->schedule_header_id . ",";
			
			}

			$oldchkval = substr($oldchkval, 0, -1);

			$tmp_arr = explode(",", $oldchkval);

			$temp = $tmp_arr;

			$result = "'" . implode ( "', '", $temp ) . "'";

			echo $result; 

		 ?>];
		<?php
		 	if(isset($route->id)) {

			 	if ($route->id == "") {
			 		 $route_id = '000';
			 	} else {

			 	 	 $route_id = $route->id;
			 	}

		 	} else {
		 		 $route_id = '000';
		 	} 
		?>

		// Edit record
   
		
		var table = $('#order-table').DataTable({
			"pageLength": 20,
			'ajax':'<?php echo site_url('/admin/order_routes/get_all_schedule_orders_for_route/') .  $route_id ?>',
			'columnDefs': [{
				'targets': 0,
				'searchable':false,
				'orderable':false,
				'width':'1%',
				'className': 'dt-body-center',
				'render': function (data, type, full, meta){
					<?php if($route->updated_flag == 1) : ?>
						return '<input type="checkbox" disabled>';
					<?php endif; ?>
					return '<input type="checkbox">';
				}
			}],
			"columns": [
				null,
				null,
				null,
				null,
				null,
				null,
				null,
				null
			],
		      
			'rowCallback': function(row, data, dataIndex){
				// Get row ID
				var rowId = data[0];

				// If row ID is in the list of selected row IDs
				if($.inArray(rowId, rows_selected) !== -1){
				$(row).find('input[type="checkbox"]').prop('checked', true);
				$(row).addClass('selected');
				}
			}
		});


		// Handle click on checkbox
		$('#order-table tbody').on('click', 'input[type="checkbox"]', function(e){
			var $row = $(this).closest('tr');

			// Get row data
			var data = table.row($row).data();

			// Get row ID
			var rowId = data[0];

			// Determine whether row ID is in the list of selected row IDs 

			var index = $.inArray(rowId, rows_selected);

			// If checkbox is checked and row ID is not in list of selected row IDs
			if(this.checked && index === -1){
				rows_selected.push(rowId);

			// Otherwise, if checkbox is not checked and row ID is in list of selected row IDs
			} else if (!this.checked && index !== -1){
				rows_selected.splice(index, 1);
			}

			if(this.checked){
				$row.addClass('selected');
			} else {
				$row.removeClass('selected');
			}
			
			// Update state of "Select all" control
			updateDataTableSelectAllCtrl(table);

			// Prevent click event from propagating to parent
			e.stopPropagation();
		});

			// Handle click on table cells with checkboxes
		$('#order-table').on('click', 'tbody td, thead th:first-child', function(e){
			$(this).parent().find('input[type="checkbox"]').trigger('click');
		});

		// Handle click on "Select all" control
		$('thead input[name="select_all"]', table.table().container()).on('click', function(e){
			if(this.checked){
				$('#order-table tbody input[type="checkbox"]:not(:checked)').trigger('click');
			} else {
				$('#order-table tbody input[type="checkbox"]:checked').trigger('click');
			}

			// Prevent click event from propagating to parent
			e.stopPropagation();
		});

		// Handle table draw event
		table.on('draw', function(){
			// Update state of "Select all" control
			updateDataTableSelectAllCtrl(table);
		});
			
		// Handle form submission event 
		$('#route-form').on('submit', function(e){
			var form = this;

			// Iterate over all selected checkboxes
			$.each(rows_selected, function(index, rowId){
				// Create a hidden element 
				$(form).append(
					$('<input>')
						.attr('type', 'hidden')
						.attr('name', 'id[]')
						.val(rowId)
				);
			});

			// FOR DEMONSTRATION ONLY     
			$('#example-console-rows').text(rows_selected.join(","));
			$('#newchkval').val($('#example-console-rows').text());
			
			// Output form data to a console     
			$('#example-console').text($(form).serialize());
			console.log("Form submission", $(form).serialize());
			
			// Remove added elements
			$('input[name="id\[\]"]', form).remove();
			
			// Prevent actual form submission
			//e.preventDefault();
		});	
		
		<?php if($route->updated_flag == 1) : ?>
			$('#name').attr('disabled', true);
			$('#delivery_boy_id').attr('disabled', true);
			$('#info').attr('disabled', true);
			$('.save').attr('disabled', true);
		<?php endif; ?>
	}

</script>

<?php 
	// replace cover photo modal
	$data = array(
		'title' => get_msg('upload_photo'),
		'img_type' => 'route',
		'img_parent_id' => @$route->id
	);

	$this->load->view( $template_path .'/components/photo_upload_modal', $data );

	// delete cover photo modal
	$this->load->view( $template_path .'/components/delete_cover_photo_modal' ); 
?>


