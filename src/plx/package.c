#include <plx/package.h>
#include <stdio.h>
#include <yaml.h>

typedef enum {
    INIT, KEY, VALUE, DEP, MKDEP, EXTRA
} parser_state;

void str_list_append(str_list *l, char *s) {
    if (!l->str) {
        l->str = strdup(s);
        return;
    }

    while(l) {
        if (!l->next) {
            l->next = malloc(sizeof(str_list));
            l->next->next = 0;
            l->next->str = strdup(s);

            return;
        }

        l = l->next;
    }
}

void set_field_value(plx_package *pck, char *name, char *value) {
    if (!strcmp(name, "name")) {
        pck->name = strdup(value);
    } else if (!strcmp(name, "version")) {
        pck->version = strdup(value);
    } else if (!strcmp(name, "repo")) {
        pck->repo = strdup(value);
    } else if (!strcmp(name, "source")) {
        pck->source = strdup(value);
    } else if (!strcmp(name, "is_group")) {
        pck->is_group = !strcmp(value, "true");
    } else if (!strcmp(name, "deps")) {
        str_list_append(&pck->deps, value);
    } else if (!strcmp(name, "mkdeps")) {
        str_list_append(&pck->mkdeps, value);
    } else if (!strcmp(name, "extras")) {
        str_list_append(&pck->extras, value);
    }
}

plx_package *plx_parse_package(char *filename) {
    FILE *fp = fopen(filename, "r");

    if (!fp) {
        fprintf(stderr, "Failed to open: %s\n", filename);
        return 0;
    }

    yaml_parser_t parser;
    yaml_token_t token;

    if (!yaml_parser_initialize(&parser)) {
        fprintf(stderr, "Failed to init parser\n");
        fclose(fp);
        return 0;
    }

    yaml_parser_set_input_file(&parser, fp);

    plx_package *pck = malloc(sizeof(plx_package));
    memset(pck, 0, sizeof(plx_package));

    parser_state state = INIT;
    char cur_field[32];

    do {
        yaml_parser_scan(&parser, &token);

        switch(token.type) {
            case YAML_KEY_TOKEN: {
                state = KEY;
            } break;

            case YAML_VALUE_TOKEN: {
                state = VALUE;
            }break;

            case YAML_SCALAR_TOKEN: {
                char *data = token.data.scalar.value;
                if (state == KEY) {
                    snprintf(cur_field, sizeof(cur_field) - 1, "%s", data);
                } else if (state == VALUE) {
                    set_field_value(pck, cur_field, data);
                }
            }
        }
    } while(token.type != YAML_STREAM_END_TOKEN);

    fclose(fp);

    return pck;
}

#define IF_FREE(x) if (x) free(x)

void free_list(str_list *l) {
    while(l) {
        IF_FREE(l->str);
        str_list *cur = l;
        l = l->next;

        free(cur);
    }
}

void plx_package_free(plx_package *pck) {
    IF_FREE(pck->name);
    IF_FREE(pck->version);
    IF_FREE(pck->source);
    IF_FREE(pck->repo);
    IF_FREE(pck->deps.str);
    IF_FREE(pck->mkdeps.str);
    IF_FREE(pck->extras.str);

    free_list(pck->deps.next);
    free_list(pck->mkdeps.next);
    free_list(pck->extras.next);
}
