module LFSR_6bit_tb;

    localparam int N = 6;

    logic clk,rst_n,sel;
    logic [N-1:0] parallel_in,parallel_out,seed;
    
    LFSR_6bit DUT(
        .clk(clk),
        .rst_n(rst_n),
        .sel(sel),
        .parallel_in(parallel_in),
        .parallel_out(parallel_out)
    );

    initial begin
        clk = 0;
        forever #0.5 clk = ~clk;
    end

    initial begin
        rst_n = 0;
        sel = 1; // serial mode
        parallel_in = '0;
        #20;

        rst_n = 1;
        sel = 0; // load in parallel mode
        @(posedge clk);
            parallel_in = $urandom_range(1,2**N-1);
           
        @(posedge clk);
            sel = 1;
        
        seed = parallel_in;
        
        $display("Random input: %b, Seed: %0d",parallel_in,seed);

        // Repeat a full loop until sequence resets
        repeat(2**N-1) begin
            //$display("GOT IN");
            @(posedge clk);
            if (parallel_out == '0) begin
                $error("LFSR hit all-zero state !");
            end
            $display("LFSR Out: %b", parallel_out);
        end
    $stop;
    end
endmodule