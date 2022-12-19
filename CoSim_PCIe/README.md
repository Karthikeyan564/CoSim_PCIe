# CoSim_PCIe
A Simple PCIe(1a to 2.0) Bus Functional Model (BFM).

Generates PCIe Physical, Data Link and Transaction Layer traffic for up to 16 lanes, controlled from user C program, via an API. Has configurable internal memory and configuration space models, and will auto-generate completions (configurably), with flow control, ACKs, and NAKS etc. Tested for Verilator and ModelSim/Questa only at the present time, though easily adpated for VCS, NC-Verilog and Icarus (and has previously been running on these in the past).
