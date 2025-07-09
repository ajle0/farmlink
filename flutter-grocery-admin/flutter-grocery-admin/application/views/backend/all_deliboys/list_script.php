<script>
    function runAfterJQ() {

        $(document).delegate('.sorting','click',function(){
            // get button and id
            var btn = $(this);
            var id = $(this).attr('id');

            // Ajax call to unpublish
            $.ajax({
                url: "<?php echo $module_site_url .'/rating_sort/'; ?>" ,
                method: 'GET',
                success: function( msg ){

                }
            });

        });

    }

</script>