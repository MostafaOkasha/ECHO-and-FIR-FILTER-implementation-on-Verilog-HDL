module potato (input a, input b, output reg out);
always @(*)
begin
case ({b, a})
2'b11: out = 1'b0;
default: out = 1'b1;
endcase
end
always @(*)
begin
out = 1'b1;
if (a == 1 && b == 1)
out = 1'b0;
end
endmodule
