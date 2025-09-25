module shift_register_tb;
    parameter N = 4;
    
    logic clk;
    logic rst_n;
    logic serial_parallel;
    logic load_enable;
    logic serial_in;
    logic [N-1:0] parallel_in;
    logic [N-1:0] parallel_out;
    logic serial_out;
    
    // Instantiate the shift register
    shift_register #(N) dut (
        .clk(clk),
        .rst_n(rst_n),
        .serial_parallel(serial_parallel),
        .load_enable(load_enable),
        .serial_in(serial_in),
        .parallel_in(parallel_in),
        .parallel_out(parallel_out),
        .serial_out(serial_out)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    // Test sequence
    initial begin
        // Initial reset
        rst_n = 0;
        serial_parallel = 0;
        load_enable = 0;
        serial_in = 0;
        parallel_in = 0;
        
        // Hold reset for a few cycles
        repeat(4) @(posedge clk);
        rst_n = 1;
        
        $display("Test 1: Parallel load with 4'b1010");
        @(posedge clk);
        load_enable = 1;
        serial_parallel = 1;
        parallel_in = 4'b1010;
        
        @(posedge clk);
        $display("Parallel out: %b, Serial out: %b", parallel_out, serial_out);
        
        $display("Test 2: Disabled loading (should keep previous value)");
        load_enable = 0;
        parallel_in = 4'b0101;
        
        @(posedge clk);
        $display("Parallel out: %b, Serial out: %b", parallel_out, serial_out);
        
        $display("Test 3: Parallel load with 4'b1100");
        load_enable = 1;
        parallel_in = 4'b1100;
        
        @(posedge clk);
        $display("Parallel out: %b, Serial out: %b", parallel_out, serial_out);
        
        $display("Test 4: Serial shifting (1,0,1,1)");
        serial_parallel = 0;
        
        serial_in = 1;
        @(posedge clk);
        $display("Parallel out: %b, Serial out: %b", parallel_out, serial_out);
        
        serial_in = 0;
        @(posedge clk);
        $display("Parallel out: %b, Serial out: %b", parallel_out, serial_out);
        
        serial_in = 1;
        @(posedge clk);
        $display("Parallel out: %b, Serial out: %b", parallel_out, serial_out);
        
        serial_in = 1;
        @(posedge clk);
        $display("Parallel out: %b, Serial out: %b", parallel_out, serial_out);
        
        $display("Test 5: Reset during operation");
        rst_n = 0;
        @(posedge clk);
        $display("After reset - Parallel out: %b, Serial out: %b", parallel_out, serial_out);
        
        rst_n = 1;
        
        $display("Test 6: Serial shifting after reset (1,0,1,0)");
        serial_in = 1;
        @(posedge clk);
        $display("Parallel out: %b, Serial out: %b", parallel_out, serial_out);
        
        serial_in = 0;
        @(posedge clk);
        $display("Parallel out: %b, Serial out: %b", parallel_out, serial_out);
        
        serial_in = 1;
        @(posedge clk);
        $display("Parallel out: %b, Serial out: %b", parallel_out, serial_out);
        
        serial_in = 0;
        @(posedge clk);
        $display("Parallel out: %b, Serial out: %b", parallel_out, serial_out);
        
        $display("Test 7: Parallel load after serial shift with 4'b0011");
        serial_parallel = 1;
        parallel_in = 4'b0011;
        
        @(posedge clk);
        $display("Parallel out: %b, Serial out: %b", parallel_out, serial_out);
        
        @(posedge clk);
        $display("Parallel out: %b, Serial out: %b", parallel_out, serial_out);
        
        $display("Test complete!");
        $stop;
    end
endmodule