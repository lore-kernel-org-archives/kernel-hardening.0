From: Hoeun Ryu <hoeun.ryu@gmail.com>
Date: Sun, 19 Feb 2017 19:04:08 +0900
Message-Id: <1487498660-16600-5-git-send-email-hoeun.ryu@gmail.com>
In-Reply-To: <1487498660-16600-1-git-send-email-hoeun.ryu@gmail.com>
References: <1487498660-16600-1-git-send-email-hoeun.ryu@gmail.com>
Subject: [kernel-hardening] [RFC 5/7] cpu: mark ro_mostly_after_init for cpuhp_ap/bp_states
To: kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org
Cc: Hoeun Ryu <hoeun.ryu@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Ingo Molnar <mingo@kernel.org>, Anna-Maria Gleixner <anna-maria@linutronix.de>, Peter Zijlstra <peterz@infradead.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>
List-ID: <kernel-hardening.lists.openwall.com>

It would be good that `__ro_mostly_after_init` is marked to cpuhp state
objects. They can not be simply marked as `__ro_after_init` because they
should be writable during module_init/exit. Now that they can be read-only
except during module_init/exit

Signed-off-by: Hoeun Ryu <hoeun.ryu@gmail.com>
---
 kernel/cpu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/cpu.c b/kernel/cpu.c
index 0a5f630..12ad4c2 100644
--- a/kernel/cpu.c
+++ b/kernel/cpu.c
@@ -1126,7 +1126,7 @@ core_initcall(cpu_hotplug_pm_sync_init);
 #endif /* CONFIG_SMP */
 
 /* Boot processor state steps */
-static struct cpuhp_step cpuhp_bp_states[] = {
+static struct cpuhp_step cpuhp_bp_states[] __ro_mostly_after_init = {
 	[CPUHP_OFFLINE] = {
 		.name			= "offline",
 		.startup.single		= NULL,
@@ -1212,7 +1212,7 @@ static struct cpuhp_step cpuhp_bp_states[] = {
 };
 
 /* Application processor state steps */
-static struct cpuhp_step cpuhp_ap_states[] = {
+static struct cpuhp_step cpuhp_ap_states[] __ro_mostly_after_init = {
 #ifdef CONFIG_SMP
 	/* Final state before CPU kills itself */
 	[CPUHP_AP_IDLE_DEAD] = {
-- 
2.7.4
