<link rel="stylesheet" type="text/css" href="https://cdn.datatables.net/v/dt/dt-1.10.16/sl-1.2.5/datatables.min.css"/>
        <script type="text/javascript" src="https://cdn.datatables.net/v/dt/dt-1.10.16/sl-1.2.5/datatables.min.js"></script> 
        <link rel="stylesheet" type="text/css" href="https://gyrocode.github.io/jquery-datatables-checkboxes/1.2.10/css/dataTables.checkboxes.css" />
        <script type="text/javascript" src="https://gyrocode.github.io/jquery-datatables-checkboxes/1.2.10/js/dataTables.checkboxes.min.js"></script>
        <!-- jQuery UI 1.11.4 -->
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.min.js"></script>
        <!-- Resolve conflict in jQuery UI tooltip with Bootstrap tooltip -->
        <script>
          $.widget.bridge('uibutton', $.ui.button)
        </script>
        <!-- Bootstrap 4 -->
        <script src="<?php echo base_url( 'assets/plugins/bootstrap/js/bootstrap.bundle.min.js' ); ?>"></script>

        <?php show_analytic(); ?>
        <script src="<?php echo base_url( 'assets/validator/jquery.validate.js' ); ?>"></script>
        <script type="text/javascript">
          
          // functions to run after jquery is loaded
          if ( typeof runAfterJQ == "function" ) runAfterJQ();

          <?php if ( $this->config->item( 'client_side_validation' ) == true ): ?>
            
            // functions to run after jquery is loaded
            if ( typeof jqvalidate == "function" ) jqvalidate();

          <?php endif; ?>

                $('.page-sidebar-menu li').removeClass('active');

                // highlight submenu item
                $('li a[href="' + this.location.pathname + '"]').parent().addClass('active');

                // Highlight parent menu item.
                $('ul a[href="' + this.location.pathname + '"]').parents('li').addClass('active');

                

        </script>

        <!-- Select2 -->
        <link rel="stylesheet" href="<?php echo base_url('assets/select2/select2.min.css'); ?>">
        <script src="<?php echo base_url( 'assets/select2/select2.full.min.js' ); ?>"></script>
        <script>
            $(document).ready(function() {
                $('.select2').select2();                                    
            });
        </script>
  </div>
 <!-- ./ wrapper -->
</body>
</html>