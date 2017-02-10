From: Jess Frazelle <me@jessfraz.com>
Date: Fri, 10 Feb 2017 02:09:00 -0800
Message-Id: <20170210100902.11765-3-me@jessfraz.com>
In-Reply-To: <20170210100902.11765-1-me@jessfraz.com>
References: <20170210100902.11765-1-me@jessfraz.com>
Subject: [kernel-hardening] [PATCH 2/4] pci: set msi_domain_ops as __ro_after_init
To: kernel-hardening@lists.openwall.com
Cc: Jess Frazelle <me@jessfraz.com>
List-ID: <kernel-hardening.lists.openwall.com>

Marked msi_domain_ops structs as __ro_after_init when called only during init.
This protects the data structure from accidental corruption.

Suggested-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Jess Frazelle <me@jessfraz.com>
---
 drivers/pci/host/pci-hyperv.c | 2 +-
 drivers/pci/host/vmd.c        | 2 +-
 drivers/pci/msi.c             | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/pci/host/pci-hyperv.c b/drivers/pci/host/pci-hyperv.c
index 3efcc7bdc5fb..f05b93689d8f 100644
--- a/drivers/pci/host/pci-hyperv.c
+++ b/drivers/pci/host/pci-hyperv.c
@@ -958,7 +958,7 @@ static irq_hw_number_t hv_msi_domain_ops_get_hwirq(struct msi_domain_info *info,
 	return arg->msi_hwirq;
 }

-static struct msi_domain_ops hv_msi_ops = {
+static struct msi_domain_ops hv_msi_ops __ro_after_init = {
 	.get_hwirq	= hv_msi_domain_ops_get_hwirq,
 	.msi_prepare	= pci_msi_prepare,
 	.set_desc	= pci_msi_set_desc,
diff --git a/drivers/pci/host/vmd.c b/drivers/pci/host/vmd.c
index 18ef1a93c10a..152c461538e4 100644
--- a/drivers/pci/host/vmd.c
+++ b/drivers/pci/host/vmd.c
@@ -253,7 +253,7 @@ static void vmd_set_desc(msi_alloc_info_t *arg, struct msi_desc *desc)
 	arg->desc = desc;
 }

-static struct msi_domain_ops vmd_msi_domain_ops = {
+static struct msi_domain_ops vmd_msi_domain_ops __ro_after_init = {
 	.get_hwirq	= vmd_get_hwirq,
 	.msi_init	= vmd_msi_init,
 	.msi_free	= vmd_msi_free,
diff --git a/drivers/pci/msi.c b/drivers/pci/msi.c
index 50c5003295ca..93141d5e2d1c 100644
--- a/drivers/pci/msi.c
+++ b/drivers/pci/msi.c
@@ -1413,7 +1413,7 @@ static void pci_msi_domain_set_desc(msi_alloc_info_t *arg,
 #define pci_msi_domain_set_desc		NULL
 #endif

-static struct msi_domain_ops pci_msi_domain_ops_default = {
+static struct msi_domain_ops pci_msi_domain_ops_default __ro_after_init = {
 	.set_desc	= pci_msi_domain_set_desc,
 	.msi_check	= pci_msi_domain_check_cap,
 	.handle_error	= pci_msi_domain_handle_error,
--
2.11.0
