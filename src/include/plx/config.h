#pragma once

#include <plx/common.h>

typedef struct _config_entry {
    char *key;
    char *value;
    struct _config_entry *next;
} config_entry;

typedef struct {
    config_entry *config_entries;
} plx_config;

plx_config *plx_config_load();

char *plx_config_entry(plx_config *config, char *key);
