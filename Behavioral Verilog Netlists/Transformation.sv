
module Transformation
  #(parameter FEATURE_COLS = 96,
    parameter WEIGHT_ROWS = 96,
    parameter FEATURE_ROWS = 6,
    parameter WEIGHT_COLS = 3,
    parameter FEATURE_WIDTH = 5,
    parameter WEIGHT_WIDTH = 5,
    parameter DOT_PROD_WIDTH = 16,
    parameter ADDRESS_WIDTH = 13,
    parameter COUNTER_WEIGHT_WIDTH = $clog2(WEIGHT_COLS),
    parameter COUNTER_FEATURE_WIDTH = $clog2(FEATURE_ROWS),
    parameter MAX_ADDRESS_WIDTH = 2,
    parameter NUM_OF_NODES = 6,			 
    parameter COO_NUM_OF_COLS = 6,			
    parameter COO_NUM_OF_ROWS = 2,			
    parameter COO_BW = $clog2(COO_NUM_OF_COLS)	
)
(
  input logic clk,	// Clock
  input logic reset,	// Reset 
  input logic start,
  input logic [WEIGHT_WIDTH-1:0] data_in [0:WEIGHT_ROWS-1], //FM and WM Data
  input logic [COUNTER_FEATURE_WIDTH-1:0] read_fm_wm_row,
  //input logic [COO_BW - 1:0] coo_in [0:1], //row 0 and row 1 of the COO Stream

  //output logic [COO_BW - 1:0] coo_address, // The column of the COO Matrix 
  output logic [ADDRESS_WIDTH-1:0] read_address, // The Address to read the FM and WM Data
  output logic enable_read, // Enabling the Read of the FM and WM Data
  output logic done, // Done signal indicating that all the calculations have been completed
  output logic [DOT_PROD_WIDTH-1:0] FM_WM_ROW [0:WEIGHT_COLS-1]
  //output logic [MAX_ADDRESS_WIDTH - 1:0] max_addi_answer [0:FEATURE_ROWS - 1] // The answer to the argmax and matrix multiplication 
); 
    wire [COUNTER_WEIGHT_WIDTH-1:0] w_cnt;
    wire [COUNTER_FEATURE_WIDTH-1:0] f_cnt;
    //wire fm_wm_write_en;
    //wire en_write;
    wire en_pad;
    wire en_weight_ctr;
    wire en_feature_ctr;
    wire read_f_w;
    wire transform_done;

    //wire wr_en;

    wire [WEIGHT_WIDTH-1:0] w_col_out [0:WEIGHT_ROWS-1];
    //wire wr_en;
    wire [DOT_PROD_WIDTH-1:0] fm_wm_prod;
    //wire [DOT_PROD_WIDTH-1:0] fm_wm_out [0:WEIGHT_COLS-1];

Transformation_FSM FSM_BLOCK (
  .clk (clk),
  .reset (reset),
  .weight_count (w_cnt),
  .feature_count (f_cnt),
  .start (start),

  //.enable_write_fm_wm_prod (fm_wm_write_en),
  .enable_read (enable_read),
  //.enable_write (en_write),
  .enable_scratch_pad (en_pad),
  .enable_weight_counter (en_weight_ctr),
  .enable_feature_counter (en_feature_ctr),
  .read_feature_or_weight (read_f_w),
  .done (done)
);

Counter ctr (
  .clk (clk),
  .reset (reset),
  .enable_weight_counter (en_weight_ctr),
  .enable_feature_counter (en_feature_ctr),
  .read_feature_or_weight (read_f_w),

  .read_address (read_address),
  .weight_count (w_cnt),
  .feature_count (f_cnt)
);

Scratch_Pad pad (
  .clk (clk),
  .reset (reset),
  .write_enable (en_pad),
  .weight_col_in (data_in),
  
  .weight_col_out (w_col_out)
);

Vector_Mult vec_mul (
  .feature_col_in (data_in),
  .weight_col_in (w_col_out),

  .fm_wm_in (fm_wm_prod)
);

//assign read_fm_wm_row = 0;
//assign wr_en = 1;

Matrix_FM_WM_Memory fm_wm_mem (
  .clk (clk),
  .rst (reset),
  .write_row (f_cnt),
  .write_col (w_cnt),
  .read_row (read_fm_wm_row),
  //.wr_en (wr_en), //??? why is it always 0?
  .fm_wm_in (fm_wm_prod),

  .fm_wm_row_out (FM_WM_ROW)
);

endmodule