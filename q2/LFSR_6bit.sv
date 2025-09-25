module LFSR_6bit (
  input  logic clk, rst_n,
  input  logic sel,
  input  logic [5:0] parallel_in,
  output logic [5:0] parallel_out
);
  // 6-bit register to store current state
  logic [5:0] lfsr_reg, lfsr_next;
  
  // LFSR feedback logic (tapping bits 5 and 4)
  // Common polynomial for 6-bit LFSR: x^6 + x^5 + x^1 + 1
  logic feedback;
  assign feedback = lfsr_next[5] ^ lfsr_next[4] ^ lfsr_next[0] + 'b1;
  
  // Register update logic
  always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
      lfsr_next <= 'd1; // Reset to zeros
    end else begin
      lfsr_next <= lfsr_reg;
    end
  end

  always_comb begin 
    if(sel) begin
      lfsr_reg = {lfsr_next[4:0], feedback};

    end else begin
      lfsr_reg = parallel_in;
    end
  end

  assign parallel_out = lfsr_next;
endmodule
