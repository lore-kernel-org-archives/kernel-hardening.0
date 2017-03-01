Date: Wed, 1 Mar 2017 12:33:49 -0800
From: Kees Cook <keescook@chromium.org>
Message-ID: <20170301203349.GA42365@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Subject: [kernel-hardening] [PATCH] PCI: Fix typo in pax_open/close_kernel wrapping
To: pageexec@freemail.hu
Cc: spender@grsecurity.net, Mark Rutland <mark.rutland@arm.com>, Hoeun Ryu <hoeun.ryu@gmail.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This fixes a mistaken double-open in PaX's constification coverage of
cpcihp_zt5550.

Signed-off-by: Kees Cook <kees@outflux.net>
---
 drivers/pci/hotplug/cpcihp_zt5550.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pci/hotplug/cpcihp_zt5550.c b/drivers/pci/hotplug/cpcihp_zt5550.c
index 438f019..18c4d10 100644
--- a/drivers/pci/hotplug/cpcihp_zt5550.c
+++ b/drivers/pci/hotplug/cpcihp_zt5550.c
@@ -228,7 +228,7 @@ static int zt5550_hc_init_one(struct pci_dev *pdev, const struct pci_device_id *
 		const_cast(zt5550_hpc_ops.enable_irq) = zt5550_hc_enable_irq;
 		const_cast(zt5550_hpc_ops.disable_irq) = zt5550_hc_disable_irq;
 		const_cast(zt5550_hpc_ops.check_irq) = zt5550_hc_check_irq;
-		pax_open_kernel();
+		pax_close_kernel();
 	} else {
 		info("using ENUM# polling mode");
 	}
-- 
2.7.4


-- 
Kees Cook
Pixel Security
