#include "VSched_pli.h"

extern int PciCrc32(char* userdata);
extern int PciCrc16(char* userdata);

// -------------------------------------------------------------------------
// register_vpi_tasks()
//
// Registers the VProc system tasks for VPI
// -------------------------------------------------------------------------

static void register_vpi_tasks()
{
    s_vpi_systf_data data[] =
      {
          VPROC_VPI_TBL
          {vpiSysTask, 0, "$pcicrc16",   PciCrc16,   0, 0, 0},
          {vpiSysTask, 0, "$pcicrc32",   PciCrc32,   0, 0, 0},
      };


    for (int idx= 0; idx < sizeof(data)/sizeof(s_vpi_systf_data); idx++)
    {
        debug_io_printf("registering %s\n", data[idx].tfname);
        vpi_register_systf(&data[idx]);
    }
}

// -------------------------------------------------------------------------
// Contains a zero-terminated list of functions that have
// to be called at startup
// -------------------------------------------------------------------------

void (*vlog_startup_routines[])() =
{
    register_vpi_tasks,
    0
};

