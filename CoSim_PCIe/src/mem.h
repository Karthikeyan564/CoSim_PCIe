#ifndef _MEM_H_
#define _MEM_H_

// -------------------------------------------------------------------------
// INCLUDES
// -------------------------------------------------------------------------

#include <stdio.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdbool.h>

#ifndef OSVVM
#include "VUser.h"
#endif

// -------------------------------------------------------------------------
// DEFINES
// -------------------------------------------------------------------------

#define TABLESIZE      (4096UL)
#define TABLEMASK      (TABLESIZE-1)

#define MEM_BAD_STATUS  1
#define MEM_GOOD_STATUS 0

// -------------------------------------------------------------------------
// TYPEDEFS
// -------------------------------------------------------------------------

typedef struct {
    char** p;
    uint64_t addr;
    bool     valid;
} PrimaryTbl_t, *pPrimaryTbl_t;

typedef uint16_t  PktData_t;
typedef uint16_t* pPktData_t;

// -------------------------------------------------------------------------
// PROTOTYPES
// -------------------------------------------------------------------------

extern void   InitialiseMem       (int node);

extern void     WriteRamByteBlock   (const uint64_t addr, const PktData_t* const data, const int fbe, const int lbe, const int length, const uint32_t node);
extern int      ReadRamByteBlock    (const uint64_t addr, PktData_t* const data, const int length, const uint32_t node);
extern void     WriteConfigSpace    (const uint32_t addr, const uint32_t data, const uint32_t node);
extern uint32_t ReadConfigSpace     (const uint32_t addr, const uint32_t node);
extern void     WriteConfigSpaceBuf (const uint32_t addr, const PktData_t* const data, const int fbe, const int lbe, const int length, const uint32_t node);
extern void     ReadConfigSpaceBuf  (const uint32_t addr, PktData_t* const data, const int length, const uint32_t node);

extern void     WriteRamByte        (const uint64_t addr, const uint32_t data, const uint32_t node);
extern void     WriteRamWord        (const uint64_t addr, const uint32_t data, const int little_endian, const uint32_t node);
extern void     WriteRamDWord       (const uint64_t addr, const uint64_t data, const int little_endian, const uint32_t node);
extern uint32_t ReadRamByte         (const uint64_t addr, const uint32_t node);
extern uint32_t ReadRamWord         (const uint64_t addr, const int little_endian, const uint32_t node);
extern uint64_t ReadRamDWord        (const uint64_t addr, const int little_endian, const uint32_t node);
#endif
