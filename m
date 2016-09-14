Reply-To: kernel-hardening@lists.openwall.com
From: Juerg Haefliger <juerg.haefliger@hpe.com>
Date: Wed, 14 Sep 2016 09:19:01 +0200
Message-Id: <20160914071901.8127-4-juerg.haefliger@hpe.com>
In-Reply-To: <20160914071901.8127-1-juerg.haefliger@hpe.com>
References: <20160902113909.32631-1-juerg.haefliger@hpe.com>
 <20160914071901.8127-1-juerg.haefliger@hpe.com>
Subject: [kernel-hardening] [RFC PATCH v2 3/3] block: Always use a bounce buffer when XPFO is enabled
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com, linux-x86_64@vger.kernel.org
Cc: juerg.haefliger@hpe.com, vpk@cs.columbia.edu
List-ID: <kernel-hardening.lists.openwall.com>

This is a temporary hack to prevent the use of bio_map_user_iov()
which causes XPFO page faults.

Signed-off-by: Juerg Haefliger <juerg.haefliger@hpe.com>
---
 block/blk-map.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/blk-map.c b/block/blk-map.c
index b8657fa8dc9a..e889dbfee6fb 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -52,7 +52,7 @@ static int __blk_rq_map_user_iov(struct request *rq,
 	struct bio *bio, *orig_bio;
 	int ret;
 
-	if (copy)
+	if (copy || IS_ENABLED(CONFIG_XPFO))
 		bio = bio_copy_user_iov(q, map_data, iter, gfp_mask);
 	else
 		bio = bio_map_user_iov(q, iter, gfp_mask);
-- 
2.9.3
