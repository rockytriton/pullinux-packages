#include <plx/package.h>
#include <stdio.h>
#include <string.h>
#include <dirent.h>
#include <stdlib.h>
#include <unistd.h>
#include <argp.h>

plx_context *plx_context_load(char *base) {
    plx_context *ctx = malloc(sizeof(plx_context));
    ctx->plx_base = strdup(base);

    if (!ctx->plx_base) {
        ctx->plx_base = strdup("/");
    }

    return ctx;
}

void plx_context_free(plx_context *ctx) {
    free(ctx->plx_base);
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

