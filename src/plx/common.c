#include <plx/package.h>
#include <stdio.h>
#include <string.h>
#include <dirent.h>
#include <stdlib.h>
#include <unistd.h>
#include <argp.h>

plx_context *plx_context_load(plx_args *args) {
    plx_context *ctx = malloc(sizeof(plx_context));
    ctx->plx_base = strdup(args->root);
    ctx->rebuild = args->rebuild;
    ctx->plx_repo_url = strdup("https://github.com/rockytriton/pullinux-packages/releases/download/1.2.0.2/");

    return ctx;
}

void plx_context_free(plx_context *ctx) {
    free(ctx->plx_base);
    free(ctx->plx_repo_url);
    free(ctx);
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

