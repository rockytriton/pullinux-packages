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

typedef struct package_list_entry_ {
    plx_package *pck;
    struct package_list_entry_ *prev;
    struct package_list_entry_ *next;
} package_list_entry;

typedef struct {
    package_list_entry *head;
    package_list_entry *tail;

} package_list;

plx_package *plx_parse_package(char *filename);
void plx_package_free(plx_package *pck);

bool plx_package_is_installed(plx_context *ctx, char *name);
plx_package *plx_package_load(plx_context *ctx, char *name);
package_list_entry *plx_package_list_find(package_list *list, char *name);
package_list_entry *plx_package_list_add(package_list *list, package_list_entry *parent, plx_package *pck, bool add_deps);
void plx_package_load_all(plx_context *ctx, package_list *list);
void plx_package_list_add_dependencies(package_list *global_list, package_list *needed, package_list_entry *pcke);
