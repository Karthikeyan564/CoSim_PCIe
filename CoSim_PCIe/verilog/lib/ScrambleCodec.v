`ifdef VPROC_SV
`include "allheaders.v"
`endif

`WsTimeScale

module ScrambleCodec(ClkPci, notResetPci, MovePipe, Shift, NextShift, OutShift, NextXorWord, XorWord);

input         ClkPci;
input         notResetPci;
input         MovePipe;
input  [15:0] Shift;
output  [7:0] XorWord;
output  [7:0] NextXorWord;
output [15:0] OutShift;
output [15:0] NextShift;

reg    [15:0] OutShift;
reg     [7:0] XorWord;

// G(X) = X^16 + X^5 + X^4 + X^3 + 1

assign NextShift   = (MovePipe ? {Shift[7:0], Shift[15:8]} ^ {5'h00, Shift[15:8], 3'h0} ^ {4'h0, Shift[15:8], 4'h0} ^ {3'h0, Shift[15:8], 5'h00} : 
                                  Shift) | {16{~notResetPci}};

assign NextXorWord = {NextShift[8] , NextShift[9] , NextShift[10], NextShift[11], NextShift[12], NextShift[13], NextShift[14], NextShift[15]};

always @(posedge ClkPci)
begin
    OutShift <= #`RegDel NextShift;
    XorWord  <= #`RegDel NextXorWord;
end

endmodule

