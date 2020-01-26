// placer holder testbench should you wish to use it  
// signal_in is input 
// change signal in every signal clock cycle 
// filter_out will refresh every single clock cycle 
module tb_fir();
logic clk;
int signal_in;
logic [13:0] h;
int filter_out;
int i;
FIR #(14) filter(.clk(clk),.h(h),.signal_in(signal_in),.filter_out(filter_out));

initial forever begin
    clk=1'b1;
    #5;
    clk=1'b0;
    #5;
end

initial begin

for(i=0;i<15;i++)begin
      h[i]=i%2;
    end

#5;
    for(i=0;i<199;i++)begin
      signal_in=i%2;
    end
#5000;
$stop;
end
endmodule 