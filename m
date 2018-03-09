From: "Tobin C. Harding" <me@tobin.cc>
Subject: [PATCH 3/4] usb: Remove stack VLA usage
Date: Fri,  9 Mar 2018 16:55:35 +1100
Message-Id: <1520574935-7457-1-git-send-email-me@tobin.cc>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org, Tycho Andersen <tycho@tycho.ws>, Kees Cook <keescook@chromium.org>, Felipe Balbi <felipe.balbi@linux.intel.com>, Alan Stern <stern@rowland.harvard.edu>
List-ID: <kernel-hardening.lists.openwall.com>

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 drivers/usb/misc/usbtest.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/misc/usbtest.c b/drivers/usb/misc/usbtest.c
index 90028ef541e3..9e1142b8b91b 100644
--- a/drivers/usb/misc/usbtest.c
+++ b/drivers/usb/misc/usbtest.c
@@ -2028,11 +2028,14 @@ test_queue(struct usbtest_dev *dev, struct usbtest_param_32 *param,
 	unsigned		i;
 	unsigned long		packets = 0;
 	int			status = 0;
-	struct urb		*urbs[param->sglen];
+	struct urb		*urbs[MAX_SGLEN];
 
 	if (!param->sglen || param->iterations > UINT_MAX / param->sglen)
 		return -EINVAL;
 
+	if (param->sglen > MAX_SGLEN)
+		return -EINVAL;
+
 	memset(&context, 0, sizeof(context));
 	context.count = param->iterations * param->sglen;
 	context.dev = dev;
-- 
2.7.4
