#include <plx/package.h>
#include <plx/install.h>
#include <stdio.h>
#include <string.h>
#include <dirent.h>
#include <stdlib.h>
#include <unistd.h>
#include <argp.h>

static char doc[] = "pullit package manager";
static char args_doc[] = "[PACKAGE_NAME]";

static struct argp_option options[] = {
    { "root", 'r', "path", 0, "Alternative root filesystem"},
    { "rebuild", 'b', 0, 0, "Rebuild the package"},
    { "no-deps", 'n', 0, 0, "No dependencies"},
    {0}
};

static error_t parse_opt(int key, char *arg, struct argp_state *state) {
    plx_args *arguments = state->input;

    switch(key) {
        case 'r': 
            arguments->root = arg;
            break;
        case 'b': 
            arguments->rebuild = true;
            break;
        case 'n': 
            arguments->nodeps = true;
            break;
        case ARGP_KEY_ARG: 
            arguments->package = arg;
            return 0;
        default:
            return ARGP_ERR_UNKNOWN;
    }

    return 0;
}

static struct argp argp = { options, parse_opt, args_doc, doc, 0, 0, 0 };

int main(int argc, char **argv) {

    plx_args arguments;
    arguments.root = "/";
    arguments.package = "";
    arguments.rebuild = false;
    arguments.nodeps = false;

    printf("Pullinux - Pullit Package Manager v 1.2.0\n\n");

    argp_parse(&argp, argc, argv, 0, 0, &arguments);

    if (!strlen(arguments.package)) {
        printf("Must provide package\n");
        return -1;
    }

    plx_context *ctx = plx_context_load(&arguments);

    package_list pcklist = {0};
    plx_package_load_all(ctx, &pcklist);

    package_list needed = {0};
    plx_package *pck = plx_package_list_find(&pcklist, arguments.package)->pck;

    if (!pck) {
        printf("Package not found! %s\n", arguments.package);
        return -2;
    }

    if (pck->installed && !ctx->rebuild) {
        printf("Package already installed!\n");
        return 0;
    }

    package_list_entry *pcke = plx_package_list_add(&needed, 0, pck, false);

    if (!arguments.nodeps) {
        plx_package_list_add_dependencies(&pcklist, &needed, pcke);
    }

#ifdef DBG_LIST
    printf("List Head: %s\n", needed.head->pck->name);
    printf("List Tail: %s\n", needed.tail->pck->name);

    printf("\n\n\nLIST:\n");

    package_list_entry *l = needed.head;

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

    printf("\n");
#endif

    printf("The following packages will be %s:\n\n    ", ctx->rebuild ? "rebuilt" : "installed");

    package_list_entry *l = needed.head;

    while(l) {
        printf("%s%s", l->pck->name, l->next ? ", " : "\n\n");

        l = l->next;
    }

    printf("Continue? Y/n: ");
    fflush(stdout);

    char sz[32];
    fgets(sz, sizeof(sz) - 1, stdin);

    sz[strlen(sz) - 1] = 0;

    if (!strcmp(sz, "Y") || !strlen(sz)) {
        return plx_install(ctx, &needed);
    } 
    
    printf("Cancelled\n");
    return 1;
}