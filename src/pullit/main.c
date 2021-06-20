#include <plx/package.h>
#include <plx/install.h>
#include <stdio.h>
#include <string.h>
#include <dirent.h>
#include <stdlib.h>
#include <unistd.h>
#include <argp.h>

#include <signal.h>
#include <stdlib.h>
#include <stdio.h>
#include <unistd.h>
#include <sys/mount.h>

static char doc[] = "pullit package manager";
static char args_doc[] = "[PACKAGE_NAME]";

static struct argp_option options[] = {
    { "root", 'r', "path", 0, "Alternative root filesystem"},
    { "rebuild", 'b', 0, 0, "Rebuild the package"},
    { "rebuild-install", 'i', 0, 0, "Install Rebuilt the package"},
    { "no-deps", 'n', 0, 0, "No dependencies"},
    {0}
};

static plx_context *ctx;

static error_t parse_opt(int key, char *arg, struct argp_state *state) {
    plx_args *arguments = state->input;

    switch(key) {
        case 'r': 
            arguments->root = arg;
            break;
        case 'b': 
            arguments->rebuild = true;
            break;
        case 'i': 
            arguments->install_rebuild = true;
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

bool ensure_installed(plx_context *ctx, package_list *global_list, package_list *needed, char *pckname) {
    package_list_entry *fpe = plx_package_list_find(global_list, pckname);

    if (!fpe) {
        return false;
    }

    plx_package *pck = fpe->pck;

    if (pck->installed) {
        return true;
    }

    if (!plx_package_list_add_deps_new(ctx, global_list, needed, pck->name)) {
        return false;
    }

    package_list_entry *pcke = plx_package_list_add(needed, 0, pck);

    if (!pcke) {
        return false;
    }

    return true;
}

void cleanup_bind_mounts() {
    char sz[1024];
    printf("Unbinding mounts...\n");
    sprintf(sz, "%s/dev/pts", ctx->plx_base); umount(sz);
    sprintf(sz, "%s/dev", ctx->plx_base); umount(sz);
    sprintf(sz, "%s/proc", ctx->plx_base); umount(sz);
    sprintf(sz, "%s/sys", ctx->plx_base); umount(sz);
    sprintf(sz, "%s/run", ctx->plx_base); umount(sz);
    sprintf(sz, "%s/usr/share/plx/dl-cache", ctx->plx_base); umount(sz);
}

void handle_close(int n) {
    cleanup_bind_mounts();
    exit(-1);
}

int main(int argc, char **argv) {

    struct sigaction sigIntHandler;

    sigIntHandler.sa_handler = handle_close;
    sigemptyset(&sigIntHandler.sa_mask);
    sigIntHandler.sa_flags = 0;

    sigaction(SIGINT, &sigIntHandler, NULL);

    plx_args arguments;
    arguments.root = "/";
    arguments.package = "";
    arguments.rebuild = false;
    arguments.install_rebuild = false;
    arguments.nodeps = false;

    printf("Pullinux - Pullit Package Manager v 1.2.0\n\n");

    argp_parse(&argp, argc, argv, 0, 0, &arguments);

    if (!strlen(arguments.package)) {
        printf("Must provide package\n");
        return -1;
    }

    if (DEBUG) printf("Loading...\n");

    ctx = plx_context_load(&arguments, arguments.root, false);

    if (arguments.rebuild) {
        ctx->use_make_deps = true;
    }

    if (DEBUG) printf("Loading all...\n");

    package_list pcklist = {0};
    if (!plx_package_load_all(ctx, &pcklist)) {
        return -1;
    }

    if (DEBUG) printf("Finding...\n");

    package_list needed = {0};
    package_list_entry *fpe = plx_package_list_find(&pcklist, arguments.package);

    if (!fpe) {
        printf("Package not Found\n");
        return -1;
    }

    plx_package *pck = fpe->pck;

    if (DEBUG) printf("Found package\n");

    if (!pck) {
        printf("Package not found! %s\n", arguments.package);
        return -2;
    }

    if (pck->installed && !arguments.rebuild) {
        printf("Package already installed!\n");
        return 0;
    }

    if (!ensure_installed(ctx, &pcklist, &needed, "base-fs")) {
        return -1;
    }

    if (!ensure_installed(ctx, &pcklist, &needed, "base")) {
        return -1;
    }

    fpe = plx_package_list_find(&pcklist, "base");

    if (fpe->pck->installed) {
        if (!plx_enter_chroot(ctx)) {
            return -1;
        }
    }

    fpe = plx_package_list_find(&needed, arguments.package);
    
    if (!fpe) {

        if (!arguments.nodeps) {
            printf("Adding deps...\n");
            if (!plx_package_list_add_deps_new(ctx, &pcklist, &needed, pck->name)) {
                return -1;
            }
        }

        package_list_entry *pcke = plx_package_list_add(&needed, 0, pck);

        if (!pcke) {
            return -1;
        }
    }

    if (DEBUG) printf("added to list\n");

    printf("The following packages will be %s:\n\n    ", arguments.rebuild ? "rebuilt" : "installed");

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

    int n = 1;

    if (!strcmp(sz, "Y") || !strlen(sz)) {
        n = plx_install(ctx, &needed, arguments.install_rebuild);
    }

    cleanup_bind_mounts();
    
    return n;
}
