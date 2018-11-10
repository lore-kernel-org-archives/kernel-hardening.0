From: Alexander Popov <alex.popov@linux.com>
Subject: [PATCH 1/1] stackleak: Disable ftrace for stackleak.c
Date: Sun, 11 Nov 2018 01:05:30 +0300
Message-Id: <1541887530-16610-1-git-send-email-alex.popov@linux.com>
To: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Jann Horn <jannh@google.com>, Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Joerg Roedel <joro@8bytes.org>, Borislav Petkov <bp@alien8.de>, Thomas Gleixner <tglx@linutronix.de>, Dave Hansen <dave.hansen@linux.intel.com>, Steven Rostedt <rostedt@goodmis.org>, Peter Zijlstra <peterz@infradead.org>, Jan Kara <jack@suse.cz>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, Dan Williams <dan.j.williams@intel.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Masami Hiramatsu <mhiramat@kernel.org>, x86@kernel.org, alex.popov@linux.com, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

The stackleak_erase() function is called on the trampoline stack at the
end of syscall. This stack is not big enough for ftrace operations,
e.g. it can be overflowed if we enable kprobe_events for stackleak_erase().

Let's disable ftrace for stackleak.c to avoid such situations.

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Alexander Popov <alex.popov@linux.com>
Reviewed-by: Kees Cook <keescook@chromium.org>
---
 kernel/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/Makefile b/kernel/Makefile
index 7343b3a..0906f6d 100644
--- a/kernel/Makefile
+++ b/kernel/Makefile
@@ -18,6 +18,7 @@ obj-$(CONFIG_MULTIUSER) += groups.o
 ifdef CONFIG_FUNCTION_TRACER
 # Do not trace internal ftrace files
 CFLAGS_REMOVE_irq_work.o = $(CC_FLAGS_FTRACE)
+CFLAGS_REMOVE_stackleak.o = $(CC_FLAGS_FTRACE)
 endif
 
 # Prevents flicker of uninteresting __do_softirq()/__local_bh_disable_ip()
-- 
2.7.4
