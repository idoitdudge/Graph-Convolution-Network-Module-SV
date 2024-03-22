module Argmax
  #(parameter FINAL_MATRIX_ROW = 6,
    parameter FINAL_MATRIX_COL = 3,
    parameter ROW_WIDTH = $clog2(FINAL_MATRIX_ROW),
    parameter COL_WIDTH = $clog2(FINAL_MATRIX_COL),
    parameter DOT_PROD_WIDTH = 16,
    parameter MAX_ADDRESS_WIDTH = 2
)
(
    input logic clk,
    input logic reset,
    input logic done_comb,
    input logic [DOT_PROD_WIDTH-1:0] adj_fm_wm_in [0:FINAL_MATRIX_COL-1],

    output logic [MAX_ADDRESS_WIDTH - 1:0] max_addi_answer [0:FINAL_MATRIX_ROW - 1],
    output logic [ROW_WIDTH - 1:0] read_row,
    output done
);
    logic done_sig;
    logic [MAX_ADDRESS_WIDTH - 1:0] mem [0:FINAL_MATRIX_ROW - 1];
    logic [ROW_WIDTH - 1:0] counter;
    logic [MAX_ADDRESS_WIDTH - 1:0] max;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            counter <= '0;
            done_sig <= '0;    
	        max <= '0;
        end

        else if (done_comb && counter <= FINAL_MATRIX_ROW-1) begin
	        mem[counter] <= (adj_fm_wm_in[0] >= adj_fm_wm_in[1]) ? (adj_fm_wm_in[0] >= adj_fm_wm_in[2] ? 0 : 2) : (adj_fm_wm_in[1] >= adj_fm_wm_in[2] ? 1 : 2);
            counter <= counter + 1;
        end

        else if (counter == FINAL_MATRIX_ROW) begin
            done_sig <= 1;
        end
    end

    //assign max = (adj_fm_wm_in[0] >= adj_fm_wm_in[1]) ? (adj_fm_wm_in[0] >= adj_fm_wm_in[2] ? 0 : 2) : (adj_fm_wm_in[1] >= adj_fm_wm_in[2] ? 1 : 2);
    //assign mem[counter] = max;
    assign done = done_sig;
    assign read_row = counter;
    assign max_addi_answer = mem;

    // always_ff @(posedge clk or reset) begin
    //     if (reset) begin
    //         for (int i = 0; i < FINAL_MATRIX_ROW; i = i + 1) begin
    //             mem[i] <= '0;
    //         end
    //         done_sig <= '0;
    //         counter <= '0;
    //     end
        
    //     else if (done_comb && counter < FINAL_MATRIX_ROW) begin
    //         for (int j = 0; j < FINAL_MATRIX_COL; j = j + 1) begin
    //             if (mem[j] < adj_fm_wm_in[j]) begin
    //                 mem[j] <= adj_fm_wm_in[j];
    //             end
    //         end
    //         counter <= counter + 1;
    //     end

    //     else begin
    //         done_sig <= 1;
    //     end
    // end

    // assign max_addi_answer = mem;
    // assign read_row = counter;
    // assign done = done_sig;

endmodule
