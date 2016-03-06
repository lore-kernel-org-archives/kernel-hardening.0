Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 7 Mar 2016 00:02:08 +0100
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160307000208.1bec3e7dc874489d1b4fcbb4@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v5 0/5] Introduce GCC plugin infrastructure
To: linux-kbuild@vger.kernel.org
Cc: pageexec@freemail.hu, spender@grsecurity.net, kernel-hardening@lists.openwall.com, mmarek@suse.com, keescook@chromium.org, linux@rasmusvillemoes.dk, fengguang.wu@intel.com, dvyukov@google.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

This patch set introduce the GCC plugin infrastructure with examples for testing
and documentation.

GCC plugins are loadable modules that provide extra features to the compiler.
They are useful for runtime instrumentation and static analysis.

The infrastructure supports all gcc versions from 4.5 to 6.0, building
out-of-tree modules and building in a separate directory. Cross-compilation
is supported too but currently only the x86 architecture enables plugins.

This infrastructure was ported from grsecurity/PaX. It is a CII project
supported by the Linux Foundation.

Emese Revfy (5):
 Shared library support
 GCC plugin infrastructure
 Add Cyclomatic complexity plugin
 Documentations of the GCC plugin infrastructre
 Add sancov plugin


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
 Documentation/dontdiff                   |   1 +
 Documentation/gcc-plugins.txt            |  82 ++++++++++++++++++
 MAINTAINERS                              |   8 ++
 Makefile                                 |  41 ++++++---
 arch/Kconfig                             |  36 ++++++++
 arch/x86/Kconfig                         |   1 +
 arch/x86/entry/vdso/Makefile             |   2 +-
 init/Makefile                            |   3 +
 scripts/Makefile.gcc-plugins             |  35 ++++++++
 scripts/gcc-plugin.sh                    |  51 +++++++++++
 scripts/link-vmlinux.sh                  |   2 +-
 scripts/package/builddeb                 |   1 +
 tools/gcc/Makefile                       |  21 +++++
 tools/gcc/cyc_complexity_plugin.c        |  73 ++++++++++++++++
 tools/gcc/gcc-common.h                   | 830 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/gcc/gcc-generate-gimple-pass.h     | 175 ++++++++++++++++++++++++++++++++++++++
 tools/gcc/gcc-generate-ipa-pass.h        | 289 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
 tools/gcc/gcc-generate-rtl-pass.h        | 175 ++++++++++++++++++++++++++++++++++++++
 tools/gcc/gcc-generate-simple_ipa-pass.h | 175 ++++++++++++++++++++++++++++++++++++++
 tools/gcc/sancov_plugin.c                | 133 +++++++++++++++++++++++++++++
 20 files changed, 2121 insertions(+), 13 deletions(-)
