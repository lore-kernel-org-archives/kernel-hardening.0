From: Jess Frazelle <me@jessfraz.com>
Date: Fri, 10 Feb 2017 02:09:01 -0800
Message-Id: <20170210100902.11765-4-me@jessfraz.com>
In-Reply-To: <20170210100902.11765-1-me@jessfraz.com>
References: <20170210100902.11765-1-me@jessfraz.com>
Subject: [kernel-hardening] [PATCH 3/4] x86: set msi_domain_ops as __ro_after_init
To: kernel-hardening@lists.openwall.com
Cc: Jess Frazelle <me@jessfraz.com>
List-ID: <kernel-hardening.lists.openwall.com>

Marked msi_domain_ops structs as __ro_after_init when called only during init.
This protects the data structure from accidental corruption.

Suggested-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Jess Frazelle <me@jessfraz.com>
---
 arch/x86/kernel/apic/msi.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/apic/msi.c b/arch/x86/kernel/apic/msi.c
index 015bbf30e3e3..27783a1e7166 100644
--- a/arch/x86/kernel/apic/msi.c
+++ b/arch/x86/kernel/apic/msi.c
@@ -121,7 +121,7 @@ void pci_msi_set_desc(msi_alloc_info_t *arg, struct msi_desc *desc)
 }
 EXPORT_SYMBOL_GPL(pci_msi_set_desc);

-static struct msi_domain_ops pci_msi_domain_ops = {
+static struct msi_domain_ops pci_msi_domain_ops __ro_after_init = {
 	.get_hwirq	= pci_msi_get_hwirq,
 	.msi_prepare	= pci_msi_prepare,
 	.set_desc	= pci_msi_set_desc,
@@ -207,7 +207,7 @@ static int dmar_msi_init(struct irq_domain *domain,
 	return 0;
 }

-static struct msi_domain_ops dmar_msi_domain_ops = {
+static struct msi_domain_ops dmar_msi_domain_ops __ro_after_init = {
 	.get_hwirq	= dmar_msi_get_hwirq,
 	.msi_init	= dmar_msi_init,
 };
@@ -304,7 +304,7 @@ static void hpet_msi_free(struct irq_domain *domain,
 	irq_clear_status_flags(virq, IRQ_MOVE_PCNTXT);
 }

-static struct msi_domain_ops hpet_msi_domain_ops = {
+static struct msi_domain_ops hpet_msi_domain_ops __ro_after_init = {
 	.get_hwirq	= hpet_msi_get_hwirq,
 	.msi_init	= hpet_msi_init,
 	.msi_free	= hpet_msi_free,
--
2.11.0
