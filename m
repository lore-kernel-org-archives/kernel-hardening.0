From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v2 4/8] Convert dax device to kvzalloc_struct
Date: Wed, 14 Feb 2018 12:11:50 -0800
Message-Id: <20180214201154.10186-5-willy@infradead.org>
In-Reply-To: <20180214201154.10186-1-willy@infradead.org>
References: <20180214201154.10186-1-willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-mm@kvack.org, Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Joe Perches <joe@perches.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Matthew Wilcox <mawilcox@microsoft.com>

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 drivers/dax/device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/dax/device.c b/drivers/dax/device.c
index 2137dbc29877..5821cde340f6 100644
--- a/drivers/dax/device.c
+++ b/drivers/dax/device.c
@@ -586,7 +586,7 @@ struct dev_dax *devm_create_dev_dax(struct dax_region *dax_region,
 	if (!count)
 		return ERR_PTR(-EINVAL);
 
-	dev_dax = kzalloc(sizeof(*dev_dax) + sizeof(*res) * count, GFP_KERNEL);
+	dev_dax = kvzalloc_struct(dev_dax, res, count, GFP_KERNEL);
 	if (!dev_dax)
 		return ERR_PTR(-ENOMEM);
 
-- 
2.15.1
