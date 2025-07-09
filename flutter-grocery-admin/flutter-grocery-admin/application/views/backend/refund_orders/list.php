<div class="table-responsive animated fadeInRight">
    <table class="table m-0 table-striped">
        <tr>
            <th><?php echo get_msg('no'); ?></th>
            <th><?php echo get_msg('trans_code'); ?></th>
            <th><?php echo get_msg('buyer_name'); ?></th>
            <th><?php echo get_msg('payment_method'); ?></th>
            <th><?php echo get_msg('payment_status'); ?></th>
            <th><?php echo get_msg('refunded_amount'); ?></th>
        </tr>

        <?php $count = $this->uri->segment(4) or $count = 0; ?>

        <?php if ( !empty( $refunds ) && count( $refunds->result()) > 0 ): ?>

            <?php foreach($refunds->result() as $refund): ?>

                <tr>
                    <?php
                    $transactions_header_id = $refund->transactions_header_id;
                    $user_id = $refund->added_user_id;
                    $shop_id = $refund->shop_id;

                    $trans_currency = $this->Shop->get_one($shop_id)->currency_symbol;

                    ?>
                    <td><?php echo ++$count;?></td>
                    <td><?php echo $this->Transactionheader->get_one($transactions_header_id)->trans_code;?></td>
                    <td><?php echo $this->User->get_one($user_id)->user_name;?></td>
                    <td><?php echo $refund->payment_method;?></td>
                    <td><?php echo $refund->payment_status;?></td>
                    <td><?php echo $trans_currency . ' ' . $refund->refund_amount;?></td>

                </tr>

            <?php endforeach; ?>

        <?php else: ?>

            <?php $this->load->view( $template_path .'/partials/no_data' ); ?>

        <?php endif; ?>

    </table>
</div>