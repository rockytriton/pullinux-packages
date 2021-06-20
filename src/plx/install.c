#include <plx/install.h>
#include <plx/download.h>
#include <plx/build.h>
#include <stdio.h>
#include <libgen.h>
#include <unistd.h>
#include <string.h>
#include <sys/stat.h>
#include <stdlib.h>
#include <sys/mount.h>

int plx_install_package(plx_context *ctx, plx_package *pck) {
    
    if (pck->no_package) {
        char command[1024];
        snprintf(command, sizeof(command) - 1, 
            "mkdir -p %s/usr/share/plx/inst/%c/%s && cp %s/usr/share/plx/repo/%c/%s/.pck %s/usr/share/plx/inst/%c/%s/.pck", 
            ctx->plx_base, *pck->name, pck->name, ctx->plx_base, *pck->name, pck->name, ctx->plx_base, *pck->name, pck->name);
    
        return system(command);
    }

    char fn[1024];
    snprintf(fn, sizeof(fn) - 1, "%s-%s-pullinux-1.2.0.txz", pck->name, pck->version);

    char full_path[1024];
    snprintf(full_path, sizeof(full_path) - 1, "/usr/share/plx/dl-cache/%s", fn);

    //if (!ctx->use_make_deps || access(full_path, F_OK) != 0) {
    if (access(full_path, F_OK) != 0) {
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

            setenv("XORG_PREFIX", "/usr", 1);
            setenv("QT5PREFIX", "/opt/qt5", 1);
            setenv("KF5_PREFIX", "/opt/kf5", 1);

            snprintf(command, sizeof(command) - 1, "cd %s/.install/ && bash -e %s/.install/install.sh", ctx->plx_base, ctx->plx_base);
            ret = system(command);

            if (ret) {
                return ret;
            }

            system("/sbin/ldconfig");
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

    if (!ctx->use_make_deps) {
        snprintf(full_path, sizeof(full_path) - 1, "%s/usr/share/plx/build/%s", ctx->plx_base, fn);
        remove(full_path);
    }

    snprintf(command, sizeof(command) - 1, 
        "mkdir -p %s/usr/share/plx/inst/%c/%s && cp %s/usr/share/plx/repo/%c/%s/.pck %s/usr/share/plx/inst/%c/%s/.pck", 
        ctx->plx_base, *pck->name, pck->name, ctx->plx_base, *pck->name, pck->name, ctx->plx_base, *pck->name, pck->name);
    
    return system(command);
}

int plx_install_old(plx_context *ctx, package_list *list, bool install_rebuild) {
    //start at the tail and work your way back...

    package_list_entry *e = list->tail;

    while(e) {
        printf("%s package: %s\n", ctx->use_make_deps ? "Rebuilding" : "Installing", e->pck->name);

        if (ctx->use_make_deps) {
            if (plx_build_package(ctx, e->pck)) {
                return -3;
            }

            if (!install_rebuild) {
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

bool plx_enter_chroot(plx_context *ctx) {
    if (!strcmp(ctx->plx_base, "/")) {
        return true;
    }

    printf("Binding mounts...\n");

    char sz[1024];
    sprintf(sz, "%s/dev", ctx->plx_base); mount("/dev", sz, 0, MS_BIND, 0);
    sprintf(sz, "%s/dev/pts", ctx->plx_base); mount("/dev/pts", sz, 0, MS_BIND, 0);
    sprintf(sz, "%s/proc", ctx->plx_base); mount("proc", sz, "proc", 0, 0);
    sprintf(sz, "%s/sys", ctx->plx_base); mount("sysfs", sz, "sysfs", 0, 0);
    sprintf(sz, "%s/run", ctx->plx_base); mount("tmpfs", sz, "tmpfs", 0, 0);
    sprintf(sz, "%s/usr/share/plx/dl-cache", ctx->plx_base); mount("/usr/share/plx/dl-cache", sz, 0, MS_BIND, 0);

    printf("\nEntering chroot environment...\n");
    int r = chroot(ctx->plx_base);
    
    if (r) {
        printf("Failed to enter chroot! %d\n", r);
        return false;
    }
    
    free(ctx->plx_base);
    ctx->plx_base = strdup("/");
    ctx->plx_repo_base = strdup("/usr/share/plx/repo");
    chdir("/");

    printf("\nNow in chroot\n");

    return true;
}

bool plx_post_install(plx_context *ctx) {
    if (!strcmp(ctx->plx_base, "/")) {
        printf("\n\nWARN: Installed base in non-chroot\n\n");
        return;
    }

    if (!plx_enter_chroot(ctx)) {
        return false;
    }

    if (system("bash /.postinstall/post_install.sh && rm -rf /.postinstall")) {
        printf("\n\nFailed to do post install!\n");
        return false;
    }

    return true;
}

int plx_install(plx_context *ctx, package_list *list, bool install_rebuild) {
    //start at the tail and work your way back...

    package_list_entry *e = list->head;

    while(e) {
        printf("%s package: %s\n", ctx->use_make_deps ? "Rebuilding" : "Installing", e->pck->name);

        if (ctx->use_make_deps) {
            if (plx_build_package(ctx, e->pck)) {
                return -3;
            }

            if (!install_rebuild) {
                printf("Install new build? Y/n: ");
                fflush(stdout);

                char sz[32];
                fgets(sz, sizeof(sz) - 1, stdin);

                sz[strlen(sz) - 1] = 0;

                if (!strcmp(sz, "Y") || !strlen(sz)) {
                    printf("Installing...\n");
                } else {
                    e = e->next;
                    continue;
                }
            }
        }

        if (plx_install_package(ctx, e->pck)) {
            return -2;
        }

        if (!strcmp(e->pck->name, "base")) {
            //installed base, do post install...
            plx_post_install(ctx);
        }

        e = e->next;
    }

    return 0;
}

