From: Kees Cook <keescook@chromium.org>
Date: Fri, 26 May 2017 13:17:19 -0700
Message-Id: <1495829844-69341-16-git-send-email-keescook@chromium.org>
In-Reply-To: <1495829844-69341-1-git-send-email-keescook@chromium.org>
References: <1495829844-69341-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH v2 15/20] mtk-vcodec: Use designated initializers
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Wu-Cheng Li <wuchengli@chromium.org>, PC Chen <pc.chen@mediatek.com>, Tiffany Lin <tiffany.lin@mediatek.com>, Hans Verkuil <hans.verkuil@cisco.com>, Mauro Carvalho Chehab <mchehab@s-opensource.com>, Laura Abbott <labbott@redhat.com>, x86@kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

The randstruct plugin requires designated initializers for structures
that are entirely function pointers.

Cc: Wu-Cheng Li <wuchengli@chromium.org>
Cc: PC Chen <pc.chen@mediatek.com>
Cc: Tiffany Lin <tiffany.lin@mediatek.com>
Cc: Hans Verkuil <hans.verkuil@cisco.com>
Cc: Mauro Carvalho Chehab <mchehab@s-opensource.com>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/media/platform/mtk-vcodec/vdec/vdec_h264_if.c | 8 ++++----
 drivers/media/platform/mtk-vcodec/vdec/vdec_vp8_if.c  | 8 ++++----
 drivers/media/platform/mtk-vcodec/vdec/vdec_vp9_if.c  | 8 ++++----
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/media/platform/mtk-vcodec/vdec/vdec_h264_if.c b/drivers/media/platform/mtk-vcodec/vdec/vdec_h264_if.c
index 57a842ff3097..b7731b18ecae 100644
--- a/drivers/media/platform/mtk-vcodec/vdec/vdec_h264_if.c
+++ b/drivers/media/platform/mtk-vcodec/vdec/vdec_h264_if.c
@@ -493,10 +493,10 @@ static int vdec_h264_get_param(unsigned long h_vdec,
 }
 
 static struct vdec_common_if vdec_h264_if = {
-	vdec_h264_init,
-	vdec_h264_decode,
-	vdec_h264_get_param,
-	vdec_h264_deinit,
+	.init		= vdec_h264_init,
+	.decode		= vdec_h264_decode,
+	.get_param	= vdec_h264_get_param,
+	.deinit		= vdec_h264_deinit,
 };
 
 struct vdec_common_if *get_h264_dec_comm_if(void);
diff --git a/drivers/media/platform/mtk-vcodec/vdec/vdec_vp8_if.c b/drivers/media/platform/mtk-vcodec/vdec/vdec_vp8_if.c
index 6e7a62ae0842..b9fad6a48879 100644
--- a/drivers/media/platform/mtk-vcodec/vdec/vdec_vp8_if.c
+++ b/drivers/media/platform/mtk-vcodec/vdec/vdec_vp8_if.c
@@ -620,10 +620,10 @@ static void vdec_vp8_deinit(unsigned long h_vdec)
 }
 
 static struct vdec_common_if vdec_vp8_if = {
-	vdec_vp8_init,
-	vdec_vp8_decode,
-	vdec_vp8_get_param,
-	vdec_vp8_deinit,
+	.init		= vdec_vp8_init,
+	.decode		= vdec_vp8_decode,
+	.get_param	= vdec_vp8_get_param,
+	.deinit		= vdec_vp8_deinit,
 };
 
 struct vdec_common_if *get_vp8_dec_comm_if(void);
diff --git a/drivers/media/platform/mtk-vcodec/vdec/vdec_vp9_if.c b/drivers/media/platform/mtk-vcodec/vdec/vdec_vp9_if.c
index 5539b1853f16..1daee1207469 100644
--- a/drivers/media/platform/mtk-vcodec/vdec/vdec_vp9_if.c
+++ b/drivers/media/platform/mtk-vcodec/vdec/vdec_vp9_if.c
@@ -979,10 +979,10 @@ static int vdec_vp9_get_param(unsigned long h_vdec,
 }
 
 static struct vdec_common_if vdec_vp9_if = {
-	vdec_vp9_init,
-	vdec_vp9_decode,
-	vdec_vp9_get_param,
-	vdec_vp9_deinit,
+	.init		= vdec_vp9_init,
+	.decode		= vdec_vp9_decode,
+	.get_param	= vdec_vp9_get_param,
+	.deinit		= vdec_vp9_deinit,
 };
 
 struct vdec_common_if *get_vp9_dec_comm_if(void);
-- 
2.7.4
