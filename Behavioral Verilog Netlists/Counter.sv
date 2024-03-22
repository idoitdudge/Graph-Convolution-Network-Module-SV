module Counter 
  #(parameter FEATURE_ROWS = 6,
    parameter WEIGHT_COLS = 3,
    parameter COUNTER_WEIGHT_WIDTH = $clog2(WEIGHT_COLS),
    parameter COUNTER_FEATURE_WIDTH = $clog2(FEATURE_ROWS))

(
  input logic clk,
  input logic reset,
  input logic enable_weight_counter,
  input logic enable_feature_counter,
  input logic read_feature_or_weight,

  output wire [12:0] read_address,
  output logic [COUNTER_WEIGHT_WIDTH-1:0] weight_count,
  output logic [COUNTER_FEATURE_WIDTH-1:0] feature_count
);

    logic [COUNTER_WEIGHT_WIDTH-1:0] w_count;
    logic [COUNTER_FEATURE_WIDTH-1:0] f_count;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            w_count <= '0;
            f_count <= '0;
        end

        else if (enable_weight_counter && w_count < WEIGHT_COLS-1) begin
            w_count <= w_count + 1;
	    f_count <= 0;
        end
        
        else if (enable_feature_counter && f_count < FEATURE_ROWS-1) begin
            f_count <= f_count + 1;
        end

        //else if (f_count == FEATURE_ROWS-1) begin
        //    f_count <= '0;
        //end
    end

    assign read_address = (read_feature_or_weight == 1) ? (f_count) + 10'b10_0000_0000 : w_count; 
    assign weight_count = w_count;
    assign feature_count = f_count;

endmodule
