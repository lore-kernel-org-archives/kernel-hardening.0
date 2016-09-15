Reply-To: kernel-hardening@lists.openwall.com
From: Mark Rutland <mark.rutland@arm.com>
Date: Thu, 15 Sep 2016 14:49:03 +0100
Message-Id: <1473947349-14521-3-git-send-email-mark.rutland@arm.com>
In-Reply-To: <1473947349-14521-1-git-send-email-mark.rutland@arm.com>
References: <1473947349-14521-1-git-send-email-mark.rutland@arm.com>
Subject: [kernel-hardening] [RFC PATCH 2/8] thread_info: allow custom in-task thread_info
To: linux-arm-kernel@lists.infradead.org
Cc: akpm@linux-foundation.org, ard.biesheuvel@linaro.org, catalin.marinas@arm.com, james.morse@arm.com, keescook@chromium.org, linux-kernel@vger.kernel.org, lorenzo.pieralisi@arm.com, luto@kernel.org, mark.rutland@arm.com, suzuki.poulose@arm.com, takahiro.akashi@linaro.org, will.deacon@arm.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Currently, task_struct is defined in <linux/sched.h>, which (indirectly)
pulls in a number of low-level arch headers such as <asm/preempt.h>
through a number of other headers. Thus, code and structures in these
headers can't rely on the definition of task_struct. Some of these
headers are necessary for the definition of task_struct, so moving
task_struct into its own header is insufficient tio avoid circular
includes.

With CONFIG_THREAD_INFO_IN_TASK, arch code needs to implement its own
get_current() for the generic get_thread_info(). To avoid header
dependency issues, this relies on thread_info being the first member of
task_struct. This can be used by low-level arch code, as it doesn't
depend on the definition of task_struct.

For architectures without preempt-safe this_cpu ops, some data required
by low-level arch code (e.g. preempt_count) has to be stored per-thread,
and for the reasons above, we cannot place this in task_struct (or
thread_struct, since we cannot know its offset from within task_struct).
The only practical location for these is thread_info.

This patch allows architectures with CONFIG_ARCH_HAS_OWN_THREAD_INFO to
define their own thread_info, avoiding the problems described above.

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Will Deacon <will.deacon@arm.com>
Cc: linux-kernel@vger.kernel.org
---
 include/linux/thread_info.h | 3 ++-
 init/Kconfig                | 3 +++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/include/linux/thread_info.h b/include/linux/thread_info.h
index d9622f7..7984f87 100644
--- a/include/linux/thread_info.h
+++ b/include/linux/thread_info.h
@@ -13,7 +13,8 @@
 struct timespec;
 struct compat_timespec;
 
-#ifdef CONFIG_THREAD_INFO_IN_TASK
+#if defined(CONFIG_THREAD_INFO_IN_TASK) && \
+    !defined(CONFIG_ARCH_HAS_OWN_THREAD_INFO)
 struct thread_info {
 	u32			flags;		/* low level flags */
 };
diff --git a/init/Kconfig b/init/Kconfig
index 3b9a47f..f812098 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -26,6 +26,9 @@ config IRQ_WORK
 config BUILDTIME_EXTABLE_SORT
 	bool
 
+config ARCH_HAS_OWN_THREAD_INFO
+	bool
+
 config THREAD_INFO_IN_TASK
 	bool
 	help
-- 
1.9.1
