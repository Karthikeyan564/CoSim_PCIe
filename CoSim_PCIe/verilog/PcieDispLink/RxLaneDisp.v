//=============================================================
// A PCI-Express Physical (logical) layer Rx lane
// See Base Specification Revision 1.0a section 4.2
//=============================================================

`ifdef VPROC_SV
`include "allheaders.v"
`endif

`WsTimeScale

//-------------------------------------------------------------
// RxLaneDisp
//-------------------------------------------------------------

module RxLaneDisp (LinkIn, notReset, Clk, RxByte, RxByteRaw, RxControl, Synced, DisableScramble, InvertTxPolarity,
                   RxTrainingSeq, ElecIdleOrderedSet, FtsOrderedSet, SkpOrderedSet);

input        Clk;
input  [9:0] LinkIn;
input        notReset;
input        Synced;
input        DisableScramble;
input        InvertTxPolarity;
output [7:0] RxByte;
output [7:0] RxByteRaw;
output       RxControl;

output       ElecIdleOrderedSet;
output       FtsOrderedSet;
output       SkpOrderedSet;
output [1:0] RxTrainingSeq; 

wire   [7:0] DecodeByte;
wire   [7:0] ScXor;
wire         DecodeCtrl;
wire  [15:0] Shift;
wire         notResetScrambler;
wire         MoveScrambler;
wire         Scramble;
wire         TSEvent0;

wire [9:0] LinkData = LinkIn ^ {10{InvertTxPolarity}};

    // Combinatorial decode logic
    Decoder        dc (.Clk(1'b0), 
                       .Input              (LinkData),
                       .BitRev             (1'b0), 
                       .InvertDataIn       (1'b0), 
                       .OutputRaw          (DecodeByte), 
                       .ControlRaw         (DecodeCtrl),
                       .Output             (),
                       .Control            ()
                       );

    // Receiver logic controlling scrambling and flow control, as well as flagging
    // reception events
    RxLogicDisp   rxl (.Clk                (Clk), 
                       .notReset           (notReset),
                       .DecodeCtrl         (DecodeCtrl),
                       .DecodeByte         (DecodeByte),
                       .OutByteRaw         (RxByteRaw),
                       .LinkIn             (LinkIn),
                       .Synced             (Synced),
                       .notResetScrambler  (notResetScrambler),
                       .MoveScrambler      (MoveScrambler),
                       .Scramble           (Scramble),
                       .DisableScramble    (DisableScramble),
                       .ElecIdleOrderedSet (ElecIdleOrderedSet),
                       .FtsOrderedSet      (FtsOrderedSet),
                       .SkpOrderedSet      (SkpOrderedSet),
                       .RxTrainingSeq      (RxTrainingSeq),
                       .RxControl          (RxControl)
                       );

    // Generates scrambling code
    ScrambleCodec rsc (.ClkPci             (Clk),
                       .notResetPci        (notResetScrambler),
                       .MovePipe           (MoveScrambler),
                       .Shift              (Shift),
                       .NextShift          (),
                       .OutShift           (Shift),
                       .NextXorWord        (),
                       .XorWord            (ScXor)
                       );

    // Receiver data path
    RxDpDisp     rxdp (.Clk                (Clk), 
                       .Scramble           (Scramble),
                       .DecodeByte         (DecodeByte),
                       .ScXor              (ScXor),
                       .OutByteRaw         (RxByteRaw), 
                       .OutByteSc          (RxByte)
                       );


endmodule

//-------------------------------------------------------------
// RxDpDisp
//-------------------------------------------------------------

module RxDpDisp (Clk, Scramble, DecodeByte, ScXor, OutByteRaw, OutByteSc);

input        Clk;
input        Scramble;
input  [7:0] DecodeByte;
input  [7:0] ScXor;

output [7:0] OutByteSc;
output [7:0] OutByteRaw;

reg    [7:0] OutByteRaw;

assign OutByteSc = OutByteRaw ^ (ScXor & {8{Scramble}});

always @(posedge Clk)
begin
    OutByteRaw  <= #`RegDel DecodeByte;
end

endmodule
