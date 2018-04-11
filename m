From: Laura Abbott <labbott@redhat.com>
Subject: [PATCHv2] misc: tifm: Remove VLA
Date: Tue, 10 Apr 2018 18:04:12 -0700
Message-Id: <20180411010412.18006-1-labbott@redhat.com>
To: Alex Dubov <oakad@yahoo.com>, Arnd Bergmann <arnd@arndb.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Laura Abbott <labbott@redhat.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

There's an ongoing effort to remove VLAs[1] from the kernel to eventually
turn on -Wvla. The single VLA can either take a value of 2 or 4 so switch
to the upper bound.

[1] https://lkml.org/lkml/2018/3/7/621

Signed-off-by: Laura Abbott <labbott@redhat.com>
---
v2: Add extra bounds check per request of Arnd
---
 drivers/misc/tifm_7xx1.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/misc/tifm_7xx1.c b/drivers/misc/tifm_7xx1.c
index e5f108713dd8..9ac95b48ef92 100644
--- a/drivers/misc/tifm_7xx1.c
+++ b/drivers/misc/tifm_7xx1.c
@@ -239,9 +239,13 @@ static int tifm_7xx1_resume(struct pci_dev *dev)
 	unsigned long timeout;
 	unsigned int good_sockets = 0, bad_sockets = 0;
 	unsigned long flags;
-	unsigned char new_ids[fm->num_sockets];
+	/* Maximum number of entries is 4 */
+	unsigned char new_ids[4];
 	DECLARE_COMPLETION_ONSTACK(finish_resume);
 
+	if (WARN_ON(fm->num_sockets > ARRAY_SIZE(new_ids)))
+		return -ENXIO;
+
 	pci_set_power_state(dev, PCI_D0);
 	pci_restore_state(dev);
 	rc = pci_enable_device(dev);
-- 
2.14.3
