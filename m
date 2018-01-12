From: Dan Williams <dan.j.williams@intel.com>
Date: Thu, 11 Jan 2018 16:47:40 -0800
Message-ID: <151571806069.27429.6683179525235570687.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <151571798296.27429.7166552848688034184.stgit@dwillia2-desk3.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] [PATCH v2 14/19] [media] uvcvideo: prevent bounds-check bypass via
 speculative execution
To: linux-kernel@vger.kernel.org
Cc: linux-arch@vger.kernel.org, alan@linux.intel.com, kernel-hardening@lists.openwall.com, Laurent Pinchart <laurent.pinchart@ideasonboard.com>, tglx@linutronix.de, Mauro Carvalho Chehab <mchehab@kernel.org>, torvalds@linux-foundation.org, akpm@linux-foundation.org, Elena Reshetova <elena.reshetova@intel.com>, linux-media@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Static analysis reports that 'index' may be a user controlled value that
is used as a data dependency to read 'pin' from the
'selector->baSourceID' array. In order to avoid potential leaks of
kernel memory values, block speculative execution of the instruction
stream that could issue reads based on an invalid value of 'pin'.

Based on an original patch by Elena Reshetova.

Laurent notes:

    "...as this is nowhere close to being a fast path, I think we can close
    this potential hole as proposed in the patch"

Cc: Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: linux-media@vger.kernel.org
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/media/usb/uvc/uvc_v4l2.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 3e7e283a44a8..30ee200206ee 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -22,6 +22,7 @@
 #include <linux/mm.h>
 #include <linux/wait.h>
 #include <linux/atomic.h>
+#include <linux/nospec.h>
 
 #include <media/v4l2-common.h>
 #include <media/v4l2-ctrls.h>
@@ -809,8 +810,12 @@ static int uvc_ioctl_enum_input(struct file *file, void *fh,
 	const struct uvc_entity *selector = chain->selector;
 	struct uvc_entity *iterm = NULL;
 	u32 index = input->index;
+	__u8 *elem = NULL;
 	int pin = 0;
 
+	if (selector)
+		elem = array_ptr(selector->baSourceID, index,
+				selector->bNrInPins);
 	if (selector == NULL ||
 	    (chain->dev->quirks & UVC_QUIRK_IGNORE_SELECTOR_UNIT)) {
 		if (index != 0)
@@ -820,8 +825,8 @@ static int uvc_ioctl_enum_input(struct file *file, void *fh,
 				break;
 		}
 		pin = iterm->id;
-	} else if (index < selector->bNrInPins) {
-		pin = selector->baSourceID[index];
+	} else if (elem) {
+		pin = *elem;
 		list_for_each_entry(iterm, &chain->entities, chain) {
 			if (!UVC_ENTITY_IS_ITERM(iterm))
 				continue;
