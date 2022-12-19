`ifndef _PCIEDISPHEADER_V_
`define _PCIEDISPHEADER_V_

// Disp Control
`define DispAll             0
`define DispFinish          1
`define DispStop            2
`define DispUnused0         3
`define DispTL              4
`define DispDL              5
`define DispPL              6
`define DispRawSym          7
`define NoDispBits          8
`define DispBits            (`NoDispBits-1):0

`define NoDecTimeDigs       12
`define NoDispContBits      (`NoDecTimeDigs * 4)
`define DispEntries         256

`define CmplSaveDepth       1024

`define COMP_RX             4
`define COMP_PENDING        3
`define DISP_RXTS           2
`define DISP_RXFTSOS        1
`define DISP_RXSKPOS        0

// Disp DataIn
`define DispCompl           0
`define DispComplHdr        96:1

`define DispDataInBits      96:0
`define DispDataOutBits     96:0


`define CHECKONLY           1'b0
`define ENABLEDISP          1'b1

`define DispLineBrk         8

`define LINEBREAK           22
`define PADSTR              "..."

`endif
