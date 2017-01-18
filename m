Reply-To: kernel-hardening@lists.openwall.com
From: Elena Reshetova <elena.reshetova@intel.com>
Date: Wed, 18 Jan 2017 11:11:35 +0200
Message-Id: <1484730707-29313-7-git-send-email-elena.reshetova@intel.com>
In-Reply-To: <1484730707-29313-1-git-send-email-elena.reshetova@intel.com>
References: <1484730707-29313-1-git-send-email-elena.reshetova@intel.com>
Subject: [kernel-hardening] [RFCv2 PATCH 06/18] kref: Avoid more abuse
To: kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, arnd@arndb.de, tglx@linutronix.de, mingo@redhat.com, h.peter.anvin@intel.com, peterz@infradead.org, will.deacon@arm.com, dwindsor@gmail.com, gregkh@linuxfoundation.org
List-ID: <kernel-hardening.lists.openwall.com>

From: Peter Zijlstra <peterz@infradead.org>

Leak references by unbalanced get, instead of poking at kref
implementation details.

Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/usb/mon/mon_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/mon/mon_main.c b/drivers/usb/mon/mon_main.c
index 33ff49c..4684734 100644
--- a/drivers/usb/mon/mon_main.c
+++ b/drivers/usb/mon/mon_main.c
@@ -409,7 +409,7 @@ static void __exit mon_exit(void)
 			printk(KERN_ERR TAG
 			    ": Outstanding opens (%d) on usb%d, leaking...\n",
 			    mbus->nreaders, mbus->u_bus->busnum);
-			atomic_set(&mbus->ref.refcount, 2);	/* Force leak */
+			kref_get(&mbus->ref); /* Force leak */
 		}
 
 		mon_dissolve(mbus, mbus->u_bus);
-- 
2.7.4
