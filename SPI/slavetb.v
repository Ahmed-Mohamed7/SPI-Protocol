
module slavetb ();

reg sclk;
reg reset;
reg [1:0]mode;
reg [7:0]externalin;
reg load_enable;
reg mosi;
reg ss;
reg [7:0]slavestore;
integer i;
wire [7:0]slave_data;
reg [7:0]Master_data;

always #5
sclk=~sclk;

slave test(externalin,load_enable,reset,mode,miso,mosi,sclk,ss,slave_data);

initial begin
$display("externalin\tload_enable\treset\t\tmode\tmiso\tmosi\tsclk\tss\tslave_data\tslavestore");
$monitor("%b\t\t%b\t%b\t%b\tmiso=%b\tmosi=%b\t%b\t%b\t%b\t%b",externalin,load_enable,reset,mode,miso,mosi,sclk,ss,slave_data,slavestore);
sclk=1'b0;//setting the clock (sclk) to oscillate
ss=1'b0;//ss=1 means that slave is not selected yet
mode=2'b00;//  can  be changed to test other modes(00,01,10,11)
externalin=8'b11011010;//any load for clk independent loading - could be changed
Master_data=8'b00110110;//the data simulated that comming from the master
load_enable=1'b0;//to disable loading
reset=1'b1;//reset testing reseting so all slave regs be zeros 
#10
reset=1'b0;//removing reset
load_enable=1'b1;#10//enabling load 
if(~mode[0]) begin #5;end
load_enable=1'b0;//disableing clk independent loading
    #5;
    for (i=7; i>-1; i=i-1)
    begin
	mosi=Master_data[i];//loading the data into the mosi
       #5;
       slavestore[i]=miso;//storeing the data coming from slave's regs
       #5;
    end

if(Master_data==slave_data&&slavestore==externalin)//checking for both slave_data and slavestore
$display("slave testbench  succeeded");
else 
begin
$display("slave testbench faild @ %b	<= Master_data",Master_data);
$display("	       %b	<= slave regs",slave_data);
$display("------------------------------------------------");
$display("slave testbench faild @ %b	<= slavestore",slavestore);
$display("	       %b",externalin);
end
$finish();
end
endmodule