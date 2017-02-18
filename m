From: Eddie Kovsky <ewk@edkovsky.org>
Date: Fri, 17 Feb 2017 22:58:44 -0700
Message-Id: <20170218055844.1457-4-ewk@edkovsky.org>
In-Reply-To: <20170218055844.1457-1-ewk@edkovsky.org>
References: <20170218055844.1457-1-ewk@edkovsky.org>
Subject: [kernel-hardening] [PATCH v2 3/3] Make vmbus register arguments read-only
To: jeyu@redhat.com, rusty@rustcorp.com.au, keescook@chromium.org, kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Use the new RO check functions introduced in this series to make the
vmbus register functions verify that the address of their arguments are
read-only. Addresses that fail the verification are rejected.

Signed-off-by: Eddie Kovsky <ewk@edkovsky.org>
---
 drivers/hv/vmbus_drv.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/hv/vmbus_drv.c b/drivers/hv/vmbus_drv.c
index c1b27026f744..e527454ffa59 100644
--- a/drivers/hv/vmbus_drv.c
+++ b/drivers/hv/vmbus_drv.c
@@ -1026,6 +1026,11 @@ int __vmbus_driver_register(struct hv_driver *hv_driver, struct module *owner, c
 	if (ret < 0)
 		return ret;

+	ret = kernel_ro_address(&hv_driver);
+	if (ret < 1)
+		pr_err("Module address is not read-only.");
+		return ret;
+
 	hv_driver->driver.name = hv_driver->name;
 	hv_driver->driver.owner = owner;
 	hv_driver->driver.mod_name = mod_name;
@@ -1092,6 +1097,11 @@ int vmbus_device_register(struct hv_device *child_device_obj)
 {
 	int ret = 0;

+	ret = kernel_ro_address(&child_device_obj);
+	if (ret < 1)
+		pr_err("Device address is not read-only.");
+		return ret;
+
 	dev_set_name(&child_device_obj->device, "%pUl",
 		     child_device_obj->channel->offermsg.offer.if_instance.b);

--
2.11.1
