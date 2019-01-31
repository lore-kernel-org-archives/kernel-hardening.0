From: Thomas Garnier <thgarnie@chromium.org>
Subject: [PATCH v6 16/27] compiler: Option to add PROVIDE_HIDDEN replacement for weak symbols
Date: Thu, 31 Jan 2019 11:24:23 -0800
Message-Id: <20190131192533.34130-17-thgarnie@chromium.org>
In-Reply-To: <20190131192533.34130-1-thgarnie@chromium.org>
References: <20190131192533.34130-1-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: kernel-hardening@lists.openwall.com
Cc: kristen@linux.intel.com, Thomas Garnier <thgarnie@chromium.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Thomas Garnier <thgarnie@google.com>, Nicholas Piggin <npiggin@gmail.com>, Sam Ravnborg <sam@ravnborg.org>, Palmer Dabbelt <palmer@sifive.com>, Michael Forney <forney@google.com>, Cao jin <caoj.fnst@cn.fujitsu.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Provide an option to have a PROVIDE_HIDDEN (linker script) entry for
each weak symbol. This option solves an error in x86_64 where the linker
optimizes PIE generated code to be non-PIE because --emit-relocs was used
instead of -pie (to reduce dynamic relocations).

Signed-off-by: Thomas Garnier <thgarnie@chromium.org>
---
 init/Kconfig            |  7 +++++++
 scripts/link-vmlinux.sh | 14 ++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/init/Kconfig b/init/Kconfig
index 116e0de4817f..2261c9891631 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -2104,6 +2104,13 @@ config ASN1
 	  inform it as to what tags are to be expected in a stream and what
 	  functions to call on what tags.
 
+config WEAK_PROVIDE_HIDDEN
+	bool
+	help
+	  Generate linker script PROVIDE_HIDDEN entries for all weak symbols. It
+	  allows to prevent non-PIE code being replaced by the linker if the
+	  emit-relocs option is used instead of PIE (useful for x86_64 PIE).
+
 source "kernel/Kconfig.locks"
 
 config ARCH_HAS_SYNC_CORE_BEFORE_USERMODE
diff --git a/scripts/link-vmlinux.sh b/scripts/link-vmlinux.sh
index bc7f1fc1f55b..abf44a804c79 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -119,6 +119,17 @@ kallsyms()
 	${CC} ${aflags} -c -o ${2} ${afile}
 }
 
+gen_weak_provide_hidden()
+{
+        if [ -n "${CONFIG_WEAK_PROVIDE_HIDDEN}" ]; then
+                local pattern="s/^\s\+ w \(\w\+\)$/PROVIDE_HIDDEN(\1 = .);/gp"
+                echo -e "SECTIONS {\n. = _end;" > .tmp_vmlinux_hiddenld
+                ${NM} ${1} | sed -n "${pattern}" >> .tmp_vmlinux_hiddenld
+                echo "}" >> .tmp_vmlinux_hiddenld
+                LDFLAGS_vmlinux="${LDFLAGS_vmlinux} -T .tmp_vmlinux_hiddenld"
+        fi
+}
+
 # Create map file with all symbols from ${1}
 # See mksymap for additional details
 mksysmap()
@@ -200,6 +211,9 @@ modpost_link vmlinux.o
 # modpost vmlinux.o to check for section mismatches
 ${MAKE} -f "${srctree}/scripts/Makefile.modpost" vmlinux.o
 
+# Generate weak linker script
+gen_weak_provide_hidden vmlinux.o
+
 kallsymso=""
 kallsyms_vmlinux=""
 if [ -n "${CONFIG_KALLSYMS}" ]; then
-- 
2.20.1.495.gaa96b0ce6b-goog
