// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2022.1 (win64) Build 3526262 Mon Apr 18 15:48:16 MDT 2022
// Date        : Fri Oct 21 23:32:44 2022
// Host        : DESKTOP-6LNBR6U running 64-bit major release  (build 9200)
// Command     : write_verilog -force -mode synth_stub -rename_top BRAM_img1 -prefix
//               BRAM_img1_ BRAM_img1_stub.v
// Design      : BRAM_img1
// Purpose     : Stub declaration of top-level module interface
// Device      : xc7a35tcpg236-1
// --------------------------------------------------------------------------------

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// The synthesis directives are for Synopsys Synplify support to prevent IO buffer insertion.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
(* x_core_info = "blk_mem_gen_v8_4_5,Vivado 2022.1" *)
module BRAM_img1(clka, wea, addra, dina, douta)
/* synthesis syn_black_box black_box_pad_pin="clka,wea[0:0],addra[18:0],dina[4:0],douta[4:0]" */;
  input clka;
  input [0:0]wea;
  input [18:0]addra;
  input [4:0]dina;
  output [4:0]douta;
endmodule
