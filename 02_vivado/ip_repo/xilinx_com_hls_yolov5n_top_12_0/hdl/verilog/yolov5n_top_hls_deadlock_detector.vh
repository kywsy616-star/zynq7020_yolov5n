
    wire reset;
    wire clock;
    assign reset = ap_rst_n;
    assign clock = ap_clk;
    wire [2:0] proc_0_data_FIFO_blk;
    wire [2:0] proc_0_data_PIPO_blk;
    wire [2:0] proc_0_start_FIFO_blk;
    wire [2:0] proc_0_TLF_FIFO_blk;
    wire [2:0] proc_0_input_sync_blk;
    wire [2:0] proc_0_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_0;
    reg [2:0] proc_dep_vld_vec_0_reg;
    wire [2:0] in_chan_dep_vld_vec_0;
    wire [20:0] in_chan_dep_data_vec_0;
    wire [2:0] token_in_vec_0;
    wire [2:0] out_chan_dep_vld_vec_0;
    wire [6:0] out_chan_dep_data_0;
    wire [2:0] token_out_vec_0;
    wire dl_detect_out_0;
    wire dep_chan_vld_1_0;
    wire [6:0] dep_chan_data_1_0;
    wire token_1_0;
    wire dep_chan_vld_5_0;
    wire [6:0] dep_chan_data_5_0;
    wire token_5_0;
    wire dep_chan_vld_6_0;
    wire [6:0] dep_chan_data_6_0;
    wire token_6_0;
    wire [2:0] proc_1_data_FIFO_blk;
    wire [2:0] proc_1_data_PIPO_blk;
    wire [2:0] proc_1_start_FIFO_blk;
    wire [2:0] proc_1_TLF_FIFO_blk;
    wire [2:0] proc_1_input_sync_blk;
    wire [2:0] proc_1_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_1;
    reg [2:0] proc_dep_vld_vec_1_reg;
    wire [2:0] in_chan_dep_vld_vec_1;
    wire [20:0] in_chan_dep_data_vec_1;
    wire [2:0] token_in_vec_1;
    wire [2:0] out_chan_dep_vld_vec_1;
    wire [6:0] out_chan_dep_data_1;
    wire [2:0] token_out_vec_1;
    wire dl_detect_out_1;
    wire dep_chan_vld_0_1;
    wire [6:0] dep_chan_data_0_1;
    wire token_0_1;
    wire dep_chan_vld_5_1;
    wire [6:0] dep_chan_data_5_1;
    wire token_5_1;
    wire dep_chan_vld_6_1;
    wire [6:0] dep_chan_data_6_1;
    wire token_6_1;
    wire [1:0] proc_2_data_FIFO_blk;
    wire [1:0] proc_2_data_PIPO_blk;
    wire [1:0] proc_2_start_FIFO_blk;
    wire [1:0] proc_2_TLF_FIFO_blk;
    wire [1:0] proc_2_input_sync_blk;
    wire [1:0] proc_2_output_sync_blk;
    wire [1:0] proc_dep_vld_vec_2;
    reg [1:0] proc_dep_vld_vec_2_reg;
    wire [1:0] in_chan_dep_vld_vec_2;
    wire [13:0] in_chan_dep_data_vec_2;
    wire [1:0] token_in_vec_2;
    wire [1:0] out_chan_dep_vld_vec_2;
    wire [6:0] out_chan_dep_data_2;
    wire [1:0] token_out_vec_2;
    wire dl_detect_out_2;
    wire dep_chan_vld_3_2;
    wire [6:0] dep_chan_data_3_2;
    wire token_3_2;
    wire dep_chan_vld_4_2;
    wire [6:0] dep_chan_data_4_2;
    wire token_4_2;
    wire [1:0] proc_3_data_FIFO_blk;
    wire [1:0] proc_3_data_PIPO_blk;
    wire [1:0] proc_3_start_FIFO_blk;
    wire [1:0] proc_3_TLF_FIFO_blk;
    wire [1:0] proc_3_input_sync_blk;
    wire [1:0] proc_3_output_sync_blk;
    wire [1:0] proc_dep_vld_vec_3;
    reg [1:0] proc_dep_vld_vec_3_reg;
    wire [1:0] in_chan_dep_vld_vec_3;
    wire [13:0] in_chan_dep_data_vec_3;
    wire [1:0] token_in_vec_3;
    wire [1:0] out_chan_dep_vld_vec_3;
    wire [6:0] out_chan_dep_data_3;
    wire [1:0] token_out_vec_3;
    wire dl_detect_out_3;
    wire dep_chan_vld_2_3;
    wire [6:0] dep_chan_data_2_3;
    wire token_2_3;
    wire dep_chan_vld_4_3;
    wire [6:0] dep_chan_data_4_3;
    wire token_4_3;
    wire [1:0] proc_4_data_FIFO_blk;
    wire [1:0] proc_4_data_PIPO_blk;
    wire [1:0] proc_4_start_FIFO_blk;
    wire [1:0] proc_4_TLF_FIFO_blk;
    wire [1:0] proc_4_input_sync_blk;
    wire [1:0] proc_4_output_sync_blk;
    wire [1:0] proc_dep_vld_vec_4;
    reg [1:0] proc_dep_vld_vec_4_reg;
    wire [1:0] in_chan_dep_vld_vec_4;
    wire [13:0] in_chan_dep_data_vec_4;
    wire [1:0] token_in_vec_4;
    wire [1:0] out_chan_dep_vld_vec_4;
    wire [6:0] out_chan_dep_data_4;
    wire [1:0] token_out_vec_4;
    wire dl_detect_out_4;
    wire dep_chan_vld_2_4;
    wire [6:0] dep_chan_data_2_4;
    wire token_2_4;
    wire dep_chan_vld_3_4;
    wire [6:0] dep_chan_data_3_4;
    wire token_3_4;
    wire [2:0] proc_5_data_FIFO_blk;
    wire [2:0] proc_5_data_PIPO_blk;
    wire [2:0] proc_5_start_FIFO_blk;
    wire [2:0] proc_5_TLF_FIFO_blk;
    wire [2:0] proc_5_input_sync_blk;
    wire [2:0] proc_5_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_5;
    reg [2:0] proc_dep_vld_vec_5_reg;
    wire [2:0] in_chan_dep_vld_vec_5;
    wire [20:0] in_chan_dep_data_vec_5;
    wire [2:0] token_in_vec_5;
    wire [2:0] out_chan_dep_vld_vec_5;
    wire [6:0] out_chan_dep_data_5;
    wire [2:0] token_out_vec_5;
    wire dl_detect_out_5;
    wire dep_chan_vld_0_5;
    wire [6:0] dep_chan_data_0_5;
    wire token_0_5;
    wire dep_chan_vld_1_5;
    wire [6:0] dep_chan_data_1_5;
    wire token_1_5;
    wire dep_chan_vld_6_5;
    wire [6:0] dep_chan_data_6_5;
    wire token_6_5;
    wire [2:0] proc_6_data_FIFO_blk;
    wire [2:0] proc_6_data_PIPO_blk;
    wire [2:0] proc_6_start_FIFO_blk;
    wire [2:0] proc_6_TLF_FIFO_blk;
    wire [2:0] proc_6_input_sync_blk;
    wire [2:0] proc_6_output_sync_blk;
    wire [2:0] proc_dep_vld_vec_6;
    reg [2:0] proc_dep_vld_vec_6_reg;
    wire [2:0] in_chan_dep_vld_vec_6;
    wire [20:0] in_chan_dep_data_vec_6;
    wire [2:0] token_in_vec_6;
    wire [2:0] out_chan_dep_vld_vec_6;
    wire [6:0] out_chan_dep_data_6;
    wire [2:0] token_out_vec_6;
    wire dl_detect_out_6;
    wire dep_chan_vld_0_6;
    wire [6:0] dep_chan_data_0_6;
    wire token_0_6;
    wire dep_chan_vld_1_6;
    wire [6:0] dep_chan_data_1_6;
    wire token_1_6;
    wire dep_chan_vld_5_6;
    wire [6:0] dep_chan_data_5_6;
    wire token_5_6;
    wire [6:0] dl_in_vec;
    wire dl_detect_out;
    wire token_clear;
    reg [6:0] origin;

    reg ap_done_reg_0;// for module grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0
    always @ (negedge reset or posedge clock) begin
        if (~reset) begin
            ap_done_reg_0 <= 'b0;
        end
        else begin
            ap_done_reg_0 <= grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.ap_done & ~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.ap_continue;
        end
    end

    reg ap_done_reg_1;// for module grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_mac_U0
    always @ (negedge reset or posedge clock) begin
        if (~reset) begin
            ap_done_reg_1 <= 'b0;
        end
        else begin
            ap_done_reg_1 <= grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_mac_U0.ap_done & ~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_mac_U0.ap_continue;
        end
    end

    reg ap_done_reg_2;// for module grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_quant_U0
    always @ (negedge reset or posedge clock) begin
        if (~reset) begin
            ap_done_reg_2 <= 'b0;
        end
        else begin
            ap_done_reg_2 <= grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_quant_U0.ap_done & ~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_quant_U0.ap_continue;
        end
    end

    reg ap_done_reg_3;// for module grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.r64_pair_read_U0
    always @ (negedge reset or posedge clock) begin
        if (~reset) begin
            ap_done_reg_3 <= 'b0;
        end
        else begin
            ap_done_reg_3 <= grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.r64_pair_read_U0.ap_done & ~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.r64_pair_read_U0.ap_continue;
        end
    end

    reg ap_done_reg_4;// for module grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.r64_pair_write_U0
    always @ (negedge reset or posedge clock) begin
        if (~reset) begin
            ap_done_reg_4 <= 'b0;
        end
        else begin
            ap_done_reg_4 <= grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.r64_pair_write_U0.ap_done & ~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.r64_pair_write_U0.ap_continue;
        end
    end

reg [15:0] trans_in_cnt_0;// for process grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.r64_pair_rows_entry107_U0
always @(negedge reset or posedge clock) begin
    if (~reset) begin
         trans_in_cnt_0 <= 16'h0;
    end
    else if (grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.r64_pair_rows_entry107_U0.start_write == 1'b1) begin
        trans_in_cnt_0 <= trans_in_cnt_0 + 16'h1;
    end
    else begin
        trans_in_cnt_0 <= trans_in_cnt_0;
    end
end

reg [15:0] trans_out_cnt_0;// for process grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.r64_pair_rows_entry107_U0
always @(negedge reset or posedge clock) begin
    if (~reset) begin
         trans_out_cnt_0 <= 16'h0;
    end
    else if (grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.r64_pair_rows_entry107_U0.ap_done == 1'b1 && grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.r64_pair_rows_entry107_U0.ap_continue == 1'b1) begin
        trans_out_cnt_0 <= trans_out_cnt_0 + 16'h1;
    end
    else begin
        trans_out_cnt_0 <= trans_out_cnt_0;
    end
end

reg [15:0] trans_in_cnt_1;// for process grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0
always @(negedge reset or posedge clock) begin
    if (~reset) begin
         trans_in_cnt_1 <= 16'h0;
    end
    else if (grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.start_write == 1'b1) begin
        trans_in_cnt_1 <= trans_in_cnt_1 + 16'h1;
    end
    else begin
        trans_in_cnt_1 <= trans_in_cnt_1;
    end
end

reg [15:0] trans_out_cnt_1;// for process grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0
always @(negedge reset or posedge clock) begin
    if (~reset) begin
         trans_out_cnt_1 <= 16'h0;
    end
    else if (grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.ap_done == 1'b1 && grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.ap_continue == 1'b1) begin
        trans_out_cnt_1 <= trans_out_cnt_1 + 16'h1;
    end
    else begin
        trans_out_cnt_1 <= trans_out_cnt_1;
    end
end

    // Process: grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0
    yolov5n_top_hls_deadlock_detect_unit #(7, 0, 3, 3) yolov5n_top_hls_deadlock_detect_unit_0 (
        .reset(reset),
        .clock(clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_0),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_0),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_0),
        .token_in_vec(token_in_vec_0),
        .dl_detect_in(dl_detect_out),
        .origin(origin[0]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_0),
        .out_chan_dep_data(out_chan_dep_data_0),
        .token_out_vec(token_out_vec_0),
        .dl_detect_out(dl_in_vec[0]));

    assign proc_0_data_FIFO_blk[0] = 1'b0 | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.p_act_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.c_src_off_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.c_dst_off_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.c_add_off_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.c_src_ch_off_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.c_dst_ch_off_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.c_add_ch_off_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.c_ih_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.c_iw_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.c_oh_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.c_ow_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.c_icb_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.c_oc_real_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.c_kk_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.c_ss_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.c_pad_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.current_tr_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.current_tc_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.current_nc_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.next_rows_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.next_cols_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.next_r0_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.next_c0_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.next_valid_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.compute_y_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.compute_x0_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.compute_ob_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.compute_nxx_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.compute_nwoc_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.compute_valid_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.store_y_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.store_valid_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.store_row_last_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.quota_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.reuse_out_blk_n);
    assign proc_0_data_PIPO_blk[0] = 1'b0;
    assign proc_0_start_FIFO_blk[0] = 1'b0;
    assign proc_0_TLF_FIFO_blk[0] = 1'b0;
    assign proc_0_input_sync_blk[0] = 1'b0 | (grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.ap_sync_r64_wave_entry11111_U0_ap_ready & grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.ap_idle & ~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.ap_sync_r64_memory_U0_ap_ready);
    assign proc_0_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_0[0] = dl_detect_out ? proc_dep_vld_vec_0_reg[0] : (proc_0_data_FIFO_blk[0] | proc_0_data_PIPO_blk[0] | proc_0_start_FIFO_blk[0] | proc_0_TLF_FIFO_blk[0] | proc_0_input_sync_blk[0] | proc_0_output_sync_blk[0]);
    assign proc_0_data_FIFO_blk[1] = 1'b0 | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.c_add_off_out1_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.c_ih_out2_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.c_iw_out3_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.c_oh_out4_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.c_ow_out5_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.c_icb_out6_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.c_ocb_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.c_oc_real_out7_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.c_kk_out8_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.c_ss_out9_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.c_pad_out10_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.current_nc_out11_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.current_rows_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.current_cols_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.compute_y_out12_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.compute_x0_out13_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.compute_ob_out14_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.compute_nxx_out15_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.compute_nwoc_out16_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.compute_valid_out17_blk_n);
    assign proc_0_data_PIPO_blk[1] = 1'b0;
    assign proc_0_start_FIFO_blk[1] = 1'b0;
    assign proc_0_TLF_FIFO_blk[1] = 1'b0;
    assign proc_0_input_sync_blk[1] = 1'b0 | (grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.ap_sync_r64_wave_entry11111_U0_ap_ready & grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.ap_idle & ~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.ap_sync_r64_mac_U0_ap_ready);
    assign proc_0_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_0[1] = dl_detect_out ? proc_dep_vld_vec_0_reg[1] : (proc_0_data_FIFO_blk[1] | proc_0_data_PIPO_blk[1] | proc_0_start_FIFO_blk[1] | proc_0_TLF_FIFO_blk[1] | proc_0_input_sync_blk[1] | proc_0_output_sync_blk[1]);
    assign proc_0_data_FIFO_blk[2] = 1'b0 | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.c_act_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.quant_x0_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.quant_ob_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.quant_nxx_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.quant_nwoc_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.quant_valid_out_blk_n);
    assign proc_0_data_PIPO_blk[2] = 1'b0;
    assign proc_0_start_FIFO_blk[2] = 1'b0 | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.start_for_r64_quant_U0_U.if_full_n & grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.ap_start & ~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_wave_entry11111_U0.real_start & (trans_in_cnt_1 == trans_out_cnt_1) & ~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.start_for_r64_quant_U0_U.if_read);
    assign proc_0_TLF_FIFO_blk[2] = 1'b0;
    assign proc_0_input_sync_blk[2] = 1'b0;
    assign proc_0_output_sync_blk[2] = 1'b0;
    assign proc_dep_vld_vec_0[2] = dl_detect_out ? proc_dep_vld_vec_0_reg[2] : (proc_0_data_FIFO_blk[2] | proc_0_data_PIPO_blk[2] | proc_0_start_FIFO_blk[2] | proc_0_TLF_FIFO_blk[2] | proc_0_input_sync_blk[2] | proc_0_output_sync_blk[2]);
    always @ (negedge reset or posedge clock) begin
        if (~reset) begin
            proc_dep_vld_vec_0_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_0_reg <= proc_dep_vld_vec_0;
        end
    end
    assign in_chan_dep_vld_vec_0[0] = dep_chan_vld_1_0;
    assign in_chan_dep_data_vec_0[6 : 0] = dep_chan_data_1_0;
    assign token_in_vec_0[0] = token_1_0;
    assign in_chan_dep_vld_vec_0[1] = dep_chan_vld_5_0;
    assign in_chan_dep_data_vec_0[13 : 7] = dep_chan_data_5_0;
    assign token_in_vec_0[1] = token_5_0;
    assign in_chan_dep_vld_vec_0[2] = dep_chan_vld_6_0;
    assign in_chan_dep_data_vec_0[20 : 14] = dep_chan_data_6_0;
    assign token_in_vec_0[2] = token_6_0;
    assign dep_chan_vld_0_1 = out_chan_dep_vld_vec_0[0];
    assign dep_chan_data_0_1 = out_chan_dep_data_0;
    assign token_0_1 = token_out_vec_0[0];
    assign dep_chan_vld_0_5 = out_chan_dep_vld_vec_0[1];
    assign dep_chan_data_0_5 = out_chan_dep_data_0;
    assign token_0_5 = token_out_vec_0[1];
    assign dep_chan_vld_0_6 = out_chan_dep_vld_vec_0[2];
    assign dep_chan_data_0_6 = out_chan_dep_data_0;
    assign token_0_6 = token_out_vec_0[2];

    // Process: grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0
    yolov5n_top_hls_deadlock_detect_unit #(7, 1, 3, 3) yolov5n_top_hls_deadlock_detect_unit_1 (
        .reset(reset),
        .clock(clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_1),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_1),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_1),
        .token_in_vec(token_in_vec_1),
        .dl_detect_in(dl_detect_out),
        .origin(origin[1]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_1),
        .out_chan_dep_data(out_chan_dep_data_1),
        .token_out_vec(token_out_vec_1),
        .dl_detect_out(dl_in_vec[1]));

    assign proc_1_data_FIFO_blk[0] = 1'b0 | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.p_act_c_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.c_src_off_c_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.c_dst_off_c_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.c_add_off_c_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.c_src_ch_off_c_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.c_dst_ch_off_c_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.c_add_ch_off_c_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.c_ih_c_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.c_iw_c_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.c_oh_c_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.c_ow_c_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.c_icb_c_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.c_oc_real_c_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.c_kk_c_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.c_ss_c_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.c_pad_c_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.current_tr_c_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.current_tc_c_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.current_nc_c_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.next_rows_c_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.next_cols_c_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.next_r0_c_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.next_c0_c_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.next_valid_c_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.compute_y_c_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.compute_x0_c_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.compute_ob_c_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.compute_nxx_c_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.compute_nwoc_c_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.compute_valid_c_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.store_y_c_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.store_valid_c_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.store_row_last_c_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.quota_c_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.reuse_c_blk_n);
    assign proc_1_data_PIPO_blk[0] = 1'b0;
    assign proc_1_start_FIFO_blk[0] = 1'b0;
    assign proc_1_TLF_FIFO_blk[0] = 1'b0;
    assign proc_1_input_sync_blk[0] = 1'b0 | (grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.ap_sync_r64_memory_U0_ap_ready & grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.ap_idle & ~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.ap_sync_r64_wave_entry11111_U0_ap_ready);
    assign proc_1_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_1[0] = dl_detect_out ? proc_dep_vld_vec_1_reg[0] : (proc_1_data_FIFO_blk[0] | proc_1_data_PIPO_blk[0] | proc_1_start_FIFO_blk[0] | proc_1_TLF_FIFO_blk[0] | proc_1_input_sync_blk[0] | proc_1_output_sync_blk[0]);
    assign proc_1_data_FIFO_blk[1] = 1'b0;
    assign proc_1_data_PIPO_blk[1] = 1'b0;
    assign proc_1_start_FIFO_blk[1] = 1'b0;
    assign proc_1_TLF_FIFO_blk[1] = 1'b0;
    assign proc_1_input_sync_blk[1] = 1'b0 | (grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.ap_sync_r64_memory_U0_ap_ready & grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.ap_idle & ~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.ap_sync_r64_mac_U0_ap_ready);
    assign proc_1_output_sync_blk[1] = 1'b0 | (ap_done_reg_0 & grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.ap_done & ~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_mac_U0.ap_done);
    assign proc_dep_vld_vec_1[1] = dl_detect_out ? proc_dep_vld_vec_1_reg[1] : (proc_1_data_FIFO_blk[1] | proc_1_data_PIPO_blk[1] | proc_1_start_FIFO_blk[1] | proc_1_TLF_FIFO_blk[1] | proc_1_input_sync_blk[1] | proc_1_output_sync_blk[1]);
    assign proc_1_data_FIFO_blk[2] = 1'b0;
    assign proc_1_data_PIPO_blk[2] = 1'b0;
    assign proc_1_start_FIFO_blk[2] = 1'b0;
    assign proc_1_TLF_FIFO_blk[2] = 1'b0;
    assign proc_1_input_sync_blk[2] = 1'b0;
    assign proc_1_output_sync_blk[2] = 1'b0 | (ap_done_reg_0 & grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.ap_done & ~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_quant_U0.ap_done);
    assign proc_dep_vld_vec_1[2] = dl_detect_out ? proc_dep_vld_vec_1_reg[2] : (proc_1_data_FIFO_blk[2] | proc_1_data_PIPO_blk[2] | proc_1_start_FIFO_blk[2] | proc_1_TLF_FIFO_blk[2] | proc_1_input_sync_blk[2] | proc_1_output_sync_blk[2]);
    always @ (negedge reset or posedge clock) begin
        if (~reset) begin
            proc_dep_vld_vec_1_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_1_reg <= proc_dep_vld_vec_1;
        end
    end
    assign in_chan_dep_vld_vec_1[0] = dep_chan_vld_0_1;
    assign in_chan_dep_data_vec_1[6 : 0] = dep_chan_data_0_1;
    assign token_in_vec_1[0] = token_0_1;
    assign in_chan_dep_vld_vec_1[1] = dep_chan_vld_5_1;
    assign in_chan_dep_data_vec_1[13 : 7] = dep_chan_data_5_1;
    assign token_in_vec_1[1] = token_5_1;
    assign in_chan_dep_vld_vec_1[2] = dep_chan_vld_6_1;
    assign in_chan_dep_data_vec_1[20 : 14] = dep_chan_data_6_1;
    assign token_in_vec_1[2] = token_6_1;
    assign dep_chan_vld_1_0 = out_chan_dep_vld_vec_1[0];
    assign dep_chan_data_1_0 = out_chan_dep_data_1;
    assign token_1_0 = token_out_vec_1[0];
    assign dep_chan_vld_1_5 = out_chan_dep_vld_vec_1[1];
    assign dep_chan_data_1_5 = out_chan_dep_data_1;
    assign token_1_5 = token_out_vec_1[1];
    assign dep_chan_vld_1_6 = out_chan_dep_vld_vec_1[2];
    assign dep_chan_data_1_6 = out_chan_dep_data_1;
    assign token_1_6 = token_out_vec_1[2];

    // Process: grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.r64_pair_rows_entry107_U0
    yolov5n_top_hls_deadlock_detect_unit #(7, 2, 2, 2) yolov5n_top_hls_deadlock_detect_unit_2 (
        .reset(reset),
        .clock(clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_2),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_2),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_2),
        .token_in_vec(token_in_vec_2),
        .dl_detect_in(dl_detect_out),
        .origin(origin[2]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_2),
        .out_chan_dep_data(out_chan_dep_data_2),
        .token_out_vec(token_out_vec_2),
        .dl_detect_out(dl_in_vec[2]));

    assign proc_2_data_FIFO_blk[0] = 1'b0 | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.r64_pair_rows_entry107_U0.p_act_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.r64_pair_rows_entry107_U0.src_off_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.r64_pair_rows_entry107_U0.read_base_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.r64_pair_rows_entry107_U0.ibase_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.r64_pair_rows_entry107_U0.count_out_blk_n);
    assign proc_2_data_PIPO_blk[0] = 1'b0;
    assign proc_2_start_FIFO_blk[0] = 1'b0;
    assign proc_2_TLF_FIFO_blk[0] = 1'b0;
    assign proc_2_input_sync_blk[0] = 1'b0 | (grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.ap_sync_r64_pair_rows_entry107_U0_ap_ready & grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.r64_pair_rows_entry107_U0.ap_idle & ~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.ap_sync_r64_pair_read_U0_ap_ready);
    assign proc_2_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_2[0] = dl_detect_out ? proc_dep_vld_vec_2_reg[0] : (proc_2_data_FIFO_blk[0] | proc_2_data_PIPO_blk[0] | proc_2_start_FIFO_blk[0] | proc_2_TLF_FIFO_blk[0] | proc_2_input_sync_blk[0] | proc_2_output_sync_blk[0]);
    assign proc_2_data_FIFO_blk[1] = 1'b0 | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.r64_pair_rows_entry107_U0.p_act_out1_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.r64_pair_rows_entry107_U0.dst_off_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.r64_pair_rows_entry107_U0.base_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.r64_pair_rows_entry107_U0.q_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.r64_pair_rows_entry107_U0.count_out2_blk_n);
    assign proc_2_data_PIPO_blk[1] = 1'b0;
    assign proc_2_start_FIFO_blk[1] = 1'b0 | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.start_for_r64_pair_write_U0_U.if_full_n & grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.r64_pair_rows_entry107_U0.ap_start & ~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.r64_pair_rows_entry107_U0.real_start & (trans_in_cnt_0 == trans_out_cnt_0) & ~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.start_for_r64_pair_write_U0_U.if_read);
    assign proc_2_TLF_FIFO_blk[1] = 1'b0;
    assign proc_2_input_sync_blk[1] = 1'b0;
    assign proc_2_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_2[1] = dl_detect_out ? proc_dep_vld_vec_2_reg[1] : (proc_2_data_FIFO_blk[1] | proc_2_data_PIPO_blk[1] | proc_2_start_FIFO_blk[1] | proc_2_TLF_FIFO_blk[1] | proc_2_input_sync_blk[1] | proc_2_output_sync_blk[1]);
    always @ (negedge reset or posedge clock) begin
        if (~reset) begin
            proc_dep_vld_vec_2_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_2_reg <= proc_dep_vld_vec_2;
        end
    end
    assign in_chan_dep_vld_vec_2[0] = dep_chan_vld_3_2;
    assign in_chan_dep_data_vec_2[6 : 0] = dep_chan_data_3_2;
    assign token_in_vec_2[0] = token_3_2;
    assign in_chan_dep_vld_vec_2[1] = dep_chan_vld_4_2;
    assign in_chan_dep_data_vec_2[13 : 7] = dep_chan_data_4_2;
    assign token_in_vec_2[1] = token_4_2;
    assign dep_chan_vld_2_3 = out_chan_dep_vld_vec_2[0];
    assign dep_chan_data_2_3 = out_chan_dep_data_2;
    assign token_2_3 = token_out_vec_2[0];
    assign dep_chan_vld_2_4 = out_chan_dep_vld_vec_2[1];
    assign dep_chan_data_2_4 = out_chan_dep_data_2;
    assign token_2_4 = token_out_vec_2[1];

    // Process: grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.r64_pair_read_U0
    yolov5n_top_hls_deadlock_detect_unit #(7, 3, 2, 2) yolov5n_top_hls_deadlock_detect_unit_3 (
        .reset(reset),
        .clock(clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_3),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_3),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_3),
        .token_in_vec(token_in_vec_3),
        .dl_detect_in(dl_detect_out),
        .origin(origin[3]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_3),
        .out_chan_dep_data(out_chan_dep_data_3),
        .token_out_vec(token_out_vec_3),
        .dl_detect_out(dl_in_vec[3]));

    assign proc_3_data_FIFO_blk[0] = 1'b0 | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.r64_pair_read_U0.p_act_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.r64_pair_read_U0.src_off_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.r64_pair_read_U0.read_base_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.r64_pair_read_U0.ibase_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.r64_pair_read_U0.count_blk_n);
    assign proc_3_data_PIPO_blk[0] = 1'b0;
    assign proc_3_start_FIFO_blk[0] = 1'b0;
    assign proc_3_TLF_FIFO_blk[0] = 1'b0;
    assign proc_3_input_sync_blk[0] = 1'b0 | (grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.ap_sync_r64_pair_read_U0_ap_ready & grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.r64_pair_read_U0.ap_idle & ~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.ap_sync_r64_pair_rows_entry107_U0_ap_ready);
    assign proc_3_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_3[0] = dl_detect_out ? proc_dep_vld_vec_3_reg[0] : (proc_3_data_FIFO_blk[0] | proc_3_data_PIPO_blk[0] | proc_3_start_FIFO_blk[0] | proc_3_TLF_FIFO_blk[0] | proc_3_input_sync_blk[0] | proc_3_output_sync_blk[0]);
    assign proc_3_data_FIFO_blk[1] = 1'b0;
    assign proc_3_data_PIPO_blk[1] = 1'b0;
    assign proc_3_start_FIFO_blk[1] = 1'b0;
    assign proc_3_TLF_FIFO_blk[1] = 1'b0;
    assign proc_3_input_sync_blk[1] = 1'b0;
    assign proc_3_output_sync_blk[1] = 1'b0 | (ap_done_reg_3 & grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.r64_pair_read_U0.ap_done & ~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.r64_pair_write_U0.ap_done);
    assign proc_dep_vld_vec_3[1] = dl_detect_out ? proc_dep_vld_vec_3_reg[1] : (proc_3_data_FIFO_blk[1] | proc_3_data_PIPO_blk[1] | proc_3_start_FIFO_blk[1] | proc_3_TLF_FIFO_blk[1] | proc_3_input_sync_blk[1] | proc_3_output_sync_blk[1]);
    always @ (negedge reset or posedge clock) begin
        if (~reset) begin
            proc_dep_vld_vec_3_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_3_reg <= proc_dep_vld_vec_3;
        end
    end
    assign in_chan_dep_vld_vec_3[0] = dep_chan_vld_2_3;
    assign in_chan_dep_data_vec_3[6 : 0] = dep_chan_data_2_3;
    assign token_in_vec_3[0] = token_2_3;
    assign in_chan_dep_vld_vec_3[1] = dep_chan_vld_4_3;
    assign in_chan_dep_data_vec_3[13 : 7] = dep_chan_data_4_3;
    assign token_in_vec_3[1] = token_4_3;
    assign dep_chan_vld_3_2 = out_chan_dep_vld_vec_3[0];
    assign dep_chan_data_3_2 = out_chan_dep_data_3;
    assign token_3_2 = token_out_vec_3[0];
    assign dep_chan_vld_3_4 = out_chan_dep_vld_vec_3[1];
    assign dep_chan_data_3_4 = out_chan_dep_data_3;
    assign token_3_4 = token_out_vec_3[1];

    // Process: grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.r64_pair_write_U0
    yolov5n_top_hls_deadlock_detect_unit #(7, 4, 2, 2) yolov5n_top_hls_deadlock_detect_unit_4 (
        .reset(reset),
        .clock(clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_4),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_4),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_4),
        .token_in_vec(token_in_vec_4),
        .dl_detect_in(dl_detect_out),
        .origin(origin[4]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_4),
        .out_chan_dep_data(out_chan_dep_data_4),
        .token_out_vec(token_out_vec_4),
        .dl_detect_out(dl_in_vec[4]));

    assign proc_4_data_FIFO_blk[0] = 1'b0 | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.r64_pair_write_U0.p_act_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.r64_pair_write_U0.dst_off_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.r64_pair_write_U0.base_r_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.r64_pair_write_U0.q_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.r64_pair_write_U0.count_blk_n);
    assign proc_4_data_PIPO_blk[0] = 1'b0;
    assign proc_4_start_FIFO_blk[0] = 1'b0 | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.start_for_r64_pair_write_U0_U.if_empty_n & grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.r64_pair_write_U0.ap_idle & ~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.start_for_r64_pair_write_U0_U.if_write);
    assign proc_4_TLF_FIFO_blk[0] = 1'b0;
    assign proc_4_input_sync_blk[0] = 1'b0;
    assign proc_4_output_sync_blk[0] = 1'b0;
    assign proc_dep_vld_vec_4[0] = dl_detect_out ? proc_dep_vld_vec_4_reg[0] : (proc_4_data_FIFO_blk[0] | proc_4_data_PIPO_blk[0] | proc_4_start_FIFO_blk[0] | proc_4_TLF_FIFO_blk[0] | proc_4_input_sync_blk[0] | proc_4_output_sync_blk[0]);
    assign proc_4_data_FIFO_blk[1] = 1'b0;
    assign proc_4_data_PIPO_blk[1] = 1'b0;
    assign proc_4_start_FIFO_blk[1] = 1'b0;
    assign proc_4_TLF_FIFO_blk[1] = 1'b0;
    assign proc_4_input_sync_blk[1] = 1'b0;
    assign proc_4_output_sync_blk[1] = 1'b0 | (ap_done_reg_4 & grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.r64_pair_write_U0.ap_done & ~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.grp_r64_pair_rows_fu_1459.r64_pair_read_U0.ap_done);
    assign proc_dep_vld_vec_4[1] = dl_detect_out ? proc_dep_vld_vec_4_reg[1] : (proc_4_data_FIFO_blk[1] | proc_4_data_PIPO_blk[1] | proc_4_start_FIFO_blk[1] | proc_4_TLF_FIFO_blk[1] | proc_4_input_sync_blk[1] | proc_4_output_sync_blk[1]);
    always @ (negedge reset or posedge clock) begin
        if (~reset) begin
            proc_dep_vld_vec_4_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_4_reg <= proc_dep_vld_vec_4;
        end
    end
    assign in_chan_dep_vld_vec_4[0] = dep_chan_vld_2_4;
    assign in_chan_dep_data_vec_4[6 : 0] = dep_chan_data_2_4;
    assign token_in_vec_4[0] = token_2_4;
    assign in_chan_dep_vld_vec_4[1] = dep_chan_vld_3_4;
    assign in_chan_dep_data_vec_4[13 : 7] = dep_chan_data_3_4;
    assign token_in_vec_4[1] = token_3_4;
    assign dep_chan_vld_4_2 = out_chan_dep_vld_vec_4[0];
    assign dep_chan_data_4_2 = out_chan_dep_data_4;
    assign token_4_2 = token_out_vec_4[0];
    assign dep_chan_vld_4_3 = out_chan_dep_vld_vec_4[1];
    assign dep_chan_data_4_3 = out_chan_dep_data_4;
    assign token_4_3 = token_out_vec_4[1];

    // Process: grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_mac_U0
    yolov5n_top_hls_deadlock_detect_unit #(7, 5, 3, 3) yolov5n_top_hls_deadlock_detect_unit_5 (
        .reset(reset),
        .clock(clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_5),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_5),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_5),
        .token_in_vec(token_in_vec_5),
        .dl_detect_in(dl_detect_out),
        .origin(origin[5]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_5),
        .out_chan_dep_data(out_chan_dep_data_5),
        .token_out_vec(token_out_vec_5),
        .dl_detect_out(dl_in_vec[5]));

    assign proc_5_data_FIFO_blk[0] = 1'b0 | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_mac_U0.packets_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_mac_U0.c_add_off_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_mac_U0.c_ih_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_mac_U0.c_iw_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_mac_U0.c_oh_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_mac_U0.c_ow_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_mac_U0.c_ocb_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_mac_U0.c_oc_real_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_mac_U0.c_kk_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_mac_U0.c_ss_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_mac_U0.c_pad_out_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_mac_U0.current_nc_out_blk_n);
    assign proc_5_data_PIPO_blk[0] = 1'b0;
    assign proc_5_start_FIFO_blk[0] = 1'b0;
    assign proc_5_TLF_FIFO_blk[0] = 1'b0;
    assign proc_5_input_sync_blk[0] = 1'b0;
    assign proc_5_output_sync_blk[0] = 1'b0 | (ap_done_reg_1 & grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_mac_U0.ap_done & ~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_quant_U0.ap_done);
    assign proc_dep_vld_vec_5[0] = dl_detect_out ? proc_dep_vld_vec_5_reg[0] : (proc_5_data_FIFO_blk[0] | proc_5_data_PIPO_blk[0] | proc_5_start_FIFO_blk[0] | proc_5_TLF_FIFO_blk[0] | proc_5_input_sync_blk[0] | proc_5_output_sync_blk[0]);
    assign proc_5_data_FIFO_blk[1] = 1'b0 | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_mac_U0.c_add_off_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_mac_U0.c_ih_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_mac_U0.c_iw_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_mac_U0.c_oh_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_mac_U0.c_ow_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_mac_U0.c_icb_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_mac_U0.c_ocb_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_mac_U0.c_oc_real_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_mac_U0.c_kk_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_mac_U0.c_ss_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_mac_U0.c_pad_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_mac_U0.current_nc_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_mac_U0.current_rows_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_mac_U0.current_cols_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_mac_U0.compute_y_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_mac_U0.compute_x0_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_mac_U0.compute_ob_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_mac_U0.compute_nxx_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_mac_U0.compute_nwoc_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_mac_U0.compute_valid_blk_n);
    assign proc_5_data_PIPO_blk[1] = 1'b0;
    assign proc_5_start_FIFO_blk[1] = 1'b0;
    assign proc_5_TLF_FIFO_blk[1] = 1'b0;
    assign proc_5_input_sync_blk[1] = 1'b0 | (grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.ap_sync_r64_mac_U0_ap_ready & grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_mac_U0.ap_idle & ~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.ap_sync_r64_wave_entry11111_U0_ap_ready);
    assign proc_5_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_5[1] = dl_detect_out ? proc_dep_vld_vec_5_reg[1] : (proc_5_data_FIFO_blk[1] | proc_5_data_PIPO_blk[1] | proc_5_start_FIFO_blk[1] | proc_5_TLF_FIFO_blk[1] | proc_5_input_sync_blk[1] | proc_5_output_sync_blk[1]);
    assign proc_5_data_FIFO_blk[2] = 1'b0;
    assign proc_5_data_PIPO_blk[2] = 1'b0;
    assign proc_5_start_FIFO_blk[2] = 1'b0;
    assign proc_5_TLF_FIFO_blk[2] = 1'b0;
    assign proc_5_input_sync_blk[2] = 1'b0 | (grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.ap_sync_r64_mac_U0_ap_ready & grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_mac_U0.ap_idle & ~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.ap_sync_r64_memory_U0_ap_ready);
    assign proc_5_output_sync_blk[2] = 1'b0 | (ap_done_reg_1 & grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_mac_U0.ap_done & ~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.ap_done);
    assign proc_dep_vld_vec_5[2] = dl_detect_out ? proc_dep_vld_vec_5_reg[2] : (proc_5_data_FIFO_blk[2] | proc_5_data_PIPO_blk[2] | proc_5_start_FIFO_blk[2] | proc_5_TLF_FIFO_blk[2] | proc_5_input_sync_blk[2] | proc_5_output_sync_blk[2]);
    always @ (negedge reset or posedge clock) begin
        if (~reset) begin
            proc_dep_vld_vec_5_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_5_reg <= proc_dep_vld_vec_5;
        end
    end
    assign in_chan_dep_vld_vec_5[0] = dep_chan_vld_0_5;
    assign in_chan_dep_data_vec_5[6 : 0] = dep_chan_data_0_5;
    assign token_in_vec_5[0] = token_0_5;
    assign in_chan_dep_vld_vec_5[1] = dep_chan_vld_1_5;
    assign in_chan_dep_data_vec_5[13 : 7] = dep_chan_data_1_5;
    assign token_in_vec_5[1] = token_1_5;
    assign in_chan_dep_vld_vec_5[2] = dep_chan_vld_6_5;
    assign in_chan_dep_data_vec_5[20 : 14] = dep_chan_data_6_5;
    assign token_in_vec_5[2] = token_6_5;
    assign dep_chan_vld_5_6 = out_chan_dep_vld_vec_5[0];
    assign dep_chan_data_5_6 = out_chan_dep_data_5;
    assign token_5_6 = token_out_vec_5[0];
    assign dep_chan_vld_5_0 = out_chan_dep_vld_vec_5[1];
    assign dep_chan_data_5_0 = out_chan_dep_data_5;
    assign token_5_0 = token_out_vec_5[1];
    assign dep_chan_vld_5_1 = out_chan_dep_vld_vec_5[2];
    assign dep_chan_data_5_1 = out_chan_dep_data_5;
    assign token_5_1 = token_out_vec_5[2];

    // Process: grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_quant_U0
    yolov5n_top_hls_deadlock_detect_unit #(7, 6, 3, 3) yolov5n_top_hls_deadlock_detect_unit_6 (
        .reset(reset),
        .clock(clock),
        .proc_dep_vld_vec(proc_dep_vld_vec_6),
        .in_chan_dep_vld_vec(in_chan_dep_vld_vec_6),
        .in_chan_dep_data_vec(in_chan_dep_data_vec_6),
        .token_in_vec(token_in_vec_6),
        .dl_detect_in(dl_detect_out),
        .origin(origin[6]),
        .token_clear(token_clear),
        .out_chan_dep_vld_vec(out_chan_dep_vld_vec_6),
        .out_chan_dep_data(out_chan_dep_data_6),
        .token_out_vec(token_out_vec_6),
        .dl_detect_out(dl_in_vec[6]));

    assign proc_6_data_FIFO_blk[0] = 1'b0 | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_quant_U0.packets1_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_quant_U0.c_add_off_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_quant_U0.c_ih_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_quant_U0.c_iw_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_quant_U0.c_oh_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_quant_U0.c_ow_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_quant_U0.c_ocb_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_quant_U0.c_oc_real_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_quant_U0.c_kk_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_quant_U0.c_ss_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_quant_U0.c_pad_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_quant_U0.t_nc_blk_n);
    assign proc_6_data_PIPO_blk[0] = 1'b0;
    assign proc_6_start_FIFO_blk[0] = 1'b0;
    assign proc_6_TLF_FIFO_blk[0] = 1'b0;
    assign proc_6_input_sync_blk[0] = 1'b0;
    assign proc_6_output_sync_blk[0] = 1'b0 | (ap_done_reg_2 & grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_quant_U0.ap_done & ~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_mac_U0.ap_done);
    assign proc_dep_vld_vec_6[0] = dl_detect_out ? proc_dep_vld_vec_6_reg[0] : (proc_6_data_FIFO_blk[0] | proc_6_data_PIPO_blk[0] | proc_6_start_FIFO_blk[0] | proc_6_TLF_FIFO_blk[0] | proc_6_input_sync_blk[0] | proc_6_output_sync_blk[0]);
    assign proc_6_data_FIFO_blk[1] = 1'b0 | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_quant_U0.c_act_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_quant_U0.first_x0_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_quant_U0.first_ob_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_quant_U0.first_nxx_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_quant_U0.first_nwoc_blk_n) | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_quant_U0.first_valid_blk_n);
    assign proc_6_data_PIPO_blk[1] = 1'b0;
    assign proc_6_start_FIFO_blk[1] = 1'b0 | (~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.start_for_r64_quant_U0_U.if_empty_n & grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_quant_U0.ap_idle & ~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.start_for_r64_quant_U0_U.if_write);
    assign proc_6_TLF_FIFO_blk[1] = 1'b0;
    assign proc_6_input_sync_blk[1] = 1'b0;
    assign proc_6_output_sync_blk[1] = 1'b0;
    assign proc_dep_vld_vec_6[1] = dl_detect_out ? proc_dep_vld_vec_6_reg[1] : (proc_6_data_FIFO_blk[1] | proc_6_data_PIPO_blk[1] | proc_6_start_FIFO_blk[1] | proc_6_TLF_FIFO_blk[1] | proc_6_input_sync_blk[1] | proc_6_output_sync_blk[1]);
    assign proc_6_data_FIFO_blk[2] = 1'b0;
    assign proc_6_data_PIPO_blk[2] = 1'b0;
    assign proc_6_start_FIFO_blk[2] = 1'b0;
    assign proc_6_TLF_FIFO_blk[2] = 1'b0;
    assign proc_6_input_sync_blk[2] = 1'b0;
    assign proc_6_output_sync_blk[2] = 1'b0 | (ap_done_reg_2 & grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_quant_U0.ap_done & ~grp_conv_kernel_fu_336.grp_r64_wave_fu_1967.r64_memory_U0.ap_done);
    assign proc_dep_vld_vec_6[2] = dl_detect_out ? proc_dep_vld_vec_6_reg[2] : (proc_6_data_FIFO_blk[2] | proc_6_data_PIPO_blk[2] | proc_6_start_FIFO_blk[2] | proc_6_TLF_FIFO_blk[2] | proc_6_input_sync_blk[2] | proc_6_output_sync_blk[2]);
    always @ (negedge reset or posedge clock) begin
        if (~reset) begin
            proc_dep_vld_vec_6_reg <= 'b0;
        end
        else begin
            proc_dep_vld_vec_6_reg <= proc_dep_vld_vec_6;
        end
    end
    assign in_chan_dep_vld_vec_6[0] = dep_chan_vld_0_6;
    assign in_chan_dep_data_vec_6[6 : 0] = dep_chan_data_0_6;
    assign token_in_vec_6[0] = token_0_6;
    assign in_chan_dep_vld_vec_6[1] = dep_chan_vld_1_6;
    assign in_chan_dep_data_vec_6[13 : 7] = dep_chan_data_1_6;
    assign token_in_vec_6[1] = token_1_6;
    assign in_chan_dep_vld_vec_6[2] = dep_chan_vld_5_6;
    assign in_chan_dep_data_vec_6[20 : 14] = dep_chan_data_5_6;
    assign token_in_vec_6[2] = token_5_6;
    assign dep_chan_vld_6_5 = out_chan_dep_vld_vec_6[0];
    assign dep_chan_data_6_5 = out_chan_dep_data_6;
    assign token_6_5 = token_out_vec_6[0];
    assign dep_chan_vld_6_0 = out_chan_dep_vld_vec_6[1];
    assign dep_chan_data_6_0 = out_chan_dep_data_6;
    assign token_6_0 = token_out_vec_6[1];
    assign dep_chan_vld_6_1 = out_chan_dep_vld_vec_6[2];
    assign dep_chan_data_6_1 = out_chan_dep_data_6;
    assign token_6_1 = token_out_vec_6[2];


`include "yolov5n_top_hls_deadlock_report_unit.vh"
