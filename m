From: Matthew Wilcox <willy@infradead.org>
Subject: [PATCH 4/6] Convert vhost to struct_size
Date: Thu,  7 Jun 2018 07:57:18 -0700
Message-Id: <20180607145720.22590-5-willy@infradead.org>
In-Reply-To: <20180607145720.22590-1-willy@infradead.org>
References: <20180607145720.22590-1-willy@infradead.org>
To: Kees Cook <keescook@chromium.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

From: Matthew Wilcox <mawilcox@microsoft.com>

Signed-off-by: Matthew Wilcox <mawilcox@microsoft.com>
---
 drivers/vhost/vhost.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/vhost/vhost.c b/drivers/vhost/vhost.c
index 895eaa25807c..f9bce818da11 100644
--- a/drivers/vhost/vhost.c
+++ b/drivers/vhost/vhost.c
@@ -1286,7 +1286,8 @@ static long vhost_set_memory(struct vhost_dev *d, struct vhost_memory __user *m)
 		return -EOPNOTSUPP;
 	if (mem.nregions > max_mem_regions)
 		return -E2BIG;
-	newmem = kvzalloc(size + mem.nregions * sizeof(*m->regions), GFP_KERNEL);
+	newmem = kvzalloc(struct_size(newmem, regions, mem.nregions),
+			GFP_KERNEL);
 	if (!newmem)
 		return -ENOMEM;
 
-- 
2.17.0
