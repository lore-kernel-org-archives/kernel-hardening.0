From: Jason Yan <yanaijie@huawei.com>
Subject: [PATCH] usercopy: skip the check if not a real usercopy
Date: Wed, 2 Jan 2019 17:31:37 +0800
Message-ID: <20190102093137.17136-1-yanaijie@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain
To: keescook@chromium.org, kernel-hardening@lists.openwall.com
Cc: zhaohongjiang@huawei.com, miaoxie@huawei.com, Jason Yan <yanaijie@huawei.com>, Li Bin <huawei.libin@huawei.com>, Wei Yongjun <weiyongjun1@huawei.com>
List-ID: <kernel-hardening.lists.openwall.com>

Some kernel codes use copy_to/from_user to copy data between kernel
buffers by calling set_fs(KERNEL_DS). Hardened usercopy will check these
objects and sometimes soft lockup may happen as follows:

[   96.314420] watchdog: BUG: soft lockup - CPU#4 stuck for 22s! [sh:356]
......
[   96.674904] Call Trace:
[   96.684489]  __check_object_size+0x1f1/0x460
[   96.691669]  __probe_kernel_write+0x195/0x390
[   96.696821]  ftrace_write+0x67/0xa0
[   96.709086]  ftrace_replace_code+0x3e2/0xa30
[   96.724418]  ? ftrace_int3_handler+0x100/0x100
[   96.731570]  ftrace_modify_all_code+0x1f6/0x2e0
[   96.741639]  ? function_stack_trace_call+0x340/0x340
[   96.751778]  arch_ftrace_update_code+0x3a/0x70
[   96.762062]  ftrace_run_update_code+0x35/0xf0
[   96.763874]  ftrace_startup_enable+0x7a/0xa0
[   96.770122]  ftrace_startup+0x405/0x6a0
[   96.782269]  register_ftrace_function+0x76/0x150
[   96.794676]  function_trace_init+0x1bb/0x250
[   96.805203]  tracing_set_tracer+0x4af/0xa10
[   96.817490]  tracing_set_trace_write+0x40e/0x660
[   96.832344]  ? tracing_set_tracer+0xa10/0xa10
[   96.843771]  ? kasan_check_read+0x1d/0x30
[   96.855433]  ? do_raw_spin_unlock+0x6c/0x300
[   96.864058]  ? _raw_spin_unlock+0x44/0x70
[   96.873790]  ? do_anonymous_page+0x6d3/0x1030
[   96.887520]  ? tracing_set_tracer+0xa10/0xa10
[   96.897393]  __vfs_write+0x11b/0x880
[   96.910798]  ? kernel_read+0x150/0x150
[   96.918995]  ? __lock_acquire+0x925/0x1770
[   96.925343]  ? __lock_acquire+0x925/0x1770
[   96.933334]  ? pmd_alloc+0x140/0x140
[   96.944556]  ? __lock_is_held+0xe3/0x1a0
[   96.954812]  ? kasan_check_read+0x1d/0x30
[   96.959380]  ? rcu_read_lock_sched_held+0x1dd/0x210
[   96.967383]  ? rcu_sync_lockdep_assert+0xf0/0x190
[   96.984740]  ? __sb_start_write+0x1b3/0x3e0
[   96.999405]  vfs_write+0x210/0x640
[   97.013153]  ksys_write+0xe6/0x210
[   97.023623]  ? __x64_sys_read+0xe0/0xe0
[   97.035021]  ? trace_hardirqs_on_thunk+0x1a/0x1c
[   97.044914]  ? do_syscall_64+0x98/0x2b0
[   97.050349]  ? do_syscall_64+0x98/0x2b0
[   97.058009]  __x64_sys_write+0x94/0xe0
[   97.063153]  do_syscall_64+0x161/0x2b0
[   97.069358]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
......

It's unnecessary to check these objects for copying between kernel buffers.
So skip all hardened usercopy tests.

Signed-off-by: Jason Yan <yanaijie@huawei.com>
CC: Li Bin <huawei.libin@huawei.com>
CC: Wei Yongjun <weiyongjun1@huawei.com>
---
 mm/usercopy.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/usercopy.c b/mm/usercopy.c
index 852eb4e53f06..8a0a1854f564 100644
--- a/mm/usercopy.c
+++ b/mm/usercopy.c
@@ -23,6 +23,7 @@
 #include <linux/atomic.h>
 #include <linux/jump_label.h>
 #include <asm/sections.h>
+#include <linux/uaccess.h>
 
 /*
  * Checks if a given pointer and length is contained by the current
@@ -255,6 +256,10 @@ void __check_object_size(const void *ptr, unsigned long n, bool to_user)
 	if (static_branch_unlikely(&bypass_usercopy_checks))
 		return;
 
+	/* Skip all tests if it is not a real usercopy. */
+	if (uaccess_kernel())
+		return;
+
 	/* Skip all tests if size is zero. */
 	if (!n)
 		return;
-- 
2.14.4
