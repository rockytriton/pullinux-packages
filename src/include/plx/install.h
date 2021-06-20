#pragma once

#include <plx/package.h>

int plx_install(plx_context *ctx, package_list *list, bool install_rebuild);
bool plx_enter_chroot(plx_context *ctx);
