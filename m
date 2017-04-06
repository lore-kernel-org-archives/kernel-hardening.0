From: Kees Cook <keescook@chromium.org>
Date: Thu,  6 Apr 2017 14:18:25 -0700
Message-Id: <1491513513-84351-11-git-send-email-keescook@chromium.org>
In-Reply-To: <1491513513-84351-1-git-send-email-keescook@chromium.org>
References: <1491513513-84351-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 10/18] scsi/bfa: use designated initializers
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, Michael Leibowitz <michael.leibowitz@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

Prepare to mark sensitive kernel structures for randomization by making
sure they're using designated initializers. These were identified during
allyesconfig builds of x86, arm, and arm64, with most initializer fixes
extracted from grsecurity.

Signed-off-by: Kees Cook <keescook@chromium.org>
---
 drivers/scsi/bfa/bfa_fcs_lport.c | 29 ++++++++++++++++++++---------
 drivers/scsi/bfa/bfa_modules.h   | 12 ++++++------
 2 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/drivers/scsi/bfa/bfa_fcs_lport.c b/drivers/scsi/bfa/bfa_fcs_lport.c
index 4ddda72f60e6..64860c730ec9 100644
--- a/drivers/scsi/bfa/bfa_fcs_lport.c
+++ b/drivers/scsi/bfa/bfa_fcs_lport.c
@@ -90,15 +90,26 @@ static struct {
 	void		(*offline) (struct bfa_fcs_lport_s *port);
 } __port_action[] = {
 	{
-	bfa_fcs_lport_unknown_init, bfa_fcs_lport_unknown_online,
-			bfa_fcs_lport_unknown_offline}, {
-	bfa_fcs_lport_fab_init, bfa_fcs_lport_fab_online,
-			bfa_fcs_lport_fab_offline}, {
-	bfa_fcs_lport_n2n_init, bfa_fcs_lport_n2n_online,
-			bfa_fcs_lport_n2n_offline}, {
-	bfa_fcs_lport_loop_init, bfa_fcs_lport_loop_online,
-			bfa_fcs_lport_loop_offline},
-	};
+		.init = bfa_fcs_lport_unknown_init,
+		.online = bfa_fcs_lport_unknown_online,
+		.offline = bfa_fcs_lport_unknown_offline
+	},
+	{
+		.init = bfa_fcs_lport_fab_init,
+		.online = bfa_fcs_lport_fab_online,
+		.offline = bfa_fcs_lport_fab_offline
+	},
+	{
+		.init = bfa_fcs_lport_n2n_init,
+		.online = bfa_fcs_lport_n2n_online,
+		.offline = bfa_fcs_lport_n2n_offline
+	},
+	{
+		.init = bfa_fcs_lport_loop_init,
+		.online = bfa_fcs_lport_loop_online,
+		.offline = bfa_fcs_lport_loop_offline
+	},
+};
 
 /*
  *  fcs_port_sm FCS logical port state machine
diff --git a/drivers/scsi/bfa/bfa_modules.h b/drivers/scsi/bfa/bfa_modules.h
index 53135f21fa0e..640621b4c3da 100644
--- a/drivers/scsi/bfa/bfa_modules.h
+++ b/drivers/scsi/bfa/bfa_modules.h
@@ -79,12 +79,12 @@ enum {
 									\
 	extern struct bfa_module_s hal_mod_ ## __mod;			\
 	struct bfa_module_s hal_mod_ ## __mod = {			\
-		bfa_ ## __mod ## _meminfo,				\
-		bfa_ ## __mod ## _attach,				\
-		bfa_ ## __mod ## _detach,				\
-		bfa_ ## __mod ## _start,				\
-		bfa_ ## __mod ## _stop,					\
-		bfa_ ## __mod ## _iocdisable,				\
+		.meminfo = bfa_ ## __mod ## _meminfo,			\
+		.attach = bfa_ ## __mod ## _attach,			\
+		.detach = bfa_ ## __mod ## _detach,			\
+		.start = bfa_ ## __mod ## _start,			\
+		.stop = bfa_ ## __mod ## _stop,				\
+		.iocdisable = bfa_ ## __mod ## _iocdisable,		\
 	}
 
 #define BFA_CACHELINE_SZ	(256)
-- 
2.7.4
