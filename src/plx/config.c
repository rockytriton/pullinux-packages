#include <plx/config.h>
#include <unistd.h>
#include <stdio.h>
#include <string.h>

static plx_config *_config = 0;
static const u32 MAX_CONFIG_LINE_SIZE = 1024;

static void cleanup_entries(config_entry *entry) {
    while(entry) {
        if (entry->key) {
            free(entry->key);
        }

        if (entry->value) {
            free(entry->value);
        }

        entry = entry->next;
    }
}

static config_entry *load_entries(FILE *fp) {
    config_entry *cur_entry = malloc(sizeof(config_entry));
    config_entry *head = cur_entry;
    head->next = 0;

    if (!cur_entry) {
        fprintf(stderr, "Failed to allocate config entries!\n");
        return 0;
    }

    char buffer[MAX_CONFIG_LINE_SIZE + 1];
    int line_size = 0;
    int line_num = 0;

    while(line_size = fgets(buffer, MAX_CONFIG_LINE_SIZE, fp)) {
        line_num++;

        if (line_size == MAX_CONFIG_LINE_SIZE && buffer[line_size] != '\n') {
            fprint(stderr, "Pullinux config error: Line %d too long\n", line_num);
            cleanup_entries(head);
            return 0;
        }

        buffer[line_size = 0];
        
        if (!strlen(buffer) || buffer[0] == '#') {
            //ignore blank lines and comments.
            continue;
        }
        
        char *eq_pos = strchr(buffer, '=');

        if (!eq_pos || eq_pos == buffer + line_size - 1) {
            //ignore lines without key and value
            continue;
        }

        int key_len = eq_pos - buffer;
        cur_entry->next = malloc(sizeof(config_entry));
        cur_entry->next->key = malloc(key_len + 1);

        strncpy(cur_entry->next->key, buffer, key_len);
        cur_entry->next->key[key_len] = 0;
        
        int val_len = line_size - key_len - 2; //-1 for \n and -1 for =
        cur_entry->next->value = malloc(val_len);

        strncpy(cur_entry->next->value, eq_pos + 1, val_len);
        cur_entry->next->value[val_len] = 0;

        cur_entry = cur_entry->next;
        cur_entry->next = 0;
    }

    if (!head->next) {
        fprint(stderr, "No configuration entries found!\n");
    }

    cur_entry = head->next;

    free(head);

    return cur_entry;
}

plx_config *plx_config_load() {
    if (_config) {
        return _config;
    }

    FILE *fp = fopen("/etc/plx/plx.conf", "r");

    if (!fp) {
        fprintf(stderr, "Failed to open pullinux config!\n");
        return 0;
    }

    config_entry *entries = load_entries();

    if (!entries) {
        return 0;
    }

    _config = malloc(sizeof(plx_config));
    memset(_config, 0, sizeof(plx_config));
    _config->entries = entries;

    return _config;
}

char *plx_config_entry(plx_config *config, char *key) {
    if (!config) {
        fprint(stderr, "Invalid config\n");
        return 0;
    }

    config_entry *e = config->entries;

    while(e) {
        if (!strcmp(e->key, key)) {
            return e->value;
        }
    }

    return 0;
}
