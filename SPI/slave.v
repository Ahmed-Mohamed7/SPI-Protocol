module slave (externalin,load_enable,reset,mode,miso,mosi,sclk,ss,slave_data);
		
input mosi;
input ss;
input [1:0]mode;
input [7:0]externalin;
input sclk;
input reset;
input load_enable;	
output reg miso;
output [7:0] slave_data; 
reg [7:0]shift_regs;

assign inclk = ss?1'b0:sclk;

always@(posedge ss)
begin
	miso<=1'bz;
end

always@(posedge inclk , posedge reset,posedge load_enable)
begin
	if(load_enable==1'b0)
	begin
	       if(mode==0||mode==2'b10)

             miso<=shift_regs[7];

else if(mode==2'b01||mode==2'b11)
shift_regs[7:0]<={shift_regs[6:0],mosi};

                 
	end
	else 
	begin
		shift_regs=externalin;
	miso=ss?1'bz:1'b0;
	end
	if(reset)
	begin
		shift_regs<=8'b00000000;
		miso=ss?1'bz:1'b0;
	end
end

always@(negedge inclk)
begin
	if(load_enable==1'b0)
	begin
	       if(mode==0||mode==2'b10)

shift_regs[7:0]<={shift_regs[6:0],mosi};


else if(mode==2'b01||mode==2'b11)

miso<=shift_regs[7];
//shifting
end


else
begin
		shift_regs=externalin;
//		miso=shift_regs[7];
	end
end
assign slave_data = shift_regs;
endmodule
