MIME-Version: 1.0
Date: Mon, 25 Jun 2018 15:39:04 -0700
In-Reply-To: <20180625224014.134829-1-thgarnie@google.com>
Message-Id: <20180625224014.134829-17-thgarnie@google.com>
References: <20180625224014.134829-1-thgarnie@google.com>
Subject: [PATCH v5 16/27] compiler: Option to add PROVIDE_HIDDEN replacement
 for weak symbols
From: Thomas Garnier <thgarnie@google.com>
Content-Type: text/plain; charset="UTF-8"
To: kernel-hardening@lists.openwall.com
Cc: Thomas Garnier <thgarnie@google.com>, Ingo Molnar <mingo@kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, Thomas Gleixner <tglx@linutronix.de>, Kees Cook <keescook@chromium.org>, "Peter Zijlstra (Intel)" <peterz@infradead.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Randy Dunlap <rdunlap@infradead.org>, Nicholas Piggin <npiggin@gmail.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Provide an option to have a PROVIDE_HIDDEN (linker script) entry for
each weak symbol. This option solves an error in x86_64 where the linker
optimizes PIE generated code to be non-PIE because --emit-relocs was used
instead of -pie (to reduce dynamic relocations).

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 init/Kconfig            |  7 +++++++
 scripts/link-vmlinux.sh | 14 ++++++++++++++
 2 files changed, 21 insertions(+)

diff --git a/init/Kconfig b/init/Kconfig
index d4f90cc38ede..2d7431a8b108 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1974,6 +1974,13 @@ config ASN1
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
index 4bf811c09f59..f5d31119b9d7 100755
--- a/scripts/link-vmlinux.sh
+++ b/scripts/link-vmlinux.sh
@@ -142,6 +142,17 @@ kallsyms()
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
@@ -226,6 +237,9 @@ modpost_link vmlinux.o
 # modpost vmlinux.o to check for section mismatches
 ${MAKE} -f "${srctree}/scripts/Makefile.modpost" vmlinux.o
 
+# Generate weak linker script
+gen_weak_provide_hidden vmlinux.o
+
 kallsymso=""
 kallsyms_vmlinux=""
 if [ -n "${CONFIG_KALLSYMS}" ]; then
-- 
2.18.0.rc2.346.g013aa6912e-goog
