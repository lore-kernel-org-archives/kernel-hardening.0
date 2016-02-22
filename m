Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 22 Feb 2016 20:13:35 +0100
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160222201335.449323716ca4d929f92424d5@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v3 0/3] Introduce GCC plugin infrastructure
To: linux-kbuild@vger.kernel.org
Cc: pageexec@freemail.hu, spender@grsecurity.net, kernel-hardening@lists.openwall.com, mmarek@suse.com, keescook@chromium.org, linux@rasmusvillemoes.dk
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

Emese Revfy (3):
 GCC plugin infrastructure
 Add Cyclomatic complexity plugin
 Documentations of the GCC plugin infrastructre

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
 Documentation/gcc-plugins.txt            |  80 ++++
 Makefile                                 |  41 +-
 arch/Kconfig                             |  24 +
 arch/x86/Kconfig                         |   1 +
 init/Makefile                            |   3 +
 scripts/Makefile.build                   |   2 +-
 scripts/Makefile.clean                   |   3 +-
 scripts/Makefile.gcc-plugins             |  30 ++
 scripts/Makefile.host                    |  69 ++-
 scripts/gcc-plugin.sh                    |  51 ++
 scripts/link-vmlinux.sh                  |   2 +-
 scripts/package/builddeb                 |   1 +
 tools/gcc/Makefile                       |  19 +
 tools/gcc/cyc_complexity_plugin.c        |  70 +++
 tools/gcc/gcc-common.h                   | 794 +++++++++++++++++++++++++++++++
 tools/gcc/gcc-generate-gimple-pass.h     | 172 +++++++
 tools/gcc/gcc-generate-ipa-pass.h        | 286 +++++++++++
 tools/gcc/gcc-generate-rtl-pass.h        | 172 +++++++
 tools/gcc/gcc-generate-simple_ipa-pass.h | 172 +++++++
 20 files changed, 1978 insertions(+), 15 deletions(-)
