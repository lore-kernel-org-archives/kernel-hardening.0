Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 24 May 2016 00:07:19 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160524000719.b456ed0cd2aafacb4e53f177@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v9 0/4] Introduce GCC plugin infrastructure
To: linux-kbuild@vger.kernel.org
Cc: pageexec@freemail.hu, spender@grsecurity.net, kernel-hardening@lists.openwall.com, mmarek@suse.com, keescook@chromium.org, linux@rasmusvillemoes.dk, fengguang.wu@intel.com, dvyukov@google.com, linux-kernel@vger.kernel.org, david.brown@linaro.org, yamada.masahiro@socionext.com
List-ID: <kernel-hardening.lists.openwall.com>

This patch set introduce the GCC plugin infrastructure with examples for testing
and documentation.

GCC plugins are loadable modules that provide extra features to the compiler.
They are useful for runtime instrumentation and static analysis.

The infrastructure supports all gcc versions from 4.5 to 6.0, building
out-of-tree modules and building in a separate directory. Cross-compilation
is supported too but currently only the x86, arm, arm64 and uml architectures enable plugins.

This infrastructure was ported from grsecurity/PaX. Based on work created by the PaX Team.
It is a CII project supported by the Linux Foundation.

Emese Revfy (4):
 Shared library support
 GCC plugin infrastructure
 Add Cyclomatic complexity plugin
 Add sancov plugin


Changes from v8:
 * Use warnings instead of errors because of allmodconfig/allyesconfig builds
   with old gcc versions
    (Suggested-by: Michal Marek <mmarek@suse.com>)
 * Order HAVE_GCC_PLUGINS alphabetically
 * Moved exported variables from the top level Makefile to scripts/Makefile.gcc-plugins

Changes from v7:
 * Moved the "The GCC plugin infrastructure supports the arm and arm64 architectures too"
   and the "Documentations of the GCC plugin infrastructre" patches
   into the "GCC plugin infrastructure" patch
    (Suggested-by: Masahiro Yamada <yamada.masahiro@socionext.com>)
 * Add gcc-plugin.sh to MAINTAINERS
    (Suggested-by: Masahiro Yamada <yamada.masahiro@socionext.com>)
 * Makefile.host: Remove *shobjs from multi-depend
    (Suggested-by: Masahiro Yamada <yamada.masahiro@socionext.com>)
 * Have distclean and mrproper targets clean the *.so files
    (Suggested-by: Masahiro Yamada <yamada.masahiro@socionext.com>)
 * Simplied gcc-plugin-y to add plugins to HOSTLIBS
    (Suggested-by: Masahiro Yamada <yamada.masahiro@socionext.com>)
 * Simplified Makefile.host
    (Suggested-by: Masahiro Yamada <yamada.masahiro@socionext.com>)
 * Clean *.c.[012]*.*
    (Suggested-by: Michal Marek <mmarek@suse.com>)
 * Documentation: gcc plugins have to compilable as C and C++
 * Enable GCC plugins for UML

Changes from v6:
 * Disable the sancov plugin whenever KCOV_INSTRUMENT is disabled
    (Reported-by: Huang Ying <ying.huang@linux.intel.com>)
 * Disable KCOV/sancov plugin because this is not a regular kernel code
    (Reported-by: Huang Ying <ying.huang@linux.intel.com>)
 * Removed unnecessary gcc plugin cflags
    (Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>)
 * Removed unnecessary gcc plugin aflags

Changes from v5:
 * Set important properties on the external fndecl (Add sancov plugin)
 * Revert documentation change too (Shared library support)
    (Suggested-by: Kees Cook <keescook@chromium.org>)
 * The GCC plugin infrastructure now supports the arm and arm64 architectures too
    (Signed-off-by: David Brown <david.brown@linaro.org>)
 * Simplify the computation of PLUGINCC (GCC plugin infrastructure)
    (Suggested-by: Masahiro Yamada <yamada.masahiro@socionext.com>)
 * Simplify the invocation of gcc-plugin.sh (GCC plugin infrastructure)
    (Suggested-by: Masahiro Yamada <yamada.masahiro@socionext.com>)
 * Make use of multi-depend (Shared library support)
    (Suggested-by: Masahiro Yamada <yamada.masahiro@socionext.com>)
 * Remove unnecessary exports (GCC plugin infrastructure)
    (Suggested-by: Masahiro Yamada <yamada.masahiro@socionext.com>)
 * Simplify Makefile by using addprefix (GCC plugin infrastructure)
    (Suggested-by: Masahiro Yamada <yamada.masahiro@socionext.com>)
 * Moved the gcc plugins from tools/ to scripts/ (GCC plugin infrastructure)
    (Suggested-by: Masahiro Yamada <yamada.masahiro@socionext.com>)
 * Removed plugins from KBUILD_CFLAGS_32 (GCC plugin infrastructure)
 * Remove gcc-plugin target everywhere
    (Suggested-by and partly Written-by: Masahiro Yamada <yamada.masahiro@socionext.com>)
 * There is no leaf gcc attribute in gcc-4.5 (Add sancov plugin)
 * Added support to the sancov plugin with kcov (Add sancov plugin)

Changes from v4:
 * Moved shared library support from the GCC plugin infrastructure patch into
   a different patch
 * Update gcc-*.h from PaX
   * Fixed gcc-common.h for gcc 6
   * Added pass cloning support to the gcc pass generators
 * Disable all plugins in vdso because it is userland code
 * Add sancov gcc plugin: another use case for gcc plugin support in the kernel
   is when there is a feature in the latest gcc version and we would like to use
   it with older gcc versions as well (e.g., distros).

Changes from v3:
 * Fix some indentation related warnings
   (Suggested by checkpatch.pl)
 * Add maintainer entries
 * Don't run gcc_plugin.sh when the GCC_PLUGINS option is disabled or unsupported
   (Reported-by: Fengguang Wu <fengguang.wu@intel.com>)

Changes from v2:
 * Fixed incorrectly encoded characters
 * Generate the GIMPLE, IPA, SIMPLE_IPA and RTL pass structures
   (Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>)
 * Write plugin related warning messages to stderr instead of stdout
   (Suggested-by: Kees Cook <keescook@chromium.org>)
 * Mention the installation of the gcc plugin headers (Documentation)

Changes from v1:
 * Move the gcc-plugins make target into a separate Makefile because there may
   be a lot of plugins (Suggested-by: Rasmus Villemoes)
 * Simplify the dependencies of the plugin related config option
   (Suggested-by: Kees Cook <keescook@chromium.org>)
 * Removed the unnecessary example plugin

---
 .gitignore                                         |   1 +
 Documentation/dontdiff                             |   1 +
 Documentation/gcc-plugins.txt                      |  87 +++
 MAINTAINERS                                        |   9 +
 Makefile                                           |  24 +-
 arch/Kconfig                                       |  36 +
 arch/arm/Kconfig                                   |   1 +
 arch/arm64/Kconfig                                 |   1 +
 arch/um/Kconfig.common                             |   1 +
 arch/x86/Kconfig                                   |   1 +
 arch/x86/entry/vdso/Makefile                       |   3 +-
 arch/x86/purgatory/Makefile                        |   2 +
 lib/Kconfig.debug                                  |   2 +
 scripts/Makefile                                   |   2 +-
 scripts/Makefile.build                             |   2 +-
 scripts/Makefile.clean                             |   4 +-
 scripts/Makefile.gcc-plugins                       |  43 ++
 scripts/Makefile.host                              |  55 +-
 scripts/gcc-plugin.sh                              |  51 ++
 scripts/gcc-plugins/Makefile                       |  27 +
 scripts/gcc-plugins/cyc_complexity_plugin.c        |  73 ++
 scripts/gcc-plugins/gcc-common.h                   | 830 +++++++++++++++++++++
 scripts/gcc-plugins/gcc-generate-gimple-pass.h     | 175 +++++
 scripts/gcc-plugins/gcc-generate-ipa-pass.h        | 289 +++++++
 scripts/gcc-plugins/gcc-generate-rtl-pass.h        | 175 +++++
 scripts/gcc-plugins/gcc-generate-simple_ipa-pass.h | 175 +++++
 scripts/gcc-plugins/sancov_plugin.c                | 144 ++++
 scripts/link-vmlinux.sh                            |   2 +-
 scripts/package/builddeb                           |   1 +
 29 files changed, 2200 insertions(+), 17 deletions(-)
