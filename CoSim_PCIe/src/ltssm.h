#include <stdint.h>

#ifndef _LTSSM_H_
#define _LTSSM_H_

#define LINK_INIT_NO_CHANGE  (-1)

typedef struct
{
    int ltssm_linknum;
    int ltssm_n_fts;
    int ltssm_ts_ctl;
    int ltssm_detect_quiet_to;
    int ltssm_enable_tests;
    int ltssm_force_tests;

} ConfigLinkInit_t;

#define INIT_CFG_LINK_STRUCT(_cfg) {                  \
  (_cfg).ltssm_linknum         = LINK_INIT_NO_CHANGE; \
  (_cfg).ltssm_n_fts           = LINK_INIT_NO_CHANGE; \
  (_cfg).ltssm_ts_ctl          = LINK_INIT_NO_CHANGE; \
  (_cfg).ltssm_detect_quiet_to = LINK_INIT_NO_CHANGE; \
  (_cfg).ltssm_enable_tests    = LINK_INIT_NO_CHANGE; \
  (_cfg).ltssm_force_tests     = LINK_INIT_NO_CHANGE; \
}

extern void ConfigLinkInit (const ConfigLinkInit_t cfg, const int node);

#endif
