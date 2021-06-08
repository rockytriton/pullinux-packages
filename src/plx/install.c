#include <plx/install.h>
#include <plx/download.h>
#include <plx/build.h>
#include <stdio.h>
#include <libgen.h>
#include <unistd.h>
#include <string.h>
#include <sys/stat.h>
#include <stdlib.h>

int plx_install_package(plx_context *ctx, plx_package *pck) {
    if (pck->is_group) {
        return 0;
    }

    char fn[1024];
    snprintf(fn, sizeof(fn) - 1, "%s-%s-pullinux-1.2.0.txz", pck->name, pck->version);

    char full_path[1024];
    snprintf(full_path, sizeof(full_path) - 1, "%s/tmp/%s", ctx->plx_base, fn);

    if (!ctx->rebuild || access(full_path, F_OK) != 0) {
        char repo_url[1024];
        snprintf(repo_url, sizeof(repo_url) - 1, "%s/%s", ctx->plx_repo_url, fn);

        printf("Downloading %s \n", repo_url);

        if (!plx_download_file(repo_url, full_path)) {
            remove(full_path);

            printf("Download failed!\n");

            return -1;
        }
    }

    system("rm -rf /.install");

    char command[2048];
    sprintf(command, "tar -xhf \"%s\" -C %s", full_path, ctx->plx_base);

    int ret = system(command);

    if (ret) {
        printf("Failed to extract\n");
        return ret;
    }

    snprintf(full_path, sizeof(full_path) - 1, "%s/.install", ctx->plx_base);

    bool on_root = !strcmp(ctx->plx_base, "/");

    if (on_root) {
        if (access(full_path, F_OK) == 0) {
            printf("Running installer...\n");
            snprintf(command, sizeof(command) - 1, "cd %s/.install/ && bash -e %s/.install/install.sh", ctx->plx_base, ctx->plx_base);
            ret = system(command);

            if (ret) {
                return ret;
            }

            system("ldconfig");
        }
    } else if (access(full_path, F_OK) == 0) {
        printf("Appending post install...\n");

        char sz[1024];
        snprintf(sz, sizeof(sz) - 1, "%s/.postinstall/", ctx->plx_base);

        if (access(sz, F_OK) != 0) {
            mkdir(sz, 0755);
        }

        snprintf(sz, sizeof(sz) - 1, "%s/.postinstall/%s", ctx->plx_base, pck->name);
        mkdir(sz, 0755);

        snprintf(full_path, sizeof(full_path) - 1, "%s/.postinstall/%s/.install", ctx->plx_base, pck->name);

        if (access(full_path, F_OK) == 0) {
            printf("\n\nWARNING: DIR EXISTS!\n\n");
            sprintf(command, "rm -rf %s", full_path);
            system(command);
        }

        snprintf(full_path, sizeof(full_path) - 1, "%s/.install", ctx->plx_base);

        snprintf(command, sizeof(command) - 1, "mv %s/.install %s/.postinstall/%s/", ctx->plx_base, ctx->plx_base, pck->name);

        ret = system(command);

        if (ret) {
            return ret;
        }

        snprintf(full_path, sizeof(full_path) - 1, "%s/.postinstall/post_install.sh", ctx->plx_base);

        snprintf(sz, sizeof(sz) - 1, "/.postinstall/%s", pck->name);
        snprintf(command, sizeof(command) - 1, "echo \"cd %s/.install && bash -e %s/.install/install.sh\" >> \"%s\"", sz, sz, full_path);

        ret = system(command);

        if (ret) {
            return ret;
        }
    }

    if (!ctx->rebuild) {
        snprintf(full_path, sizeof(full_path) - 1, "%s/tmp/%s", ctx->plx_base, fn);
        remove(full_path);
    }

    snprintf(command, sizeof(command) - 1, 
        "mkdir -p %s/usr/share/plx/inst/%c/%s && cp %s/usr/share/plx/repo/%c/%s/.pck %s/usr/share/plx/inst/%c/%s/.pck", 
        ctx->plx_base, *pck->name, pck->name, ctx->plx_base, *pck->name, pck->name, ctx->plx_base, *pck->name, pck->name);
    
    return system(command);
}

int plx_install(plx_context *ctx, package_list *list) {
    //start at the tail and work your way back...

    package_list_entry *e = list->tail;

    while(e) {
        printf("%s package: %s\n", ctx->rebuild ? "Rebuilding" : "Installing", e->pck->name);

        if (ctx->rebuild) {
            if (plx_build_package(ctx, e->pck)) {
                return -3;
            }

            if (!ctx->install_rebuild) {
                printf("Install new build? Y/n: ");
                fflush(stdout);

                char sz[32];
                fgets(sz, sizeof(sz) - 1, stdin);

                sz[strlen(sz) - 1] = 0;

                if (!strcmp(sz, "Y") || !strlen(sz)) {
                    printf("Installing...\n");
                } else {
                    e = e->prev;
                    continue;
                }
            }
        }

        if (plx_install_package(ctx, e->pck)) {
            return -2;
        }

        e = e->prev;
    }

    return 0;
}

