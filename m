From: Thomas Garnier <thgarnie@google.com>
Date: Wed, 22 Mar 2017 13:38:31 -0700
Message-Id: <20170322203834.67556-1-thgarnie@google.com>
Subject: [kernel-hardening] [PATCH v4 1/4] syscalls: Restore address limit after a syscall
To: Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dave Hansen <dave.hansen@intel.com>, David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>, Thomas Garnier <thgarnie@google.com>, =?UTF-8?q?Ren=C3=A9=20Nyffenegger?= <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Stephen Smalley <sds@tycho.nsa.gov>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andy Lutomirski <luto@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>, Kees Cook <keescook@chromium.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Russell King <linux@armlinux.org.uk>, Vladimir Murzin <vladimir.murzin@arm.com>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>
Cc: linux-s390@vger.kernel.org, linux-kernel@vger.kernel.org, linux-api@vger.kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This patch ensures a syscall does not return to user-mode with a kernel
address limit. If that happened, a process can corrupt kernel-mode
memory and elevate privileges.

For example, it would mitigation this bug:

- https://bugs.chromium.org/p/project-zero/issues/detail?id=990

If the CONFIG_BUG_ON_DATA_CORRUPTION option is enabled, an incorrect
state will result in a BUG_ON.

The CONFIG_ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE option is also
added so each architecture can optimize this change.

Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
Based on next-20170322
---
 arch/s390/Kconfig        |  1 +
 include/linux/syscalls.h | 18 +++++++++++++++++-
 init/Kconfig             |  7 +++++++
 kernel/sys.c             |  8 ++++++++
 4 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/arch/s390/Kconfig b/arch/s390/Kconfig
index a2dcef0aacc7..b73f5b87bc99 100644
--- a/arch/s390/Kconfig
+++ b/arch/s390/Kconfig
@@ -103,6 +103,7 @@ config S390
 	select ARCH_INLINE_WRITE_UNLOCK_BH
 	select ARCH_INLINE_WRITE_UNLOCK_IRQ
 	select ARCH_INLINE_WRITE_UNLOCK_IRQRESTORE
+	select ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE
 	select ARCH_SAVE_PAGE_KEYS if HIBERNATION
 	select ARCH_SUPPORTS_ATOMIC_RMW
 	select ARCH_SUPPORTS_NUMA_BALANCING
diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index 980c3c9b06f8..e659076adf6c 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -191,6 +191,19 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	SYSCALL_METADATA(sname, x, __VA_ARGS__)			\
 	__SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
 
+asmlinkage void verify_pre_usermode_state(void);
+
+#ifndef CONFIG_ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE
+#define __CHECK_USER_CALLER() \
+	bool user_caller = segment_eq(get_fs(), USER_DS)
+#define __VERIFY_PRE_USERMODE_STATE() \
+	if (user_caller) verify_pre_usermode_state()
+#else
+#define __CHECK_USER_CALLER()
+#define __VERIFY_PRE_USERMODE_STATE()
+#endif
+
+
 #define __PROTECT(...) asmlinkage_protect(__VA_ARGS__)
 #define __SYSCALL_DEFINEx(x, name, ...)					\
 	asmlinkage long sys##name(__MAP(x,__SC_DECL,__VA_ARGS__))	\
@@ -199,7 +212,10 @@ extern struct trace_event_functions exit_syscall_print_funcs;
 	asmlinkage long SyS##name(__MAP(x,__SC_LONG,__VA_ARGS__));	\
 	asmlinkage long SyS##name(__MAP(x,__SC_LONG,__VA_ARGS__))	\
 	{								\
-		long ret = SYSC##name(__MAP(x,__SC_CAST,__VA_ARGS__));	\
+		long ret;						\
+		__CHECK_USER_CALLER();					\
+		ret = SYSC##name(__MAP(x,__SC_CAST,__VA_ARGS__));	\
+		__VERIFY_PRE_USERMODE_STATE();				\
 		__MAP(x,__SC_TEST,__VA_ARGS__);				\
 		__PROTECT(x, ret,__MAP(x,__SC_ARGS,__VA_ARGS__));	\
 		return ret;						\
diff --git a/init/Kconfig b/init/Kconfig
index c859c993c26f..c4efc3a95e4a 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -1929,6 +1929,13 @@ config PROFILING
 config TRACEPOINTS
 	bool
 
+#
+# Set by each architecture that want to optimize how verify_pre_usermode_state
+# is called.
+#
+config ARCH_NO_SYSCALL_VERIFY_PRE_USERMODE_STATE
+	bool
+
 source "arch/Kconfig"
 
 endmenu		# General setup
diff --git a/kernel/sys.c b/kernel/sys.c
index 196c7134bee6..411163ac9dc3 100644
--- a/kernel/sys.c
+++ b/kernel/sys.c
@@ -2459,3 +2459,11 @@ COMPAT_SYSCALL_DEFINE1(sysinfo, struct compat_sysinfo __user *, info)
 	return 0;
 }
 #endif /* CONFIG_COMPAT */
+
+/* Called before coming back to user-mode */
+asmlinkage void verify_pre_usermode_state(void)
+{
+	if (CHECK_DATA_CORRUPTION(!segment_eq(get_fs(), USER_DS),
+				  "incorrect get_fs() on user-mode return"))
+		set_fs(USER_DS);
+}
-- 
2.12.1.500.gab5fba24ee-goog
