module coo_Counter

(
    input logic clk,
    input logic reset,
    input logic counter_in,

    //output logic counter_out;
    output logic [2:0] done_counter
);

    //logic count;
    logic [2:0] done_count;

    always_ff @(posedge clk or posedge reset) begin
        if (reset) begin
            //count <= 1'b0;
            done_count <= '0;
        end

        else if (counter_in == 1) begin
            //count <= 1'b0;
            done_count <= done_count + 1;
        end

        // else begin
        //     count <= 1'b1;
        // end
    end

    //assign counter_out = count;
    assign done_counter = done_count;

endmodule
