<script>
	<?php if ( $this->config->item( 'client_side_validation' ) == true ): ?>

	function jqvalidate() {
		
		$('#shop-form').validate({
			rules:{
				name:{
					blankCheck : "",
					minlength: 3,
					remote: "<?php echo $module_site_url .'/ajx_exists/'.@$shop->id; ?>"
					
				},
				description:{
					required : true
				},
				cover:{
					required : true
				},
				icon:{
					required : true
				},
				lat:{
                    blankCheck : "",
                    indexCheck : "",
                    validChecklat : ""
			    },
			    lng:{
			     blankCheck : "",
			     indexCheck : "",
			     validChecklng : ""
			    },
			    from_monday:{
			    	blankIndexCheckMon : ""
			    },
			    to_monday:{
			    	blankIndexCheckMon : "",
			    	validCheckMon : ""
			    },
			    from_tuesday:{
			    	blankIndexCheckTue : ""
			    },
			    to_tuesday:{
			    	blankIndexCheckTue : "",
			    	validCheckTue : ""
			    },
			    from_wednesday:{
			    	blankIndexCheckWed : ""
			    },
			    to_wednesday:{
			    	blankIndexCheckWed : "",
			    	validCheckWed : ""
			    },
			    from_thursday:{
			    	blankIndexCheckThu : ""
			    },
			    to_thursday:{
			    	blankIndexCheckThu : "",
			    	validCheckThu : ""
			    },
			    from_friday:{
			    	blankIndexCheckFri : ""
			    },
			    to_friday:{
			    	blankIndexCheckFri : "",
			    	validCheckFri : ""
			    },
			    from_saturday:{
			    	blankIndexCheckSat : ""
			    },
			    to_saturday:{
			    	blankIndexCheckSat : "",
			    	validCheckSat : ""
			    },
			    from_sunday:{
			    	blankIndexCheckSun : ""
			    },
			    to_sunday:{
			    	blankIndexCheckSun : "",
			    	validCheckSun : ""
			    },
				email:{
					required: true,
					email: true,
				},
				currency_symbol: {
					blankCheck : "",
				},
				currency_short_form: {
					blankCheck : "",
				},
				sender_email:{
					required: true,
					email: true,
				}, 
				minimum_order_amount : {
					blankCheck : "",
                    indexCheck : "",
				},
				// normal_checkout_setting : {
				// 	required: true
				// }

			},
			messages:{
				name:{
					blankCheck : "<?php echo get_msg( 'err_shop_name' ) ;?>",
					minlength: "<?php echo get_msg( 'err_shop_len' ) ;?>",
					remote: "<?php echo get_msg( 'err_shop_exist' ) ;?>."
				},
				cover:{
					required : "<?php echo get_msg( 'err_image_missing' ) ;?>."
				},
				icon:{
					required : "<?php echo get_msg( 'err_image_missing' ) ;?>."
				},
			    lat:{
				     blankCheck : "<?php echo get_msg( 'err_lat' ) ;?>",
				     indexCheck : "<?php echo get_msg( 'err_lat_lng' ) ;?>",
				     validChecklat : "<?php echo get_msg( 'lat_invlaid' ) ;?>"
			    },
			    lng:{
			     	blankCheck : "<?php echo get_msg( 'err_lng' ) ;?>",
			     	indexCheck : "<?php echo get_msg( 'err_lat_lng' ) ;?>",
			     	validChecklng : "<?php echo get_msg( 'lng_invlaid' ) ;?>"
			    },
			    from_monday:{
			    	blankIndexCheckMon : "<?php echo get_msg( 'err_monday' ) ;?>"
			    },
			    to_monday:{
			    	blankIndexCheckMon : "<?php echo get_msg( 'err_monday' ) ;?>",
			    	validCheckMon : "<?php echo get_msg( 'invalid_monday' ) ;?>",
			    },
			    from_tuesday:{
			    	blankIndexCheckTue : "<?php echo get_msg( 'err_tuesday' ) ;?>"
			    },
			    to_tuesday:{
			    	blankIndexCheckTue : "<?php echo get_msg( 'err_tuesday' ) ;?>",
			    	validCheckTue : "<?php echo get_msg( 'invalid_tuesday' ) ;?>"
			    },
			    from_wednesday:{
			    	blankIndexCheckWed : "<?php echo get_msg( 'err_wednesday' ) ;?>"
			    },
			    to_wednesday:{
			    	blankIndexCheckWed : "<?php echo get_msg( 'err_wednesday' ) ;?>",
			    	validCheckWed : "<?php echo get_msg( 'invalid_wednesday' ) ;?>"
			    },
			    from_thursday:{
			    	blankIndexCheckThu : "<?php echo get_msg( 'err_thursday' ) ;?>"
			    },
			    to_thursday:{
			    	blankIndexCheckThu : "<?php echo get_msg( 'err_thursday' ) ;?>",
			    	validCheckThu : "<?php echo get_msg( 'invalid_thursday' ) ;?>"
			    },
			    from_friday:{
			    	blankIndexCheckFri : "<?php echo get_msg( 'err_friday' ) ;?>"
			    },
			    to_friday:{
			    	blankIndexCheckFri : "<?php echo get_msg( 'err_friday' ) ;?>",
			    	validCheckFri : "<?php echo get_msg( 'invalid_friday' ) ;?>"
			    },
			    from_saturday:{
			    	blankIndexCheckSat : "<?php echo get_msg( 'err_saturday' ) ;?>"
			    },
			    to_saturday:{
			    	blankIndexCheckSat : "<?php echo get_msg( 'err_saturday' ) ;?>",
			    	validCheckSat : "<?php echo get_msg( 'invalid_saturday' ) ;?>"
			    },
			    from_sunday:{
			    	blankIndexCheckSun : "<?php echo get_msg( 'err_sunday' ) ;?>"
			    },
			    to_sunday:{
			    	blankIndexCheckSun : "<?php echo get_msg( 'err_sunday' ) ;?>",
			    	validCheckSun : "<?php echo get_msg( 'invalid_sunday' ) ;?>"
			    },
				currency_symbol : {
					blankCheck : "<?php echo get_msg( 'err_curr_sym' ) ;?>",
				},
				currency_short_form : {
					blankCheck : "<?php echo get_msg( 'err_curr_short' ) ;?>"
				},
				email: {
					required: "<?php echo get_msg( 'err_contact_email_blank' ); ?>",
					email: "<?php echo get_msg( 'err_contact_email_invalid' ); ?>",
				},
				sender_email: {
					required: "<?php echo get_msg( 'err_sender_email_blank' ); ?>",
					email: "<?php echo get_msg( 'err_sender_email_invalid' ); ?>",
				},
				minimum_order_amount :{
					blankCheck : "<?php echo get_msg( 'err_min_order_amount' ) ;?>",
					indexCheck : "<?php echo get_msg( 'min_order_cannot_zero' ) ;?>",
				},
				// normal_checkout_setting : {
				// 	required: "<?php echo get_msg( 'err_choice_one' ); ?>",
				// }
			}

		});

		// custom validation
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

		jQuery.validator.addMethod("validChecklat",function( value, element ) {
			    if (value < -90 || value > 90) {
			    	return false;
			    } else {
			   	 	return true;
			    }
		});

		jQuery.validator.addMethod("validChecklng",function( value, element ) {
			    if (value < -180 || value > 180) {
			    	return false;
			   } else {
			   	 	return true;
			   }
		});

		// open and close hour blank check start

		jQuery.validator.addMethod("blankIndexCheckMon",function( value, element ) {
			   //alert(document.getElementById("from_monday").value);
			   var monday_chk = document.getElementById("monday") ;
			   var from_monday = document.getElementById("from_monday").value ;
			   var to_monday = document.getElementById("to_monday").value ;

			    if (monday_chk.checked == true) {
			   		if (value == "" || value == '0') {
			   			return false;
			   		} else {
			   			return true;
			   		}
			    } else {
			    	return true;
			    }

			    
		});

		jQuery.validator.addMethod("blankIndexCheckTue",function( value, element ) {
			   
			    var tuesday_chk = document.getElementById("tuesday") ;
			   

			    if (tuesday_chk.checked == true) {
			   		if (value == "" || value == '0') {
			   			return false;
			   		} else {
			   			return true;
			   		}
			    } else {
			    	return true;
			    }

			    
		});

		jQuery.validator.addMethod("blankIndexCheckWed",function( value, element ) {
			   
			    var wednesday_chk = document.getElementById("wednesday") ;
			   

			    if (wednesday_chk.checked == true) {
			   		if (value == "" || value == '0') {
			   			return false;
			   		} else {
			   			return true;
			   		}
			    } else {
			    	return true;
			    }

			    
		});

		jQuery.validator.addMethod("blankIndexCheckThu",function( value, element ) {
			   
			    var thursday_chk = document.getElementById("thursday") ;
			   

			    if (thursday_chk.checked == true) {
			   		if (value == "" || value == '0') {
			   			return false;
			   		} else {
			   			return true;
			   		}
			    } else {
			    	return true;
			    }

			    
		});

		jQuery.validator.addMethod("blankIndexCheckFri",function( value, element ) {
			   
			    var friday_chk = document.getElementById("friday") ;

			    if (friday_chk.checked == true) {
			   		if (value == "" || value == '0') {
			   			return false;
			   		} else {
			   			return true;
			   		}
			    } else {
			    	return true;
			    }

			   
		});

		jQuery.validator.addMethod("blankIndexCheckSat",function( value, element ) {
			   
			    var saturday_chk = document.getElementById("saturday") ;
			   
			    if (saturday_chk.checked == true) {
			   		if (value == "" || value == '0') {
			   			return false;
			   		} else {
			   			return true;
			   		}
			    } else {
			    	return true;
			    }

			    
		});

		jQuery.validator.addMethod("blankIndexCheckSun",function( value, element ) {
			   
			    var sunday_chk = document.getElementById("sunday") ;


			    if (sunday_chk.checked == true) {
			   		if (value == "" || value == '0') {
			   			return false;
			   		} else {
			   			return true;
			   		}
			    } else {
			    	return true;
			    }
		}); //end

		// open and close hour invalid check start

		jQuery.validator.addMethod("validCheckMon",function( value, element ) {
			   //alert(document.getElementById("from_monday").value);
			   var from_monday = document.getElementById("from_monday").value ;

			    if (from_monday > value) {
			   		return false;
			    } else {
			    	return true;
			    }
		});


		jQuery.validator.addMethod("validCheckTue",function( value, element ) {
			   
			    var from_tuesday = document.getElementById("from_tuesday").value ;
			  
			    if (from_tuesday > value) {
			   		return false;
			    } else {
			    	return true;
			    }
		});

		jQuery.validator.addMethod("validCheckWed",function( value, element ) {
			   
			    var from_wednesday = document.getElementById("from_wednesday").value ;

			    if (from_wednesday > value) {
			   		return false;
			    } else {
			    	return true;
			   }
		}); 

		jQuery.validator.addMethod("validCheckThu",function( value, element ) {
			  
			    var from_thursday = document.getElementById("from_thursday").value ;


			    if (from_thursday > value) {
			   		return false;
			    } else {
			    	return true;
			   }
		}); 

		jQuery.validator.addMethod("validCheckFri",function( value, element ) {
			   
			    var from_friday = document.getElementById("from_friday").value ;

			    if (from_friday > value) {
			   		return false;
			    } else {
			    	return true;
			   }
		}); 

		jQuery.validator.addMethod("validCheckSat",function( value, element ) {
			  
			    var from_saturday = document.getElementById("from_saturday").value ;

			    if (from_saturday > value) {
			   		return false;
			    } else {
			    	return true;
			   }
		}); 

		jQuery.validator.addMethod("validCheckSun",function( value, element ) {
			  
			    var from_sunday = document.getElementById("from_sunday").value ;

			    if (from_sunday > value) {
			   		return false;
			    } else {
			    	return true;
			   }
		}); // end
		

	}
	

	<?php endif; ?>

	$('.delete-img').click(function(e){
			e.preventDefault();

			// get id and image
			var id = $(this).attr('id');

			// do action
			var action = '<?php echo $module_site_url .'/delete_cover_photo/'; ?>' + id + '/<?php echo @$shop->id; ?>';
			console.log( action );
			$('.btn-delete-image').attr('href', action);
			
		});

		$('.delete-shop').click(function(e){
		e.preventDefault();
		var id = $(this).attr('id');
		var image = $(this).attr('image');
		var action = '<?php echo site_url('/admin/shops/delete/');?>';
		$('.btn-delete-shop').attr('href', action + id);
	});
		
	$('a[data-toggle="tab"]').on('shown.bs.tab', function (e) {

    		var target = $(e.target).attr("value") // activated tab
    		$('#current_tab').val(target);

	});

	$('input[name="overall_tax_label"]').keyup(function(e)
                                {
		  if (/\D/g.test(this.value))
		  {
		    // Filter non-digits from input value.
		    this.value = this.value.replace(/\D.\D/g, '');
		  }
	});

	$('input[name="shipping_tax_label"]').keyup(function(e)
                                {
		  if (/\D/g.test(this.value))
		  {
		    // Filter non-digits from input value.
		    this.value = this.value.replace(/\D.\D/g, '');
		  }
	});

	$('input[name="minimum_order_amount"]').keyup(function(e)
                                {
		  if (/\D/g.test(this.value))
		  {
		    // Filter non-digits from input value.
		    this.value = this.value.replace(/\D.\D/g, '');
		  }
	});

</script>


<style type="text/css">
    
    
    .red{ background: #ff0000; }
    .green{ background: #228B22; }
    .blue{ background: #0000ff; }
    .is_area { background: #e2e0e0; padding: 20px; display: none; margin-top: 20px; }
    .deli_fee_by_distance { background: #e2e0e0; padding: 20px; display: none; margin-top: 20px; }
    .fixed_delivery { background: #e2e0e0; padding: 20px; display: none; margin-top: 20px; }
    .free_delivery { background: #e2e0e0; padding: 20px; display: none; margin-top: 20px; }


    label{ margin-right: 15px; }

</style>
<script src="https://code.jquery.com/jquery-1.12.4.min.js"></script>

<script type="text/javascript">
$(document).ready(function(){
    $('input[type="radio"]').click(function(){
        var inputValue = $(this).attr("value");
        var targetBox = $("." + inputValue);
        $(".box").not(targetBox).hide();
        $(targetBox).show();
    });
});

$(document).ready(() => {
	$("#checkout_with_email").click(() => {
		$("#ways_for_email").removeClass("d-none");
		document.getElementById("one_page_checkout").checked = true;	

	})
})

$(document).ready(() => {
	$("#checkout_with_whatsapp").click(() => {
		$("#ways_for_email").addClass("d-none");
	})
})

$(document).ready(() => {
	$("#deli_auto_assign").click(() => {
		$("#how_many_deli_to_broadcast_label").removeClass("d-none");
		$("#how_many_deli_to_broadcast_input").removeClass("d-none");
	})
})

$(document).ready(() => {
	$("#deli_manual_assign").click(() => {
		$("#how_many_deli_to_broadcast_label").addClass("d-none");
		$("#how_many_deli_to_broadcast_input").addClass("d-none");
	})
})


$('#shoptag').change(function(){
		var shop_tag = $(this).val();
		
    	$('#tagselect').val(shop_tag);
    	
});

</script> 

<?php 
	// replace cover photo modal
	$data = array(
		'title' => get_msg('upload_photo'),
		'img_type' => 'shop',
		'img_parent_id' => @$shop->id
	);
	
	$this->load->view( $template_path .'/components/shop_photo_upload_modal', $data );
	// delete cover photo modal
	$this->load->view( $template_path .'/components/delete_cover_photo_modal' );

	// replace icon photo modal
	$data = array(
		'title' => get_msg('upload_photo'),
		'img_type' => 'shop-icon',
		'img_parent_id' => @$shop->id
	);
	
	$this->load->view( $template_path .'/components/icon_upload_modal', $data );
	// delete icon photo modal
	$this->load->view( $template_path .'/components/delete_icon_modal' ); 
?>
