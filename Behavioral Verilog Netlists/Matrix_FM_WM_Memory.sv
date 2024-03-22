module Matrix_FM_WM_Memory 
  #(parameter FEATURE_ROWS = 6,
    parameter WEIGHT_COLS = 3,
    parameter DOT_PROD_WIDTH = 16,
    parameter ADDRESS_WIDTH = 13,
    parameter WEIGHT_WIDTH = $clog2(WEIGHT_COLS),
    parameter FEATURE_WIDTH = $clog2(FEATURE_ROWS)
)
(
    input logic clk,
    input logic rst,
    input logic [FEATURE_WIDTH-1:0] write_row,
    input logic [WEIGHT_WIDTH-1:0] write_col,
    input logic [FEATURE_WIDTH - 1:0] read_row,
    //input logic wr_en,
    input logic [DOT_PROD_WIDTH - 1:0] fm_wm_in,
    output logic [DOT_PROD_WIDTH - 1:0] fm_wm_row_out [0:WEIGHT_COLS-1]
);

    
    // Declare memory array to store matrix data
    logic [DOT_PROD_WIDTH - 1:0] mem  [0:FEATURE_ROWS-1][0:WEIGHT_COLS-1];
    //logic [DOT_PROD_WIDTH - 1:0] test;

    always_ff @(posedge clk or posedge rst) begin
        if (rst) begin
            // Reset memory to 0 on reset
	    for (int i = 0; i < WEIGHT_COLS; i = i + 1) begin
		for (int j = 0; j < FEATURE_ROWS; j = j + 1) begin
          	    mem [j][i] <= '0;
 		end 
            end
        end else begin
            // Write data to memory at the specified address and column
            mem[write_row][write_col] <= fm_wm_in;
	    //mem[0][1] <= fm_wm_in;
	    //mem[0][2] <= fm_wm_in;
        end
    end

    assign fm_wm_row_out = mem[read_row];
    //assign fm_wm_row_out = fm_wm_in;
    //assign fm_wm_row_out = mem[0];
endmodule