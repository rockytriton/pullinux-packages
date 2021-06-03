#pragma once

#include <plx/common.h>

/*
name: zstd
version: 1.4.8
repo: core
source: https://github.com/facebook/zstd/releases/download/v1.4.8/zstd-1.4.8.tar.gz
deps: [
  'xz',
]
mkdeps: []
extras: [
]
is_group: false
*/

typedef struct str_list_ {
    char *str;
    struct str_list_ *next;
} str_list;

typedef struct {
    char *name;
    char *version;
    char *repo;
    char *source;
    bool is_group;
    str_list deps;
    str_list mkdeps;
    str_list extras;

    bool installed;
} plx_package;

plx_package *plx_parse_package(char *filename);
void plx_package_free(plx_package *pck);
