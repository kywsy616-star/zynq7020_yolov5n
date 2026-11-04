-- Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
-- --------------------------------------------------------------------------------
-- Tool Version: Vivado v.2020.2 (win64) Build 3064766 Wed Nov 18 09:12:45 MST 2020
-- Date        : Sat Oct 10 17:19:53 2026
-- Host        : DESKTOP-IO7F7QJ running 64-bit major release  (build 9200)
-- Command     : write_vhdl -force -mode funcsim -rename_top decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix -prefix
--               decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_ zynq_hdmi_transmitter_0_0_sim_netlist.vhdl
-- Design      : zynq_hdmi_transmitter_0_0
-- Purpose     : This VHDL netlist is a functional simulation representation of the design and should not be modified or
--               synthesized. This netlist cannot be used for SDF annotated simulation.
-- Device      : xc7z020clg400-2
-- --------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_encode is
  port (
    rst_n_0 : out STD_LOGIC;
    de_reg2 : out STD_LOGIC;
    c0_reg2 : out STD_LOGIC;
    D : out STD_LOGIC_VECTOR ( 1 downto 0 );
    c0_reg2_reg_0 : out STD_LOGIC_VECTOR ( 1 downto 0 );
    \data_out_reg[9]_0\ : out STD_LOGIC_VECTOR ( 9 downto 0 );
    video_de : in STD_LOGIC;
    pclk : in STD_LOGIC;
    video_hsync : in STD_LOGIC;
    video_vsync : in STD_LOGIC;
    \data_out_reg[9]_1\ : in STD_LOGIC;
    \data_out_reg[9]_2\ : in STD_LOGIC;
    Q : in STD_LOGIC_VECTOR ( 0 to 0 );
    \data_out_reg[9]_3\ : in STD_LOGIC;
    \data_out_reg[9]_4\ : in STD_LOGIC;
    \data_out_reg[9]_5\ : in STD_LOGIC_VECTOR ( 0 to 0 );
    rst_n : in STD_LOGIC;
    video_din : in STD_LOGIC_VECTOR ( 7 downto 0 )
  );
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_encode;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_encode is
  signal c0_reg1 : STD_LOGIC;
  signal \^c0_reg2\ : STD_LOGIC;
  signal c1_reg1 : STD_LOGIC;
  signal c1_reg2 : STD_LOGIC;
  signal cnt : STD_LOGIC_VECTOR ( 4 downto 1 );
  signal \cnt[1]_i_1_n_0\ : STD_LOGIC;
  signal \cnt[1]_i_2_n_0\ : STD_LOGIC;
  signal \cnt[1]_i_3__0_n_0\ : STD_LOGIC;
  signal \cnt[2]_i_1_n_0\ : STD_LOGIC;
  signal \cnt[2]_i_2_n_0\ : STD_LOGIC;
  signal \cnt[2]_i_3_n_0\ : STD_LOGIC;
  signal \cnt[2]_i_4_n_0\ : STD_LOGIC;
  signal \cnt[3]_i_1__0_n_0\ : STD_LOGIC;
  signal \cnt[3]_i_2_n_0\ : STD_LOGIC;
  signal \cnt[3]_i_3_n_0\ : STD_LOGIC;
  signal \cnt[3]_i_4_n_0\ : STD_LOGIC;
  signal \cnt[3]_i_5_n_0\ : STD_LOGIC;
  signal \cnt[3]_i_6_n_0\ : STD_LOGIC;
  signal \cnt[3]_i_7_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_10_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_11_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_12_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_13_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_14_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_15_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_16_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_17_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_18_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_19_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_1_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_20_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_21_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_22_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_23_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_24_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_2_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_3_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_4_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_5_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_6_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_7_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_8_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_9_n_0\ : STD_LOGIC;
  signal data_in_n1 : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal data_in_n10 : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \data_in_n1[0]_i_2_n_0\ : STD_LOGIC;
  signal \data_in_n1[1]_i_2_n_0\ : STD_LOGIC;
  signal \data_in_n1[2]_i_2_n_0\ : STD_LOGIC;
  signal \data_in_n1[3]_i_2_n_0\ : STD_LOGIC;
  signal \data_in_n1[3]_i_3_n_0\ : STD_LOGIC;
  signal \data_in_n1[3]_i_4_n_0\ : STD_LOGIC;
  signal \data_in_reg_reg_n_0_[0]\ : STD_LOGIC;
  signal data_out : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal \data_out[9]_i_1_n_0\ : STD_LOGIC;
  signal de_reg1 : STD_LOGIC;
  signal \^de_reg2\ : STD_LOGIC;
  signal p_0_in : STD_LOGIC;
  signal p_0_in0_in : STD_LOGIC;
  signal p_0_in1_in : STD_LOGIC;
  signal p_0_in2_in : STD_LOGIC;
  signal p_0_in3_in : STD_LOGIC;
  signal p_0_in4_in : STD_LOGIC;
  signal p_0_in5_in : STD_LOGIC;
  signal q_m : STD_LOGIC_VECTOR ( 8 to 8 );
  signal q_m_1 : STD_LOGIC;
  signal q_m_2 : STD_LOGIC;
  signal q_m_3 : STD_LOGIC;
  signal q_m_4 : STD_LOGIC;
  signal q_m_6 : STD_LOGIC;
  signal q_m_7 : STD_LOGIC;
  signal q_m_n0 : STD_LOGIC_VECTOR ( 3 downto 1 );
  signal q_m_n00 : STD_LOGIC_VECTOR ( 3 downto 1 );
  signal q_m_n1 : STD_LOGIC_VECTOR ( 3 downto 1 );
  signal q_m_n10 : STD_LOGIC_VECTOR ( 3 downto 1 );
  signal \q_m_n1[2]_i_1_n_0\ : STD_LOGIC;
  signal \q_m_n1[3]_i_2_n_0\ : STD_LOGIC;
  signal \q_m_n1[3]_i_3_n_0\ : STD_LOGIC;
  signal \q_m_n1[3]_i_4_n_0\ : STD_LOGIC;
  signal \q_m_n1[3]_i_5_n_0\ : STD_LOGIC;
  signal \q_m_n1[3]_i_6_n_0\ : STD_LOGIC;
  signal \q_m_n1[3]_i_7_n_0\ : STD_LOGIC;
  signal q_m_reg : STD_LOGIC_VECTOR ( 8 downto 0 );
  signal \q_m_reg[5]_i_1_n_0\ : STD_LOGIC;
  signal \q_m_reg[7]_i_2_n_0\ : STD_LOGIC;
  signal \q_m_reg[7]_i_3_n_0\ : STD_LOGIC;
  signal \^rst_n_0\ : STD_LOGIC;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \cnt[1]_i_2\ : label is "soft_lutpair16";
  attribute SOFT_HLUTNM of \cnt[1]_i_3__0\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \cnt[2]_i_2\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \cnt[2]_i_3\ : label is "soft_lutpair2";
  attribute SOFT_HLUTNM of \cnt[2]_i_4\ : label is "soft_lutpair1";
  attribute SOFT_HLUTNM of \cnt[3]_i_5\ : label is "soft_lutpair13";
  attribute SOFT_HLUTNM of \cnt[3]_i_7\ : label is "soft_lutpair16";
  attribute SOFT_HLUTNM of \cnt[4]_i_10\ : label is "soft_lutpair10";
  attribute SOFT_HLUTNM of \cnt[4]_i_11\ : label is "soft_lutpair11";
  attribute SOFT_HLUTNM of \cnt[4]_i_12\ : label is "soft_lutpair10";
  attribute SOFT_HLUTNM of \cnt[4]_i_14\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \cnt[4]_i_15\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \cnt[4]_i_16\ : label is "soft_lutpair12";
  attribute SOFT_HLUTNM of \cnt[4]_i_17\ : label is "soft_lutpair0";
  attribute SOFT_HLUTNM of \cnt[4]_i_21\ : label is "soft_lutpair12";
  attribute SOFT_HLUTNM of \cnt[4]_i_22\ : label is "soft_lutpair13";
  attribute SOFT_HLUTNM of \cnt[4]_i_24\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \cnt[4]_i_7\ : label is "soft_lutpair4";
  attribute SOFT_HLUTNM of \cnt[4]_i_8\ : label is "soft_lutpair3";
  attribute SOFT_HLUTNM of \cnt[4]_i_9\ : label is "soft_lutpair11";
  attribute SOFT_HLUTNM of \data_in_n1[0]_i_2\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \data_in_n1[3]_i_3\ : label is "soft_lutpair5";
  attribute SOFT_HLUTNM of \data_out[8]_i_1\ : label is "soft_lutpair14";
  attribute SOFT_HLUTNM of \data_out[8]_i_1__0\ : label is "soft_lutpair14";
  attribute SOFT_HLUTNM of \q_m_n1[3]_i_2\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \q_m_n1[3]_i_5\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \q_m_n1[3]_i_6\ : label is "soft_lutpair15";
  attribute SOFT_HLUTNM of \q_m_reg[2]_i_1\ : label is "soft_lutpair15";
  attribute SOFT_HLUTNM of \q_m_reg[3]_i_1\ : label is "soft_lutpair6";
  attribute SOFT_HLUTNM of \q_m_reg[4]_i_1\ : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of \q_m_reg[7]_i_1\ : label is "soft_lutpair7";
  attribute SOFT_HLUTNM of \q_m_reg[7]_i_2\ : label is "soft_lutpair8";
  attribute SOFT_HLUTNM of \q_m_reg[7]_i_3\ : label is "soft_lutpair9";
  attribute SOFT_HLUTNM of \q_m_reg[8]_i_1\ : label is "soft_lutpair8";
begin
  c0_reg2 <= \^c0_reg2\;
  de_reg2 <= \^de_reg2\;
  rst_n_0 <= \^rst_n_0\;
c0_reg1_reg: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => video_hsync,
      Q => c0_reg1
    );
c0_reg2_reg: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => c0_reg1,
      Q => \^c0_reg2\
    );
c1_reg1_reg: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => video_vsync,
      Q => c1_reg1
    );
c1_reg2_reg: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => c1_reg1,
      Q => c1_reg2
    );
\cnt[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0028AA28AA280028"
    )
        port map (
      I0 => \^de_reg2\,
      I1 => \cnt[1]_i_2_n_0\,
      I2 => cnt(1),
      I3 => \cnt[4]_i_3_n_0\,
      I4 => \cnt[4]_i_5_n_0\,
      I5 => \cnt[1]_i_3__0_n_0\,
      O => \cnt[1]_i_1_n_0\
    );
\cnt[1]_i_2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => q_m_n1(1),
      I1 => q_m_n0(1),
      O => \cnt[1]_i_2_n_0\
    );
\cnt[1]_i_3__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9669"
    )
        port map (
      I0 => cnt(1),
      I1 => q_m_n0(1),
      I2 => q_m_reg(8),
      I3 => q_m_n1(1),
      O => \cnt[1]_i_3__0_n_0\
    );
\cnt[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"020202A2A2A202A2"
    )
        port map (
      I0 => \^de_reg2\,
      I1 => \cnt[2]_i_2_n_0\,
      I2 => \cnt[4]_i_3_n_0\,
      I3 => \cnt[2]_i_3_n_0\,
      I4 => \cnt[4]_i_5_n_0\,
      I5 => \cnt[2]_i_4_n_0\,
      O => \cnt[2]_i_1_n_0\
    );
\cnt[2]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"56955965"
    )
        port map (
      I0 => \cnt[4]_i_10_n_0\,
      I1 => cnt(1),
      I2 => q_m_n1(1),
      I3 => q_m_n0(1),
      I4 => q_m_reg(8),
      O => \cnt[2]_i_2_n_0\
    );
\cnt[2]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"596565A6"
    )
        port map (
      I0 => \cnt[4]_i_10_n_0\,
      I1 => q_m_reg(8),
      I2 => q_m_n0(1),
      I3 => q_m_n1(1),
      I4 => cnt(1),
      O => \cnt[2]_i_3_n_0\
    );
\cnt[2]_i_4\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"9A595965"
    )
        port map (
      I0 => \cnt[4]_i_10_n_0\,
      I1 => cnt(1),
      I2 => q_m_n1(1),
      I3 => q_m_reg(8),
      I4 => q_m_n0(1),
      O => \cnt[2]_i_4_n_0\
    );
\cnt[3]_i_1__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"22E22EEE00000000"
    )
        port map (
      I0 => \cnt[3]_i_2_n_0\,
      I1 => \cnt[4]_i_3_n_0\,
      I2 => \cnt[4]_i_5_n_0\,
      I3 => \cnt[3]_i_3_n_0\,
      I4 => \cnt[3]_i_4_n_0\,
      I5 => \^de_reg2\,
      O => \cnt[3]_i_1__0_n_0\
    );
\cnt[3]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F3200CDF0CDFF320"
    )
        port map (
      I0 => \cnt[1]_i_2_n_0\,
      I1 => cnt(1),
      I2 => \cnt[3]_i_5_n_0\,
      I3 => \cnt[4]_i_10_n_0\,
      I4 => \cnt[4]_i_12_n_0\,
      I5 => \cnt[4]_i_8_n_0\,
      O => \cnt[3]_i_2_n_0\
    );
\cnt[3]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5955995999599A99"
    )
        port map (
      I0 => \cnt[3]_i_6_n_0\,
      I1 => \cnt[4]_i_10_n_0\,
      I2 => cnt(1),
      I3 => q_m_n1(1),
      I4 => q_m_reg(8),
      I5 => q_m_n0(1),
      O => \cnt[3]_i_3_n_0\
    );
\cnt[3]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"7F0180FE80FE7F01"
    )
        port map (
      I0 => \cnt[3]_i_7_n_0\,
      I1 => cnt(1),
      I2 => q_m_n1(1),
      I3 => \cnt[4]_i_17_n_0\,
      I4 => \cnt[4]_i_14_n_0\,
      I5 => \cnt[4]_i_15_n_0\,
      O => \cnt[3]_i_4_n_0\
    );
\cnt[3]_i_5\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"DB"
    )
        port map (
      I0 => q_m_reg(8),
      I1 => q_m_n0(1),
      I2 => q_m_n1(1),
      O => \cnt[3]_i_5_n_0\
    );
\cnt[3]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6969966996699696"
    )
        port map (
      I0 => q_m_n1(3),
      I1 => q_m_n0(3),
      I2 => cnt(3),
      I3 => q_m_n1(2),
      I4 => q_m_n0(2),
      I5 => cnt(2),
      O => \cnt[3]_i_6_n_0\
    );
\cnt[3]_i_7\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => q_m_n0(1),
      I1 => q_m_reg(8),
      O => \cnt[3]_i_7_n_0\
    );
\cnt[4]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"020202A2A2A202A2"
    )
        port map (
      I0 => \^de_reg2\,
      I1 => \cnt[4]_i_2_n_0\,
      I2 => \cnt[4]_i_3_n_0\,
      I3 => \cnt[4]_i_4_n_0\,
      I4 => \cnt[4]_i_5_n_0\,
      I5 => \cnt[4]_i_6_n_0\,
      O => \cnt[4]_i_1_n_0\
    );
\cnt[4]_i_10\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => cnt(2),
      I1 => q_m_n0(2),
      I2 => q_m_n1(2),
      O => \cnt[4]_i_10_n_0\
    );
\cnt[4]_i_11\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"EFFB"
    )
        port map (
      I0 => cnt(1),
      I1 => q_m_n1(1),
      I2 => q_m_n0(1),
      I3 => q_m_reg(8),
      O => \cnt[4]_i_11_n_0\
    );
\cnt[4]_i_12\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B28E"
    )
        port map (
      I0 => cnt(2),
      I1 => q_m_n0(2),
      I2 => q_m_n1(2),
      I3 => q_m_reg(8),
      O => \cnt[4]_i_12_n_0\
    );
\cnt[4]_i_13\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => q_m_n0(3),
      I1 => q_m_n1(3),
      I2 => q_m_n1(2),
      I3 => q_m_n0(2),
      I4 => q_m_n1(1),
      I5 => q_m_n0(1),
      O => \cnt[4]_i_13_n_0\
    );
\cnt[4]_i_14\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B44B4BB4"
    )
        port map (
      I0 => q_m_n1(2),
      I1 => q_m_n0(2),
      I2 => q_m_n1(3),
      I3 => q_m_n0(3),
      I4 => cnt(3),
      O => \cnt[4]_i_14_n_0\
    );
\cnt[4]_i_15\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"2F02022F"
    )
        port map (
      I0 => q_m_n0(1),
      I1 => q_m_reg(8),
      I2 => cnt(2),
      I3 => q_m_n0(2),
      I4 => q_m_n1(2),
      O => \cnt[4]_i_15_n_0\
    );
\cnt[4]_i_16\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"7117"
    )
        port map (
      I0 => q_m_n1(1),
      I1 => cnt(1),
      I2 => q_m_n0(1),
      I3 => q_m_reg(8),
      O => \cnt[4]_i_16_n_0\
    );
\cnt[4]_i_17\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"96699696"
    )
        port map (
      I0 => q_m_n1(2),
      I1 => q_m_n0(2),
      I2 => cnt(2),
      I3 => q_m_reg(8),
      I4 => q_m_n0(1),
      O => \cnt[4]_i_17_n_0\
    );
\cnt[4]_i_18\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9A55AA9A55659A55"
    )
        port map (
      I0 => cnt(4),
      I1 => q_m_n1(2),
      I2 => q_m_n0(2),
      I3 => q_m_n1(3),
      I4 => q_m_n0(3),
      I5 => cnt(3),
      O => \cnt[4]_i_18_n_0\
    );
\cnt[4]_i_19\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"DDFD00F0FFFFDDFD"
    )
        port map (
      I0 => q_m_n0(1),
      I1 => q_m_n1(1),
      I2 => q_m_n1(3),
      I3 => q_m_n0(3),
      I4 => q_m_n1(2),
      I5 => q_m_n0(2),
      O => \cnt[4]_i_19_n_0\
    );
\cnt[4]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"595599999A99AAAA"
    )
        port map (
      I0 => \cnt[4]_i_7_n_0\,
      I1 => \cnt[4]_i_8_n_0\,
      I2 => \cnt[4]_i_9_n_0\,
      I3 => \cnt[4]_i_10_n_0\,
      I4 => \cnt[4]_i_11_n_0\,
      I5 => \cnt[4]_i_12_n_0\,
      O => \cnt[4]_i_2_n_0\
    );
\cnt[4]_i_20\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FF2F2F22FF2FFF2F"
    )
        port map (
      I0 => q_m_n0(3),
      I1 => q_m_n1(3),
      I2 => q_m_n1(2),
      I3 => q_m_n0(2),
      I4 => q_m_n0(1),
      I5 => q_m_n1(1),
      O => \cnt[4]_i_20_n_0\
    );
\cnt[4]_i_21\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0096"
    )
        port map (
      I0 => q_m_n0(1),
      I1 => q_m_reg(8),
      I2 => q_m_n1(1),
      I3 => cnt(1),
      O => \cnt[4]_i_21_n_0\
    );
\cnt[4]_i_22\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"4D"
    )
        port map (
      I0 => q_m_reg(8),
      I1 => q_m_n1(1),
      I2 => q_m_n0(1),
      O => \cnt[4]_i_22_n_0\
    );
\cnt[4]_i_23\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"8E"
    )
        port map (
      I0 => cnt(2),
      I1 => q_m_n0(2),
      I2 => q_m_n1(2),
      O => \cnt[4]_i_23_n_0\
    );
\cnt[4]_i_24\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"599A"
    )
        port map (
      I0 => cnt(4),
      I1 => q_m_n1(3),
      I2 => q_m_n0(3),
      I3 => cnt(3),
      O => \cnt[4]_i_24_n_0\
    );
\cnt[4]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"55555554"
    )
        port map (
      I0 => \cnt[4]_i_13_n_0\,
      I1 => cnt(2),
      I2 => cnt(4),
      I3 => cnt(1),
      I4 => cnt(3),
      O => \cnt[4]_i_3_n_0\
    );
\cnt[4]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"11171777EEE8E888"
    )
        port map (
      I0 => \cnt[4]_i_14_n_0\,
      I1 => \cnt[4]_i_15_n_0\,
      I2 => \cnt[1]_i_3__0_n_0\,
      I3 => \cnt[4]_i_16_n_0\,
      I4 => \cnt[4]_i_17_n_0\,
      I5 => \cnt[4]_i_18_n_0\,
      O => \cnt[4]_i_4_n_0\
    );
\cnt[4]_i_5\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"47C477F7"
    )
        port map (
      I0 => \cnt[4]_i_19_n_0\,
      I1 => cnt(4),
      I2 => q_m_n0(3),
      I3 => q_m_n1(3),
      I4 => \cnt[4]_i_20_n_0\,
      O => \cnt[4]_i_5_n_0\
    );
\cnt[4]_i_6\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"E8FF00E81700FF17"
    )
        port map (
      I0 => \cnt[4]_i_21_n_0\,
      I1 => \cnt[4]_i_10_n_0\,
      I2 => \cnt[4]_i_22_n_0\,
      I3 => \cnt[4]_i_23_n_0\,
      I4 => \cnt[4]_i_8_n_0\,
      I5 => \cnt[4]_i_24_n_0\,
      O => \cnt[4]_i_6_n_0\
    );
\cnt[4]_i_7\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"5965A96A"
    )
        port map (
      I0 => cnt(4),
      I1 => q_m_reg(8),
      I2 => q_m_n1(3),
      I3 => q_m_n0(3),
      I4 => cnt(3),
      O => \cnt[4]_i_7_n_0\
    );
\cnt[4]_i_8\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => cnt(3),
      I1 => q_m_n0(3),
      I2 => q_m_n1(3),
      O => \cnt[4]_i_8_n_0\
    );
\cnt[4]_i_9\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0820"
    )
        port map (
      I0 => cnt(1),
      I1 => q_m_n1(1),
      I2 => q_m_n0(1),
      I3 => q_m_reg(8),
      O => \cnt[4]_i_9_n_0\
    );
\cnt_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => \cnt[1]_i_1_n_0\,
      Q => cnt(1)
    );
\cnt_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => \cnt[2]_i_1_n_0\,
      Q => cnt(2)
    );
\cnt_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => \cnt[3]_i_1__0_n_0\,
      Q => cnt(3)
    );
\cnt_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => \cnt[4]_i_1_n_0\,
      Q => cnt(4)
    );
\data_in_n1[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6996966996696996"
    )
        port map (
      I0 => video_din(0),
      I1 => video_din(7),
      I2 => \data_in_n1[0]_i_2_n_0\,
      I3 => video_din(2),
      I4 => video_din(1),
      I5 => video_din(3),
      O => data_in_n10(0)
    );
\data_in_n1[0]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => video_din(6),
      I1 => video_din(4),
      I2 => video_din(5),
      O => \data_in_n1[0]_i_2_n_0\
    );
\data_in_n1[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => \data_in_n1[3]_i_2_n_0\,
      I1 => \data_in_n1[1]_i_2_n_0\,
      I2 => \data_in_n1[3]_i_3_n_0\,
      O => data_in_n10(1)
    );
\data_in_n1[1]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"171717E817E8E8E8"
    )
        port map (
      I0 => video_din(3),
      I1 => video_din(2),
      I2 => video_din(1),
      I3 => video_din(6),
      I4 => video_din(5),
      I5 => video_din(4),
      O => \data_in_n1[1]_i_2_n_0\
    );
\data_in_n1[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"7E7E7EE87EE8E8E8"
    )
        port map (
      I0 => \data_in_n1[3]_i_2_n_0\,
      I1 => \data_in_n1[3]_i_3_n_0\,
      I2 => \data_in_n1[2]_i_2_n_0\,
      I3 => video_din(4),
      I4 => video_din(5),
      I5 => video_din(6),
      O => data_in_n10(2)
    );
\data_in_n1[2]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E8"
    )
        port map (
      I0 => video_din(1),
      I1 => video_din(2),
      I2 => video_din(3),
      O => \data_in_n1[2]_i_2_n_0\
    );
\data_in_n1[3]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8880800000000000"
    )
        port map (
      I0 => \data_in_n1[3]_i_2_n_0\,
      I1 => \data_in_n1[3]_i_3_n_0\,
      I2 => video_din(3),
      I3 => video_din(2),
      I4 => video_din(1),
      I5 => \data_in_n1[3]_i_4_n_0\,
      O => data_in_n10(3)
    );
\data_in_n1[3]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9600009600969600"
    )
        port map (
      I0 => video_din(2),
      I1 => video_din(1),
      I2 => video_din(3),
      I3 => video_din(0),
      I4 => video_din(7),
      I5 => \data_in_n1[0]_i_2_n_0\,
      O => \data_in_n1[3]_i_2_n_0\
    );
\data_in_n1[3]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"E88E8EE8"
    )
        port map (
      I0 => video_din(7),
      I1 => video_din(0),
      I2 => video_din(5),
      I3 => video_din(4),
      I4 => video_din(6),
      O => \data_in_n1[3]_i_3_n_0\
    );
\data_in_n1[3]_i_4\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E8"
    )
        port map (
      I0 => video_din(4),
      I1 => video_din(5),
      I2 => video_din(6),
      O => \data_in_n1[3]_i_4_n_0\
    );
\data_in_n1_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => data_in_n10(0),
      Q => data_in_n1(0)
    );
\data_in_n1_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => data_in_n10(1),
      Q => data_in_n1(1)
    );
\data_in_n1_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => data_in_n10(2),
      Q => data_in_n1(2)
    );
\data_in_n1_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => data_in_n10(3),
      Q => data_in_n1(3)
    );
\data_in_reg[7]_i_1\: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => rst_n,
      O => \^rst_n_0\
    );
\data_in_reg_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => video_din(0),
      Q => \data_in_reg_reg_n_0_[0]\
    );
\data_in_reg_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => video_din(1),
      Q => p_0_in5_in
    );
\data_in_reg_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => video_din(2),
      Q => p_0_in4_in
    );
\data_in_reg_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => video_din(3),
      Q => p_0_in3_in
    );
\data_in_reg_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => video_din(4),
      Q => p_0_in2_in
    );
\data_in_reg_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => video_din(5),
      Q => p_0_in1_in
    );
\data_in_reg_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => video_din(6),
      Q => p_0_in0_in
    );
\data_in_reg_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => video_din(7),
      Q => p_0_in
    );
\data_out[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"59A9FFFF59A90000"
    )
        port map (
      I0 => q_m_reg(0),
      I1 => q_m_reg(8),
      I2 => \cnt[4]_i_3_n_0\,
      I3 => \cnt[4]_i_5_n_0\,
      I4 => \^de_reg2\,
      I5 => \^c0_reg2\,
      O => data_out(0)
    );
\data_out[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"59A9FFFF59A90000"
    )
        port map (
      I0 => q_m_reg(1),
      I1 => q_m_reg(8),
      I2 => \cnt[4]_i_3_n_0\,
      I3 => \cnt[4]_i_5_n_0\,
      I4 => \^de_reg2\,
      I5 => \^c0_reg2\,
      O => data_out(1)
    );
\data_out[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"08A85DFDA202F757"
    )
        port map (
      I0 => \^de_reg2\,
      I1 => q_m_reg(8),
      I2 => \cnt[4]_i_3_n_0\,
      I3 => \cnt[4]_i_5_n_0\,
      I4 => \^c0_reg2\,
      I5 => q_m_reg(2),
      O => data_out(2)
    );
\data_out[3]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"59A9FFFF59A90000"
    )
        port map (
      I0 => q_m_reg(3),
      I1 => q_m_reg(8),
      I2 => \cnt[4]_i_3_n_0\,
      I3 => \cnt[4]_i_5_n_0\,
      I4 => \^de_reg2\,
      I5 => \^c0_reg2\,
      O => data_out(3)
    );
\data_out[4]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"08A85DFDA202F757"
    )
        port map (
      I0 => \^de_reg2\,
      I1 => q_m_reg(8),
      I2 => \cnt[4]_i_3_n_0\,
      I3 => \cnt[4]_i_5_n_0\,
      I4 => \^c0_reg2\,
      I5 => q_m_reg(4),
      O => data_out(4)
    );
\data_out[5]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"59A9FFFF59A90000"
    )
        port map (
      I0 => q_m_reg(5),
      I1 => q_m_reg(8),
      I2 => \cnt[4]_i_3_n_0\,
      I3 => \cnt[4]_i_5_n_0\,
      I4 => \^de_reg2\,
      I5 => \^c0_reg2\,
      O => data_out(5)
    );
\data_out[6]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"08A85DFDA202F757"
    )
        port map (
      I0 => \^de_reg2\,
      I1 => q_m_reg(8),
      I2 => \cnt[4]_i_3_n_0\,
      I3 => \cnt[4]_i_5_n_0\,
      I4 => \^c0_reg2\,
      I5 => q_m_reg(6),
      O => data_out(6)
    );
\data_out[7]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"59A9FFFF59A90000"
    )
        port map (
      I0 => q_m_reg(7),
      I1 => q_m_reg(8),
      I2 => \cnt[4]_i_3_n_0\,
      I3 => \cnt[4]_i_5_n_0\,
      I4 => \^de_reg2\,
      I5 => \^c0_reg2\,
      O => data_out(7)
    );
\data_out[8]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"C5"
    )
        port map (
      I0 => \^c0_reg2\,
      I1 => q_m_reg(8),
      I2 => \^de_reg2\,
      O => data_out(8)
    );
\data_out[8]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"C5"
    )
        port map (
      I0 => \^c0_reg2\,
      I1 => \data_out_reg[9]_5\(0),
      I2 => \^de_reg2\,
      O => c0_reg2_reg_0(0)
    );
\data_out[8]_i_1__1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"C5"
    )
        port map (
      I0 => \^c0_reg2\,
      I1 => Q(0),
      I2 => \^de_reg2\,
      O => D(0)
    );
\data_out[9]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F000F0FF99999999"
    )
        port map (
      I0 => \^c0_reg2\,
      I1 => c1_reg2,
      I2 => \cnt[4]_i_5_n_0\,
      I3 => \cnt[4]_i_3_n_0\,
      I4 => q_m_reg(8),
      I5 => \^de_reg2\,
      O => \data_out[9]_i_1_n_0\
    );
\data_out[9]_i_1__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"09F9090909F9F9F9"
    )
        port map (
      I0 => \^c0_reg2\,
      I1 => c1_reg2,
      I2 => \^de_reg2\,
      I3 => \data_out_reg[9]_1\,
      I4 => \data_out_reg[9]_2\,
      I5 => Q(0),
      O => D(1)
    );
\data_out[9]_i_1__1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F000F0FF99999999"
    )
        port map (
      I0 => \^c0_reg2\,
      I1 => c1_reg2,
      I2 => \data_out_reg[9]_3\,
      I3 => \data_out_reg[9]_4\,
      I4 => \data_out_reg[9]_5\(0),
      I5 => \^de_reg2\,
      O => c0_reg2_reg_0(1)
    );
\data_out_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => data_out(0),
      Q => \data_out_reg[9]_0\(0)
    );
\data_out_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => data_out(1),
      Q => \data_out_reg[9]_0\(1)
    );
\data_out_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => data_out(2),
      Q => \data_out_reg[9]_0\(2)
    );
\data_out_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => data_out(3),
      Q => \data_out_reg[9]_0\(3)
    );
\data_out_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => data_out(4),
      Q => \data_out_reg[9]_0\(4)
    );
\data_out_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => data_out(5),
      Q => \data_out_reg[9]_0\(5)
    );
\data_out_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => data_out(6),
      Q => \data_out_reg[9]_0\(6)
    );
\data_out_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => data_out(7),
      Q => \data_out_reg[9]_0\(7)
    );
\data_out_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => data_out(8),
      Q => \data_out_reg[9]_0\(8)
    );
\data_out_reg[9]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => \data_out[9]_i_1_n_0\,
      Q => \data_out_reg[9]_0\(9)
    );
de_reg1_reg: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => video_de,
      Q => de_reg1
    );
de_reg2_reg: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => de_reg1,
      Q => \^de_reg2\
    );
\q_m_n0[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9996699996669996"
    )
        port map (
      I0 => \q_m_n1[3]_i_3_n_0\,
      I1 => \q_m_n1[3]_i_2_n_0\,
      I2 => \q_m_n1[3]_i_5_n_0\,
      I3 => \q_m_n1[3]_i_4_n_0\,
      I4 => \data_in_reg_reg_n_0_[0]\,
      I5 => \q_m_n1[3]_i_6_n_0\,
      O => q_m_n00(1)
    );
\q_m_n0[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"2000FBB2FBB2DFFF"
    )
        port map (
      I0 => \q_m_n1[3]_i_6_n_0\,
      I1 => \data_in_reg_reg_n_0_[0]\,
      I2 => \q_m_n1[3]_i_4_n_0\,
      I3 => \q_m_n1[3]_i_5_n_0\,
      I4 => \q_m_n1[3]_i_2_n_0\,
      I5 => \q_m_n1[3]_i_3_n_0\,
      O => q_m_n00(2)
    );
\q_m_n0[3]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0100000000000000"
    )
        port map (
      I0 => \q_m_n1[3]_i_2_n_0\,
      I1 => \q_m_n1[3]_i_3_n_0\,
      I2 => \data_in_reg_reg_n_0_[0]\,
      I3 => \q_m_n1[3]_i_4_n_0\,
      I4 => \q_m_n1[3]_i_5_n_0\,
      I5 => \q_m_n1[3]_i_6_n_0\,
      O => q_m_n00(3)
    );
\q_m_n0_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => q_m_n00(1),
      Q => q_m_n0(1)
    );
\q_m_n0_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => q_m_n00(2),
      Q => q_m_n0(2)
    );
\q_m_n0_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => q_m_n00(3),
      Q => q_m_n0(3)
    );
\q_m_n1[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6696969996999969"
    )
        port map (
      I0 => \q_m_n1[3]_i_2_n_0\,
      I1 => \q_m_n1[3]_i_3_n_0\,
      I2 => \data_in_reg_reg_n_0_[0]\,
      I3 => \q_m_n1[3]_i_4_n_0\,
      I4 => \q_m_n1[3]_i_5_n_0\,
      I5 => \q_m_n1[3]_i_6_n_0\,
      O => q_m_n10(1)
    );
\q_m_n1[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFEF71F771F70010"
    )
        port map (
      I0 => \q_m_n1[3]_i_5_n_0\,
      I1 => \q_m_n1[3]_i_4_n_0\,
      I2 => \data_in_reg_reg_n_0_[0]\,
      I3 => \q_m_n1[3]_i_6_n_0\,
      I4 => \q_m_n1[3]_i_3_n_0\,
      I5 => \q_m_n1[3]_i_2_n_0\,
      O => \q_m_n1[2]_i_1_n_0\
    );
\q_m_n1[3]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000080"
    )
        port map (
      I0 => \q_m_n1[3]_i_2_n_0\,
      I1 => \q_m_n1[3]_i_3_n_0\,
      I2 => \data_in_reg_reg_n_0_[0]\,
      I3 => \q_m_n1[3]_i_4_n_0\,
      I4 => \q_m_n1[3]_i_5_n_0\,
      I5 => \q_m_n1[3]_i_6_n_0\,
      O => q_m_n10(3)
    );
\q_m_n1[3]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B42D4BD2"
    )
        port map (
      I0 => \q_m_reg[7]_i_2_n_0\,
      I1 => p_0_in3_in,
      I2 => \data_in_reg_reg_n_0_[0]\,
      I3 => p_0_in4_in,
      I4 => p_0_in5_in,
      O => \q_m_n1[3]_i_2_n_0\
    );
\q_m_n1[3]_i_3\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"E11E1EE178878778"
    )
        port map (
      I0 => p_0_in0_in,
      I1 => \q_m_reg[7]_i_2_n_0\,
      I2 => q_m_2,
      I3 => p_0_in2_in,
      I4 => p_0_in3_in,
      I5 => p_0_in1_in,
      O => \q_m_n1[3]_i_3_n_0\
    );
\q_m_n1[3]_i_4\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9669699669969669"
    )
        port map (
      I0 => p_0_in3_in,
      I1 => p_0_in2_in,
      I2 => \data_in_reg_reg_n_0_[0]\,
      I3 => p_0_in4_in,
      I4 => p_0_in5_in,
      I5 => \q_m_n1[3]_i_7_n_0\,
      O => \q_m_n1[3]_i_4_n_0\
    );
\q_m_n1[3]_i_5\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"96696996"
    )
        port map (
      I0 => p_0_in0_in,
      I1 => \q_m_reg[7]_i_3_n_0\,
      I2 => p_0_in1_in,
      I3 => \q_m_reg[7]_i_2_n_0\,
      I4 => p_0_in,
      O => \q_m_n1[3]_i_5_n_0\
    );
\q_m_n1[3]_i_6\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"69"
    )
        port map (
      I0 => \data_in_reg_reg_n_0_[0]\,
      I1 => p_0_in5_in,
      I2 => p_0_in3_in,
      O => \q_m_n1[3]_i_6_n_0\
    );
\q_m_n1[3]_i_7\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5555555566666A66"
    )
        port map (
      I0 => p_0_in0_in,
      I1 => data_in_n1(2),
      I2 => data_in_n1(0),
      I3 => \data_in_reg_reg_n_0_[0]\,
      I4 => data_in_n1(1),
      I5 => data_in_n1(3),
      O => \q_m_n1[3]_i_7_n_0\
    );
\q_m_n1_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => q_m_n10(1),
      Q => q_m_n1(1)
    );
\q_m_n1_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => \q_m_n1[2]_i_1_n_0\,
      Q => q_m_n1(2)
    );
\q_m_n1_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => q_m_n10(3),
      Q => q_m_n1(3)
    );
\q_m_reg[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFA800570055FFAA"
    )
        port map (
      I0 => data_in_n1(2),
      I1 => data_in_n1(0),
      I2 => data_in_n1(1),
      I3 => data_in_n1(3),
      I4 => p_0_in5_in,
      I5 => \data_in_reg_reg_n_0_[0]\,
      O => q_m_1
    );
\q_m_reg[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => \data_in_reg_reg_n_0_[0]\,
      I1 => p_0_in4_in,
      I2 => p_0_in5_in,
      O => q_m_2
    );
\q_m_reg[3]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"96696996"
    )
        port map (
      I0 => p_0_in5_in,
      I1 => p_0_in4_in,
      I2 => \data_in_reg_reg_n_0_[0]\,
      I3 => p_0_in3_in,
      I4 => \q_m_reg[7]_i_2_n_0\,
      O => q_m_3
    );
\q_m_reg[4]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"96696996"
    )
        port map (
      I0 => p_0_in3_in,
      I1 => p_0_in2_in,
      I2 => \data_in_reg_reg_n_0_[0]\,
      I3 => p_0_in4_in,
      I4 => p_0_in5_in,
      O => q_m_4
    );
\q_m_reg[5]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"96696996"
    )
        port map (
      I0 => \q_m_reg[7]_i_2_n_0\,
      I1 => q_m_2,
      I2 => p_0_in2_in,
      I3 => p_0_in3_in,
      I4 => p_0_in1_in,
      O => \q_m_reg[5]_i_1_n_0\
    );
\q_m_reg[6]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"96696996"
    )
        port map (
      I0 => p_0_in1_in,
      I1 => p_0_in3_in,
      I2 => p_0_in2_in,
      I3 => q_m_2,
      I4 => p_0_in0_in,
      O => q_m_6
    );
\q_m_reg[7]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"69969669"
    )
        port map (
      I0 => p_0_in,
      I1 => \q_m_reg[7]_i_2_n_0\,
      I2 => p_0_in1_in,
      I3 => \q_m_reg[7]_i_3_n_0\,
      I4 => p_0_in0_in,
      O => q_m_7
    );
\q_m_reg[7]_i_2\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFEFAAAA"
    )
        port map (
      I0 => data_in_n1(3),
      I1 => data_in_n1(1),
      I2 => \data_in_reg_reg_n_0_[0]\,
      I3 => data_in_n1(0),
      I4 => data_in_n1(2),
      O => \q_m_reg[7]_i_2_n_0\
    );
\q_m_reg[7]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"69969669"
    )
        port map (
      I0 => p_0_in5_in,
      I1 => p_0_in4_in,
      I2 => \data_in_reg_reg_n_0_[0]\,
      I3 => p_0_in2_in,
      I4 => p_0_in3_in,
      O => \q_m_reg[7]_i_3_n_0\
    );
\q_m_reg[8]_i_1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00005575"
    )
        port map (
      I0 => data_in_n1(2),
      I1 => data_in_n1(0),
      I2 => \data_in_reg_reg_n_0_[0]\,
      I3 => data_in_n1(1),
      I4 => data_in_n1(3),
      O => q_m(8)
    );
\q_m_reg_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => \data_in_reg_reg_n_0_[0]\,
      Q => q_m_reg(0)
    );
\q_m_reg_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => q_m_1,
      Q => q_m_reg(1)
    );
\q_m_reg_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => q_m_2,
      Q => q_m_reg(2)
    );
\q_m_reg_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => q_m_3,
      Q => q_m_reg(3)
    );
\q_m_reg_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => q_m_4,
      Q => q_m_reg(4)
    );
\q_m_reg_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => \q_m_reg[5]_i_1_n_0\,
      Q => q_m_reg(5)
    );
\q_m_reg_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => q_m_6,
      Q => q_m_reg(6)
    );
\q_m_reg_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => q_m_7,
      Q => q_m_reg(7)
    );
\q_m_reg_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \^rst_n_0\,
      D => q_m(8),
      Q => q_m_reg(8)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_encode_0 is
  port (
    \cnt_reg[2]_0\ : out STD_LOGIC;
    \cnt_reg[4]_0\ : out STD_LOGIC;
    Q : out STD_LOGIC_VECTOR ( 0 to 0 );
    \data_out_reg[9]_0\ : out STD_LOGIC_VECTOR ( 9 downto 0 );
    de_reg2 : in STD_LOGIC;
    c0_reg2 : in STD_LOGIC;
    video_din : in STD_LOGIC_VECTOR ( 7 downto 0 );
    pclk : in STD_LOGIC;
    \data_out_reg[0]_0\ : in STD_LOGIC;
    D : in STD_LOGIC_VECTOR ( 1 downto 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_encode_0 : entity is "encode";
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_encode_0;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_encode_0 is
  signal \^q\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal cnt : STD_LOGIC_VECTOR ( 4 downto 1 );
  signal \cnt[1]_i_1__0_n_0\ : STD_LOGIC;
  signal \cnt[1]_i_2__0_n_0\ : STD_LOGIC;
  signal \cnt[1]_i_3__1_n_0\ : STD_LOGIC;
  signal \cnt[2]_i_1__0_n_0\ : STD_LOGIC;
  signal \cnt[2]_i_2__0_n_0\ : STD_LOGIC;
  signal \cnt[2]_i_3__1_n_0\ : STD_LOGIC;
  signal \cnt[2]_i_4__0_n_0\ : STD_LOGIC;
  signal \cnt[3]_i_1__1_n_0\ : STD_LOGIC;
  signal \cnt[3]_i_2__0_n_0\ : STD_LOGIC;
  signal \cnt[3]_i_3__0_n_0\ : STD_LOGIC;
  signal \cnt[3]_i_4__0_n_0\ : STD_LOGIC;
  signal \cnt[3]_i_5__0_n_0\ : STD_LOGIC;
  signal \cnt[3]_i_6__0_n_0\ : STD_LOGIC;
  signal \cnt[3]_i_7__0_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_10__0_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_11__0_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_12__0_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_13__0_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_14__0_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_15__1_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_16__0_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_17__0_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_18__0_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_19__0_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_1__0_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_20__1_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_21__0_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_22__0_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_23__0_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_24__0_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_25_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_2__0_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_4__0_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_6__0_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_7__0_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_8__0_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_9__0_n_0\ : STD_LOGIC;
  signal \^cnt_reg[2]_0\ : STD_LOGIC;
  signal \^cnt_reg[4]_0\ : STD_LOGIC;
  signal data_in_n1 : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \data_in_n1[0]_i_1_n_0\ : STD_LOGIC;
  signal \data_in_n1[0]_i_2_n_0\ : STD_LOGIC;
  signal \data_in_n1[1]_i_1_n_0\ : STD_LOGIC;
  signal \data_in_n1[1]_i_2_n_0\ : STD_LOGIC;
  signal \data_in_n1[2]_i_1_n_0\ : STD_LOGIC;
  signal \data_in_n1[2]_i_2_n_0\ : STD_LOGIC;
  signal \data_in_n1[3]_i_1_n_0\ : STD_LOGIC;
  signal \data_in_n1[3]_i_2_n_0\ : STD_LOGIC;
  signal \data_in_n1[3]_i_3_n_0\ : STD_LOGIC;
  signal \data_in_n1[3]_i_4_n_0\ : STD_LOGIC;
  signal \data_in_reg_reg_n_0_[0]\ : STD_LOGIC;
  signal \data_out[0]_i_1__0_n_0\ : STD_LOGIC;
  signal \data_out[1]_i_1__0_n_0\ : STD_LOGIC;
  signal \data_out[2]_i_1__0_n_0\ : STD_LOGIC;
  signal \data_out[3]_i_1__0_n_0\ : STD_LOGIC;
  signal \data_out[4]_i_1__0_n_0\ : STD_LOGIC;
  signal \data_out[5]_i_1__0_n_0\ : STD_LOGIC;
  signal \data_out[6]_i_1__0_n_0\ : STD_LOGIC;
  signal \data_out[7]_i_1__0_n_0\ : STD_LOGIC;
  signal p_0_in : STD_LOGIC;
  signal p_0_in0_in : STD_LOGIC;
  signal p_0_in1_in : STD_LOGIC;
  signal p_0_in2_in : STD_LOGIC;
  signal p_0_in3_in : STD_LOGIC;
  signal p_0_in4_in : STD_LOGIC;
  signal p_0_in5_in : STD_LOGIC;
  signal q_m : STD_LOGIC_VECTOR ( 8 to 8 );
  signal q_m_1 : STD_LOGIC;
  signal q_m_2 : STD_LOGIC;
  signal q_m_3 : STD_LOGIC;
  signal q_m_4 : STD_LOGIC;
  signal q_m_6 : STD_LOGIC;
  signal q_m_7 : STD_LOGIC;
  signal \q_m_n0[1]_i_1__0_n_0\ : STD_LOGIC;
  signal \q_m_n0[2]_i_1__0_n_0\ : STD_LOGIC;
  signal \q_m_n0[3]_i_1__0_n_0\ : STD_LOGIC;
  signal \q_m_n0_reg_n_0_[1]\ : STD_LOGIC;
  signal \q_m_n0_reg_n_0_[2]\ : STD_LOGIC;
  signal \q_m_n0_reg_n_0_[3]\ : STD_LOGIC;
  signal \q_m_n1[1]_i_1__0_n_0\ : STD_LOGIC;
  signal \q_m_n1[2]_i_1__0_n_0\ : STD_LOGIC;
  signal \q_m_n1[3]_i_1__0_n_0\ : STD_LOGIC;
  signal \q_m_n1[3]_i_2__0_n_0\ : STD_LOGIC;
  signal \q_m_n1[3]_i_3__0_n_0\ : STD_LOGIC;
  signal \q_m_n1[3]_i_4__0_n_0\ : STD_LOGIC;
  signal \q_m_n1[3]_i_5__0_n_0\ : STD_LOGIC;
  signal \q_m_n1[3]_i_6__0_n_0\ : STD_LOGIC;
  signal \q_m_n1[3]_i_7__0_n_0\ : STD_LOGIC;
  signal \q_m_n1_reg_n_0_[1]\ : STD_LOGIC;
  signal \q_m_n1_reg_n_0_[2]\ : STD_LOGIC;
  signal \q_m_n1_reg_n_0_[3]\ : STD_LOGIC;
  signal \q_m_reg[5]_i_1__0_n_0\ : STD_LOGIC;
  signal \q_m_reg[7]_i_2__0_n_0\ : STD_LOGIC;
  signal \q_m_reg[7]_i_3__0_n_0\ : STD_LOGIC;
  signal \q_m_reg_reg_n_0_[0]\ : STD_LOGIC;
  signal \q_m_reg_reg_n_0_[1]\ : STD_LOGIC;
  signal \q_m_reg_reg_n_0_[2]\ : STD_LOGIC;
  signal \q_m_reg_reg_n_0_[3]\ : STD_LOGIC;
  signal \q_m_reg_reg_n_0_[4]\ : STD_LOGIC;
  signal \q_m_reg_reg_n_0_[5]\ : STD_LOGIC;
  signal \q_m_reg_reg_n_0_[6]\ : STD_LOGIC;
  signal \q_m_reg_reg_n_0_[7]\ : STD_LOGIC;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \cnt[1]_i_2__0\ : label is "soft_lutpair31";
  attribute SOFT_HLUTNM of \cnt[1]_i_3__1\ : label is "soft_lutpair27";
  attribute SOFT_HLUTNM of \cnt[2]_i_2__0\ : label is "soft_lutpair17";
  attribute SOFT_HLUTNM of \cnt[2]_i_3__1\ : label is "soft_lutpair17";
  attribute SOFT_HLUTNM of \cnt[2]_i_4__0\ : label is "soft_lutpair20";
  attribute SOFT_HLUTNM of \cnt[3]_i_5__0\ : label is "soft_lutpair31";
  attribute SOFT_HLUTNM of \cnt[4]_i_10__0\ : label is "soft_lutpair29";
  attribute SOFT_HLUTNM of \cnt[4]_i_11__0\ : label is "soft_lutpair28";
  attribute SOFT_HLUTNM of \cnt[4]_i_12__0\ : label is "soft_lutpair28";
  attribute SOFT_HLUTNM of \cnt[4]_i_14__0\ : label is "soft_lutpair21";
  attribute SOFT_HLUTNM of \cnt[4]_i_15__1\ : label is "soft_lutpair20";
  attribute SOFT_HLUTNM of \cnt[4]_i_16__0\ : label is "soft_lutpair30";
  attribute SOFT_HLUTNM of \cnt[4]_i_20__1\ : label is "soft_lutpair18";
  attribute SOFT_HLUTNM of \cnt[4]_i_21__0\ : label is "soft_lutpair19";
  attribute SOFT_HLUTNM of \cnt[4]_i_22__0\ : label is "soft_lutpair29";
  attribute SOFT_HLUTNM of \cnt[4]_i_23__0\ : label is "soft_lutpair30";
  attribute SOFT_HLUTNM of \cnt[4]_i_24__0\ : label is "soft_lutpair19";
  attribute SOFT_HLUTNM of \cnt[4]_i_7__0\ : label is "soft_lutpair21";
  attribute SOFT_HLUTNM of \cnt[4]_i_8__0\ : label is "soft_lutpair18";
  attribute SOFT_HLUTNM of \cnt[4]_i_9__0\ : label is "soft_lutpair27";
  attribute SOFT_HLUTNM of \data_in_n1[0]_i_2\ : label is "soft_lutpair22";
  attribute SOFT_HLUTNM of \data_in_n1[3]_i_3\ : label is "soft_lutpair22";
  attribute SOFT_HLUTNM of \q_m_n1[3]_i_2__0\ : label is "soft_lutpair23";
  attribute SOFT_HLUTNM of \q_m_n1[3]_i_5__0\ : label is "soft_lutpair24";
  attribute SOFT_HLUTNM of \q_m_n1[3]_i_6__0\ : label is "soft_lutpair32";
  attribute SOFT_HLUTNM of \q_m_reg[2]_i_1__0\ : label is "soft_lutpair32";
  attribute SOFT_HLUTNM of \q_m_reg[3]_i_1__0\ : label is "soft_lutpair23";
  attribute SOFT_HLUTNM of \q_m_reg[4]_i_1__0\ : label is "soft_lutpair26";
  attribute SOFT_HLUTNM of \q_m_reg[7]_i_1__0\ : label is "soft_lutpair24";
  attribute SOFT_HLUTNM of \q_m_reg[7]_i_2__0\ : label is "soft_lutpair25";
  attribute SOFT_HLUTNM of \q_m_reg[7]_i_3__0\ : label is "soft_lutpair26";
  attribute SOFT_HLUTNM of \q_m_reg[8]_i_1__0\ : label is "soft_lutpair25";
begin
  Q(0) <= \^q\(0);
  \cnt_reg[2]_0\ <= \^cnt_reg[2]_0\;
  \cnt_reg[4]_0\ <= \^cnt_reg[4]_0\;
\cnt[1]_i_1__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"AA2800280028AA28"
    )
        port map (
      I0 => de_reg2,
      I1 => \cnt[1]_i_2__0_n_0\,
      I2 => cnt(1),
      I3 => \^cnt_reg[2]_0\,
      I4 => \cnt[1]_i_3__1_n_0\,
      I5 => \^cnt_reg[4]_0\,
      O => \cnt[1]_i_1__0_n_0\
    );
\cnt[1]_i_2__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \q_m_n1_reg_n_0_[1]\,
      I1 => \q_m_n0_reg_n_0_[1]\,
      O => \cnt[1]_i_2__0_n_0\
    );
\cnt[1]_i_3__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9669"
    )
        port map (
      I0 => cnt(1),
      I1 => \q_m_n0_reg_n_0_[1]\,
      I2 => \^q\(0),
      I3 => \q_m_n1_reg_n_0_[1]\,
      O => \cnt[1]_i_3__1_n_0\
    );
\cnt[2]_i_1__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"020202A2A2A202A2"
    )
        port map (
      I0 => de_reg2,
      I1 => \cnt[2]_i_2__0_n_0\,
      I2 => \^cnt_reg[2]_0\,
      I3 => \cnt[2]_i_3__1_n_0\,
      I4 => \^cnt_reg[4]_0\,
      I5 => \cnt[2]_i_4__0_n_0\,
      O => \cnt[2]_i_1__0_n_0\
    );
\cnt[2]_i_2__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"55966955"
    )
        port map (
      I0 => \cnt[4]_i_11__0_n_0\,
      I1 => cnt(1),
      I2 => \^q\(0),
      I3 => \q_m_n0_reg_n_0_[1]\,
      I4 => \q_m_n1_reg_n_0_[1]\,
      O => \cnt[2]_i_2__0_n_0\
    );
\cnt[2]_i_3__1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"8E1871E7"
    )
        port map (
      I0 => cnt(1),
      I1 => \q_m_n0_reg_n_0_[1]\,
      I2 => \q_m_n1_reg_n_0_[1]\,
      I3 => \^q\(0),
      I4 => \cnt[4]_i_11__0_n_0\,
      O => \cnt[2]_i_3__1_n_0\
    );
\cnt[2]_i_4__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"2D4B4BD2"
    )
        port map (
      I0 => \^q\(0),
      I1 => \q_m_n0_reg_n_0_[1]\,
      I2 => \cnt[4]_i_11__0_n_0\,
      I3 => \q_m_n1_reg_n_0_[1]\,
      I4 => cnt(1),
      O => \cnt[2]_i_4__0_n_0\
    );
\cnt[3]_i_1__1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"EEE222E200000000"
    )
        port map (
      I0 => \cnt[3]_i_2__0_n_0\,
      I1 => \^cnt_reg[2]_0\,
      I2 => \cnt[3]_i_3__0_n_0\,
      I3 => \^cnt_reg[4]_0\,
      I4 => \cnt[3]_i_4__0_n_0\,
      I5 => de_reg2,
      O => \cnt[3]_i_1__1_n_0\
    );
\cnt[3]_i_2__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8E8A717571758E8A"
    )
        port map (
      I0 => \cnt[4]_i_11__0_n_0\,
      I1 => \cnt[3]_i_5__0_n_0\,
      I2 => cnt(1),
      I3 => \cnt[1]_i_2__0_n_0\,
      I4 => \cnt[4]_i_12__0_n_0\,
      I5 => \cnt[4]_i_8__0_n_0\,
      O => \cnt[3]_i_2__0_n_0\
    );
\cnt[3]_i_3__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9C3CCC9C3C399C3C"
    )
        port map (
      I0 => cnt(1),
      I1 => \cnt[3]_i_6__0_n_0\,
      I2 => \cnt[4]_i_11__0_n_0\,
      I3 => \^q\(0),
      I4 => \q_m_n1_reg_n_0_[1]\,
      I5 => \q_m_n0_reg_n_0_[1]\,
      O => \cnt[3]_i_3__0_n_0\
    );
\cnt[3]_i_4__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"D5542AAB2AABD554"
    )
        port map (
      I0 => \cnt[4]_i_24__0_n_0\,
      I1 => \q_m_n1_reg_n_0_[1]\,
      I2 => \cnt[3]_i_7__0_n_0\,
      I3 => cnt(1),
      I4 => \cnt[4]_i_20__1_n_0\,
      I5 => \cnt[4]_i_21__0_n_0\,
      O => \cnt[3]_i_4__0_n_0\
    );
\cnt[3]_i_5__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"DB"
    )
        port map (
      I0 => \q_m_n1_reg_n_0_[1]\,
      I1 => \q_m_n0_reg_n_0_[1]\,
      I2 => \^q\(0),
      O => \cnt[3]_i_5__0_n_0\
    );
\cnt[3]_i_6__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6969966996699696"
    )
        port map (
      I0 => \q_m_n1_reg_n_0_[3]\,
      I1 => \q_m_n0_reg_n_0_[3]\,
      I2 => cnt(3),
      I3 => \q_m_n1_reg_n_0_[2]\,
      I4 => \q_m_n0_reg_n_0_[2]\,
      I5 => cnt(2),
      O => \cnt[3]_i_6__0_n_0\
    );
\cnt[3]_i_7__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \q_m_n0_reg_n_0_[1]\,
      I1 => \^q\(0),
      O => \cnt[3]_i_7__0_n_0\
    );
\cnt[4]_i_10__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0820"
    )
        port map (
      I0 => cnt(1),
      I1 => \^q\(0),
      I2 => \q_m_n0_reg_n_0_[1]\,
      I3 => \q_m_n1_reg_n_0_[1]\,
      O => \cnt[4]_i_10__0_n_0\
    );
\cnt[4]_i_11__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => cnt(2),
      I1 => \q_m_n0_reg_n_0_[2]\,
      I2 => \q_m_n1_reg_n_0_[2]\,
      O => \cnt[4]_i_11__0_n_0\
    );
\cnt[4]_i_12__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B28E"
    )
        port map (
      I0 => cnt(2),
      I1 => \q_m_n0_reg_n_0_[2]\,
      I2 => \q_m_n1_reg_n_0_[2]\,
      I3 => \^q\(0),
      O => \cnt[4]_i_12__0_n_0\
    );
\cnt[4]_i_13__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \q_m_n0_reg_n_0_[1]\,
      I1 => \q_m_n1_reg_n_0_[1]\,
      I2 => \q_m_n1_reg_n_0_[2]\,
      I3 => \q_m_n0_reg_n_0_[2]\,
      I4 => \q_m_n1_reg_n_0_[3]\,
      I5 => \q_m_n0_reg_n_0_[3]\,
      O => \cnt[4]_i_13__0_n_0\
    );
\cnt[4]_i_14__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"A665"
    )
        port map (
      I0 => cnt(4),
      I1 => \q_m_n1_reg_n_0_[3]\,
      I2 => \q_m_n0_reg_n_0_[3]\,
      I3 => cnt(3),
      O => \cnt[4]_i_14__0_n_0\
    );
\cnt[4]_i_15__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BEEB"
    )
        port map (
      I0 => cnt(1),
      I1 => \q_m_n0_reg_n_0_[1]\,
      I2 => \^q\(0),
      I3 => \q_m_n1_reg_n_0_[1]\,
      O => \cnt[4]_i_15__1_n_0\
    );
\cnt[4]_i_16__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B2"
    )
        port map (
      I0 => \q_m_n0_reg_n_0_[1]\,
      I1 => \q_m_n1_reg_n_0_[1]\,
      I2 => \^q\(0),
      O => \cnt[4]_i_16__0_n_0\
    );
\cnt[4]_i_17__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"8E"
    )
        port map (
      I0 => cnt(2),
      I1 => \q_m_n0_reg_n_0_[2]\,
      I2 => \q_m_n1_reg_n_0_[2]\,
      O => \cnt[4]_i_17__0_n_0\
    );
\cnt[4]_i_18__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"D4DD0000FFFFD4DD"
    )
        port map (
      I0 => \q_m_n1_reg_n_0_[2]\,
      I1 => \q_m_n0_reg_n_0_[2]\,
      I2 => \q_m_n0_reg_n_0_[1]\,
      I3 => \q_m_n1_reg_n_0_[1]\,
      I4 => \q_m_n0_reg_n_0_[3]\,
      I5 => \q_m_n1_reg_n_0_[3]\,
      O => \cnt[4]_i_18__0_n_0\
    );
\cnt[4]_i_19__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"B2BB0000FFFFB2BB"
    )
        port map (
      I0 => \q_m_n1_reg_n_0_[2]\,
      I1 => \q_m_n0_reg_n_0_[2]\,
      I2 => \q_m_n1_reg_n_0_[1]\,
      I3 => \q_m_n0_reg_n_0_[1]\,
      I4 => \q_m_n1_reg_n_0_[3]\,
      I5 => \q_m_n0_reg_n_0_[3]\,
      O => \cnt[4]_i_19__0_n_0\
    );
\cnt[4]_i_1__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"020202A2A2A202A2"
    )
        port map (
      I0 => de_reg2,
      I1 => \cnt[4]_i_2__0_n_0\,
      I2 => \^cnt_reg[2]_0\,
      I3 => \cnt[4]_i_4__0_n_0\,
      I4 => \^cnt_reg[4]_0\,
      I5 => \cnt[4]_i_6__0_n_0\,
      O => \cnt[4]_i_1__0_n_0\
    );
\cnt[4]_i_20__1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"4BB4B44B"
    )
        port map (
      I0 => \q_m_n1_reg_n_0_[2]\,
      I1 => \q_m_n0_reg_n_0_[2]\,
      I2 => \q_m_n1_reg_n_0_[3]\,
      I3 => \q_m_n0_reg_n_0_[3]\,
      I4 => cnt(3),
      O => \cnt[4]_i_20__1_n_0\
    );
\cnt[4]_i_21__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"DFFD0DD0"
    )
        port map (
      I0 => \q_m_n0_reg_n_0_[1]\,
      I1 => \^q\(0),
      I2 => \q_m_n1_reg_n_0_[2]\,
      I3 => \q_m_n0_reg_n_0_[2]\,
      I4 => cnt(2),
      O => \cnt[4]_i_21__0_n_0\
    );
\cnt[4]_i_22__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0009"
    )
        port map (
      I0 => \^q\(0),
      I1 => \q_m_n0_reg_n_0_[1]\,
      I2 => cnt(1),
      I3 => \q_m_n1_reg_n_0_[1]\,
      O => \cnt[4]_i_22__0_n_0\
    );
\cnt[4]_i_23__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2800"
    )
        port map (
      I0 => cnt(1),
      I1 => \q_m_n0_reg_n_0_[1]\,
      I2 => \^q\(0),
      I3 => \q_m_n1_reg_n_0_[1]\,
      O => \cnt[4]_i_23__0_n_0\
    );
\cnt[4]_i_24__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B44B4BB4"
    )
        port map (
      I0 => \^q\(0),
      I1 => \q_m_n0_reg_n_0_[1]\,
      I2 => \q_m_n1_reg_n_0_[2]\,
      I3 => \q_m_n0_reg_n_0_[2]\,
      I4 => cnt(2),
      O => \cnt[4]_i_24__0_n_0\
    );
\cnt[4]_i_25\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9A55AA9A55659A55"
    )
        port map (
      I0 => cnt(4),
      I1 => \q_m_n1_reg_n_0_[2]\,
      I2 => \q_m_n0_reg_n_0_[2]\,
      I3 => \q_m_n1_reg_n_0_[3]\,
      I4 => \q_m_n0_reg_n_0_[3]\,
      I5 => cnt(3),
      O => \cnt[4]_i_25_n_0\
    );
\cnt[4]_i_2__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"599959599AAA9A9A"
    )
        port map (
      I0 => \cnt[4]_i_7__0_n_0\,
      I1 => \cnt[4]_i_8__0_n_0\,
      I2 => \cnt[4]_i_9__0_n_0\,
      I3 => \cnt[4]_i_10__0_n_0\,
      I4 => \cnt[4]_i_11__0_n_0\,
      I5 => \cnt[4]_i_12__0_n_0\,
      O => \cnt[4]_i_2__0_n_0\
    );
\cnt[4]_i_3__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"55555554"
    )
        port map (
      I0 => \cnt[4]_i_13__0_n_0\,
      I1 => cnt(2),
      I2 => cnt(4),
      I3 => cnt(1),
      I4 => cnt(3),
      O => \^cnt_reg[2]_0\
    );
\cnt[4]_i_4__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"95A9AAAA555595A9"
    )
        port map (
      I0 => \cnt[4]_i_14__0_n_0\,
      I1 => \cnt[4]_i_15__1_n_0\,
      I2 => \cnt[4]_i_16__0_n_0\,
      I3 => \cnt[4]_i_11__0_n_0\,
      I4 => \cnt[4]_i_8__0_n_0\,
      I5 => \cnt[4]_i_17__0_n_0\,
      O => \cnt[4]_i_4__0_n_0\
    );
\cnt[4]_i_6__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8E888E8E71777171"
    )
        port map (
      I0 => \cnt[4]_i_20__1_n_0\,
      I1 => \cnt[4]_i_21__0_n_0\,
      I2 => \cnt[4]_i_22__0_n_0\,
      I3 => \cnt[4]_i_23__0_n_0\,
      I4 => \cnt[4]_i_24__0_n_0\,
      I5 => \cnt[4]_i_25_n_0\,
      O => \cnt[4]_i_6__0_n_0\
    );
\cnt[4]_i_7__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"5965A96A"
    )
        port map (
      I0 => cnt(4),
      I1 => \^q\(0),
      I2 => \q_m_n1_reg_n_0_[3]\,
      I3 => \q_m_n0_reg_n_0_[3]\,
      I4 => cnt(3),
      O => \cnt[4]_i_7__0_n_0\
    );
\cnt[4]_i_8__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => cnt(3),
      I1 => \q_m_n0_reg_n_0_[3]\,
      I2 => \q_m_n1_reg_n_0_[3]\,
      O => \cnt[4]_i_8__0_n_0\
    );
\cnt[4]_i_9__0\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FEBF"
    )
        port map (
      I0 => cnt(1),
      I1 => \^q\(0),
      I2 => \q_m_n0_reg_n_0_[1]\,
      I3 => \q_m_n1_reg_n_0_[1]\,
      O => \cnt[4]_i_9__0_n_0\
    );
\cnt_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[0]_0\,
      D => \cnt[1]_i_1__0_n_0\,
      Q => cnt(1)
    );
\cnt_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[0]_0\,
      D => \cnt[2]_i_1__0_n_0\,
      Q => cnt(2)
    );
\cnt_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[0]_0\,
      D => \cnt[3]_i_1__1_n_0\,
      Q => cnt(3)
    );
\cnt_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[0]_0\,
      D => \cnt[4]_i_1__0_n_0\,
      Q => cnt(4)
    );
\cnt_reg[4]_i_5\: unisim.vcomponents.MUXF7
     port map (
      I0 => \cnt[4]_i_18__0_n_0\,
      I1 => \cnt[4]_i_19__0_n_0\,
      O => \^cnt_reg[4]_0\,
      S => cnt(4)
    );
\data_in_n1[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6996966996696996"
    )
        port map (
      I0 => video_din(0),
      I1 => video_din(7),
      I2 => \data_in_n1[0]_i_2_n_0\,
      I3 => video_din(2),
      I4 => video_din(1),
      I5 => video_din(3),
      O => \data_in_n1[0]_i_1_n_0\
    );
\data_in_n1[0]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => video_din(6),
      I1 => video_din(4),
      I2 => video_din(5),
      O => \data_in_n1[0]_i_2_n_0\
    );
\data_in_n1[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => \data_in_n1[3]_i_2_n_0\,
      I1 => \data_in_n1[1]_i_2_n_0\,
      I2 => \data_in_n1[3]_i_3_n_0\,
      O => \data_in_n1[1]_i_1_n_0\
    );
\data_in_n1[1]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"171717E817E8E8E8"
    )
        port map (
      I0 => video_din(3),
      I1 => video_din(2),
      I2 => video_din(1),
      I3 => video_din(6),
      I4 => video_din(5),
      I5 => video_din(4),
      O => \data_in_n1[1]_i_2_n_0\
    );
\data_in_n1[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"7E7E7EE87EE8E8E8"
    )
        port map (
      I0 => \data_in_n1[3]_i_2_n_0\,
      I1 => \data_in_n1[3]_i_3_n_0\,
      I2 => \data_in_n1[2]_i_2_n_0\,
      I3 => video_din(4),
      I4 => video_din(5),
      I5 => video_din(6),
      O => \data_in_n1[2]_i_1_n_0\
    );
\data_in_n1[2]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E8"
    )
        port map (
      I0 => video_din(1),
      I1 => video_din(2),
      I2 => video_din(3),
      O => \data_in_n1[2]_i_2_n_0\
    );
\data_in_n1[3]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8880800000000000"
    )
        port map (
      I0 => \data_in_n1[3]_i_2_n_0\,
      I1 => \data_in_n1[3]_i_3_n_0\,
      I2 => video_din(3),
      I3 => video_din(2),
      I4 => video_din(1),
      I5 => \data_in_n1[3]_i_4_n_0\,
      O => \data_in_n1[3]_i_1_n_0\
    );
\data_in_n1[3]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9600009600969600"
    )
        port map (
      I0 => video_din(2),
      I1 => video_din(1),
      I2 => video_din(3),
      I3 => video_din(0),
      I4 => video_din(7),
      I5 => \data_in_n1[0]_i_2_n_0\,
      O => \data_in_n1[3]_i_2_n_0\
    );
\data_in_n1[3]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"E88E8EE8"
    )
        port map (
      I0 => video_din(7),
      I1 => video_din(0),
      I2 => video_din(5),
      I3 => video_din(4),
      I4 => video_din(6),
      O => \data_in_n1[3]_i_3_n_0\
    );
\data_in_n1[3]_i_4\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E8"
    )
        port map (
      I0 => video_din(4),
      I1 => video_din(5),
      I2 => video_din(6),
      O => \data_in_n1[3]_i_4_n_0\
    );
\data_in_n1_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[0]_0\,
      D => \data_in_n1[0]_i_1_n_0\,
      Q => data_in_n1(0)
    );
\data_in_n1_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[0]_0\,
      D => \data_in_n1[1]_i_1_n_0\,
      Q => data_in_n1(1)
    );
\data_in_n1_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[0]_0\,
      D => \data_in_n1[2]_i_1_n_0\,
      Q => data_in_n1(2)
    );
\data_in_n1_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[0]_0\,
      D => \data_in_n1[3]_i_1_n_0\,
      Q => data_in_n1(3)
    );
\data_in_reg_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[0]_0\,
      D => video_din(0),
      Q => \data_in_reg_reg_n_0_[0]\
    );
\data_in_reg_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[0]_0\,
      D => video_din(1),
      Q => p_0_in5_in
    );
\data_in_reg_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[0]_0\,
      D => video_din(2),
      Q => p_0_in4_in
    );
\data_in_reg_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[0]_0\,
      D => video_din(3),
      Q => p_0_in3_in
    );
\data_in_reg_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[0]_0\,
      D => video_din(4),
      Q => p_0_in2_in
    );
\data_in_reg_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[0]_0\,
      D => video_din(5),
      Q => p_0_in1_in
    );
\data_in_reg_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[0]_0\,
      D => video_din(6),
      Q => p_0_in0_in
    );
\data_in_reg_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[0]_0\,
      D => video_din(7),
      Q => p_0_in
    );
\data_out[0]_i_1__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"A959FFFFA9590000"
    )
        port map (
      I0 => \q_m_reg_reg_n_0_[0]\,
      I1 => \^q\(0),
      I2 => \^cnt_reg[2]_0\,
      I3 => \^cnt_reg[4]_0\,
      I4 => de_reg2,
      I5 => c0_reg2,
      O => \data_out[0]_i_1__0_n_0\
    );
\data_out[1]_i_1__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"A959FFFFA9590000"
    )
        port map (
      I0 => \q_m_reg_reg_n_0_[1]\,
      I1 => \^q\(0),
      I2 => \^cnt_reg[2]_0\,
      I3 => \^cnt_reg[4]_0\,
      I4 => de_reg2,
      I5 => c0_reg2,
      O => \data_out[1]_i_1__0_n_0\
    );
\data_out[2]_i_1__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"E200E2FF1D001DFF"
    )
        port map (
      I0 => \^q\(0),
      I1 => \^cnt_reg[2]_0\,
      I2 => \^cnt_reg[4]_0\,
      I3 => de_reg2,
      I4 => c0_reg2,
      I5 => \q_m_reg_reg_n_0_[2]\,
      O => \data_out[2]_i_1__0_n_0\
    );
\data_out[3]_i_1__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"A959FFFFA9590000"
    )
        port map (
      I0 => \q_m_reg_reg_n_0_[3]\,
      I1 => \^q\(0),
      I2 => \^cnt_reg[2]_0\,
      I3 => \^cnt_reg[4]_0\,
      I4 => de_reg2,
      I5 => c0_reg2,
      O => \data_out[3]_i_1__0_n_0\
    );
\data_out[4]_i_1__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"E200E2FF1D001DFF"
    )
        port map (
      I0 => \^q\(0),
      I1 => \^cnt_reg[2]_0\,
      I2 => \^cnt_reg[4]_0\,
      I3 => de_reg2,
      I4 => c0_reg2,
      I5 => \q_m_reg_reg_n_0_[4]\,
      O => \data_out[4]_i_1__0_n_0\
    );
\data_out[5]_i_1__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"A959FFFFA9590000"
    )
        port map (
      I0 => \q_m_reg_reg_n_0_[5]\,
      I1 => \^q\(0),
      I2 => \^cnt_reg[2]_0\,
      I3 => \^cnt_reg[4]_0\,
      I4 => de_reg2,
      I5 => c0_reg2,
      O => \data_out[5]_i_1__0_n_0\
    );
\data_out[6]_i_1__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"E200E2FF1D001DFF"
    )
        port map (
      I0 => \^q\(0),
      I1 => \^cnt_reg[2]_0\,
      I2 => \^cnt_reg[4]_0\,
      I3 => de_reg2,
      I4 => c0_reg2,
      I5 => \q_m_reg_reg_n_0_[6]\,
      O => \data_out[6]_i_1__0_n_0\
    );
\data_out[7]_i_1__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"A959FFFFA9590000"
    )
        port map (
      I0 => \q_m_reg_reg_n_0_[7]\,
      I1 => \^q\(0),
      I2 => \^cnt_reg[2]_0\,
      I3 => \^cnt_reg[4]_0\,
      I4 => de_reg2,
      I5 => c0_reg2,
      O => \data_out[7]_i_1__0_n_0\
    );
\data_out_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[0]_0\,
      D => \data_out[0]_i_1__0_n_0\,
      Q => \data_out_reg[9]_0\(0)
    );
\data_out_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[0]_0\,
      D => \data_out[1]_i_1__0_n_0\,
      Q => \data_out_reg[9]_0\(1)
    );
\data_out_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[0]_0\,
      D => \data_out[2]_i_1__0_n_0\,
      Q => \data_out_reg[9]_0\(2)
    );
\data_out_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[0]_0\,
      D => \data_out[3]_i_1__0_n_0\,
      Q => \data_out_reg[9]_0\(3)
    );
\data_out_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[0]_0\,
      D => \data_out[4]_i_1__0_n_0\,
      Q => \data_out_reg[9]_0\(4)
    );
\data_out_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[0]_0\,
      D => \data_out[5]_i_1__0_n_0\,
      Q => \data_out_reg[9]_0\(5)
    );
\data_out_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[0]_0\,
      D => \data_out[6]_i_1__0_n_0\,
      Q => \data_out_reg[9]_0\(6)
    );
\data_out_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[0]_0\,
      D => \data_out[7]_i_1__0_n_0\,
      Q => \data_out_reg[9]_0\(7)
    );
\data_out_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[0]_0\,
      D => D(0),
      Q => \data_out_reg[9]_0\(8)
    );
\data_out_reg[9]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[0]_0\,
      D => D(1),
      Q => \data_out_reg[9]_0\(9)
    );
\q_m_n0[1]_i_1__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9996699996669996"
    )
        port map (
      I0 => \q_m_n1[3]_i_3__0_n_0\,
      I1 => \q_m_n1[3]_i_2__0_n_0\,
      I2 => \q_m_n1[3]_i_5__0_n_0\,
      I3 => \q_m_n1[3]_i_4__0_n_0\,
      I4 => \data_in_reg_reg_n_0_[0]\,
      I5 => \q_m_n1[3]_i_6__0_n_0\,
      O => \q_m_n0[1]_i_1__0_n_0\
    );
\q_m_n0[2]_i_1__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"2000FBB2FBB2DFFF"
    )
        port map (
      I0 => \q_m_n1[3]_i_6__0_n_0\,
      I1 => \data_in_reg_reg_n_0_[0]\,
      I2 => \q_m_n1[3]_i_4__0_n_0\,
      I3 => \q_m_n1[3]_i_5__0_n_0\,
      I4 => \q_m_n1[3]_i_2__0_n_0\,
      I5 => \q_m_n1[3]_i_3__0_n_0\,
      O => \q_m_n0[2]_i_1__0_n_0\
    );
\q_m_n0[3]_i_1__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0100000000000000"
    )
        port map (
      I0 => \q_m_n1[3]_i_2__0_n_0\,
      I1 => \q_m_n1[3]_i_3__0_n_0\,
      I2 => \data_in_reg_reg_n_0_[0]\,
      I3 => \q_m_n1[3]_i_4__0_n_0\,
      I4 => \q_m_n1[3]_i_5__0_n_0\,
      I5 => \q_m_n1[3]_i_6__0_n_0\,
      O => \q_m_n0[3]_i_1__0_n_0\
    );
\q_m_n0_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[0]_0\,
      D => \q_m_n0[1]_i_1__0_n_0\,
      Q => \q_m_n0_reg_n_0_[1]\
    );
\q_m_n0_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[0]_0\,
      D => \q_m_n0[2]_i_1__0_n_0\,
      Q => \q_m_n0_reg_n_0_[2]\
    );
\q_m_n0_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[0]_0\,
      D => \q_m_n0[3]_i_1__0_n_0\,
      Q => \q_m_n0_reg_n_0_[3]\
    );
\q_m_n1[1]_i_1__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6696969996999969"
    )
        port map (
      I0 => \q_m_n1[3]_i_2__0_n_0\,
      I1 => \q_m_n1[3]_i_3__0_n_0\,
      I2 => \data_in_reg_reg_n_0_[0]\,
      I3 => \q_m_n1[3]_i_4__0_n_0\,
      I4 => \q_m_n1[3]_i_5__0_n_0\,
      I5 => \q_m_n1[3]_i_6__0_n_0\,
      O => \q_m_n1[1]_i_1__0_n_0\
    );
\q_m_n1[2]_i_1__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFEF71F771F70010"
    )
        port map (
      I0 => \q_m_n1[3]_i_5__0_n_0\,
      I1 => \q_m_n1[3]_i_4__0_n_0\,
      I2 => \data_in_reg_reg_n_0_[0]\,
      I3 => \q_m_n1[3]_i_6__0_n_0\,
      I4 => \q_m_n1[3]_i_3__0_n_0\,
      I5 => \q_m_n1[3]_i_2__0_n_0\,
      O => \q_m_n1[2]_i_1__0_n_0\
    );
\q_m_n1[3]_i_1__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000080"
    )
        port map (
      I0 => \q_m_n1[3]_i_2__0_n_0\,
      I1 => \q_m_n1[3]_i_3__0_n_0\,
      I2 => \data_in_reg_reg_n_0_[0]\,
      I3 => \q_m_n1[3]_i_4__0_n_0\,
      I4 => \q_m_n1[3]_i_5__0_n_0\,
      I5 => \q_m_n1[3]_i_6__0_n_0\,
      O => \q_m_n1[3]_i_1__0_n_0\
    );
\q_m_n1[3]_i_2__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B42D4BD2"
    )
        port map (
      I0 => \q_m_reg[7]_i_2__0_n_0\,
      I1 => p_0_in3_in,
      I2 => \data_in_reg_reg_n_0_[0]\,
      I3 => p_0_in4_in,
      I4 => p_0_in5_in,
      O => \q_m_n1[3]_i_2__0_n_0\
    );
\q_m_n1[3]_i_3__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"E11E1EE178878778"
    )
        port map (
      I0 => p_0_in0_in,
      I1 => \q_m_reg[7]_i_2__0_n_0\,
      I2 => q_m_2,
      I3 => p_0_in2_in,
      I4 => p_0_in3_in,
      I5 => p_0_in1_in,
      O => \q_m_n1[3]_i_3__0_n_0\
    );
\q_m_n1[3]_i_4__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9669699669969669"
    )
        port map (
      I0 => p_0_in3_in,
      I1 => p_0_in2_in,
      I2 => \data_in_reg_reg_n_0_[0]\,
      I3 => p_0_in4_in,
      I4 => p_0_in5_in,
      I5 => \q_m_n1[3]_i_7__0_n_0\,
      O => \q_m_n1[3]_i_4__0_n_0\
    );
\q_m_n1[3]_i_5__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"96696996"
    )
        port map (
      I0 => p_0_in0_in,
      I1 => \q_m_reg[7]_i_3__0_n_0\,
      I2 => p_0_in1_in,
      I3 => \q_m_reg[7]_i_2__0_n_0\,
      I4 => p_0_in,
      O => \q_m_n1[3]_i_5__0_n_0\
    );
\q_m_n1[3]_i_6__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"69"
    )
        port map (
      I0 => \data_in_reg_reg_n_0_[0]\,
      I1 => p_0_in5_in,
      I2 => p_0_in3_in,
      O => \q_m_n1[3]_i_6__0_n_0\
    );
\q_m_n1[3]_i_7__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5555555566666A66"
    )
        port map (
      I0 => p_0_in0_in,
      I1 => data_in_n1(2),
      I2 => data_in_n1(0),
      I3 => \data_in_reg_reg_n_0_[0]\,
      I4 => data_in_n1(1),
      I5 => data_in_n1(3),
      O => \q_m_n1[3]_i_7__0_n_0\
    );
\q_m_n1_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[0]_0\,
      D => \q_m_n1[1]_i_1__0_n_0\,
      Q => \q_m_n1_reg_n_0_[1]\
    );
\q_m_n1_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[0]_0\,
      D => \q_m_n1[2]_i_1__0_n_0\,
      Q => \q_m_n1_reg_n_0_[2]\
    );
\q_m_n1_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[0]_0\,
      D => \q_m_n1[3]_i_1__0_n_0\,
      Q => \q_m_n1_reg_n_0_[3]\
    );
\q_m_reg[1]_i_1__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFA800570055FFAA"
    )
        port map (
      I0 => data_in_n1(2),
      I1 => data_in_n1(0),
      I2 => data_in_n1(1),
      I3 => data_in_n1(3),
      I4 => p_0_in5_in,
      I5 => \data_in_reg_reg_n_0_[0]\,
      O => q_m_1
    );
\q_m_reg[2]_i_1__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => \data_in_reg_reg_n_0_[0]\,
      I1 => p_0_in4_in,
      I2 => p_0_in5_in,
      O => q_m_2
    );
\q_m_reg[3]_i_1__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"96696996"
    )
        port map (
      I0 => p_0_in5_in,
      I1 => p_0_in4_in,
      I2 => \data_in_reg_reg_n_0_[0]\,
      I3 => p_0_in3_in,
      I4 => \q_m_reg[7]_i_2__0_n_0\,
      O => q_m_3
    );
\q_m_reg[4]_i_1__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"96696996"
    )
        port map (
      I0 => p_0_in3_in,
      I1 => p_0_in2_in,
      I2 => \data_in_reg_reg_n_0_[0]\,
      I3 => p_0_in4_in,
      I4 => p_0_in5_in,
      O => q_m_4
    );
\q_m_reg[5]_i_1__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"96696996"
    )
        port map (
      I0 => \q_m_reg[7]_i_2__0_n_0\,
      I1 => q_m_2,
      I2 => p_0_in2_in,
      I3 => p_0_in3_in,
      I4 => p_0_in1_in,
      O => \q_m_reg[5]_i_1__0_n_0\
    );
\q_m_reg[6]_i_1__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"96696996"
    )
        port map (
      I0 => p_0_in1_in,
      I1 => p_0_in3_in,
      I2 => p_0_in2_in,
      I3 => q_m_2,
      I4 => p_0_in0_in,
      O => q_m_6
    );
\q_m_reg[7]_i_1__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"69969669"
    )
        port map (
      I0 => p_0_in,
      I1 => \q_m_reg[7]_i_2__0_n_0\,
      I2 => p_0_in1_in,
      I3 => \q_m_reg[7]_i_3__0_n_0\,
      I4 => p_0_in0_in,
      O => q_m_7
    );
\q_m_reg[7]_i_2__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFEFAAAA"
    )
        port map (
      I0 => data_in_n1(3),
      I1 => data_in_n1(1),
      I2 => \data_in_reg_reg_n_0_[0]\,
      I3 => data_in_n1(0),
      I4 => data_in_n1(2),
      O => \q_m_reg[7]_i_2__0_n_0\
    );
\q_m_reg[7]_i_3__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"69969669"
    )
        port map (
      I0 => p_0_in5_in,
      I1 => p_0_in4_in,
      I2 => \data_in_reg_reg_n_0_[0]\,
      I3 => p_0_in2_in,
      I4 => p_0_in3_in,
      O => \q_m_reg[7]_i_3__0_n_0\
    );
\q_m_reg[8]_i_1__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00005575"
    )
        port map (
      I0 => data_in_n1(2),
      I1 => data_in_n1(0),
      I2 => \data_in_reg_reg_n_0_[0]\,
      I3 => data_in_n1(1),
      I4 => data_in_n1(3),
      O => q_m(8)
    );
\q_m_reg_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[0]_0\,
      D => \data_in_reg_reg_n_0_[0]\,
      Q => \q_m_reg_reg_n_0_[0]\
    );
\q_m_reg_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[0]_0\,
      D => q_m_1,
      Q => \q_m_reg_reg_n_0_[1]\
    );
\q_m_reg_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[0]_0\,
      D => q_m_2,
      Q => \q_m_reg_reg_n_0_[2]\
    );
\q_m_reg_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[0]_0\,
      D => q_m_3,
      Q => \q_m_reg_reg_n_0_[3]\
    );
\q_m_reg_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[0]_0\,
      D => q_m_4,
      Q => \q_m_reg_reg_n_0_[4]\
    );
\q_m_reg_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[0]_0\,
      D => \q_m_reg[5]_i_1__0_n_0\,
      Q => \q_m_reg_reg_n_0_[5]\
    );
\q_m_reg_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[0]_0\,
      D => q_m_6,
      Q => \q_m_reg_reg_n_0_[6]\
    );
\q_m_reg_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[0]_0\,
      D => q_m_7,
      Q => \q_m_reg_reg_n_0_[7]\
    );
\q_m_reg_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[0]_0\,
      D => q_m(8),
      Q => \^q\(0)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_encode_1 is
  port (
    Q : out STD_LOGIC_VECTOR ( 0 to 0 );
    \cnt_reg[2]_0\ : out STD_LOGIC;
    \cnt_reg[4]_0\ : out STD_LOGIC;
    \data_out_reg[9]_0\ : out STD_LOGIC_VECTOR ( 9 downto 0 );
    de_reg2 : in STD_LOGIC;
    c0_reg2 : in STD_LOGIC;
    video_din : in STD_LOGIC_VECTOR ( 7 downto 0 );
    pclk : in STD_LOGIC;
    \data_out_reg[9]_1\ : in STD_LOGIC;
    D : in STD_LOGIC_VECTOR ( 1 downto 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_encode_1 : entity is "encode";
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_encode_1;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_encode_1 is
  signal \^q\ : STD_LOGIC_VECTOR ( 0 to 0 );
  signal cnt : STD_LOGIC_VECTOR ( 4 downto 1 );
  signal \cnt[1]_i_1__1_n_0\ : STD_LOGIC;
  signal \cnt[1]_i_2__1_n_0\ : STD_LOGIC;
  signal \cnt[1]_i_3_n_0\ : STD_LOGIC;
  signal \cnt[2]_i_1__1_n_0\ : STD_LOGIC;
  signal \cnt[2]_i_2__1_n_0\ : STD_LOGIC;
  signal \cnt[2]_i_3__0_n_0\ : STD_LOGIC;
  signal \cnt[2]_i_4__1_n_0\ : STD_LOGIC;
  signal \cnt[3]_i_1_n_0\ : STD_LOGIC;
  signal \cnt[3]_i_2__1_n_0\ : STD_LOGIC;
  signal \cnt[3]_i_3__1_n_0\ : STD_LOGIC;
  signal \cnt[3]_i_4__1_n_0\ : STD_LOGIC;
  signal \cnt[3]_i_5__1_n_0\ : STD_LOGIC;
  signal \cnt[3]_i_6__1_n_0\ : STD_LOGIC;
  signal \cnt[3]_i_7__1_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_10__1_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_11__1_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_12__1_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_13__1_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_14__1_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_15__0_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_16__1_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_17__1_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_18__1_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_19__1_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_1__1_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_20__0_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_21__1_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_22__1_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_23__1_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_24__1_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_25__0_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_2__1_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_4__1_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_6__1_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_7__1_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_8__1_n_0\ : STD_LOGIC;
  signal \cnt[4]_i_9__1_n_0\ : STD_LOGIC;
  signal \^cnt_reg[2]_0\ : STD_LOGIC;
  signal \^cnt_reg[4]_0\ : STD_LOGIC;
  signal data_in_n1 : STD_LOGIC_VECTOR ( 3 downto 0 );
  signal \data_in_n1[0]_i_1_n_0\ : STD_LOGIC;
  signal \data_in_n1[0]_i_2_n_0\ : STD_LOGIC;
  signal \data_in_n1[1]_i_1_n_0\ : STD_LOGIC;
  signal \data_in_n1[1]_i_2_n_0\ : STD_LOGIC;
  signal \data_in_n1[2]_i_1_n_0\ : STD_LOGIC;
  signal \data_in_n1[2]_i_2_n_0\ : STD_LOGIC;
  signal \data_in_n1[3]_i_1_n_0\ : STD_LOGIC;
  signal \data_in_n1[3]_i_2_n_0\ : STD_LOGIC;
  signal \data_in_n1[3]_i_3_n_0\ : STD_LOGIC;
  signal \data_in_n1[3]_i_4_n_0\ : STD_LOGIC;
  signal \data_in_reg_reg_n_0_[0]\ : STD_LOGIC;
  signal \data_out[0]_i_1__1_n_0\ : STD_LOGIC;
  signal \data_out[1]_i_1__1_n_0\ : STD_LOGIC;
  signal \data_out[2]_i_1__1_n_0\ : STD_LOGIC;
  signal \data_out[3]_i_1__1_n_0\ : STD_LOGIC;
  signal \data_out[4]_i_1__1_n_0\ : STD_LOGIC;
  signal \data_out[5]_i_1__1_n_0\ : STD_LOGIC;
  signal \data_out[6]_i_1__1_n_0\ : STD_LOGIC;
  signal \data_out[7]_i_1__1_n_0\ : STD_LOGIC;
  signal p_0_in : STD_LOGIC;
  signal p_0_in0_in : STD_LOGIC;
  signal p_0_in1_in : STD_LOGIC;
  signal p_0_in2_in : STD_LOGIC;
  signal p_0_in3_in : STD_LOGIC;
  signal p_0_in4_in : STD_LOGIC;
  signal p_0_in5_in : STD_LOGIC;
  signal q_m : STD_LOGIC_VECTOR ( 8 to 8 );
  signal q_m_1 : STD_LOGIC;
  signal q_m_2 : STD_LOGIC;
  signal q_m_3 : STD_LOGIC;
  signal q_m_4 : STD_LOGIC;
  signal q_m_6 : STD_LOGIC;
  signal q_m_7 : STD_LOGIC;
  signal \q_m_n0[1]_i_1__1_n_0\ : STD_LOGIC;
  signal \q_m_n0[2]_i_1__1_n_0\ : STD_LOGIC;
  signal \q_m_n0[3]_i_1__1_n_0\ : STD_LOGIC;
  signal \q_m_n0_reg_n_0_[1]\ : STD_LOGIC;
  signal \q_m_n0_reg_n_0_[2]\ : STD_LOGIC;
  signal \q_m_n0_reg_n_0_[3]\ : STD_LOGIC;
  signal \q_m_n1[1]_i_1__1_n_0\ : STD_LOGIC;
  signal \q_m_n1[2]_i_1__1_n_0\ : STD_LOGIC;
  signal \q_m_n1[3]_i_1__1_n_0\ : STD_LOGIC;
  signal \q_m_n1[3]_i_2__1_n_0\ : STD_LOGIC;
  signal \q_m_n1[3]_i_3__1_n_0\ : STD_LOGIC;
  signal \q_m_n1[3]_i_4__1_n_0\ : STD_LOGIC;
  signal \q_m_n1[3]_i_5__1_n_0\ : STD_LOGIC;
  signal \q_m_n1[3]_i_6__1_n_0\ : STD_LOGIC;
  signal \q_m_n1[3]_i_7__1_n_0\ : STD_LOGIC;
  signal \q_m_n1_reg_n_0_[1]\ : STD_LOGIC;
  signal \q_m_n1_reg_n_0_[2]\ : STD_LOGIC;
  signal \q_m_n1_reg_n_0_[3]\ : STD_LOGIC;
  signal \q_m_reg[5]_i_1__1_n_0\ : STD_LOGIC;
  signal \q_m_reg[7]_i_2__1_n_0\ : STD_LOGIC;
  signal \q_m_reg[7]_i_3__1_n_0\ : STD_LOGIC;
  signal \q_m_reg_reg_n_0_[0]\ : STD_LOGIC;
  signal \q_m_reg_reg_n_0_[1]\ : STD_LOGIC;
  signal \q_m_reg_reg_n_0_[2]\ : STD_LOGIC;
  signal \q_m_reg_reg_n_0_[3]\ : STD_LOGIC;
  signal \q_m_reg_reg_n_0_[4]\ : STD_LOGIC;
  signal \q_m_reg_reg_n_0_[5]\ : STD_LOGIC;
  signal \q_m_reg_reg_n_0_[6]\ : STD_LOGIC;
  signal \q_m_reg_reg_n_0_[7]\ : STD_LOGIC;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \cnt[1]_i_2__1\ : label is "soft_lutpair47";
  attribute SOFT_HLUTNM of \cnt[1]_i_3\ : label is "soft_lutpair47";
  attribute SOFT_HLUTNM of \cnt[2]_i_2__1\ : label is "soft_lutpair33";
  attribute SOFT_HLUTNM of \cnt[2]_i_3__0\ : label is "soft_lutpair36";
  attribute SOFT_HLUTNM of \cnt[2]_i_4__1\ : label is "soft_lutpair33";
  attribute SOFT_HLUTNM of \cnt[3]_i_5__1\ : label is "soft_lutpair46";
  attribute SOFT_HLUTNM of \cnt[4]_i_10__1\ : label is "soft_lutpair44";
  attribute SOFT_HLUTNM of \cnt[4]_i_11__1\ : label is "soft_lutpair45";
  attribute SOFT_HLUTNM of \cnt[4]_i_12__1\ : label is "soft_lutpair45";
  attribute SOFT_HLUTNM of \cnt[4]_i_14__1\ : label is "soft_lutpair43";
  attribute SOFT_HLUTNM of \cnt[4]_i_15__0\ : label is "soft_lutpair37";
  attribute SOFT_HLUTNM of \cnt[4]_i_16__1\ : label is "soft_lutpair43";
  attribute SOFT_HLUTNM of \cnt[4]_i_17__1\ : label is "soft_lutpair37";
  attribute SOFT_HLUTNM of \cnt[4]_i_18__1\ : label is "soft_lutpair34";
  attribute SOFT_HLUTNM of \cnt[4]_i_22__1\ : label is "soft_lutpair35";
  attribute SOFT_HLUTNM of \cnt[4]_i_23__1\ : label is "soft_lutpair36";
  attribute SOFT_HLUTNM of \cnt[4]_i_24__1\ : label is "soft_lutpair46";
  attribute SOFT_HLUTNM of \cnt[4]_i_7__1\ : label is "soft_lutpair35";
  attribute SOFT_HLUTNM of \cnt[4]_i_8__1\ : label is "soft_lutpair34";
  attribute SOFT_HLUTNM of \cnt[4]_i_9__1\ : label is "soft_lutpair44";
  attribute SOFT_HLUTNM of \data_in_n1[0]_i_2\ : label is "soft_lutpair38";
  attribute SOFT_HLUTNM of \data_in_n1[3]_i_3\ : label is "soft_lutpair38";
  attribute SOFT_HLUTNM of \q_m_n1[3]_i_2__1\ : label is "soft_lutpair39";
  attribute SOFT_HLUTNM of \q_m_n1[3]_i_5__1\ : label is "soft_lutpair40";
  attribute SOFT_HLUTNM of \q_m_n1[3]_i_6__1\ : label is "soft_lutpair48";
  attribute SOFT_HLUTNM of \q_m_reg[2]_i_1__1\ : label is "soft_lutpair48";
  attribute SOFT_HLUTNM of \q_m_reg[3]_i_1__1\ : label is "soft_lutpair39";
  attribute SOFT_HLUTNM of \q_m_reg[4]_i_1__1\ : label is "soft_lutpair42";
  attribute SOFT_HLUTNM of \q_m_reg[7]_i_1__1\ : label is "soft_lutpair40";
  attribute SOFT_HLUTNM of \q_m_reg[7]_i_2__1\ : label is "soft_lutpair41";
  attribute SOFT_HLUTNM of \q_m_reg[7]_i_3__1\ : label is "soft_lutpair42";
  attribute SOFT_HLUTNM of \q_m_reg[8]_i_1__1\ : label is "soft_lutpair41";
begin
  Q(0) <= \^q\(0);
  \cnt_reg[2]_0\ <= \^cnt_reg[2]_0\;
  \cnt_reg[4]_0\ <= \^cnt_reg[4]_0\;
\cnt[1]_i_1__1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0A28A028A0280A28"
    )
        port map (
      I0 => de_reg2,
      I1 => \cnt[1]_i_2__1_n_0\,
      I2 => cnt(1),
      I3 => \^cnt_reg[2]_0\,
      I4 => \^cnt_reg[4]_0\,
      I5 => \cnt[1]_i_3_n_0\,
      O => \cnt[1]_i_1__1_n_0\
    );
\cnt[1]_i_2__1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \q_m_n1_reg_n_0_[1]\,
      I1 => \q_m_n0_reg_n_0_[1]\,
      O => \cnt[1]_i_2__1_n_0\
    );
\cnt[1]_i_3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => \q_m_n1_reg_n_0_[1]\,
      I1 => \^q\(0),
      I2 => \q_m_n0_reg_n_0_[1]\,
      O => \cnt[1]_i_3_n_0\
    );
\cnt[2]_i_1__1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"020202A2A2A202A2"
    )
        port map (
      I0 => de_reg2,
      I1 => \cnt[2]_i_2__1_n_0\,
      I2 => \^cnt_reg[2]_0\,
      I3 => \cnt[2]_i_3__0_n_0\,
      I4 => \^cnt_reg[4]_0\,
      I5 => \cnt[2]_i_4__1_n_0\,
      O => \cnt[2]_i_1__1_n_0\
    );
\cnt[2]_i_2__1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"AA6996AA"
    )
        port map (
      I0 => \cnt[4]_i_11__1_n_0\,
      I1 => cnt(1),
      I2 => \^q\(0),
      I3 => \q_m_n0_reg_n_0_[1]\,
      I4 => \q_m_n1_reg_n_0_[1]\,
      O => \cnt[2]_i_2__1_n_0\
    );
\cnt[2]_i_3__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"9AA6A665"
    )
        port map (
      I0 => \cnt[4]_i_11__1_n_0\,
      I1 => \q_m_n0_reg_n_0_[1]\,
      I2 => \^q\(0),
      I3 => \q_m_n1_reg_n_0_[1]\,
      I4 => cnt(1),
      O => \cnt[2]_i_3__0_n_0\
    );
\cnt[2]_i_4__1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"7E1781E8"
    )
        port map (
      I0 => cnt(1),
      I1 => \q_m_n0_reg_n_0_[1]\,
      I2 => \^q\(0),
      I3 => \q_m_n1_reg_n_0_[1]\,
      I4 => \cnt[4]_i_11__1_n_0\,
      O => \cnt[2]_i_4__1_n_0\
    );
\cnt[3]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"020202A2A2A202A2"
    )
        port map (
      I0 => de_reg2,
      I1 => \cnt[3]_i_2__1_n_0\,
      I2 => \^cnt_reg[2]_0\,
      I3 => \cnt[3]_i_3__1_n_0\,
      I4 => \^cnt_reg[4]_0\,
      I5 => \cnt[3]_i_4__1_n_0\,
      O => \cnt[3]_i_1_n_0\
    );
\cnt[3]_i_2__1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"B2BA4D454D45B2BA"
    )
        port map (
      I0 => \cnt[4]_i_11__1_n_0\,
      I1 => \cnt[3]_i_5__1_n_0\,
      I2 => cnt(1),
      I3 => \cnt[1]_i_2__1_n_0\,
      I4 => \cnt[4]_i_12__1_n_0\,
      I5 => \cnt[4]_i_8__1_n_0\,
      O => \cnt[3]_i_2__1_n_0\
    );
\cnt[3]_i_3__1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FE80017F017FFE80"
    )
        port map (
      I0 => cnt(1),
      I1 => \q_m_n1_reg_n_0_[1]\,
      I2 => \cnt[3]_i_6__1_n_0\,
      I3 => \cnt[4]_i_15__0_n_0\,
      I4 => \cnt[4]_i_18__1_n_0\,
      I5 => \cnt[4]_i_17__1_n_0\,
      O => \cnt[3]_i_3__1_n_0\
    );
\cnt[3]_i_4__1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"10515175EFAEAE8A"
    )
        port map (
      I0 => \cnt[4]_i_11__1_n_0\,
      I1 => \^q\(0),
      I2 => \q_m_n1_reg_n_0_[1]\,
      I3 => \q_m_n0_reg_n_0_[1]\,
      I4 => cnt(1),
      I5 => \cnt[3]_i_7__1_n_0\,
      O => \cnt[3]_i_4__1_n_0\
    );
\cnt[3]_i_5__1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"DB"
    )
        port map (
      I0 => \q_m_n1_reg_n_0_[1]\,
      I1 => \q_m_n0_reg_n_0_[1]\,
      I2 => \^q\(0),
      O => \cnt[3]_i_5__1_n_0\
    );
\cnt[3]_i_6__1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"6"
    )
        port map (
      I0 => \q_m_n0_reg_n_0_[1]\,
      I1 => \^q\(0),
      O => \cnt[3]_i_6__1_n_0\
    );
\cnt[3]_i_7__1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6996696996966996"
    )
        port map (
      I0 => \q_m_n1_reg_n_0_[3]\,
      I1 => \q_m_n0_reg_n_0_[3]\,
      I2 => cnt(3),
      I3 => cnt(2),
      I4 => \q_m_n1_reg_n_0_[2]\,
      I5 => \q_m_n0_reg_n_0_[2]\,
      O => \cnt[3]_i_7__1_n_0\
    );
\cnt[4]_i_10__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0820"
    )
        port map (
      I0 => cnt(1),
      I1 => \^q\(0),
      I2 => \q_m_n0_reg_n_0_[1]\,
      I3 => \q_m_n1_reg_n_0_[1]\,
      O => \cnt[4]_i_10__1_n_0\
    );
\cnt[4]_i_11__1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"69"
    )
        port map (
      I0 => cnt(2),
      I1 => \q_m_n0_reg_n_0_[2]\,
      I2 => \q_m_n1_reg_n_0_[2]\,
      O => \cnt[4]_i_11__1_n_0\
    );
\cnt[4]_i_12__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"B28E"
    )
        port map (
      I0 => cnt(2),
      I1 => \q_m_n0_reg_n_0_[2]\,
      I2 => \q_m_n1_reg_n_0_[2]\,
      I3 => \^q\(0),
      O => \cnt[4]_i_12__1_n_0\
    );
\cnt[4]_i_13__1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9009000000009009"
    )
        port map (
      I0 => \q_m_n0_reg_n_0_[2]\,
      I1 => \q_m_n1_reg_n_0_[2]\,
      I2 => \q_m_n1_reg_n_0_[1]\,
      I3 => \q_m_n0_reg_n_0_[1]\,
      I4 => \q_m_n1_reg_n_0_[3]\,
      I5 => \q_m_n0_reg_n_0_[3]\,
      O => \cnt[4]_i_13__1_n_0\
    );
\cnt[4]_i_14__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0041"
    )
        port map (
      I0 => cnt(1),
      I1 => \q_m_n0_reg_n_0_[1]\,
      I2 => \^q\(0),
      I3 => \q_m_n1_reg_n_0_[1]\,
      O => \cnt[4]_i_14__1_n_0\
    );
\cnt[4]_i_15__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"69966969"
    )
        port map (
      I0 => \q_m_n1_reg_n_0_[2]\,
      I1 => \q_m_n0_reg_n_0_[2]\,
      I2 => cnt(2),
      I3 => \^q\(0),
      I4 => \q_m_n0_reg_n_0_[1]\,
      O => \cnt[4]_i_15__0_n_0\
    );
\cnt[4]_i_16__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"9FFF"
    )
        port map (
      I0 => \q_m_n0_reg_n_0_[1]\,
      I1 => \^q\(0),
      I2 => \q_m_n1_reg_n_0_[1]\,
      I3 => cnt(1),
      O => \cnt[4]_i_16__1_n_0\
    );
\cnt[4]_i_17__1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"2F02022F"
    )
        port map (
      I0 => \q_m_n0_reg_n_0_[1]\,
      I1 => \^q\(0),
      I2 => cnt(2),
      I3 => \q_m_n0_reg_n_0_[2]\,
      I4 => \q_m_n1_reg_n_0_[2]\,
      O => \cnt[4]_i_17__1_n_0\
    );
\cnt[4]_i_18__1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"4BB4B44B"
    )
        port map (
      I0 => \q_m_n1_reg_n_0_[2]\,
      I1 => \q_m_n0_reg_n_0_[2]\,
      I2 => \q_m_n1_reg_n_0_[3]\,
      I3 => \q_m_n0_reg_n_0_[3]\,
      I4 => cnt(3),
      O => \cnt[4]_i_18__1_n_0\
    );
\cnt[4]_i_19__1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9A55AA9A55659A55"
    )
        port map (
      I0 => cnt(4),
      I1 => \q_m_n1_reg_n_0_[2]\,
      I2 => \q_m_n0_reg_n_0_[2]\,
      I3 => \q_m_n1_reg_n_0_[3]\,
      I4 => \q_m_n0_reg_n_0_[3]\,
      I5 => cnt(3),
      O => \cnt[4]_i_19__1_n_0\
    );
\cnt[4]_i_1__1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"020202A2A2A202A2"
    )
        port map (
      I0 => de_reg2,
      I1 => \cnt[4]_i_2__1_n_0\,
      I2 => \^cnt_reg[2]_0\,
      I3 => \cnt[4]_i_4__1_n_0\,
      I4 => \^cnt_reg[4]_0\,
      I5 => \cnt[4]_i_6__1_n_0\,
      O => \cnt[4]_i_1__1_n_0\
    );
\cnt[4]_i_20__0\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"2202FF0F00002202"
    )
        port map (
      I0 => \q_m_n0_reg_n_0_[1]\,
      I1 => \q_m_n1_reg_n_0_[1]\,
      I2 => \q_m_n1_reg_n_0_[3]\,
      I3 => \q_m_n0_reg_n_0_[3]\,
      I4 => \q_m_n1_reg_n_0_[2]\,
      I5 => \q_m_n0_reg_n_0_[2]\,
      O => \cnt[4]_i_20__0_n_0\
    );
\cnt[4]_i_21__1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"DDFD00F0FFFFDDFD"
    )
        port map (
      I0 => \q_m_n1_reg_n_0_[1]\,
      I1 => \q_m_n0_reg_n_0_[1]\,
      I2 => \q_m_n0_reg_n_0_[3]\,
      I3 => \q_m_n1_reg_n_0_[3]\,
      I4 => \q_m_n0_reg_n_0_[2]\,
      I5 => \q_m_n1_reg_n_0_[2]\,
      O => \cnt[4]_i_21__1_n_0\
    );
\cnt[4]_i_22__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"A665"
    )
        port map (
      I0 => cnt(4),
      I1 => \q_m_n1_reg_n_0_[3]\,
      I2 => \q_m_n0_reg_n_0_[3]\,
      I3 => cnt(3),
      O => \cnt[4]_i_22__1_n_0\
    );
\cnt[4]_i_23__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"BEEB"
    )
        port map (
      I0 => cnt(1),
      I1 => \q_m_n0_reg_n_0_[1]\,
      I2 => \^q\(0),
      I3 => \q_m_n1_reg_n_0_[1]\,
      O => \cnt[4]_i_23__1_n_0\
    );
\cnt[4]_i_24__1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B2"
    )
        port map (
      I0 => \q_m_n0_reg_n_0_[1]\,
      I1 => \q_m_n1_reg_n_0_[1]\,
      I2 => \^q\(0),
      O => \cnt[4]_i_24__1_n_0\
    );
\cnt[4]_i_25__0\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B2"
    )
        port map (
      I0 => \q_m_n0_reg_n_0_[2]\,
      I1 => \q_m_n1_reg_n_0_[2]\,
      I2 => cnt(2),
      O => \cnt[4]_i_25__0_n_0\
    );
\cnt[4]_i_2__1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"595959999A9A9AAA"
    )
        port map (
      I0 => \cnt[4]_i_7__1_n_0\,
      I1 => \cnt[4]_i_8__1_n_0\,
      I2 => \cnt[4]_i_9__1_n_0\,
      I3 => \cnt[4]_i_10__1_n_0\,
      I4 => \cnt[4]_i_11__1_n_0\,
      I5 => \cnt[4]_i_12__1_n_0\,
      O => \cnt[4]_i_2__1_n_0\
    );
\cnt[4]_i_3__1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"55555554"
    )
        port map (
      I0 => \cnt[4]_i_13__1_n_0\,
      I1 => cnt(2),
      I2 => cnt(4),
      I3 => cnt(1),
      I4 => cnt(3),
      O => \^cnt_reg[2]_0\
    );
\cnt[4]_i_4__1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"45FF0045BA00FFBA"
    )
        port map (
      I0 => \cnt[4]_i_14__1_n_0\,
      I1 => \cnt[4]_i_15__0_n_0\,
      I2 => \cnt[4]_i_16__1_n_0\,
      I3 => \cnt[4]_i_17__1_n_0\,
      I4 => \cnt[4]_i_18__1_n_0\,
      I5 => \cnt[4]_i_19__1_n_0\,
      O => \cnt[4]_i_4__1_n_0\
    );
\cnt[4]_i_5__0\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"8BC8BBFB"
    )
        port map (
      I0 => \cnt[4]_i_20__0_n_0\,
      I1 => cnt(4),
      I2 => \q_m_n0_reg_n_0_[3]\,
      I3 => \q_m_n1_reg_n_0_[3]\,
      I4 => \cnt[4]_i_21__1_n_0\,
      O => \^cnt_reg[4]_0\
    );
\cnt[4]_i_6__1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"A995AAAA5555A995"
    )
        port map (
      I0 => \cnt[4]_i_22__1_n_0\,
      I1 => \cnt[4]_i_23__1_n_0\,
      I2 => \cnt[4]_i_24__1_n_0\,
      I3 => \cnt[4]_i_11__1_n_0\,
      I4 => \cnt[4]_i_8__1_n_0\,
      I5 => \cnt[4]_i_25__0_n_0\,
      O => \cnt[4]_i_6__1_n_0\
    );
\cnt[4]_i_7__1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"5965A96A"
    )
        port map (
      I0 => cnt(4),
      I1 => \^q\(0),
      I2 => \q_m_n1_reg_n_0_[3]\,
      I3 => \q_m_n0_reg_n_0_[3]\,
      I4 => cnt(3),
      O => \cnt[4]_i_7__1_n_0\
    );
\cnt[4]_i_8__1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => cnt(3),
      I1 => \q_m_n0_reg_n_0_[3]\,
      I2 => \q_m_n1_reg_n_0_[3]\,
      O => \cnt[4]_i_8__1_n_0\
    );
\cnt[4]_i_9__1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FEBF"
    )
        port map (
      I0 => cnt(1),
      I1 => \^q\(0),
      I2 => \q_m_n0_reg_n_0_[1]\,
      I3 => \q_m_n1_reg_n_0_[1]\,
      O => \cnt[4]_i_9__1_n_0\
    );
\cnt_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[9]_1\,
      D => \cnt[1]_i_1__1_n_0\,
      Q => cnt(1)
    );
\cnt_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[9]_1\,
      D => \cnt[2]_i_1__1_n_0\,
      Q => cnt(2)
    );
\cnt_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[9]_1\,
      D => \cnt[3]_i_1_n_0\,
      Q => cnt(3)
    );
\cnt_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[9]_1\,
      D => \cnt[4]_i_1__1_n_0\,
      Q => cnt(4)
    );
\data_in_n1[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6996966996696996"
    )
        port map (
      I0 => video_din(0),
      I1 => video_din(7),
      I2 => \data_in_n1[0]_i_2_n_0\,
      I3 => video_din(2),
      I4 => video_din(1),
      I5 => video_din(3),
      O => \data_in_n1[0]_i_1_n_0\
    );
\data_in_n1[0]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => video_din(6),
      I1 => video_din(4),
      I2 => video_din(5),
      O => \data_in_n1[0]_i_2_n_0\
    );
\data_in_n1[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => \data_in_n1[3]_i_2_n_0\,
      I1 => \data_in_n1[1]_i_2_n_0\,
      I2 => \data_in_n1[3]_i_3_n_0\,
      O => \data_in_n1[1]_i_1_n_0\
    );
\data_in_n1[1]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"171717E817E8E8E8"
    )
        port map (
      I0 => video_din(3),
      I1 => video_din(2),
      I2 => video_din(1),
      I3 => video_din(6),
      I4 => video_din(5),
      I5 => video_din(4),
      O => \data_in_n1[1]_i_2_n_0\
    );
\data_in_n1[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"7E7E7EE87EE8E8E8"
    )
        port map (
      I0 => \data_in_n1[3]_i_2_n_0\,
      I1 => \data_in_n1[3]_i_3_n_0\,
      I2 => \data_in_n1[2]_i_2_n_0\,
      I3 => video_din(4),
      I4 => video_din(5),
      I5 => video_din(6),
      O => \data_in_n1[2]_i_1_n_0\
    );
\data_in_n1[2]_i_2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E8"
    )
        port map (
      I0 => video_din(1),
      I1 => video_din(2),
      I2 => video_din(3),
      O => \data_in_n1[2]_i_2_n_0\
    );
\data_in_n1[3]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"8880800000000000"
    )
        port map (
      I0 => \data_in_n1[3]_i_2_n_0\,
      I1 => \data_in_n1[3]_i_3_n_0\,
      I2 => video_din(3),
      I3 => video_din(2),
      I4 => video_din(1),
      I5 => \data_in_n1[3]_i_4_n_0\,
      O => \data_in_n1[3]_i_1_n_0\
    );
\data_in_n1[3]_i_2\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9600009600969600"
    )
        port map (
      I0 => video_din(2),
      I1 => video_din(1),
      I2 => video_din(3),
      I3 => video_din(0),
      I4 => video_din(7),
      I5 => \data_in_n1[0]_i_2_n_0\,
      O => \data_in_n1[3]_i_2_n_0\
    );
\data_in_n1[3]_i_3\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"E88E8EE8"
    )
        port map (
      I0 => video_din(7),
      I1 => video_din(0),
      I2 => video_din(5),
      I3 => video_din(4),
      I4 => video_din(6),
      O => \data_in_n1[3]_i_3_n_0\
    );
\data_in_n1[3]_i_4\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"E8"
    )
        port map (
      I0 => video_din(4),
      I1 => video_din(5),
      I2 => video_din(6),
      O => \data_in_n1[3]_i_4_n_0\
    );
\data_in_n1_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[9]_1\,
      D => \data_in_n1[0]_i_1_n_0\,
      Q => data_in_n1(0)
    );
\data_in_n1_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[9]_1\,
      D => \data_in_n1[1]_i_1_n_0\,
      Q => data_in_n1(1)
    );
\data_in_n1_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[9]_1\,
      D => \data_in_n1[2]_i_1_n_0\,
      Q => data_in_n1(2)
    );
\data_in_n1_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[9]_1\,
      D => \data_in_n1[3]_i_1_n_0\,
      Q => data_in_n1(3)
    );
\data_in_reg_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[9]_1\,
      D => video_din(0),
      Q => \data_in_reg_reg_n_0_[0]\
    );
\data_in_reg_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[9]_1\,
      D => video_din(1),
      Q => p_0_in5_in
    );
\data_in_reg_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[9]_1\,
      D => video_din(2),
      Q => p_0_in4_in
    );
\data_in_reg_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[9]_1\,
      D => video_din(3),
      Q => p_0_in3_in
    );
\data_in_reg_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[9]_1\,
      D => video_din(4),
      Q => p_0_in2_in
    );
\data_in_reg_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[9]_1\,
      D => video_din(5),
      Q => p_0_in1_in
    );
\data_in_reg_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[9]_1\,
      D => video_din(6),
      Q => p_0_in0_in
    );
\data_in_reg_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[9]_1\,
      D => video_din(7),
      Q => p_0_in
    );
\data_out[0]_i_1__1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"59A9FFFF59A90000"
    )
        port map (
      I0 => \q_m_reg_reg_n_0_[0]\,
      I1 => \^q\(0),
      I2 => \^cnt_reg[2]_0\,
      I3 => \^cnt_reg[4]_0\,
      I4 => de_reg2,
      I5 => c0_reg2,
      O => \data_out[0]_i_1__1_n_0\
    );
\data_out[1]_i_1__1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"59A9FFFF59A90000"
    )
        port map (
      I0 => \q_m_reg_reg_n_0_[1]\,
      I1 => \^q\(0),
      I2 => \^cnt_reg[2]_0\,
      I3 => \^cnt_reg[4]_0\,
      I4 => de_reg2,
      I5 => c0_reg2,
      O => \data_out[1]_i_1__1_n_0\
    );
\data_out[2]_i_1__1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"08A85DFDA202F757"
    )
        port map (
      I0 => de_reg2,
      I1 => \^q\(0),
      I2 => \^cnt_reg[2]_0\,
      I3 => \^cnt_reg[4]_0\,
      I4 => c0_reg2,
      I5 => \q_m_reg_reg_n_0_[2]\,
      O => \data_out[2]_i_1__1_n_0\
    );
\data_out[3]_i_1__1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"59A9FFFF59A90000"
    )
        port map (
      I0 => \q_m_reg_reg_n_0_[3]\,
      I1 => \^q\(0),
      I2 => \^cnt_reg[2]_0\,
      I3 => \^cnt_reg[4]_0\,
      I4 => de_reg2,
      I5 => c0_reg2,
      O => \data_out[3]_i_1__1_n_0\
    );
\data_out[4]_i_1__1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"08A85DFDA202F757"
    )
        port map (
      I0 => de_reg2,
      I1 => \^q\(0),
      I2 => \^cnt_reg[2]_0\,
      I3 => \^cnt_reg[4]_0\,
      I4 => c0_reg2,
      I5 => \q_m_reg_reg_n_0_[4]\,
      O => \data_out[4]_i_1__1_n_0\
    );
\data_out[5]_i_1__1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"59A9FFFF59A90000"
    )
        port map (
      I0 => \q_m_reg_reg_n_0_[5]\,
      I1 => \^q\(0),
      I2 => \^cnt_reg[2]_0\,
      I3 => \^cnt_reg[4]_0\,
      I4 => de_reg2,
      I5 => c0_reg2,
      O => \data_out[5]_i_1__1_n_0\
    );
\data_out[6]_i_1__1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"08A85DFDA202F757"
    )
        port map (
      I0 => de_reg2,
      I1 => \^q\(0),
      I2 => \^cnt_reg[2]_0\,
      I3 => \^cnt_reg[4]_0\,
      I4 => c0_reg2,
      I5 => \q_m_reg_reg_n_0_[6]\,
      O => \data_out[6]_i_1__1_n_0\
    );
\data_out[7]_i_1__1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"59A9FFFF59A90000"
    )
        port map (
      I0 => \q_m_reg_reg_n_0_[7]\,
      I1 => \^q\(0),
      I2 => \^cnt_reg[2]_0\,
      I3 => \^cnt_reg[4]_0\,
      I4 => de_reg2,
      I5 => c0_reg2,
      O => \data_out[7]_i_1__1_n_0\
    );
\data_out_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[9]_1\,
      D => \data_out[0]_i_1__1_n_0\,
      Q => \data_out_reg[9]_0\(0)
    );
\data_out_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[9]_1\,
      D => \data_out[1]_i_1__1_n_0\,
      Q => \data_out_reg[9]_0\(1)
    );
\data_out_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[9]_1\,
      D => \data_out[2]_i_1__1_n_0\,
      Q => \data_out_reg[9]_0\(2)
    );
\data_out_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[9]_1\,
      D => \data_out[3]_i_1__1_n_0\,
      Q => \data_out_reg[9]_0\(3)
    );
\data_out_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[9]_1\,
      D => \data_out[4]_i_1__1_n_0\,
      Q => \data_out_reg[9]_0\(4)
    );
\data_out_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[9]_1\,
      D => \data_out[5]_i_1__1_n_0\,
      Q => \data_out_reg[9]_0\(5)
    );
\data_out_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[9]_1\,
      D => \data_out[6]_i_1__1_n_0\,
      Q => \data_out_reg[9]_0\(6)
    );
\data_out_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[9]_1\,
      D => \data_out[7]_i_1__1_n_0\,
      Q => \data_out_reg[9]_0\(7)
    );
\data_out_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[9]_1\,
      D => D(0),
      Q => \data_out_reg[9]_0\(8)
    );
\data_out_reg[9]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[9]_1\,
      D => D(1),
      Q => \data_out_reg[9]_0\(9)
    );
\q_m_n0[1]_i_1__1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9996699996669996"
    )
        port map (
      I0 => \q_m_n1[3]_i_3__1_n_0\,
      I1 => \q_m_n1[3]_i_2__1_n_0\,
      I2 => \q_m_n1[3]_i_5__1_n_0\,
      I3 => \q_m_n1[3]_i_4__1_n_0\,
      I4 => \data_in_reg_reg_n_0_[0]\,
      I5 => \q_m_n1[3]_i_6__1_n_0\,
      O => \q_m_n0[1]_i_1__1_n_0\
    );
\q_m_n0[2]_i_1__1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"2000FBB2FBB2DFFF"
    )
        port map (
      I0 => \q_m_n1[3]_i_6__1_n_0\,
      I1 => \data_in_reg_reg_n_0_[0]\,
      I2 => \q_m_n1[3]_i_4__1_n_0\,
      I3 => \q_m_n1[3]_i_5__1_n_0\,
      I4 => \q_m_n1[3]_i_2__1_n_0\,
      I5 => \q_m_n1[3]_i_3__1_n_0\,
      O => \q_m_n0[2]_i_1__1_n_0\
    );
\q_m_n0[3]_i_1__1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0100000000000000"
    )
        port map (
      I0 => \q_m_n1[3]_i_2__1_n_0\,
      I1 => \q_m_n1[3]_i_3__1_n_0\,
      I2 => \data_in_reg_reg_n_0_[0]\,
      I3 => \q_m_n1[3]_i_4__1_n_0\,
      I4 => \q_m_n1[3]_i_5__1_n_0\,
      I5 => \q_m_n1[3]_i_6__1_n_0\,
      O => \q_m_n0[3]_i_1__1_n_0\
    );
\q_m_n0_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[9]_1\,
      D => \q_m_n0[1]_i_1__1_n_0\,
      Q => \q_m_n0_reg_n_0_[1]\
    );
\q_m_n0_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[9]_1\,
      D => \q_m_n0[2]_i_1__1_n_0\,
      Q => \q_m_n0_reg_n_0_[2]\
    );
\q_m_n0_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[9]_1\,
      D => \q_m_n0[3]_i_1__1_n_0\,
      Q => \q_m_n0_reg_n_0_[3]\
    );
\q_m_n1[1]_i_1__1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"6696969996999969"
    )
        port map (
      I0 => \q_m_n1[3]_i_2__1_n_0\,
      I1 => \q_m_n1[3]_i_3__1_n_0\,
      I2 => \data_in_reg_reg_n_0_[0]\,
      I3 => \q_m_n1[3]_i_4__1_n_0\,
      I4 => \q_m_n1[3]_i_5__1_n_0\,
      I5 => \q_m_n1[3]_i_6__1_n_0\,
      O => \q_m_n1[1]_i_1__1_n_0\
    );
\q_m_n1[2]_i_1__1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFEF71F771F70010"
    )
        port map (
      I0 => \q_m_n1[3]_i_5__1_n_0\,
      I1 => \q_m_n1[3]_i_4__1_n_0\,
      I2 => \data_in_reg_reg_n_0_[0]\,
      I3 => \q_m_n1[3]_i_6__1_n_0\,
      I4 => \q_m_n1[3]_i_3__1_n_0\,
      I5 => \q_m_n1[3]_i_2__1_n_0\,
      O => \q_m_n1[2]_i_1__1_n_0\
    );
\q_m_n1[3]_i_1__1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000000000000080"
    )
        port map (
      I0 => \q_m_n1[3]_i_2__1_n_0\,
      I1 => \q_m_n1[3]_i_3__1_n_0\,
      I2 => \data_in_reg_reg_n_0_[0]\,
      I3 => \q_m_n1[3]_i_4__1_n_0\,
      I4 => \q_m_n1[3]_i_5__1_n_0\,
      I5 => \q_m_n1[3]_i_6__1_n_0\,
      O => \q_m_n1[3]_i_1__1_n_0\
    );
\q_m_n1[3]_i_2__1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"B42D4BD2"
    )
        port map (
      I0 => \q_m_reg[7]_i_2__1_n_0\,
      I1 => p_0_in3_in,
      I2 => \data_in_reg_reg_n_0_[0]\,
      I3 => p_0_in4_in,
      I4 => p_0_in5_in,
      O => \q_m_n1[3]_i_2__1_n_0\
    );
\q_m_n1[3]_i_3__1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"E11E1EE178878778"
    )
        port map (
      I0 => p_0_in0_in,
      I1 => \q_m_reg[7]_i_2__1_n_0\,
      I2 => q_m_2,
      I3 => p_0_in2_in,
      I4 => p_0_in3_in,
      I5 => p_0_in1_in,
      O => \q_m_n1[3]_i_3__1_n_0\
    );
\q_m_n1[3]_i_4__1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"9669699669969669"
    )
        port map (
      I0 => p_0_in3_in,
      I1 => p_0_in2_in,
      I2 => \data_in_reg_reg_n_0_[0]\,
      I3 => p_0_in4_in,
      I4 => p_0_in5_in,
      I5 => \q_m_n1[3]_i_7__1_n_0\,
      O => \q_m_n1[3]_i_4__1_n_0\
    );
\q_m_n1[3]_i_5__1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"96696996"
    )
        port map (
      I0 => p_0_in0_in,
      I1 => \q_m_reg[7]_i_3__1_n_0\,
      I2 => p_0_in1_in,
      I3 => \q_m_reg[7]_i_2__1_n_0\,
      I4 => p_0_in,
      O => \q_m_n1[3]_i_5__1_n_0\
    );
\q_m_n1[3]_i_6__1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"69"
    )
        port map (
      I0 => \data_in_reg_reg_n_0_[0]\,
      I1 => p_0_in5_in,
      I2 => p_0_in3_in,
      O => \q_m_n1[3]_i_6__1_n_0\
    );
\q_m_n1[3]_i_7__1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"5555555566666A66"
    )
        port map (
      I0 => p_0_in0_in,
      I1 => data_in_n1(2),
      I2 => data_in_n1(0),
      I3 => \data_in_reg_reg_n_0_[0]\,
      I4 => data_in_n1(1),
      I5 => data_in_n1(3),
      O => \q_m_n1[3]_i_7__1_n_0\
    );
\q_m_n1_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[9]_1\,
      D => \q_m_n1[1]_i_1__1_n_0\,
      Q => \q_m_n1_reg_n_0_[1]\
    );
\q_m_n1_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[9]_1\,
      D => \q_m_n1[2]_i_1__1_n_0\,
      Q => \q_m_n1_reg_n_0_[2]\
    );
\q_m_n1_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[9]_1\,
      D => \q_m_n1[3]_i_1__1_n_0\,
      Q => \q_m_n1_reg_n_0_[3]\
    );
\q_m_reg[1]_i_1__1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FFA800570055FFAA"
    )
        port map (
      I0 => data_in_n1(2),
      I1 => data_in_n1(0),
      I2 => data_in_n1(1),
      I3 => data_in_n1(3),
      I4 => p_0_in5_in,
      I5 => \data_in_reg_reg_n_0_[0]\,
      O => q_m_1
    );
\q_m_reg[2]_i_1__1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"96"
    )
        port map (
      I0 => \data_in_reg_reg_n_0_[0]\,
      I1 => p_0_in4_in,
      I2 => p_0_in5_in,
      O => q_m_2
    );
\q_m_reg[3]_i_1__1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"96696996"
    )
        port map (
      I0 => p_0_in5_in,
      I1 => p_0_in4_in,
      I2 => \data_in_reg_reg_n_0_[0]\,
      I3 => p_0_in3_in,
      I4 => \q_m_reg[7]_i_2__1_n_0\,
      O => q_m_3
    );
\q_m_reg[4]_i_1__1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"96696996"
    )
        port map (
      I0 => p_0_in3_in,
      I1 => p_0_in2_in,
      I2 => \data_in_reg_reg_n_0_[0]\,
      I3 => p_0_in4_in,
      I4 => p_0_in5_in,
      O => q_m_4
    );
\q_m_reg[5]_i_1__1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"96696996"
    )
        port map (
      I0 => \q_m_reg[7]_i_2__1_n_0\,
      I1 => q_m_2,
      I2 => p_0_in2_in,
      I3 => p_0_in3_in,
      I4 => p_0_in1_in,
      O => \q_m_reg[5]_i_1__1_n_0\
    );
\q_m_reg[6]_i_1__1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"96696996"
    )
        port map (
      I0 => p_0_in1_in,
      I1 => p_0_in3_in,
      I2 => p_0_in2_in,
      I3 => q_m_2,
      I4 => p_0_in0_in,
      O => q_m_6
    );
\q_m_reg[7]_i_1__1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"69969669"
    )
        port map (
      I0 => p_0_in,
      I1 => \q_m_reg[7]_i_2__1_n_0\,
      I2 => p_0_in1_in,
      I3 => \q_m_reg[7]_i_3__1_n_0\,
      I4 => p_0_in0_in,
      O => q_m_7
    );
\q_m_reg[7]_i_2__1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"FFEFAAAA"
    )
        port map (
      I0 => data_in_n1(3),
      I1 => data_in_n1(1),
      I2 => \data_in_reg_reg_n_0_[0]\,
      I3 => data_in_n1(0),
      I4 => data_in_n1(2),
      O => \q_m_reg[7]_i_2__1_n_0\
    );
\q_m_reg[7]_i_3__1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"69969669"
    )
        port map (
      I0 => p_0_in5_in,
      I1 => p_0_in4_in,
      I2 => \data_in_reg_reg_n_0_[0]\,
      I3 => p_0_in2_in,
      I4 => p_0_in3_in,
      O => \q_m_reg[7]_i_3__1_n_0\
    );
\q_m_reg[8]_i_1__1\: unisim.vcomponents.LUT5
    generic map(
      INIT => X"00005575"
    )
        port map (
      I0 => data_in_n1(2),
      I1 => data_in_n1(0),
      I2 => \data_in_reg_reg_n_0_[0]\,
      I3 => data_in_n1(1),
      I4 => data_in_n1(3),
      O => q_m(8)
    );
\q_m_reg_reg[0]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[9]_1\,
      D => \data_in_reg_reg_n_0_[0]\,
      Q => \q_m_reg_reg_n_0_[0]\
    );
\q_m_reg_reg[1]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[9]_1\,
      D => q_m_1,
      Q => \q_m_reg_reg_n_0_[1]\
    );
\q_m_reg_reg[2]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[9]_1\,
      D => q_m_2,
      Q => \q_m_reg_reg_n_0_[2]\
    );
\q_m_reg_reg[3]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[9]_1\,
      D => q_m_3,
      Q => \q_m_reg_reg_n_0_[3]\
    );
\q_m_reg_reg[4]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[9]_1\,
      D => q_m_4,
      Q => \q_m_reg_reg_n_0_[4]\
    );
\q_m_reg_reg[5]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[9]_1\,
      D => \q_m_reg[5]_i_1__1_n_0\,
      Q => \q_m_reg_reg_n_0_[5]\
    );
\q_m_reg_reg[6]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[9]_1\,
      D => q_m_6,
      Q => \q_m_reg_reg_n_0_[6]\
    );
\q_m_reg_reg[7]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[9]_1\,
      D => q_m_7,
      Q => \q_m_reg_reg_n_0_[7]\
    );
\q_m_reg_reg[8]\: unisim.vcomponents.FDCE
     port map (
      C => pclk,
      CE => '1',
      CLR => \data_out_reg[9]_1\,
      D => q_m(8),
      Q => \^q\(0)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_par_to_ser is
  port (
    tmds_data_p : out STD_LOGIC_VECTOR ( 0 to 0 );
    tmds_data_n : out STD_LOGIC_VECTOR ( 0 to 0 );
    C00 : in STD_LOGIC;
    pclk_x5 : in STD_LOGIC;
    \data_fall_s_reg[4]_0\ : in STD_LOGIC_VECTOR ( 9 downto 0 )
  );
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_par_to_ser;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_par_to_ser is
  signal \cnt[0]_i_1_n_0\ : STD_LOGIC;
  signal \cnt[1]_i_1__2_n_0\ : STD_LOGIC;
  signal \cnt[2]_i_1__2_n_0\ : STD_LOGIC;
  signal \cnt_reg_n_0_[0]\ : STD_LOGIC;
  signal \cnt_reg_n_0_[1]\ : STD_LOGIC;
  signal data : STD_LOGIC;
  signal data_fall_s : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \data_fall_s[0]_i_1_n_0\ : STD_LOGIC;
  signal \data_fall_s[1]_i_1_n_0\ : STD_LOGIC;
  signal \data_fall_s[2]_i_1_n_0\ : STD_LOGIC;
  signal \data_fall_s[3]_i_1_n_0\ : STD_LOGIC;
  signal \data_fall_s[4]_i_1_n_0\ : STD_LOGIC;
  signal \data_fall_s_reg_n_0_[1]\ : STD_LOGIC;
  signal \data_fall_s_reg_n_0_[2]\ : STD_LOGIC;
  signal \data_fall_s_reg_n_0_[3]\ : STD_LOGIC;
  signal \data_fall_s_reg_n_0_[4]\ : STD_LOGIC;
  signal \data_rise_s[0]_i_1_n_0\ : STD_LOGIC;
  signal \data_rise_s[1]_i_1_n_0\ : STD_LOGIC;
  signal \data_rise_s[2]_i_1_n_0\ : STD_LOGIC;
  signal \data_rise_s[3]_i_1_n_0\ : STD_LOGIC;
  signal \data_rise_s[4]_i_1_n_0\ : STD_LOGIC;
  signal \data_rise_s_reg_n_0_[0]\ : STD_LOGIC;
  signal \data_rise_s_reg_n_0_[1]\ : STD_LOGIC;
  signal \data_rise_s_reg_n_0_[2]\ : STD_LOGIC;
  signal \data_rise_s_reg_n_0_[3]\ : STD_LOGIC;
  signal \data_rise_s_reg_n_0_[4]\ : STD_LOGIC;
  signal p_4_in : STD_LOGIC;
  signal NLW_ODDR2_inst0_R_UNCONNECTED : STD_LOGIC;
  signal NLW_ODDR2_inst0_S_UNCONNECTED : STD_LOGIC;
  attribute BOX_TYPE : string;
  attribute BOX_TYPE of OBUFDS_inst : label is "PRIMITIVE";
  attribute CAPACITANCE : string;
  attribute CAPACITANCE of OBUFDS_inst : label is "DONT_CARE";
  attribute BOX_TYPE of ODDR2_inst0 : label is "PRIMITIVE";
  attribute OPT_MODIFIED : string;
  attribute OPT_MODIFIED of ODDR2_inst0 : label is "MLO";
  attribute XILINX_LEGACY_PRIM : string;
  attribute XILINX_LEGACY_PRIM of ODDR2_inst0 : label is "ODDR2";
  attribute XILINX_TRANSFORM_PINMAP : string;
  attribute XILINX_TRANSFORM_PINMAP of ODDR2_inst0 : label is "D0:D1 D1:D2 C0:C";
  attribute \__SRVAL\ : string;
  attribute \__SRVAL\ of ODDR2_inst0 : label is "TRUE";
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \cnt[0]_i_1\ : label is "soft_lutpair50";
  attribute SOFT_HLUTNM of \cnt[1]_i_1__2\ : label is "soft_lutpair49";
  attribute SOFT_HLUTNM of \cnt[2]_i_1__2\ : label is "soft_lutpair49";
  attribute SOFT_HLUTNM of \data_fall_s[0]_i_1\ : label is "soft_lutpair53";
  attribute SOFT_HLUTNM of \data_fall_s[1]_i_1\ : label is "soft_lutpair53";
  attribute SOFT_HLUTNM of \data_fall_s[2]_i_1\ : label is "soft_lutpair54";
  attribute SOFT_HLUTNM of \data_fall_s[3]_i_1\ : label is "soft_lutpair54";
  attribute SOFT_HLUTNM of \data_rise_s[0]_i_1\ : label is "soft_lutpair50";
  attribute SOFT_HLUTNM of \data_rise_s[1]_i_1\ : label is "soft_lutpair51";
  attribute SOFT_HLUTNM of \data_rise_s[2]_i_1\ : label is "soft_lutpair51";
  attribute SOFT_HLUTNM of \data_rise_s[3]_i_1\ : label is "soft_lutpair52";
  attribute SOFT_HLUTNM of \data_rise_s[4]_i_1\ : label is "soft_lutpair52";
begin
OBUFDS_inst: unisim.vcomponents.OBUFDS
     port map (
      I => data,
      O => tmds_data_p(0),
      OB => tmds_data_n(0)
    );
ODDR2_inst0: unisim.vcomponents.ODDR
    generic map(
      DDR_CLK_EDGE => "OPPOSITE_EDGE",
      INIT => '0',
      IS_C_INVERTED => '1',
      SRTYPE => "SYNC"
    )
        port map (
      C => C00,
      CE => '1',
      D1 => \data_rise_s_reg_n_0_[0]\,
      D2 => data_fall_s(0),
      Q => data,
      R => NLW_ODDR2_inst0_R_UNCONNECTED,
      S => NLW_ODDR2_inst0_S_UNCONNECTED
    );
\cnt[0]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => p_4_in,
      I1 => \cnt_reg_n_0_[0]\,
      O => \cnt[0]_i_1_n_0\
    );
\cnt[1]_i_1__2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"06"
    )
        port map (
      I0 => \cnt_reg_n_0_[1]\,
      I1 => \cnt_reg_n_0_[0]\,
      I2 => p_4_in,
      O => \cnt[1]_i_1__2_n_0\
    );
\cnt[2]_i_1__2\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => \cnt_reg_n_0_[1]\,
      I1 => \cnt_reg_n_0_[0]\,
      I2 => p_4_in,
      O => \cnt[2]_i_1__2_n_0\
    );
\cnt_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => pclk_x5,
      CE => '1',
      D => \cnt[0]_i_1_n_0\,
      Q => \cnt_reg_n_0_[0]\,
      R => '0'
    );
\cnt_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => pclk_x5,
      CE => '1',
      D => \cnt[1]_i_1__2_n_0\,
      Q => \cnt_reg_n_0_[1]\,
      R => '0'
    );
\cnt_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => pclk_x5,
      CE => '1',
      D => \cnt[2]_i_1__2_n_0\,
      Q => p_4_in,
      R => '0'
    );
\data_fall_s[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \data_fall_s_reg[4]_0\(1),
      I1 => p_4_in,
      I2 => \data_fall_s_reg_n_0_[1]\,
      O => \data_fall_s[0]_i_1_n_0\
    );
\data_fall_s[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \data_fall_s_reg[4]_0\(3),
      I1 => p_4_in,
      I2 => \data_fall_s_reg_n_0_[2]\,
      O => \data_fall_s[1]_i_1_n_0\
    );
\data_fall_s[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \data_fall_s_reg[4]_0\(5),
      I1 => p_4_in,
      I2 => \data_fall_s_reg_n_0_[3]\,
      O => \data_fall_s[2]_i_1_n_0\
    );
\data_fall_s[3]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \data_fall_s_reg[4]_0\(7),
      I1 => p_4_in,
      I2 => \data_fall_s_reg_n_0_[4]\,
      O => \data_fall_s[3]_i_1_n_0\
    );
\data_fall_s[4]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => p_4_in,
      I1 => \data_fall_s_reg[4]_0\(9),
      O => \data_fall_s[4]_i_1_n_0\
    );
\data_fall_s_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => pclk_x5,
      CE => '1',
      D => \data_fall_s[0]_i_1_n_0\,
      Q => data_fall_s(0),
      R => '0'
    );
\data_fall_s_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => pclk_x5,
      CE => '1',
      D => \data_fall_s[1]_i_1_n_0\,
      Q => \data_fall_s_reg_n_0_[1]\,
      R => '0'
    );
\data_fall_s_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => pclk_x5,
      CE => '1',
      D => \data_fall_s[2]_i_1_n_0\,
      Q => \data_fall_s_reg_n_0_[2]\,
      R => '0'
    );
\data_fall_s_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => pclk_x5,
      CE => '1',
      D => \data_fall_s[3]_i_1_n_0\,
      Q => \data_fall_s_reg_n_0_[3]\,
      R => '0'
    );
\data_fall_s_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => pclk_x5,
      CE => '1',
      D => \data_fall_s[4]_i_1_n_0\,
      Q => \data_fall_s_reg_n_0_[4]\,
      R => '0'
    );
\data_rise_s[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \data_fall_s_reg[4]_0\(0),
      I1 => p_4_in,
      I2 => \data_rise_s_reg_n_0_[1]\,
      O => \data_rise_s[0]_i_1_n_0\
    );
\data_rise_s[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \data_fall_s_reg[4]_0\(2),
      I1 => p_4_in,
      I2 => \data_rise_s_reg_n_0_[2]\,
      O => \data_rise_s[1]_i_1_n_0\
    );
\data_rise_s[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \data_fall_s_reg[4]_0\(4),
      I1 => p_4_in,
      I2 => \data_rise_s_reg_n_0_[3]\,
      O => \data_rise_s[2]_i_1_n_0\
    );
\data_rise_s[3]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \data_fall_s_reg[4]_0\(6),
      I1 => p_4_in,
      I2 => \data_rise_s_reg_n_0_[4]\,
      O => \data_rise_s[3]_i_1_n_0\
    );
\data_rise_s[4]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => p_4_in,
      I1 => \data_fall_s_reg[4]_0\(8),
      O => \data_rise_s[4]_i_1_n_0\
    );
\data_rise_s_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => pclk_x5,
      CE => '1',
      D => \data_rise_s[0]_i_1_n_0\,
      Q => \data_rise_s_reg_n_0_[0]\,
      R => '0'
    );
\data_rise_s_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => pclk_x5,
      CE => '1',
      D => \data_rise_s[1]_i_1_n_0\,
      Q => \data_rise_s_reg_n_0_[1]\,
      R => '0'
    );
\data_rise_s_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => pclk_x5,
      CE => '1',
      D => \data_rise_s[2]_i_1_n_0\,
      Q => \data_rise_s_reg_n_0_[2]\,
      R => '0'
    );
\data_rise_s_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => pclk_x5,
      CE => '1',
      D => \data_rise_s[3]_i_1_n_0\,
      Q => \data_rise_s_reg_n_0_[3]\,
      R => '0'
    );
\data_rise_s_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => pclk_x5,
      CE => '1',
      D => \data_rise_s[4]_i_1_n_0\,
      Q => \data_rise_s_reg_n_0_[4]\,
      R => '0'
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_par_to_ser_2 is
  port (
    tmds_clk_p : out STD_LOGIC;
    tmds_clk_n : out STD_LOGIC;
    C00 : in STD_LOGIC;
    pclk_x5 : in STD_LOGIC
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_par_to_ser_2 : entity is "par_to_ser";
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_par_to_ser_2;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_par_to_ser_2 is
  signal \cnt[0]_i_1__2_n_0\ : STD_LOGIC;
  signal \cnt[1]_i_1__5_n_0\ : STD_LOGIC;
  signal \cnt[2]_i_1__5_n_0\ : STD_LOGIC;
  signal \cnt_reg_n_0_[0]\ : STD_LOGIC;
  signal \cnt_reg_n_0_[1]\ : STD_LOGIC;
  signal data : STD_LOGIC;
  signal data_fall_s : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \data_fall_s[2]_i_1_n_0\ : STD_LOGIC;
  signal \data_fall_s_reg_n_0_[1]\ : STD_LOGIC;
  signal \data_fall_s_reg_n_0_[2]\ : STD_LOGIC;
  signal \data_rise_s[3]_i_1_n_0\ : STD_LOGIC;
  signal \data_rise_s_reg_n_0_[0]\ : STD_LOGIC;
  signal \data_rise_s_reg_n_0_[1]\ : STD_LOGIC;
  signal \data_rise_s_reg_n_0_[2]\ : STD_LOGIC;
  signal \data_rise_s_reg_n_0_[3]\ : STD_LOGIC;
  signal \data_rise_s_reg_n_0_[4]\ : STD_LOGIC;
  signal p_4_in : STD_LOGIC;
  signal NLW_ODDR2_inst0_R_UNCONNECTED : STD_LOGIC;
  signal NLW_ODDR2_inst0_S_UNCONNECTED : STD_LOGIC;
  attribute BOX_TYPE : string;
  attribute BOX_TYPE of OBUFDS_inst : label is "PRIMITIVE";
  attribute CAPACITANCE : string;
  attribute CAPACITANCE of OBUFDS_inst : label is "DONT_CARE";
  attribute BOX_TYPE of ODDR2_inst0 : label is "PRIMITIVE";
  attribute OPT_MODIFIED : string;
  attribute OPT_MODIFIED of ODDR2_inst0 : label is "MLO";
  attribute XILINX_LEGACY_PRIM : string;
  attribute XILINX_LEGACY_PRIM of ODDR2_inst0 : label is "ODDR2";
  attribute XILINX_TRANSFORM_PINMAP : string;
  attribute XILINX_TRANSFORM_PINMAP of ODDR2_inst0 : label is "D0:D1 D1:D2 C0:C";
  attribute \__SRVAL\ : string;
  attribute \__SRVAL\ of ODDR2_inst0 : label is "TRUE";
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \cnt[0]_i_1__2\ : label is "soft_lutpair56";
  attribute SOFT_HLUTNM of \cnt[1]_i_1__5\ : label is "soft_lutpair55";
  attribute SOFT_HLUTNM of \cnt[2]_i_1__5\ : label is "soft_lutpair55";
  attribute SOFT_HLUTNM of \data_rise_s[3]_i_1\ : label is "soft_lutpair56";
begin
OBUFDS_inst: unisim.vcomponents.OBUFDS
     port map (
      I => data,
      O => tmds_clk_p,
      OB => tmds_clk_n
    );
ODDR2_inst0: unisim.vcomponents.ODDR
    generic map(
      DDR_CLK_EDGE => "OPPOSITE_EDGE",
      INIT => '0',
      IS_C_INVERTED => '1',
      SRTYPE => "SYNC"
    )
        port map (
      C => C00,
      CE => '1',
      D1 => \data_rise_s_reg_n_0_[0]\,
      D2 => data_fall_s(0),
      Q => data,
      R => NLW_ODDR2_inst0_R_UNCONNECTED,
      S => NLW_ODDR2_inst0_S_UNCONNECTED
    );
\cnt[0]_i_1__2\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => p_4_in,
      I1 => \cnt_reg_n_0_[0]\,
      O => \cnt[0]_i_1__2_n_0\
    );
\cnt[1]_i_1__5\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"06"
    )
        port map (
      I0 => \cnt_reg_n_0_[1]\,
      I1 => \cnt_reg_n_0_[0]\,
      I2 => p_4_in,
      O => \cnt[1]_i_1__5_n_0\
    );
\cnt[2]_i_1__5\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => \cnt_reg_n_0_[1]\,
      I1 => \cnt_reg_n_0_[0]\,
      I2 => p_4_in,
      O => \cnt[2]_i_1__5_n_0\
    );
\cnt_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => pclk_x5,
      CE => '1',
      D => \cnt[0]_i_1__2_n_0\,
      Q => \cnt_reg_n_0_[0]\,
      R => '0'
    );
\cnt_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => pclk_x5,
      CE => '1',
      D => \cnt[1]_i_1__5_n_0\,
      Q => \cnt_reg_n_0_[1]\,
      R => '0'
    );
\cnt_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => pclk_x5,
      CE => '1',
      D => \cnt[2]_i_1__5_n_0\,
      Q => p_4_in,
      R => '0'
    );
\data_fall_s[2]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => p_4_in,
      I1 => \data_rise_s_reg_n_0_[3]\,
      O => \data_fall_s[2]_i_1_n_0\
    );
\data_fall_s_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => pclk_x5,
      CE => '1',
      D => \data_fall_s_reg_n_0_[1]\,
      Q => data_fall_s(0),
      R => p_4_in
    );
\data_fall_s_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => pclk_x5,
      CE => '1',
      D => \data_fall_s_reg_n_0_[2]\,
      Q => \data_fall_s_reg_n_0_[1]\,
      R => p_4_in
    );
\data_fall_s_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => pclk_x5,
      CE => '1',
      D => \data_fall_s[2]_i_1_n_0\,
      Q => \data_fall_s_reg_n_0_[2]\,
      R => '0'
    );
\data_rise_s[3]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"E"
    )
        port map (
      I0 => p_4_in,
      I1 => \data_rise_s_reg_n_0_[4]\,
      O => \data_rise_s[3]_i_1_n_0\
    );
\data_rise_s_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => pclk_x5,
      CE => '1',
      D => \data_rise_s_reg_n_0_[1]\,
      Q => \data_rise_s_reg_n_0_[0]\,
      R => p_4_in
    );
\data_rise_s_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => pclk_x5,
      CE => '1',
      D => \data_rise_s_reg_n_0_[2]\,
      Q => \data_rise_s_reg_n_0_[1]\,
      R => p_4_in
    );
\data_rise_s_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => pclk_x5,
      CE => '1',
      D => \data_rise_s_reg_n_0_[3]\,
      Q => \data_rise_s_reg_n_0_[2]\,
      R => p_4_in
    );
\data_rise_s_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => pclk_x5,
      CE => '1',
      D => \data_rise_s[3]_i_1_n_0\,
      Q => \data_rise_s_reg_n_0_[3]\,
      R => '0'
    );
\data_rise_s_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => pclk_x5,
      CE => '1',
      D => p_4_in,
      Q => \data_rise_s_reg_n_0_[4]\,
      R => '0'
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_par_to_ser_3 is
  port (
    tmds_data_p : out STD_LOGIC_VECTOR ( 0 to 0 );
    tmds_data_n : out STD_LOGIC_VECTOR ( 0 to 0 );
    C00 : in STD_LOGIC;
    pclk_x5 : in STD_LOGIC;
    \data_fall_s_reg[4]_0\ : in STD_LOGIC_VECTOR ( 9 downto 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_par_to_ser_3 : entity is "par_to_ser";
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_par_to_ser_3;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_par_to_ser_3 is
  signal \cnt[0]_i_1__0_n_0\ : STD_LOGIC;
  signal \cnt[1]_i_1__3_n_0\ : STD_LOGIC;
  signal \cnt[2]_i_1__3_n_0\ : STD_LOGIC;
  signal \cnt_reg_n_0_[0]\ : STD_LOGIC;
  signal \cnt_reg_n_0_[1]\ : STD_LOGIC;
  signal data : STD_LOGIC;
  signal data_fall_s : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \data_fall_s[0]_i_1_n_0\ : STD_LOGIC;
  signal \data_fall_s[1]_i_1_n_0\ : STD_LOGIC;
  signal \data_fall_s[2]_i_1_n_0\ : STD_LOGIC;
  signal \data_fall_s[3]_i_1_n_0\ : STD_LOGIC;
  signal \data_fall_s[4]_i_1_n_0\ : STD_LOGIC;
  signal \data_fall_s_reg_n_0_[1]\ : STD_LOGIC;
  signal \data_fall_s_reg_n_0_[2]\ : STD_LOGIC;
  signal \data_fall_s_reg_n_0_[3]\ : STD_LOGIC;
  signal \data_fall_s_reg_n_0_[4]\ : STD_LOGIC;
  signal \data_rise_s[0]_i_1_n_0\ : STD_LOGIC;
  signal \data_rise_s[1]_i_1_n_0\ : STD_LOGIC;
  signal \data_rise_s[2]_i_1_n_0\ : STD_LOGIC;
  signal \data_rise_s[3]_i_1_n_0\ : STD_LOGIC;
  signal \data_rise_s[4]_i_1_n_0\ : STD_LOGIC;
  signal \data_rise_s_reg_n_0_[0]\ : STD_LOGIC;
  signal \data_rise_s_reg_n_0_[1]\ : STD_LOGIC;
  signal \data_rise_s_reg_n_0_[2]\ : STD_LOGIC;
  signal \data_rise_s_reg_n_0_[3]\ : STD_LOGIC;
  signal \data_rise_s_reg_n_0_[4]\ : STD_LOGIC;
  signal p_4_in : STD_LOGIC;
  signal NLW_ODDR2_inst0_R_UNCONNECTED : STD_LOGIC;
  signal NLW_ODDR2_inst0_S_UNCONNECTED : STD_LOGIC;
  attribute BOX_TYPE : string;
  attribute BOX_TYPE of OBUFDS_inst : label is "PRIMITIVE";
  attribute CAPACITANCE : string;
  attribute CAPACITANCE of OBUFDS_inst : label is "DONT_CARE";
  attribute BOX_TYPE of ODDR2_inst0 : label is "PRIMITIVE";
  attribute OPT_MODIFIED : string;
  attribute OPT_MODIFIED of ODDR2_inst0 : label is "MLO";
  attribute XILINX_LEGACY_PRIM : string;
  attribute XILINX_LEGACY_PRIM of ODDR2_inst0 : label is "ODDR2";
  attribute XILINX_TRANSFORM_PINMAP : string;
  attribute XILINX_TRANSFORM_PINMAP of ODDR2_inst0 : label is "D0:D1 D1:D2 C0:C";
  attribute \__SRVAL\ : string;
  attribute \__SRVAL\ of ODDR2_inst0 : label is "TRUE";
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \cnt[0]_i_1__0\ : label is "soft_lutpair58";
  attribute SOFT_HLUTNM of \cnt[1]_i_1__3\ : label is "soft_lutpair57";
  attribute SOFT_HLUTNM of \cnt[2]_i_1__3\ : label is "soft_lutpair57";
  attribute SOFT_HLUTNM of \data_fall_s[0]_i_1\ : label is "soft_lutpair61";
  attribute SOFT_HLUTNM of \data_fall_s[1]_i_1\ : label is "soft_lutpair61";
  attribute SOFT_HLUTNM of \data_fall_s[2]_i_1\ : label is "soft_lutpair62";
  attribute SOFT_HLUTNM of \data_fall_s[3]_i_1\ : label is "soft_lutpair62";
  attribute SOFT_HLUTNM of \data_rise_s[0]_i_1\ : label is "soft_lutpair58";
  attribute SOFT_HLUTNM of \data_rise_s[1]_i_1\ : label is "soft_lutpair59";
  attribute SOFT_HLUTNM of \data_rise_s[2]_i_1\ : label is "soft_lutpair59";
  attribute SOFT_HLUTNM of \data_rise_s[3]_i_1\ : label is "soft_lutpair60";
  attribute SOFT_HLUTNM of \data_rise_s[4]_i_1\ : label is "soft_lutpair60";
begin
OBUFDS_inst: unisim.vcomponents.OBUFDS
     port map (
      I => data,
      O => tmds_data_p(0),
      OB => tmds_data_n(0)
    );
ODDR2_inst0: unisim.vcomponents.ODDR
    generic map(
      DDR_CLK_EDGE => "OPPOSITE_EDGE",
      INIT => '0',
      IS_C_INVERTED => '1',
      SRTYPE => "SYNC"
    )
        port map (
      C => C00,
      CE => '1',
      D1 => \data_rise_s_reg_n_0_[0]\,
      D2 => data_fall_s(0),
      Q => data,
      R => NLW_ODDR2_inst0_R_UNCONNECTED,
      S => NLW_ODDR2_inst0_S_UNCONNECTED
    );
\cnt[0]_i_1__0\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => p_4_in,
      I1 => \cnt_reg_n_0_[0]\,
      O => \cnt[0]_i_1__0_n_0\
    );
\cnt[1]_i_1__3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"06"
    )
        port map (
      I0 => \cnt_reg_n_0_[1]\,
      I1 => \cnt_reg_n_0_[0]\,
      I2 => p_4_in,
      O => \cnt[1]_i_1__3_n_0\
    );
\cnt[2]_i_1__3\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => \cnt_reg_n_0_[1]\,
      I1 => \cnt_reg_n_0_[0]\,
      I2 => p_4_in,
      O => \cnt[2]_i_1__3_n_0\
    );
\cnt_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => pclk_x5,
      CE => '1',
      D => \cnt[0]_i_1__0_n_0\,
      Q => \cnt_reg_n_0_[0]\,
      R => '0'
    );
\cnt_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => pclk_x5,
      CE => '1',
      D => \cnt[1]_i_1__3_n_0\,
      Q => \cnt_reg_n_0_[1]\,
      R => '0'
    );
\cnt_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => pclk_x5,
      CE => '1',
      D => \cnt[2]_i_1__3_n_0\,
      Q => p_4_in,
      R => '0'
    );
\data_fall_s[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \data_fall_s_reg[4]_0\(1),
      I1 => p_4_in,
      I2 => \data_fall_s_reg_n_0_[1]\,
      O => \data_fall_s[0]_i_1_n_0\
    );
\data_fall_s[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \data_fall_s_reg[4]_0\(3),
      I1 => p_4_in,
      I2 => \data_fall_s_reg_n_0_[2]\,
      O => \data_fall_s[1]_i_1_n_0\
    );
\data_fall_s[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \data_fall_s_reg[4]_0\(5),
      I1 => p_4_in,
      I2 => \data_fall_s_reg_n_0_[3]\,
      O => \data_fall_s[2]_i_1_n_0\
    );
\data_fall_s[3]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \data_fall_s_reg[4]_0\(7),
      I1 => p_4_in,
      I2 => \data_fall_s_reg_n_0_[4]\,
      O => \data_fall_s[3]_i_1_n_0\
    );
\data_fall_s[4]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => p_4_in,
      I1 => \data_fall_s_reg[4]_0\(9),
      O => \data_fall_s[4]_i_1_n_0\
    );
\data_fall_s_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => pclk_x5,
      CE => '1',
      D => \data_fall_s[0]_i_1_n_0\,
      Q => data_fall_s(0),
      R => '0'
    );
\data_fall_s_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => pclk_x5,
      CE => '1',
      D => \data_fall_s[1]_i_1_n_0\,
      Q => \data_fall_s_reg_n_0_[1]\,
      R => '0'
    );
\data_fall_s_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => pclk_x5,
      CE => '1',
      D => \data_fall_s[2]_i_1_n_0\,
      Q => \data_fall_s_reg_n_0_[2]\,
      R => '0'
    );
\data_fall_s_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => pclk_x5,
      CE => '1',
      D => \data_fall_s[3]_i_1_n_0\,
      Q => \data_fall_s_reg_n_0_[3]\,
      R => '0'
    );
\data_fall_s_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => pclk_x5,
      CE => '1',
      D => \data_fall_s[4]_i_1_n_0\,
      Q => \data_fall_s_reg_n_0_[4]\,
      R => '0'
    );
\data_rise_s[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \data_fall_s_reg[4]_0\(0),
      I1 => p_4_in,
      I2 => \data_rise_s_reg_n_0_[1]\,
      O => \data_rise_s[0]_i_1_n_0\
    );
\data_rise_s[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \data_fall_s_reg[4]_0\(2),
      I1 => p_4_in,
      I2 => \data_rise_s_reg_n_0_[2]\,
      O => \data_rise_s[1]_i_1_n_0\
    );
\data_rise_s[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \data_fall_s_reg[4]_0\(4),
      I1 => p_4_in,
      I2 => \data_rise_s_reg_n_0_[3]\,
      O => \data_rise_s[2]_i_1_n_0\
    );
\data_rise_s[3]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \data_fall_s_reg[4]_0\(6),
      I1 => p_4_in,
      I2 => \data_rise_s_reg_n_0_[4]\,
      O => \data_rise_s[3]_i_1_n_0\
    );
\data_rise_s[4]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => p_4_in,
      I1 => \data_fall_s_reg[4]_0\(8),
      O => \data_rise_s[4]_i_1_n_0\
    );
\data_rise_s_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => pclk_x5,
      CE => '1',
      D => \data_rise_s[0]_i_1_n_0\,
      Q => \data_rise_s_reg_n_0_[0]\,
      R => '0'
    );
\data_rise_s_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => pclk_x5,
      CE => '1',
      D => \data_rise_s[1]_i_1_n_0\,
      Q => \data_rise_s_reg_n_0_[1]\,
      R => '0'
    );
\data_rise_s_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => pclk_x5,
      CE => '1',
      D => \data_rise_s[2]_i_1_n_0\,
      Q => \data_rise_s_reg_n_0_[2]\,
      R => '0'
    );
\data_rise_s_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => pclk_x5,
      CE => '1',
      D => \data_rise_s[3]_i_1_n_0\,
      Q => \data_rise_s_reg_n_0_[3]\,
      R => '0'
    );
\data_rise_s_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => pclk_x5,
      CE => '1',
      D => \data_rise_s[4]_i_1_n_0\,
      Q => \data_rise_s_reg_n_0_[4]\,
      R => '0'
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_par_to_ser_4 is
  port (
    C00 : out STD_LOGIC;
    tmds_data_p : out STD_LOGIC_VECTOR ( 0 to 0 );
    tmds_data_n : out STD_LOGIC_VECTOR ( 0 to 0 );
    pclk_x5 : in STD_LOGIC;
    \data_fall_s_reg[4]_0\ : in STD_LOGIC_VECTOR ( 9 downto 0 )
  );
  attribute ORIG_REF_NAME : string;
  attribute ORIG_REF_NAME of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_par_to_ser_4 : entity is "par_to_ser";
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_par_to_ser_4;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_par_to_ser_4 is
  signal \cnt[0]_i_1__1_n_0\ : STD_LOGIC;
  signal \cnt[1]_i_1__4_n_0\ : STD_LOGIC;
  signal \cnt[2]_i_1__4_n_0\ : STD_LOGIC;
  signal \cnt_reg_n_0_[0]\ : STD_LOGIC;
  signal \cnt_reg_n_0_[1]\ : STD_LOGIC;
  signal data : STD_LOGIC;
  signal data_fall_s : STD_LOGIC_VECTOR ( 0 to 0 );
  signal \data_fall_s[0]_i_1_n_0\ : STD_LOGIC;
  signal \data_fall_s[1]_i_1_n_0\ : STD_LOGIC;
  signal \data_fall_s[2]_i_1_n_0\ : STD_LOGIC;
  signal \data_fall_s[3]_i_1_n_0\ : STD_LOGIC;
  signal \data_fall_s[4]_i_1_n_0\ : STD_LOGIC;
  signal \data_fall_s_reg_n_0_[1]\ : STD_LOGIC;
  signal \data_fall_s_reg_n_0_[2]\ : STD_LOGIC;
  signal \data_fall_s_reg_n_0_[3]\ : STD_LOGIC;
  signal \data_fall_s_reg_n_0_[4]\ : STD_LOGIC;
  signal \data_rise_s[0]_i_1_n_0\ : STD_LOGIC;
  signal \data_rise_s[1]_i_1_n_0\ : STD_LOGIC;
  signal \data_rise_s[2]_i_1_n_0\ : STD_LOGIC;
  signal \data_rise_s[3]_i_1_n_0\ : STD_LOGIC;
  signal \data_rise_s[4]_i_1_n_0\ : STD_LOGIC;
  signal \data_rise_s_reg_n_0_[0]\ : STD_LOGIC;
  signal \data_rise_s_reg_n_0_[1]\ : STD_LOGIC;
  signal \data_rise_s_reg_n_0_[2]\ : STD_LOGIC;
  signal \data_rise_s_reg_n_0_[3]\ : STD_LOGIC;
  signal \data_rise_s_reg_n_0_[4]\ : STD_LOGIC;
  signal p_4_in : STD_LOGIC;
  signal \^pclk_x5\ : STD_LOGIC;
  signal NLW_ODDR2_inst0_R_UNCONNECTED : STD_LOGIC;
  signal NLW_ODDR2_inst0_S_UNCONNECTED : STD_LOGIC;
  attribute BOX_TYPE : string;
  attribute BOX_TYPE of OBUFDS_inst : label is "PRIMITIVE";
  attribute CAPACITANCE : string;
  attribute CAPACITANCE of OBUFDS_inst : label is "DONT_CARE";
  attribute BOX_TYPE of ODDR2_inst0 : label is "PRIMITIVE";
  attribute OPT_MODIFIED : string;
  attribute OPT_MODIFIED of ODDR2_inst0 : label is "MLO";
  attribute XILINX_LEGACY_PRIM : string;
  attribute XILINX_LEGACY_PRIM of ODDR2_inst0 : label is "ODDR2";
  attribute XILINX_TRANSFORM_PINMAP : string;
  attribute XILINX_TRANSFORM_PINMAP of ODDR2_inst0 : label is "D0:D1 D1:D2 C0:C";
  attribute \__SRVAL\ : string;
  attribute \__SRVAL\ of ODDR2_inst0 : label is "TRUE";
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \cnt[0]_i_1__1\ : label is "soft_lutpair64";
  attribute SOFT_HLUTNM of \cnt[1]_i_1__4\ : label is "soft_lutpair63";
  attribute SOFT_HLUTNM of \cnt[2]_i_1__4\ : label is "soft_lutpair63";
  attribute SOFT_HLUTNM of \data_fall_s[0]_i_1\ : label is "soft_lutpair67";
  attribute SOFT_HLUTNM of \data_fall_s[1]_i_1\ : label is "soft_lutpair67";
  attribute SOFT_HLUTNM of \data_fall_s[2]_i_1\ : label is "soft_lutpair68";
  attribute SOFT_HLUTNM of \data_fall_s[3]_i_1\ : label is "soft_lutpair68";
  attribute SOFT_HLUTNM of \data_rise_s[0]_i_1\ : label is "soft_lutpair64";
  attribute SOFT_HLUTNM of \data_rise_s[1]_i_1\ : label is "soft_lutpair65";
  attribute SOFT_HLUTNM of \data_rise_s[2]_i_1\ : label is "soft_lutpair65";
  attribute SOFT_HLUTNM of \data_rise_s[3]_i_1\ : label is "soft_lutpair66";
  attribute SOFT_HLUTNM of \data_rise_s[4]_i_1\ : label is "soft_lutpair66";
begin
  C00 <= \^pclk_x5\;
  \^pclk_x5\ <= pclk_x5;
OBUFDS_inst: unisim.vcomponents.OBUFDS
     port map (
      I => data,
      O => tmds_data_p(0),
      OB => tmds_data_n(0)
    );
ODDR2_inst0: unisim.vcomponents.ODDR
    generic map(
      DDR_CLK_EDGE => "OPPOSITE_EDGE",
      INIT => '0',
      IS_C_INVERTED => '1',
      SRTYPE => "SYNC"
    )
        port map (
      C => \^pclk_x5\,
      CE => '1',
      D1 => \data_rise_s_reg_n_0_[0]\,
      D2 => data_fall_s(0),
      Q => data,
      R => NLW_ODDR2_inst0_R_UNCONNECTED,
      S => NLW_ODDR2_inst0_S_UNCONNECTED
    );
\cnt[0]_i_1__1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => p_4_in,
      I1 => \cnt_reg_n_0_[0]\,
      O => \cnt[0]_i_1__1_n_0\
    );
\cnt[1]_i_1__4\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"06"
    )
        port map (
      I0 => \cnt_reg_n_0_[1]\,
      I1 => \cnt_reg_n_0_[0]\,
      I2 => p_4_in,
      O => \cnt[1]_i_1__4_n_0\
    );
\cnt[2]_i_1__4\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"08"
    )
        port map (
      I0 => \cnt_reg_n_0_[1]\,
      I1 => \cnt_reg_n_0_[0]\,
      I2 => p_4_in,
      O => \cnt[2]_i_1__4_n_0\
    );
\cnt_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => \^pclk_x5\,
      CE => '1',
      D => \cnt[0]_i_1__1_n_0\,
      Q => \cnt_reg_n_0_[0]\,
      R => '0'
    );
\cnt_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => \^pclk_x5\,
      CE => '1',
      D => \cnt[1]_i_1__4_n_0\,
      Q => \cnt_reg_n_0_[1]\,
      R => '0'
    );
\cnt_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => \^pclk_x5\,
      CE => '1',
      D => \cnt[2]_i_1__4_n_0\,
      Q => p_4_in,
      R => '0'
    );
\data_fall_s[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \data_fall_s_reg[4]_0\(1),
      I1 => p_4_in,
      I2 => \data_fall_s_reg_n_0_[1]\,
      O => \data_fall_s[0]_i_1_n_0\
    );
\data_fall_s[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \data_fall_s_reg[4]_0\(3),
      I1 => p_4_in,
      I2 => \data_fall_s_reg_n_0_[2]\,
      O => \data_fall_s[1]_i_1_n_0\
    );
\data_fall_s[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \data_fall_s_reg[4]_0\(5),
      I1 => p_4_in,
      I2 => \data_fall_s_reg_n_0_[3]\,
      O => \data_fall_s[2]_i_1_n_0\
    );
\data_fall_s[3]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \data_fall_s_reg[4]_0\(7),
      I1 => p_4_in,
      I2 => \data_fall_s_reg_n_0_[4]\,
      O => \data_fall_s[3]_i_1_n_0\
    );
\data_fall_s[4]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => p_4_in,
      I1 => \data_fall_s_reg[4]_0\(9),
      O => \data_fall_s[4]_i_1_n_0\
    );
\data_fall_s_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => \^pclk_x5\,
      CE => '1',
      D => \data_fall_s[0]_i_1_n_0\,
      Q => data_fall_s(0),
      R => '0'
    );
\data_fall_s_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => \^pclk_x5\,
      CE => '1',
      D => \data_fall_s[1]_i_1_n_0\,
      Q => \data_fall_s_reg_n_0_[1]\,
      R => '0'
    );
\data_fall_s_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => \^pclk_x5\,
      CE => '1',
      D => \data_fall_s[2]_i_1_n_0\,
      Q => \data_fall_s_reg_n_0_[2]\,
      R => '0'
    );
\data_fall_s_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => \^pclk_x5\,
      CE => '1',
      D => \data_fall_s[3]_i_1_n_0\,
      Q => \data_fall_s_reg_n_0_[3]\,
      R => '0'
    );
\data_fall_s_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => \^pclk_x5\,
      CE => '1',
      D => \data_fall_s[4]_i_1_n_0\,
      Q => \data_fall_s_reg_n_0_[4]\,
      R => '0'
    );
\data_rise_s[0]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \data_fall_s_reg[4]_0\(0),
      I1 => p_4_in,
      I2 => \data_rise_s_reg_n_0_[1]\,
      O => \data_rise_s[0]_i_1_n_0\
    );
\data_rise_s[1]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \data_fall_s_reg[4]_0\(2),
      I1 => p_4_in,
      I2 => \data_rise_s_reg_n_0_[2]\,
      O => \data_rise_s[1]_i_1_n_0\
    );
\data_rise_s[2]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \data_fall_s_reg[4]_0\(4),
      I1 => p_4_in,
      I2 => \data_rise_s_reg_n_0_[3]\,
      O => \data_rise_s[2]_i_1_n_0\
    );
\data_rise_s[3]_i_1\: unisim.vcomponents.LUT3
    generic map(
      INIT => X"B8"
    )
        port map (
      I0 => \data_fall_s_reg[4]_0\(6),
      I1 => p_4_in,
      I2 => \data_rise_s_reg_n_0_[4]\,
      O => \data_rise_s[3]_i_1_n_0\
    );
\data_rise_s[4]_i_1\: unisim.vcomponents.LUT2
    generic map(
      INIT => X"8"
    )
        port map (
      I0 => p_4_in,
      I1 => \data_fall_s_reg[4]_0\(8),
      O => \data_rise_s[4]_i_1_n_0\
    );
\data_rise_s_reg[0]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => \^pclk_x5\,
      CE => '1',
      D => \data_rise_s[0]_i_1_n_0\,
      Q => \data_rise_s_reg_n_0_[0]\,
      R => '0'
    );
\data_rise_s_reg[1]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => \^pclk_x5\,
      CE => '1',
      D => \data_rise_s[1]_i_1_n_0\,
      Q => \data_rise_s_reg_n_0_[1]\,
      R => '0'
    );
\data_rise_s_reg[2]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => \^pclk_x5\,
      CE => '1',
      D => \data_rise_s[2]_i_1_n_0\,
      Q => \data_rise_s_reg_n_0_[2]\,
      R => '0'
    );
\data_rise_s_reg[3]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => \^pclk_x5\,
      CE => '1',
      D => \data_rise_s[3]_i_1_n_0\,
      Q => \data_rise_s_reg_n_0_[3]\,
      R => '0'
    );
\data_rise_s_reg[4]\: unisim.vcomponents.FDRE
    generic map(
      INIT => '0'
    )
        port map (
      C => \^pclk_x5\,
      CE => '1',
      D => \data_rise_s[4]_i_1_n_0\,
      Q => \data_rise_s_reg_n_0_[4]\,
      R => '0'
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_hdmi_transmitter is
  port (
    tmds_data_p : out STD_LOGIC_VECTOR ( 2 downto 0 );
    tmds_data_n : out STD_LOGIC_VECTOR ( 2 downto 0 );
    tmds_clk_p : out STD_LOGIC;
    tmds_clk_n : out STD_LOGIC;
    pclk_x5 : in STD_LOGIC;
    video_de : in STD_LOGIC;
    pclk : in STD_LOGIC;
    video_hsync : in STD_LOGIC;
    video_vsync : in STD_LOGIC;
    rst_n : in STD_LOGIC;
    video_din : in STD_LOGIC_VECTOR ( 23 downto 0 )
  );
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_hdmi_transmitter;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_hdmi_transmitter is
  signal C00 : STD_LOGIC;
  signal c0_reg2 : STD_LOGIC;
  signal de_reg2 : STD_LOGIC;
  signal encode_b_n_0 : STD_LOGIC;
  signal encode_b_n_10 : STD_LOGIC;
  signal encode_b_n_11 : STD_LOGIC;
  signal encode_b_n_12 : STD_LOGIC;
  signal encode_b_n_13 : STD_LOGIC;
  signal encode_b_n_14 : STD_LOGIC;
  signal encode_b_n_15 : STD_LOGIC;
  signal encode_b_n_16 : STD_LOGIC;
  signal encode_b_n_3 : STD_LOGIC;
  signal encode_b_n_4 : STD_LOGIC;
  signal encode_b_n_5 : STD_LOGIC;
  signal encode_b_n_6 : STD_LOGIC;
  signal encode_b_n_7 : STD_LOGIC;
  signal encode_b_n_8 : STD_LOGIC;
  signal encode_b_n_9 : STD_LOGIC;
  signal encode_g_n_0 : STD_LOGIC;
  signal encode_g_n_1 : STD_LOGIC;
  signal encode_g_n_10 : STD_LOGIC;
  signal encode_g_n_11 : STD_LOGIC;
  signal encode_g_n_12 : STD_LOGIC;
  signal encode_g_n_2 : STD_LOGIC;
  signal encode_g_n_3 : STD_LOGIC;
  signal encode_g_n_4 : STD_LOGIC;
  signal encode_g_n_5 : STD_LOGIC;
  signal encode_g_n_6 : STD_LOGIC;
  signal encode_g_n_7 : STD_LOGIC;
  signal encode_g_n_8 : STD_LOGIC;
  signal encode_g_n_9 : STD_LOGIC;
  signal encode_r_n_0 : STD_LOGIC;
  signal encode_r_n_1 : STD_LOGIC;
  signal encode_r_n_10 : STD_LOGIC;
  signal encode_r_n_11 : STD_LOGIC;
  signal encode_r_n_12 : STD_LOGIC;
  signal encode_r_n_2 : STD_LOGIC;
  signal encode_r_n_3 : STD_LOGIC;
  signal encode_r_n_4 : STD_LOGIC;
  signal encode_r_n_5 : STD_LOGIC;
  signal encode_r_n_6 : STD_LOGIC;
  signal encode_r_n_7 : STD_LOGIC;
  signal encode_r_n_8 : STD_LOGIC;
  signal encode_r_n_9 : STD_LOGIC;
begin
encode_b: entity work.decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_encode
     port map (
      D(1) => encode_b_n_3,
      D(0) => encode_b_n_4,
      Q(0) => encode_g_n_2,
      c0_reg2 => c0_reg2,
      c0_reg2_reg_0(1) => encode_b_n_5,
      c0_reg2_reg_0(0) => encode_b_n_6,
      \data_out_reg[9]_0\(9) => encode_b_n_7,
      \data_out_reg[9]_0\(8) => encode_b_n_8,
      \data_out_reg[9]_0\(7) => encode_b_n_9,
      \data_out_reg[9]_0\(6) => encode_b_n_10,
      \data_out_reg[9]_0\(5) => encode_b_n_11,
      \data_out_reg[9]_0\(4) => encode_b_n_12,
      \data_out_reg[9]_0\(3) => encode_b_n_13,
      \data_out_reg[9]_0\(2) => encode_b_n_14,
      \data_out_reg[9]_0\(1) => encode_b_n_15,
      \data_out_reg[9]_0\(0) => encode_b_n_16,
      \data_out_reg[9]_1\ => encode_g_n_1,
      \data_out_reg[9]_2\ => encode_g_n_0,
      \data_out_reg[9]_3\ => encode_r_n_2,
      \data_out_reg[9]_4\ => encode_r_n_1,
      \data_out_reg[9]_5\(0) => encode_r_n_0,
      de_reg2 => de_reg2,
      pclk => pclk,
      rst_n => rst_n,
      rst_n_0 => encode_b_n_0,
      video_de => video_de,
      video_din(7 downto 0) => video_din(7 downto 0),
      video_hsync => video_hsync,
      video_vsync => video_vsync
    );
encode_g: entity work.decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_encode_0
     port map (
      D(1) => encode_b_n_3,
      D(0) => encode_b_n_4,
      Q(0) => encode_g_n_2,
      c0_reg2 => c0_reg2,
      \cnt_reg[2]_0\ => encode_g_n_0,
      \cnt_reg[4]_0\ => encode_g_n_1,
      \data_out_reg[0]_0\ => encode_b_n_0,
      \data_out_reg[9]_0\(9) => encode_g_n_3,
      \data_out_reg[9]_0\(8) => encode_g_n_4,
      \data_out_reg[9]_0\(7) => encode_g_n_5,
      \data_out_reg[9]_0\(6) => encode_g_n_6,
      \data_out_reg[9]_0\(5) => encode_g_n_7,
      \data_out_reg[9]_0\(4) => encode_g_n_8,
      \data_out_reg[9]_0\(3) => encode_g_n_9,
      \data_out_reg[9]_0\(2) => encode_g_n_10,
      \data_out_reg[9]_0\(1) => encode_g_n_11,
      \data_out_reg[9]_0\(0) => encode_g_n_12,
      de_reg2 => de_reg2,
      pclk => pclk,
      video_din(7 downto 0) => video_din(15 downto 8)
    );
encode_r: entity work.decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_encode_1
     port map (
      D(1) => encode_b_n_5,
      D(0) => encode_b_n_6,
      Q(0) => encode_r_n_0,
      c0_reg2 => c0_reg2,
      \cnt_reg[2]_0\ => encode_r_n_1,
      \cnt_reg[4]_0\ => encode_r_n_2,
      \data_out_reg[9]_0\(9) => encode_r_n_3,
      \data_out_reg[9]_0\(8) => encode_r_n_4,
      \data_out_reg[9]_0\(7) => encode_r_n_5,
      \data_out_reg[9]_0\(6) => encode_r_n_6,
      \data_out_reg[9]_0\(5) => encode_r_n_7,
      \data_out_reg[9]_0\(4) => encode_r_n_8,
      \data_out_reg[9]_0\(3) => encode_r_n_9,
      \data_out_reg[9]_0\(2) => encode_r_n_10,
      \data_out_reg[9]_0\(1) => encode_r_n_11,
      \data_out_reg[9]_0\(0) => encode_r_n_12,
      \data_out_reg[9]_1\ => encode_b_n_0,
      de_reg2 => de_reg2,
      pclk => pclk,
      video_din(7 downto 0) => video_din(23 downto 16)
    );
par_to_ser_b: entity work.decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_par_to_ser
     port map (
      C00 => C00,
      \data_fall_s_reg[4]_0\(9) => encode_b_n_7,
      \data_fall_s_reg[4]_0\(8) => encode_b_n_8,
      \data_fall_s_reg[4]_0\(7) => encode_b_n_9,
      \data_fall_s_reg[4]_0\(6) => encode_b_n_10,
      \data_fall_s_reg[4]_0\(5) => encode_b_n_11,
      \data_fall_s_reg[4]_0\(4) => encode_b_n_12,
      \data_fall_s_reg[4]_0\(3) => encode_b_n_13,
      \data_fall_s_reg[4]_0\(2) => encode_b_n_14,
      \data_fall_s_reg[4]_0\(1) => encode_b_n_15,
      \data_fall_s_reg[4]_0\(0) => encode_b_n_16,
      pclk_x5 => pclk_x5,
      tmds_data_n(0) => tmds_data_n(0),
      tmds_data_p(0) => tmds_data_p(0)
    );
par_to_ser_clk: entity work.decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_par_to_ser_2
     port map (
      C00 => C00,
      pclk_x5 => pclk_x5,
      tmds_clk_n => tmds_clk_n,
      tmds_clk_p => tmds_clk_p
    );
par_to_ser_g: entity work.decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_par_to_ser_3
     port map (
      C00 => C00,
      \data_fall_s_reg[4]_0\(9) => encode_g_n_3,
      \data_fall_s_reg[4]_0\(8) => encode_g_n_4,
      \data_fall_s_reg[4]_0\(7) => encode_g_n_5,
      \data_fall_s_reg[4]_0\(6) => encode_g_n_6,
      \data_fall_s_reg[4]_0\(5) => encode_g_n_7,
      \data_fall_s_reg[4]_0\(4) => encode_g_n_8,
      \data_fall_s_reg[4]_0\(3) => encode_g_n_9,
      \data_fall_s_reg[4]_0\(2) => encode_g_n_10,
      \data_fall_s_reg[4]_0\(1) => encode_g_n_11,
      \data_fall_s_reg[4]_0\(0) => encode_g_n_12,
      pclk_x5 => pclk_x5,
      tmds_data_n(0) => tmds_data_n(1),
      tmds_data_p(0) => tmds_data_p(1)
    );
par_to_ser_r: entity work.decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_par_to_ser_4
     port map (
      C00 => C00,
      \data_fall_s_reg[4]_0\(9) => encode_r_n_3,
      \data_fall_s_reg[4]_0\(8) => encode_r_n_4,
      \data_fall_s_reg[4]_0\(7) => encode_r_n_5,
      \data_fall_s_reg[4]_0\(6) => encode_r_n_6,
      \data_fall_s_reg[4]_0\(5) => encode_r_n_7,
      \data_fall_s_reg[4]_0\(4) => encode_r_n_8,
      \data_fall_s_reg[4]_0\(3) => encode_r_n_9,
      \data_fall_s_reg[4]_0\(2) => encode_r_n_10,
      \data_fall_s_reg[4]_0\(1) => encode_r_n_11,
      \data_fall_s_reg[4]_0\(0) => encode_r_n_12,
      pclk_x5 => pclk_x5,
      tmds_data_n(0) => tmds_data_n(2),
      tmds_data_p(0) => tmds_data_p(2)
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_hdmi_transmitter_v1_0_S00_AXI is
  port (
    tmds_data_p : out STD_LOGIC_VECTOR ( 2 downto 0 );
    tmds_data_n : out STD_LOGIC_VECTOR ( 2 downto 0 );
    tmds_clk_p : out STD_LOGIC;
    tmds_clk_n : out STD_LOGIC;
    S_AXI_WREADY : out STD_LOGIC;
    S_AXI_AWREADY : out STD_LOGIC;
    S_AXI_ARREADY : out STD_LOGIC;
    s00_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_rvalid : out STD_LOGIC;
    s00_axi_bvalid : out STD_LOGIC;
    pclk_x5 : in STD_LOGIC;
    video_din : in STD_LOGIC_VECTOR ( 23 downto 0 );
    pclk : in STD_LOGIC;
    video_de : in STD_LOGIC;
    video_hsync : in STD_LOGIC;
    video_vsync : in STD_LOGIC;
    s00_axi_aclk : in STD_LOGIC;
    s00_axi_araddr : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_arvalid : in STD_LOGIC;
    s00_axi_awaddr : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_wvalid : in STD_LOGIC;
    s00_axi_awvalid : in STD_LOGIC;
    s00_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_aresetn : in STD_LOGIC;
    rst_n : in STD_LOGIC;
    s00_axi_bready : in STD_LOGIC;
    s00_axi_rready : in STD_LOGIC
  );
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_hdmi_transmitter_v1_0_S00_AXI;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_hdmi_transmitter_v1_0_S00_AXI is
  signal \^s_axi_arready\ : STD_LOGIC;
  signal \^s_axi_awready\ : STD_LOGIC;
  signal \^s_axi_wready\ : STD_LOGIC;
  signal aw_en_i_1_n_0 : STD_LOGIC;
  signal aw_en_reg_n_0 : STD_LOGIC;
  signal axi_araddr : STD_LOGIC_VECTOR ( 3 downto 2 );
  signal \axi_araddr[2]_i_1_n_0\ : STD_LOGIC;
  signal \axi_araddr[3]_i_1_n_0\ : STD_LOGIC;
  signal axi_arready0 : STD_LOGIC;
  signal axi_awaddr : STD_LOGIC_VECTOR ( 3 downto 2 );
  signal \axi_awaddr[2]_i_1_n_0\ : STD_LOGIC;
  signal \axi_awaddr[3]_i_1_n_0\ : STD_LOGIC;
  signal axi_awready0 : STD_LOGIC;
  signal axi_awready_i_1_n_0 : STD_LOGIC;
  signal axi_bvalid_i_1_n_0 : STD_LOGIC;
  signal axi_rvalid_i_1_n_0 : STD_LOGIC;
  signal axi_wready0 : STD_LOGIC;
  signal reg_data_out : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \^s00_axi_bvalid\ : STD_LOGIC;
  signal \^s00_axi_rvalid\ : STD_LOGIC;
  signal slv_reg0 : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \slv_reg0[15]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg0[23]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg0[31]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg0[7]_i_1_n_0\ : STD_LOGIC;
  signal slv_reg1 : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \slv_reg1[15]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg1[23]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg1[31]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg1[7]_i_1_n_0\ : STD_LOGIC;
  signal slv_reg2 : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \slv_reg2[15]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg2[23]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg2[31]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg2[7]_i_1_n_0\ : STD_LOGIC;
  signal slv_reg3 : STD_LOGIC_VECTOR ( 31 downto 0 );
  signal \slv_reg3[15]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg3[23]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg3[31]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg3[7]_i_1_n_0\ : STD_LOGIC;
  signal \slv_reg_rden__0\ : STD_LOGIC;
  signal \slv_reg_wren__0\ : STD_LOGIC;
  attribute SOFT_HLUTNM : string;
  attribute SOFT_HLUTNM of \axi_araddr[3]_i_1\ : label is "soft_lutpair69";
  attribute SOFT_HLUTNM of axi_arready_i_1 : label is "soft_lutpair69";
  attribute SOFT_HLUTNM of axi_wready_i_1 : label is "soft_lutpair70";
  attribute SOFT_HLUTNM of \slv_reg3[31]_i_2\ : label is "soft_lutpair70";
begin
  S_AXI_ARREADY <= \^s_axi_arready\;
  S_AXI_AWREADY <= \^s_axi_awready\;
  S_AXI_WREADY <= \^s_axi_wready\;
  s00_axi_bvalid <= \^s00_axi_bvalid\;
  s00_axi_rvalid <= \^s00_axi_rvalid\;
aw_en_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F7FFC4CCC4CCC4CC"
    )
        port map (
      I0 => s00_axi_awvalid,
      I1 => aw_en_reg_n_0,
      I2 => \^s_axi_awready\,
      I3 => s00_axi_wvalid,
      I4 => s00_axi_bready,
      I5 => \^s00_axi_bvalid\,
      O => aw_en_i_1_n_0
    );
aw_en_reg: unisim.vcomponents.FDSE
     port map (
      C => s00_axi_aclk,
      CE => '1',
      D => aw_en_i_1_n_0,
      Q => aw_en_reg_n_0,
      S => axi_awready_i_1_n_0
    );
\axi_araddr[2]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => s00_axi_araddr(0),
      I1 => s00_axi_arvalid,
      I2 => \^s_axi_arready\,
      I3 => axi_araddr(2),
      O => \axi_araddr[2]_i_1_n_0\
    );
\axi_araddr[3]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"FB08"
    )
        port map (
      I0 => s00_axi_araddr(1),
      I1 => s00_axi_arvalid,
      I2 => \^s_axi_arready\,
      I3 => axi_araddr(3),
      O => \axi_araddr[3]_i_1_n_0\
    );
\axi_araddr_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => '1',
      D => \axi_araddr[2]_i_1_n_0\,
      Q => axi_araddr(2),
      R => axi_awready_i_1_n_0
    );
\axi_araddr_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => '1',
      D => \axi_araddr[3]_i_1_n_0\,
      Q => axi_araddr(3),
      R => axi_awready_i_1_n_0
    );
axi_arready_i_1: unisim.vcomponents.LUT2
    generic map(
      INIT => X"2"
    )
        port map (
      I0 => s00_axi_arvalid,
      I1 => \^s_axi_arready\,
      O => axi_arready0
    );
axi_arready_reg: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => '1',
      D => axi_arready0,
      Q => \^s_axi_arready\,
      R => axi_awready_i_1_n_0
    );
\axi_awaddr[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FBFFFFFF08000000"
    )
        port map (
      I0 => s00_axi_awaddr(0),
      I1 => s00_axi_wvalid,
      I2 => \^s_axi_awready\,
      I3 => aw_en_reg_n_0,
      I4 => s00_axi_awvalid,
      I5 => axi_awaddr(2),
      O => \axi_awaddr[2]_i_1_n_0\
    );
\axi_awaddr[3]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"FBFFFFFF08000000"
    )
        port map (
      I0 => s00_axi_awaddr(1),
      I1 => s00_axi_wvalid,
      I2 => \^s_axi_awready\,
      I3 => aw_en_reg_n_0,
      I4 => s00_axi_awvalid,
      I5 => axi_awaddr(3),
      O => \axi_awaddr[3]_i_1_n_0\
    );
\axi_awaddr_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => '1',
      D => \axi_awaddr[2]_i_1_n_0\,
      Q => axi_awaddr(2),
      R => axi_awready_i_1_n_0
    );
\axi_awaddr_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => '1',
      D => \axi_awaddr[3]_i_1_n_0\,
      Q => axi_awaddr(3),
      R => axi_awready_i_1_n_0
    );
axi_awready_i_1: unisim.vcomponents.LUT1
    generic map(
      INIT => X"1"
    )
        port map (
      I0 => s00_axi_aresetn,
      O => axi_awready_i_1_n_0
    );
axi_awready_i_2: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2000"
    )
        port map (
      I0 => s00_axi_wvalid,
      I1 => \^s_axi_awready\,
      I2 => aw_en_reg_n_0,
      I3 => s00_axi_awvalid,
      O => axi_awready0
    );
axi_awready_reg: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => '1',
      D => axi_awready0,
      Q => \^s_axi_awready\,
      R => axi_awready_i_1_n_0
    );
axi_bvalid_i_1: unisim.vcomponents.LUT6
    generic map(
      INIT => X"0000FFFF80008000"
    )
        port map (
      I0 => s00_axi_awvalid,
      I1 => s00_axi_wvalid,
      I2 => \^s_axi_awready\,
      I3 => \^s_axi_wready\,
      I4 => s00_axi_bready,
      I5 => \^s00_axi_bvalid\,
      O => axi_bvalid_i_1_n_0
    );
axi_bvalid_reg: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => '1',
      D => axi_bvalid_i_1_n_0,
      Q => \^s00_axi_bvalid\,
      R => axi_awready_i_1_n_0
    );
\axi_rdata[0]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0AAFFCCF0AA00CC"
    )
        port map (
      I0 => slv_reg1(0),
      I1 => slv_reg0(0),
      I2 => slv_reg3(0),
      I3 => axi_araddr(3),
      I4 => axi_araddr(2),
      I5 => slv_reg2(0),
      O => reg_data_out(0)
    );
\axi_rdata[10]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0AAFFCCF0AA00CC"
    )
        port map (
      I0 => slv_reg1(10),
      I1 => slv_reg0(10),
      I2 => slv_reg3(10),
      I3 => axi_araddr(3),
      I4 => axi_araddr(2),
      I5 => slv_reg2(10),
      O => reg_data_out(10)
    );
\axi_rdata[11]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0AAFFCCF0AA00CC"
    )
        port map (
      I0 => slv_reg1(11),
      I1 => slv_reg0(11),
      I2 => slv_reg3(11),
      I3 => axi_araddr(3),
      I4 => axi_araddr(2),
      I5 => slv_reg2(11),
      O => reg_data_out(11)
    );
\axi_rdata[12]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0AAFFCCF0AA00CC"
    )
        port map (
      I0 => slv_reg1(12),
      I1 => slv_reg0(12),
      I2 => slv_reg3(12),
      I3 => axi_araddr(3),
      I4 => axi_araddr(2),
      I5 => slv_reg2(12),
      O => reg_data_out(12)
    );
\axi_rdata[13]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0AAFFCCF0AA00CC"
    )
        port map (
      I0 => slv_reg1(13),
      I1 => slv_reg0(13),
      I2 => slv_reg3(13),
      I3 => axi_araddr(3),
      I4 => axi_araddr(2),
      I5 => slv_reg2(13),
      O => reg_data_out(13)
    );
\axi_rdata[14]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0AAFFCCF0AA00CC"
    )
        port map (
      I0 => slv_reg1(14),
      I1 => slv_reg0(14),
      I2 => slv_reg3(14),
      I3 => axi_araddr(3),
      I4 => axi_araddr(2),
      I5 => slv_reg2(14),
      O => reg_data_out(14)
    );
\axi_rdata[15]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0AAFFCCF0AA00CC"
    )
        port map (
      I0 => slv_reg1(15),
      I1 => slv_reg0(15),
      I2 => slv_reg3(15),
      I3 => axi_araddr(3),
      I4 => axi_araddr(2),
      I5 => slv_reg2(15),
      O => reg_data_out(15)
    );
\axi_rdata[16]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0AAFFCCF0AA00CC"
    )
        port map (
      I0 => slv_reg1(16),
      I1 => slv_reg0(16),
      I2 => slv_reg3(16),
      I3 => axi_araddr(3),
      I4 => axi_araddr(2),
      I5 => slv_reg2(16),
      O => reg_data_out(16)
    );
\axi_rdata[17]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0AAFFCCF0AA00CC"
    )
        port map (
      I0 => slv_reg1(17),
      I1 => slv_reg0(17),
      I2 => slv_reg3(17),
      I3 => axi_araddr(3),
      I4 => axi_araddr(2),
      I5 => slv_reg2(17),
      O => reg_data_out(17)
    );
\axi_rdata[18]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0AAFFCCF0AA00CC"
    )
        port map (
      I0 => slv_reg1(18),
      I1 => slv_reg0(18),
      I2 => slv_reg3(18),
      I3 => axi_araddr(3),
      I4 => axi_araddr(2),
      I5 => slv_reg2(18),
      O => reg_data_out(18)
    );
\axi_rdata[19]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0AAFFCCF0AA00CC"
    )
        port map (
      I0 => slv_reg1(19),
      I1 => slv_reg0(19),
      I2 => slv_reg3(19),
      I3 => axi_araddr(3),
      I4 => axi_araddr(2),
      I5 => slv_reg2(19),
      O => reg_data_out(19)
    );
\axi_rdata[1]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0AAFFCCF0AA00CC"
    )
        port map (
      I0 => slv_reg1(1),
      I1 => slv_reg0(1),
      I2 => slv_reg3(1),
      I3 => axi_araddr(3),
      I4 => axi_araddr(2),
      I5 => slv_reg2(1),
      O => reg_data_out(1)
    );
\axi_rdata[20]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0AAFFCCF0AA00CC"
    )
        port map (
      I0 => slv_reg1(20),
      I1 => slv_reg0(20),
      I2 => slv_reg3(20),
      I3 => axi_araddr(3),
      I4 => axi_araddr(2),
      I5 => slv_reg2(20),
      O => reg_data_out(20)
    );
\axi_rdata[21]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0AAFFCCF0AA00CC"
    )
        port map (
      I0 => slv_reg1(21),
      I1 => slv_reg0(21),
      I2 => slv_reg3(21),
      I3 => axi_araddr(3),
      I4 => axi_araddr(2),
      I5 => slv_reg2(21),
      O => reg_data_out(21)
    );
\axi_rdata[22]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0AAFFCCF0AA00CC"
    )
        port map (
      I0 => slv_reg1(22),
      I1 => slv_reg0(22),
      I2 => slv_reg3(22),
      I3 => axi_araddr(3),
      I4 => axi_araddr(2),
      I5 => slv_reg2(22),
      O => reg_data_out(22)
    );
\axi_rdata[23]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0AAFFCCF0AA00CC"
    )
        port map (
      I0 => slv_reg1(23),
      I1 => slv_reg0(23),
      I2 => slv_reg3(23),
      I3 => axi_araddr(3),
      I4 => axi_araddr(2),
      I5 => slv_reg2(23),
      O => reg_data_out(23)
    );
\axi_rdata[24]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0AAFFCCF0AA00CC"
    )
        port map (
      I0 => slv_reg1(24),
      I1 => slv_reg0(24),
      I2 => slv_reg3(24),
      I3 => axi_araddr(3),
      I4 => axi_araddr(2),
      I5 => slv_reg2(24),
      O => reg_data_out(24)
    );
\axi_rdata[25]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0AAFFCCF0AA00CC"
    )
        port map (
      I0 => slv_reg1(25),
      I1 => slv_reg0(25),
      I2 => slv_reg3(25),
      I3 => axi_araddr(3),
      I4 => axi_araddr(2),
      I5 => slv_reg2(25),
      O => reg_data_out(25)
    );
\axi_rdata[26]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0AAFFCCF0AA00CC"
    )
        port map (
      I0 => slv_reg1(26),
      I1 => slv_reg0(26),
      I2 => slv_reg3(26),
      I3 => axi_araddr(3),
      I4 => axi_araddr(2),
      I5 => slv_reg2(26),
      O => reg_data_out(26)
    );
\axi_rdata[27]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0AAFFCCF0AA00CC"
    )
        port map (
      I0 => slv_reg1(27),
      I1 => slv_reg0(27),
      I2 => slv_reg3(27),
      I3 => axi_araddr(3),
      I4 => axi_araddr(2),
      I5 => slv_reg2(27),
      O => reg_data_out(27)
    );
\axi_rdata[28]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0AAFFCCF0AA00CC"
    )
        port map (
      I0 => slv_reg1(28),
      I1 => slv_reg0(28),
      I2 => slv_reg3(28),
      I3 => axi_araddr(3),
      I4 => axi_araddr(2),
      I5 => slv_reg2(28),
      O => reg_data_out(28)
    );
\axi_rdata[29]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0AAFFCCF0AA00CC"
    )
        port map (
      I0 => slv_reg1(29),
      I1 => slv_reg0(29),
      I2 => slv_reg3(29),
      I3 => axi_araddr(3),
      I4 => axi_araddr(2),
      I5 => slv_reg2(29),
      O => reg_data_out(29)
    );
\axi_rdata[2]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0AAFFCCF0AA00CC"
    )
        port map (
      I0 => slv_reg1(2),
      I1 => slv_reg0(2),
      I2 => slv_reg3(2),
      I3 => axi_araddr(3),
      I4 => axi_araddr(2),
      I5 => slv_reg2(2),
      O => reg_data_out(2)
    );
\axi_rdata[30]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0AAFFCCF0AA00CC"
    )
        port map (
      I0 => slv_reg1(30),
      I1 => slv_reg0(30),
      I2 => slv_reg3(30),
      I3 => axi_araddr(3),
      I4 => axi_araddr(2),
      I5 => slv_reg2(30),
      O => reg_data_out(30)
    );
\axi_rdata[31]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0AAFFCCF0AA00CC"
    )
        port map (
      I0 => slv_reg1(31),
      I1 => slv_reg0(31),
      I2 => slv_reg3(31),
      I3 => axi_araddr(3),
      I4 => axi_araddr(2),
      I5 => slv_reg2(31),
      O => reg_data_out(31)
    );
\axi_rdata[3]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0AAFFCCF0AA00CC"
    )
        port map (
      I0 => slv_reg1(3),
      I1 => slv_reg0(3),
      I2 => slv_reg3(3),
      I3 => axi_araddr(3),
      I4 => axi_araddr(2),
      I5 => slv_reg2(3),
      O => reg_data_out(3)
    );
\axi_rdata[4]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0AAFFCCF0AA00CC"
    )
        port map (
      I0 => slv_reg1(4),
      I1 => slv_reg0(4),
      I2 => slv_reg3(4),
      I3 => axi_araddr(3),
      I4 => axi_araddr(2),
      I5 => slv_reg2(4),
      O => reg_data_out(4)
    );
\axi_rdata[5]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0AAFFCCF0AA00CC"
    )
        port map (
      I0 => slv_reg1(5),
      I1 => slv_reg0(5),
      I2 => slv_reg3(5),
      I3 => axi_araddr(3),
      I4 => axi_araddr(2),
      I5 => slv_reg2(5),
      O => reg_data_out(5)
    );
\axi_rdata[6]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0AAFFCCF0AA00CC"
    )
        port map (
      I0 => slv_reg1(6),
      I1 => slv_reg0(6),
      I2 => slv_reg3(6),
      I3 => axi_araddr(3),
      I4 => axi_araddr(2),
      I5 => slv_reg2(6),
      O => reg_data_out(6)
    );
\axi_rdata[7]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0AAFFCCF0AA00CC"
    )
        port map (
      I0 => slv_reg1(7),
      I1 => slv_reg0(7),
      I2 => slv_reg3(7),
      I3 => axi_araddr(3),
      I4 => axi_araddr(2),
      I5 => slv_reg2(7),
      O => reg_data_out(7)
    );
\axi_rdata[8]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0AAFFCCF0AA00CC"
    )
        port map (
      I0 => slv_reg1(8),
      I1 => slv_reg0(8),
      I2 => slv_reg3(8),
      I3 => axi_araddr(3),
      I4 => axi_araddr(2),
      I5 => slv_reg2(8),
      O => reg_data_out(8)
    );
\axi_rdata[9]_i_1\: unisim.vcomponents.LUT6
    generic map(
      INIT => X"F0AAFFCCF0AA00CC"
    )
        port map (
      I0 => slv_reg1(9),
      I1 => slv_reg0(9),
      I2 => slv_reg3(9),
      I3 => axi_araddr(3),
      I4 => axi_araddr(2),
      I5 => slv_reg2(9),
      O => reg_data_out(9)
    );
\axi_rdata_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(0),
      Q => s00_axi_rdata(0),
      R => axi_awready_i_1_n_0
    );
\axi_rdata_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(10),
      Q => s00_axi_rdata(10),
      R => axi_awready_i_1_n_0
    );
\axi_rdata_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(11),
      Q => s00_axi_rdata(11),
      R => axi_awready_i_1_n_0
    );
\axi_rdata_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(12),
      Q => s00_axi_rdata(12),
      R => axi_awready_i_1_n_0
    );
\axi_rdata_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(13),
      Q => s00_axi_rdata(13),
      R => axi_awready_i_1_n_0
    );
\axi_rdata_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(14),
      Q => s00_axi_rdata(14),
      R => axi_awready_i_1_n_0
    );
\axi_rdata_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(15),
      Q => s00_axi_rdata(15),
      R => axi_awready_i_1_n_0
    );
\axi_rdata_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(16),
      Q => s00_axi_rdata(16),
      R => axi_awready_i_1_n_0
    );
\axi_rdata_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(17),
      Q => s00_axi_rdata(17),
      R => axi_awready_i_1_n_0
    );
\axi_rdata_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(18),
      Q => s00_axi_rdata(18),
      R => axi_awready_i_1_n_0
    );
\axi_rdata_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(19),
      Q => s00_axi_rdata(19),
      R => axi_awready_i_1_n_0
    );
\axi_rdata_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(1),
      Q => s00_axi_rdata(1),
      R => axi_awready_i_1_n_0
    );
\axi_rdata_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(20),
      Q => s00_axi_rdata(20),
      R => axi_awready_i_1_n_0
    );
\axi_rdata_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(21),
      Q => s00_axi_rdata(21),
      R => axi_awready_i_1_n_0
    );
\axi_rdata_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(22),
      Q => s00_axi_rdata(22),
      R => axi_awready_i_1_n_0
    );
\axi_rdata_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(23),
      Q => s00_axi_rdata(23),
      R => axi_awready_i_1_n_0
    );
\axi_rdata_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(24),
      Q => s00_axi_rdata(24),
      R => axi_awready_i_1_n_0
    );
\axi_rdata_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(25),
      Q => s00_axi_rdata(25),
      R => axi_awready_i_1_n_0
    );
\axi_rdata_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(26),
      Q => s00_axi_rdata(26),
      R => axi_awready_i_1_n_0
    );
\axi_rdata_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(27),
      Q => s00_axi_rdata(27),
      R => axi_awready_i_1_n_0
    );
\axi_rdata_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(28),
      Q => s00_axi_rdata(28),
      R => axi_awready_i_1_n_0
    );
\axi_rdata_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(29),
      Q => s00_axi_rdata(29),
      R => axi_awready_i_1_n_0
    );
\axi_rdata_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(2),
      Q => s00_axi_rdata(2),
      R => axi_awready_i_1_n_0
    );
\axi_rdata_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(30),
      Q => s00_axi_rdata(30),
      R => axi_awready_i_1_n_0
    );
\axi_rdata_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(31),
      Q => s00_axi_rdata(31),
      R => axi_awready_i_1_n_0
    );
\axi_rdata_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(3),
      Q => s00_axi_rdata(3),
      R => axi_awready_i_1_n_0
    );
\axi_rdata_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(4),
      Q => s00_axi_rdata(4),
      R => axi_awready_i_1_n_0
    );
\axi_rdata_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(5),
      Q => s00_axi_rdata(5),
      R => axi_awready_i_1_n_0
    );
\axi_rdata_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(6),
      Q => s00_axi_rdata(6),
      R => axi_awready_i_1_n_0
    );
\axi_rdata_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(7),
      Q => s00_axi_rdata(7),
      R => axi_awready_i_1_n_0
    );
\axi_rdata_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(8),
      Q => s00_axi_rdata(8),
      R => axi_awready_i_1_n_0
    );
\axi_rdata_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg_rden__0\,
      D => reg_data_out(9),
      Q => s00_axi_rdata(9),
      R => axi_awready_i_1_n_0
    );
axi_rvalid_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"08F8"
    )
        port map (
      I0 => \^s_axi_arready\,
      I1 => s00_axi_arvalid,
      I2 => \^s00_axi_rvalid\,
      I3 => s00_axi_rready,
      O => axi_rvalid_i_1_n_0
    );
axi_rvalid_reg: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => '1',
      D => axi_rvalid_i_1_n_0,
      Q => \^s00_axi_rvalid\,
      R => axi_awready_i_1_n_0
    );
axi_wready_i_1: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0800"
    )
        port map (
      I0 => s00_axi_awvalid,
      I1 => s00_axi_wvalid,
      I2 => \^s_axi_wready\,
      I3 => aw_en_reg_n_0,
      O => axi_wready0
    );
axi_wready_reg: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => '1',
      D => axi_wready0,
      Q => \^s_axi_wready\,
      R => axi_awready_i_1_n_0
    );
hdmi_transmitter_inst: entity work.decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_hdmi_transmitter
     port map (
      pclk => pclk,
      pclk_x5 => pclk_x5,
      rst_n => rst_n,
      tmds_clk_n => tmds_clk_n,
      tmds_clk_p => tmds_clk_p,
      tmds_data_n(2 downto 0) => tmds_data_n(2 downto 0),
      tmds_data_p(2 downto 0) => tmds_data_p(2 downto 0),
      video_de => video_de,
      video_din(23 downto 0) => video_din(23 downto 0),
      video_hsync => video_hsync,
      video_vsync => video_vsync
    );
\slv_reg0[15]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0200"
    )
        port map (
      I0 => \slv_reg_wren__0\,
      I1 => axi_awaddr(3),
      I2 => axi_awaddr(2),
      I3 => s00_axi_wstrb(1),
      O => \slv_reg0[15]_i_1_n_0\
    );
\slv_reg0[23]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0200"
    )
        port map (
      I0 => \slv_reg_wren__0\,
      I1 => axi_awaddr(3),
      I2 => axi_awaddr(2),
      I3 => s00_axi_wstrb(2),
      O => \slv_reg0[23]_i_1_n_0\
    );
\slv_reg0[31]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0200"
    )
        port map (
      I0 => \slv_reg_wren__0\,
      I1 => axi_awaddr(3),
      I2 => axi_awaddr(2),
      I3 => s00_axi_wstrb(3),
      O => \slv_reg0[31]_i_1_n_0\
    );
\slv_reg0[7]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0200"
    )
        port map (
      I0 => \slv_reg_wren__0\,
      I1 => axi_awaddr(3),
      I2 => axi_awaddr(2),
      I3 => s00_axi_wstrb(0),
      O => \slv_reg0[7]_i_1_n_0\
    );
\slv_reg0_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[7]_i_1_n_0\,
      D => s00_axi_wdata(0),
      Q => slv_reg0(0),
      R => axi_awready_i_1_n_0
    );
\slv_reg0_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[15]_i_1_n_0\,
      D => s00_axi_wdata(10),
      Q => slv_reg0(10),
      R => axi_awready_i_1_n_0
    );
\slv_reg0_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[15]_i_1_n_0\,
      D => s00_axi_wdata(11),
      Q => slv_reg0(11),
      R => axi_awready_i_1_n_0
    );
\slv_reg0_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[15]_i_1_n_0\,
      D => s00_axi_wdata(12),
      Q => slv_reg0(12),
      R => axi_awready_i_1_n_0
    );
\slv_reg0_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[15]_i_1_n_0\,
      D => s00_axi_wdata(13),
      Q => slv_reg0(13),
      R => axi_awready_i_1_n_0
    );
\slv_reg0_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[15]_i_1_n_0\,
      D => s00_axi_wdata(14),
      Q => slv_reg0(14),
      R => axi_awready_i_1_n_0
    );
\slv_reg0_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[15]_i_1_n_0\,
      D => s00_axi_wdata(15),
      Q => slv_reg0(15),
      R => axi_awready_i_1_n_0
    );
\slv_reg0_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[23]_i_1_n_0\,
      D => s00_axi_wdata(16),
      Q => slv_reg0(16),
      R => axi_awready_i_1_n_0
    );
\slv_reg0_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[23]_i_1_n_0\,
      D => s00_axi_wdata(17),
      Q => slv_reg0(17),
      R => axi_awready_i_1_n_0
    );
\slv_reg0_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[23]_i_1_n_0\,
      D => s00_axi_wdata(18),
      Q => slv_reg0(18),
      R => axi_awready_i_1_n_0
    );
\slv_reg0_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[23]_i_1_n_0\,
      D => s00_axi_wdata(19),
      Q => slv_reg0(19),
      R => axi_awready_i_1_n_0
    );
\slv_reg0_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[7]_i_1_n_0\,
      D => s00_axi_wdata(1),
      Q => slv_reg0(1),
      R => axi_awready_i_1_n_0
    );
\slv_reg0_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[23]_i_1_n_0\,
      D => s00_axi_wdata(20),
      Q => slv_reg0(20),
      R => axi_awready_i_1_n_0
    );
\slv_reg0_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[23]_i_1_n_0\,
      D => s00_axi_wdata(21),
      Q => slv_reg0(21),
      R => axi_awready_i_1_n_0
    );
\slv_reg0_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[23]_i_1_n_0\,
      D => s00_axi_wdata(22),
      Q => slv_reg0(22),
      R => axi_awready_i_1_n_0
    );
\slv_reg0_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[23]_i_1_n_0\,
      D => s00_axi_wdata(23),
      Q => slv_reg0(23),
      R => axi_awready_i_1_n_0
    );
\slv_reg0_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[31]_i_1_n_0\,
      D => s00_axi_wdata(24),
      Q => slv_reg0(24),
      R => axi_awready_i_1_n_0
    );
\slv_reg0_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[31]_i_1_n_0\,
      D => s00_axi_wdata(25),
      Q => slv_reg0(25),
      R => axi_awready_i_1_n_0
    );
\slv_reg0_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[31]_i_1_n_0\,
      D => s00_axi_wdata(26),
      Q => slv_reg0(26),
      R => axi_awready_i_1_n_0
    );
\slv_reg0_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[31]_i_1_n_0\,
      D => s00_axi_wdata(27),
      Q => slv_reg0(27),
      R => axi_awready_i_1_n_0
    );
\slv_reg0_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[31]_i_1_n_0\,
      D => s00_axi_wdata(28),
      Q => slv_reg0(28),
      R => axi_awready_i_1_n_0
    );
\slv_reg0_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[31]_i_1_n_0\,
      D => s00_axi_wdata(29),
      Q => slv_reg0(29),
      R => axi_awready_i_1_n_0
    );
\slv_reg0_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[7]_i_1_n_0\,
      D => s00_axi_wdata(2),
      Q => slv_reg0(2),
      R => axi_awready_i_1_n_0
    );
\slv_reg0_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[31]_i_1_n_0\,
      D => s00_axi_wdata(30),
      Q => slv_reg0(30),
      R => axi_awready_i_1_n_0
    );
\slv_reg0_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[31]_i_1_n_0\,
      D => s00_axi_wdata(31),
      Q => slv_reg0(31),
      R => axi_awready_i_1_n_0
    );
\slv_reg0_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[7]_i_1_n_0\,
      D => s00_axi_wdata(3),
      Q => slv_reg0(3),
      R => axi_awready_i_1_n_0
    );
\slv_reg0_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[7]_i_1_n_0\,
      D => s00_axi_wdata(4),
      Q => slv_reg0(4),
      R => axi_awready_i_1_n_0
    );
\slv_reg0_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[7]_i_1_n_0\,
      D => s00_axi_wdata(5),
      Q => slv_reg0(5),
      R => axi_awready_i_1_n_0
    );
\slv_reg0_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[7]_i_1_n_0\,
      D => s00_axi_wdata(6),
      Q => slv_reg0(6),
      R => axi_awready_i_1_n_0
    );
\slv_reg0_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[7]_i_1_n_0\,
      D => s00_axi_wdata(7),
      Q => slv_reg0(7),
      R => axi_awready_i_1_n_0
    );
\slv_reg0_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[15]_i_1_n_0\,
      D => s00_axi_wdata(8),
      Q => slv_reg0(8),
      R => axi_awready_i_1_n_0
    );
\slv_reg0_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg0[15]_i_1_n_0\,
      D => s00_axi_wdata(9),
      Q => slv_reg0(9),
      R => axi_awready_i_1_n_0
    );
\slv_reg1[15]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2000"
    )
        port map (
      I0 => \slv_reg_wren__0\,
      I1 => axi_awaddr(3),
      I2 => s00_axi_wstrb(1),
      I3 => axi_awaddr(2),
      O => \slv_reg1[15]_i_1_n_0\
    );
\slv_reg1[23]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2000"
    )
        port map (
      I0 => \slv_reg_wren__0\,
      I1 => axi_awaddr(3),
      I2 => s00_axi_wstrb(2),
      I3 => axi_awaddr(2),
      O => \slv_reg1[23]_i_1_n_0\
    );
\slv_reg1[31]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2000"
    )
        port map (
      I0 => \slv_reg_wren__0\,
      I1 => axi_awaddr(3),
      I2 => s00_axi_wstrb(3),
      I3 => axi_awaddr(2),
      O => \slv_reg1[31]_i_1_n_0\
    );
\slv_reg1[7]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"2000"
    )
        port map (
      I0 => \slv_reg_wren__0\,
      I1 => axi_awaddr(3),
      I2 => s00_axi_wstrb(0),
      I3 => axi_awaddr(2),
      O => \slv_reg1[7]_i_1_n_0\
    );
\slv_reg1_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg1[7]_i_1_n_0\,
      D => s00_axi_wdata(0),
      Q => slv_reg1(0),
      R => axi_awready_i_1_n_0
    );
\slv_reg1_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg1[15]_i_1_n_0\,
      D => s00_axi_wdata(10),
      Q => slv_reg1(10),
      R => axi_awready_i_1_n_0
    );
\slv_reg1_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg1[15]_i_1_n_0\,
      D => s00_axi_wdata(11),
      Q => slv_reg1(11),
      R => axi_awready_i_1_n_0
    );
\slv_reg1_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg1[15]_i_1_n_0\,
      D => s00_axi_wdata(12),
      Q => slv_reg1(12),
      R => axi_awready_i_1_n_0
    );
\slv_reg1_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg1[15]_i_1_n_0\,
      D => s00_axi_wdata(13),
      Q => slv_reg1(13),
      R => axi_awready_i_1_n_0
    );
\slv_reg1_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg1[15]_i_1_n_0\,
      D => s00_axi_wdata(14),
      Q => slv_reg1(14),
      R => axi_awready_i_1_n_0
    );
\slv_reg1_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg1[15]_i_1_n_0\,
      D => s00_axi_wdata(15),
      Q => slv_reg1(15),
      R => axi_awready_i_1_n_0
    );
\slv_reg1_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg1[23]_i_1_n_0\,
      D => s00_axi_wdata(16),
      Q => slv_reg1(16),
      R => axi_awready_i_1_n_0
    );
\slv_reg1_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg1[23]_i_1_n_0\,
      D => s00_axi_wdata(17),
      Q => slv_reg1(17),
      R => axi_awready_i_1_n_0
    );
\slv_reg1_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg1[23]_i_1_n_0\,
      D => s00_axi_wdata(18),
      Q => slv_reg1(18),
      R => axi_awready_i_1_n_0
    );
\slv_reg1_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg1[23]_i_1_n_0\,
      D => s00_axi_wdata(19),
      Q => slv_reg1(19),
      R => axi_awready_i_1_n_0
    );
\slv_reg1_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg1[7]_i_1_n_0\,
      D => s00_axi_wdata(1),
      Q => slv_reg1(1),
      R => axi_awready_i_1_n_0
    );
\slv_reg1_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg1[23]_i_1_n_0\,
      D => s00_axi_wdata(20),
      Q => slv_reg1(20),
      R => axi_awready_i_1_n_0
    );
\slv_reg1_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg1[23]_i_1_n_0\,
      D => s00_axi_wdata(21),
      Q => slv_reg1(21),
      R => axi_awready_i_1_n_0
    );
\slv_reg1_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg1[23]_i_1_n_0\,
      D => s00_axi_wdata(22),
      Q => slv_reg1(22),
      R => axi_awready_i_1_n_0
    );
\slv_reg1_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg1[23]_i_1_n_0\,
      D => s00_axi_wdata(23),
      Q => slv_reg1(23),
      R => axi_awready_i_1_n_0
    );
\slv_reg1_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg1[31]_i_1_n_0\,
      D => s00_axi_wdata(24),
      Q => slv_reg1(24),
      R => axi_awready_i_1_n_0
    );
\slv_reg1_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg1[31]_i_1_n_0\,
      D => s00_axi_wdata(25),
      Q => slv_reg1(25),
      R => axi_awready_i_1_n_0
    );
\slv_reg1_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg1[31]_i_1_n_0\,
      D => s00_axi_wdata(26),
      Q => slv_reg1(26),
      R => axi_awready_i_1_n_0
    );
\slv_reg1_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg1[31]_i_1_n_0\,
      D => s00_axi_wdata(27),
      Q => slv_reg1(27),
      R => axi_awready_i_1_n_0
    );
\slv_reg1_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg1[31]_i_1_n_0\,
      D => s00_axi_wdata(28),
      Q => slv_reg1(28),
      R => axi_awready_i_1_n_0
    );
\slv_reg1_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg1[31]_i_1_n_0\,
      D => s00_axi_wdata(29),
      Q => slv_reg1(29),
      R => axi_awready_i_1_n_0
    );
\slv_reg1_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg1[7]_i_1_n_0\,
      D => s00_axi_wdata(2),
      Q => slv_reg1(2),
      R => axi_awready_i_1_n_0
    );
\slv_reg1_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg1[31]_i_1_n_0\,
      D => s00_axi_wdata(30),
      Q => slv_reg1(30),
      R => axi_awready_i_1_n_0
    );
\slv_reg1_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg1[31]_i_1_n_0\,
      D => s00_axi_wdata(31),
      Q => slv_reg1(31),
      R => axi_awready_i_1_n_0
    );
\slv_reg1_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg1[7]_i_1_n_0\,
      D => s00_axi_wdata(3),
      Q => slv_reg1(3),
      R => axi_awready_i_1_n_0
    );
\slv_reg1_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg1[7]_i_1_n_0\,
      D => s00_axi_wdata(4),
      Q => slv_reg1(4),
      R => axi_awready_i_1_n_0
    );
\slv_reg1_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg1[7]_i_1_n_0\,
      D => s00_axi_wdata(5),
      Q => slv_reg1(5),
      R => axi_awready_i_1_n_0
    );
\slv_reg1_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg1[7]_i_1_n_0\,
      D => s00_axi_wdata(6),
      Q => slv_reg1(6),
      R => axi_awready_i_1_n_0
    );
\slv_reg1_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg1[7]_i_1_n_0\,
      D => s00_axi_wdata(7),
      Q => slv_reg1(7),
      R => axi_awready_i_1_n_0
    );
\slv_reg1_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg1[15]_i_1_n_0\,
      D => s00_axi_wdata(8),
      Q => slv_reg1(8),
      R => axi_awready_i_1_n_0
    );
\slv_reg1_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg1[15]_i_1_n_0\,
      D => s00_axi_wdata(9),
      Q => slv_reg1(9),
      R => axi_awready_i_1_n_0
    );
\slv_reg2[15]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0080"
    )
        port map (
      I0 => \slv_reg_wren__0\,
      I1 => axi_awaddr(3),
      I2 => s00_axi_wstrb(1),
      I3 => axi_awaddr(2),
      O => \slv_reg2[15]_i_1_n_0\
    );
\slv_reg2[23]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0080"
    )
        port map (
      I0 => \slv_reg_wren__0\,
      I1 => axi_awaddr(3),
      I2 => s00_axi_wstrb(2),
      I3 => axi_awaddr(2),
      O => \slv_reg2[23]_i_1_n_0\
    );
\slv_reg2[31]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0080"
    )
        port map (
      I0 => \slv_reg_wren__0\,
      I1 => axi_awaddr(3),
      I2 => s00_axi_wstrb(3),
      I3 => axi_awaddr(2),
      O => \slv_reg2[31]_i_1_n_0\
    );
\slv_reg2[7]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"0080"
    )
        port map (
      I0 => \slv_reg_wren__0\,
      I1 => axi_awaddr(3),
      I2 => s00_axi_wstrb(0),
      I3 => axi_awaddr(2),
      O => \slv_reg2[7]_i_1_n_0\
    );
\slv_reg2_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg2[7]_i_1_n_0\,
      D => s00_axi_wdata(0),
      Q => slv_reg2(0),
      R => axi_awready_i_1_n_0
    );
\slv_reg2_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg2[15]_i_1_n_0\,
      D => s00_axi_wdata(10),
      Q => slv_reg2(10),
      R => axi_awready_i_1_n_0
    );
\slv_reg2_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg2[15]_i_1_n_0\,
      D => s00_axi_wdata(11),
      Q => slv_reg2(11),
      R => axi_awready_i_1_n_0
    );
\slv_reg2_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg2[15]_i_1_n_0\,
      D => s00_axi_wdata(12),
      Q => slv_reg2(12),
      R => axi_awready_i_1_n_0
    );
\slv_reg2_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg2[15]_i_1_n_0\,
      D => s00_axi_wdata(13),
      Q => slv_reg2(13),
      R => axi_awready_i_1_n_0
    );
\slv_reg2_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg2[15]_i_1_n_0\,
      D => s00_axi_wdata(14),
      Q => slv_reg2(14),
      R => axi_awready_i_1_n_0
    );
\slv_reg2_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg2[15]_i_1_n_0\,
      D => s00_axi_wdata(15),
      Q => slv_reg2(15),
      R => axi_awready_i_1_n_0
    );
\slv_reg2_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg2[23]_i_1_n_0\,
      D => s00_axi_wdata(16),
      Q => slv_reg2(16),
      R => axi_awready_i_1_n_0
    );
\slv_reg2_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg2[23]_i_1_n_0\,
      D => s00_axi_wdata(17),
      Q => slv_reg2(17),
      R => axi_awready_i_1_n_0
    );
\slv_reg2_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg2[23]_i_1_n_0\,
      D => s00_axi_wdata(18),
      Q => slv_reg2(18),
      R => axi_awready_i_1_n_0
    );
\slv_reg2_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg2[23]_i_1_n_0\,
      D => s00_axi_wdata(19),
      Q => slv_reg2(19),
      R => axi_awready_i_1_n_0
    );
\slv_reg2_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg2[7]_i_1_n_0\,
      D => s00_axi_wdata(1),
      Q => slv_reg2(1),
      R => axi_awready_i_1_n_0
    );
\slv_reg2_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg2[23]_i_1_n_0\,
      D => s00_axi_wdata(20),
      Q => slv_reg2(20),
      R => axi_awready_i_1_n_0
    );
\slv_reg2_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg2[23]_i_1_n_0\,
      D => s00_axi_wdata(21),
      Q => slv_reg2(21),
      R => axi_awready_i_1_n_0
    );
\slv_reg2_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg2[23]_i_1_n_0\,
      D => s00_axi_wdata(22),
      Q => slv_reg2(22),
      R => axi_awready_i_1_n_0
    );
\slv_reg2_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg2[23]_i_1_n_0\,
      D => s00_axi_wdata(23),
      Q => slv_reg2(23),
      R => axi_awready_i_1_n_0
    );
\slv_reg2_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg2[31]_i_1_n_0\,
      D => s00_axi_wdata(24),
      Q => slv_reg2(24),
      R => axi_awready_i_1_n_0
    );
\slv_reg2_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg2[31]_i_1_n_0\,
      D => s00_axi_wdata(25),
      Q => slv_reg2(25),
      R => axi_awready_i_1_n_0
    );
\slv_reg2_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg2[31]_i_1_n_0\,
      D => s00_axi_wdata(26),
      Q => slv_reg2(26),
      R => axi_awready_i_1_n_0
    );
\slv_reg2_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg2[31]_i_1_n_0\,
      D => s00_axi_wdata(27),
      Q => slv_reg2(27),
      R => axi_awready_i_1_n_0
    );
\slv_reg2_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg2[31]_i_1_n_0\,
      D => s00_axi_wdata(28),
      Q => slv_reg2(28),
      R => axi_awready_i_1_n_0
    );
\slv_reg2_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg2[31]_i_1_n_0\,
      D => s00_axi_wdata(29),
      Q => slv_reg2(29),
      R => axi_awready_i_1_n_0
    );
\slv_reg2_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg2[7]_i_1_n_0\,
      D => s00_axi_wdata(2),
      Q => slv_reg2(2),
      R => axi_awready_i_1_n_0
    );
\slv_reg2_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg2[31]_i_1_n_0\,
      D => s00_axi_wdata(30),
      Q => slv_reg2(30),
      R => axi_awready_i_1_n_0
    );
\slv_reg2_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg2[31]_i_1_n_0\,
      D => s00_axi_wdata(31),
      Q => slv_reg2(31),
      R => axi_awready_i_1_n_0
    );
\slv_reg2_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg2[7]_i_1_n_0\,
      D => s00_axi_wdata(3),
      Q => slv_reg2(3),
      R => axi_awready_i_1_n_0
    );
\slv_reg2_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg2[7]_i_1_n_0\,
      D => s00_axi_wdata(4),
      Q => slv_reg2(4),
      R => axi_awready_i_1_n_0
    );
\slv_reg2_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg2[7]_i_1_n_0\,
      D => s00_axi_wdata(5),
      Q => slv_reg2(5),
      R => axi_awready_i_1_n_0
    );
\slv_reg2_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg2[7]_i_1_n_0\,
      D => s00_axi_wdata(6),
      Q => slv_reg2(6),
      R => axi_awready_i_1_n_0
    );
\slv_reg2_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg2[7]_i_1_n_0\,
      D => s00_axi_wdata(7),
      Q => slv_reg2(7),
      R => axi_awready_i_1_n_0
    );
\slv_reg2_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg2[15]_i_1_n_0\,
      D => s00_axi_wdata(8),
      Q => slv_reg2(8),
      R => axi_awready_i_1_n_0
    );
\slv_reg2_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg2[15]_i_1_n_0\,
      D => s00_axi_wdata(9),
      Q => slv_reg2(9),
      R => axi_awready_i_1_n_0
    );
\slv_reg3[15]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8000"
    )
        port map (
      I0 => \slv_reg_wren__0\,
      I1 => s00_axi_wstrb(1),
      I2 => axi_awaddr(2),
      I3 => axi_awaddr(3),
      O => \slv_reg3[15]_i_1_n_0\
    );
\slv_reg3[23]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8000"
    )
        port map (
      I0 => \slv_reg_wren__0\,
      I1 => s00_axi_wstrb(2),
      I2 => axi_awaddr(2),
      I3 => axi_awaddr(3),
      O => \slv_reg3[23]_i_1_n_0\
    );
\slv_reg3[31]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8000"
    )
        port map (
      I0 => \slv_reg_wren__0\,
      I1 => s00_axi_wstrb(3),
      I2 => axi_awaddr(2),
      I3 => axi_awaddr(3),
      O => \slv_reg3[31]_i_1_n_0\
    );
\slv_reg3[31]_i_2\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8000"
    )
        port map (
      I0 => \^s_axi_wready\,
      I1 => \^s_axi_awready\,
      I2 => s00_axi_awvalid,
      I3 => s00_axi_wvalid,
      O => \slv_reg_wren__0\
    );
\slv_reg3[7]_i_1\: unisim.vcomponents.LUT4
    generic map(
      INIT => X"8000"
    )
        port map (
      I0 => \slv_reg_wren__0\,
      I1 => s00_axi_wstrb(0),
      I2 => axi_awaddr(2),
      I3 => axi_awaddr(3),
      O => \slv_reg3[7]_i_1_n_0\
    );
\slv_reg3_reg[0]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[7]_i_1_n_0\,
      D => s00_axi_wdata(0),
      Q => slv_reg3(0),
      R => axi_awready_i_1_n_0
    );
\slv_reg3_reg[10]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[15]_i_1_n_0\,
      D => s00_axi_wdata(10),
      Q => slv_reg3(10),
      R => axi_awready_i_1_n_0
    );
\slv_reg3_reg[11]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[15]_i_1_n_0\,
      D => s00_axi_wdata(11),
      Q => slv_reg3(11),
      R => axi_awready_i_1_n_0
    );
\slv_reg3_reg[12]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[15]_i_1_n_0\,
      D => s00_axi_wdata(12),
      Q => slv_reg3(12),
      R => axi_awready_i_1_n_0
    );
\slv_reg3_reg[13]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[15]_i_1_n_0\,
      D => s00_axi_wdata(13),
      Q => slv_reg3(13),
      R => axi_awready_i_1_n_0
    );
\slv_reg3_reg[14]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[15]_i_1_n_0\,
      D => s00_axi_wdata(14),
      Q => slv_reg3(14),
      R => axi_awready_i_1_n_0
    );
\slv_reg3_reg[15]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[15]_i_1_n_0\,
      D => s00_axi_wdata(15),
      Q => slv_reg3(15),
      R => axi_awready_i_1_n_0
    );
\slv_reg3_reg[16]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[23]_i_1_n_0\,
      D => s00_axi_wdata(16),
      Q => slv_reg3(16),
      R => axi_awready_i_1_n_0
    );
\slv_reg3_reg[17]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[23]_i_1_n_0\,
      D => s00_axi_wdata(17),
      Q => slv_reg3(17),
      R => axi_awready_i_1_n_0
    );
\slv_reg3_reg[18]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[23]_i_1_n_0\,
      D => s00_axi_wdata(18),
      Q => slv_reg3(18),
      R => axi_awready_i_1_n_0
    );
\slv_reg3_reg[19]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[23]_i_1_n_0\,
      D => s00_axi_wdata(19),
      Q => slv_reg3(19),
      R => axi_awready_i_1_n_0
    );
\slv_reg3_reg[1]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[7]_i_1_n_0\,
      D => s00_axi_wdata(1),
      Q => slv_reg3(1),
      R => axi_awready_i_1_n_0
    );
\slv_reg3_reg[20]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[23]_i_1_n_0\,
      D => s00_axi_wdata(20),
      Q => slv_reg3(20),
      R => axi_awready_i_1_n_0
    );
\slv_reg3_reg[21]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[23]_i_1_n_0\,
      D => s00_axi_wdata(21),
      Q => slv_reg3(21),
      R => axi_awready_i_1_n_0
    );
\slv_reg3_reg[22]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[23]_i_1_n_0\,
      D => s00_axi_wdata(22),
      Q => slv_reg3(22),
      R => axi_awready_i_1_n_0
    );
\slv_reg3_reg[23]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[23]_i_1_n_0\,
      D => s00_axi_wdata(23),
      Q => slv_reg3(23),
      R => axi_awready_i_1_n_0
    );
\slv_reg3_reg[24]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[31]_i_1_n_0\,
      D => s00_axi_wdata(24),
      Q => slv_reg3(24),
      R => axi_awready_i_1_n_0
    );
\slv_reg3_reg[25]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[31]_i_1_n_0\,
      D => s00_axi_wdata(25),
      Q => slv_reg3(25),
      R => axi_awready_i_1_n_0
    );
\slv_reg3_reg[26]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[31]_i_1_n_0\,
      D => s00_axi_wdata(26),
      Q => slv_reg3(26),
      R => axi_awready_i_1_n_0
    );
\slv_reg3_reg[27]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[31]_i_1_n_0\,
      D => s00_axi_wdata(27),
      Q => slv_reg3(27),
      R => axi_awready_i_1_n_0
    );
\slv_reg3_reg[28]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[31]_i_1_n_0\,
      D => s00_axi_wdata(28),
      Q => slv_reg3(28),
      R => axi_awready_i_1_n_0
    );
\slv_reg3_reg[29]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[31]_i_1_n_0\,
      D => s00_axi_wdata(29),
      Q => slv_reg3(29),
      R => axi_awready_i_1_n_0
    );
\slv_reg3_reg[2]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[7]_i_1_n_0\,
      D => s00_axi_wdata(2),
      Q => slv_reg3(2),
      R => axi_awready_i_1_n_0
    );
\slv_reg3_reg[30]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[31]_i_1_n_0\,
      D => s00_axi_wdata(30),
      Q => slv_reg3(30),
      R => axi_awready_i_1_n_0
    );
\slv_reg3_reg[31]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[31]_i_1_n_0\,
      D => s00_axi_wdata(31),
      Q => slv_reg3(31),
      R => axi_awready_i_1_n_0
    );
\slv_reg3_reg[3]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[7]_i_1_n_0\,
      D => s00_axi_wdata(3),
      Q => slv_reg3(3),
      R => axi_awready_i_1_n_0
    );
\slv_reg3_reg[4]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[7]_i_1_n_0\,
      D => s00_axi_wdata(4),
      Q => slv_reg3(4),
      R => axi_awready_i_1_n_0
    );
\slv_reg3_reg[5]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[7]_i_1_n_0\,
      D => s00_axi_wdata(5),
      Q => slv_reg3(5),
      R => axi_awready_i_1_n_0
    );
\slv_reg3_reg[6]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[7]_i_1_n_0\,
      D => s00_axi_wdata(6),
      Q => slv_reg3(6),
      R => axi_awready_i_1_n_0
    );
\slv_reg3_reg[7]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[7]_i_1_n_0\,
      D => s00_axi_wdata(7),
      Q => slv_reg3(7),
      R => axi_awready_i_1_n_0
    );
\slv_reg3_reg[8]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[15]_i_1_n_0\,
      D => s00_axi_wdata(8),
      Q => slv_reg3(8),
      R => axi_awready_i_1_n_0
    );
\slv_reg3_reg[9]\: unisim.vcomponents.FDRE
     port map (
      C => s00_axi_aclk,
      CE => \slv_reg3[15]_i_1_n_0\,
      D => s00_axi_wdata(9),
      Q => slv_reg3(9),
      R => axi_awready_i_1_n_0
    );
slv_reg_rden: unisim.vcomponents.LUT3
    generic map(
      INIT => X"20"
    )
        port map (
      I0 => s00_axi_arvalid,
      I1 => \^s00_axi_rvalid\,
      I2 => \^s_axi_arready\,
      O => \slv_reg_rden__0\
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_hdmi_transmitter_v1_0 is
  port (
    tmds_data_p : out STD_LOGIC_VECTOR ( 2 downto 0 );
    tmds_data_n : out STD_LOGIC_VECTOR ( 2 downto 0 );
    tmds_clk_p : out STD_LOGIC;
    tmds_clk_n : out STD_LOGIC;
    S_AXI_WREADY : out STD_LOGIC;
    S_AXI_AWREADY : out STD_LOGIC;
    S_AXI_ARREADY : out STD_LOGIC;
    s00_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_rvalid : out STD_LOGIC;
    s00_axi_bvalid : out STD_LOGIC;
    pclk_x5 : in STD_LOGIC;
    video_din : in STD_LOGIC_VECTOR ( 23 downto 0 );
    pclk : in STD_LOGIC;
    video_de : in STD_LOGIC;
    video_hsync : in STD_LOGIC;
    video_vsync : in STD_LOGIC;
    s00_axi_aclk : in STD_LOGIC;
    s00_axi_araddr : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_arvalid : in STD_LOGIC;
    s00_axi_awaddr : in STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_wvalid : in STD_LOGIC;
    s00_axi_awvalid : in STD_LOGIC;
    s00_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_aresetn : in STD_LOGIC;
    rst_n : in STD_LOGIC;
    s00_axi_bready : in STD_LOGIC;
    s00_axi_rready : in STD_LOGIC
  );
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_hdmi_transmitter_v1_0;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_hdmi_transmitter_v1_0 is
begin
hdmi_transmitter_v1_0_S00_AXI_inst: entity work.decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_hdmi_transmitter_v1_0_S00_AXI
     port map (
      S_AXI_ARREADY => S_AXI_ARREADY,
      S_AXI_AWREADY => S_AXI_AWREADY,
      S_AXI_WREADY => S_AXI_WREADY,
      pclk => pclk,
      pclk_x5 => pclk_x5,
      rst_n => rst_n,
      s00_axi_aclk => s00_axi_aclk,
      s00_axi_araddr(1 downto 0) => s00_axi_araddr(1 downto 0),
      s00_axi_aresetn => s00_axi_aresetn,
      s00_axi_arvalid => s00_axi_arvalid,
      s00_axi_awaddr(1 downto 0) => s00_axi_awaddr(1 downto 0),
      s00_axi_awvalid => s00_axi_awvalid,
      s00_axi_bready => s00_axi_bready,
      s00_axi_bvalid => s00_axi_bvalid,
      s00_axi_rdata(31 downto 0) => s00_axi_rdata(31 downto 0),
      s00_axi_rready => s00_axi_rready,
      s00_axi_rvalid => s00_axi_rvalid,
      s00_axi_wdata(31 downto 0) => s00_axi_wdata(31 downto 0),
      s00_axi_wstrb(3 downto 0) => s00_axi_wstrb(3 downto 0),
      s00_axi_wvalid => s00_axi_wvalid,
      tmds_clk_n => tmds_clk_n,
      tmds_clk_p => tmds_clk_p,
      tmds_data_n(2 downto 0) => tmds_data_n(2 downto 0),
      tmds_data_p(2 downto 0) => tmds_data_p(2 downto 0),
      video_de => video_de,
      video_din(23 downto 0) => video_din(23 downto 0),
      video_hsync => video_hsync,
      video_vsync => video_vsync
    );
end STRUCTURE;
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  port (
    pclk : in STD_LOGIC;
    pclk_x5 : in STD_LOGIC;
    rst_n : in STD_LOGIC;
    video_din : in STD_LOGIC_VECTOR ( 23 downto 0 );
    video_hsync : in STD_LOGIC;
    video_vsync : in STD_LOGIC;
    video_de : in STD_LOGIC;
    tmds_clk_p : out STD_LOGIC;
    tmds_clk_n : out STD_LOGIC;
    tmds_data_p : out STD_LOGIC_VECTOR ( 2 downto 0 );
    tmds_data_n : out STD_LOGIC_VECTOR ( 2 downto 0 );
    tmds_oen : out STD_LOGIC;
    s00_axi_awaddr : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_awprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_awvalid : in STD_LOGIC;
    s00_axi_awready : out STD_LOGIC;
    s00_axi_wdata : in STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_wstrb : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_wvalid : in STD_LOGIC;
    s00_axi_wready : out STD_LOGIC;
    s00_axi_bresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_bvalid : out STD_LOGIC;
    s00_axi_bready : in STD_LOGIC;
    s00_axi_araddr : in STD_LOGIC_VECTOR ( 3 downto 0 );
    s00_axi_arprot : in STD_LOGIC_VECTOR ( 2 downto 0 );
    s00_axi_arvalid : in STD_LOGIC;
    s00_axi_arready : out STD_LOGIC;
    s00_axi_rdata : out STD_LOGIC_VECTOR ( 31 downto 0 );
    s00_axi_rresp : out STD_LOGIC_VECTOR ( 1 downto 0 );
    s00_axi_rvalid : out STD_LOGIC;
    s00_axi_rready : in STD_LOGIC;
    s00_axi_aclk : in STD_LOGIC;
    s00_axi_aresetn : in STD_LOGIC
  );
  attribute NotValidForBitStream : boolean;
  attribute NotValidForBitStream of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is true;
  attribute CHECK_LICENSE_TYPE : string;
  attribute CHECK_LICENSE_TYPE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "zynq_hdmi_transmitter_0_0,hdmi_transmitter_v1_0,{}";
  attribute DowngradeIPIdentifiedWarnings : string;
  attribute DowngradeIPIdentifiedWarnings of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "yes";
  attribute X_CORE_INFO : string;
  attribute X_CORE_INFO of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix : entity is "hdmi_transmitter_v1_0,Vivado 2020.2";
end decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix;

architecture STRUCTURE of decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix is
  signal \<const0>\ : STD_LOGIC;
  signal \<const1>\ : STD_LOGIC;
  attribute X_INTERFACE_INFO : string;
  attribute X_INTERFACE_INFO of rst_n : signal is "xilinx.com:signal:reset:1.0 rst_n RST";
  attribute X_INTERFACE_PARAMETER : string;
  attribute X_INTERFACE_PARAMETER of rst_n : signal is "XIL_INTERFACENAME rst_n, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s00_axi_aclk : signal is "xilinx.com:signal:clock:1.0 S00_AXI_CLK CLK";
  attribute X_INTERFACE_PARAMETER of s00_axi_aclk : signal is "XIL_INTERFACENAME S00_AXI_CLK, ASSOCIATED_BUSIF S00_AXI, ASSOCIATED_RESET s00_axi_aresetn, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.000, CLK_DOMAIN zynq_processing_system7_0_0_FCLK_CLK0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s00_axi_aresetn : signal is "xilinx.com:signal:reset:1.0 S00_AXI_RST RST";
  attribute X_INTERFACE_PARAMETER of s00_axi_aresetn : signal is "XIL_INTERFACENAME S00_AXI_RST, POLARITY ACTIVE_LOW, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s00_axi_arready : signal is "xilinx.com:interface:aximm:1.0 S00_AXI ARREADY";
  attribute X_INTERFACE_INFO of s00_axi_arvalid : signal is "xilinx.com:interface:aximm:1.0 S00_AXI ARVALID";
  attribute X_INTERFACE_INFO of s00_axi_awready : signal is "xilinx.com:interface:aximm:1.0 S00_AXI AWREADY";
  attribute X_INTERFACE_INFO of s00_axi_awvalid : signal is "xilinx.com:interface:aximm:1.0 S00_AXI AWVALID";
  attribute X_INTERFACE_INFO of s00_axi_bready : signal is "xilinx.com:interface:aximm:1.0 S00_AXI BREADY";
  attribute X_INTERFACE_INFO of s00_axi_bvalid : signal is "xilinx.com:interface:aximm:1.0 S00_AXI BVALID";
  attribute X_INTERFACE_INFO of s00_axi_rready : signal is "xilinx.com:interface:aximm:1.0 S00_AXI RREADY";
  attribute X_INTERFACE_PARAMETER of s00_axi_rready : signal is "XIL_INTERFACENAME S00_AXI, WIZ_DATA_WIDTH 32, WIZ_NUM_REG 4, SUPPORTS_NARROW_BURST 0, DATA_WIDTH 32, PROTOCOL AXI4LITE, FREQ_HZ 100000000, ID_WIDTH 0, ADDR_WIDTH 4, AWUSER_WIDTH 0, ARUSER_WIDTH 0, WUSER_WIDTH 0, RUSER_WIDTH 0, BUSER_WIDTH 0, READ_WRITE_MODE READ_WRITE, HAS_BURST 0, HAS_LOCK 0, HAS_PROT 1, HAS_CACHE 0, HAS_QOS 0, HAS_REGION 0, HAS_WSTRB 1, HAS_BRESP 1, HAS_RRESP 1, NUM_READ_OUTSTANDING 2, NUM_WRITE_OUTSTANDING 2, MAX_BURST_LENGTH 1, PHASE 0.000, CLK_DOMAIN zynq_processing_system7_0_0_FCLK_CLK0, NUM_READ_THREADS 1, NUM_WRITE_THREADS 1, RUSER_BITS_PER_BYTE 0, WUSER_BITS_PER_BYTE 0, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s00_axi_rvalid : signal is "xilinx.com:interface:aximm:1.0 S00_AXI RVALID";
  attribute X_INTERFACE_INFO of s00_axi_wready : signal is "xilinx.com:interface:aximm:1.0 S00_AXI WREADY";
  attribute X_INTERFACE_INFO of s00_axi_wvalid : signal is "xilinx.com:interface:aximm:1.0 S00_AXI WVALID";
  attribute X_INTERFACE_INFO of tmds_clk_n : signal is "xilinx.com:signal:clock:1.0 tmds_clk_n CLK";
  attribute X_INTERFACE_PARAMETER of tmds_clk_n : signal is "XIL_INTERFACENAME tmds_clk_n, ASSOCIATED_RESET rst_n, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.000, CLK_DOMAIN zynq_hdmi_transmitter_0_0_tmds_clk_n, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of tmds_clk_p : signal is "xilinx.com:signal:clock:1.0 tmds_clk_p CLK";
  attribute X_INTERFACE_PARAMETER of tmds_clk_p : signal is "XIL_INTERFACENAME tmds_clk_p, FREQ_HZ 100000000, FREQ_TOLERANCE_HZ 0, PHASE 0.000, CLK_DOMAIN zynq_hdmi_transmitter_0_0_tmds_clk_p, INSERT_VIP 0";
  attribute X_INTERFACE_INFO of s00_axi_araddr : signal is "xilinx.com:interface:aximm:1.0 S00_AXI ARADDR";
  attribute X_INTERFACE_INFO of s00_axi_arprot : signal is "xilinx.com:interface:aximm:1.0 S00_AXI ARPROT";
  attribute X_INTERFACE_INFO of s00_axi_awaddr : signal is "xilinx.com:interface:aximm:1.0 S00_AXI AWADDR";
  attribute X_INTERFACE_INFO of s00_axi_awprot : signal is "xilinx.com:interface:aximm:1.0 S00_AXI AWPROT";
  attribute X_INTERFACE_INFO of s00_axi_bresp : signal is "xilinx.com:interface:aximm:1.0 S00_AXI BRESP";
  attribute X_INTERFACE_INFO of s00_axi_rdata : signal is "xilinx.com:interface:aximm:1.0 S00_AXI RDATA";
  attribute X_INTERFACE_INFO of s00_axi_rresp : signal is "xilinx.com:interface:aximm:1.0 S00_AXI RRESP";
  attribute X_INTERFACE_INFO of s00_axi_wdata : signal is "xilinx.com:interface:aximm:1.0 S00_AXI WDATA";
  attribute X_INTERFACE_INFO of s00_axi_wstrb : signal is "xilinx.com:interface:aximm:1.0 S00_AXI WSTRB";
begin
  s00_axi_bresp(1) <= \<const0>\;
  s00_axi_bresp(0) <= \<const0>\;
  s00_axi_rresp(1) <= \<const0>\;
  s00_axi_rresp(0) <= \<const0>\;
  tmds_oen <= \<const1>\;
GND: unisim.vcomponents.GND
     port map (
      G => \<const0>\
    );
VCC: unisim.vcomponents.VCC
     port map (
      P => \<const1>\
    );
inst: entity work.decalper_eb_ot_sdeen_pot_pi_dehcac_xnilix_hdmi_transmitter_v1_0
     port map (
      S_AXI_ARREADY => s00_axi_arready,
      S_AXI_AWREADY => s00_axi_awready,
      S_AXI_WREADY => s00_axi_wready,
      pclk => pclk,
      pclk_x5 => pclk_x5,
      rst_n => rst_n,
      s00_axi_aclk => s00_axi_aclk,
      s00_axi_araddr(1 downto 0) => s00_axi_araddr(3 downto 2),
      s00_axi_aresetn => s00_axi_aresetn,
      s00_axi_arvalid => s00_axi_arvalid,
      s00_axi_awaddr(1 downto 0) => s00_axi_awaddr(3 downto 2),
      s00_axi_awvalid => s00_axi_awvalid,
      s00_axi_bready => s00_axi_bready,
      s00_axi_bvalid => s00_axi_bvalid,
      s00_axi_rdata(31 downto 0) => s00_axi_rdata(31 downto 0),
      s00_axi_rready => s00_axi_rready,
      s00_axi_rvalid => s00_axi_rvalid,
      s00_axi_wdata(31 downto 0) => s00_axi_wdata(31 downto 0),
      s00_axi_wstrb(3 downto 0) => s00_axi_wstrb(3 downto 0),
      s00_axi_wvalid => s00_axi_wvalid,
      tmds_clk_n => tmds_clk_n,
      tmds_clk_p => tmds_clk_p,
      tmds_data_n(2 downto 0) => tmds_data_n(2 downto 0),
      tmds_data_p(2 downto 0) => tmds_data_p(2 downto 0),
      video_de => video_de,
      video_din(23 downto 0) => video_din(23 downto 0),
      video_hsync => video_hsync,
      video_vsync => video_vsync
    );
end STRUCTURE;
