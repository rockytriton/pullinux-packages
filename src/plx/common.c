#include <plx/package.h>
#include <stdio.h>
#include <string.h>
#include <dirent.h>
#include <stdlib.h>
#include <unistd.h>
#include <argp.h>

char *repo_base = "/src/pullinux-1.2.0/git/pullinux-packages/repo/";
char *inst_base = "/src/pullinux-1.2.0/plx/inst/";

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


bool is_package_installed(char *name) {
    char full_path[1024];
    snprintf(full_path, sizeof(full_path) - 1, "%s%c/%s/.pck", repo_base, *name, name);

    return access(full_path, F_OK) == 0;
}

plx_package *load_package(char *name) {
    char full_path[1024];
    snprintf(full_path, sizeof(full_path) - 1, "%s%c/%s/.pck", repo_base, *name, name);
    printf("LOADING PACKAGE: %s", full_path);

    plx_package *pck = plx_parse_package(full_path);
    pck->installed = is_package_installed(name);

    printf("       %s\n", pck->installed ? "INSTALLED" : "");

    return pck;
}

package_list_entry *find_package_in_list(package_list *list, char *name) {
    package_list_entry *e = list->head;

    while(e) {
        if (!strcmp(e->pck->name, name)) {
            return e;
        }

        e = e->next;
    }

    return 0;
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

package_list_entry *package_list_add(package_list *list, package_list_entry *parent, plx_package *pck, bool add_deps) {
    if (!pck) {
        fprintf(stderr, "Invalid Package!\n");
        exit(-1);
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


void load_all_packages(package_list *list) {
    char *base_dirs = "abcdefghijklmnopqrstuvwxyz1234567890";

    char *b = base_dirs;

    while(*b) {
        char full_path[1024];
        snprintf(full_path, sizeof(full_path) - 1, "%s%c", repo_base, *b);

        struct dirent *entry;
        DIR *dp = opendir(full_path);

        if (dp) {
            while((entry = readdir(dp))) {
                if (entry->d_name[0] == '.') {
                    continue;
                }

                package_list_add(list, 0, load_package(entry->d_name), false);
            }
            closedir(dp);
        }

        b++;
    }
}

void add_dependencies(package_list *global_list, package_list *needed, package_list_entry *pcke) {
    if (pcke->pck->deps.str) {
        str_list *l = &pcke->pck->deps;

        while(l) {
            package_list_entry *e = find_package_in_list(global_list, l->str);

            if (!e) {
                printf("Unable to find package...\n");
                l = l->next;
                continue;
            }

            plx_package *dep = e->pck;

            package_list_entry *existing = find_package_in_list(needed, dep->name);

            if (existing) {
                if (existing->prev) {
                    existing->prev->next = existing->next;
                    existing->next->prev = existing->prev;
                    needed->tail->next = existing;
                    existing->prev = needed->tail;
                    existing->next = 0;
                    needed->tail = existing;

                    add_dependencies(global_list, needed, existing);
                }

            } else {
                package_list_entry *depe = package_list_add(needed, 0, dep, false);
                add_dependencies(global_list, needed, depe);
            }

            l = l->next;
        }
    }
}

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

    argp_parse(&argp, argc, argv, 0, 0, &arguments);

    printf("ROOT: %s\n", arguments.root);
    printf("PCK : %s\n", arguments.package);

    if (argc > 0) {
        return 0;
    }

    package_list pcklist = {0};
    load_all_packages(&pcklist);

    printf("\n\n");
    printf("List Head: %s\n", pcklist.head->pck->name);
    printf("List Tail: %s\n", pcklist.tail->pck->name);

    printf("\n\nLoading Base package:\n");

    package_list needed = {0};
    plx_package *pck = find_package_in_list(&pcklist, "base")->pck;

    printf("Foudn base: %s - %p\n", pck->name, pck);

    package_list_entry *pcke = package_list_add(&needed, 0, pck, false);
    add_dependencies(&pcklist, &needed, pcke);

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

    //package_list_add(&pcklist, 0, load_package("base"), true);

/*
    plx_package *pck = plx_parse_package("/src/pullinux-1.2.0/git/pullinux-packages/repo/g/glibc/.pck");

    printf("\n\n\nPackage:\n");
    printf("\tname: %s\n", pck->name);
    printf("\tversion: %s\n", pck->version);
    printf("\tsource: %s\n", pck->source);
    printf("\trepo: %s\n", pck->repo);
    printf("\tis_group: %d\n", pck->is_group);

    printf("\tdeps:\n");

    str_list *l = &pck->deps;

    while(l) {
        if (l->str) {
            printf("\t\t- %s\n", l->str);
        }

        l = l->next;
    }

    printf("\tmkdeps:\n");

    l = &pck->mkdeps;

    while(l) {
        if (l->str) {
            printf("\t\t- %s\n", l->str);
        }

        l = l->next;
    }

    printf("\textras:\n");

    l = &pck->extras;

    while(l) {
        if (l->str) {
            printf("\t\t- %s\n", l->str);
        }

        l = l->next;
    }

    printf("\n");

    plx_package_free(pck);
*/

}