#include "this_aip_load.h"

SEETA_AIP_API int32_t this_aip_load(struct SeetaAIP *aip, uint32_t size) {
    /* = Edit your lib here = */
    return SEETA_AIP_LOAD_UNHANDLED_INTERNAL_ERROR;
}

SEETA_AIP_API int32_t seeta_aip_load(struct SeetaAIP *aip, uint32_t size) {
    return this_aip_load(aip, size);
}