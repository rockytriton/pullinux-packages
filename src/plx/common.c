#include <plx/package.h>
#include <stdio.h>
#include <string.h>
#include <dirent.h>
#include <stdlib.h>
#include <unistd.h>
#include <argp.h>

plx_context *plx_context_load(void *args, char *root, bool repo_root) {
    plx_context *ctx = malloc(sizeof(plx_context));
    ctx->plx_base = strdup(root);
    
    if (repo_root) {
        ctx->plx_repo_base = strdup(root);
    } else {
        ctx->plx_repo_base = malloc(1024);
        sprintf(ctx->plx_repo_base, "%s/usr/share/plx/repo", root);
    }

    ctx->args = args;
    ctx->use_make_deps = false;
    ctx->plx_repo_url = strdup("https://github.com/rockytriton/pullinux-packages/releases/download/1.2.0.2/");

    return ctx;
}

void plx_context_free(plx_context *ctx) {
    free(ctx->plx_base);
    free(ctx->plx_repo_url);
    free(ctx);
}

void str_list_copy(str_list *to, str_list *from) {
    to->str = strdup(from->str);

    str_list *lf = from->next;
    str_list *lt = to;

    while(lf) {
        lt = malloc(sizeof(str_list));
        to->next = lt;
        lt->str = strdup(lf->str);
        to = lt;

        lf = lf->next;
    }
}

str_list *str_list_from_str(char *str, char *sep) {
    if (!str || strlen(str) < 1) {
        return 0;
    }

    str_list *list = malloc(sizeof(str_list));
    str_list *head = list;
    list->next = 0;
    char *tok = strdup(strtok(str, sep));

    while(tok) {
        list->str = tok;

        tok = strtok(NULL, sep);

        if (!tok) {
            break;
        }

        str_list *next = malloc(sizeof(str_list));
        next->next = 0;
        next->str = 0;
        list->next = next;

        list = next;
    }

    return head;
}

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

void print_list(package_list *needed) {
    package_list_entry *l = needed->head;

    while(l) {
        printf("%s([%s][%s]", l->pck->name, l->prev ? l->prev->pck->name : "0", l->next ? l->next->pck->name : "0");

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

    printf("\n");
}

