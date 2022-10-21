// Copyright 1986-2022 Xilinx, Inc. All Rights Reserved.

// This empty module with port declaration file causes synthesis tools to infer a black box for IP.
// Please paste the declaration into a Verilog source file or add the file as an additional source.
module VGA_Controller(clk, rst, RED, GREEN, BLUE, HS, VS);
  input clk;
  input rst;
  output [3:0]RED;
  output [3:0]GREEN;
  output [3:0]BLUE;
  output HS;
  output VS;
endmodule
