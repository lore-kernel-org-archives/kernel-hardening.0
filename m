From: Jess Frazelle <me@jessfraz.com>
Date: Fri, 10 Feb 2017 17:37:54 -0800
Message-Id: <20170211013758.3288-1-me@jessfraz.com>
Subject: [kernel-hardening] [PATCH v2 1/5] irq: set {msi_domain,syscore}_ops as __ro_after_init
To: Thomas Gleixner <tglx@linutronix.de>, Marc Zyngier <marc.zyngier@arm.com>, "open list:IRQ SUBSYSTEM" <linux-kernel@vger.kernel.org>
Cc: kernel-hardening@lists.openwall.com, Jess Frazelle <me@jessfraz.com>
List-ID: <kernel-hardening.lists.openwall.com>

Marked msi_domain_ops structs as __ro_after_init when called only during init.
Marked syscore_ops structs as __ro_after_init when register_syscore_ops was
called only during init. Most of the caller functions were already annotated as
__init.
unregister_syscore_ops() was never called on these syscore_ops.
This protects the data structure from accidental corruption.

Suggested-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Jess Frazelle <me@jessfraz.com>
---
 kernel/irq/generic-chip.c | 2 +-
 kernel/irq/msi.c          | 2 +-
 kernel/irq/pm.c           | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/irq/generic-chip.c b/kernel/irq/generic-chip.c
index ee32870079c9..cca63dbaabea 100644
--- a/kernel/irq/generic-chip.c
+++ b/kernel/irq/generic-chip.c
@@ -623,7 +623,7 @@ static void irq_gc_shutdown(void)
 	}
 }

-static struct syscore_ops irq_gc_syscore_ops = {
+static struct syscore_ops irq_gc_syscore_ops __ro_after_init = {
 	.suspend = irq_gc_suspend,
 	.resume = irq_gc_resume,
 	.shutdown = irq_gc_shutdown,
diff --git a/kernel/irq/msi.c b/kernel/irq/msi.c
index ee230063f033..0e5b723f710f 100644
--- a/kernel/irq/msi.c
+++ b/kernel/irq/msi.c
@@ -217,7 +217,7 @@ static int msi_domain_ops_check(struct irq_domain *domain,
 	return 0;
 }

-static struct msi_domain_ops msi_domain_ops_default = {
+static struct msi_domain_ops msi_domain_ops_default __ro_after_init = {
 	.get_hwirq	= msi_domain_ops_get_hwirq,
 	.msi_init	= msi_domain_ops_init,
 	.msi_check	= msi_domain_ops_check,
diff --git a/kernel/irq/pm.c b/kernel/irq/pm.c
index cea1de0161f1..d6b889bed323 100644
--- a/kernel/irq/pm.c
+++ b/kernel/irq/pm.c
@@ -185,7 +185,7 @@ static void irq_pm_syscore_resume(void)
 	resume_irqs(true);
 }

-static struct syscore_ops irq_pm_syscore_ops = {
+static struct syscore_ops irq_pm_syscore_ops __ro_after_init = {
 	.resume		= irq_pm_syscore_resume,
 };

--
2.11.0
