`ifdef VPROC_SV
`include "allheaders.v"
`endif

`WsTimeScale

module ContDisps (Clk, DispValOut);

input                        Clk;
output [`DispBits]           DispValOut;


reg [(`NoDispContBits-1):0]  ControlDisps[0:`DispEntries*2]; 
reg [(`NoDispContBits-1):0]  DispVal;
reg [(`NoDispContBits-1):0]  NextDispVal;
reg [(`NoDispContBits-1):0]  MaskDispVal;

reg [(`NoDecTimeDigs*4)-1:0] StartDispTime;

reg [31:0]                   ControlDispsIndex;
integer                      CycleNo;

assign DispValOut = DispVal[`DispBits];

//-------------------------------------------------------------
//

function [(`NoDecTimeDigs*4)-1:0] MakeDecimal;

input [(`NoDecTimeDigs*4)-1:0] InVal;
reg   [(`NoDecTimeDigs*4)-1:0] i, MulBy, DecVal;
reg   [(`NoDecTimeDigs*4)-1:0] HexVal;

begin
    HexVal = InVal;
    DecVal = 0;
    MulBy  = 1;

    for (i = 0; i < `NoDecTimeDigs; i = i + 1)
    begin
        DecVal = ((HexVal & 64'hf) * MulBy) + DecVal;
        HexVal = HexVal >> 4;
        MulBy = MulBy * 10;
    end

    MakeDecimal = DecVal;
end
endfunction

//-------------------------------------------------------------
//

task ReReadContDisps;
begin
    $readmemh({"hex/ContDisps.hex"}, ControlDisps);

    if (ControlDisps[ControlDispsIndex] !== {`DispEntries*2{1'bx}})
    begin
        if (StartDispTime != MakeDecimal(ControlDisps[ControlDispsIndex+1]))
        begin
            StartDispTime = MakeDecimal(ControlDisps[ControlDispsIndex+1]);
            $display("Read in new ContDisps.hex.");
            $display("Will now start to print state on cycle %0d for %h.", StartDispTime, NextDispVal);
        end

        NextDispVal = ControlDisps[ControlDispsIndex];

        if (CycleNo >= StartDispTime)
        begin
            $display("Will start to print state now for %h.", NextDispVal);
        end
    end
end
endtask

//-------------------------------------------------------------
//

initial
begin
    $readmemh({"hex/ContDisps.hex"}, ControlDisps);

    @(posedge Clk);
    
    CycleNo           = 0;
    ControlDispsIndex = 0;
    DispVal           = 0;
    StartDispTime     = MakeDecimal(ControlDisps[ControlDispsIndex+1]);
    NextDispVal       = ControlDisps[ControlDispsIndex];

    $display("Will start to print state on cycle %0d for %h.", StartDispTime, NextDispVal);

    forever
    begin
        if (ControlDisps[ControlDispsIndex] !== {`DispEntries*2{1'bx}})
        begin
            if (CycleNo >= StartDispTime)
            begin
                ControlDispsIndex = ControlDispsIndex + 2;
                DispVal           = NextDispVal;
                StartDispTime     = MakeDecimal(ControlDisps[ControlDispsIndex+1]);
                NextDispVal       = ControlDisps[ControlDispsIndex];

                $display("Will start to print state on cycle %0d for %h.", StartDispTime, NextDispVal);
            end
        end 

        if ((CycleNo % 4000) == 0)
        begin
            ReReadContDisps;
        end

        @(posedge Clk);
        CycleNo = CycleNo + 1;
   end 
end

endmodule
