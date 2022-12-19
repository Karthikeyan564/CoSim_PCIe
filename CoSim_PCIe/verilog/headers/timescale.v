`ifndef _TIMESCALE_V_
`define _TIMESCALE_V_

`ifdef TIMESCALE_RESOL_10PS
`define WsTimeScale `timescale 1 ps / 10 ps
`else
`define WsTimeScale `timescale 1 ps / 1 ps
`endif

`ifndef RegDel
`define RegDel             1
`endif

`define PcieVHostSampleDel 10

`endif