`ifdef VPROC_SV
`include "allheaders.v"
`endif

`WsTimeScale

module RxDP (ClkPci, NextScramble, DecodeByte, NextScXor, OutByteRaw, OutByteSc);

input        ClkPci;
input        NextScramble;
input  [7:0] DecodeByte;
input  [7:0] NextScXor;

output [7:0] OutByteSc;
output [7:0] OutByteRaw;

reg    [7:0] OutByteRaw;
reg    [7:0] OutByteSc;

always @(posedge ClkPci)
begin
    OutByteRaw  <= #`RegDel DecodeByte;
    OutByteSc   <= #`RegDel DecodeByte ^ (NextScXor & {8{NextScramble}});
end

endmodule
