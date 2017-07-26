From: Thomas Garnier <thgarnie@google.com>
Date: Wed, 26 Jul 2017 10:00:51 -0700
Message-Id: <20170726170051.28328-3-thgarnie@google.com>
In-Reply-To: <20170726170051.28328-1-thgarnie@google.com>
References: <20170726170051.28328-1-thgarnie@google.com>
Subject: [kernel-hardening] [PATCH v2 3/3] arm64/syscalls: Move address limit check in loop
To: Russell King <linux@armlinux.org.uk>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@amacapital.net>, Will Drewry <wad@chromium.org>, Thomas Garnier <thgarnie@google.com>, Thomas Gleixner <tglx@linutronix.de>, Al Viro <viro@zeniv.linux.org.uk>, Dave Martin <Dave.Martin@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Pratyush Anand <panand@redhat.com>, Chris Metcalf <cmetcalf@mellanox.com>, leonard.crestez@nxp.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

A bug was reported on ARM where set_fs might be called after it was
checked on the work pending function. ARM64 is not affected by this bug
but has a similar construct. In order to avoid any similar problems in
the future, the addr_limit_user_check function is moved at the beginning
of the loop.

Fixes: cf7de27ab351 ("arm64/syscalls: Check address limit on user-mode return")
Reported-by: Leonard Crestez <leonard.crestez@nxp.com>
Signed-off-by: Thomas Garnier <thgarnie@google.com>
---
 arch/arm64/kernel/signal.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/kernel/signal.c b/arch/arm64/kernel/signal.c
index e3e3293d1123..8e2705983e1d 100644
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -751,10 +751,10 @@ asmlinkage void do_notify_resume(struct pt_regs *regs,
 	 */
 	trace_hardirqs_off();
 
-	/* Check valid user FS if needed */
-	addr_limit_user_check();
-
 	do {
+		/* Check valid user FS if needed */
+		addr_limit_user_check();
+
 		if (thread_flags & _TIF_NEED_RESCHED) {
 			schedule();
 		} else {
-- 
2.14.0.rc0.400.g1c36432dff-goog
