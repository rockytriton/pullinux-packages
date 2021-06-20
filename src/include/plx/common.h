#pragma once

#include <stdint.h>
#include <stdbool.h>

typedef uint32_t u32;
typedef uint16_t u16;
typedef uint8_t u8;

typedef struct str_list_ {
    char *str;
    struct str_list_ *next;
} str_list;

typedef struct {
    char *plx_base;
    char *plx_repo_url;
    char *plx_repo_base;
    bool use_make_deps;
    void *args;
} plx_context;

typedef struct {
    char *root;
    char *package;
    bool rebuild;
    bool nodeps;
    bool install_rebuild;
} plx_args;

plx_context *plx_context_load(void *args, char *root, bool repo_root);
void plx_context_free(plx_context *ctx);

void str_list_append(str_list *l, char *s);
void str_list_copy(str_list *to, str_list *from);
str_list *str_list_from_str(char *str, char *sep);

#define DEBUG 1 
