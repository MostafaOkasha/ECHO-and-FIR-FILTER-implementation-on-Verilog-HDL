module mac #(parameter dsize = 16)
    (input clk, input signed [dsize-1:0] coeffin, datain, input signed [dsize*2-1:0] cascin,
    output signed [dsize-1:0] cascdata, output reg signed [2*dsize-1:0] cascout);
    
    reg signed [dsize-1:0]   coeff;
    reg signed [dsize-1:0]   data;
    reg signed [dsize-1:0]   datatwo;  
    reg signed [2*dsize-1:0] product;
    
    assign cascdata = datatwo;
    
    always @(posedge clk)
        begin
            coeff   <= coeffin;
            data    <= datain;
            datatwo <= data;
            product <= data * coeff;
            cascout <= product + cascin;     
        end
        
endmodule