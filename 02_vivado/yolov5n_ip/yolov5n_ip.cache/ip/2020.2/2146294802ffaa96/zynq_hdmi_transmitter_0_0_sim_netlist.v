// Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
// Date        : Sat Oct 10 17:19:53 2026
// Host        : DESKTOP-IO7F7QJ running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
//               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ zynq_hdmi_transmitter_0_0_sim_netlist.v
// Design      : zynq_hdmi_transmitter_0_0
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xc7z020clg400-2
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_encode
   (rst_n_0,
    de_reg2,
    c0_reg2,
    D,
    c0_reg2_reg_0,
    \data_out_reg[9]_0 ,
    video_de,
    pclk,
    video_hsync,
    video_vsync,
    \data_out_reg[9]_1 ,
    \data_out_reg[9]_2 ,
    Q,
    \data_out_reg[9]_3 ,
    \data_out_reg[9]_4 ,
    \data_out_reg[9]_5 ,
    rst_n,
    video_din);
  output rst_n_0;
  output de_reg2;
  output c0_reg2;
  output [1:0]D;
  output [1:0]c0_reg2_reg_0;
  output [9:0]\data_out_reg[9]_0 ;
  input video_de;
  input pclk;
  input video_hsync;
  input video_vsync;
  input \data_out_reg[9]_1 ;
  input \data_out_reg[9]_2 ;
  input [0:0]Q;
  input \data_out_reg[9]_3 ;
  input \data_out_reg[9]_4 ;
  input [0:0]\data_out_reg[9]_5 ;
  input rst_n;
  input [7:0]video_din;

  wire [1:0]D;
  wire [0:0]Q;
  wire c0_reg1;
  wire c0_reg2;
  wire [1:0]c0_reg2_reg_0;
  wire c1_reg1;
  wire c1_reg2;
  wire [4:1]cnt;
  wire \cnt[1]_i_1_n_0 ;
  wire \cnt[1]_i_2_n_0 ;
  wire \cnt[1]_i_3__0_n_0 ;
  wire \cnt[2]_i_1_n_0 ;
  wire \cnt[2]_i_2_n_0 ;
  wire \cnt[2]_i_3_n_0 ;
  wire \cnt[2]_i_4_n_0 ;
  wire \cnt[3]_i_1__0_n_0 ;
  wire \cnt[3]_i_2_n_0 ;
  wire \cnt[3]_i_3_n_0 ;
  wire \cnt[3]_i_4_n_0 ;
  wire \cnt[3]_i_5_n_0 ;
  wire \cnt[3]_i_6_n_0 ;
  wire \cnt[3]_i_7_n_0 ;
  wire \cnt[4]_i_10_n_0 ;
  wire \cnt[4]_i_11_n_0 ;
  wire \cnt[4]_i_12_n_0 ;
  wire \cnt[4]_i_13_n_0 ;
  wire \cnt[4]_i_14_n_0 ;
  wire \cnt[4]_i_15_n_0 ;
  wire \cnt[4]_i_16_n_0 ;
  wire \cnt[4]_i_17_n_0 ;
  wire \cnt[4]_i_18_n_0 ;
  wire \cnt[4]_i_19_n_0 ;
  wire \cnt[4]_i_1_n_0 ;
  wire \cnt[4]_i_20_n_0 ;
  wire \cnt[4]_i_21_n_0 ;
  wire \cnt[4]_i_22_n_0 ;
  wire \cnt[4]_i_23_n_0 ;
  wire \cnt[4]_i_24_n_0 ;
  wire \cnt[4]_i_2_n_0 ;
  wire \cnt[4]_i_3_n_0 ;
  wire \cnt[4]_i_4_n_0 ;
  wire \cnt[4]_i_5_n_0 ;
  wire \cnt[4]_i_6_n_0 ;
  wire \cnt[4]_i_7_n_0 ;
  wire \cnt[4]_i_8_n_0 ;
  wire \cnt[4]_i_9_n_0 ;
  wire [3:0]data_in_n1;
  wire [3:0]data_in_n10;
  wire \data_in_n1[0]_i_2_n_0 ;
  wire \data_in_n1[1]_i_2_n_0 ;
  wire \data_in_n1[2]_i_2_n_0 ;
  wire \data_in_n1[3]_i_2_n_0 ;
  wire \data_in_n1[3]_i_3_n_0 ;
  wire \data_in_n1[3]_i_4_n_0 ;
  wire \data_in_reg_reg_n_0_[0] ;
  wire [8:0]data_out;
  wire \data_out[9]_i_1_n_0 ;
  wire [9:0]\data_out_reg[9]_0 ;
  wire \data_out_reg[9]_1 ;
  wire \data_out_reg[9]_2 ;
  wire \data_out_reg[9]_3 ;
  wire \data_out_reg[9]_4 ;
  wire [0:0]\data_out_reg[9]_5 ;
  wire de_reg1;
  wire de_reg2;
  wire p_0_in;
  wire p_0_in0_in;
  wire p_0_in1_in;
  wire p_0_in2_in;
  wire p_0_in3_in;
  wire p_0_in4_in;
  wire p_0_in5_in;
  wire pclk;
  wire [8:8]q_m;
  wire q_m_1;
  wire q_m_2;
  wire q_m_3;
  wire q_m_4;
  wire q_m_6;
  wire q_m_7;
  wire [3:1]q_m_n0;
  wire [3:1]q_m_n00;
  wire [3:1]q_m_n1;
  wire [3:1]q_m_n10;
  wire \q_m_n1[2]_i_1_n_0 ;
  wire \q_m_n1[3]_i_2_n_0 ;
  wire \q_m_n1[3]_i_3_n_0 ;
  wire \q_m_n1[3]_i_4_n_0 ;
  wire \q_m_n1[3]_i_5_n_0 ;
  wire \q_m_n1[3]_i_6_n_0 ;
  wire \q_m_n1[3]_i_7_n_0 ;
  wire [8:0]q_m_reg;
  wire \q_m_reg[5]_i_1_n_0 ;
  wire \q_m_reg[7]_i_2_n_0 ;
  wire \q_m_reg[7]_i_3_n_0 ;
  wire rst_n;
  wire rst_n_0;
  wire video_de;
  wire [7:0]video_din;
  wire video_hsync;
  wire video_vsync;

  FDCE c0_reg1_reg
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(video_hsync),
        .Q(c0_reg1));
  FDCE c0_reg2_reg
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(c0_reg1),
        .Q(c0_reg2));
  FDCE c1_reg1_reg
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(video_vsync),
        .Q(c1_reg1));
  FDCE c1_reg2_reg
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(c1_reg1),
        .Q(c1_reg2));
  LUT6 #(
    .INIT(64'h0028AA28AA280028)) 
    \cnt[1]_i_1 
       (.I0(de_reg2),
        .I1(\cnt[1]_i_2_n_0 ),
        .I2(cnt[1]),
        .I3(\cnt[4]_i_3_n_0 ),
        .I4(\cnt[4]_i_5_n_0 ),
        .I5(\cnt[1]_i_3__0_n_0 ),
        .O(\cnt[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \cnt[1]_i_2 
       (.I0(q_m_n1[1]),
        .I1(q_m_n0[1]),
        .O(\cnt[1]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT4 #(
    .INIT(16'h9669)) 
    \cnt[1]_i_3__0 
       (.I0(cnt[1]),
        .I1(q_m_n0[1]),
        .I2(q_m_reg[8]),
        .I3(q_m_n1[1]),
        .O(\cnt[1]_i_3__0_n_0 ));
  LUT6 #(
    .INIT(64'h020202A2A2A202A2)) 
    \cnt[2]_i_1 
       (.I0(de_reg2),
        .I1(\cnt[2]_i_2_n_0 ),
        .I2(\cnt[4]_i_3_n_0 ),
        .I3(\cnt[2]_i_3_n_0 ),
        .I4(\cnt[4]_i_5_n_0 ),
        .I5(\cnt[2]_i_4_n_0 ),
        .O(\cnt[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'h56955965)) 
    \cnt[2]_i_2 
       (.I0(\cnt[4]_i_10_n_0 ),
        .I1(cnt[1]),
        .I2(q_m_n1[1]),
        .I3(q_m_n0[1]),
        .I4(q_m_reg[8]),
        .O(\cnt[2]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair2" *) 
  LUT5 #(
    .INIT(32'h596565A6)) 
    \cnt[2]_i_3 
       (.I0(\cnt[4]_i_10_n_0 ),
        .I1(q_m_reg[8]),
        .I2(q_m_n0[1]),
        .I3(q_m_n1[1]),
        .I4(cnt[1]),
        .O(\cnt[2]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair1" *) 
  LUT5 #(
    .INIT(32'h9A595965)) 
    \cnt[2]_i_4 
       (.I0(\cnt[4]_i_10_n_0 ),
        .I1(cnt[1]),
        .I2(q_m_n1[1]),
        .I3(q_m_reg[8]),
        .I4(q_m_n0[1]),
        .O(\cnt[2]_i_4_n_0 ));
  LUT6 #(
    .INIT(64'h22E22EEE00000000)) 
    \cnt[3]_i_1__0 
       (.I0(\cnt[3]_i_2_n_0 ),
        .I1(\cnt[4]_i_3_n_0 ),
        .I2(\cnt[4]_i_5_n_0 ),
        .I3(\cnt[3]_i_3_n_0 ),
        .I4(\cnt[3]_i_4_n_0 ),
        .I5(de_reg2),
        .O(\cnt[3]_i_1__0_n_0 ));
  LUT6 #(
    .INIT(64'hF3200CDF0CDFF320)) 
    \cnt[3]_i_2 
       (.I0(\cnt[1]_i_2_n_0 ),
        .I1(cnt[1]),
        .I2(\cnt[3]_i_5_n_0 ),
        .I3(\cnt[4]_i_10_n_0 ),
        .I4(\cnt[4]_i_12_n_0 ),
        .I5(\cnt[4]_i_8_n_0 ),
        .O(\cnt[3]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h5955995999599A99)) 
    \cnt[3]_i_3 
       (.I0(\cnt[3]_i_6_n_0 ),
        .I1(\cnt[4]_i_10_n_0 ),
        .I2(cnt[1]),
        .I3(q_m_n1[1]),
        .I4(q_m_reg[8]),
        .I5(q_m_n0[1]),
        .O(\cnt[3]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h7F0180FE80FE7F01)) 
    \cnt[3]_i_4 
       (.I0(\cnt[3]_i_7_n_0 ),
        .I1(cnt[1]),
        .I2(q_m_n1[1]),
        .I3(\cnt[4]_i_17_n_0 ),
        .I4(\cnt[4]_i_14_n_0 ),
        .I5(\cnt[4]_i_15_n_0 ),
        .O(\cnt[3]_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT3 #(
    .INIT(8'hDB)) 
    \cnt[3]_i_5 
       (.I0(q_m_reg[8]),
        .I1(q_m_n0[1]),
        .I2(q_m_n1[1]),
        .O(\cnt[3]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'h6969966996699696)) 
    \cnt[3]_i_6 
       (.I0(q_m_n1[3]),
        .I1(q_m_n0[3]),
        .I2(cnt[3]),
        .I3(q_m_n1[2]),
        .I4(q_m_n0[2]),
        .I5(cnt[2]),
        .O(\cnt[3]_i_6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair16" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \cnt[3]_i_7 
       (.I0(q_m_n0[1]),
        .I1(q_m_reg[8]),
        .O(\cnt[3]_i_7_n_0 ));
  LUT6 #(
    .INIT(64'h020202A2A2A202A2)) 
    \cnt[4]_i_1 
       (.I0(de_reg2),
        .I1(\cnt[4]_i_2_n_0 ),
        .I2(\cnt[4]_i_3_n_0 ),
        .I3(\cnt[4]_i_4_n_0 ),
        .I4(\cnt[4]_i_5_n_0 ),
        .I5(\cnt[4]_i_6_n_0 ),
        .O(\cnt[4]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT3 #(
    .INIT(8'h96)) 
    \cnt[4]_i_10 
       (.I0(cnt[2]),
        .I1(q_m_n0[2]),
        .I2(q_m_n1[2]),
        .O(\cnt[4]_i_10_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT4 #(
    .INIT(16'hEFFB)) 
    \cnt[4]_i_11 
       (.I0(cnt[1]),
        .I1(q_m_n1[1]),
        .I2(q_m_n0[1]),
        .I3(q_m_reg[8]),
        .O(\cnt[4]_i_11_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair10" *) 
  LUT4 #(
    .INIT(16'hB28E)) 
    \cnt[4]_i_12 
       (.I0(cnt[2]),
        .I1(q_m_n0[2]),
        .I2(q_m_n1[2]),
        .I3(q_m_reg[8]),
        .O(\cnt[4]_i_12_n_0 ));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    \cnt[4]_i_13 
       (.I0(q_m_n0[3]),
        .I1(q_m_n1[3]),
        .I2(q_m_n1[2]),
        .I3(q_m_n0[2]),
        .I4(q_m_n1[1]),
        .I5(q_m_n0[1]),
        .O(\cnt[4]_i_13_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT5 #(
    .INIT(32'hB44B4BB4)) 
    \cnt[4]_i_14 
       (.I0(q_m_n1[2]),
        .I1(q_m_n0[2]),
        .I2(q_m_n1[3]),
        .I3(q_m_n0[3]),
        .I4(cnt[3]),
        .O(\cnt[4]_i_14_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h2F02022F)) 
    \cnt[4]_i_15 
       (.I0(q_m_n0[1]),
        .I1(q_m_reg[8]),
        .I2(cnt[2]),
        .I3(q_m_n0[2]),
        .I4(q_m_n1[2]),
        .O(\cnt[4]_i_15_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT4 #(
    .INIT(16'h7117)) 
    \cnt[4]_i_16 
       (.I0(q_m_n1[1]),
        .I1(cnt[1]),
        .I2(q_m_n0[1]),
        .I3(q_m_reg[8]),
        .O(\cnt[4]_i_16_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair0" *) 
  LUT5 #(
    .INIT(32'h96699696)) 
    \cnt[4]_i_17 
       (.I0(q_m_n1[2]),
        .I1(q_m_n0[2]),
        .I2(cnt[2]),
        .I3(q_m_reg[8]),
        .I4(q_m_n0[1]),
        .O(\cnt[4]_i_17_n_0 ));
  LUT6 #(
    .INIT(64'h9A55AA9A55659A55)) 
    \cnt[4]_i_18 
       (.I0(cnt[4]),
        .I1(q_m_n1[2]),
        .I2(q_m_n0[2]),
        .I3(q_m_n1[3]),
        .I4(q_m_n0[3]),
        .I5(cnt[3]),
        .O(\cnt[4]_i_18_n_0 ));
  LUT6 #(
    .INIT(64'hDDFD00F0FFFFDDFD)) 
    \cnt[4]_i_19 
       (.I0(q_m_n0[1]),
        .I1(q_m_n1[1]),
        .I2(q_m_n1[3]),
        .I3(q_m_n0[3]),
        .I4(q_m_n1[2]),
        .I5(q_m_n0[2]),
        .O(\cnt[4]_i_19_n_0 ));
  LUT6 #(
    .INIT(64'h595599999A99AAAA)) 
    \cnt[4]_i_2 
       (.I0(\cnt[4]_i_7_n_0 ),
        .I1(\cnt[4]_i_8_n_0 ),
        .I2(\cnt[4]_i_9_n_0 ),
        .I3(\cnt[4]_i_10_n_0 ),
        .I4(\cnt[4]_i_11_n_0 ),
        .I5(\cnt[4]_i_12_n_0 ),
        .O(\cnt[4]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hFF2F2F22FF2FFF2F)) 
    \cnt[4]_i_20 
       (.I0(q_m_n0[3]),
        .I1(q_m_n1[3]),
        .I2(q_m_n1[2]),
        .I3(q_m_n0[2]),
        .I4(q_m_n0[1]),
        .I5(q_m_n1[1]),
        .O(\cnt[4]_i_20_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair12" *) 
  LUT4 #(
    .INIT(16'h0096)) 
    \cnt[4]_i_21 
       (.I0(q_m_n0[1]),
        .I1(q_m_reg[8]),
        .I2(q_m_n1[1]),
        .I3(cnt[1]),
        .O(\cnt[4]_i_21_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair13" *) 
  LUT3 #(
    .INIT(8'h4D)) 
    \cnt[4]_i_22 
       (.I0(q_m_reg[8]),
        .I1(q_m_n1[1]),
        .I2(q_m_n0[1]),
        .O(\cnt[4]_i_22_n_0 ));
  LUT3 #(
    .INIT(8'h8E)) 
    \cnt[4]_i_23 
       (.I0(cnt[2]),
        .I1(q_m_n0[2]),
        .I2(q_m_n1[2]),
        .O(\cnt[4]_i_23_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT4 #(
    .INIT(16'h599A)) 
    \cnt[4]_i_24 
       (.I0(cnt[4]),
        .I1(q_m_n1[3]),
        .I2(q_m_n0[3]),
        .I3(cnt[3]),
        .O(\cnt[4]_i_24_n_0 ));
  LUT5 #(
    .INIT(32'h55555554)) 
    \cnt[4]_i_3 
       (.I0(\cnt[4]_i_13_n_0 ),
        .I1(cnt[2]),
        .I2(cnt[4]),
        .I3(cnt[1]),
        .I4(cnt[3]),
        .O(\cnt[4]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h11171777EEE8E888)) 
    \cnt[4]_i_4 
       (.I0(\cnt[4]_i_14_n_0 ),
        .I1(\cnt[4]_i_15_n_0 ),
        .I2(\cnt[1]_i_3__0_n_0 ),
        .I3(\cnt[4]_i_16_n_0 ),
        .I4(\cnt[4]_i_17_n_0 ),
        .I5(\cnt[4]_i_18_n_0 ),
        .O(\cnt[4]_i_4_n_0 ));
  LUT5 #(
    .INIT(32'h47C477F7)) 
    \cnt[4]_i_5 
       (.I0(\cnt[4]_i_19_n_0 ),
        .I1(cnt[4]),
        .I2(q_m_n0[3]),
        .I3(q_m_n1[3]),
        .I4(\cnt[4]_i_20_n_0 ),
        .O(\cnt[4]_i_5_n_0 ));
  LUT6 #(
    .INIT(64'hE8FF00E81700FF17)) 
    \cnt[4]_i_6 
       (.I0(\cnt[4]_i_21_n_0 ),
        .I1(\cnt[4]_i_10_n_0 ),
        .I2(\cnt[4]_i_22_n_0 ),
        .I3(\cnt[4]_i_23_n_0 ),
        .I4(\cnt[4]_i_8_n_0 ),
        .I5(\cnt[4]_i_24_n_0 ),
        .O(\cnt[4]_i_6_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair4" *) 
  LUT5 #(
    .INIT(32'h5965A96A)) 
    \cnt[4]_i_7 
       (.I0(cnt[4]),
        .I1(q_m_reg[8]),
        .I2(q_m_n1[3]),
        .I3(q_m_n0[3]),
        .I4(cnt[3]),
        .O(\cnt[4]_i_7_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair3" *) 
  LUT3 #(
    .INIT(8'h96)) 
    \cnt[4]_i_8 
       (.I0(cnt[3]),
        .I1(q_m_n0[3]),
        .I2(q_m_n1[3]),
        .O(\cnt[4]_i_8_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair11" *) 
  LUT4 #(
    .INIT(16'h0820)) 
    \cnt[4]_i_9 
       (.I0(cnt[1]),
        .I1(q_m_n1[1]),
        .I2(q_m_n0[1]),
        .I3(q_m_reg[8]),
        .O(\cnt[4]_i_9_n_0 ));
  FDCE \cnt_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(\cnt[1]_i_1_n_0 ),
        .Q(cnt[1]));
  FDCE \cnt_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(\cnt[2]_i_1_n_0 ),
        .Q(cnt[2]));
  FDCE \cnt_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(\cnt[3]_i_1__0_n_0 ),
        .Q(cnt[3]));
  FDCE \cnt_reg[4] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(\cnt[4]_i_1_n_0 ),
        .Q(cnt[4]));
  LUT6 #(
    .INIT(64'h6996966996696996)) 
    \data_in_n1[0]_i_1 
       (.I0(video_din[0]),
        .I1(video_din[7]),
        .I2(\data_in_n1[0]_i_2_n_0 ),
        .I3(video_din[2]),
        .I4(video_din[1]),
        .I5(video_din[3]),
        .O(data_in_n10[0]));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT3 #(
    .INIT(8'h96)) 
    \data_in_n1[0]_i_2 
       (.I0(video_din[6]),
        .I1(video_din[4]),
        .I2(video_din[5]),
        .O(\data_in_n1[0]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'h96)) 
    \data_in_n1[1]_i_1 
       (.I0(\data_in_n1[3]_i_2_n_0 ),
        .I1(\data_in_n1[1]_i_2_n_0 ),
        .I2(\data_in_n1[3]_i_3_n_0 ),
        .O(data_in_n10[1]));
  LUT6 #(
    .INIT(64'h171717E817E8E8E8)) 
    \data_in_n1[1]_i_2 
       (.I0(video_din[3]),
        .I1(video_din[2]),
        .I2(video_din[1]),
        .I3(video_din[6]),
        .I4(video_din[5]),
        .I5(video_din[4]),
        .O(\data_in_n1[1]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h7E7E7EE87EE8E8E8)) 
    \data_in_n1[2]_i_1 
       (.I0(\data_in_n1[3]_i_2_n_0 ),
        .I1(\data_in_n1[3]_i_3_n_0 ),
        .I2(\data_in_n1[2]_i_2_n_0 ),
        .I3(video_din[4]),
        .I4(video_din[5]),
        .I5(video_din[6]),
        .O(data_in_n10[2]));
  LUT3 #(
    .INIT(8'hE8)) 
    \data_in_n1[2]_i_2 
       (.I0(video_din[1]),
        .I1(video_din[2]),
        .I2(video_din[3]),
        .O(\data_in_n1[2]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h8880800000000000)) 
    \data_in_n1[3]_i_1 
       (.I0(\data_in_n1[3]_i_2_n_0 ),
        .I1(\data_in_n1[3]_i_3_n_0 ),
        .I2(video_din[3]),
        .I3(video_din[2]),
        .I4(video_din[1]),
        .I5(\data_in_n1[3]_i_4_n_0 ),
        .O(data_in_n10[3]));
  LUT6 #(
    .INIT(64'h9600009600969600)) 
    \data_in_n1[3]_i_2 
       (.I0(video_din[2]),
        .I1(video_din[1]),
        .I2(video_din[3]),
        .I3(video_din[0]),
        .I4(video_din[7]),
        .I5(\data_in_n1[0]_i_2_n_0 ),
        .O(\data_in_n1[3]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair5" *) 
  LUT5 #(
    .INIT(32'hE88E8EE8)) 
    \data_in_n1[3]_i_3 
       (.I0(video_din[7]),
        .I1(video_din[0]),
        .I2(video_din[5]),
        .I3(video_din[4]),
        .I4(video_din[6]),
        .O(\data_in_n1[3]_i_3_n_0 ));
  LUT3 #(
    .INIT(8'hE8)) 
    \data_in_n1[3]_i_4 
       (.I0(video_din[4]),
        .I1(video_din[5]),
        .I2(video_din[6]),
        .O(\data_in_n1[3]_i_4_n_0 ));
  FDCE \data_in_n1_reg[0] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(data_in_n10[0]),
        .Q(data_in_n1[0]));
  FDCE \data_in_n1_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(data_in_n10[1]),
        .Q(data_in_n1[1]));
  FDCE \data_in_n1_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(data_in_n10[2]),
        .Q(data_in_n1[2]));
  FDCE \data_in_n1_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(data_in_n10[3]),
        .Q(data_in_n1[3]));
  LUT1 #(
    .INIT(2'h1)) 
    \data_in_reg[7]_i_1 
       (.I0(rst_n),
        .O(rst_n_0));
  FDCE \data_in_reg_reg[0] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(video_din[0]),
        .Q(\data_in_reg_reg_n_0_[0] ));
  FDCE \data_in_reg_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(video_din[1]),
        .Q(p_0_in5_in));
  FDCE \data_in_reg_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(video_din[2]),
        .Q(p_0_in4_in));
  FDCE \data_in_reg_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(video_din[3]),
        .Q(p_0_in3_in));
  FDCE \data_in_reg_reg[4] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(video_din[4]),
        .Q(p_0_in2_in));
  FDCE \data_in_reg_reg[5] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(video_din[5]),
        .Q(p_0_in1_in));
  FDCE \data_in_reg_reg[6] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(video_din[6]),
        .Q(p_0_in0_in));
  FDCE \data_in_reg_reg[7] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(video_din[7]),
        .Q(p_0_in));
  LUT6 #(
    .INIT(64'h59A9FFFF59A90000)) 
    \data_out[0]_i_1 
       (.I0(q_m_reg[0]),
        .I1(q_m_reg[8]),
        .I2(\cnt[4]_i_3_n_0 ),
        .I3(\cnt[4]_i_5_n_0 ),
        .I4(de_reg2),
        .I5(c0_reg2),
        .O(data_out[0]));
  LUT6 #(
    .INIT(64'h59A9FFFF59A90000)) 
    \data_out[1]_i_1 
       (.I0(q_m_reg[1]),
        .I1(q_m_reg[8]),
        .I2(\cnt[4]_i_3_n_0 ),
        .I3(\cnt[4]_i_5_n_0 ),
        .I4(de_reg2),
        .I5(c0_reg2),
        .O(data_out[1]));
  LUT6 #(
    .INIT(64'h08A85DFDA202F757)) 
    \data_out[2]_i_1 
       (.I0(de_reg2),
        .I1(q_m_reg[8]),
        .I2(\cnt[4]_i_3_n_0 ),
        .I3(\cnt[4]_i_5_n_0 ),
        .I4(c0_reg2),
        .I5(q_m_reg[2]),
        .O(data_out[2]));
  LUT6 #(
    .INIT(64'h59A9FFFF59A90000)) 
    \data_out[3]_i_1 
       (.I0(q_m_reg[3]),
        .I1(q_m_reg[8]),
        .I2(\cnt[4]_i_3_n_0 ),
        .I3(\cnt[4]_i_5_n_0 ),
        .I4(de_reg2),
        .I5(c0_reg2),
        .O(data_out[3]));
  LUT6 #(
    .INIT(64'h08A85DFDA202F757)) 
    \data_out[4]_i_1 
       (.I0(de_reg2),
        .I1(q_m_reg[8]),
        .I2(\cnt[4]_i_3_n_0 ),
        .I3(\cnt[4]_i_5_n_0 ),
        .I4(c0_reg2),
        .I5(q_m_reg[4]),
        .O(data_out[4]));
  LUT6 #(
    .INIT(64'h59A9FFFF59A90000)) 
    \data_out[5]_i_1 
       (.I0(q_m_reg[5]),
        .I1(q_m_reg[8]),
        .I2(\cnt[4]_i_3_n_0 ),
        .I3(\cnt[4]_i_5_n_0 ),
        .I4(de_reg2),
        .I5(c0_reg2),
        .O(data_out[5]));
  LUT6 #(
    .INIT(64'h08A85DFDA202F757)) 
    \data_out[6]_i_1 
       (.I0(de_reg2),
        .I1(q_m_reg[8]),
        .I2(\cnt[4]_i_3_n_0 ),
        .I3(\cnt[4]_i_5_n_0 ),
        .I4(c0_reg2),
        .I5(q_m_reg[6]),
        .O(data_out[6]));
  LUT6 #(
    .INIT(64'h59A9FFFF59A90000)) 
    \data_out[7]_i_1 
       (.I0(q_m_reg[7]),
        .I1(q_m_reg[8]),
        .I2(\cnt[4]_i_3_n_0 ),
        .I3(\cnt[4]_i_5_n_0 ),
        .I4(de_reg2),
        .I5(c0_reg2),
        .O(data_out[7]));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT3 #(
    .INIT(8'hC5)) 
    \data_out[8]_i_1 
       (.I0(c0_reg2),
        .I1(q_m_reg[8]),
        .I2(de_reg2),
        .O(data_out[8]));
  (* SOFT_HLUTNM = "soft_lutpair14" *) 
  LUT3 #(
    .INIT(8'hC5)) 
    \data_out[8]_i_1__0 
       (.I0(c0_reg2),
        .I1(\data_out_reg[9]_5 ),
        .I2(de_reg2),
        .O(c0_reg2_reg_0[0]));
  LUT3 #(
    .INIT(8'hC5)) 
    \data_out[8]_i_1__1 
       (.I0(c0_reg2),
        .I1(Q),
        .I2(de_reg2),
        .O(D[0]));
  LUT6 #(
    .INIT(64'hF000F0FF99999999)) 
    \data_out[9]_i_1 
       (.I0(c0_reg2),
        .I1(c1_reg2),
        .I2(\cnt[4]_i_5_n_0 ),
        .I3(\cnt[4]_i_3_n_0 ),
        .I4(q_m_reg[8]),
        .I5(de_reg2),
        .O(\data_out[9]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h09F9090909F9F9F9)) 
    \data_out[9]_i_1__0 
       (.I0(c0_reg2),
        .I1(c1_reg2),
        .I2(de_reg2),
        .I3(\data_out_reg[9]_1 ),
        .I4(\data_out_reg[9]_2 ),
        .I5(Q),
        .O(D[1]));
  LUT6 #(
    .INIT(64'hF000F0FF99999999)) 
    \data_out[9]_i_1__1 
       (.I0(c0_reg2),
        .I1(c1_reg2),
        .I2(\data_out_reg[9]_3 ),
        .I3(\data_out_reg[9]_4 ),
        .I4(\data_out_reg[9]_5 ),
        .I5(de_reg2),
        .O(c0_reg2_reg_0[1]));
  FDCE \data_out_reg[0] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(data_out[0]),
        .Q(\data_out_reg[9]_0 [0]));
  FDCE \data_out_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(data_out[1]),
        .Q(\data_out_reg[9]_0 [1]));
  FDCE \data_out_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(data_out[2]),
        .Q(\data_out_reg[9]_0 [2]));
  FDCE \data_out_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(data_out[3]),
        .Q(\data_out_reg[9]_0 [3]));
  FDCE \data_out_reg[4] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(data_out[4]),
        .Q(\data_out_reg[9]_0 [4]));
  FDCE \data_out_reg[5] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(data_out[5]),
        .Q(\data_out_reg[9]_0 [5]));
  FDCE \data_out_reg[6] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(data_out[6]),
        .Q(\data_out_reg[9]_0 [6]));
  FDCE \data_out_reg[7] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(data_out[7]),
        .Q(\data_out_reg[9]_0 [7]));
  FDCE \data_out_reg[8] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(data_out[8]),
        .Q(\data_out_reg[9]_0 [8]));
  FDCE \data_out_reg[9] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(\data_out[9]_i_1_n_0 ),
        .Q(\data_out_reg[9]_0 [9]));
  FDCE de_reg1_reg
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(video_de),
        .Q(de_reg1));
  FDCE de_reg2_reg
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(de_reg1),
        .Q(de_reg2));
  LUT6 #(
    .INIT(64'h9996699996669996)) 
    \q_m_n0[1]_i_1 
       (.I0(\q_m_n1[3]_i_3_n_0 ),
        .I1(\q_m_n1[3]_i_2_n_0 ),
        .I2(\q_m_n1[3]_i_5_n_0 ),
        .I3(\q_m_n1[3]_i_4_n_0 ),
        .I4(\data_in_reg_reg_n_0_[0] ),
        .I5(\q_m_n1[3]_i_6_n_0 ),
        .O(q_m_n00[1]));
  LUT6 #(
    .INIT(64'h2000FBB2FBB2DFFF)) 
    \q_m_n0[2]_i_1 
       (.I0(\q_m_n1[3]_i_6_n_0 ),
        .I1(\data_in_reg_reg_n_0_[0] ),
        .I2(\q_m_n1[3]_i_4_n_0 ),
        .I3(\q_m_n1[3]_i_5_n_0 ),
        .I4(\q_m_n1[3]_i_2_n_0 ),
        .I5(\q_m_n1[3]_i_3_n_0 ),
        .O(q_m_n00[2]));
  LUT6 #(
    .INIT(64'h0100000000000000)) 
    \q_m_n0[3]_i_1 
       (.I0(\q_m_n1[3]_i_2_n_0 ),
        .I1(\q_m_n1[3]_i_3_n_0 ),
        .I2(\data_in_reg_reg_n_0_[0] ),
        .I3(\q_m_n1[3]_i_4_n_0 ),
        .I4(\q_m_n1[3]_i_5_n_0 ),
        .I5(\q_m_n1[3]_i_6_n_0 ),
        .O(q_m_n00[3]));
  FDCE \q_m_n0_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(q_m_n00[1]),
        .Q(q_m_n0[1]));
  FDCE \q_m_n0_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(q_m_n00[2]),
        .Q(q_m_n0[2]));
  FDCE \q_m_n0_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(q_m_n00[3]),
        .Q(q_m_n0[3]));
  LUT6 #(
    .INIT(64'h6696969996999969)) 
    \q_m_n1[1]_i_1 
       (.I0(\q_m_n1[3]_i_2_n_0 ),
        .I1(\q_m_n1[3]_i_3_n_0 ),
        .I2(\data_in_reg_reg_n_0_[0] ),
        .I3(\q_m_n1[3]_i_4_n_0 ),
        .I4(\q_m_n1[3]_i_5_n_0 ),
        .I5(\q_m_n1[3]_i_6_n_0 ),
        .O(q_m_n10[1]));
  LUT6 #(
    .INIT(64'hFFEF71F771F70010)) 
    \q_m_n1[2]_i_1 
       (.I0(\q_m_n1[3]_i_5_n_0 ),
        .I1(\q_m_n1[3]_i_4_n_0 ),
        .I2(\data_in_reg_reg_n_0_[0] ),
        .I3(\q_m_n1[3]_i_6_n_0 ),
        .I4(\q_m_n1[3]_i_3_n_0 ),
        .I5(\q_m_n1[3]_i_2_n_0 ),
        .O(\q_m_n1[2]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000080)) 
    \q_m_n1[3]_i_1 
       (.I0(\q_m_n1[3]_i_2_n_0 ),
        .I1(\q_m_n1[3]_i_3_n_0 ),
        .I2(\data_in_reg_reg_n_0_[0] ),
        .I3(\q_m_n1[3]_i_4_n_0 ),
        .I4(\q_m_n1[3]_i_5_n_0 ),
        .I5(\q_m_n1[3]_i_6_n_0 ),
        .O(q_m_n10[3]));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT5 #(
    .INIT(32'hB42D4BD2)) 
    \q_m_n1[3]_i_2 
       (.I0(\q_m_reg[7]_i_2_n_0 ),
        .I1(p_0_in3_in),
        .I2(\data_in_reg_reg_n_0_[0] ),
        .I3(p_0_in4_in),
        .I4(p_0_in5_in),
        .O(\q_m_n1[3]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'hE11E1EE178878778)) 
    \q_m_n1[3]_i_3 
       (.I0(p_0_in0_in),
        .I1(\q_m_reg[7]_i_2_n_0 ),
        .I2(q_m_2),
        .I3(p_0_in2_in),
        .I4(p_0_in3_in),
        .I5(p_0_in1_in),
        .O(\q_m_n1[3]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h9669699669969669)) 
    \q_m_n1[3]_i_4 
       (.I0(p_0_in3_in),
        .I1(p_0_in2_in),
        .I2(\data_in_reg_reg_n_0_[0] ),
        .I3(p_0_in4_in),
        .I4(p_0_in5_in),
        .I5(\q_m_n1[3]_i_7_n_0 ),
        .O(\q_m_n1[3]_i_4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT5 #(
    .INIT(32'h96696996)) 
    \q_m_n1[3]_i_5 
       (.I0(p_0_in0_in),
        .I1(\q_m_reg[7]_i_3_n_0 ),
        .I2(p_0_in1_in),
        .I3(\q_m_reg[7]_i_2_n_0 ),
        .I4(p_0_in),
        .O(\q_m_n1[3]_i_5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT3 #(
    .INIT(8'h69)) 
    \q_m_n1[3]_i_6 
       (.I0(\data_in_reg_reg_n_0_[0] ),
        .I1(p_0_in5_in),
        .I2(p_0_in3_in),
        .O(\q_m_n1[3]_i_6_n_0 ));
  LUT6 #(
    .INIT(64'h5555555566666A66)) 
    \q_m_n1[3]_i_7 
       (.I0(p_0_in0_in),
        .I1(data_in_n1[2]),
        .I2(data_in_n1[0]),
        .I3(\data_in_reg_reg_n_0_[0] ),
        .I4(data_in_n1[1]),
        .I5(data_in_n1[3]),
        .O(\q_m_n1[3]_i_7_n_0 ));
  FDCE \q_m_n1_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(q_m_n10[1]),
        .Q(q_m_n1[1]));
  FDCE \q_m_n1_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(\q_m_n1[2]_i_1_n_0 ),
        .Q(q_m_n1[2]));
  FDCE \q_m_n1_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(q_m_n10[3]),
        .Q(q_m_n1[3]));
  LUT6 #(
    .INIT(64'hFFA800570055FFAA)) 
    \q_m_reg[1]_i_1 
       (.I0(data_in_n1[2]),
        .I1(data_in_n1[0]),
        .I2(data_in_n1[1]),
        .I3(data_in_n1[3]),
        .I4(p_0_in5_in),
        .I5(\data_in_reg_reg_n_0_[0] ),
        .O(q_m_1));
  (* SOFT_HLUTNM = "soft_lutpair15" *) 
  LUT3 #(
    .INIT(8'h96)) 
    \q_m_reg[2]_i_1 
       (.I0(\data_in_reg_reg_n_0_[0] ),
        .I1(p_0_in4_in),
        .I2(p_0_in5_in),
        .O(q_m_2));
  (* SOFT_HLUTNM = "soft_lutpair6" *) 
  LUT5 #(
    .INIT(32'h96696996)) 
    \q_m_reg[3]_i_1 
       (.I0(p_0_in5_in),
        .I1(p_0_in4_in),
        .I2(\data_in_reg_reg_n_0_[0] ),
        .I3(p_0_in3_in),
        .I4(\q_m_reg[7]_i_2_n_0 ),
        .O(q_m_3));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT5 #(
    .INIT(32'h96696996)) 
    \q_m_reg[4]_i_1 
       (.I0(p_0_in3_in),
        .I1(p_0_in2_in),
        .I2(\data_in_reg_reg_n_0_[0] ),
        .I3(p_0_in4_in),
        .I4(p_0_in5_in),
        .O(q_m_4));
  LUT5 #(
    .INIT(32'h96696996)) 
    \q_m_reg[5]_i_1 
       (.I0(\q_m_reg[7]_i_2_n_0 ),
        .I1(q_m_2),
        .I2(p_0_in2_in),
        .I3(p_0_in3_in),
        .I4(p_0_in1_in),
        .O(\q_m_reg[5]_i_1_n_0 ));
  LUT5 #(
    .INIT(32'h96696996)) 
    \q_m_reg[6]_i_1 
       (.I0(p_0_in1_in),
        .I1(p_0_in3_in),
        .I2(p_0_in2_in),
        .I3(q_m_2),
        .I4(p_0_in0_in),
        .O(q_m_6));
  (* SOFT_HLUTNM = "soft_lutpair7" *) 
  LUT5 #(
    .INIT(32'h69969669)) 
    \q_m_reg[7]_i_1 
       (.I0(p_0_in),
        .I1(\q_m_reg[7]_i_2_n_0 ),
        .I2(p_0_in1_in),
        .I3(\q_m_reg[7]_i_3_n_0 ),
        .I4(p_0_in0_in),
        .O(q_m_7));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT5 #(
    .INIT(32'hFFEFAAAA)) 
    \q_m_reg[7]_i_2 
       (.I0(data_in_n1[3]),
        .I1(data_in_n1[1]),
        .I2(\data_in_reg_reg_n_0_[0] ),
        .I3(data_in_n1[0]),
        .I4(data_in_n1[2]),
        .O(\q_m_reg[7]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair9" *) 
  LUT5 #(
    .INIT(32'h69969669)) 
    \q_m_reg[7]_i_3 
       (.I0(p_0_in5_in),
        .I1(p_0_in4_in),
        .I2(\data_in_reg_reg_n_0_[0] ),
        .I3(p_0_in2_in),
        .I4(p_0_in3_in),
        .O(\q_m_reg[7]_i_3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair8" *) 
  LUT5 #(
    .INIT(32'h00005575)) 
    \q_m_reg[8]_i_1 
       (.I0(data_in_n1[2]),
        .I1(data_in_n1[0]),
        .I2(\data_in_reg_reg_n_0_[0] ),
        .I3(data_in_n1[1]),
        .I4(data_in_n1[3]),
        .O(q_m));
  FDCE \q_m_reg_reg[0] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(\data_in_reg_reg_n_0_[0] ),
        .Q(q_m_reg[0]));
  FDCE \q_m_reg_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(q_m_1),
        .Q(q_m_reg[1]));
  FDCE \q_m_reg_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(q_m_2),
        .Q(q_m_reg[2]));
  FDCE \q_m_reg_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(q_m_3),
        .Q(q_m_reg[3]));
  FDCE \q_m_reg_reg[4] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(q_m_4),
        .Q(q_m_reg[4]));
  FDCE \q_m_reg_reg[5] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(\q_m_reg[5]_i_1_n_0 ),
        .Q(q_m_reg[5]));
  FDCE \q_m_reg_reg[6] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(q_m_6),
        .Q(q_m_reg[6]));
  FDCE \q_m_reg_reg[7] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(q_m_7),
        .Q(q_m_reg[7]));
  FDCE \q_m_reg_reg[8] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(rst_n_0),
        .D(q_m),
        .Q(q_m_reg[8]));
endmodule

(* ORIG_REF_NAME = "encode" *) 
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_encode_0
   (\cnt_reg[2]_0 ,
    \cnt_reg[4]_0 ,
    Q,
    \data_out_reg[9]_0 ,
    de_reg2,
    c0_reg2,
    video_din,
    pclk,
    \data_out_reg[0]_0 ,
    D);
  output \cnt_reg[2]_0 ;
  output \cnt_reg[4]_0 ;
  output [0:0]Q;
  output [9:0]\data_out_reg[9]_0 ;
  input de_reg2;
  input c0_reg2;
  input [7:0]video_din;
  input pclk;
  input \data_out_reg[0]_0 ;
  input [1:0]D;

  wire [1:0]D;
  wire [0:0]Q;
  wire c0_reg2;
  wire [4:1]cnt;
  wire \cnt[1]_i_1__0_n_0 ;
  wire \cnt[1]_i_2__0_n_0 ;
  wire \cnt[1]_i_3__1_n_0 ;
  wire \cnt[2]_i_1__0_n_0 ;
  wire \cnt[2]_i_2__0_n_0 ;
  wire \cnt[2]_i_3__1_n_0 ;
  wire \cnt[2]_i_4__0_n_0 ;
  wire \cnt[3]_i_1__1_n_0 ;
  wire \cnt[3]_i_2__0_n_0 ;
  wire \cnt[3]_i_3__0_n_0 ;
  wire \cnt[3]_i_4__0_n_0 ;
  wire \cnt[3]_i_5__0_n_0 ;
  wire \cnt[3]_i_6__0_n_0 ;
  wire \cnt[3]_i_7__0_n_0 ;
  wire \cnt[4]_i_10__0_n_0 ;
  wire \cnt[4]_i_11__0_n_0 ;
  wire \cnt[4]_i_12__0_n_0 ;
  wire \cnt[4]_i_13__0_n_0 ;
  wire \cnt[4]_i_14__0_n_0 ;
  wire \cnt[4]_i_15__1_n_0 ;
  wire \cnt[4]_i_16__0_n_0 ;
  wire \cnt[4]_i_17__0_n_0 ;
  wire \cnt[4]_i_18__0_n_0 ;
  wire \cnt[4]_i_19__0_n_0 ;
  wire \cnt[4]_i_1__0_n_0 ;
  wire \cnt[4]_i_20__1_n_0 ;
  wire \cnt[4]_i_21__0_n_0 ;
  wire \cnt[4]_i_22__0_n_0 ;
  wire \cnt[4]_i_23__0_n_0 ;
  wire \cnt[4]_i_24__0_n_0 ;
  wire \cnt[4]_i_25_n_0 ;
  wire \cnt[4]_i_2__0_n_0 ;
  wire \cnt[4]_i_4__0_n_0 ;
  wire \cnt[4]_i_6__0_n_0 ;
  wire \cnt[4]_i_7__0_n_0 ;
  wire \cnt[4]_i_8__0_n_0 ;
  wire \cnt[4]_i_9__0_n_0 ;
  wire \cnt_reg[2]_0 ;
  wire \cnt_reg[4]_0 ;
  wire [3:0]data_in_n1;
  wire \data_in_n1[0]_i_1_n_0 ;
  wire \data_in_n1[0]_i_2_n_0 ;
  wire \data_in_n1[1]_i_1_n_0 ;
  wire \data_in_n1[1]_i_2_n_0 ;
  wire \data_in_n1[2]_i_1_n_0 ;
  wire \data_in_n1[2]_i_2_n_0 ;
  wire \data_in_n1[3]_i_1_n_0 ;
  wire \data_in_n1[3]_i_2_n_0 ;
  wire \data_in_n1[3]_i_3_n_0 ;
  wire \data_in_n1[3]_i_4_n_0 ;
  wire \data_in_reg_reg_n_0_[0] ;
  wire \data_out[0]_i_1__0_n_0 ;
  wire \data_out[1]_i_1__0_n_0 ;
  wire \data_out[2]_i_1__0_n_0 ;
  wire \data_out[3]_i_1__0_n_0 ;
  wire \data_out[4]_i_1__0_n_0 ;
  wire \data_out[5]_i_1__0_n_0 ;
  wire \data_out[6]_i_1__0_n_0 ;
  wire \data_out[7]_i_1__0_n_0 ;
  wire \data_out_reg[0]_0 ;
  wire [9:0]\data_out_reg[9]_0 ;
  wire de_reg2;
  wire p_0_in;
  wire p_0_in0_in;
  wire p_0_in1_in;
  wire p_0_in2_in;
  wire p_0_in3_in;
  wire p_0_in4_in;
  wire p_0_in5_in;
  wire pclk;
  wire [8:8]q_m;
  wire q_m_1;
  wire q_m_2;
  wire q_m_3;
  wire q_m_4;
  wire q_m_6;
  wire q_m_7;
  wire \q_m_n0[1]_i_1__0_n_0 ;
  wire \q_m_n0[2]_i_1__0_n_0 ;
  wire \q_m_n0[3]_i_1__0_n_0 ;
  wire \q_m_n0_reg_n_0_[1] ;
  wire \q_m_n0_reg_n_0_[2] ;
  wire \q_m_n0_reg_n_0_[3] ;
  wire \q_m_n1[1]_i_1__0_n_0 ;
  wire \q_m_n1[2]_i_1__0_n_0 ;
  wire \q_m_n1[3]_i_1__0_n_0 ;
  wire \q_m_n1[3]_i_2__0_n_0 ;
  wire \q_m_n1[3]_i_3__0_n_0 ;
  wire \q_m_n1[3]_i_4__0_n_0 ;
  wire \q_m_n1[3]_i_5__0_n_0 ;
  wire \q_m_n1[3]_i_6__0_n_0 ;
  wire \q_m_n1[3]_i_7__0_n_0 ;
  wire \q_m_n1_reg_n_0_[1] ;
  wire \q_m_n1_reg_n_0_[2] ;
  wire \q_m_n1_reg_n_0_[3] ;
  wire \q_m_reg[5]_i_1__0_n_0 ;
  wire \q_m_reg[7]_i_2__0_n_0 ;
  wire \q_m_reg[7]_i_3__0_n_0 ;
  wire \q_m_reg_reg_n_0_[0] ;
  wire \q_m_reg_reg_n_0_[1] ;
  wire \q_m_reg_reg_n_0_[2] ;
  wire \q_m_reg_reg_n_0_[3] ;
  wire \q_m_reg_reg_n_0_[4] ;
  wire \q_m_reg_reg_n_0_[5] ;
  wire \q_m_reg_reg_n_0_[6] ;
  wire \q_m_reg_reg_n_0_[7] ;
  wire [7:0]video_din;

  LUT6 #(
    .INIT(64'hAA2800280028AA28)) 
    \cnt[1]_i_1__0 
       (.I0(de_reg2),
        .I1(\cnt[1]_i_2__0_n_0 ),
        .I2(cnt[1]),
        .I3(\cnt_reg[2]_0 ),
        .I4(\cnt[1]_i_3__1_n_0 ),
        .I5(\cnt_reg[4]_0 ),
        .O(\cnt[1]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \cnt[1]_i_2__0 
       (.I0(\q_m_n1_reg_n_0_[1] ),
        .I1(\q_m_n0_reg_n_0_[1] ),
        .O(\cnt[1]_i_2__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT4 #(
    .INIT(16'h9669)) 
    \cnt[1]_i_3__1 
       (.I0(cnt[1]),
        .I1(\q_m_n0_reg_n_0_[1] ),
        .I2(Q),
        .I3(\q_m_n1_reg_n_0_[1] ),
        .O(\cnt[1]_i_3__1_n_0 ));
  LUT6 #(
    .INIT(64'h020202A2A2A202A2)) 
    \cnt[2]_i_1__0 
       (.I0(de_reg2),
        .I1(\cnt[2]_i_2__0_n_0 ),
        .I2(\cnt_reg[2]_0 ),
        .I3(\cnt[2]_i_3__1_n_0 ),
        .I4(\cnt_reg[4]_0 ),
        .I5(\cnt[2]_i_4__0_n_0 ),
        .O(\cnt[2]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT5 #(
    .INIT(32'h55966955)) 
    \cnt[2]_i_2__0 
       (.I0(\cnt[4]_i_11__0_n_0 ),
        .I1(cnt[1]),
        .I2(Q),
        .I3(\q_m_n0_reg_n_0_[1] ),
        .I4(\q_m_n1_reg_n_0_[1] ),
        .O(\cnt[2]_i_2__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair17" *) 
  LUT5 #(
    .INIT(32'h8E1871E7)) 
    \cnt[2]_i_3__1 
       (.I0(cnt[1]),
        .I1(\q_m_n0_reg_n_0_[1] ),
        .I2(\q_m_n1_reg_n_0_[1] ),
        .I3(Q),
        .I4(\cnt[4]_i_11__0_n_0 ),
        .O(\cnt[2]_i_3__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT5 #(
    .INIT(32'h2D4B4BD2)) 
    \cnt[2]_i_4__0 
       (.I0(Q),
        .I1(\q_m_n0_reg_n_0_[1] ),
        .I2(\cnt[4]_i_11__0_n_0 ),
        .I3(\q_m_n1_reg_n_0_[1] ),
        .I4(cnt[1]),
        .O(\cnt[2]_i_4__0_n_0 ));
  LUT6 #(
    .INIT(64'hEEE222E200000000)) 
    \cnt[3]_i_1__1 
       (.I0(\cnt[3]_i_2__0_n_0 ),
        .I1(\cnt_reg[2]_0 ),
        .I2(\cnt[3]_i_3__0_n_0 ),
        .I3(\cnt_reg[4]_0 ),
        .I4(\cnt[3]_i_4__0_n_0 ),
        .I5(de_reg2),
        .O(\cnt[3]_i_1__1_n_0 ));
  LUT6 #(
    .INIT(64'h8E8A717571758E8A)) 
    \cnt[3]_i_2__0 
       (.I0(\cnt[4]_i_11__0_n_0 ),
        .I1(\cnt[3]_i_5__0_n_0 ),
        .I2(cnt[1]),
        .I3(\cnt[1]_i_2__0_n_0 ),
        .I4(\cnt[4]_i_12__0_n_0 ),
        .I5(\cnt[4]_i_8__0_n_0 ),
        .O(\cnt[3]_i_2__0_n_0 ));
  LUT6 #(
    .INIT(64'h9C3CCC9C3C399C3C)) 
    \cnt[3]_i_3__0 
       (.I0(cnt[1]),
        .I1(\cnt[3]_i_6__0_n_0 ),
        .I2(\cnt[4]_i_11__0_n_0 ),
        .I3(Q),
        .I4(\q_m_n1_reg_n_0_[1] ),
        .I5(\q_m_n0_reg_n_0_[1] ),
        .O(\cnt[3]_i_3__0_n_0 ));
  LUT6 #(
    .INIT(64'hD5542AAB2AABD554)) 
    \cnt[3]_i_4__0 
       (.I0(\cnt[4]_i_24__0_n_0 ),
        .I1(\q_m_n1_reg_n_0_[1] ),
        .I2(\cnt[3]_i_7__0_n_0 ),
        .I3(cnt[1]),
        .I4(\cnt[4]_i_20__1_n_0 ),
        .I5(\cnt[4]_i_21__0_n_0 ),
        .O(\cnt[3]_i_4__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair31" *) 
  LUT3 #(
    .INIT(8'hDB)) 
    \cnt[3]_i_5__0 
       (.I0(\q_m_n1_reg_n_0_[1] ),
        .I1(\q_m_n0_reg_n_0_[1] ),
        .I2(Q),
        .O(\cnt[3]_i_5__0_n_0 ));
  LUT6 #(
    .INIT(64'h6969966996699696)) 
    \cnt[3]_i_6__0 
       (.I0(\q_m_n1_reg_n_0_[3] ),
        .I1(\q_m_n0_reg_n_0_[3] ),
        .I2(cnt[3]),
        .I3(\q_m_n1_reg_n_0_[2] ),
        .I4(\q_m_n0_reg_n_0_[2] ),
        .I5(cnt[2]),
        .O(\cnt[3]_i_6__0_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \cnt[3]_i_7__0 
       (.I0(\q_m_n0_reg_n_0_[1] ),
        .I1(Q),
        .O(\cnt[3]_i_7__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT4 #(
    .INIT(16'h0820)) 
    \cnt[4]_i_10__0 
       (.I0(cnt[1]),
        .I1(Q),
        .I2(\q_m_n0_reg_n_0_[1] ),
        .I3(\q_m_n1_reg_n_0_[1] ),
        .O(\cnt[4]_i_10__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT3 #(
    .INIT(8'h96)) 
    \cnt[4]_i_11__0 
       (.I0(cnt[2]),
        .I1(\q_m_n0_reg_n_0_[2] ),
        .I2(\q_m_n1_reg_n_0_[2] ),
        .O(\cnt[4]_i_11__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair28" *) 
  LUT4 #(
    .INIT(16'hB28E)) 
    \cnt[4]_i_12__0 
       (.I0(cnt[2]),
        .I1(\q_m_n0_reg_n_0_[2] ),
        .I2(\q_m_n1_reg_n_0_[2] ),
        .I3(Q),
        .O(\cnt[4]_i_12__0_n_0 ));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    \cnt[4]_i_13__0 
       (.I0(\q_m_n0_reg_n_0_[1] ),
        .I1(\q_m_n1_reg_n_0_[1] ),
        .I2(\q_m_n1_reg_n_0_[2] ),
        .I3(\q_m_n0_reg_n_0_[2] ),
        .I4(\q_m_n1_reg_n_0_[3] ),
        .I5(\q_m_n0_reg_n_0_[3] ),
        .O(\cnt[4]_i_13__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT4 #(
    .INIT(16'hA665)) 
    \cnt[4]_i_14__0 
       (.I0(cnt[4]),
        .I1(\q_m_n1_reg_n_0_[3] ),
        .I2(\q_m_n0_reg_n_0_[3] ),
        .I3(cnt[3]),
        .O(\cnt[4]_i_14__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair20" *) 
  LUT4 #(
    .INIT(16'hBEEB)) 
    \cnt[4]_i_15__1 
       (.I0(cnt[1]),
        .I1(\q_m_n0_reg_n_0_[1] ),
        .I2(Q),
        .I3(\q_m_n1_reg_n_0_[1] ),
        .O(\cnt[4]_i_15__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT3 #(
    .INIT(8'hB2)) 
    \cnt[4]_i_16__0 
       (.I0(\q_m_n0_reg_n_0_[1] ),
        .I1(\q_m_n1_reg_n_0_[1] ),
        .I2(Q),
        .O(\cnt[4]_i_16__0_n_0 ));
  LUT3 #(
    .INIT(8'h8E)) 
    \cnt[4]_i_17__0 
       (.I0(cnt[2]),
        .I1(\q_m_n0_reg_n_0_[2] ),
        .I2(\q_m_n1_reg_n_0_[2] ),
        .O(\cnt[4]_i_17__0_n_0 ));
  LUT6 #(
    .INIT(64'hD4DD0000FFFFD4DD)) 
    \cnt[4]_i_18__0 
       (.I0(\q_m_n1_reg_n_0_[2] ),
        .I1(\q_m_n0_reg_n_0_[2] ),
        .I2(\q_m_n0_reg_n_0_[1] ),
        .I3(\q_m_n1_reg_n_0_[1] ),
        .I4(\q_m_n0_reg_n_0_[3] ),
        .I5(\q_m_n1_reg_n_0_[3] ),
        .O(\cnt[4]_i_18__0_n_0 ));
  LUT6 #(
    .INIT(64'hB2BB0000FFFFB2BB)) 
    \cnt[4]_i_19__0 
       (.I0(\q_m_n1_reg_n_0_[2] ),
        .I1(\q_m_n0_reg_n_0_[2] ),
        .I2(\q_m_n1_reg_n_0_[1] ),
        .I3(\q_m_n0_reg_n_0_[1] ),
        .I4(\q_m_n1_reg_n_0_[3] ),
        .I5(\q_m_n0_reg_n_0_[3] ),
        .O(\cnt[4]_i_19__0_n_0 ));
  LUT6 #(
    .INIT(64'h020202A2A2A202A2)) 
    \cnt[4]_i_1__0 
       (.I0(de_reg2),
        .I1(\cnt[4]_i_2__0_n_0 ),
        .I2(\cnt_reg[2]_0 ),
        .I3(\cnt[4]_i_4__0_n_0 ),
        .I4(\cnt_reg[4]_0 ),
        .I5(\cnt[4]_i_6__0_n_0 ),
        .O(\cnt[4]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT5 #(
    .INIT(32'h4BB4B44B)) 
    \cnt[4]_i_20__1 
       (.I0(\q_m_n1_reg_n_0_[2] ),
        .I1(\q_m_n0_reg_n_0_[2] ),
        .I2(\q_m_n1_reg_n_0_[3] ),
        .I3(\q_m_n0_reg_n_0_[3] ),
        .I4(cnt[3]),
        .O(\cnt[4]_i_20__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT5 #(
    .INIT(32'hDFFD0DD0)) 
    \cnt[4]_i_21__0 
       (.I0(\q_m_n0_reg_n_0_[1] ),
        .I1(Q),
        .I2(\q_m_n1_reg_n_0_[2] ),
        .I3(\q_m_n0_reg_n_0_[2] ),
        .I4(cnt[2]),
        .O(\cnt[4]_i_21__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair29" *) 
  LUT4 #(
    .INIT(16'h0009)) 
    \cnt[4]_i_22__0 
       (.I0(Q),
        .I1(\q_m_n0_reg_n_0_[1] ),
        .I2(cnt[1]),
        .I3(\q_m_n1_reg_n_0_[1] ),
        .O(\cnt[4]_i_22__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair30" *) 
  LUT4 #(
    .INIT(16'h2800)) 
    \cnt[4]_i_23__0 
       (.I0(cnt[1]),
        .I1(\q_m_n0_reg_n_0_[1] ),
        .I2(Q),
        .I3(\q_m_n1_reg_n_0_[1] ),
        .O(\cnt[4]_i_23__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair19" *) 
  LUT5 #(
    .INIT(32'hB44B4BB4)) 
    \cnt[4]_i_24__0 
       (.I0(Q),
        .I1(\q_m_n0_reg_n_0_[1] ),
        .I2(\q_m_n1_reg_n_0_[2] ),
        .I3(\q_m_n0_reg_n_0_[2] ),
        .I4(cnt[2]),
        .O(\cnt[4]_i_24__0_n_0 ));
  LUT6 #(
    .INIT(64'h9A55AA9A55659A55)) 
    \cnt[4]_i_25 
       (.I0(cnt[4]),
        .I1(\q_m_n1_reg_n_0_[2] ),
        .I2(\q_m_n0_reg_n_0_[2] ),
        .I3(\q_m_n1_reg_n_0_[3] ),
        .I4(\q_m_n0_reg_n_0_[3] ),
        .I5(cnt[3]),
        .O(\cnt[4]_i_25_n_0 ));
  LUT6 #(
    .INIT(64'h599959599AAA9A9A)) 
    \cnt[4]_i_2__0 
       (.I0(\cnt[4]_i_7__0_n_0 ),
        .I1(\cnt[4]_i_8__0_n_0 ),
        .I2(\cnt[4]_i_9__0_n_0 ),
        .I3(\cnt[4]_i_10__0_n_0 ),
        .I4(\cnt[4]_i_11__0_n_0 ),
        .I5(\cnt[4]_i_12__0_n_0 ),
        .O(\cnt[4]_i_2__0_n_0 ));
  LUT5 #(
    .INIT(32'h55555554)) 
    \cnt[4]_i_3__0 
       (.I0(\cnt[4]_i_13__0_n_0 ),
        .I1(cnt[2]),
        .I2(cnt[4]),
        .I3(cnt[1]),
        .I4(cnt[3]),
        .O(\cnt_reg[2]_0 ));
  LUT6 #(
    .INIT(64'h95A9AAAA555595A9)) 
    \cnt[4]_i_4__0 
       (.I0(\cnt[4]_i_14__0_n_0 ),
        .I1(\cnt[4]_i_15__1_n_0 ),
        .I2(\cnt[4]_i_16__0_n_0 ),
        .I3(\cnt[4]_i_11__0_n_0 ),
        .I4(\cnt[4]_i_8__0_n_0 ),
        .I5(\cnt[4]_i_17__0_n_0 ),
        .O(\cnt[4]_i_4__0_n_0 ));
  LUT6 #(
    .INIT(64'h8E888E8E71777171)) 
    \cnt[4]_i_6__0 
       (.I0(\cnt[4]_i_20__1_n_0 ),
        .I1(\cnt[4]_i_21__0_n_0 ),
        .I2(\cnt[4]_i_22__0_n_0 ),
        .I3(\cnt[4]_i_23__0_n_0 ),
        .I4(\cnt[4]_i_24__0_n_0 ),
        .I5(\cnt[4]_i_25_n_0 ),
        .O(\cnt[4]_i_6__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair21" *) 
  LUT5 #(
    .INIT(32'h5965A96A)) 
    \cnt[4]_i_7__0 
       (.I0(cnt[4]),
        .I1(Q),
        .I2(\q_m_n1_reg_n_0_[3] ),
        .I3(\q_m_n0_reg_n_0_[3] ),
        .I4(cnt[3]),
        .O(\cnt[4]_i_7__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair18" *) 
  LUT3 #(
    .INIT(8'h96)) 
    \cnt[4]_i_8__0 
       (.I0(cnt[3]),
        .I1(\q_m_n0_reg_n_0_[3] ),
        .I2(\q_m_n1_reg_n_0_[3] ),
        .O(\cnt[4]_i_8__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair27" *) 
  LUT4 #(
    .INIT(16'hFEBF)) 
    \cnt[4]_i_9__0 
       (.I0(cnt[1]),
        .I1(Q),
        .I2(\q_m_n0_reg_n_0_[1] ),
        .I3(\q_m_n1_reg_n_0_[1] ),
        .O(\cnt[4]_i_9__0_n_0 ));
  FDCE \cnt_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[0]_0 ),
        .D(\cnt[1]_i_1__0_n_0 ),
        .Q(cnt[1]));
  FDCE \cnt_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[0]_0 ),
        .D(\cnt[2]_i_1__0_n_0 ),
        .Q(cnt[2]));
  FDCE \cnt_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[0]_0 ),
        .D(\cnt[3]_i_1__1_n_0 ),
        .Q(cnt[3]));
  FDCE \cnt_reg[4] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[0]_0 ),
        .D(\cnt[4]_i_1__0_n_0 ),
        .Q(cnt[4]));
  MUXF7 \cnt_reg[4]_i_5 
       (.I0(\cnt[4]_i_18__0_n_0 ),
        .I1(\cnt[4]_i_19__0_n_0 ),
        .O(\cnt_reg[4]_0 ),
        .S(cnt[4]));
  LUT6 #(
    .INIT(64'h6996966996696996)) 
    \data_in_n1[0]_i_1 
       (.I0(video_din[0]),
        .I1(video_din[7]),
        .I2(\data_in_n1[0]_i_2_n_0 ),
        .I3(video_din[2]),
        .I4(video_din[1]),
        .I5(video_din[3]),
        .O(\data_in_n1[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT3 #(
    .INIT(8'h96)) 
    \data_in_n1[0]_i_2 
       (.I0(video_din[6]),
        .I1(video_din[4]),
        .I2(video_din[5]),
        .O(\data_in_n1[0]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'h96)) 
    \data_in_n1[1]_i_1 
       (.I0(\data_in_n1[3]_i_2_n_0 ),
        .I1(\data_in_n1[1]_i_2_n_0 ),
        .I2(\data_in_n1[3]_i_3_n_0 ),
        .O(\data_in_n1[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h171717E817E8E8E8)) 
    \data_in_n1[1]_i_2 
       (.I0(video_din[3]),
        .I1(video_din[2]),
        .I2(video_din[1]),
        .I3(video_din[6]),
        .I4(video_din[5]),
        .I5(video_din[4]),
        .O(\data_in_n1[1]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h7E7E7EE87EE8E8E8)) 
    \data_in_n1[2]_i_1 
       (.I0(\data_in_n1[3]_i_2_n_0 ),
        .I1(\data_in_n1[3]_i_3_n_0 ),
        .I2(\data_in_n1[2]_i_2_n_0 ),
        .I3(video_din[4]),
        .I4(video_din[5]),
        .I5(video_din[6]),
        .O(\data_in_n1[2]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hE8)) 
    \data_in_n1[2]_i_2 
       (.I0(video_din[1]),
        .I1(video_din[2]),
        .I2(video_din[3]),
        .O(\data_in_n1[2]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h8880800000000000)) 
    \data_in_n1[3]_i_1 
       (.I0(\data_in_n1[3]_i_2_n_0 ),
        .I1(\data_in_n1[3]_i_3_n_0 ),
        .I2(video_din[3]),
        .I3(video_din[2]),
        .I4(video_din[1]),
        .I5(\data_in_n1[3]_i_4_n_0 ),
        .O(\data_in_n1[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h9600009600969600)) 
    \data_in_n1[3]_i_2 
       (.I0(video_din[2]),
        .I1(video_din[1]),
        .I2(video_din[3]),
        .I3(video_din[0]),
        .I4(video_din[7]),
        .I5(\data_in_n1[0]_i_2_n_0 ),
        .O(\data_in_n1[3]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair22" *) 
  LUT5 #(
    .INIT(32'hE88E8EE8)) 
    \data_in_n1[3]_i_3 
       (.I0(video_din[7]),
        .I1(video_din[0]),
        .I2(video_din[5]),
        .I3(video_din[4]),
        .I4(video_din[6]),
        .O(\data_in_n1[3]_i_3_n_0 ));
  LUT3 #(
    .INIT(8'hE8)) 
    \data_in_n1[3]_i_4 
       (.I0(video_din[4]),
        .I1(video_din[5]),
        .I2(video_din[6]),
        .O(\data_in_n1[3]_i_4_n_0 ));
  FDCE \data_in_n1_reg[0] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[0]_0 ),
        .D(\data_in_n1[0]_i_1_n_0 ),
        .Q(data_in_n1[0]));
  FDCE \data_in_n1_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[0]_0 ),
        .D(\data_in_n1[1]_i_1_n_0 ),
        .Q(data_in_n1[1]));
  FDCE \data_in_n1_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[0]_0 ),
        .D(\data_in_n1[2]_i_1_n_0 ),
        .Q(data_in_n1[2]));
  FDCE \data_in_n1_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[0]_0 ),
        .D(\data_in_n1[3]_i_1_n_0 ),
        .Q(data_in_n1[3]));
  FDCE \data_in_reg_reg[0] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[0]_0 ),
        .D(video_din[0]),
        .Q(\data_in_reg_reg_n_0_[0] ));
  FDCE \data_in_reg_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[0]_0 ),
        .D(video_din[1]),
        .Q(p_0_in5_in));
  FDCE \data_in_reg_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[0]_0 ),
        .D(video_din[2]),
        .Q(p_0_in4_in));
  FDCE \data_in_reg_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[0]_0 ),
        .D(video_din[3]),
        .Q(p_0_in3_in));
  FDCE \data_in_reg_reg[4] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[0]_0 ),
        .D(video_din[4]),
        .Q(p_0_in2_in));
  FDCE \data_in_reg_reg[5] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[0]_0 ),
        .D(video_din[5]),
        .Q(p_0_in1_in));
  FDCE \data_in_reg_reg[6] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[0]_0 ),
        .D(video_din[6]),
        .Q(p_0_in0_in));
  FDCE \data_in_reg_reg[7] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[0]_0 ),
        .D(video_din[7]),
        .Q(p_0_in));
  LUT6 #(
    .INIT(64'hA959FFFFA9590000)) 
    \data_out[0]_i_1__0 
       (.I0(\q_m_reg_reg_n_0_[0] ),
        .I1(Q),
        .I2(\cnt_reg[2]_0 ),
        .I3(\cnt_reg[4]_0 ),
        .I4(de_reg2),
        .I5(c0_reg2),
        .O(\data_out[0]_i_1__0_n_0 ));
  LUT6 #(
    .INIT(64'hA959FFFFA9590000)) 
    \data_out[1]_i_1__0 
       (.I0(\q_m_reg_reg_n_0_[1] ),
        .I1(Q),
        .I2(\cnt_reg[2]_0 ),
        .I3(\cnt_reg[4]_0 ),
        .I4(de_reg2),
        .I5(c0_reg2),
        .O(\data_out[1]_i_1__0_n_0 ));
  LUT6 #(
    .INIT(64'hE200E2FF1D001DFF)) 
    \data_out[2]_i_1__0 
       (.I0(Q),
        .I1(\cnt_reg[2]_0 ),
        .I2(\cnt_reg[4]_0 ),
        .I3(de_reg2),
        .I4(c0_reg2),
        .I5(\q_m_reg_reg_n_0_[2] ),
        .O(\data_out[2]_i_1__0_n_0 ));
  LUT6 #(
    .INIT(64'hA959FFFFA9590000)) 
    \data_out[3]_i_1__0 
       (.I0(\q_m_reg_reg_n_0_[3] ),
        .I1(Q),
        .I2(\cnt_reg[2]_0 ),
        .I3(\cnt_reg[4]_0 ),
        .I4(de_reg2),
        .I5(c0_reg2),
        .O(\data_out[3]_i_1__0_n_0 ));
  LUT6 #(
    .INIT(64'hE200E2FF1D001DFF)) 
    \data_out[4]_i_1__0 
       (.I0(Q),
        .I1(\cnt_reg[2]_0 ),
        .I2(\cnt_reg[4]_0 ),
        .I3(de_reg2),
        .I4(c0_reg2),
        .I5(\q_m_reg_reg_n_0_[4] ),
        .O(\data_out[4]_i_1__0_n_0 ));
  LUT6 #(
    .INIT(64'hA959FFFFA9590000)) 
    \data_out[5]_i_1__0 
       (.I0(\q_m_reg_reg_n_0_[5] ),
        .I1(Q),
        .I2(\cnt_reg[2]_0 ),
        .I3(\cnt_reg[4]_0 ),
        .I4(de_reg2),
        .I5(c0_reg2),
        .O(\data_out[5]_i_1__0_n_0 ));
  LUT6 #(
    .INIT(64'hE200E2FF1D001DFF)) 
    \data_out[6]_i_1__0 
       (.I0(Q),
        .I1(\cnt_reg[2]_0 ),
        .I2(\cnt_reg[4]_0 ),
        .I3(de_reg2),
        .I4(c0_reg2),
        .I5(\q_m_reg_reg_n_0_[6] ),
        .O(\data_out[6]_i_1__0_n_0 ));
  LUT6 #(
    .INIT(64'hA959FFFFA9590000)) 
    \data_out[7]_i_1__0 
       (.I0(\q_m_reg_reg_n_0_[7] ),
        .I1(Q),
        .I2(\cnt_reg[2]_0 ),
        .I3(\cnt_reg[4]_0 ),
        .I4(de_reg2),
        .I5(c0_reg2),
        .O(\data_out[7]_i_1__0_n_0 ));
  FDCE \data_out_reg[0] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[0]_0 ),
        .D(\data_out[0]_i_1__0_n_0 ),
        .Q(\data_out_reg[9]_0 [0]));
  FDCE \data_out_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[0]_0 ),
        .D(\data_out[1]_i_1__0_n_0 ),
        .Q(\data_out_reg[9]_0 [1]));
  FDCE \data_out_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[0]_0 ),
        .D(\data_out[2]_i_1__0_n_0 ),
        .Q(\data_out_reg[9]_0 [2]));
  FDCE \data_out_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[0]_0 ),
        .D(\data_out[3]_i_1__0_n_0 ),
        .Q(\data_out_reg[9]_0 [3]));
  FDCE \data_out_reg[4] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[0]_0 ),
        .D(\data_out[4]_i_1__0_n_0 ),
        .Q(\data_out_reg[9]_0 [4]));
  FDCE \data_out_reg[5] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[0]_0 ),
        .D(\data_out[5]_i_1__0_n_0 ),
        .Q(\data_out_reg[9]_0 [5]));
  FDCE \data_out_reg[6] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[0]_0 ),
        .D(\data_out[6]_i_1__0_n_0 ),
        .Q(\data_out_reg[9]_0 [6]));
  FDCE \data_out_reg[7] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[0]_0 ),
        .D(\data_out[7]_i_1__0_n_0 ),
        .Q(\data_out_reg[9]_0 [7]));
  FDCE \data_out_reg[8] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[0]_0 ),
        .D(D[0]),
        .Q(\data_out_reg[9]_0 [8]));
  FDCE \data_out_reg[9] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[0]_0 ),
        .D(D[1]),
        .Q(\data_out_reg[9]_0 [9]));
  LUT6 #(
    .INIT(64'h9996699996669996)) 
    \q_m_n0[1]_i_1__0 
       (.I0(\q_m_n1[3]_i_3__0_n_0 ),
        .I1(\q_m_n1[3]_i_2__0_n_0 ),
        .I2(\q_m_n1[3]_i_5__0_n_0 ),
        .I3(\q_m_n1[3]_i_4__0_n_0 ),
        .I4(\data_in_reg_reg_n_0_[0] ),
        .I5(\q_m_n1[3]_i_6__0_n_0 ),
        .O(\q_m_n0[1]_i_1__0_n_0 ));
  LUT6 #(
    .INIT(64'h2000FBB2FBB2DFFF)) 
    \q_m_n0[2]_i_1__0 
       (.I0(\q_m_n1[3]_i_6__0_n_0 ),
        .I1(\data_in_reg_reg_n_0_[0] ),
        .I2(\q_m_n1[3]_i_4__0_n_0 ),
        .I3(\q_m_n1[3]_i_5__0_n_0 ),
        .I4(\q_m_n1[3]_i_2__0_n_0 ),
        .I5(\q_m_n1[3]_i_3__0_n_0 ),
        .O(\q_m_n0[2]_i_1__0_n_0 ));
  LUT6 #(
    .INIT(64'h0100000000000000)) 
    \q_m_n0[3]_i_1__0 
       (.I0(\q_m_n1[3]_i_2__0_n_0 ),
        .I1(\q_m_n1[3]_i_3__0_n_0 ),
        .I2(\data_in_reg_reg_n_0_[0] ),
        .I3(\q_m_n1[3]_i_4__0_n_0 ),
        .I4(\q_m_n1[3]_i_5__0_n_0 ),
        .I5(\q_m_n1[3]_i_6__0_n_0 ),
        .O(\q_m_n0[3]_i_1__0_n_0 ));
  FDCE \q_m_n0_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[0]_0 ),
        .D(\q_m_n0[1]_i_1__0_n_0 ),
        .Q(\q_m_n0_reg_n_0_[1] ));
  FDCE \q_m_n0_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[0]_0 ),
        .D(\q_m_n0[2]_i_1__0_n_0 ),
        .Q(\q_m_n0_reg_n_0_[2] ));
  FDCE \q_m_n0_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[0]_0 ),
        .D(\q_m_n0[3]_i_1__0_n_0 ),
        .Q(\q_m_n0_reg_n_0_[3] ));
  LUT6 #(
    .INIT(64'h6696969996999969)) 
    \q_m_n1[1]_i_1__0 
       (.I0(\q_m_n1[3]_i_2__0_n_0 ),
        .I1(\q_m_n1[3]_i_3__0_n_0 ),
        .I2(\data_in_reg_reg_n_0_[0] ),
        .I3(\q_m_n1[3]_i_4__0_n_0 ),
        .I4(\q_m_n1[3]_i_5__0_n_0 ),
        .I5(\q_m_n1[3]_i_6__0_n_0 ),
        .O(\q_m_n1[1]_i_1__0_n_0 ));
  LUT6 #(
    .INIT(64'hFFEF71F771F70010)) 
    \q_m_n1[2]_i_1__0 
       (.I0(\q_m_n1[3]_i_5__0_n_0 ),
        .I1(\q_m_n1[3]_i_4__0_n_0 ),
        .I2(\data_in_reg_reg_n_0_[0] ),
        .I3(\q_m_n1[3]_i_6__0_n_0 ),
        .I4(\q_m_n1[3]_i_3__0_n_0 ),
        .I5(\q_m_n1[3]_i_2__0_n_0 ),
        .O(\q_m_n1[2]_i_1__0_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000080)) 
    \q_m_n1[3]_i_1__0 
       (.I0(\q_m_n1[3]_i_2__0_n_0 ),
        .I1(\q_m_n1[3]_i_3__0_n_0 ),
        .I2(\data_in_reg_reg_n_0_[0] ),
        .I3(\q_m_n1[3]_i_4__0_n_0 ),
        .I4(\q_m_n1[3]_i_5__0_n_0 ),
        .I5(\q_m_n1[3]_i_6__0_n_0 ),
        .O(\q_m_n1[3]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT5 #(
    .INIT(32'hB42D4BD2)) 
    \q_m_n1[3]_i_2__0 
       (.I0(\q_m_reg[7]_i_2__0_n_0 ),
        .I1(p_0_in3_in),
        .I2(\data_in_reg_reg_n_0_[0] ),
        .I3(p_0_in4_in),
        .I4(p_0_in5_in),
        .O(\q_m_n1[3]_i_2__0_n_0 ));
  LUT6 #(
    .INIT(64'hE11E1EE178878778)) 
    \q_m_n1[3]_i_3__0 
       (.I0(p_0_in0_in),
        .I1(\q_m_reg[7]_i_2__0_n_0 ),
        .I2(q_m_2),
        .I3(p_0_in2_in),
        .I4(p_0_in3_in),
        .I5(p_0_in1_in),
        .O(\q_m_n1[3]_i_3__0_n_0 ));
  LUT6 #(
    .INIT(64'h9669699669969669)) 
    \q_m_n1[3]_i_4__0 
       (.I0(p_0_in3_in),
        .I1(p_0_in2_in),
        .I2(\data_in_reg_reg_n_0_[0] ),
        .I3(p_0_in4_in),
        .I4(p_0_in5_in),
        .I5(\q_m_n1[3]_i_7__0_n_0 ),
        .O(\q_m_n1[3]_i_4__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT5 #(
    .INIT(32'h96696996)) 
    \q_m_n1[3]_i_5__0 
       (.I0(p_0_in0_in),
        .I1(\q_m_reg[7]_i_3__0_n_0 ),
        .I2(p_0_in1_in),
        .I3(\q_m_reg[7]_i_2__0_n_0 ),
        .I4(p_0_in),
        .O(\q_m_n1[3]_i_5__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT3 #(
    .INIT(8'h69)) 
    \q_m_n1[3]_i_6__0 
       (.I0(\data_in_reg_reg_n_0_[0] ),
        .I1(p_0_in5_in),
        .I2(p_0_in3_in),
        .O(\q_m_n1[3]_i_6__0_n_0 ));
  LUT6 #(
    .INIT(64'h5555555566666A66)) 
    \q_m_n1[3]_i_7__0 
       (.I0(p_0_in0_in),
        .I1(data_in_n1[2]),
        .I2(data_in_n1[0]),
        .I3(\data_in_reg_reg_n_0_[0] ),
        .I4(data_in_n1[1]),
        .I5(data_in_n1[3]),
        .O(\q_m_n1[3]_i_7__0_n_0 ));
  FDCE \q_m_n1_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[0]_0 ),
        .D(\q_m_n1[1]_i_1__0_n_0 ),
        .Q(\q_m_n1_reg_n_0_[1] ));
  FDCE \q_m_n1_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[0]_0 ),
        .D(\q_m_n1[2]_i_1__0_n_0 ),
        .Q(\q_m_n1_reg_n_0_[2] ));
  FDCE \q_m_n1_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[0]_0 ),
        .D(\q_m_n1[3]_i_1__0_n_0 ),
        .Q(\q_m_n1_reg_n_0_[3] ));
  LUT6 #(
    .INIT(64'hFFA800570055FFAA)) 
    \q_m_reg[1]_i_1__0 
       (.I0(data_in_n1[2]),
        .I1(data_in_n1[0]),
        .I2(data_in_n1[1]),
        .I3(data_in_n1[3]),
        .I4(p_0_in5_in),
        .I5(\data_in_reg_reg_n_0_[0] ),
        .O(q_m_1));
  (* SOFT_HLUTNM = "soft_lutpair32" *) 
  LUT3 #(
    .INIT(8'h96)) 
    \q_m_reg[2]_i_1__0 
       (.I0(\data_in_reg_reg_n_0_[0] ),
        .I1(p_0_in4_in),
        .I2(p_0_in5_in),
        .O(q_m_2));
  (* SOFT_HLUTNM = "soft_lutpair23" *) 
  LUT5 #(
    .INIT(32'h96696996)) 
    \q_m_reg[3]_i_1__0 
       (.I0(p_0_in5_in),
        .I1(p_0_in4_in),
        .I2(\data_in_reg_reg_n_0_[0] ),
        .I3(p_0_in3_in),
        .I4(\q_m_reg[7]_i_2__0_n_0 ),
        .O(q_m_3));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT5 #(
    .INIT(32'h96696996)) 
    \q_m_reg[4]_i_1__0 
       (.I0(p_0_in3_in),
        .I1(p_0_in2_in),
        .I2(\data_in_reg_reg_n_0_[0] ),
        .I3(p_0_in4_in),
        .I4(p_0_in5_in),
        .O(q_m_4));
  LUT5 #(
    .INIT(32'h96696996)) 
    \q_m_reg[5]_i_1__0 
       (.I0(\q_m_reg[7]_i_2__0_n_0 ),
        .I1(q_m_2),
        .I2(p_0_in2_in),
        .I3(p_0_in3_in),
        .I4(p_0_in1_in),
        .O(\q_m_reg[5]_i_1__0_n_0 ));
  LUT5 #(
    .INIT(32'h96696996)) 
    \q_m_reg[6]_i_1__0 
       (.I0(p_0_in1_in),
        .I1(p_0_in3_in),
        .I2(p_0_in2_in),
        .I3(q_m_2),
        .I4(p_0_in0_in),
        .O(q_m_6));
  (* SOFT_HLUTNM = "soft_lutpair24" *) 
  LUT5 #(
    .INIT(32'h69969669)) 
    \q_m_reg[7]_i_1__0 
       (.I0(p_0_in),
        .I1(\q_m_reg[7]_i_2__0_n_0 ),
        .I2(p_0_in1_in),
        .I3(\q_m_reg[7]_i_3__0_n_0 ),
        .I4(p_0_in0_in),
        .O(q_m_7));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT5 #(
    .INIT(32'hFFEFAAAA)) 
    \q_m_reg[7]_i_2__0 
       (.I0(data_in_n1[3]),
        .I1(data_in_n1[1]),
        .I2(\data_in_reg_reg_n_0_[0] ),
        .I3(data_in_n1[0]),
        .I4(data_in_n1[2]),
        .O(\q_m_reg[7]_i_2__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair26" *) 
  LUT5 #(
    .INIT(32'h69969669)) 
    \q_m_reg[7]_i_3__0 
       (.I0(p_0_in5_in),
        .I1(p_0_in4_in),
        .I2(\data_in_reg_reg_n_0_[0] ),
        .I3(p_0_in2_in),
        .I4(p_0_in3_in),
        .O(\q_m_reg[7]_i_3__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair25" *) 
  LUT5 #(
    .INIT(32'h00005575)) 
    \q_m_reg[8]_i_1__0 
       (.I0(data_in_n1[2]),
        .I1(data_in_n1[0]),
        .I2(\data_in_reg_reg_n_0_[0] ),
        .I3(data_in_n1[1]),
        .I4(data_in_n1[3]),
        .O(q_m));
  FDCE \q_m_reg_reg[0] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[0]_0 ),
        .D(\data_in_reg_reg_n_0_[0] ),
        .Q(\q_m_reg_reg_n_0_[0] ));
  FDCE \q_m_reg_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[0]_0 ),
        .D(q_m_1),
        .Q(\q_m_reg_reg_n_0_[1] ));
  FDCE \q_m_reg_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[0]_0 ),
        .D(q_m_2),
        .Q(\q_m_reg_reg_n_0_[2] ));
  FDCE \q_m_reg_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[0]_0 ),
        .D(q_m_3),
        .Q(\q_m_reg_reg_n_0_[3] ));
  FDCE \q_m_reg_reg[4] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[0]_0 ),
        .D(q_m_4),
        .Q(\q_m_reg_reg_n_0_[4] ));
  FDCE \q_m_reg_reg[5] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[0]_0 ),
        .D(\q_m_reg[5]_i_1__0_n_0 ),
        .Q(\q_m_reg_reg_n_0_[5] ));
  FDCE \q_m_reg_reg[6] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[0]_0 ),
        .D(q_m_6),
        .Q(\q_m_reg_reg_n_0_[6] ));
  FDCE \q_m_reg_reg[7] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[0]_0 ),
        .D(q_m_7),
        .Q(\q_m_reg_reg_n_0_[7] ));
  FDCE \q_m_reg_reg[8] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[0]_0 ),
        .D(q_m),
        .Q(Q));
endmodule

(* ORIG_REF_NAME = "encode" *) 
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_encode_1
   (Q,
    \cnt_reg[2]_0 ,
    \cnt_reg[4]_0 ,
    \data_out_reg[9]_0 ,
    de_reg2,
    c0_reg2,
    video_din,
    pclk,
    \data_out_reg[9]_1 ,
    D);
  output [0:0]Q;
  output \cnt_reg[2]_0 ;
  output \cnt_reg[4]_0 ;
  output [9:0]\data_out_reg[9]_0 ;
  input de_reg2;
  input c0_reg2;
  input [7:0]video_din;
  input pclk;
  input \data_out_reg[9]_1 ;
  input [1:0]D;

  wire [1:0]D;
  wire [0:0]Q;
  wire c0_reg2;
  wire [4:1]cnt;
  wire \cnt[1]_i_1__1_n_0 ;
  wire \cnt[1]_i_2__1_n_0 ;
  wire \cnt[1]_i_3_n_0 ;
  wire \cnt[2]_i_1__1_n_0 ;
  wire \cnt[2]_i_2__1_n_0 ;
  wire \cnt[2]_i_3__0_n_0 ;
  wire \cnt[2]_i_4__1_n_0 ;
  wire \cnt[3]_i_1_n_0 ;
  wire \cnt[3]_i_2__1_n_0 ;
  wire \cnt[3]_i_3__1_n_0 ;
  wire \cnt[3]_i_4__1_n_0 ;
  wire \cnt[3]_i_5__1_n_0 ;
  wire \cnt[3]_i_6__1_n_0 ;
  wire \cnt[3]_i_7__1_n_0 ;
  wire \cnt[4]_i_10__1_n_0 ;
  wire \cnt[4]_i_11__1_n_0 ;
  wire \cnt[4]_i_12__1_n_0 ;
  wire \cnt[4]_i_13__1_n_0 ;
  wire \cnt[4]_i_14__1_n_0 ;
  wire \cnt[4]_i_15__0_n_0 ;
  wire \cnt[4]_i_16__1_n_0 ;
  wire \cnt[4]_i_17__1_n_0 ;
  wire \cnt[4]_i_18__1_n_0 ;
  wire \cnt[4]_i_19__1_n_0 ;
  wire \cnt[4]_i_1__1_n_0 ;
  wire \cnt[4]_i_20__0_n_0 ;
  wire \cnt[4]_i_21__1_n_0 ;
  wire \cnt[4]_i_22__1_n_0 ;
  wire \cnt[4]_i_23__1_n_0 ;
  wire \cnt[4]_i_24__1_n_0 ;
  wire \cnt[4]_i_25__0_n_0 ;
  wire \cnt[4]_i_2__1_n_0 ;
  wire \cnt[4]_i_4__1_n_0 ;
  wire \cnt[4]_i_6__1_n_0 ;
  wire \cnt[4]_i_7__1_n_0 ;
  wire \cnt[4]_i_8__1_n_0 ;
  wire \cnt[4]_i_9__1_n_0 ;
  wire \cnt_reg[2]_0 ;
  wire \cnt_reg[4]_0 ;
  wire [3:0]data_in_n1;
  wire \data_in_n1[0]_i_1_n_0 ;
  wire \data_in_n1[0]_i_2_n_0 ;
  wire \data_in_n1[1]_i_1_n_0 ;
  wire \data_in_n1[1]_i_2_n_0 ;
  wire \data_in_n1[2]_i_1_n_0 ;
  wire \data_in_n1[2]_i_2_n_0 ;
  wire \data_in_n1[3]_i_1_n_0 ;
  wire \data_in_n1[3]_i_2_n_0 ;
  wire \data_in_n1[3]_i_3_n_0 ;
  wire \data_in_n1[3]_i_4_n_0 ;
  wire \data_in_reg_reg_n_0_[0] ;
  wire \data_out[0]_i_1__1_n_0 ;
  wire \data_out[1]_i_1__1_n_0 ;
  wire \data_out[2]_i_1__1_n_0 ;
  wire \data_out[3]_i_1__1_n_0 ;
  wire \data_out[4]_i_1__1_n_0 ;
  wire \data_out[5]_i_1__1_n_0 ;
  wire \data_out[6]_i_1__1_n_0 ;
  wire \data_out[7]_i_1__1_n_0 ;
  wire [9:0]\data_out_reg[9]_0 ;
  wire \data_out_reg[9]_1 ;
  wire de_reg2;
  wire p_0_in;
  wire p_0_in0_in;
  wire p_0_in1_in;
  wire p_0_in2_in;
  wire p_0_in3_in;
  wire p_0_in4_in;
  wire p_0_in5_in;
  wire pclk;
  wire [8:8]q_m;
  wire q_m_1;
  wire q_m_2;
  wire q_m_3;
  wire q_m_4;
  wire q_m_6;
  wire q_m_7;
  wire \q_m_n0[1]_i_1__1_n_0 ;
  wire \q_m_n0[2]_i_1__1_n_0 ;
  wire \q_m_n0[3]_i_1__1_n_0 ;
  wire \q_m_n0_reg_n_0_[1] ;
  wire \q_m_n0_reg_n_0_[2] ;
  wire \q_m_n0_reg_n_0_[3] ;
  wire \q_m_n1[1]_i_1__1_n_0 ;
  wire \q_m_n1[2]_i_1__1_n_0 ;
  wire \q_m_n1[3]_i_1__1_n_0 ;
  wire \q_m_n1[3]_i_2__1_n_0 ;
  wire \q_m_n1[3]_i_3__1_n_0 ;
  wire \q_m_n1[3]_i_4__1_n_0 ;
  wire \q_m_n1[3]_i_5__1_n_0 ;
  wire \q_m_n1[3]_i_6__1_n_0 ;
  wire \q_m_n1[3]_i_7__1_n_0 ;
  wire \q_m_n1_reg_n_0_[1] ;
  wire \q_m_n1_reg_n_0_[2] ;
  wire \q_m_n1_reg_n_0_[3] ;
  wire \q_m_reg[5]_i_1__1_n_0 ;
  wire \q_m_reg[7]_i_2__1_n_0 ;
  wire \q_m_reg[7]_i_3__1_n_0 ;
  wire \q_m_reg_reg_n_0_[0] ;
  wire \q_m_reg_reg_n_0_[1] ;
  wire \q_m_reg_reg_n_0_[2] ;
  wire \q_m_reg_reg_n_0_[3] ;
  wire \q_m_reg_reg_n_0_[4] ;
  wire \q_m_reg_reg_n_0_[5] ;
  wire \q_m_reg_reg_n_0_[6] ;
  wire \q_m_reg_reg_n_0_[7] ;
  wire [7:0]video_din;

  LUT6 #(
    .INIT(64'h0A28A028A0280A28)) 
    \cnt[1]_i_1__1 
       (.I0(de_reg2),
        .I1(\cnt[1]_i_2__1_n_0 ),
        .I2(cnt[1]),
        .I3(\cnt_reg[2]_0 ),
        .I4(\cnt_reg[4]_0 ),
        .I5(\cnt[1]_i_3_n_0 ),
        .O(\cnt[1]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair47" *) 
  LUT2 #(
    .INIT(4'h6)) 
    \cnt[1]_i_2__1 
       (.I0(\q_m_n1_reg_n_0_[1] ),
        .I1(\q_m_n0_reg_n_0_[1] ),
        .O(\cnt[1]_i_2__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair47" *) 
  LUT3 #(
    .INIT(8'h96)) 
    \cnt[1]_i_3 
       (.I0(\q_m_n1_reg_n_0_[1] ),
        .I1(Q),
        .I2(\q_m_n0_reg_n_0_[1] ),
        .O(\cnt[1]_i_3_n_0 ));
  LUT6 #(
    .INIT(64'h020202A2A2A202A2)) 
    \cnt[2]_i_1__1 
       (.I0(de_reg2),
        .I1(\cnt[2]_i_2__1_n_0 ),
        .I2(\cnt_reg[2]_0 ),
        .I3(\cnt[2]_i_3__0_n_0 ),
        .I4(\cnt_reg[4]_0 ),
        .I5(\cnt[2]_i_4__1_n_0 ),
        .O(\cnt[2]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT5 #(
    .INIT(32'hAA6996AA)) 
    \cnt[2]_i_2__1 
       (.I0(\cnt[4]_i_11__1_n_0 ),
        .I1(cnt[1]),
        .I2(Q),
        .I3(\q_m_n0_reg_n_0_[1] ),
        .I4(\q_m_n1_reg_n_0_[1] ),
        .O(\cnt[2]_i_2__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair36" *) 
  LUT5 #(
    .INIT(32'h9AA6A665)) 
    \cnt[2]_i_3__0 
       (.I0(\cnt[4]_i_11__1_n_0 ),
        .I1(\q_m_n0_reg_n_0_[1] ),
        .I2(Q),
        .I3(\q_m_n1_reg_n_0_[1] ),
        .I4(cnt[1]),
        .O(\cnt[2]_i_3__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair33" *) 
  LUT5 #(
    .INIT(32'h7E1781E8)) 
    \cnt[2]_i_4__1 
       (.I0(cnt[1]),
        .I1(\q_m_n0_reg_n_0_[1] ),
        .I2(Q),
        .I3(\q_m_n1_reg_n_0_[1] ),
        .I4(\cnt[4]_i_11__1_n_0 ),
        .O(\cnt[2]_i_4__1_n_0 ));
  LUT6 #(
    .INIT(64'h020202A2A2A202A2)) 
    \cnt[3]_i_1 
       (.I0(de_reg2),
        .I1(\cnt[3]_i_2__1_n_0 ),
        .I2(\cnt_reg[2]_0 ),
        .I3(\cnt[3]_i_3__1_n_0 ),
        .I4(\cnt_reg[4]_0 ),
        .I5(\cnt[3]_i_4__1_n_0 ),
        .O(\cnt[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hB2BA4D454D45B2BA)) 
    \cnt[3]_i_2__1 
       (.I0(\cnt[4]_i_11__1_n_0 ),
        .I1(\cnt[3]_i_5__1_n_0 ),
        .I2(cnt[1]),
        .I3(\cnt[1]_i_2__1_n_0 ),
        .I4(\cnt[4]_i_12__1_n_0 ),
        .I5(\cnt[4]_i_8__1_n_0 ),
        .O(\cnt[3]_i_2__1_n_0 ));
  LUT6 #(
    .INIT(64'hFE80017F017FFE80)) 
    \cnt[3]_i_3__1 
       (.I0(cnt[1]),
        .I1(\q_m_n1_reg_n_0_[1] ),
        .I2(\cnt[3]_i_6__1_n_0 ),
        .I3(\cnt[4]_i_15__0_n_0 ),
        .I4(\cnt[4]_i_18__1_n_0 ),
        .I5(\cnt[4]_i_17__1_n_0 ),
        .O(\cnt[3]_i_3__1_n_0 ));
  LUT6 #(
    .INIT(64'h10515175EFAEAE8A)) 
    \cnt[3]_i_4__1 
       (.I0(\cnt[4]_i_11__1_n_0 ),
        .I1(Q),
        .I2(\q_m_n1_reg_n_0_[1] ),
        .I3(\q_m_n0_reg_n_0_[1] ),
        .I4(cnt[1]),
        .I5(\cnt[3]_i_7__1_n_0 ),
        .O(\cnt[3]_i_4__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair46" *) 
  LUT3 #(
    .INIT(8'hDB)) 
    \cnt[3]_i_5__1 
       (.I0(\q_m_n1_reg_n_0_[1] ),
        .I1(\q_m_n0_reg_n_0_[1] ),
        .I2(Q),
        .O(\cnt[3]_i_5__1_n_0 ));
  LUT2 #(
    .INIT(4'h6)) 
    \cnt[3]_i_6__1 
       (.I0(\q_m_n0_reg_n_0_[1] ),
        .I1(Q),
        .O(\cnt[3]_i_6__1_n_0 ));
  LUT6 #(
    .INIT(64'h6996696996966996)) 
    \cnt[3]_i_7__1 
       (.I0(\q_m_n1_reg_n_0_[3] ),
        .I1(\q_m_n0_reg_n_0_[3] ),
        .I2(cnt[3]),
        .I3(cnt[2]),
        .I4(\q_m_n1_reg_n_0_[2] ),
        .I5(\q_m_n0_reg_n_0_[2] ),
        .O(\cnt[3]_i_7__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair44" *) 
  LUT4 #(
    .INIT(16'h0820)) 
    \cnt[4]_i_10__1 
       (.I0(cnt[1]),
        .I1(Q),
        .I2(\q_m_n0_reg_n_0_[1] ),
        .I3(\q_m_n1_reg_n_0_[1] ),
        .O(\cnt[4]_i_10__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair45" *) 
  LUT3 #(
    .INIT(8'h69)) 
    \cnt[4]_i_11__1 
       (.I0(cnt[2]),
        .I1(\q_m_n0_reg_n_0_[2] ),
        .I2(\q_m_n1_reg_n_0_[2] ),
        .O(\cnt[4]_i_11__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair45" *) 
  LUT4 #(
    .INIT(16'hB28E)) 
    \cnt[4]_i_12__1 
       (.I0(cnt[2]),
        .I1(\q_m_n0_reg_n_0_[2] ),
        .I2(\q_m_n1_reg_n_0_[2] ),
        .I3(Q),
        .O(\cnt[4]_i_12__1_n_0 ));
  LUT6 #(
    .INIT(64'h9009000000009009)) 
    \cnt[4]_i_13__1 
       (.I0(\q_m_n0_reg_n_0_[2] ),
        .I1(\q_m_n1_reg_n_0_[2] ),
        .I2(\q_m_n1_reg_n_0_[1] ),
        .I3(\q_m_n0_reg_n_0_[1] ),
        .I4(\q_m_n1_reg_n_0_[3] ),
        .I5(\q_m_n0_reg_n_0_[3] ),
        .O(\cnt[4]_i_13__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair43" *) 
  LUT4 #(
    .INIT(16'h0041)) 
    \cnt[4]_i_14__1 
       (.I0(cnt[1]),
        .I1(\q_m_n0_reg_n_0_[1] ),
        .I2(Q),
        .I3(\q_m_n1_reg_n_0_[1] ),
        .O(\cnt[4]_i_14__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair37" *) 
  LUT5 #(
    .INIT(32'h69966969)) 
    \cnt[4]_i_15__0 
       (.I0(\q_m_n1_reg_n_0_[2] ),
        .I1(\q_m_n0_reg_n_0_[2] ),
        .I2(cnt[2]),
        .I3(Q),
        .I4(\q_m_n0_reg_n_0_[1] ),
        .O(\cnt[4]_i_15__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair43" *) 
  LUT4 #(
    .INIT(16'h9FFF)) 
    \cnt[4]_i_16__1 
       (.I0(\q_m_n0_reg_n_0_[1] ),
        .I1(Q),
        .I2(\q_m_n1_reg_n_0_[1] ),
        .I3(cnt[1]),
        .O(\cnt[4]_i_16__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair37" *) 
  LUT5 #(
    .INIT(32'h2F02022F)) 
    \cnt[4]_i_17__1 
       (.I0(\q_m_n0_reg_n_0_[1] ),
        .I1(Q),
        .I2(cnt[2]),
        .I3(\q_m_n0_reg_n_0_[2] ),
        .I4(\q_m_n1_reg_n_0_[2] ),
        .O(\cnt[4]_i_17__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT5 #(
    .INIT(32'h4BB4B44B)) 
    \cnt[4]_i_18__1 
       (.I0(\q_m_n1_reg_n_0_[2] ),
        .I1(\q_m_n0_reg_n_0_[2] ),
        .I2(\q_m_n1_reg_n_0_[3] ),
        .I3(\q_m_n0_reg_n_0_[3] ),
        .I4(cnt[3]),
        .O(\cnt[4]_i_18__1_n_0 ));
  LUT6 #(
    .INIT(64'h9A55AA9A55659A55)) 
    \cnt[4]_i_19__1 
       (.I0(cnt[4]),
        .I1(\q_m_n1_reg_n_0_[2] ),
        .I2(\q_m_n0_reg_n_0_[2] ),
        .I3(\q_m_n1_reg_n_0_[3] ),
        .I4(\q_m_n0_reg_n_0_[3] ),
        .I5(cnt[3]),
        .O(\cnt[4]_i_19__1_n_0 ));
  LUT6 #(
    .INIT(64'h020202A2A2A202A2)) 
    \cnt[4]_i_1__1 
       (.I0(de_reg2),
        .I1(\cnt[4]_i_2__1_n_0 ),
        .I2(\cnt_reg[2]_0 ),
        .I3(\cnt[4]_i_4__1_n_0 ),
        .I4(\cnt_reg[4]_0 ),
        .I5(\cnt[4]_i_6__1_n_0 ),
        .O(\cnt[4]_i_1__1_n_0 ));
  LUT6 #(
    .INIT(64'h2202FF0F00002202)) 
    \cnt[4]_i_20__0 
       (.I0(\q_m_n0_reg_n_0_[1] ),
        .I1(\q_m_n1_reg_n_0_[1] ),
        .I2(\q_m_n1_reg_n_0_[3] ),
        .I3(\q_m_n0_reg_n_0_[3] ),
        .I4(\q_m_n1_reg_n_0_[2] ),
        .I5(\q_m_n0_reg_n_0_[2] ),
        .O(\cnt[4]_i_20__0_n_0 ));
  LUT6 #(
    .INIT(64'hDDFD00F0FFFFDDFD)) 
    \cnt[4]_i_21__1 
       (.I0(\q_m_n1_reg_n_0_[1] ),
        .I1(\q_m_n0_reg_n_0_[1] ),
        .I2(\q_m_n0_reg_n_0_[3] ),
        .I3(\q_m_n1_reg_n_0_[3] ),
        .I4(\q_m_n0_reg_n_0_[2] ),
        .I5(\q_m_n1_reg_n_0_[2] ),
        .O(\cnt[4]_i_21__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair35" *) 
  LUT4 #(
    .INIT(16'hA665)) 
    \cnt[4]_i_22__1 
       (.I0(cnt[4]),
        .I1(\q_m_n1_reg_n_0_[3] ),
        .I2(\q_m_n0_reg_n_0_[3] ),
        .I3(cnt[3]),
        .O(\cnt[4]_i_22__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair36" *) 
  LUT4 #(
    .INIT(16'hBEEB)) 
    \cnt[4]_i_23__1 
       (.I0(cnt[1]),
        .I1(\q_m_n0_reg_n_0_[1] ),
        .I2(Q),
        .I3(\q_m_n1_reg_n_0_[1] ),
        .O(\cnt[4]_i_23__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair46" *) 
  LUT3 #(
    .INIT(8'hB2)) 
    \cnt[4]_i_24__1 
       (.I0(\q_m_n0_reg_n_0_[1] ),
        .I1(\q_m_n1_reg_n_0_[1] ),
        .I2(Q),
        .O(\cnt[4]_i_24__1_n_0 ));
  LUT3 #(
    .INIT(8'hB2)) 
    \cnt[4]_i_25__0 
       (.I0(\q_m_n0_reg_n_0_[2] ),
        .I1(\q_m_n1_reg_n_0_[2] ),
        .I2(cnt[2]),
        .O(\cnt[4]_i_25__0_n_0 ));
  LUT6 #(
    .INIT(64'h595959999A9A9AAA)) 
    \cnt[4]_i_2__1 
       (.I0(\cnt[4]_i_7__1_n_0 ),
        .I1(\cnt[4]_i_8__1_n_0 ),
        .I2(\cnt[4]_i_9__1_n_0 ),
        .I3(\cnt[4]_i_10__1_n_0 ),
        .I4(\cnt[4]_i_11__1_n_0 ),
        .I5(\cnt[4]_i_12__1_n_0 ),
        .O(\cnt[4]_i_2__1_n_0 ));
  LUT5 #(
    .INIT(32'h55555554)) 
    \cnt[4]_i_3__1 
       (.I0(\cnt[4]_i_13__1_n_0 ),
        .I1(cnt[2]),
        .I2(cnt[4]),
        .I3(cnt[1]),
        .I4(cnt[3]),
        .O(\cnt_reg[2]_0 ));
  LUT6 #(
    .INIT(64'h45FF0045BA00FFBA)) 
    \cnt[4]_i_4__1 
       (.I0(\cnt[4]_i_14__1_n_0 ),
        .I1(\cnt[4]_i_15__0_n_0 ),
        .I2(\cnt[4]_i_16__1_n_0 ),
        .I3(\cnt[4]_i_17__1_n_0 ),
        .I4(\cnt[4]_i_18__1_n_0 ),
        .I5(\cnt[4]_i_19__1_n_0 ),
        .O(\cnt[4]_i_4__1_n_0 ));
  LUT5 #(
    .INIT(32'h8BC8BBFB)) 
    \cnt[4]_i_5__0 
       (.I0(\cnt[4]_i_20__0_n_0 ),
        .I1(cnt[4]),
        .I2(\q_m_n0_reg_n_0_[3] ),
        .I3(\q_m_n1_reg_n_0_[3] ),
        .I4(\cnt[4]_i_21__1_n_0 ),
        .O(\cnt_reg[4]_0 ));
  LUT6 #(
    .INIT(64'hA995AAAA5555A995)) 
    \cnt[4]_i_6__1 
       (.I0(\cnt[4]_i_22__1_n_0 ),
        .I1(\cnt[4]_i_23__1_n_0 ),
        .I2(\cnt[4]_i_24__1_n_0 ),
        .I3(\cnt[4]_i_11__1_n_0 ),
        .I4(\cnt[4]_i_8__1_n_0 ),
        .I5(\cnt[4]_i_25__0_n_0 ),
        .O(\cnt[4]_i_6__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair35" *) 
  LUT5 #(
    .INIT(32'h5965A96A)) 
    \cnt[4]_i_7__1 
       (.I0(cnt[4]),
        .I1(Q),
        .I2(\q_m_n1_reg_n_0_[3] ),
        .I3(\q_m_n0_reg_n_0_[3] ),
        .I4(cnt[3]),
        .O(\cnt[4]_i_7__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair34" *) 
  LUT3 #(
    .INIT(8'h96)) 
    \cnt[4]_i_8__1 
       (.I0(cnt[3]),
        .I1(\q_m_n0_reg_n_0_[3] ),
        .I2(\q_m_n1_reg_n_0_[3] ),
        .O(\cnt[4]_i_8__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair44" *) 
  LUT4 #(
    .INIT(16'hFEBF)) 
    \cnt[4]_i_9__1 
       (.I0(cnt[1]),
        .I1(Q),
        .I2(\q_m_n0_reg_n_0_[1] ),
        .I3(\q_m_n1_reg_n_0_[1] ),
        .O(\cnt[4]_i_9__1_n_0 ));
  FDCE \cnt_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[9]_1 ),
        .D(\cnt[1]_i_1__1_n_0 ),
        .Q(cnt[1]));
  FDCE \cnt_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[9]_1 ),
        .D(\cnt[2]_i_1__1_n_0 ),
        .Q(cnt[2]));
  FDCE \cnt_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[9]_1 ),
        .D(\cnt[3]_i_1_n_0 ),
        .Q(cnt[3]));
  FDCE \cnt_reg[4] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[9]_1 ),
        .D(\cnt[4]_i_1__1_n_0 ),
        .Q(cnt[4]));
  LUT6 #(
    .INIT(64'h6996966996696996)) 
    \data_in_n1[0]_i_1 
       (.I0(video_din[0]),
        .I1(video_din[7]),
        .I2(\data_in_n1[0]_i_2_n_0 ),
        .I3(video_din[2]),
        .I4(video_din[1]),
        .I5(video_din[3]),
        .O(\data_in_n1[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair38" *) 
  LUT3 #(
    .INIT(8'h96)) 
    \data_in_n1[0]_i_2 
       (.I0(video_din[6]),
        .I1(video_din[4]),
        .I2(video_din[5]),
        .O(\data_in_n1[0]_i_2_n_0 ));
  LUT3 #(
    .INIT(8'h96)) 
    \data_in_n1[1]_i_1 
       (.I0(\data_in_n1[3]_i_2_n_0 ),
        .I1(\data_in_n1[1]_i_2_n_0 ),
        .I2(\data_in_n1[3]_i_3_n_0 ),
        .O(\data_in_n1[1]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h171717E817E8E8E8)) 
    \data_in_n1[1]_i_2 
       (.I0(video_din[3]),
        .I1(video_din[2]),
        .I2(video_din[1]),
        .I3(video_din[6]),
        .I4(video_din[5]),
        .I5(video_din[4]),
        .O(\data_in_n1[1]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h7E7E7EE87EE8E8E8)) 
    \data_in_n1[2]_i_1 
       (.I0(\data_in_n1[3]_i_2_n_0 ),
        .I1(\data_in_n1[3]_i_3_n_0 ),
        .I2(\data_in_n1[2]_i_2_n_0 ),
        .I3(video_din[4]),
        .I4(video_din[5]),
        .I5(video_din[6]),
        .O(\data_in_n1[2]_i_1_n_0 ));
  LUT3 #(
    .INIT(8'hE8)) 
    \data_in_n1[2]_i_2 
       (.I0(video_din[1]),
        .I1(video_din[2]),
        .I2(video_din[3]),
        .O(\data_in_n1[2]_i_2_n_0 ));
  LUT6 #(
    .INIT(64'h8880800000000000)) 
    \data_in_n1[3]_i_1 
       (.I0(\data_in_n1[3]_i_2_n_0 ),
        .I1(\data_in_n1[3]_i_3_n_0 ),
        .I2(video_din[3]),
        .I3(video_din[2]),
        .I4(video_din[1]),
        .I5(\data_in_n1[3]_i_4_n_0 ),
        .O(\data_in_n1[3]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'h9600009600969600)) 
    \data_in_n1[3]_i_2 
       (.I0(video_din[2]),
        .I1(video_din[1]),
        .I2(video_din[3]),
        .I3(video_din[0]),
        .I4(video_din[7]),
        .I5(\data_in_n1[0]_i_2_n_0 ),
        .O(\data_in_n1[3]_i_2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair38" *) 
  LUT5 #(
    .INIT(32'hE88E8EE8)) 
    \data_in_n1[3]_i_3 
       (.I0(video_din[7]),
        .I1(video_din[0]),
        .I2(video_din[5]),
        .I3(video_din[4]),
        .I4(video_din[6]),
        .O(\data_in_n1[3]_i_3_n_0 ));
  LUT3 #(
    .INIT(8'hE8)) 
    \data_in_n1[3]_i_4 
       (.I0(video_din[4]),
        .I1(video_din[5]),
        .I2(video_din[6]),
        .O(\data_in_n1[3]_i_4_n_0 ));
  FDCE \data_in_n1_reg[0] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[9]_1 ),
        .D(\data_in_n1[0]_i_1_n_0 ),
        .Q(data_in_n1[0]));
  FDCE \data_in_n1_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[9]_1 ),
        .D(\data_in_n1[1]_i_1_n_0 ),
        .Q(data_in_n1[1]));
  FDCE \data_in_n1_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[9]_1 ),
        .D(\data_in_n1[2]_i_1_n_0 ),
        .Q(data_in_n1[2]));
  FDCE \data_in_n1_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[9]_1 ),
        .D(\data_in_n1[3]_i_1_n_0 ),
        .Q(data_in_n1[3]));
  FDCE \data_in_reg_reg[0] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[9]_1 ),
        .D(video_din[0]),
        .Q(\data_in_reg_reg_n_0_[0] ));
  FDCE \data_in_reg_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[9]_1 ),
        .D(video_din[1]),
        .Q(p_0_in5_in));
  FDCE \data_in_reg_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[9]_1 ),
        .D(video_din[2]),
        .Q(p_0_in4_in));
  FDCE \data_in_reg_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[9]_1 ),
        .D(video_din[3]),
        .Q(p_0_in3_in));
  FDCE \data_in_reg_reg[4] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[9]_1 ),
        .D(video_din[4]),
        .Q(p_0_in2_in));
  FDCE \data_in_reg_reg[5] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[9]_1 ),
        .D(video_din[5]),
        .Q(p_0_in1_in));
  FDCE \data_in_reg_reg[6] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[9]_1 ),
        .D(video_din[6]),
        .Q(p_0_in0_in));
  FDCE \data_in_reg_reg[7] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[9]_1 ),
        .D(video_din[7]),
        .Q(p_0_in));
  LUT6 #(
    .INIT(64'h59A9FFFF59A90000)) 
    \data_out[0]_i_1__1 
       (.I0(\q_m_reg_reg_n_0_[0] ),
        .I1(Q),
        .I2(\cnt_reg[2]_0 ),
        .I3(\cnt_reg[4]_0 ),
        .I4(de_reg2),
        .I5(c0_reg2),
        .O(\data_out[0]_i_1__1_n_0 ));
  LUT6 #(
    .INIT(64'h59A9FFFF59A90000)) 
    \data_out[1]_i_1__1 
       (.I0(\q_m_reg_reg_n_0_[1] ),
        .I1(Q),
        .I2(\cnt_reg[2]_0 ),
        .I3(\cnt_reg[4]_0 ),
        .I4(de_reg2),
        .I5(c0_reg2),
        .O(\data_out[1]_i_1__1_n_0 ));
  LUT6 #(
    .INIT(64'h08A85DFDA202F757)) 
    \data_out[2]_i_1__1 
       (.I0(de_reg2),
        .I1(Q),
        .I2(\cnt_reg[2]_0 ),
        .I3(\cnt_reg[4]_0 ),
        .I4(c0_reg2),
        .I5(\q_m_reg_reg_n_0_[2] ),
        .O(\data_out[2]_i_1__1_n_0 ));
  LUT6 #(
    .INIT(64'h59A9FFFF59A90000)) 
    \data_out[3]_i_1__1 
       (.I0(\q_m_reg_reg_n_0_[3] ),
        .I1(Q),
        .I2(\cnt_reg[2]_0 ),
        .I3(\cnt_reg[4]_0 ),
        .I4(de_reg2),
        .I5(c0_reg2),
        .O(\data_out[3]_i_1__1_n_0 ));
  LUT6 #(
    .INIT(64'h08A85DFDA202F757)) 
    \data_out[4]_i_1__1 
       (.I0(de_reg2),
        .I1(Q),
        .I2(\cnt_reg[2]_0 ),
        .I3(\cnt_reg[4]_0 ),
        .I4(c0_reg2),
        .I5(\q_m_reg_reg_n_0_[4] ),
        .O(\data_out[4]_i_1__1_n_0 ));
  LUT6 #(
    .INIT(64'h59A9FFFF59A90000)) 
    \data_out[5]_i_1__1 
       (.I0(\q_m_reg_reg_n_0_[5] ),
        .I1(Q),
        .I2(\cnt_reg[2]_0 ),
        .I3(\cnt_reg[4]_0 ),
        .I4(de_reg2),
        .I5(c0_reg2),
        .O(\data_out[5]_i_1__1_n_0 ));
  LUT6 #(
    .INIT(64'h08A85DFDA202F757)) 
    \data_out[6]_i_1__1 
       (.I0(de_reg2),
        .I1(Q),
        .I2(\cnt_reg[2]_0 ),
        .I3(\cnt_reg[4]_0 ),
        .I4(c0_reg2),
        .I5(\q_m_reg_reg_n_0_[6] ),
        .O(\data_out[6]_i_1__1_n_0 ));
  LUT6 #(
    .INIT(64'h59A9FFFF59A90000)) 
    \data_out[7]_i_1__1 
       (.I0(\q_m_reg_reg_n_0_[7] ),
        .I1(Q),
        .I2(\cnt_reg[2]_0 ),
        .I3(\cnt_reg[4]_0 ),
        .I4(de_reg2),
        .I5(c0_reg2),
        .O(\data_out[7]_i_1__1_n_0 ));
  FDCE \data_out_reg[0] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[9]_1 ),
        .D(\data_out[0]_i_1__1_n_0 ),
        .Q(\data_out_reg[9]_0 [0]));
  FDCE \data_out_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[9]_1 ),
        .D(\data_out[1]_i_1__1_n_0 ),
        .Q(\data_out_reg[9]_0 [1]));
  FDCE \data_out_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[9]_1 ),
        .D(\data_out[2]_i_1__1_n_0 ),
        .Q(\data_out_reg[9]_0 [2]));
  FDCE \data_out_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[9]_1 ),
        .D(\data_out[3]_i_1__1_n_0 ),
        .Q(\data_out_reg[9]_0 [3]));
  FDCE \data_out_reg[4] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[9]_1 ),
        .D(\data_out[4]_i_1__1_n_0 ),
        .Q(\data_out_reg[9]_0 [4]));
  FDCE \data_out_reg[5] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[9]_1 ),
        .D(\data_out[5]_i_1__1_n_0 ),
        .Q(\data_out_reg[9]_0 [5]));
  FDCE \data_out_reg[6] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[9]_1 ),
        .D(\data_out[6]_i_1__1_n_0 ),
        .Q(\data_out_reg[9]_0 [6]));
  FDCE \data_out_reg[7] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[9]_1 ),
        .D(\data_out[7]_i_1__1_n_0 ),
        .Q(\data_out_reg[9]_0 [7]));
  FDCE \data_out_reg[8] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[9]_1 ),
        .D(D[0]),
        .Q(\data_out_reg[9]_0 [8]));
  FDCE \data_out_reg[9] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[9]_1 ),
        .D(D[1]),
        .Q(\data_out_reg[9]_0 [9]));
  LUT6 #(
    .INIT(64'h9996699996669996)) 
    \q_m_n0[1]_i_1__1 
       (.I0(\q_m_n1[3]_i_3__1_n_0 ),
        .I1(\q_m_n1[3]_i_2__1_n_0 ),
        .I2(\q_m_n1[3]_i_5__1_n_0 ),
        .I3(\q_m_n1[3]_i_4__1_n_0 ),
        .I4(\data_in_reg_reg_n_0_[0] ),
        .I5(\q_m_n1[3]_i_6__1_n_0 ),
        .O(\q_m_n0[1]_i_1__1_n_0 ));
  LUT6 #(
    .INIT(64'h2000FBB2FBB2DFFF)) 
    \q_m_n0[2]_i_1__1 
       (.I0(\q_m_n1[3]_i_6__1_n_0 ),
        .I1(\data_in_reg_reg_n_0_[0] ),
        .I2(\q_m_n1[3]_i_4__1_n_0 ),
        .I3(\q_m_n1[3]_i_5__1_n_0 ),
        .I4(\q_m_n1[3]_i_2__1_n_0 ),
        .I5(\q_m_n1[3]_i_3__1_n_0 ),
        .O(\q_m_n0[2]_i_1__1_n_0 ));
  LUT6 #(
    .INIT(64'h0100000000000000)) 
    \q_m_n0[3]_i_1__1 
       (.I0(\q_m_n1[3]_i_2__1_n_0 ),
        .I1(\q_m_n1[3]_i_3__1_n_0 ),
        .I2(\data_in_reg_reg_n_0_[0] ),
        .I3(\q_m_n1[3]_i_4__1_n_0 ),
        .I4(\q_m_n1[3]_i_5__1_n_0 ),
        .I5(\q_m_n1[3]_i_6__1_n_0 ),
        .O(\q_m_n0[3]_i_1__1_n_0 ));
  FDCE \q_m_n0_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[9]_1 ),
        .D(\q_m_n0[1]_i_1__1_n_0 ),
        .Q(\q_m_n0_reg_n_0_[1] ));
  FDCE \q_m_n0_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[9]_1 ),
        .D(\q_m_n0[2]_i_1__1_n_0 ),
        .Q(\q_m_n0_reg_n_0_[2] ));
  FDCE \q_m_n0_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[9]_1 ),
        .D(\q_m_n0[3]_i_1__1_n_0 ),
        .Q(\q_m_n0_reg_n_0_[3] ));
  LUT6 #(
    .INIT(64'h6696969996999969)) 
    \q_m_n1[1]_i_1__1 
       (.I0(\q_m_n1[3]_i_2__1_n_0 ),
        .I1(\q_m_n1[3]_i_3__1_n_0 ),
        .I2(\data_in_reg_reg_n_0_[0] ),
        .I3(\q_m_n1[3]_i_4__1_n_0 ),
        .I4(\q_m_n1[3]_i_5__1_n_0 ),
        .I5(\q_m_n1[3]_i_6__1_n_0 ),
        .O(\q_m_n1[1]_i_1__1_n_0 ));
  LUT6 #(
    .INIT(64'hFFEF71F771F70010)) 
    \q_m_n1[2]_i_1__1 
       (.I0(\q_m_n1[3]_i_5__1_n_0 ),
        .I1(\q_m_n1[3]_i_4__1_n_0 ),
        .I2(\data_in_reg_reg_n_0_[0] ),
        .I3(\q_m_n1[3]_i_6__1_n_0 ),
        .I4(\q_m_n1[3]_i_3__1_n_0 ),
        .I5(\q_m_n1[3]_i_2__1_n_0 ),
        .O(\q_m_n1[2]_i_1__1_n_0 ));
  LUT6 #(
    .INIT(64'h0000000000000080)) 
    \q_m_n1[3]_i_1__1 
       (.I0(\q_m_n1[3]_i_2__1_n_0 ),
        .I1(\q_m_n1[3]_i_3__1_n_0 ),
        .I2(\data_in_reg_reg_n_0_[0] ),
        .I3(\q_m_n1[3]_i_4__1_n_0 ),
        .I4(\q_m_n1[3]_i_5__1_n_0 ),
        .I5(\q_m_n1[3]_i_6__1_n_0 ),
        .O(\q_m_n1[3]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair39" *) 
  LUT5 #(
    .INIT(32'hB42D4BD2)) 
    \q_m_n1[3]_i_2__1 
       (.I0(\q_m_reg[7]_i_2__1_n_0 ),
        .I1(p_0_in3_in),
        .I2(\data_in_reg_reg_n_0_[0] ),
        .I3(p_0_in4_in),
        .I4(p_0_in5_in),
        .O(\q_m_n1[3]_i_2__1_n_0 ));
  LUT6 #(
    .INIT(64'hE11E1EE178878778)) 
    \q_m_n1[3]_i_3__1 
       (.I0(p_0_in0_in),
        .I1(\q_m_reg[7]_i_2__1_n_0 ),
        .I2(q_m_2),
        .I3(p_0_in2_in),
        .I4(p_0_in3_in),
        .I5(p_0_in1_in),
        .O(\q_m_n1[3]_i_3__1_n_0 ));
  LUT6 #(
    .INIT(64'h9669699669969669)) 
    \q_m_n1[3]_i_4__1 
       (.I0(p_0_in3_in),
        .I1(p_0_in2_in),
        .I2(\data_in_reg_reg_n_0_[0] ),
        .I3(p_0_in4_in),
        .I4(p_0_in5_in),
        .I5(\q_m_n1[3]_i_7__1_n_0 ),
        .O(\q_m_n1[3]_i_4__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair40" *) 
  LUT5 #(
    .INIT(32'h96696996)) 
    \q_m_n1[3]_i_5__1 
       (.I0(p_0_in0_in),
        .I1(\q_m_reg[7]_i_3__1_n_0 ),
        .I2(p_0_in1_in),
        .I3(\q_m_reg[7]_i_2__1_n_0 ),
        .I4(p_0_in),
        .O(\q_m_n1[3]_i_5__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair48" *) 
  LUT3 #(
    .INIT(8'h69)) 
    \q_m_n1[3]_i_6__1 
       (.I0(\data_in_reg_reg_n_0_[0] ),
        .I1(p_0_in5_in),
        .I2(p_0_in3_in),
        .O(\q_m_n1[3]_i_6__1_n_0 ));
  LUT6 #(
    .INIT(64'h5555555566666A66)) 
    \q_m_n1[3]_i_7__1 
       (.I0(p_0_in0_in),
        .I1(data_in_n1[2]),
        .I2(data_in_n1[0]),
        .I3(\data_in_reg_reg_n_0_[0] ),
        .I4(data_in_n1[1]),
        .I5(data_in_n1[3]),
        .O(\q_m_n1[3]_i_7__1_n_0 ));
  FDCE \q_m_n1_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[9]_1 ),
        .D(\q_m_n1[1]_i_1__1_n_0 ),
        .Q(\q_m_n1_reg_n_0_[1] ));
  FDCE \q_m_n1_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[9]_1 ),
        .D(\q_m_n1[2]_i_1__1_n_0 ),
        .Q(\q_m_n1_reg_n_0_[2] ));
  FDCE \q_m_n1_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[9]_1 ),
        .D(\q_m_n1[3]_i_1__1_n_0 ),
        .Q(\q_m_n1_reg_n_0_[3] ));
  LUT6 #(
    .INIT(64'hFFA800570055FFAA)) 
    \q_m_reg[1]_i_1__1 
       (.I0(data_in_n1[2]),
        .I1(data_in_n1[0]),
        .I2(data_in_n1[1]),
        .I3(data_in_n1[3]),
        .I4(p_0_in5_in),
        .I5(\data_in_reg_reg_n_0_[0] ),
        .O(q_m_1));
  (* SOFT_HLUTNM = "soft_lutpair48" *) 
  LUT3 #(
    .INIT(8'h96)) 
    \q_m_reg[2]_i_1__1 
       (.I0(\data_in_reg_reg_n_0_[0] ),
        .I1(p_0_in4_in),
        .I2(p_0_in5_in),
        .O(q_m_2));
  (* SOFT_HLUTNM = "soft_lutpair39" *) 
  LUT5 #(
    .INIT(32'h96696996)) 
    \q_m_reg[3]_i_1__1 
       (.I0(p_0_in5_in),
        .I1(p_0_in4_in),
        .I2(\data_in_reg_reg_n_0_[0] ),
        .I3(p_0_in3_in),
        .I4(\q_m_reg[7]_i_2__1_n_0 ),
        .O(q_m_3));
  (* SOFT_HLUTNM = "soft_lutpair42" *) 
  LUT5 #(
    .INIT(32'h96696996)) 
    \q_m_reg[4]_i_1__1 
       (.I0(p_0_in3_in),
        .I1(p_0_in2_in),
        .I2(\data_in_reg_reg_n_0_[0] ),
        .I3(p_0_in4_in),
        .I4(p_0_in5_in),
        .O(q_m_4));
  LUT5 #(
    .INIT(32'h96696996)) 
    \q_m_reg[5]_i_1__1 
       (.I0(\q_m_reg[7]_i_2__1_n_0 ),
        .I1(q_m_2),
        .I2(p_0_in2_in),
        .I3(p_0_in3_in),
        .I4(p_0_in1_in),
        .O(\q_m_reg[5]_i_1__1_n_0 ));
  LUT5 #(
    .INIT(32'h96696996)) 
    \q_m_reg[6]_i_1__1 
       (.I0(p_0_in1_in),
        .I1(p_0_in3_in),
        .I2(p_0_in2_in),
        .I3(q_m_2),
        .I4(p_0_in0_in),
        .O(q_m_6));
  (* SOFT_HLUTNM = "soft_lutpair40" *) 
  LUT5 #(
    .INIT(32'h69969669)) 
    \q_m_reg[7]_i_1__1 
       (.I0(p_0_in),
        .I1(\q_m_reg[7]_i_2__1_n_0 ),
        .I2(p_0_in1_in),
        .I3(\q_m_reg[7]_i_3__1_n_0 ),
        .I4(p_0_in0_in),
        .O(q_m_7));
  (* SOFT_HLUTNM = "soft_lutpair41" *) 
  LUT5 #(
    .INIT(32'hFFEFAAAA)) 
    \q_m_reg[7]_i_2__1 
       (.I0(data_in_n1[3]),
        .I1(data_in_n1[1]),
        .I2(\data_in_reg_reg_n_0_[0] ),
        .I3(data_in_n1[0]),
        .I4(data_in_n1[2]),
        .O(\q_m_reg[7]_i_2__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair42" *) 
  LUT5 #(
    .INIT(32'h69969669)) 
    \q_m_reg[7]_i_3__1 
       (.I0(p_0_in5_in),
        .I1(p_0_in4_in),
        .I2(\data_in_reg_reg_n_0_[0] ),
        .I3(p_0_in2_in),
        .I4(p_0_in3_in),
        .O(\q_m_reg[7]_i_3__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair41" *) 
  LUT5 #(
    .INIT(32'h00005575)) 
    \q_m_reg[8]_i_1__1 
       (.I0(data_in_n1[2]),
        .I1(data_in_n1[0]),
        .I2(\data_in_reg_reg_n_0_[0] ),
        .I3(data_in_n1[1]),
        .I4(data_in_n1[3]),
        .O(q_m));
  FDCE \q_m_reg_reg[0] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[9]_1 ),
        .D(\data_in_reg_reg_n_0_[0] ),
        .Q(\q_m_reg_reg_n_0_[0] ));
  FDCE \q_m_reg_reg[1] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[9]_1 ),
        .D(q_m_1),
        .Q(\q_m_reg_reg_n_0_[1] ));
  FDCE \q_m_reg_reg[2] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[9]_1 ),
        .D(q_m_2),
        .Q(\q_m_reg_reg_n_0_[2] ));
  FDCE \q_m_reg_reg[3] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[9]_1 ),
        .D(q_m_3),
        .Q(\q_m_reg_reg_n_0_[3] ));
  FDCE \q_m_reg_reg[4] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[9]_1 ),
        .D(q_m_4),
        .Q(\q_m_reg_reg_n_0_[4] ));
  FDCE \q_m_reg_reg[5] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[9]_1 ),
        .D(\q_m_reg[5]_i_1__1_n_0 ),
        .Q(\q_m_reg_reg_n_0_[5] ));
  FDCE \q_m_reg_reg[6] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[9]_1 ),
        .D(q_m_6),
        .Q(\q_m_reg_reg_n_0_[6] ));
  FDCE \q_m_reg_reg[7] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[9]_1 ),
        .D(q_m_7),
        .Q(\q_m_reg_reg_n_0_[7] ));
  FDCE \q_m_reg_reg[8] 
       (.C(pclk),
        .CE(1'b1),
        .CLR(\data_out_reg[9]_1 ),
        .D(q_m),
        .Q(Q));
endmodule

module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_hdmi_transmitter
   (tmds_data_p,
    tmds_data_n,
    tmds_clk_p,
    tmds_clk_n,
    pclk_x5,
    video_de,
    pclk,
    video_hsync,
    video_vsync,
    rst_n,
    video_din);
  output [2:0]tmds_data_p;
  output [2:0]tmds_data_n;
  output tmds_clk_p;
  output tmds_clk_n;
  input pclk_x5;
  input video_de;
  input pclk;
  input video_hsync;
  input video_vsync;
  input rst_n;
  input [23:0]video_din;

  wire C00;
  wire c0_reg2;
  wire de_reg2;
  wire encode_b_n_0;
  wire encode_b_n_10;
  wire encode_b_n_11;
  wire encode_b_n_12;
  wire encode_b_n_13;
  wire encode_b_n_14;
  wire encode_b_n_15;
  wire encode_b_n_16;
  wire encode_b_n_3;
  wire encode_b_n_4;
  wire encode_b_n_5;
  wire encode_b_n_6;
  wire encode_b_n_7;
  wire encode_b_n_8;
  wire encode_b_n_9;
  wire encode_g_n_0;
  wire encode_g_n_1;
  wire encode_g_n_10;
  wire encode_g_n_11;
  wire encode_g_n_12;
  wire encode_g_n_2;
  wire encode_g_n_3;
  wire encode_g_n_4;
  wire encode_g_n_5;
  wire encode_g_n_6;
  wire encode_g_n_7;
  wire encode_g_n_8;
  wire encode_g_n_9;
  wire encode_r_n_0;
  wire encode_r_n_1;
  wire encode_r_n_10;
  wire encode_r_n_11;
  wire encode_r_n_12;
  wire encode_r_n_2;
  wire encode_r_n_3;
  wire encode_r_n_4;
  wire encode_r_n_5;
  wire encode_r_n_6;
  wire encode_r_n_7;
  wire encode_r_n_8;
  wire encode_r_n_9;
  wire pclk;
  wire pclk_x5;
  wire rst_n;
  wire tmds_clk_n;
  wire tmds_clk_p;
  wire [2:0]tmds_data_n;
  wire [2:0]tmds_data_p;
  wire video_de;
  wire [23:0]video_din;
  wire video_hsync;
  wire video_vsync;

  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_encode encode_b
       (.D({encode_b_n_3,encode_b_n_4}),
        .Q(encode_g_n_2),
        .c0_reg2(c0_reg2),
        .c0_reg2_reg_0({encode_b_n_5,encode_b_n_6}),
        .\data_out_reg[9]_0 ({encode_b_n_7,encode_b_n_8,encode_b_n_9,encode_b_n_10,encode_b_n_11,encode_b_n_12,encode_b_n_13,encode_b_n_14,encode_b_n_15,encode_b_n_16}),
        .\data_out_reg[9]_1 (encode_g_n_1),
        .\data_out_reg[9]_2 (encode_g_n_0),
        .\data_out_reg[9]_3 (encode_r_n_2),
        .\data_out_reg[9]_4 (encode_r_n_1),
        .\data_out_reg[9]_5 (encode_r_n_0),
        .de_reg2(de_reg2),
        .pclk(pclk),
        .rst_n(rst_n),
        .rst_n_0(encode_b_n_0),
        .video_de(video_de),
        .video_din(video_din[7:0]),
        .video_hsync(video_hsync),
        .video_vsync(video_vsync));
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_encode_0 encode_g
       (.D({encode_b_n_3,encode_b_n_4}),
        .Q(encode_g_n_2),
        .c0_reg2(c0_reg2),
        .\cnt_reg[2]_0 (encode_g_n_0),
        .\cnt_reg[4]_0 (encode_g_n_1),
        .\data_out_reg[0]_0 (encode_b_n_0),
        .\data_out_reg[9]_0 ({encode_g_n_3,encode_g_n_4,encode_g_n_5,encode_g_n_6,encode_g_n_7,encode_g_n_8,encode_g_n_9,encode_g_n_10,encode_g_n_11,encode_g_n_12}),
        .de_reg2(de_reg2),
        .pclk(pclk),
        .video_din(video_din[15:8]));
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_encode_1 encode_r
       (.D({encode_b_n_5,encode_b_n_6}),
        .Q(encode_r_n_0),
        .c0_reg2(c0_reg2),
        .\cnt_reg[2]_0 (encode_r_n_1),
        .\cnt_reg[4]_0 (encode_r_n_2),
        .\data_out_reg[9]_0 ({encode_r_n_3,encode_r_n_4,encode_r_n_5,encode_r_n_6,encode_r_n_7,encode_r_n_8,encode_r_n_9,encode_r_n_10,encode_r_n_11,encode_r_n_12}),
        .\data_out_reg[9]_1 (encode_b_n_0),
        .de_reg2(de_reg2),
        .pclk(pclk),
        .video_din(video_din[23:16]));
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_par_to_ser par_to_ser_b
       (.C00(C00),
        .\data_fall_s_reg[4]_0 ({encode_b_n_7,encode_b_n_8,encode_b_n_9,encode_b_n_10,encode_b_n_11,encode_b_n_12,encode_b_n_13,encode_b_n_14,encode_b_n_15,encode_b_n_16}),
        .pclk_x5(pclk_x5),
        .tmds_data_n(tmds_data_n[0]),
        .tmds_data_p(tmds_data_p[0]));
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_par_to_ser_2 par_to_ser_clk
       (.C00(C00),
        .pclk_x5(pclk_x5),
        .tmds_clk_n(tmds_clk_n),
        .tmds_clk_p(tmds_clk_p));
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_par_to_ser_3 par_to_ser_g
       (.C00(C00),
        .\data_fall_s_reg[4]_0 ({encode_g_n_3,encode_g_n_4,encode_g_n_5,encode_g_n_6,encode_g_n_7,encode_g_n_8,encode_g_n_9,encode_g_n_10,encode_g_n_11,encode_g_n_12}),
        .pclk_x5(pclk_x5),
        .tmds_data_n(tmds_data_n[1]),
        .tmds_data_p(tmds_data_p[1]));
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_par_to_ser_4 par_to_ser_r
       (.C00(C00),
        .\data_fall_s_reg[4]_0 ({encode_r_n_3,encode_r_n_4,encode_r_n_5,encode_r_n_6,encode_r_n_7,encode_r_n_8,encode_r_n_9,encode_r_n_10,encode_r_n_11,encode_r_n_12}),
        .pclk_x5(pclk_x5),
        .tmds_data_n(tmds_data_n[2]),
        .tmds_data_p(tmds_data_p[2]));
endmodule

module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_hdmi_transmitter_v1_0
   (tmds_data_p,
    tmds_data_n,
    tmds_clk_p,
    tmds_clk_n,
    S_AXI_WREADY,
    S_AXI_AWREADY,
    S_AXI_ARREADY,
    s00_axi_rdata,
    s00_axi_rvalid,
    s00_axi_bvalid,
    pclk_x5,
    video_din,
    pclk,
    video_de,
    video_hsync,
    video_vsync,
    s00_axi_aclk,
    s00_axi_araddr,
    s00_axi_arvalid,
    s00_axi_awaddr,
    s00_axi_wvalid,
    s00_axi_awvalid,
    s00_axi_wdata,
    s00_axi_wstrb,
    s00_axi_aresetn,
    rst_n,
    s00_axi_bready,
    s00_axi_rready);
  output [2:0]tmds_data_p;
  output [2:0]tmds_data_n;
  output tmds_clk_p;
  output tmds_clk_n;
  output S_AXI_WREADY;
  output S_AXI_AWREADY;
  output S_AXI_ARREADY;
  output [31:0]s00_axi_rdata;
  output s00_axi_rvalid;
  output s00_axi_bvalid;
  input pclk_x5;
  input [23:0]video_din;
  input pclk;
  input video_de;
  input video_hsync;
  input video_vsync;
  input s00_axi_aclk;
  input [1:0]s00_axi_araddr;
  input s00_axi_arvalid;
  input [1:0]s00_axi_awaddr;
  input s00_axi_wvalid;
  input s00_axi_awvalid;
  input [31:0]s00_axi_wdata;
  input [3:0]s00_axi_wstrb;
  input s00_axi_aresetn;
  input rst_n;
  input s00_axi_bready;
  input s00_axi_rready;

  wire S_AXI_ARREADY;
  wire S_AXI_AWREADY;
  wire S_AXI_WREADY;
  wire pclk;
  wire pclk_x5;
  wire rst_n;
  wire s00_axi_aclk;
  wire [1:0]s00_axi_araddr;
  wire s00_axi_aresetn;
  wire s00_axi_arvalid;
  wire [1:0]s00_axi_awaddr;
  wire s00_axi_awvalid;
  wire s00_axi_bready;
  wire s00_axi_bvalid;
  wire [31:0]s00_axi_rdata;
  wire s00_axi_rready;
  wire s00_axi_rvalid;
  wire [31:0]s00_axi_wdata;
  wire [3:0]s00_axi_wstrb;
  wire s00_axi_wvalid;
  wire tmds_clk_n;
  wire tmds_clk_p;
  wire [2:0]tmds_data_n;
  wire [2:0]tmds_data_p;
  wire video_de;
  wire [23:0]video_din;
  wire video_hsync;
  wire video_vsync;

  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_hdmi_transmitter_v1_0_S00_AXI hdmi_transmitter_v1_0_S00_AXI_inst
       (.S_AXI_ARREADY(S_AXI_ARREADY),
        .S_AXI_AWREADY(S_AXI_AWREADY),
        .S_AXI_WREADY(S_AXI_WREADY),
        .pclk(pclk),
        .pclk_x5(pclk_x5),
        .rst_n(rst_n),
        .s00_axi_aclk(s00_axi_aclk),
        .s00_axi_araddr(s00_axi_araddr),
        .s00_axi_aresetn(s00_axi_aresetn),
        .s00_axi_arvalid(s00_axi_arvalid),
        .s00_axi_awaddr(s00_axi_awaddr),
        .s00_axi_awvalid(s00_axi_awvalid),
        .s00_axi_bready(s00_axi_bready),
        .s00_axi_bvalid(s00_axi_bvalid),
        .s00_axi_rdata(s00_axi_rdata),
        .s00_axi_rready(s00_axi_rready),
        .s00_axi_rvalid(s00_axi_rvalid),
        .s00_axi_wdata(s00_axi_wdata),
        .s00_axi_wstrb(s00_axi_wstrb),
        .s00_axi_wvalid(s00_axi_wvalid),
        .tmds_clk_n(tmds_clk_n),
        .tmds_clk_p(tmds_clk_p),
        .tmds_data_n(tmds_data_n),
        .tmds_data_p(tmds_data_p),
        .video_de(video_de),
        .video_din(video_din),
        .video_hsync(video_hsync),
        .video_vsync(video_vsync));
endmodule

module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_hdmi_transmitter_v1_0_S00_AXI
   (tmds_data_p,
    tmds_data_n,
    tmds_clk_p,
    tmds_clk_n,
    S_AXI_WREADY,
    S_AXI_AWREADY,
    S_AXI_ARREADY,
    s00_axi_rdata,
    s00_axi_rvalid,
    s00_axi_bvalid,
    pclk_x5,
    video_din,
    pclk,
    video_de,
    video_hsync,
    video_vsync,
    s00_axi_aclk,
    s00_axi_araddr,
    s00_axi_arvalid,
    s00_axi_awaddr,
    s00_axi_wvalid,
    s00_axi_awvalid,
    s00_axi_wdata,
    s00_axi_wstrb,
    s00_axi_aresetn,
    rst_n,
    s00_axi_bready,
    s00_axi_rready);
  output [2:0]tmds_data_p;
  output [2:0]tmds_data_n;
  output tmds_clk_p;
  output tmds_clk_n;
  output S_AXI_WREADY;
  output S_AXI_AWREADY;
  output S_AXI_ARREADY;
  output [31:0]s00_axi_rdata;
  output s00_axi_rvalid;
  output s00_axi_bvalid;
  input pclk_x5;
  input [23:0]video_din;
  input pclk;
  input video_de;
  input video_hsync;
  input video_vsync;
  input s00_axi_aclk;
  input [1:0]s00_axi_araddr;
  input s00_axi_arvalid;
  input [1:0]s00_axi_awaddr;
  input s00_axi_wvalid;
  input s00_axi_awvalid;
  input [31:0]s00_axi_wdata;
  input [3:0]s00_axi_wstrb;
  input s00_axi_aresetn;
  input rst_n;
  input s00_axi_bready;
  input s00_axi_rready;

  wire S_AXI_ARREADY;
  wire S_AXI_AWREADY;
  wire S_AXI_WREADY;
  wire aw_en_i_1_n_0;
  wire aw_en_reg_n_0;
  wire [3:2]axi_araddr;
  wire \axi_araddr[2]_i_1_n_0 ;
  wire \axi_araddr[3]_i_1_n_0 ;
  wire axi_arready0;
  wire [3:2]axi_awaddr;
  wire \axi_awaddr[2]_i_1_n_0 ;
  wire \axi_awaddr[3]_i_1_n_0 ;
  wire axi_awready0;
  wire axi_awready_i_1_n_0;
  wire axi_bvalid_i_1_n_0;
  wire axi_rvalid_i_1_n_0;
  wire axi_wready0;
  wire pclk;
  wire pclk_x5;
  wire [31:0]reg_data_out;
  wire rst_n;
  wire s00_axi_aclk;
  wire [1:0]s00_axi_araddr;
  wire s00_axi_aresetn;
  wire s00_axi_arvalid;
  wire [1:0]s00_axi_awaddr;
  wire s00_axi_awvalid;
  wire s00_axi_bready;
  wire s00_axi_bvalid;
  wire [31:0]s00_axi_rdata;
  wire s00_axi_rready;
  wire s00_axi_rvalid;
  wire [31:0]s00_axi_wdata;
  wire [3:0]s00_axi_wstrb;
  wire s00_axi_wvalid;
  wire [31:0]slv_reg0;
  wire \slv_reg0[15]_i_1_n_0 ;
  wire \slv_reg0[23]_i_1_n_0 ;
  wire \slv_reg0[31]_i_1_n_0 ;
  wire \slv_reg0[7]_i_1_n_0 ;
  wire [31:0]slv_reg1;
  wire \slv_reg1[15]_i_1_n_0 ;
  wire \slv_reg1[23]_i_1_n_0 ;
  wire \slv_reg1[31]_i_1_n_0 ;
  wire \slv_reg1[7]_i_1_n_0 ;
  wire [31:0]slv_reg2;
  wire \slv_reg2[15]_i_1_n_0 ;
  wire \slv_reg2[23]_i_1_n_0 ;
  wire \slv_reg2[31]_i_1_n_0 ;
  wire \slv_reg2[7]_i_1_n_0 ;
  wire [31:0]slv_reg3;
  wire \slv_reg3[15]_i_1_n_0 ;
  wire \slv_reg3[23]_i_1_n_0 ;
  wire \slv_reg3[31]_i_1_n_0 ;
  wire \slv_reg3[7]_i_1_n_0 ;
  wire slv_reg_rden__0;
  wire slv_reg_wren__0;
  wire tmds_clk_n;
  wire tmds_clk_p;
  wire [2:0]tmds_data_n;
  wire [2:0]tmds_data_p;
  wire video_de;
  wire [23:0]video_din;
  wire video_hsync;
  wire video_vsync;

  LUT6 #(
    .INIT(64'hF7FFC4CCC4CCC4CC)) 
    aw_en_i_1
       (.I0(s00_axi_awvalid),
        .I1(aw_en_reg_n_0),
        .I2(S_AXI_AWREADY),
        .I3(s00_axi_wvalid),
        .I4(s00_axi_bready),
        .I5(s00_axi_bvalid),
        .O(aw_en_i_1_n_0));
  FDSE aw_en_reg
       (.C(s00_axi_aclk),
        .CE(1'b1),
        .D(aw_en_i_1_n_0),
        .Q(aw_en_reg_n_0),
        .S(axi_awready_i_1_n_0));
  LUT4 #(
    .INIT(16'hFB08)) 
    \axi_araddr[2]_i_1 
       (.I0(s00_axi_araddr[0]),
        .I1(s00_axi_arvalid),
        .I2(S_AXI_ARREADY),
        .I3(axi_araddr[2]),
        .O(\axi_araddr[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair69" *) 
  LUT4 #(
    .INIT(16'hFB08)) 
    \axi_araddr[3]_i_1 
       (.I0(s00_axi_araddr[1]),
        .I1(s00_axi_arvalid),
        .I2(S_AXI_ARREADY),
        .I3(axi_araddr[3]),
        .O(\axi_araddr[3]_i_1_n_0 ));
  FDRE \axi_araddr_reg[2] 
       (.C(s00_axi_aclk),
        .CE(1'b1),
        .D(\axi_araddr[2]_i_1_n_0 ),
        .Q(axi_araddr[2]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_araddr_reg[3] 
       (.C(s00_axi_aclk),
        .CE(1'b1),
        .D(\axi_araddr[3]_i_1_n_0 ),
        .Q(axi_araddr[3]),
        .R(axi_awready_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair69" *) 
  LUT2 #(
    .INIT(4'h2)) 
    axi_arready_i_1
       (.I0(s00_axi_arvalid),
        .I1(S_AXI_ARREADY),
        .O(axi_arready0));
  FDRE axi_arready_reg
       (.C(s00_axi_aclk),
        .CE(1'b1),
        .D(axi_arready0),
        .Q(S_AXI_ARREADY),
        .R(axi_awready_i_1_n_0));
  LUT6 #(
    .INIT(64'hFBFFFFFF08000000)) 
    \axi_awaddr[2]_i_1 
       (.I0(s00_axi_awaddr[0]),
        .I1(s00_axi_wvalid),
        .I2(S_AXI_AWREADY),
        .I3(aw_en_reg_n_0),
        .I4(s00_axi_awvalid),
        .I5(axi_awaddr[2]),
        .O(\axi_awaddr[2]_i_1_n_0 ));
  LUT6 #(
    .INIT(64'hFBFFFFFF08000000)) 
    \axi_awaddr[3]_i_1 
       (.I0(s00_axi_awaddr[1]),
        .I1(s00_axi_wvalid),
        .I2(S_AXI_AWREADY),
        .I3(aw_en_reg_n_0),
        .I4(s00_axi_awvalid),
        .I5(axi_awaddr[3]),
        .O(\axi_awaddr[3]_i_1_n_0 ));
  FDRE \axi_awaddr_reg[2] 
       (.C(s00_axi_aclk),
        .CE(1'b1),
        .D(\axi_awaddr[2]_i_1_n_0 ),
        .Q(axi_awaddr[2]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_awaddr_reg[3] 
       (.C(s00_axi_aclk),
        .CE(1'b1),
        .D(\axi_awaddr[3]_i_1_n_0 ),
        .Q(axi_awaddr[3]),
        .R(axi_awready_i_1_n_0));
  LUT1 #(
    .INIT(2'h1)) 
    axi_awready_i_1
       (.I0(s00_axi_aresetn),
        .O(axi_awready_i_1_n_0));
  LUT4 #(
    .INIT(16'h2000)) 
    axi_awready_i_2
       (.I0(s00_axi_wvalid),
        .I1(S_AXI_AWREADY),
        .I2(aw_en_reg_n_0),
        .I3(s00_axi_awvalid),
        .O(axi_awready0));
  FDRE axi_awready_reg
       (.C(s00_axi_aclk),
        .CE(1'b1),
        .D(axi_awready0),
        .Q(S_AXI_AWREADY),
        .R(axi_awready_i_1_n_0));
  LUT6 #(
    .INIT(64'h0000FFFF80008000)) 
    axi_bvalid_i_1
       (.I0(s00_axi_awvalid),
        .I1(s00_axi_wvalid),
        .I2(S_AXI_AWREADY),
        .I3(S_AXI_WREADY),
        .I4(s00_axi_bready),
        .I5(s00_axi_bvalid),
        .O(axi_bvalid_i_1_n_0));
  FDRE axi_bvalid_reg
       (.C(s00_axi_aclk),
        .CE(1'b1),
        .D(axi_bvalid_i_1_n_0),
        .Q(s00_axi_bvalid),
        .R(axi_awready_i_1_n_0));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[0]_i_1 
       (.I0(slv_reg1[0]),
        .I1(slv_reg0[0]),
        .I2(slv_reg3[0]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[0]),
        .O(reg_data_out[0]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[10]_i_1 
       (.I0(slv_reg1[10]),
        .I1(slv_reg0[10]),
        .I2(slv_reg3[10]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[10]),
        .O(reg_data_out[10]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[11]_i_1 
       (.I0(slv_reg1[11]),
        .I1(slv_reg0[11]),
        .I2(slv_reg3[11]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[11]),
        .O(reg_data_out[11]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[12]_i_1 
       (.I0(slv_reg1[12]),
        .I1(slv_reg0[12]),
        .I2(slv_reg3[12]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[12]),
        .O(reg_data_out[12]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[13]_i_1 
       (.I0(slv_reg1[13]),
        .I1(slv_reg0[13]),
        .I2(slv_reg3[13]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[13]),
        .O(reg_data_out[13]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[14]_i_1 
       (.I0(slv_reg1[14]),
        .I1(slv_reg0[14]),
        .I2(slv_reg3[14]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[14]),
        .O(reg_data_out[14]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[15]_i_1 
       (.I0(slv_reg1[15]),
        .I1(slv_reg0[15]),
        .I2(slv_reg3[15]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[15]),
        .O(reg_data_out[15]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[16]_i_1 
       (.I0(slv_reg1[16]),
        .I1(slv_reg0[16]),
        .I2(slv_reg3[16]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[16]),
        .O(reg_data_out[16]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[17]_i_1 
       (.I0(slv_reg1[17]),
        .I1(slv_reg0[17]),
        .I2(slv_reg3[17]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[17]),
        .O(reg_data_out[17]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[18]_i_1 
       (.I0(slv_reg1[18]),
        .I1(slv_reg0[18]),
        .I2(slv_reg3[18]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[18]),
        .O(reg_data_out[18]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[19]_i_1 
       (.I0(slv_reg1[19]),
        .I1(slv_reg0[19]),
        .I2(slv_reg3[19]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[19]),
        .O(reg_data_out[19]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[1]_i_1 
       (.I0(slv_reg1[1]),
        .I1(slv_reg0[1]),
        .I2(slv_reg3[1]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[1]),
        .O(reg_data_out[1]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[20]_i_1 
       (.I0(slv_reg1[20]),
        .I1(slv_reg0[20]),
        .I2(slv_reg3[20]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[20]),
        .O(reg_data_out[20]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[21]_i_1 
       (.I0(slv_reg1[21]),
        .I1(slv_reg0[21]),
        .I2(slv_reg3[21]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[21]),
        .O(reg_data_out[21]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[22]_i_1 
       (.I0(slv_reg1[22]),
        .I1(slv_reg0[22]),
        .I2(slv_reg3[22]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[22]),
        .O(reg_data_out[22]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[23]_i_1 
       (.I0(slv_reg1[23]),
        .I1(slv_reg0[23]),
        .I2(slv_reg3[23]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[23]),
        .O(reg_data_out[23]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[24]_i_1 
       (.I0(slv_reg1[24]),
        .I1(slv_reg0[24]),
        .I2(slv_reg3[24]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[24]),
        .O(reg_data_out[24]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[25]_i_1 
       (.I0(slv_reg1[25]),
        .I1(slv_reg0[25]),
        .I2(slv_reg3[25]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[25]),
        .O(reg_data_out[25]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[26]_i_1 
       (.I0(slv_reg1[26]),
        .I1(slv_reg0[26]),
        .I2(slv_reg3[26]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[26]),
        .O(reg_data_out[26]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[27]_i_1 
       (.I0(slv_reg1[27]),
        .I1(slv_reg0[27]),
        .I2(slv_reg3[27]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[27]),
        .O(reg_data_out[27]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[28]_i_1 
       (.I0(slv_reg1[28]),
        .I1(slv_reg0[28]),
        .I2(slv_reg3[28]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[28]),
        .O(reg_data_out[28]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[29]_i_1 
       (.I0(slv_reg1[29]),
        .I1(slv_reg0[29]),
        .I2(slv_reg3[29]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[29]),
        .O(reg_data_out[29]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[2]_i_1 
       (.I0(slv_reg1[2]),
        .I1(slv_reg0[2]),
        .I2(slv_reg3[2]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[2]),
        .O(reg_data_out[2]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[30]_i_1 
       (.I0(slv_reg1[30]),
        .I1(slv_reg0[30]),
        .I2(slv_reg3[30]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[30]),
        .O(reg_data_out[30]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[31]_i_1 
       (.I0(slv_reg1[31]),
        .I1(slv_reg0[31]),
        .I2(slv_reg3[31]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[31]),
        .O(reg_data_out[31]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[3]_i_1 
       (.I0(slv_reg1[3]),
        .I1(slv_reg0[3]),
        .I2(slv_reg3[3]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[3]),
        .O(reg_data_out[3]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[4]_i_1 
       (.I0(slv_reg1[4]),
        .I1(slv_reg0[4]),
        .I2(slv_reg3[4]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[4]),
        .O(reg_data_out[4]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[5]_i_1 
       (.I0(slv_reg1[5]),
        .I1(slv_reg0[5]),
        .I2(slv_reg3[5]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[5]),
        .O(reg_data_out[5]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[6]_i_1 
       (.I0(slv_reg1[6]),
        .I1(slv_reg0[6]),
        .I2(slv_reg3[6]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[6]),
        .O(reg_data_out[6]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[7]_i_1 
       (.I0(slv_reg1[7]),
        .I1(slv_reg0[7]),
        .I2(slv_reg3[7]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[7]),
        .O(reg_data_out[7]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[8]_i_1 
       (.I0(slv_reg1[8]),
        .I1(slv_reg0[8]),
        .I2(slv_reg3[8]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[8]),
        .O(reg_data_out[8]));
  LUT6 #(
    .INIT(64'hF0AAFFCCF0AA00CC)) 
    \axi_rdata[9]_i_1 
       (.I0(slv_reg1[9]),
        .I1(slv_reg0[9]),
        .I2(slv_reg3[9]),
        .I3(axi_araddr[3]),
        .I4(axi_araddr[2]),
        .I5(slv_reg2[9]),
        .O(reg_data_out[9]));
  FDRE \axi_rdata_reg[0] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[0]),
        .Q(s00_axi_rdata[0]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[10] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[10]),
        .Q(s00_axi_rdata[10]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[11] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[11]),
        .Q(s00_axi_rdata[11]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[12] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[12]),
        .Q(s00_axi_rdata[12]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[13] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[13]),
        .Q(s00_axi_rdata[13]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[14] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[14]),
        .Q(s00_axi_rdata[14]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[15] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[15]),
        .Q(s00_axi_rdata[15]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[16] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[16]),
        .Q(s00_axi_rdata[16]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[17] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[17]),
        .Q(s00_axi_rdata[17]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[18] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[18]),
        .Q(s00_axi_rdata[18]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[19] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[19]),
        .Q(s00_axi_rdata[19]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[1] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[1]),
        .Q(s00_axi_rdata[1]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[20] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[20]),
        .Q(s00_axi_rdata[20]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[21] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[21]),
        .Q(s00_axi_rdata[21]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[22] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[22]),
        .Q(s00_axi_rdata[22]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[23] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[23]),
        .Q(s00_axi_rdata[23]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[24] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[24]),
        .Q(s00_axi_rdata[24]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[25] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[25]),
        .Q(s00_axi_rdata[25]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[26] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[26]),
        .Q(s00_axi_rdata[26]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[27] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[27]),
        .Q(s00_axi_rdata[27]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[28] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[28]),
        .Q(s00_axi_rdata[28]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[29] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[29]),
        .Q(s00_axi_rdata[29]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[2] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[2]),
        .Q(s00_axi_rdata[2]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[30] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[30]),
        .Q(s00_axi_rdata[30]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[31] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[31]),
        .Q(s00_axi_rdata[31]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[3] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[3]),
        .Q(s00_axi_rdata[3]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[4] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[4]),
        .Q(s00_axi_rdata[4]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[5] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[5]),
        .Q(s00_axi_rdata[5]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[6] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[6]),
        .Q(s00_axi_rdata[6]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[7] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[7]),
        .Q(s00_axi_rdata[7]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[8] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[8]),
        .Q(s00_axi_rdata[8]),
        .R(axi_awready_i_1_n_0));
  FDRE \axi_rdata_reg[9] 
       (.C(s00_axi_aclk),
        .CE(slv_reg_rden__0),
        .D(reg_data_out[9]),
        .Q(s00_axi_rdata[9]),
        .R(axi_awready_i_1_n_0));
  LUT4 #(
    .INIT(16'h08F8)) 
    axi_rvalid_i_1
       (.I0(S_AXI_ARREADY),
        .I1(s00_axi_arvalid),
        .I2(s00_axi_rvalid),
        .I3(s00_axi_rready),
        .O(axi_rvalid_i_1_n_0));
  FDRE axi_rvalid_reg
       (.C(s00_axi_aclk),
        .CE(1'b1),
        .D(axi_rvalid_i_1_n_0),
        .Q(s00_axi_rvalid),
        .R(axi_awready_i_1_n_0));
  (* SOFT_HLUTNM = "soft_lutpair70" *) 
  LUT4 #(
    .INIT(16'h0800)) 
    axi_wready_i_1
       (.I0(s00_axi_awvalid),
        .I1(s00_axi_wvalid),
        .I2(S_AXI_WREADY),
        .I3(aw_en_reg_n_0),
        .O(axi_wready0));
  FDRE axi_wready_reg
       (.C(s00_axi_aclk),
        .CE(1'b1),
        .D(axi_wready0),
        .Q(S_AXI_WREADY),
        .R(axi_awready_i_1_n_0));
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_hdmi_transmitter hdmi_transmitter_inst
       (.pclk(pclk),
        .pclk_x5(pclk_x5),
        .rst_n(rst_n),
        .tmds_clk_n(tmds_clk_n),
        .tmds_clk_p(tmds_clk_p),
        .tmds_data_n(tmds_data_n),
        .tmds_data_p(tmds_data_p),
        .video_de(video_de),
        .video_din(video_din),
        .video_hsync(video_hsync),
        .video_vsync(video_vsync));
  LUT4 #(
    .INIT(16'h0200)) 
    \slv_reg0[15]_i_1 
       (.I0(slv_reg_wren__0),
        .I1(axi_awaddr[3]),
        .I2(axi_awaddr[2]),
        .I3(s00_axi_wstrb[1]),
        .O(\slv_reg0[15]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h0200)) 
    \slv_reg0[23]_i_1 
       (.I0(slv_reg_wren__0),
        .I1(axi_awaddr[3]),
        .I2(axi_awaddr[2]),
        .I3(s00_axi_wstrb[2]),
        .O(\slv_reg0[23]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h0200)) 
    \slv_reg0[31]_i_1 
       (.I0(slv_reg_wren__0),
        .I1(axi_awaddr[3]),
        .I2(axi_awaddr[2]),
        .I3(s00_axi_wstrb[3]),
        .O(\slv_reg0[31]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h0200)) 
    \slv_reg0[7]_i_1 
       (.I0(slv_reg_wren__0),
        .I1(axi_awaddr[3]),
        .I2(axi_awaddr[2]),
        .I3(s00_axi_wstrb[0]),
        .O(\slv_reg0[7]_i_1_n_0 ));
  FDRE \slv_reg0_reg[0] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[7]_i_1_n_0 ),
        .D(s00_axi_wdata[0]),
        .Q(slv_reg0[0]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[10] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[15]_i_1_n_0 ),
        .D(s00_axi_wdata[10]),
        .Q(slv_reg0[10]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[11] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[15]_i_1_n_0 ),
        .D(s00_axi_wdata[11]),
        .Q(slv_reg0[11]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[12] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[15]_i_1_n_0 ),
        .D(s00_axi_wdata[12]),
        .Q(slv_reg0[12]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[13] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[15]_i_1_n_0 ),
        .D(s00_axi_wdata[13]),
        .Q(slv_reg0[13]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[14] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[15]_i_1_n_0 ),
        .D(s00_axi_wdata[14]),
        .Q(slv_reg0[14]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[15] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[15]_i_1_n_0 ),
        .D(s00_axi_wdata[15]),
        .Q(slv_reg0[15]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[16] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[23]_i_1_n_0 ),
        .D(s00_axi_wdata[16]),
        .Q(slv_reg0[16]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[17] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[23]_i_1_n_0 ),
        .D(s00_axi_wdata[17]),
        .Q(slv_reg0[17]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[18] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[23]_i_1_n_0 ),
        .D(s00_axi_wdata[18]),
        .Q(slv_reg0[18]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[19] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[23]_i_1_n_0 ),
        .D(s00_axi_wdata[19]),
        .Q(slv_reg0[19]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[1] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[7]_i_1_n_0 ),
        .D(s00_axi_wdata[1]),
        .Q(slv_reg0[1]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[20] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[23]_i_1_n_0 ),
        .D(s00_axi_wdata[20]),
        .Q(slv_reg0[20]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[21] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[23]_i_1_n_0 ),
        .D(s00_axi_wdata[21]),
        .Q(slv_reg0[21]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[22] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[23]_i_1_n_0 ),
        .D(s00_axi_wdata[22]),
        .Q(slv_reg0[22]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[23] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[23]_i_1_n_0 ),
        .D(s00_axi_wdata[23]),
        .Q(slv_reg0[23]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[24] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[31]_i_1_n_0 ),
        .D(s00_axi_wdata[24]),
        .Q(slv_reg0[24]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[25] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[31]_i_1_n_0 ),
        .D(s00_axi_wdata[25]),
        .Q(slv_reg0[25]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[26] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[31]_i_1_n_0 ),
        .D(s00_axi_wdata[26]),
        .Q(slv_reg0[26]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[27] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[31]_i_1_n_0 ),
        .D(s00_axi_wdata[27]),
        .Q(slv_reg0[27]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[28] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[31]_i_1_n_0 ),
        .D(s00_axi_wdata[28]),
        .Q(slv_reg0[28]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[29] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[31]_i_1_n_0 ),
        .D(s00_axi_wdata[29]),
        .Q(slv_reg0[29]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[2] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[7]_i_1_n_0 ),
        .D(s00_axi_wdata[2]),
        .Q(slv_reg0[2]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[30] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[31]_i_1_n_0 ),
        .D(s00_axi_wdata[30]),
        .Q(slv_reg0[30]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[31] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[31]_i_1_n_0 ),
        .D(s00_axi_wdata[31]),
        .Q(slv_reg0[31]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[3] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[7]_i_1_n_0 ),
        .D(s00_axi_wdata[3]),
        .Q(slv_reg0[3]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[4] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[7]_i_1_n_0 ),
        .D(s00_axi_wdata[4]),
        .Q(slv_reg0[4]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[5] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[7]_i_1_n_0 ),
        .D(s00_axi_wdata[5]),
        .Q(slv_reg0[5]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[6] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[7]_i_1_n_0 ),
        .D(s00_axi_wdata[6]),
        .Q(slv_reg0[6]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[7] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[7]_i_1_n_0 ),
        .D(s00_axi_wdata[7]),
        .Q(slv_reg0[7]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[8] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[15]_i_1_n_0 ),
        .D(s00_axi_wdata[8]),
        .Q(slv_reg0[8]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg0_reg[9] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg0[15]_i_1_n_0 ),
        .D(s00_axi_wdata[9]),
        .Q(slv_reg0[9]),
        .R(axi_awready_i_1_n_0));
  LUT4 #(
    .INIT(16'h2000)) 
    \slv_reg1[15]_i_1 
       (.I0(slv_reg_wren__0),
        .I1(axi_awaddr[3]),
        .I2(s00_axi_wstrb[1]),
        .I3(axi_awaddr[2]),
        .O(\slv_reg1[15]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h2000)) 
    \slv_reg1[23]_i_1 
       (.I0(slv_reg_wren__0),
        .I1(axi_awaddr[3]),
        .I2(s00_axi_wstrb[2]),
        .I3(axi_awaddr[2]),
        .O(\slv_reg1[23]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h2000)) 
    \slv_reg1[31]_i_1 
       (.I0(slv_reg_wren__0),
        .I1(axi_awaddr[3]),
        .I2(s00_axi_wstrb[3]),
        .I3(axi_awaddr[2]),
        .O(\slv_reg1[31]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h2000)) 
    \slv_reg1[7]_i_1 
       (.I0(slv_reg_wren__0),
        .I1(axi_awaddr[3]),
        .I2(s00_axi_wstrb[0]),
        .I3(axi_awaddr[2]),
        .O(\slv_reg1[7]_i_1_n_0 ));
  FDRE \slv_reg1_reg[0] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg1[7]_i_1_n_0 ),
        .D(s00_axi_wdata[0]),
        .Q(slv_reg1[0]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[10] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg1[15]_i_1_n_0 ),
        .D(s00_axi_wdata[10]),
        .Q(slv_reg1[10]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[11] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg1[15]_i_1_n_0 ),
        .D(s00_axi_wdata[11]),
        .Q(slv_reg1[11]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[12] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg1[15]_i_1_n_0 ),
        .D(s00_axi_wdata[12]),
        .Q(slv_reg1[12]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[13] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg1[15]_i_1_n_0 ),
        .D(s00_axi_wdata[13]),
        .Q(slv_reg1[13]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[14] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg1[15]_i_1_n_0 ),
        .D(s00_axi_wdata[14]),
        .Q(slv_reg1[14]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[15] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg1[15]_i_1_n_0 ),
        .D(s00_axi_wdata[15]),
        .Q(slv_reg1[15]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[16] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg1[23]_i_1_n_0 ),
        .D(s00_axi_wdata[16]),
        .Q(slv_reg1[16]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[17] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg1[23]_i_1_n_0 ),
        .D(s00_axi_wdata[17]),
        .Q(slv_reg1[17]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[18] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg1[23]_i_1_n_0 ),
        .D(s00_axi_wdata[18]),
        .Q(slv_reg1[18]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[19] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg1[23]_i_1_n_0 ),
        .D(s00_axi_wdata[19]),
        .Q(slv_reg1[19]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[1] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg1[7]_i_1_n_0 ),
        .D(s00_axi_wdata[1]),
        .Q(slv_reg1[1]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[20] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg1[23]_i_1_n_0 ),
        .D(s00_axi_wdata[20]),
        .Q(slv_reg1[20]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[21] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg1[23]_i_1_n_0 ),
        .D(s00_axi_wdata[21]),
        .Q(slv_reg1[21]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[22] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg1[23]_i_1_n_0 ),
        .D(s00_axi_wdata[22]),
        .Q(slv_reg1[22]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[23] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg1[23]_i_1_n_0 ),
        .D(s00_axi_wdata[23]),
        .Q(slv_reg1[23]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[24] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg1[31]_i_1_n_0 ),
        .D(s00_axi_wdata[24]),
        .Q(slv_reg1[24]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[25] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg1[31]_i_1_n_0 ),
        .D(s00_axi_wdata[25]),
        .Q(slv_reg1[25]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[26] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg1[31]_i_1_n_0 ),
        .D(s00_axi_wdata[26]),
        .Q(slv_reg1[26]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[27] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg1[31]_i_1_n_0 ),
        .D(s00_axi_wdata[27]),
        .Q(slv_reg1[27]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[28] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg1[31]_i_1_n_0 ),
        .D(s00_axi_wdata[28]),
        .Q(slv_reg1[28]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[29] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg1[31]_i_1_n_0 ),
        .D(s00_axi_wdata[29]),
        .Q(slv_reg1[29]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[2] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg1[7]_i_1_n_0 ),
        .D(s00_axi_wdata[2]),
        .Q(slv_reg1[2]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[30] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg1[31]_i_1_n_0 ),
        .D(s00_axi_wdata[30]),
        .Q(slv_reg1[30]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[31] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg1[31]_i_1_n_0 ),
        .D(s00_axi_wdata[31]),
        .Q(slv_reg1[31]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[3] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg1[7]_i_1_n_0 ),
        .D(s00_axi_wdata[3]),
        .Q(slv_reg1[3]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[4] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg1[7]_i_1_n_0 ),
        .D(s00_axi_wdata[4]),
        .Q(slv_reg1[4]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[5] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg1[7]_i_1_n_0 ),
        .D(s00_axi_wdata[5]),
        .Q(slv_reg1[5]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[6] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg1[7]_i_1_n_0 ),
        .D(s00_axi_wdata[6]),
        .Q(slv_reg1[6]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[7] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg1[7]_i_1_n_0 ),
        .D(s00_axi_wdata[7]),
        .Q(slv_reg1[7]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[8] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg1[15]_i_1_n_0 ),
        .D(s00_axi_wdata[8]),
        .Q(slv_reg1[8]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg1_reg[9] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg1[15]_i_1_n_0 ),
        .D(s00_axi_wdata[9]),
        .Q(slv_reg1[9]),
        .R(axi_awready_i_1_n_0));
  LUT4 #(
    .INIT(16'h0080)) 
    \slv_reg2[15]_i_1 
       (.I0(slv_reg_wren__0),
        .I1(axi_awaddr[3]),
        .I2(s00_axi_wstrb[1]),
        .I3(axi_awaddr[2]),
        .O(\slv_reg2[15]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h0080)) 
    \slv_reg2[23]_i_1 
       (.I0(slv_reg_wren__0),
        .I1(axi_awaddr[3]),
        .I2(s00_axi_wstrb[2]),
        .I3(axi_awaddr[2]),
        .O(\slv_reg2[23]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h0080)) 
    \slv_reg2[31]_i_1 
       (.I0(slv_reg_wren__0),
        .I1(axi_awaddr[3]),
        .I2(s00_axi_wstrb[3]),
        .I3(axi_awaddr[2]),
        .O(\slv_reg2[31]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h0080)) 
    \slv_reg2[7]_i_1 
       (.I0(slv_reg_wren__0),
        .I1(axi_awaddr[3]),
        .I2(s00_axi_wstrb[0]),
        .I3(axi_awaddr[2]),
        .O(\slv_reg2[7]_i_1_n_0 ));
  FDRE \slv_reg2_reg[0] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg2[7]_i_1_n_0 ),
        .D(s00_axi_wdata[0]),
        .Q(slv_reg2[0]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[10] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg2[15]_i_1_n_0 ),
        .D(s00_axi_wdata[10]),
        .Q(slv_reg2[10]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[11] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg2[15]_i_1_n_0 ),
        .D(s00_axi_wdata[11]),
        .Q(slv_reg2[11]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[12] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg2[15]_i_1_n_0 ),
        .D(s00_axi_wdata[12]),
        .Q(slv_reg2[12]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[13] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg2[15]_i_1_n_0 ),
        .D(s00_axi_wdata[13]),
        .Q(slv_reg2[13]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[14] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg2[15]_i_1_n_0 ),
        .D(s00_axi_wdata[14]),
        .Q(slv_reg2[14]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[15] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg2[15]_i_1_n_0 ),
        .D(s00_axi_wdata[15]),
        .Q(slv_reg2[15]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[16] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg2[23]_i_1_n_0 ),
        .D(s00_axi_wdata[16]),
        .Q(slv_reg2[16]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[17] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg2[23]_i_1_n_0 ),
        .D(s00_axi_wdata[17]),
        .Q(slv_reg2[17]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[18] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg2[23]_i_1_n_0 ),
        .D(s00_axi_wdata[18]),
        .Q(slv_reg2[18]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[19] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg2[23]_i_1_n_0 ),
        .D(s00_axi_wdata[19]),
        .Q(slv_reg2[19]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[1] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg2[7]_i_1_n_0 ),
        .D(s00_axi_wdata[1]),
        .Q(slv_reg2[1]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[20] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg2[23]_i_1_n_0 ),
        .D(s00_axi_wdata[20]),
        .Q(slv_reg2[20]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[21] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg2[23]_i_1_n_0 ),
        .D(s00_axi_wdata[21]),
        .Q(slv_reg2[21]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[22] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg2[23]_i_1_n_0 ),
        .D(s00_axi_wdata[22]),
        .Q(slv_reg2[22]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[23] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg2[23]_i_1_n_0 ),
        .D(s00_axi_wdata[23]),
        .Q(slv_reg2[23]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[24] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg2[31]_i_1_n_0 ),
        .D(s00_axi_wdata[24]),
        .Q(slv_reg2[24]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[25] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg2[31]_i_1_n_0 ),
        .D(s00_axi_wdata[25]),
        .Q(slv_reg2[25]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[26] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg2[31]_i_1_n_0 ),
        .D(s00_axi_wdata[26]),
        .Q(slv_reg2[26]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[27] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg2[31]_i_1_n_0 ),
        .D(s00_axi_wdata[27]),
        .Q(slv_reg2[27]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[28] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg2[31]_i_1_n_0 ),
        .D(s00_axi_wdata[28]),
        .Q(slv_reg2[28]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[29] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg2[31]_i_1_n_0 ),
        .D(s00_axi_wdata[29]),
        .Q(slv_reg2[29]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[2] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg2[7]_i_1_n_0 ),
        .D(s00_axi_wdata[2]),
        .Q(slv_reg2[2]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[30] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg2[31]_i_1_n_0 ),
        .D(s00_axi_wdata[30]),
        .Q(slv_reg2[30]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[31] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg2[31]_i_1_n_0 ),
        .D(s00_axi_wdata[31]),
        .Q(slv_reg2[31]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[3] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg2[7]_i_1_n_0 ),
        .D(s00_axi_wdata[3]),
        .Q(slv_reg2[3]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[4] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg2[7]_i_1_n_0 ),
        .D(s00_axi_wdata[4]),
        .Q(slv_reg2[4]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[5] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg2[7]_i_1_n_0 ),
        .D(s00_axi_wdata[5]),
        .Q(slv_reg2[5]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[6] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg2[7]_i_1_n_0 ),
        .D(s00_axi_wdata[6]),
        .Q(slv_reg2[6]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[7] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg2[7]_i_1_n_0 ),
        .D(s00_axi_wdata[7]),
        .Q(slv_reg2[7]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[8] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg2[15]_i_1_n_0 ),
        .D(s00_axi_wdata[8]),
        .Q(slv_reg2[8]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg2_reg[9] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg2[15]_i_1_n_0 ),
        .D(s00_axi_wdata[9]),
        .Q(slv_reg2[9]),
        .R(axi_awready_i_1_n_0));
  LUT4 #(
    .INIT(16'h8000)) 
    \slv_reg3[15]_i_1 
       (.I0(slv_reg_wren__0),
        .I1(s00_axi_wstrb[1]),
        .I2(axi_awaddr[2]),
        .I3(axi_awaddr[3]),
        .O(\slv_reg3[15]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h8000)) 
    \slv_reg3[23]_i_1 
       (.I0(slv_reg_wren__0),
        .I1(s00_axi_wstrb[2]),
        .I2(axi_awaddr[2]),
        .I3(axi_awaddr[3]),
        .O(\slv_reg3[23]_i_1_n_0 ));
  LUT4 #(
    .INIT(16'h8000)) 
    \slv_reg3[31]_i_1 
       (.I0(slv_reg_wren__0),
        .I1(s00_axi_wstrb[3]),
        .I2(axi_awaddr[2]),
        .I3(axi_awaddr[3]),
        .O(\slv_reg3[31]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair70" *) 
  LUT4 #(
    .INIT(16'h8000)) 
    \slv_reg3[31]_i_2 
       (.I0(S_AXI_WREADY),
        .I1(S_AXI_AWREADY),
        .I2(s00_axi_awvalid),
        .I3(s00_axi_wvalid),
        .O(slv_reg_wren__0));
  LUT4 #(
    .INIT(16'h8000)) 
    \slv_reg3[7]_i_1 
       (.I0(slv_reg_wren__0),
        .I1(s00_axi_wstrb[0]),
        .I2(axi_awaddr[2]),
        .I3(axi_awaddr[3]),
        .O(\slv_reg3[7]_i_1_n_0 ));
  FDRE \slv_reg3_reg[0] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[7]_i_1_n_0 ),
        .D(s00_axi_wdata[0]),
        .Q(slv_reg3[0]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[10] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(s00_axi_wdata[10]),
        .Q(slv_reg3[10]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[11] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(s00_axi_wdata[11]),
        .Q(slv_reg3[11]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[12] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(s00_axi_wdata[12]),
        .Q(slv_reg3[12]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[13] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(s00_axi_wdata[13]),
        .Q(slv_reg3[13]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[14] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(s00_axi_wdata[14]),
        .Q(slv_reg3[14]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[15] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(s00_axi_wdata[15]),
        .Q(slv_reg3[15]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[16] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(s00_axi_wdata[16]),
        .Q(slv_reg3[16]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[17] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(s00_axi_wdata[17]),
        .Q(slv_reg3[17]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[18] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(s00_axi_wdata[18]),
        .Q(slv_reg3[18]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[19] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(s00_axi_wdata[19]),
        .Q(slv_reg3[19]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[1] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[7]_i_1_n_0 ),
        .D(s00_axi_wdata[1]),
        .Q(slv_reg3[1]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[20] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(s00_axi_wdata[20]),
        .Q(slv_reg3[20]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[21] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(s00_axi_wdata[21]),
        .Q(slv_reg3[21]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[22] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(s00_axi_wdata[22]),
        .Q(slv_reg3[22]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[23] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[23]_i_1_n_0 ),
        .D(s00_axi_wdata[23]),
        .Q(slv_reg3[23]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[24] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(s00_axi_wdata[24]),
        .Q(slv_reg3[24]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[25] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(s00_axi_wdata[25]),
        .Q(slv_reg3[25]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[26] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(s00_axi_wdata[26]),
        .Q(slv_reg3[26]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[27] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(s00_axi_wdata[27]),
        .Q(slv_reg3[27]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[28] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(s00_axi_wdata[28]),
        .Q(slv_reg3[28]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[29] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(s00_axi_wdata[29]),
        .Q(slv_reg3[29]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[2] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[7]_i_1_n_0 ),
        .D(s00_axi_wdata[2]),
        .Q(slv_reg3[2]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[30] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(s00_axi_wdata[30]),
        .Q(slv_reg3[30]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[31] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[31]_i_1_n_0 ),
        .D(s00_axi_wdata[31]),
        .Q(slv_reg3[31]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[3] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[7]_i_1_n_0 ),
        .D(s00_axi_wdata[3]),
        .Q(slv_reg3[3]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[4] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[7]_i_1_n_0 ),
        .D(s00_axi_wdata[4]),
        .Q(slv_reg3[4]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[5] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[7]_i_1_n_0 ),
        .D(s00_axi_wdata[5]),
        .Q(slv_reg3[5]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[6] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[7]_i_1_n_0 ),
        .D(s00_axi_wdata[6]),
        .Q(slv_reg3[6]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[7] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[7]_i_1_n_0 ),
        .D(s00_axi_wdata[7]),
        .Q(slv_reg3[7]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[8] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(s00_axi_wdata[8]),
        .Q(slv_reg3[8]),
        .R(axi_awready_i_1_n_0));
  FDRE \slv_reg3_reg[9] 
       (.C(s00_axi_aclk),
        .CE(\slv_reg3[15]_i_1_n_0 ),
        .D(s00_axi_wdata[9]),
        .Q(slv_reg3[9]),
        .R(axi_awready_i_1_n_0));
  LUT3 #(
    .INIT(8'h20)) 
    slv_reg_rden
       (.I0(s00_axi_arvalid),
        .I1(s00_axi_rvalid),
        .I2(S_AXI_ARREADY),
        .O(slv_reg_rden__0));
endmodule

module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_par_to_ser
   (tmds_data_p,
    tmds_data_n,
    C00,
    pclk_x5,
    \data_fall_s_reg[4]_0 );
  output [0:0]tmds_data_p;
  output [0:0]tmds_data_n;
  input C00;
  input pclk_x5;
  input [9:0]\data_fall_s_reg[4]_0 ;

  wire C00;
  wire \cnt[0]_i_1_n_0 ;
  wire \cnt[1]_i_1__2_n_0 ;
  wire \cnt[2]_i_1__2_n_0 ;
  wire \cnt_reg_n_0_[0] ;
  wire \cnt_reg_n_0_[1] ;
  wire data;
  wire [0:0]data_fall_s;
  wire \data_fall_s[0]_i_1_n_0 ;
  wire \data_fall_s[1]_i_1_n_0 ;
  wire \data_fall_s[2]_i_1_n_0 ;
  wire \data_fall_s[3]_i_1_n_0 ;
  wire \data_fall_s[4]_i_1_n_0 ;
  wire [9:0]\data_fall_s_reg[4]_0 ;
  wire \data_fall_s_reg_n_0_[1] ;
  wire \data_fall_s_reg_n_0_[2] ;
  wire \data_fall_s_reg_n_0_[3] ;
  wire \data_fall_s_reg_n_0_[4] ;
  wire \data_rise_s[0]_i_1_n_0 ;
  wire \data_rise_s[1]_i_1_n_0 ;
  wire \data_rise_s[2]_i_1_n_0 ;
  wire \data_rise_s[3]_i_1_n_0 ;
  wire \data_rise_s[4]_i_1_n_0 ;
  wire \data_rise_s_reg_n_0_[0] ;
  wire \data_rise_s_reg_n_0_[1] ;
  wire \data_rise_s_reg_n_0_[2] ;
  wire \data_rise_s_reg_n_0_[3] ;
  wire \data_rise_s_reg_n_0_[4] ;
  wire p_4_in;
  wire pclk_x5;
  wire [0:0]tmds_data_n;
  wire [0:0]tmds_data_p;
  wire NLW_ODDR2_inst0_R_UNCONNECTED;
  wire NLW_ODDR2_inst0_S_UNCONNECTED;

  (* BOX_TYPE = "PRIMITIVE" *) 
  (* CAPACITANCE = "DONT_CARE" *) 
  OBUFDS OBUFDS_inst
       (.I(data),
        .O(tmds_data_p),
        .OB(tmds_data_n));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "MLO" *) 
  (* XILINX_LEGACY_PRIM = "ODDR2" *) 
  (* XILINX_TRANSFORM_PINMAP = "D0:D1 D1:D2 C0:C" *) 
  (* __SRVAL = "TRUE" *) 
  ODDR #(
    .DDR_CLK_EDGE("OPPOSITE_EDGE"),
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1),
    .SRTYPE("SYNC")) 
    ODDR2_inst0
       (.C(C00),
        .CE(1'b1),
        .D1(\data_rise_s_reg_n_0_[0] ),
        .D2(data_fall_s),
        .Q(data),
        .R(NLW_ODDR2_inst0_R_UNCONNECTED),
        .S(NLW_ODDR2_inst0_S_UNCONNECTED));
  (* SOFT_HLUTNM = "soft_lutpair50" *) 
  LUT2 #(
    .INIT(4'h1)) 
    \cnt[0]_i_1 
       (.I0(p_4_in),
        .I1(\cnt_reg_n_0_[0] ),
        .O(\cnt[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair49" *) 
  LUT3 #(
    .INIT(8'h06)) 
    \cnt[1]_i_1__2 
       (.I0(\cnt_reg_n_0_[1] ),
        .I1(\cnt_reg_n_0_[0] ),
        .I2(p_4_in),
        .O(\cnt[1]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair49" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \cnt[2]_i_1__2 
       (.I0(\cnt_reg_n_0_[1] ),
        .I1(\cnt_reg_n_0_[0] ),
        .I2(p_4_in),
        .O(\cnt[2]_i_1__2_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[0] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\cnt[0]_i_1_n_0 ),
        .Q(\cnt_reg_n_0_[0] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[1] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\cnt[1]_i_1__2_n_0 ),
        .Q(\cnt_reg_n_0_[1] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[2] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\cnt[2]_i_1__2_n_0 ),
        .Q(p_4_in),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair53" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \data_fall_s[0]_i_1 
       (.I0(\data_fall_s_reg[4]_0 [1]),
        .I1(p_4_in),
        .I2(\data_fall_s_reg_n_0_[1] ),
        .O(\data_fall_s[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair53" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \data_fall_s[1]_i_1 
       (.I0(\data_fall_s_reg[4]_0 [3]),
        .I1(p_4_in),
        .I2(\data_fall_s_reg_n_0_[2] ),
        .O(\data_fall_s[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair54" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \data_fall_s[2]_i_1 
       (.I0(\data_fall_s_reg[4]_0 [5]),
        .I1(p_4_in),
        .I2(\data_fall_s_reg_n_0_[3] ),
        .O(\data_fall_s[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair54" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \data_fall_s[3]_i_1 
       (.I0(\data_fall_s_reg[4]_0 [7]),
        .I1(p_4_in),
        .I2(\data_fall_s_reg_n_0_[4] ),
        .O(\data_fall_s[3]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    \data_fall_s[4]_i_1 
       (.I0(p_4_in),
        .I1(\data_fall_s_reg[4]_0 [9]),
        .O(\data_fall_s[4]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \data_fall_s_reg[0] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\data_fall_s[0]_i_1_n_0 ),
        .Q(data_fall_s),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \data_fall_s_reg[1] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\data_fall_s[1]_i_1_n_0 ),
        .Q(\data_fall_s_reg_n_0_[1] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \data_fall_s_reg[2] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\data_fall_s[2]_i_1_n_0 ),
        .Q(\data_fall_s_reg_n_0_[2] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \data_fall_s_reg[3] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\data_fall_s[3]_i_1_n_0 ),
        .Q(\data_fall_s_reg_n_0_[3] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \data_fall_s_reg[4] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\data_fall_s[4]_i_1_n_0 ),
        .Q(\data_fall_s_reg_n_0_[4] ),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair50" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \data_rise_s[0]_i_1 
       (.I0(\data_fall_s_reg[4]_0 [0]),
        .I1(p_4_in),
        .I2(\data_rise_s_reg_n_0_[1] ),
        .O(\data_rise_s[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair51" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \data_rise_s[1]_i_1 
       (.I0(\data_fall_s_reg[4]_0 [2]),
        .I1(p_4_in),
        .I2(\data_rise_s_reg_n_0_[2] ),
        .O(\data_rise_s[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair51" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \data_rise_s[2]_i_1 
       (.I0(\data_fall_s_reg[4]_0 [4]),
        .I1(p_4_in),
        .I2(\data_rise_s_reg_n_0_[3] ),
        .O(\data_rise_s[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair52" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \data_rise_s[3]_i_1 
       (.I0(\data_fall_s_reg[4]_0 [6]),
        .I1(p_4_in),
        .I2(\data_rise_s_reg_n_0_[4] ),
        .O(\data_rise_s[3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair52" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \data_rise_s[4]_i_1 
       (.I0(p_4_in),
        .I1(\data_fall_s_reg[4]_0 [8]),
        .O(\data_rise_s[4]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \data_rise_s_reg[0] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\data_rise_s[0]_i_1_n_0 ),
        .Q(\data_rise_s_reg_n_0_[0] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \data_rise_s_reg[1] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\data_rise_s[1]_i_1_n_0 ),
        .Q(\data_rise_s_reg_n_0_[1] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \data_rise_s_reg[2] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\data_rise_s[2]_i_1_n_0 ),
        .Q(\data_rise_s_reg_n_0_[2] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \data_rise_s_reg[3] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\data_rise_s[3]_i_1_n_0 ),
        .Q(\data_rise_s_reg_n_0_[3] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \data_rise_s_reg[4] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\data_rise_s[4]_i_1_n_0 ),
        .Q(\data_rise_s_reg_n_0_[4] ),
        .R(1'b0));
endmodule

(* ORIG_REF_NAME = "par_to_ser" *) 
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_par_to_ser_2
   (tmds_clk_p,
    tmds_clk_n,
    C00,
    pclk_x5);
  output tmds_clk_p;
  output tmds_clk_n;
  input C00;
  input pclk_x5;

  wire C00;
  wire \cnt[0]_i_1__2_n_0 ;
  wire \cnt[1]_i_1__5_n_0 ;
  wire \cnt[2]_i_1__5_n_0 ;
  wire \cnt_reg_n_0_[0] ;
  wire \cnt_reg_n_0_[1] ;
  wire data;
  wire [0:0]data_fall_s;
  wire \data_fall_s[2]_i_1_n_0 ;
  wire \data_fall_s_reg_n_0_[1] ;
  wire \data_fall_s_reg_n_0_[2] ;
  wire \data_rise_s[3]_i_1_n_0 ;
  wire \data_rise_s_reg_n_0_[0] ;
  wire \data_rise_s_reg_n_0_[1] ;
  wire \data_rise_s_reg_n_0_[2] ;
  wire \data_rise_s_reg_n_0_[3] ;
  wire \data_rise_s_reg_n_0_[4] ;
  wire p_4_in;
  wire pclk_x5;
  wire tmds_clk_n;
  wire tmds_clk_p;
  wire NLW_ODDR2_inst0_R_UNCONNECTED;
  wire NLW_ODDR2_inst0_S_UNCONNECTED;

  (* BOX_TYPE = "PRIMITIVE" *) 
  (* CAPACITANCE = "DONT_CARE" *) 
  OBUFDS OBUFDS_inst
       (.I(data),
        .O(tmds_clk_p),
        .OB(tmds_clk_n));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "MLO" *) 
  (* XILINX_LEGACY_PRIM = "ODDR2" *) 
  (* XILINX_TRANSFORM_PINMAP = "D0:D1 D1:D2 C0:C" *) 
  (* __SRVAL = "TRUE" *) 
  ODDR #(
    .DDR_CLK_EDGE("OPPOSITE_EDGE"),
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1),
    .SRTYPE("SYNC")) 
    ODDR2_inst0
       (.C(C00),
        .CE(1'b1),
        .D1(\data_rise_s_reg_n_0_[0] ),
        .D2(data_fall_s),
        .Q(data),
        .R(NLW_ODDR2_inst0_R_UNCONNECTED),
        .S(NLW_ODDR2_inst0_S_UNCONNECTED));
  (* SOFT_HLUTNM = "soft_lutpair56" *) 
  LUT2 #(
    .INIT(4'h1)) 
    \cnt[0]_i_1__2 
       (.I0(p_4_in),
        .I1(\cnt_reg_n_0_[0] ),
        .O(\cnt[0]_i_1__2_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair55" *) 
  LUT3 #(
    .INIT(8'h06)) 
    \cnt[1]_i_1__5 
       (.I0(\cnt_reg_n_0_[1] ),
        .I1(\cnt_reg_n_0_[0] ),
        .I2(p_4_in),
        .O(\cnt[1]_i_1__5_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair55" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \cnt[2]_i_1__5 
       (.I0(\cnt_reg_n_0_[1] ),
        .I1(\cnt_reg_n_0_[0] ),
        .I2(p_4_in),
        .O(\cnt[2]_i_1__5_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[0] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\cnt[0]_i_1__2_n_0 ),
        .Q(\cnt_reg_n_0_[0] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[1] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\cnt[1]_i_1__5_n_0 ),
        .Q(\cnt_reg_n_0_[1] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[2] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\cnt[2]_i_1__5_n_0 ),
        .Q(p_4_in),
        .R(1'b0));
  LUT2 #(
    .INIT(4'hE)) 
    \data_fall_s[2]_i_1 
       (.I0(p_4_in),
        .I1(\data_rise_s_reg_n_0_[3] ),
        .O(\data_fall_s[2]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \data_fall_s_reg[0] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\data_fall_s_reg_n_0_[1] ),
        .Q(data_fall_s),
        .R(p_4_in));
  FDRE #(
    .INIT(1'b0)) 
    \data_fall_s_reg[1] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\data_fall_s_reg_n_0_[2] ),
        .Q(\data_fall_s_reg_n_0_[1] ),
        .R(p_4_in));
  FDRE #(
    .INIT(1'b0)) 
    \data_fall_s_reg[2] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\data_fall_s[2]_i_1_n_0 ),
        .Q(\data_fall_s_reg_n_0_[2] ),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair56" *) 
  LUT2 #(
    .INIT(4'hE)) 
    \data_rise_s[3]_i_1 
       (.I0(p_4_in),
        .I1(\data_rise_s_reg_n_0_[4] ),
        .O(\data_rise_s[3]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \data_rise_s_reg[0] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\data_rise_s_reg_n_0_[1] ),
        .Q(\data_rise_s_reg_n_0_[0] ),
        .R(p_4_in));
  FDRE #(
    .INIT(1'b0)) 
    \data_rise_s_reg[1] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\data_rise_s_reg_n_0_[2] ),
        .Q(\data_rise_s_reg_n_0_[1] ),
        .R(p_4_in));
  FDRE #(
    .INIT(1'b0)) 
    \data_rise_s_reg[2] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\data_rise_s_reg_n_0_[3] ),
        .Q(\data_rise_s_reg_n_0_[2] ),
        .R(p_4_in));
  FDRE #(
    .INIT(1'b0)) 
    \data_rise_s_reg[3] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\data_rise_s[3]_i_1_n_0 ),
        .Q(\data_rise_s_reg_n_0_[3] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \data_rise_s_reg[4] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(p_4_in),
        .Q(\data_rise_s_reg_n_0_[4] ),
        .R(1'b0));
endmodule

(* ORIG_REF_NAME = "par_to_ser" *) 
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_par_to_ser_3
   (tmds_data_p,
    tmds_data_n,
    C00,
    pclk_x5,
    \data_fall_s_reg[4]_0 );
  output [0:0]tmds_data_p;
  output [0:0]tmds_data_n;
  input C00;
  input pclk_x5;
  input [9:0]\data_fall_s_reg[4]_0 ;

  wire C00;
  wire \cnt[0]_i_1__0_n_0 ;
  wire \cnt[1]_i_1__3_n_0 ;
  wire \cnt[2]_i_1__3_n_0 ;
  wire \cnt_reg_n_0_[0] ;
  wire \cnt_reg_n_0_[1] ;
  wire data;
  wire [0:0]data_fall_s;
  wire \data_fall_s[0]_i_1_n_0 ;
  wire \data_fall_s[1]_i_1_n_0 ;
  wire \data_fall_s[2]_i_1_n_0 ;
  wire \data_fall_s[3]_i_1_n_0 ;
  wire \data_fall_s[4]_i_1_n_0 ;
  wire [9:0]\data_fall_s_reg[4]_0 ;
  wire \data_fall_s_reg_n_0_[1] ;
  wire \data_fall_s_reg_n_0_[2] ;
  wire \data_fall_s_reg_n_0_[3] ;
  wire \data_fall_s_reg_n_0_[4] ;
  wire \data_rise_s[0]_i_1_n_0 ;
  wire \data_rise_s[1]_i_1_n_0 ;
  wire \data_rise_s[2]_i_1_n_0 ;
  wire \data_rise_s[3]_i_1_n_0 ;
  wire \data_rise_s[4]_i_1_n_0 ;
  wire \data_rise_s_reg_n_0_[0] ;
  wire \data_rise_s_reg_n_0_[1] ;
  wire \data_rise_s_reg_n_0_[2] ;
  wire \data_rise_s_reg_n_0_[3] ;
  wire \data_rise_s_reg_n_0_[4] ;
  wire p_4_in;
  wire pclk_x5;
  wire [0:0]tmds_data_n;
  wire [0:0]tmds_data_p;
  wire NLW_ODDR2_inst0_R_UNCONNECTED;
  wire NLW_ODDR2_inst0_S_UNCONNECTED;

  (* BOX_TYPE = "PRIMITIVE" *) 
  (* CAPACITANCE = "DONT_CARE" *) 
  OBUFDS OBUFDS_inst
       (.I(data),
        .O(tmds_data_p),
        .OB(tmds_data_n));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "MLO" *) 
  (* XILINX_LEGACY_PRIM = "ODDR2" *) 
  (* XILINX_TRANSFORM_PINMAP = "D0:D1 D1:D2 C0:C" *) 
  (* __SRVAL = "TRUE" *) 
  ODDR #(
    .DDR_CLK_EDGE("OPPOSITE_EDGE"),
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1),
    .SRTYPE("SYNC")) 
    ODDR2_inst0
       (.C(C00),
        .CE(1'b1),
        .D1(\data_rise_s_reg_n_0_[0] ),
        .D2(data_fall_s),
        .Q(data),
        .R(NLW_ODDR2_inst0_R_UNCONNECTED),
        .S(NLW_ODDR2_inst0_S_UNCONNECTED));
  (* SOFT_HLUTNM = "soft_lutpair58" *) 
  LUT2 #(
    .INIT(4'h1)) 
    \cnt[0]_i_1__0 
       (.I0(p_4_in),
        .I1(\cnt_reg_n_0_[0] ),
        .O(\cnt[0]_i_1__0_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair57" *) 
  LUT3 #(
    .INIT(8'h06)) 
    \cnt[1]_i_1__3 
       (.I0(\cnt_reg_n_0_[1] ),
        .I1(\cnt_reg_n_0_[0] ),
        .I2(p_4_in),
        .O(\cnt[1]_i_1__3_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair57" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \cnt[2]_i_1__3 
       (.I0(\cnt_reg_n_0_[1] ),
        .I1(\cnt_reg_n_0_[0] ),
        .I2(p_4_in),
        .O(\cnt[2]_i_1__3_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[0] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\cnt[0]_i_1__0_n_0 ),
        .Q(\cnt_reg_n_0_[0] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[1] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\cnt[1]_i_1__3_n_0 ),
        .Q(\cnt_reg_n_0_[1] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[2] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\cnt[2]_i_1__3_n_0 ),
        .Q(p_4_in),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair61" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \data_fall_s[0]_i_1 
       (.I0(\data_fall_s_reg[4]_0 [1]),
        .I1(p_4_in),
        .I2(\data_fall_s_reg_n_0_[1] ),
        .O(\data_fall_s[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair61" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \data_fall_s[1]_i_1 
       (.I0(\data_fall_s_reg[4]_0 [3]),
        .I1(p_4_in),
        .I2(\data_fall_s_reg_n_0_[2] ),
        .O(\data_fall_s[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair62" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \data_fall_s[2]_i_1 
       (.I0(\data_fall_s_reg[4]_0 [5]),
        .I1(p_4_in),
        .I2(\data_fall_s_reg_n_0_[3] ),
        .O(\data_fall_s[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair62" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \data_fall_s[3]_i_1 
       (.I0(\data_fall_s_reg[4]_0 [7]),
        .I1(p_4_in),
        .I2(\data_fall_s_reg_n_0_[4] ),
        .O(\data_fall_s[3]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    \data_fall_s[4]_i_1 
       (.I0(p_4_in),
        .I1(\data_fall_s_reg[4]_0 [9]),
        .O(\data_fall_s[4]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \data_fall_s_reg[0] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\data_fall_s[0]_i_1_n_0 ),
        .Q(data_fall_s),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \data_fall_s_reg[1] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\data_fall_s[1]_i_1_n_0 ),
        .Q(\data_fall_s_reg_n_0_[1] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \data_fall_s_reg[2] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\data_fall_s[2]_i_1_n_0 ),
        .Q(\data_fall_s_reg_n_0_[2] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \data_fall_s_reg[3] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\data_fall_s[3]_i_1_n_0 ),
        .Q(\data_fall_s_reg_n_0_[3] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \data_fall_s_reg[4] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\data_fall_s[4]_i_1_n_0 ),
        .Q(\data_fall_s_reg_n_0_[4] ),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair58" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \data_rise_s[0]_i_1 
       (.I0(\data_fall_s_reg[4]_0 [0]),
        .I1(p_4_in),
        .I2(\data_rise_s_reg_n_0_[1] ),
        .O(\data_rise_s[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair59" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \data_rise_s[1]_i_1 
       (.I0(\data_fall_s_reg[4]_0 [2]),
        .I1(p_4_in),
        .I2(\data_rise_s_reg_n_0_[2] ),
        .O(\data_rise_s[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair59" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \data_rise_s[2]_i_1 
       (.I0(\data_fall_s_reg[4]_0 [4]),
        .I1(p_4_in),
        .I2(\data_rise_s_reg_n_0_[3] ),
        .O(\data_rise_s[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair60" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \data_rise_s[3]_i_1 
       (.I0(\data_fall_s_reg[4]_0 [6]),
        .I1(p_4_in),
        .I2(\data_rise_s_reg_n_0_[4] ),
        .O(\data_rise_s[3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair60" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \data_rise_s[4]_i_1 
       (.I0(p_4_in),
        .I1(\data_fall_s_reg[4]_0 [8]),
        .O(\data_rise_s[4]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \data_rise_s_reg[0] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\data_rise_s[0]_i_1_n_0 ),
        .Q(\data_rise_s_reg_n_0_[0] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \data_rise_s_reg[1] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\data_rise_s[1]_i_1_n_0 ),
        .Q(\data_rise_s_reg_n_0_[1] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \data_rise_s_reg[2] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\data_rise_s[2]_i_1_n_0 ),
        .Q(\data_rise_s_reg_n_0_[2] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \data_rise_s_reg[3] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\data_rise_s[3]_i_1_n_0 ),
        .Q(\data_rise_s_reg_n_0_[3] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \data_rise_s_reg[4] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\data_rise_s[4]_i_1_n_0 ),
        .Q(\data_rise_s_reg_n_0_[4] ),
        .R(1'b0));
endmodule

(* ORIG_REF_NAME = "par_to_ser" *) 
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_par_to_ser_4
   (C00,
    tmds_data_p,
    tmds_data_n,
    pclk_x5,
    \data_fall_s_reg[4]_0 );
  output C00;
  output [0:0]tmds_data_p;
  output [0:0]tmds_data_n;
  input pclk_x5;
  input [9:0]\data_fall_s_reg[4]_0 ;

  wire \cnt[0]_i_1__1_n_0 ;
  wire \cnt[1]_i_1__4_n_0 ;
  wire \cnt[2]_i_1__4_n_0 ;
  wire \cnt_reg_n_0_[0] ;
  wire \cnt_reg_n_0_[1] ;
  wire data;
  wire [0:0]data_fall_s;
  wire \data_fall_s[0]_i_1_n_0 ;
  wire \data_fall_s[1]_i_1_n_0 ;
  wire \data_fall_s[2]_i_1_n_0 ;
  wire \data_fall_s[3]_i_1_n_0 ;
  wire \data_fall_s[4]_i_1_n_0 ;
  wire [9:0]\data_fall_s_reg[4]_0 ;
  wire \data_fall_s_reg_n_0_[1] ;
  wire \data_fall_s_reg_n_0_[2] ;
  wire \data_fall_s_reg_n_0_[3] ;
  wire \data_fall_s_reg_n_0_[4] ;
  wire \data_rise_s[0]_i_1_n_0 ;
  wire \data_rise_s[1]_i_1_n_0 ;
  wire \data_rise_s[2]_i_1_n_0 ;
  wire \data_rise_s[3]_i_1_n_0 ;
  wire \data_rise_s[4]_i_1_n_0 ;
  wire \data_rise_s_reg_n_0_[0] ;
  wire \data_rise_s_reg_n_0_[1] ;
  wire \data_rise_s_reg_n_0_[2] ;
  wire \data_rise_s_reg_n_0_[3] ;
  wire \data_rise_s_reg_n_0_[4] ;
  wire p_4_in;
  wire pclk_x5;
  wire [0:0]tmds_data_n;
  wire [0:0]tmds_data_p;
  wire NLW_ODDR2_inst0_R_UNCONNECTED;
  wire NLW_ODDR2_inst0_S_UNCONNECTED;

  assign C00 = pclk_x5;
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* CAPACITANCE = "DONT_CARE" *) 
  OBUFDS OBUFDS_inst
       (.I(data),
        .O(tmds_data_p),
        .OB(tmds_data_n));
  (* BOX_TYPE = "PRIMITIVE" *) 
  (* OPT_MODIFIED = "MLO" *) 
  (* XILINX_LEGACY_PRIM = "ODDR2" *) 
  (* XILINX_TRANSFORM_PINMAP = "D0:D1 D1:D2 C0:C" *) 
  (* __SRVAL = "TRUE" *) 
  ODDR #(
    .DDR_CLK_EDGE("OPPOSITE_EDGE"),
    .INIT(1'b0),
    .IS_C_INVERTED(1'b1),
    .SRTYPE("SYNC")) 
    ODDR2_inst0
       (.C(pclk_x5),
        .CE(1'b1),
        .D1(\data_rise_s_reg_n_0_[0] ),
        .D2(data_fall_s),
        .Q(data),
        .R(NLW_ODDR2_inst0_R_UNCONNECTED),
        .S(NLW_ODDR2_inst0_S_UNCONNECTED));
  (* SOFT_HLUTNM = "soft_lutpair64" *) 
  LUT2 #(
    .INIT(4'h1)) 
    \cnt[0]_i_1__1 
       (.I0(p_4_in),
        .I1(\cnt_reg_n_0_[0] ),
        .O(\cnt[0]_i_1__1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair63" *) 
  LUT3 #(
    .INIT(8'h06)) 
    \cnt[1]_i_1__4 
       (.I0(\cnt_reg_n_0_[1] ),
        .I1(\cnt_reg_n_0_[0] ),
        .I2(p_4_in),
        .O(\cnt[1]_i_1__4_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair63" *) 
  LUT3 #(
    .INIT(8'h08)) 
    \cnt[2]_i_1__4 
       (.I0(\cnt_reg_n_0_[1] ),
        .I1(\cnt_reg_n_0_[0] ),
        .I2(p_4_in),
        .O(\cnt[2]_i_1__4_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[0] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\cnt[0]_i_1__1_n_0 ),
        .Q(\cnt_reg_n_0_[0] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[1] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\cnt[1]_i_1__4_n_0 ),
        .Q(\cnt_reg_n_0_[1] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \cnt_reg[2] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\cnt[2]_i_1__4_n_0 ),
        .Q(p_4_in),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair67" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \data_fall_s[0]_i_1 
       (.I0(\data_fall_s_reg[4]_0 [1]),
        .I1(p_4_in),
        .I2(\data_fall_s_reg_n_0_[1] ),
        .O(\data_fall_s[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair67" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \data_fall_s[1]_i_1 
       (.I0(\data_fall_s_reg[4]_0 [3]),
        .I1(p_4_in),
        .I2(\data_fall_s_reg_n_0_[2] ),
        .O(\data_fall_s[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair68" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \data_fall_s[2]_i_1 
       (.I0(\data_fall_s_reg[4]_0 [5]),
        .I1(p_4_in),
        .I2(\data_fall_s_reg_n_0_[3] ),
        .O(\data_fall_s[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair68" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \data_fall_s[3]_i_1 
       (.I0(\data_fall_s_reg[4]_0 [7]),
        .I1(p_4_in),
        .I2(\data_fall_s_reg_n_0_[4] ),
        .O(\data_fall_s[3]_i_1_n_0 ));
  LUT2 #(
    .INIT(4'h8)) 
    \data_fall_s[4]_i_1 
       (.I0(p_4_in),
        .I1(\data_fall_s_reg[4]_0 [9]),
        .O(\data_fall_s[4]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \data_fall_s_reg[0] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\data_fall_s[0]_i_1_n_0 ),
        .Q(data_fall_s),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \data_fall_s_reg[1] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\data_fall_s[1]_i_1_n_0 ),
        .Q(\data_fall_s_reg_n_0_[1] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \data_fall_s_reg[2] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\data_fall_s[2]_i_1_n_0 ),
        .Q(\data_fall_s_reg_n_0_[2] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \data_fall_s_reg[3] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\data_fall_s[3]_i_1_n_0 ),
        .Q(\data_fall_s_reg_n_0_[3] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \data_fall_s_reg[4] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\data_fall_s[4]_i_1_n_0 ),
        .Q(\data_fall_s_reg_n_0_[4] ),
        .R(1'b0));
  (* SOFT_HLUTNM = "soft_lutpair64" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \data_rise_s[0]_i_1 
       (.I0(\data_fall_s_reg[4]_0 [0]),
        .I1(p_4_in),
        .I2(\data_rise_s_reg_n_0_[1] ),
        .O(\data_rise_s[0]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair65" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \data_rise_s[1]_i_1 
       (.I0(\data_fall_s_reg[4]_0 [2]),
        .I1(p_4_in),
        .I2(\data_rise_s_reg_n_0_[2] ),
        .O(\data_rise_s[1]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair65" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \data_rise_s[2]_i_1 
       (.I0(\data_fall_s_reg[4]_0 [4]),
        .I1(p_4_in),
        .I2(\data_rise_s_reg_n_0_[3] ),
        .O(\data_rise_s[2]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair66" *) 
  LUT3 #(
    .INIT(8'hB8)) 
    \data_rise_s[3]_i_1 
       (.I0(\data_fall_s_reg[4]_0 [6]),
        .I1(p_4_in),
        .I2(\data_rise_s_reg_n_0_[4] ),
        .O(\data_rise_s[3]_i_1_n_0 ));
  (* SOFT_HLUTNM = "soft_lutpair66" *) 
  LUT2 #(
    .INIT(4'h8)) 
    \data_rise_s[4]_i_1 
       (.I0(p_4_in),
        .I1(\data_fall_s_reg[4]_0 [8]),
        .O(\data_rise_s[4]_i_1_n_0 ));
  FDRE #(
    .INIT(1'b0)) 
    \data_rise_s_reg[0] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\data_rise_s[0]_i_1_n_0 ),
        .Q(\data_rise_s_reg_n_0_[0] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \data_rise_s_reg[1] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\data_rise_s[1]_i_1_n_0 ),
        .Q(\data_rise_s_reg_n_0_[1] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \data_rise_s_reg[2] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\data_rise_s[2]_i_1_n_0 ),
        .Q(\data_rise_s_reg_n_0_[2] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \data_rise_s_reg[3] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\data_rise_s[3]_i_1_n_0 ),
        .Q(\data_rise_s_reg_n_0_[3] ),
        .R(1'b0));
  FDRE #(
    .INIT(1'b0)) 
    \data_rise_s_reg[4] 
       (.C(pclk_x5),
        .CE(1'b1),
        .D(\data_rise_s[4]_i_1_n_0 ),
        .Q(\data_rise_s_reg_n_0_[4] ),
        .R(1'b0));
endmodule

(* CHECK_LICENSE_TYPE = "zynq_hdmi_transmitter_0_0,hdmi_transmitter_v1_0,{}" *) (* DowngradeIPIdentifiedWarnings = "yes" *) (* X_CORE_INFO = "hdmi_transmitter_v1_0,Vivado 2020.2" *) 
(* NotValidForBitStream *)
module decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix
   (pclk,
    pclk_x5,
    rst_n,
    video_din,
    video_hsync,
    video_vsync,
    video_de,
    tmds_clk_p,
    tmds_clk_n,
    tmds_data_p,
    tmds_data_n,
    tmds_oen,
    s00_axi_awaddr,
    s00_axi_awprot,
    s00_axi_awvalid,
    s00_axi_awready,
    s00_axi_wdata,
    s00_axi_wstrb,
    s00_axi_wvalid,
    s00_axi_wready,
    s00_axi_bresp,
    s00_axi_bvalid,
    s00_axi_bready,
    s00_axi_araddr,
    s00_axi_arprot,
    s00_axi_arvalid,
    s00_axi_arready,
    s00_axi_rdata,
    s00_axi_rresp,
    s00_axi_rvalid,
    s00_axi_rready,
    s00_axi_aclk,
    s00_axi_aresetn);
  input pclk;
  input pclk_x5;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 rst_n RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME rst_n, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input rst_n;
  input [23:0]video_din;
  input video_hsync;
  input video_vsync;
  input video_de;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 tmds_clk_p CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME tmds_clk_p, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.000, CLK_DOMAIN zynq_hdmi_transmitter_0_0_tmds_clk_p, INSERT_VIP 0" *) output tmds_clk_p;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 tmds_clk_n CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME tmds_clk_n, ASSOCIATED_RESET rst_n, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.000, CLK_DOMAIN zynq_hdmi_transmitter_0_0_tmds_clk_n, INSERT_VIP 0" *) output tmds_clk_n;
  output [2:0]tmds_data_p;
  output [2:0]tmds_data_n;
  output tmds_oen;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI AWADDR" *) input [3:0]s00_axi_awaddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI AWPROT" *) input [2:0]s00_axi_awprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI AWVALID" *) input s00_axi_awvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI AWREADY" *) output s00_axi_awready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI WDATA" *) input [31:0]s00_axi_wdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI WSTRB" *) input [3:0]s00_axi_wstrb;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI WVALID" *) input s00_axi_wvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI WREADY" *) output s00_axi_wready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI BRESP" *) output [1:0]s00_axi_bresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI BVALID" *) output s00_axi_bvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI BREADY" *) input s00_axi_bready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI ARADDR" *) input [3:0]s00_axi_araddr;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI ARPROT" *) input [2:0]s00_axi_arprot;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI ARVALID" *) input s00_axi_arvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI ARREADY" *) output s00_axi_arready;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI RDATA" *) output [31:0]s00_axi_rdata;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI RRESP" *) output [1:0]s00_axi_rresp;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI RVALID" *) output s00_axi_rvalid;
  (* X_INTERFACE_INFO = "xilinx.com:interface:aximm:1.0 S00_AXI RREADY" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S00_AXI, WIZ_DATA_WIDTH 32, WIZ_NUM_REG 4, SUPPORTS_NARROW_BURST 0, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 100000000, ID_WIDTH 0, ADDR_WIDTH 4, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 1, PHASE 0.000, CLK_DOMAIN zynq_processing_system7_0_0_FCLK_CLK0, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0" *) input s00_axi_rready;
  (* X_INTERFACE_INFO = "xilinx.com:signal:clock:1.0 S00_AXI_CLK CLK" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S00_AXI_CLK, ASSOCIATED_BUSIF S00_AXI, ASSOCIATED_RESET s00_axi_aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.000, CLK_DOMAIN zynq_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0" *) input s00_axi_aclk;
  (* X_INTERFACE_INFO = "xilinx.com:signal:reset:1.0 S00_AXI_RST RST" *) (* X_INTERFACE_PARAMETER = "XIL_INTERFACENAME S00_AXI_RST, POLARITY ACTIVE_LOW, INSERT_VIP 0" *) input s00_axi_aresetn;

  wire \<const0> ;
  wire \<const1> ;
  wire pclk;
  wire pclk_x5;
  wire rst_n;
  wire s00_axi_aclk;
  wire [3:0]s00_axi_araddr;
  wire s00_axi_aresetn;
  wire s00_axi_arready;
  wire s00_axi_arvalid;
  wire [3:0]s00_axi_awaddr;
  wire s00_axi_awready;
  wire s00_axi_awvalid;
  wire s00_axi_bready;
  wire s00_axi_bvalid;
  wire [31:0]s00_axi_rdata;
  wire s00_axi_rready;
  wire s00_axi_rvalid;
  wire [31:0]s00_axi_wdata;
  wire s00_axi_wready;
  wire [3:0]s00_axi_wstrb;
  wire s00_axi_wvalid;
  (* IOSTANDARD = "TMDS_33" *) (* SLEW = "SLOW" *) wire tmds_clk_n;
  (* IOSTANDARD = "TMDS_33" *) (* SLEW = "SLOW" *) wire tmds_clk_p;
  (* IOSTANDARD = "TMDS_33" *) (* SLEW = "SLOW" *) wire [2:0]tmds_data_n;
  (* IOSTANDARD = "TMDS_33" *) (* SLEW = "SLOW" *) wire [2:0]tmds_data_p;
  wire video_de;
  wire [23:0]video_din;
  wire video_hsync;
  wire video_vsync;

  assign s00_axi_bresp[1] = \<const0> ;
  assign s00_axi_bresp[0] = \<const0> ;
  assign s00_axi_rresp[1] = \<const0> ;
  assign s00_axi_rresp[0] = \<const0> ;
  assign tmds_oen = \<const1> ;
  GND GND
       (.G(\<const0> ));
  VCC VCC
       (.P(\<const1> ));
  decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_hdmi_transmitter_v1_0 inst
       (.S_AXI_ARREADY(s00_axi_arready),
        .S_AXI_AWREADY(s00_axi_awready),
        .S_AXI_WREADY(s00_axi_wready),
        .pclk(pclk),
        .pclk_x5(pclk_x5),
        .rst_n(rst_n),
        .s00_axi_aclk(s00_axi_aclk),
        .s00_axi_araddr(s00_axi_araddr[3:2]),
        .s00_axi_aresetn(s00_axi_aresetn),
        .s00_axi_arvalid(s00_axi_arvalid),
        .s00_axi_awaddr(s00_axi_awaddr[3:2]),
        .s00_axi_awvalid(s00_axi_awvalid),
        .s00_axi_bready(s00_axi_bready),
        .s00_axi_bvalid(s00_axi_bvalid),
        .s00_axi_rdata(s00_axi_rdata),
        .s00_axi_rready(s00_axi_rready),
        .s00_axi_rvalid(s00_axi_rvalid),
        .s00_axi_wdata(s00_axi_wdata),
        .s00_axi_wstrb(s00_axi_wstrb),
        .s00_axi_wvalid(s00_axi_wvalid),
        .tmds_clk_n(tmds_clk_n),
        .tmds_clk_p(tmds_clk_p),
        .tmds_data_n(tmds_data_n),
        .tmds_data_p(tmds_data_p),
        .video_de(video_de),
        .video_din(video_din),
        .video_hsync(video_hsync),
        .video_vsync(video_vsync));
endmodule
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
