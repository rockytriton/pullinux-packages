#include <plx/install.h>
#include <plx/download.h>
#include <plx/build.h>
#include <stdio.h>
#include <libgen.h>
#include <unistd.h>
#include <string.h>
#include <sys/sysinfo.h>
#include <sys/stat.h>
#include <stdlib.h>

int plx_build_package(plx_context *ctx, plx_package *pck) {
    if (pck->is_group) {
        return 0;
    }

    char full_path[1024];

    sprintf(full_path, "/usr/share/plx/build/%s-%s-pullinux-1.2.0.txz", pck->name, pck->version);

    if (access(full_path, F_OK) == 0) {
        FILE *fs = fopen(full_path, "r");

        fseek(fs, 0L, SEEK_END);
        size_t size = ftell(fs);
        fclose(fs);

        if (size > 100) {
            printf("Not rebuild, %s already exists.  Delete to rebuild\n", full_path);
            return 0;
        }
    } 

    char *fn = 0;
    if (pck->source) {
        fn = basename(pck->source);
        snprintf(full_path, sizeof(full_path) - 1, "%s/usr/share/plx/dl-cache/%s", ctx->plx_base, fn);

        printf("Downloading %s \n", pck->source);

        if (pck->source && !plx_download_file(pck->source, full_path)) {
            remove(full_path);

            printf("Download failed!\n");

            return -1;
        }
    }

    char build_base[1024];
    char pck_base[1024];
    snprintf(build_base, sizeof(build_base) - 1, "/usr/share/plx/build/build_%s", pck->name);
    snprintf(pck_base, sizeof(pck_base) - 1, "/usr/share/plx/build/build_%s/pckdir", pck->name);

    char command[2048];
    snprintf(command, sizeof(command) - 1, "rm -rf %s && mkdir -p %s && mkdir -p %s", build_base, build_base, pck_base);

    int ret = system(command);

    if (ret) {
        printf("Failed to extract\n");
        return ret;
    }

    if (pck->source) {
        sprintf(command, "mv \"%s\" %s", full_path, build_base);

        ret = system(command);

        if (ret) {
            printf("Failed to move\n");
            return ret;
        }
    }

    snprintf(command, sizeof(command) - 1, "cp %s/.build %s/", pck->repo_path, build_base);

    ret = system(command);

    if (ret) {
        printf("Failed to copy\n");
        return ret;
    }

    snprintf(command, sizeof(command) - 1, "cp -r %s/.install %s/", pck->repo_path, pck_base);

    ret = system(command);

    snprintf(command, sizeof(command) - 1, "cp %s/.pck %s/", pck->repo_path, pck_base);

    ret = system(command);

    if (ret) {
        printf("Failed to copy\n");
        return ret;
    }
    
    if (pck->extras.str) {
        str_list *sl = &pck->extras;

        while(sl) {
            if (strstr(sl->str, "http:") == sl->str || strstr(sl->str, "https:") == sl->str) {
                char sz[1024];
                sprintf(sz, "%s/%s", build_base, basename(sl->str));

                if (!plx_download_file(sl->str, sz)) {
                    printf("Failed to download extra: %s\n", sl->str);
                    return -4;
                }
            } else {
                sprintf(command, "cp %s/%s %s/%s\n", pck->repo_path, sl->str, build_base, sl->str);

                ret = system(command);

                if (ret) {
                    printf("Failed to copy extra: %s\n", sl->str);
                    return ret;
                }
            }

            sl = sl->next;
        }
    }

    setenv("tmpdir", build_base, 1);

    if (pck->source) {
        setenv("filename", fn, 1);
    }

    setenv("pckdir", pck_base, 1);
    setenv("XORG_PREFIX", "/usr", 1);
    setenv("XORG_CONFIG", "--prefix=/usr --sysconfdir=/etc --localstatedir=/var --disable-static", 1);
    setenv("QT5PREFIX", "/opt/qt5", 1);
    setenv("QT5DIR", "/opt/qt5", 1);
    setenv("KF5_PREFIX", "/opt/kf5", 1);

    char sz[64];
    sprintf(sz, "-j%d", get_nprocs());
    setenv("MAKEFLAGS", sz, 1);

    snprintf(command, sizeof(command) - 1, "cd %s && bash -e ./.build", build_base);

    ret = system(command);

    if (ret) {
        printf("Failed to build\n");
        return ret;
    }

    printf("Build completed.\n");
    printf("Packaging...\n");

    snprintf(command, sizeof(command) - 1, "chmod 755 %s", pck_base);

    ret = system(command);

    if (ret) {
        printf("Failed to change package settings\n");
        return ret;
    }

    snprintf(command, sizeof(command) - 1, "tar -cJpf /usr/share/plx/build/%s-%s-pullinux-1.2.0.txz -C %s .", pck->name, pck->version, pck_base);

    ret = system(command);

    if (ret) {
        printf("Failed to package\n");
        return ret;
    }

    printf("Packaging complete: /usr/share/plx/build/%s-%s-pullinux-1.2.0.txz\n", pck->name, pck->version);

    snprintf(command, sizeof(command) - 1, "rm -rf %s", build_base);

    ret = system(command);


    return 0;
}
