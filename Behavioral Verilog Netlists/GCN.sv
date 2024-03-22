
module GCN
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
  input logic [COO_BW - 1:0] coo_in [0:1], //row 0 and row 1 of the COO Stream

  output logic [COO_BW - 1:0] coo_address, // The column of the COO Matrix 
  output logic [ADDRESS_WIDTH-1:0] read_address, // The Address to read the FM and WM Data
  output logic enable_read, // Enabling the Read of the FM and WM Data
  output logic done, // Done signal indicating that all the calculations have been completed
  output logic [MAX_ADDRESS_WIDTH - 1:0] max_addi_answer [0:FEATURE_ROWS - 1] // The answer to the argmax and matrix multiplication 
); 

// wire [COUNTER_WEIGHT_WIDTH-1:0] w_cnt;
// wire [COUNTER_FEATURE_WIDTH-1:0] f_cnt;
// wire fm_wm_write_en;
// wire en_write;
// wire en_pad;
// wire en_weight_ctr;
// wire en_feature_ctr;
// wire read_f_w;
// wire transform_done;

// wire [WEIGHT_WIDTH-1:0] w_col_out [0:WEIGHT_ROWS-1];
// wire wr_en;

// wire [DOT_PROD_WIDTH-1:0] fm_wm_prod;
// wire [DOT_PROD_WIDTH-1:0] fm_wm_out [0:WEIGHT_COLS-1];

// wire [COUNTER_FEATURE_WIDTH-1] read_fm_wm_row;
// wire [COO_WIDTH-1:0] read_fm_wm_adj_row;
// wire [COO_WIDTH-1:0] write_fm_wm_adj_row;

// wire done_comb;

// wire ctr_out;
// wire [COO_BW-1:0] done_ctr;

// wire [DOT_PROD_WIDTH-1:0] fm_wm_adj_output [0:WEIGHT_COLS-1];

// wire [MAX_ADDRESS_WIDTH - 1:0] max_addi [0:FEATURE_ROWS - 1];

// assign wr_en = 1;
  wire wr_en;

  // wire [WEIGHT_WIDTH-1:0] w_col_out [0:WEIGHT_ROWS-1];
  // //wire wr_en;
  // //wire [1:0] read_fm_wm_row;
  // wire [DOT_PROD_WIDTH-1:0] fm_wm_prod;
  // wire [DOT_PROD_WIDTH-1:0] fm_wm_row_out [0:WEIGHT_COLS-1];

  // wire transform_done;

  wire [DOT_PROD_WIDTH-1:0] fm_wm_adj_row_out [0:WEIGHT_COLS-1];

  wire done_comb;

  wire [COO_BW-1:0] read_fm_wm_adj_row;
  //wire [COO_BW-1:0] write_fm_wm_adj_row;

  //wire done_comb;

  wire ctr_out;
  wire [COO_BW-1:0] done_ctr;

  wire [COO_BW-1:0] read_argmax;
  //wire [DOT_PROD_WIDTH-1:0] fm_wm_adj_output [0:WEIGHT_COLS-1];

  assign wr_en = 1;

Combination combine(
  .clk (clk),
  .reset (reset),
  .start (start),
  .data_in (data_in),
  .coo_in (coo_in),
  .read_argmax (read_argmax),

  .coo_address (coo_address),
  .read_address (read_address),
  .enable_read (enable_read),
  .done_comb (done_comb),
  .fm_wm_adj_row_out (fm_wm_adj_row_out)
);

Argmax argmax (
  .clk (clk),
  .reset (reset),
  .done_comb (done_comb),
  .adj_fm_wm_in (fm_wm_adj_row_out),

  .max_addi_answer (max_addi_answer),
  .read_row (read_argmax),
  .done (done)
);

endmodule
