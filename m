From: Hoeun Ryu <hoeun.ryu@gmail.com>
Date: Sun, 19 Feb 2017 19:04:06 +0900
Message-Id: <1487498660-16600-3-git-send-email-hoeun.ryu@gmail.com>
In-Reply-To: <1487498660-16600-1-git-send-email-hoeun.ryu@gmail.com>
References: <1487498660-16600-1-git-send-email-hoeun.ryu@gmail.com>
Subject: [kernel-hardening] [RFC 3/7] module: modify memory attrs for __ro_mostly_after_init during module_init/exit
To: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
Cc: Hoeun Ryu <hoeun.ryu@gmail.com>, Jessica Yu <jeyu@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>
List-ID: <kernel-hardening.lists.openwall.com>

 `__ro_mostly_after_init` is almost like `__ro_after_init`. The section is
read-only as same as `__ro_after_init` after kernel init. This patch makes
`__ro_mostly_after_init` section read-write temporarily only during
module_init/module_exit.

Signed-off-by: Hoeun Ryu <hoeun.ryu@gmail.com>
---
 kernel/module.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/kernel/module.c b/kernel/module.c
index 7eba6de..3b25e0e 100644
--- a/kernel/module.c
+++ b/kernel/module.c
@@ -987,8 +987,11 @@ SYSCALL_DEFINE2(delete_module, const char __user *, name_user,
 
 	mutex_unlock(&module_mutex);
 	/* Final destruction now no one is using it. */
-	if (mod->exit != NULL)
+	if (mod->exit != NULL) {
+		set_ro_mostly_after_init_rw();
 		mod->exit();
+		set_ro_mostly_after_init_ro();
+	}
 	blocking_notifier_call_chain(&module_notify_list,
 				     MODULE_STATE_GOING, mod);
 	klp_module_going(mod);
@@ -3396,8 +3399,11 @@ static noinline int do_init_module(struct module *mod)
 
 	do_mod_ctors(mod);
 	/* Start the module */
-	if (mod->init != NULL)
+	if (mod->init != NULL) {
+		set_ro_mostly_after_init_rw();
 		ret = do_one_initcall(mod->init);
+		set_ro_mostly_after_init_ro();
+	}
 	if (ret < 0) {
 		goto fail_free_freeinit;
 	}
-- 
2.7.4
