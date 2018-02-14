From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH v2 7/8] Convert vhost to kvzalloc_struct
Date: Wed, 14 Feb 2018 12:11:53 -0800
Message-Id: <20180214201154.10186-8-willy@infradead.org>
In-Reply-To: <20180214201154.10186-1-willy@infradead.org>
References: <20180214201154.10186-1-willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-mm@kvack.org, Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Joe Perches <joe@perches.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Matthew Wilcox <mawilcox@microsoft.com>

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 drivers/vhost/vhost.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 1b3e8d2d5c8b..fa6c8fa80dd1 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1284,7 +1284,7 @@ static long vhost_set_memory(struct vhost_dev *d, struct vhost_memory __user *m)
 		return -EOPNOTSUPP;
 	if (mem.nregions > max_mem_regions)
 		return -E2BIG;
-	newmem = kvzalloc(size + mem.nregions * sizeof(*m->regions), GFP_KERNEL);
+	newmem = kvzalloc_struct(newmem, regions, mem.nregions, GFP_KERNEL);
 	if (!newmem)
 		return -ENOMEM;
 
-- 
2.15.1
