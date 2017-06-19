From: Kees Cook <keescook@chromium.org>
Date: Mon, 19 Jun 2017 16:36:32 -0700
Message-Id: <1497915397-93805-19-git-send-email-keescook@chromium.org>
In-Reply-To: <1497915397-93805-1-git-send-email-keescook@chromium.org>
References: <1497915397-93805-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 18/23] scsi: define usercopy region in scsi_sense_cache slab cache
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, David Windsor <dave@nullcore.net>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

From: David Windsor <dave@nullcore.net>

SCSI sense buffers, stored in struct scsi_cmnd.sense and therefore
contained in the scsi_sense_cache slab cache, need to be copied to/from
userspace.

In support of usercopy hardening, this patch defines a region in
the scsi_sense_cache slab cache in which userspace copy operations
are allowed.

This region is known as the slab cache's usercopy region.  Slab
caches can now check that each copy operation involving cache-managed
memory falls entirely within the slab's usercopy region.

Signed-off-by: David Windsor <dave@nullcore.net>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/scsi/scsi_lib.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 99e16ac479e3..fc5052aded84 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -77,14 +77,15 @@ int scsi_init_sense_cache(struct Scsi_Host *shost)
 	if (shost->unchecked_isa_dma) {
 		scsi_sense_isadma_cache =
 			kmem_cache_create("scsi_sense_cache(DMA)",
-			SCSI_SENSE_BUFFERSIZE, 0,
-			SLAB_HWCACHE_ALIGN | SLAB_CACHE_DMA, NULL);
+				SCSI_SENSE_BUFFERSIZE, 0,
+				SLAB_HWCACHE_ALIGN | SLAB_CACHE_DMA, NULL);
 		if (!scsi_sense_isadma_cache)
 			ret = -ENOMEM;
 	} else {
 		scsi_sense_cache =
-			kmem_cache_create("scsi_sense_cache",
-			SCSI_SENSE_BUFFERSIZE, 0, SLAB_HWCACHE_ALIGN, NULL);
+			kmem_cache_create_usercopy("scsi_sense_cache",
+				SCSI_SENSE_BUFFERSIZE, 0, SLAB_HWCACHE_ALIGN,
+				0, SCSI_SENSE_BUFFERSIZE, NULL);
 		if (!scsi_sense_cache)
 			ret = -ENOMEM;
 	}
-- 
2.7.4
