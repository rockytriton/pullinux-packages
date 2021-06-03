#include <plx/package.h>
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
    {0}
};

struct arguments {
    char *root;
    char *package;
};

static error_t parse_opt(int key, char *arg, struct argp_state *state) {
    struct arguments *arguments = state->input;

    switch(key) {
        case 'r': 
            arguments->root = arg;
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

    struct arguments arguments;
    arguments.root = "/";
    arguments.package = "";

    argp_parse(&argp, argc, argv, 0, 0, &arguments);

    if (!strlen(arguments.package)) {
        printf("Must provide package\n");
        return -1;
    }

    plx_context *ctx = plx_context_load(arguments.root);

    package_list pcklist = {0};
    plx_package_load_all(ctx, &pcklist);

    package_list needed = {0};
    plx_package *pck = plx_package_list_find(&pcklist, arguments.package)->pck;

    if (!pck) {
        printf("Package not found! %s\n", arguments.package);
        return -2;
    }

    package_list_entry *pcke = plx_package_list_add(&needed, 0, pck, false);
    plx_package_list_add_dependencies(&pcklist, &needed, pcke);

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

    if (pck->installed) {
        printf("Package already installed.\n");
        return 0;
    }

}