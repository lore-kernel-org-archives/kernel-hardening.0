From: Thomas Garnier <thgarnie@google.com>
Subject: [PATCH v3 24/27] x86/mm: Make the x86 GOT read-only
Date: Wed, 23 May 2018 12:54:18 -0700
Message-Id: <20180523195421.180248-25-thgarnie@google.com>
In-Reply-To: <20180523195421.180248-1-thgarnie@google.com>
References: <20180523195421.180248-1-thgarnie@google.com>
To: Herbert Xu <herbert@gondor.apana.org.au>, "David S . Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Thomas Garnier <thgarnie@google.com>, Philippe Ombredanne <pombredanne@nexb.com>, Kate Stewart <kstewart@linuxfoundation.org>, Arnaldo Carvalho de Melo <acme@redhat.com>, Yonghong Song <yhs@fb.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Kees Cook <keescook@chromium.org>, Tom Lendacky <thomas.lendacky@amd.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Andy Lutomirski <luto@kernel.org>, Dominik Brodowski <linux@dominikbrodowski.net>, Borislav Petkov <bp@alien8.de>, Borislav Petkov <bp@suse.de>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Juergen Gross <jgross@suse.com>, Alok Kataria <akataria@vmware.com>, Steven Rostedt <rostedt@goodmis.org>, Jan Kiszka <jan.kiszka@siemens.com>, Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Dennis Zhou <dennisszhou@gmail.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Alexey Dobriyan <adobriyan@gmail.com>, Masami Hiramatsu <mhiramat@kernel.org>, Cao jin <caoj.fnst@cn.fujitsu.com>, Francis Deslauriers <francis.deslauriers@efficios.com>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Nicolas Pitre <nicolas.pitre@linaro.org>, Andrew Morton <akpm@linux-foundation.org>, Randy Dunlap <rdunlap@infradead.org>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Christopher Li <sparse@chrisli.org>, Jason Baron <jbaron@akamai.com>, Mika Westerberg <mika.westerberg@linux.intel.com>, Lukas Wunner <lukas@wunner.de>, Dou Liyang <douly.fnst@cn.fujitsu.com>, Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Petr Mladek <pmladek@suse.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Ingo Molnar <mingo@kernel.org>, Nicholas Piggin <npiggin@gmail.com>, "H . J . Lu" <hjl.tools@gmail.com>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?q?Radim=20Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, Joerg Roedel <joro@8bytes.org>, David Woodhouse <dwmw@amazon.co.uk>, Dave Hansen <dave.hansen@linux.intel.com>, Rik van Riel <riel@redhat.com>, Jia Zhang <qianyue.zj@alibaba-inc.com>, Ricardo Neri <ricardo.neri-calderon@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Jan Beulich <JBeulich@suse.com>, Matthias Kaehlcke <mka@chromium.org>, Baoquan He <bhe@redhat.com>, =?UTF-8?q?Jan=20H=20=2E=20Sch=C3=B6nherr?= <jschoenh@amazon.de>, Daniel Micay <danielmicay@gmail.com>
Cc: x86@kernel.org, linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, virtualization@lists.linux-foundation.org, xen-devel@lists.xenproject.org, linux-arch@vger.kernel.org, linux-sparse@vger.kernel.org, kvm@vger.kernel.org, linux-doc@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

The GOT is changed during early boot when relocations are applied. Make
it read-only directly. This table exists only for PIE binary.

Position Independent Executable (PIE) support will allow to extended the
KASLR randomization range below the -2G memory limit.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 include/asm-generic/vmlinux.lds.h | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/include/asm-generic/vmlinux.lds.h b/include/asm-generic/vmlinux.lds.h
index e373e2e10f6a..e5b0710fe693 100644
--- a/include/asm-generic/vmlinux.lds.h
+++ b/include/asm-generic/vmlinux.lds.h
@@ -314,6 +314,17 @@
 	__end_ro_after_init = .;
 #endif
 
+#ifdef CONFIG_X86_PIE
+#define RO_GOT_X86							\
+	.got        : AT(ADDR(.got) - LOAD_OFFSET) {			\
+		VMLINUX_SYMBOL(__start_got) = .;			\
+		*(.got);						\
+		VMLINUX_SYMBOL(__end_got) = .;				\
+	}
+#else
+#define RO_GOT_X86
+#endif
+
 /*
  * Read only Data
  */
@@ -370,6 +381,7 @@
 		__end_builtin_fw = .;					\
 	}								\
 									\
+	RO_GOT_X86							\
 	TRACEDATA							\
 									\
 	/* Kernel symbol table: Normal symbols */			\
-- 
2.17.0.441.gb46fe60e1d-goog
