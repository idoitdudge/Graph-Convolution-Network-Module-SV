module coo_convert
  #(parameter COO_EDGE_ROW = 2,
    parameter COO_WIDTH = 3,
    parameter COO_EDGES = 6,
    parameter FW_COL = 6,
    parameter WEIGHT_COLS = 3,
    parameter FEATURE_ROWS = 6,
    parameter FEATURE_WIDTH = $clog2(FEATURE_ROWS),
    parameter COO_EDGES_WIDTH = $clog2(COO_EDGES),
    parameter DOT_PROD_WIDTH = 16
)
(
    input logic clk,
    input logic reset,
    //input logic counter_in,
    input logic [COO_WIDTH-1:0] coo_in [0:COO_EDGE_ROW-1],
    //input logic [DOT_PROD_WIDTH - 1:0] fm_wm_row_in  [0:WEIGHT_COLS-1],
    input logic done_trans,
    input logic [COO_EDGES_WIDTH-1:0] done_counter,

    //output logic [DOT_PROD_WIDTH - 1:0] fm_wm_adj_row_out [0:WEIGHT_COLS-1],
    output logic counter_out,
    output logic [COO_EDGES_WIDTH-1:0] coo_address,
    output logic [FEATURE_WIDTH - 1:0] read_row_fw_wm,
    output logic [COO_WIDTH - 1:0] read_row_fw_wm_adj,
    output logic done
);

    logic [FEATURE_WIDTH - 1:0] read_row_fw_wm_temp;
    logic [COO_WIDTH - 1:0] read_row_fw_wm_adj_temp;
    logic [COO_EDGES_WIDTH-1:0] coo_address_temp;
    //logic [COO_EDGES_WIDTH-1:0] coo_address_temp_one;
    logic counter;
    logic done_comb;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            coo_address_temp <= '0;
            read_row_fw_wm_adj_temp <= '0;
            read_row_fw_wm_temp <= '0;
            done_comb <= 1'b0;
            counter <= '0;
        end

        else if (done_trans && counter == 1'b0 && done_counter < COO_EDGES) begin
            read_row_fw_wm_temp <= coo_in[0] - 1;
            read_row_fw_wm_adj_temp <= coo_in[1] - 1;
            counter <= 1;
        end
        
        else if (done_trans && counter == 1'b1 && done_counter < COO_EDGES) begin
            read_row_fw_wm_temp <= coo_in[1] - 1;
            read_row_fw_wm_adj_temp <= coo_in[0] - 1;
            coo_address_temp <= coo_address_temp + 1;
            counter <= '0;
        end

        else if (done_counter == COO_EDGES) begin
            done_comb <= 1'b1;
        end
    end

    //assign coo_address_temp_one = coo_address_temp;
    assign read_row_fw_wm = read_row_fw_wm_temp;
    assign read_row_fw_wm_adj = read_row_fw_wm_adj_temp;
    //assign fm_wm_adj_row_out = fm_wm_row_in; 
    assign coo_address = coo_address_temp; //can i just add to itself? is it synthesizable?
    assign done = done_comb;
    assign counter_out = counter;

endmodule
