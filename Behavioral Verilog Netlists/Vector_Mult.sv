module Vector_Mult
  #(//parameter FEATURE_ROWS = 6,
    //parameter WEIGHT_COLS = 3,
    parameter DOT_PROD_WIDTH = 16,
    parameter ADDRESS_WIDTH = 13,
    //parameter WEIGHT_WIDTH = $clog2(WEIGHT_COLS),
    //parameter FEATURE_WIDTH = $clog2(FEATURE_ROWS)
    parameter WEIGHT_FEATURE_WIDTH = 5,
    parameter WEIGHT_FEATURE_ROWS = 96
)

(
  input wire [WEIGHT_FEATURE_WIDTH-1:0] feature_col_in [0:WEIGHT_FEATURE_ROWS-1],
  input logic [WEIGHT_FEATURE_WIDTH-1:0] weight_col_in [0:WEIGHT_FEATURE_ROWS-1],
  
  output logic [DOT_PROD_WIDTH - 1:0] fm_wm_in
);

  logic [DOT_PROD_WIDTH-1:0] temp [0:WEIGHT_FEATURE_ROWS-1];
  logic [DOT_PROD_WIDTH-1:0] adder [0:7];

  always_comb begin
    for(int i = 0; i < WEIGHT_FEATURE_ROWS; i = i + 1) begin
      temp[i] = feature_col_in[i] * weight_col_in[i];
    end
  end 

  assign adder[0] = temp[0] + temp[1] + temp[2] + temp[3] + temp[4] + temp[5] + temp[6] + temp[7] + temp[8] + temp[9] + temp[10] + temp[11];
  assign adder[1] = temp[12] + temp[13] + temp[14] + temp[15] + temp[16] + temp[17] + temp[18] + temp[19] + temp[20] + temp[21] + temp[22] + temp[23];
  assign adder[2] = temp[24] + temp[25] + temp[26] + temp[27] + temp[28] + temp[29] + temp[30] + temp[31] + temp[32] + temp[33] + temp[34] + temp[35];
  assign adder[3] = temp[36] + temp[37] + temp[38] + temp[39] + temp[40] + temp[41] + temp[42] + temp[43] + temp[44] + temp[45] + temp[46] + temp[47];
  assign adder[4] = temp[48] + temp[49] + temp[50] + temp[51] + temp[52] + temp[53] + temp[54] + temp[55] + temp[56] + temp[57] + temp[58] + temp[59];
  assign adder[5] = temp[60] + temp[61] + temp[62] + temp[63] + temp[64] + temp[65] + temp[66] + temp[67] + temp[68] + temp[69] + temp[70] + temp[71];
  assign adder[6] = temp[72] + temp[73] + temp[74] + temp[75] + temp[76] + temp[77] + temp[78] + temp[79] + temp[80] + temp[81] + temp[82] + temp[83];
  assign adder[7] = temp[84] + temp[85] + temp[86] + temp[87] + temp[88] + temp[89] + temp[90] + temp[91] + temp[92] + temp[93] + temp[94] + temp[95];
  assign fm_wm_in = adder[0] + adder[1] + adder[2] + adder[3] + adder[4] + adder[5] + adder[6] + adder[7];

endmodule