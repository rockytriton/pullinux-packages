#include <plx/package.h>
#include <stdio.h>
#include <yaml.h>
#include <stdio.h>
#include <string.h>
#include <dirent.h>
#include <stdlib.h>
#include <unistd.h>
#include <argp.h>

typedef enum {
    INIT, KEY, VALUE, DEP, MKDEP, EXTRA
} parser_state;

u32 plx_package_to_string(plx_package *pck, char *str, u32 max_size) {
    char str_deps[2408];
    char str_mkdeps[2408];
    char str_extras[2408];

    strcpy(str_deps, "");
    strcpy(str_mkdeps, "");
    strcpy(str_extras, "");

    str_list *l = &pck->deps;
    while(l && l->str) {
        strcat(str_deps, "  '");
        strcat(str_deps, l->str);
        strcat(str_deps, "',\n");

        l = l->next;
    }

    l = &pck->mkdeps;
    while(l && l->str) {
        strcat(str_mkdeps, "  '");
        strcat(str_mkdeps, l->str);
        strcat(str_mkdeps, "',\n");

        l = l->next;
    }

    l = &pck->extras;
    while(l && l->str) {
        strcat(str_extras, "  '");
        strcat(str_extras, l->str);
        strcat(str_extras, "',\n");

        l = l->next;
    }

    return snprintf(str, max_size, "name: %s\nversion: %s\nrepo: core\nsource: %s\ndeps: [\n%s\n]\nmkdeps: [\n%s\n]\nextras: [\n%s\n]\n",
        pck->name, pck->version, pck->source, str_deps, str_mkdeps, str_extras);
}

bool plx_package_is_installed(plx_context *ctx, char *name) {
    char full_path[1024];
    snprintf(full_path, sizeof(full_path) - 1, "%s/../inst/%c/%s/.pck", ctx->plx_repo_base, *name, name);

    return access(full_path, F_OK) == 0;
}

plx_package *plx_package_load(plx_context *ctx, char *name) {
    char full_path[1024];
    snprintf(full_path, sizeof(full_path) - 1, "%s/%c/%s/.pck", ctx->plx_repo_base, *name, name);

    plx_package *pck = plx_parse_package(full_path);
    pck->installed = plx_package_is_installed(ctx, name);

    snprintf(full_path, sizeof(full_path) - 1, "%s/%c/%s", ctx->plx_repo_base, *name, name);
    pck->repo_path = strdup(full_path);
    
    return pck;
}

package_list_entry *plx_package_list_find(package_list *list, char *name) {
    package_list_entry *e = list->head;

    while(e) {
        if (!strcmp(e->pck->name, name)) {
            return e;
        }

        e = e->next;
    }

    return 0;
}

package_list_entry *plx_package_list_add(package_list *list, package_list_entry *parent, plx_package *pck) {
    if (!pck) {
        fprintf(stderr, "Invalid Package!\n");
        return 0;
    }

    package_list_entry *child = malloc(sizeof(package_list_entry));
    memset(child, 0, sizeof(package_list_entry));

    if (!parent && !list->head) {
        list->head = list->tail = child;
    }

    child->next = parent;
    child->pck = pck;
    
    if (list->tail != child) {
        list->tail->next = child;
        child->prev = list->tail;
        list->tail = child;
    }

    return child;
}

bool plx_package_load_all(plx_context *ctx, package_list *list) {
    char *base_dirs = "abcdefghijklmnopqrstuvwxyz1234567890";

    char *b = base_dirs;

    while(*b) {
        char full_path[1024];
        snprintf(full_path, sizeof(full_path) - 1, "%s/%c", ctx->plx_repo_base, *b);

        struct dirent *entry;
        DIR *dp = opendir(full_path);

        if (dp) {
            while((entry = readdir(dp))) {
                if (entry->d_name[0] == '.') {
                    continue;
                }

                if (!plx_package_list_add(list, 0, plx_package_load(ctx, entry->d_name))) {
                    return false;
                }
            }

            closedir(dp);
        }

        b++;
    }

    return true;
}

void print_list2(package_list *plst) {
    printf("\n\n\nLIST: %p\n", plst->head);

    package_list_entry *l = plst->head;

    while(l) {
        printf("%s(", l->pck->name);

        if (l->pck->deps.str) {
            str_list *sl = &l->pck->deps;

            while(sl) {
                printf("%s,", sl->str);
                sl = sl->next;
            }
        }

        printf(")->");

        l = l->next;
    }

    printf("\n\n");
}

bool plx_package_list_add_dependencies_from_list(plx_context *ctx, package_list *global_list, package_list *needed, package_list_entry *pcke, str_list *list, char *src, u32 level) {
    if (list && list->str) {
        str_list *l = list;

        while(l && l->str) {
            package_list_entry *e = plx_package_list_find(global_list, l->str);

            if (!e) {
                fprintf(stderr, "Unable to find package: %s...\n", l->str);
                return false;
            }

            plx_package *dep = e->pck;

            if (dep->installed) {
                l = l->next;
                continue;
            }

            if (!strcmp(dep->name, src)) {
                //fprintf(stderr, "Found a cycle: %s\n", src);
                return false;
            }

            package_list_entry *existing = plx_package_list_find(needed, dep->name);

            if (existing) {
                if (existing->prev && existing->next) {
                    //printf("\t%8d  - moving: %s (%s)\n", level, dep->name, src);

                    //print_list2(needed);

                    existing->prev->next = existing->next;
                    existing->next->prev = existing->prev;
                    needed->tail->next = existing;
                    existing->prev = needed->tail;
                    existing->next = 0;
                    needed->tail = existing;
                    //printf("\t  - moved: %s\n", dep->name);

                    if (!plx_package_list_add_dependencies(ctx, global_list, needed, existing, dep->name, level + 1)) {
                        return false;
                    }
                }

            } else {
                package_list_entry *depe = plx_package_list_add(needed, 0, dep);

                if (!depe) {
                    return false;
                }

                if (!plx_package_list_add_dependencies(ctx, global_list, needed, depe, src, level + 1)) {
                    return false;
                }
            }

            l = l->next;
        }

    }

    return true;
}

bool plx_package_list_add_dependencies(plx_context *ctx, package_list *global_list, package_list *needed, package_list_entry *pcke, char *src, u32 level) {
    if (DEBUG) printf("Adding deps for %s\n", pcke->pck->name);
    
    if (!plx_package_list_add_dependencies_from_list(ctx, global_list, needed, pcke, &pcke->pck->deps, src, level + 1)) {
        return false;
    }

    if (ctx->use_make_deps) {
        if (!plx_package_list_add_dependencies_from_list(ctx, global_list, needed, pcke, &pcke->pck->mkdeps, src, level + 1)) {
            return false;
        }
    }

    if (DEBUG) printf("Added deps for %s\n", pcke->pck->name);

    return true;
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
