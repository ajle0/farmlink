<script type="text/javascript">
    // Initial call i make so user do not wait 2 seconds for messages to show
    function refresh() {
        $.ajax({
            method: 'GET',
            dataType: 'JSON',
            url:  '<?php echo $module_site_url . '/get_all_activetask/';?>',
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


</script>