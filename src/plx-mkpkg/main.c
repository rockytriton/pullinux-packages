#include <plx/package.h>
#include <stdio.h>
#include <string.h>
#include <dirent.h>
#include <stdlib.h>
#include <unistd.h>
#include <argp.h>
#include <libgen.h>
#include <errno.h>

static char doc[] = "Pullinux Package Creator";
static char args_doc[] = "";

static struct argp_option options[] = {
    { "root", 'r', "path", 0, "Alternative root filesystem"},
    { "url", 'u', "url", 0, "Source URL"},
    { "package-name", 'p', "name", 0, "Package name"},
    { "version", 'v', "version", 0, "Version number"},
    { "deps", 'd', "dep name", 0, "dependencies list"},
    { "mkdeps", 'm',"mkdep name", 0, "make dependencies list"},
    { "extras", 'e', "extra name", 0, "extras list"},
    { "is-ninja", 'n', 0, 0, "is ninja build"},
    { "is-cmake", 'c', 0, 0, "is cmake build"},
    { "is-xwin", 'x', 0, 0, "is x windows package"},
    { "is-kde", 'k', 0, 0, "is kde package"},
    { "with-docs", 'w', 0, 0, "include docs pages"},
    { "with-install", 'i', 0, 0, "include install script"},
    {0}
};

typedef enum {
    AS_DEP,
    AS_MKDEP,
    AS_EXTRAS
} arg_state;

typedef struct {
    char *root;
    plx_package pck;
    arg_state arg_state;

    bool is_ninja;
    bool is_cmake;
    bool is_x;
    bool is_kde;
    bool doc_install;
    bool with_install;
    
} mkpkg_args;

static error_t parse_opt(int key, char *arg, struct argp_state *state) {
    mkpkg_args *arguments = state->input;
    str_list *l;

    switch(key) {
        case 'r': 
            arguments->root = arg;
            break;
        case 'u': 
            arguments->pck.source = arg;
            break;
        case 'p': 
            arguments->pck.name = arg;
            break;
        case 'v': 
            arguments->pck.version = arg;
            break;
        case 'n': 
            arguments->is_ninja = true;
            break;
        case 'c': 
            arguments->is_cmake = true;
            break;
        case 'x': 
            arguments->is_x = true;
            break;
        case 'k': 
            arguments->is_kde = true;
            break;
        case 'w': 
            arguments->doc_install = true;
            break;
        case 'i': 
            arguments->with_install = true;
            break;

        case 'd':
            arguments->arg_state = AS_DEP;
            l = str_list_from_str(arg, ",");
            str_list_copy(&arguments->pck.deps, l);
            break;

        case 'e':
            arguments->arg_state = AS_MKDEP;
            l = str_list_from_str(arg, ",");
            str_list_copy(&arguments->pck.mkdeps, l);
            break;

        case 'm':
            arguments->arg_state = AS_EXTRAS;
            l = str_list_from_str(arg, ",");
            str_list_copy(&arguments->pck.extras, l);
            break;

        case ARGP_KEY_ARG: {
            switch(arguments->arg_state) {
                case AS_DEP:
                    str_list_append(&arguments->pck.deps, arg);
                    break;
                case AS_MKDEP:
                    str_list_append(&arguments->pck.mkdeps, arg);
                    break;
                case AS_EXTRAS:
                    str_list_append(&arguments->pck.extras, arg);
                    break;
                default:
                    printf("UNKNOWN STATE\n");
                    exit(-1);
            }
        } break;

        default:
            return ARGP_ERR_UNKNOWN;
    }

    return 0;
}

static struct argp argp = { options, parse_opt, args_doc, doc, 0, 0, 0 };

bool load_pck_from_source(mkpkg_args *arguments) {
    char filename[1024];
    strcpy(filename, basename(arguments->pck.source));

    char *end = strstr(filename, ".t");

    if (!end) {
        printf("Unable to determine package name and version\n");
        return false;
    }

    *end = 0;

    printf("Package Name-Ver: %s\n", filename);

    end = strrchr(filename, '-');

    if (!end) {
        printf("Unable to determine package name and version\n");
        return false;
    }

    char *ver = end + 1;
    *end = 0;

    printf("Package Name: %s\n", filename);
    printf("Package Vers: %s\n", ver);

    arguments->pck.name = strdup(filename);
    arguments->pck.version = strdup(ver);

    return true;
}

char *get_template_name(mkpkg_args *args) {
    if (args->is_ninja) {
        return "build_ninja.sh";
    }
    if (args->is_x) {
        return "build_xwin.sh";
    }
    if (args->is_kde) {
        return "build_kde.sh";
    }
    if (args->is_cmake) {
        return "build_cmake.sh";
    }
    if (args->doc_install) {
        return "build_wdoc.sh";
    }

    return "build.sh";
}

int main(int argc, char **argv) {

    mkpkg_args arguments = {0};

    printf("Pullinux - Pullinux Package Creator v 1.2.0\n\n");

    argp_parse(&argp, argc, argv, 0, 0, &arguments);

    if (!arguments.root) {
        arguments.root = "/usr/share/plx/repo";
        char *root = getenv("PLX_REPO");

        if (root) {
            arguments.root = root;
        }
    } 

    plx_context *ctx = plx_context_load(&arguments, arguments.root, true);

    package_list pcklist = {0};
    if (!plx_package_load_all(ctx, &pcklist)) {
        return -1;
    }

    if (DEBUG) printf("Finding...\n");

    printf("Using Pullinux root: %s\n", arguments.root);

    if (!arguments.pck.name) {
        if (!arguments.pck.source) {
            printf("Must provide URL or name\n");
            return -1;
        }

        if (!load_pck_from_source(&arguments)) {
            return -1;
        }    
    }

    package_list needed = {0};
    package_list_entry *fpe = plx_package_list_find(&pcklist, arguments.pck.name);

    if (fpe) {
        printf("Package already exists!\n");
        return -1;
    }

    for (str_list *l = &arguments.pck.deps; l != 0 && l->str; l = l->next) {
        if (!plx_package_list_find(&pcklist, l->str)) {
            printf("WARNING: Dependency doesn't exist: %s\n", l->str);
        }
    }

    for (str_list *l = &arguments.pck.mkdeps; l != 0 && l->str; l = l->next) {
        if (!plx_package_list_find(&pcklist, l->str)) {
            printf("WARNING: Make Dependency doesn't exist: %s\n", l->str);
        }
    }

    char sz[4096];
    plx_package_to_string(&arguments.pck, sz, sizeof(sz));

    printf("Package Contents:\n");
    printf(sz);

    printf("Saving...\n");

    char filename[1024];
    sprintf(filename, "%s/%c/", arguments.root, arguments.pck.name[0]);

    mkdir(filename, 0755);
    sprintf(filename, "%s/%c/%s/", arguments.root, arguments.pck.name[0], arguments.pck.name);

    mkdir(filename, 0755);

    sprintf(filename, "%s/%c/%s/.pck", arguments.root, arguments.pck.name[0], arguments.pck.name);
    FILE *fp = fopen(filename, "w");

    if (!fp) {
        printf("FATAL: Unable to open file: %s - %d\n", filename, errno);
        return -1;
    }

    fwrite(sz, strlen(sz), 1, fp);

    fclose(fp);

    char command[2048];

    printf("Wrote data\n");

    if (arguments.with_install) {
        sprintf(filename, "%s/%c/%s/.install", arguments.root, arguments.pck.name[0], arguments.pck.name);
        mkdir(filename, 0755);

        sprintf(command, "touch %s/%c/%s/.install/install.sh", arguments.root, arguments.pck.name[0], arguments.pck.name);

        if (system(command)) {
            printf("Failed to create install script\n");
            return -1;
        }
    }

    printf("Getting template\n");

    char *t = get_template_name(&arguments);

    sprintf(command, "cp %s/../templates/%s %s/%c/%s/.build", arguments.root, t, arguments.root,
                arguments.pck.name[0], arguments.pck.name);
    
    printf("Copying build\n");

    if (system(command)) {
        printf("Failed to create template\n");
        return -1;
    }

    sprintf(command, "vi %s/%c/%s/.build", arguments.root, arguments.pck.name[0], arguments.pck.name);

    if (system(command)) {
        printf("Failed to create open script\n");
        return -1;
    }

    printf("%s/%c/%s/.pck\n", arguments.root, arguments.pck.name[0], arguments.pck.name);
    printf("%s/%c/%s/.build\n", arguments.root, arguments.pck.name[0], arguments.pck.name);

    if (arguments.with_install) {
        printf("%s/%c/%s/.install/install.sh\n", arguments.root, arguments.pck.name[0], arguments.pck.name);
    }

    printf("Done\n");
}
