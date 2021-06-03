#pragma once

#include <stdint.h>
#include <stdbool.h>

typedef uint32_t u32;
typedef uint16_t u16;
typedef uint8_t u8;

typedef struct {
    char *plx_base;
} plx_context;

plx_context *plx_context_load(char *base);
void plx_context_free(plx_context *ctx);