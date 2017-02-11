From: Jess Frazelle <me@jessfraz.com>
Date: Fri, 10 Feb 2017 17:37:57 -0800
Message-Id: <20170211013758.3288-4-me@jessfraz.com>
In-Reply-To: <20170211013758.3288-1-me@jessfraz.com>
References: <20170211013758.3288-1-me@jessfraz.com>
Subject: [kernel-hardening] [PATCH v2 4/5] staging: set msi_domain_ops as __ro_after_init
To: Stuart Yoder <stuart.yoder@nxp.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Bharat Bhushan <bharat.bhushan@nxp.com>, Bhaktipriya Shridhar <bhaktipriya96@gmail.com>, Nipun Gupta <nipun.gupta@nxp.com>, Jess Frazelle <me@jessfraz.com>, "open list:QORIQ DPAA2 FSL-MC BUS DRIVER" <linux-kernel@vger.kernel.org>, "open list:STAGING SUBSYSTEM" <devel@driverdev.osuosl.org>
Cc: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Marked msi_domain_ops structs as __ro_after_init when called only during init.
This protects the data structure from accidental corruption.

Suggested-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Jess Frazelle <me@jessfraz.com>
---
 drivers/staging/fsl-mc/bus/irq-gic-v3-its-fsl-mc-msi.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/fsl-mc/bus/irq-gic-v3-its-fsl-mc-msi.c b/drivers/staging/fsl-mc/bus/irq-gic-v3-its-fsl-mc-msi.c
index 6b1cd574644f..0e2c1b5e13b7 100644
--- a/drivers/staging/fsl-mc/bus/irq-gic-v3-its-fsl-mc-msi.c
+++ b/drivers/staging/fsl-mc/bus/irq-gic-v3-its-fsl-mc-msi.c
@@ -51,7 +51,7 @@ static int its_fsl_mc_msi_prepare(struct irq_domain *msi_domain,
 	return msi_info->ops->msi_prepare(msi_domain->parent, dev, nvec, info);
 }

-static struct msi_domain_ops its_fsl_mc_msi_ops = {
+static struct msi_domain_ops its_fsl_mc_msi_ops __ro_after_init = {
 	.msi_prepare = its_fsl_mc_msi_prepare,
 };

--
2.11.0
