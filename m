From: Lionel Debroux <lionel_debroux@yahoo.fr>
Date: Sun, 14 May 2017 11:33:26 +0200
Message-Id: <1494754407-31455-1-git-send-email-lionel_debroux@yahoo.fr>
Subject: [kernel-hardening] [PATCH] drivers/gpu/drm: constify several *max_ioctl variables.
To: kernel-hardening@lists.openwall.com
Cc: Lionel Debroux <lionel_debroux@yahoo.fr>
List-ID: <kernel-hardening.lists.openwall.com>

These are initialized with ARRAY_SIZE(a const struct drm_ioctl_desc array).
They have therefore no business being writable.

Extracted from PaX/grsecurity.

Signed-off-by: Lionel Debroux <lionel_debroux@yahoo.fr>
---
 drivers/gpu/drm/i810/i810_dma.c     | 2 +-
 drivers/gpu/drm/i810/i810_drv.h     | 2 +-
 drivers/gpu/drm/mga/mga_drv.h       | 2 +-
 drivers/gpu/drm/mga/mga_state.c     | 2 +-
 drivers/gpu/drm/qxl/qxl_drv.c       | 2 +-
 drivers/gpu/drm/qxl/qxl_ioctl.c     | 2 +-
 drivers/gpu/drm/r128/r128_drv.h     | 2 +-
 drivers/gpu/drm/r128/r128_state.c   | 2 +-
 drivers/gpu/drm/savage/savage_bci.c | 2 +-
 drivers/gpu/drm/savage/savage_drv.h | 2 +-
 drivers/gpu/drm/sis/sis_drv.h       | 2 +-
 drivers/gpu/drm/sis/sis_mm.c        | 2 +-
 drivers/gpu/drm/via/via_dma.c       | 2 +-
 drivers/gpu/drm/via/via_drv.h       | 2 +-
 14 files changed, 14 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/i810/i810_dma.c b/drivers/gpu/drm/i810/i810_dma.c
index 576a417..91bcf1e 100644
--- a/drivers/gpu/drm/i810/i810_dma.c
+++ b/drivers/gpu/drm/i810/i810_dma.c
@@ -1256,4 +1256,4 @@ const struct drm_ioctl_desc i810_ioctls[] = {
 	DRM_IOCTL_DEF_DRV(I810_FLIP, i810_flip_bufs, DRM_AUTH|DRM_UNLOCKED),
 };
 
-int i810_max_ioctl = ARRAY_SIZE(i810_ioctls);
+const int i810_max_ioctl = ARRAY_SIZE(i810_ioctls);
diff --git a/drivers/gpu/drm/i810/i810_drv.h b/drivers/gpu/drm/i810/i810_drv.h
index c73d2f2..c86aaa5 100644
--- a/drivers/gpu/drm/i810/i810_drv.h
+++ b/drivers/gpu/drm/i810/i810_drv.h
@@ -127,7 +127,7 @@ extern void i810_driver_preclose(struct drm_device *dev,
 
 extern long i810_ioctl(struct file *file, unsigned int cmd, unsigned long arg);
 extern const struct drm_ioctl_desc i810_ioctls[];
-extern int i810_max_ioctl;
+extern const int i810_max_ioctl;
 
 #define I810_BASE(reg)		((unsigned long) \
 				dev_priv->mmio_map->handle)
diff --git a/drivers/gpu/drm/mga/mga_drv.h b/drivers/gpu/drm/mga/mga_drv.h
index 45cf363..e9e59be 100644
--- a/drivers/gpu/drm/mga/mga_drv.h
+++ b/drivers/gpu/drm/mga/mga_drv.h
@@ -152,7 +152,7 @@ typedef struct drm_mga_private {
 } drm_mga_private_t;
 
 extern const struct drm_ioctl_desc mga_ioctls[];
-extern int mga_max_ioctl;
+extern const int mga_max_ioctl;
 
 				/* mga_dma.c */
 extern int mga_dma_bootstrap(struct drm_device *dev, void *data,
diff --git a/drivers/gpu/drm/mga/mga_state.c b/drivers/gpu/drm/mga/mga_state.c
index 792f924..aeb1334 100644
--- a/drivers/gpu/drm/mga/mga_state.c
+++ b/drivers/gpu/drm/mga/mga_state.c
@@ -1099,4 +1099,4 @@ const struct drm_ioctl_desc mga_ioctls[] = {
 	DRM_IOCTL_DEF_DRV(MGA_DMA_BOOTSTRAP, mga_dma_bootstrap, DRM_AUTH|DRM_MASTER|DRM_ROOT_ONLY),
 };
 
-int mga_max_ioctl = ARRAY_SIZE(mga_ioctls);
+const int mga_max_ioctl = ARRAY_SIZE(mga_ioctls);
diff --git a/drivers/gpu/drm/qxl/qxl_drv.c b/drivers/gpu/drm/qxl/qxl_drv.c
index abf7b83..2584be8 100644
--- a/drivers/gpu/drm/qxl/qxl_drv.c
+++ b/drivers/gpu/drm/qxl/qxl_drv.c
@@ -37,7 +37,7 @@
 #include "qxl_drv.h"
 #include "qxl_object.h"
 
-extern int qxl_max_ioctls;
+extern const int qxl_max_ioctls;
 static const struct pci_device_id pciidlist[] = {
 	{ 0x1b36, 0x100, PCI_ANY_ID, PCI_ANY_ID, PCI_CLASS_DISPLAY_VGA << 8,
 	  0xffff00, 0 },
diff --git a/drivers/gpu/drm/qxl/qxl_ioctl.c b/drivers/gpu/drm/qxl/qxl_ioctl.c
index 0b82a87..ad02c0b 100644
--- a/drivers/gpu/drm/qxl/qxl_ioctl.c
+++ b/drivers/gpu/drm/qxl/qxl_ioctl.c
@@ -439,4 +439,4 @@ const struct drm_ioctl_desc qxl_ioctls[] = {
 			  DRM_AUTH),
 };
 
-int qxl_max_ioctls = ARRAY_SIZE(qxl_ioctls);
+const int qxl_max_ioctls = ARRAY_SIZE(qxl_ioctls);
diff --git a/drivers/gpu/drm/r128/r128_drv.h b/drivers/gpu/drm/r128/r128_drv.h
index 09143b8..acf65d8 100644
--- a/drivers/gpu/drm/r128/r128_drv.h
+++ b/drivers/gpu/drm/r128/r128_drv.h
@@ -135,7 +135,7 @@ typedef struct drm_r128_buf_priv {
 } drm_r128_buf_priv_t;
 
 extern const struct drm_ioctl_desc r128_ioctls[];
-extern int r128_max_ioctl;
+extern const int r128_max_ioctl;
 
 				/* r128_cce.c */
 extern int r128_cce_init(struct drm_device *dev, void *data, struct drm_file *file_priv);
diff --git a/drivers/gpu/drm/r128/r128_state.c b/drivers/gpu/drm/r128/r128_state.c
index 8fd2d9f..b5ea690 100644
--- a/drivers/gpu/drm/r128/r128_state.c
+++ b/drivers/gpu/drm/r128/r128_state.c
@@ -1641,4 +1641,4 @@ const struct drm_ioctl_desc r128_ioctls[] = {
 	DRM_IOCTL_DEF_DRV(R128_GETPARAM, r128_getparam, DRM_AUTH),
 };
 
-int r128_max_ioctl = ARRAY_SIZE(r128_ioctls);
+const int r128_max_ioctl = ARRAY_SIZE(r128_ioctls);
diff --git a/drivers/gpu/drm/savage/savage_bci.c b/drivers/gpu/drm/savage/savage_bci.c
index 2a5b846..93f7f7f 100644
--- a/drivers/gpu/drm/savage/savage_bci.c
+++ b/drivers/gpu/drm/savage/savage_bci.c
@@ -1078,4 +1078,4 @@ const struct drm_ioctl_desc savage_ioctls[] = {
 	DRM_IOCTL_DEF_DRV(SAVAGE_BCI_EVENT_WAIT, savage_bci_event_wait, DRM_AUTH),
 };
 
-int savage_max_ioctl = ARRAY_SIZE(savage_ioctls);
+const int savage_max_ioctl = ARRAY_SIZE(savage_ioctls);
diff --git a/drivers/gpu/drm/savage/savage_drv.h b/drivers/gpu/drm/savage/savage_drv.h
index 44a1009..8d02332 100644
--- a/drivers/gpu/drm/savage/savage_drv.h
+++ b/drivers/gpu/drm/savage/savage_drv.h
@@ -107,7 +107,7 @@ enum savage_family {
 };
 
 extern const struct drm_ioctl_desc savage_ioctls[];
-extern int savage_max_ioctl;
+extern const int savage_max_ioctl;
 
 #define S3_SAVAGE3D_SERIES(chip)  ((chip>=S3_SAVAGE3D) && (chip<=S3_SAVAGE_MX))
 
diff --git a/drivers/gpu/drm/sis/sis_drv.h b/drivers/gpu/drm/sis/sis_drv.h
index 328f8a7..0cfcf55 100644
--- a/drivers/gpu/drm/sis/sis_drv.h
+++ b/drivers/gpu/drm/sis/sis_drv.h
@@ -77,6 +77,6 @@ extern void sis_reclaim_buffers_locked(struct drm_device *dev,
 extern void sis_lastclose(struct drm_device *dev);
 
 extern const struct drm_ioctl_desc sis_ioctls[];
-extern int sis_max_ioctl;
+extern const int sis_max_ioctl;
 
 #endif
diff --git a/drivers/gpu/drm/sis/sis_mm.c b/drivers/gpu/drm/sis/sis_mm.c
index 1622db2..89b5ee6 100644
--- a/drivers/gpu/drm/sis/sis_mm.c
+++ b/drivers/gpu/drm/sis/sis_mm.c
@@ -357,4 +357,4 @@ const struct drm_ioctl_desc sis_ioctls[] = {
 	DRM_IOCTL_DEF_DRV(SIS_FB_INIT, sis_fb_init, DRM_AUTH | DRM_MASTER | DRM_ROOT_ONLY),
 };
 
-int sis_max_ioctl = ARRAY_SIZE(sis_ioctls);
+const int sis_max_ioctl = ARRAY_SIZE(sis_ioctls);
diff --git a/drivers/gpu/drm/via/via_dma.c b/drivers/gpu/drm/via/via_dma.c
index d17d8f2..67e8e48b 100644
--- a/drivers/gpu/drm/via/via_dma.c
+++ b/drivers/gpu/drm/via/via_dma.c
@@ -737,4 +737,4 @@ const struct drm_ioctl_desc via_ioctls[] = {
 	DRM_IOCTL_DEF_DRV(VIA_BLIT_SYNC, via_dma_blit_sync, DRM_AUTH)
 };
 
-int via_max_ioctl = ARRAY_SIZE(via_ioctls);
+const int via_max_ioctl = ARRAY_SIZE(via_ioctls);
diff --git a/drivers/gpu/drm/via/via_drv.h b/drivers/gpu/drm/via/via_drv.h
index 9873942..a54420a 100644
--- a/drivers/gpu/drm/via/via_drv.h
+++ b/drivers/gpu/drm/via/via_drv.h
@@ -121,7 +121,7 @@ enum via_family {
 #define VIA_WRITE8(reg, val)	DRM_WRITE8(VIA_BASE, reg, val)
 
 extern const struct drm_ioctl_desc via_ioctls[];
-extern int via_max_ioctl;
+extern const int via_max_ioctl;
 
 extern int via_fb_init(struct drm_device *dev, void *data, struct drm_file *file_priv);
 extern int via_mem_alloc(struct drm_device *dev, void *data, struct drm_file *file_priv);
-- 
2.8.1.217.ge6ac6e1
