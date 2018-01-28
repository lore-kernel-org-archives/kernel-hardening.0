From: Andy Lutomirski <luto@kernel.org>
Date: Sun, 28 Jan 2018 10:38:51 -0800
Message-Id: <4dd5a4d0f6b694f17eaf64c80c36a2560993b9ea.1517164461.git.luto@kernel.org>
In-Reply-To: <cover.1517164461.git.luto@kernel.org>
References: <cover.1517164461.git.luto@kernel.org>
In-Reply-To: <cover.1517164461.git.luto@kernel.org>
References: <cover.1517164461.git.luto@kernel.org>
Subject: [kernel-hardening] [PATCH 3/3] syscalls: Add a bit of documentation to __SYSCALL_DEFINE
To: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Borislav Petkov <bp@alien8.de>, Andy Lutomirski <luto@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

__SYSCALL_DEFINE is rather magical.  Add a bit of documentation.

Signed-off-by: Andy Lutomirski <luto@kernel.org>
---
 include/linux/syscalls.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/syscalls.h b/include/linux/syscalls.h
index a78186d826d7..d3f244a447c5 100644
--- a/include/linux/syscalls.h
+++ b/include/linux/syscalls.h
@@ -207,6 +207,16 @@ static inline int is_syscall_trace_event(struct trace_event_call *tp_event)
 	__SYSCALL_DEFINEx(x, sname, __VA_ARGS__)
 
 #define __PROTECT(...) asmlinkage_protect(__VA_ARGS__)
+
+/*
+ * For a syscall like long foo(void *a, long long b), this defines:
+ *
+ * static inline long SYSC_foo(void *a, long long b): the actual code
+ *
+ * asmlinkage long SyS_foo(long a, long long b): wrapper that calls SYSC_foo
+ *
+ * asmlinkage long sys_foo(void *a, long long b): alias of SyS_foo
+ */
 #define __SYSCALL_DEFINEx(x, name, ...)					\
 	asmlinkage long sys##name(__MAP(x,__SC_DECL,__VA_ARGS__))	\
 		__attribute__((alias(__stringify(SyS##name))));		\
-- 
2.14.3
