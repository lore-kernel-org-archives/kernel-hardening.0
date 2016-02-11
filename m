Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 11 Feb 2016 23:36:46 +0100
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160211233646.97c2af3675dc5b0f525f0489@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v2 0/3] Introduce GCC plugin infrastructure
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

Changes from v1:
 * Move the gcc-plugins make target into a separate Makefile because there may
   be a lot of plugins (Suggested-by: Rasmus Villemoes)
 * Simplify the dependencies of the plugin related config option
   (Suggested-by: Kees Cook)
 * Removed the unnecessary example plugin

---
 Documentation/dontdiff            |   1 +
 Documentation/gcc-plugins.txt     |  68 ++++
 Makefile                          |  41 +-
 arch/Kconfig                      |  24 ++
 arch/x86/Kconfig                  |   1 +
 init/Makefile                     |   3 +
 scripts/Makefile.build            |   2 +-
 scripts/Makefile.clean            |   3 +-
 scripts/Makefile.gcc-plugins      |  30 ++
 scripts/Makefile.host             |  69 +++-
 scripts/gcc-plugin.sh             |  51 +++
 scripts/link-vmlinux.sh           |   2 +-
 scripts/package/builddeb          |   1 +
 tools/gcc/Makefile                |  19 +
 tools/gcc/cyc_complexity_plugin.c | 120 ++++++
 tools/gcc/gcc-common.h            | 794 ++++++++++++++++++++++++++++++++++++++
 16 files changed, 1214 insertions(+), 15 deletions(-)
