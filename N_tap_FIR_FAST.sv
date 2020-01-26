/*
Revisions
Version 1.0 : created the file 
Version 1.1 : fixed the issue leading to multiple iteration when j was 1 bad adding condtional operators 

Designer information
Name : dhruv patel
Role : FPGA Digital Design intern
Email : dhruvpatel1999@alumni.ubc.ca



>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
design documentation 
>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>


Description 
____________________________________________________________________________________
the following is a parametrized N-Tap FIR filter which takes the number of tabs and the delay functions as parameters and 
generates a FIR aritecture 
____________________________________________________________________________________



Interface 
____________________________________________________________________________________
    protocal : Not designed for inegration into global****

    input 
                      clk : input clock, must be less than or = to 1GHZ-1/(t setup time), 
                            clock gating allowed such that frequency [1ghz,0)
                            setup/hold time are global FPGA PLB time elements 
                      signal_in: the digital signal that is to be filtered  aka x[n]
                      h: the filter coefficients for the FIR system 

                            
                      
    output   
                      filter_out: the filtered y[n] output of the system.
____________________________________________________________________________________




basic math
____________________________________________________________________________________
y[n]=a1=0*x[n]+a1*x[n-1]......am*x[n-m]

H[z]=Y[z]/X[z]=a0+a1z^-1......am*z^-1

inputs {a0 to am : m E Z+}
____________________________________________________________________________________

*/
module FIR(clk,h,signal_in,filter_out);
parameter n = 14 ;

input logic clk;
input signal_in;
input [n-1:0] h;
output int filter_out;

logic [n-1:0][9:0] vdff_var; // the shift register array
logic [n-1:0][n-1:0][9:0] matrix; // the matrix used to implement the pyramid adders

assign vdff_var[0]=signal_in;

genvar i; // generates the shift registers 
generate 
  for (i=0; i<n; i=i+1) begin : layer_1
    vDFF #(10) layer_1(.clk(clk),.load(1'b1),.in(vdff_var[i]),.out(vdff_var[i+1]));
    mult       layer_mult(.in(vdff_var[i]),.out(matrix[n][i]),.mult_parm(h[i]));
  end
endgenerate 


genvar j,k; // generates the pyramid adders 
generate 
  for (j=n; j>0; j=((j%2==0) ? j/2:((j==1)?0:j/2+1))) begin : addr_layer
    if (j%2==0) begin
        for(k=0;k<=j;k=k+2) begin 
            add addr_e(.a(matrix[j][k]),.b(matrix[j][k+1]),.out(matrix[j/2][(k+1)/2]));
    end
    end else begin
        for(k=0;k<j;k=k+2) begin
            add add_o(.a(matrix[j][k]),.b(matrix[j][k+1]),.out(matrix[j/2][(k+1)/2]));
            end
    add addr_u(.a(matrix[j][j]),.b(10'b0),.out(matrix[j/2][(j)/2+1]));
    end
  end
endgenerate 

vDFF #(10) answer(.clk(clk),.load(1'b1),.in(matrix[0][0]),.out(filter_out)); // final output 

endmodule

//TESTED
module vDFF(clk, load, in, out); // my vDFF form cpen 211 
  parameter n = 9;  // width
  input clk, load;
  input [n-1:0] in;
  output [n-1:0] out;
  reg [n-1:0] out;
  wire [n-1:0] next_out;

  assign next_out = (load ? in : out);

  always @(posedge clk)
    out = next_out;

endmodule 

//// placeholder mult 
//would use a Double Precision Floating Point Multiplier in IEEE-754 in real life, but i have so many midterms
module mult(in,out,mult_parm); 
input int in,mult_parm;
output int out;
assign out=in*mult_parm;
endmodule

// would use a custom low laterncy adder in real life 
module add(a,b,out);
input int a,b;
output int out;
assign out=a+b;
endmodule