//=============================================================
// VUserMain1.c
//=============================================================

#include <stdio.h>
#include <stdlib.h>
#include "pcie.h"

#define RST_DEASSERT_INT 4

static int          node      = 1;
static unsigned int Interrupt = 0;

//-------------------------------------------------------------
// ResetDeasserted()
//
// ISR for reset de-assertion. Clears interrupts state.
//
//-------------------------------------------------------------

static int ResetDeasserted(void)
{
    Interrupt |= RST_DEASSERT_INT;
}

//-------------------------------------------------------------
// VUserInput_1()
//
// Consumes the unhandled input Packets
//-------------------------------------------------------------

static void VUserInput_1(pPkt_t pkt, int status, void* usrptr) 
{
    int idx;

    if (pkt->seq == DLLP_SEQ_ID) 
    {
        DebugVPrint("---> VUserInput_1 received DLLP\n");
    }
    else
    {
        DebugVPrint("---> VUserInput_1 received TLP sequence %d of %d bytes at %d\n", pkt->seq, GET_TLP_LENGTH(pkt->data), pkt->TimeStamp);
    }

    // Once packet is finished with, the allocated space *must* be freed.
    // All input packets have their own memory space to avoid overwrites
    // which shared buffers.
    DISCARD_PACKET(pkt);
}

//-------------------------------------------------------------
// VUserMain1()
//
// Endpoint complement to VUserMain0. Initialises link and FC
// before sending idles indefinitely.
//
//-------------------------------------------------------------

void VUserMain1() 
{

    // Initialise PCIe VHost, with input callback function and no user pointer.
    InitialisePcie(VUserInput_1, NULL, node);

    // Make sure the link is out of electrical idle
    VWrite(LINK_STATE, 0, 0, node);

    DebugVPrint("VUserMain: in node %d\n", node);

    VRegInterrupt(RST_DEASSERT_INT, ResetDeasserted, node);

    // Use node number as seed
    PcieSeed(node, node);

    // Send out idles until we recieve an interrupt
    do
    {
        SendOs(IDL, node);
    }
    while (!Interrupt);

    Interrupt &= ~RST_DEASSERT_INT;

    // Initialise the link for 16 lanes
    InitLink(16, node);

    // Initialise flow control
    InitFc(node);

    // Send out idels forever
    while (true)
    {
        SendIdle(100, node);
    }
}
    
