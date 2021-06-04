#pragma once

#include <stdint.h>
#include <stdbool.h>

typedef uint32_t u32;
typedef uint16_t u16;
typedef uint8_t u8;

typedef struct {
    char *plx_base;
    char *plx_repo_url;
    bool rebuild;
} plx_context;

typedef struct {
    char *root;
    char *package;
    bool rebuild;
    bool nodeps;
} plx_args;

plx_context *plx_context_load(plx_args *args);
void plx_context_free(plx_context *ctx);