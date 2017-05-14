From: Lionel Debroux <lionel_debroux@yahoo.fr>
Date: Sun, 14 May 2017 11:33:27 +0200
Message-Id: <1494754407-31455-2-git-send-email-lionel_debroux@yahoo.fr>
In-Reply-To: <1494754407-31455-1-git-send-email-lionel_debroux@yahoo.fr>
References: <1494754407-31455-1-git-send-email-lionel_debroux@yahoo.fr>
Subject: [kernel-hardening] [PATCH] drivers/media: improve the return type of a bunch of .get_frontend_algo callbacks.
To: kernel-hardening@lists.openwall.com
Cc: Lionel Debroux <lionel_debroux@yahoo.fr>
List-ID: <kernel-hardening.lists.openwall.com>

The definition of struct dvb_frontend_ops has .get_frontend_algo return
enum dvbfe_algo, so use that instead of the less descriptive "int".

Extracted from PaX/grsecurity.

Signed-off-by: Lionel Debroux <lionel_debroux@yahoo.fr>
---
 drivers/media/dvb-frontends/cx24116.c       | 2 +-
 drivers/media/dvb-frontends/cx24117.c       | 2 +-
 drivers/media/dvb-frontends/cx24120.c       | 2 +-
 drivers/media/dvb-frontends/cx24123.c       | 2 +-
 drivers/media/dvb-frontends/cxd2820r_core.c | 2 +-
 drivers/media/dvb-frontends/mb86a20s.c      | 2 +-
 drivers/media/dvb-frontends/s921.c          | 2 +-
 drivers/media/pci/bt8xx/dst.c               | 2 +-
 drivers/media/pci/pt1/va1j5jf8007s.c        | 2 +-
 drivers/media/pci/pt1/va1j5jf8007t.c        | 2 +-
 10 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/media/dvb-frontends/cx24116.c b/drivers/media/dvb-frontends/cx24116.c
index e105532..e07d52bb 100644
--- a/drivers/media/dvb-frontends/cx24116.c
+++ b/drivers/media/dvb-frontends/cx24116.c
@@ -1462,7 +1462,7 @@ static int cx24116_tune(struct dvb_frontend *fe, bool re_tune,
 	return cx24116_read_status(fe, status);
 }
 
-static int cx24116_get_algo(struct dvb_frontend *fe)
+static enum dvbfe_algo cx24116_get_algo(struct dvb_frontend *fe)
 {
 	return DVBFE_ALGO_HW;
 }
diff --git a/drivers/media/dvb-frontends/cx24117.c b/drivers/media/dvb-frontends/cx24117.c
index d37cb77..97e0fef 100644
--- a/drivers/media/dvb-frontends/cx24117.c
+++ b/drivers/media/dvb-frontends/cx24117.c
@@ -1555,7 +1555,7 @@ static int cx24117_tune(struct dvb_frontend *fe, bool re_tune,
 	return cx24117_read_status(fe, status);
 }
 
-static int cx24117_get_algo(struct dvb_frontend *fe)
+static enum dvbfe_algo cx24117_get_algo(struct dvb_frontend *fe)
 {
 	return DVBFE_ALGO_HW;
 }
diff --git a/drivers/media/dvb-frontends/cx24120.c b/drivers/media/dvb-frontends/cx24120.c
index 7f11dcc..01da670 100644
--- a/drivers/media/dvb-frontends/cx24120.c
+++ b/drivers/media/dvb-frontends/cx24120.c
@@ -1491,7 +1491,7 @@ static int cx24120_tune(struct dvb_frontend *fe, bool re_tune,
 	return cx24120_read_status(fe, status);
 }
 
-static int cx24120_get_algo(struct dvb_frontend *fe)
+static enum dvbfe_algo cx24120_get_algo(struct dvb_frontend *fe)
 {
 	return DVBFE_ALGO_HW;
 }
diff --git a/drivers/media/dvb-frontends/cx24123.c b/drivers/media/dvb-frontends/cx24123.c
index 4ae3d92..1292c05 100644
--- a/drivers/media/dvb-frontends/cx24123.c
+++ b/drivers/media/dvb-frontends/cx24123.c
@@ -1005,7 +1005,7 @@ static int cx24123_tune(struct dvb_frontend *fe,
 	return retval;
 }
 
-static int cx24123_get_algo(struct dvb_frontend *fe)
+static enum dvbfe_algo cx24123_get_algo(struct dvb_frontend *fe)
 {
 	return DVBFE_ALGO_HW;
 }
diff --git a/drivers/media/dvb-frontends/cxd2820r_core.c b/drivers/media/dvb-frontends/cxd2820r_core.c
index f6ebbb4..3e0d8cb 100644
--- a/drivers/media/dvb-frontends/cxd2820r_core.c
+++ b/drivers/media/dvb-frontends/cxd2820r_core.c
@@ -403,7 +403,7 @@ static enum dvbfe_search cxd2820r_search(struct dvb_frontend *fe)
 	return DVBFE_ALGO_SEARCH_ERROR;
 }
 
-static int cxd2820r_get_frontend_algo(struct dvb_frontend *fe)
+static enum dvbfe_algo cxd2820r_get_frontend_algo(struct dvb_frontend *fe)
 {
 	return DVBFE_ALGO_CUSTOM;
 }
diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index e8ac8c3..e0f4ba8 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -2055,7 +2055,7 @@ static void mb86a20s_release(struct dvb_frontend *fe)
 	kfree(state);
 }
 
-static int mb86a20s_get_frontend_algo(struct dvb_frontend *fe)
+static enum dvbfe_algo mb86a20s_get_frontend_algo(struct dvb_frontend *fe)
 {
         return DVBFE_ALGO_HW;
 }
diff --git a/drivers/media/dvb-frontends/s921.c b/drivers/media/dvb-frontends/s921.c
index 274544a..9ef9b9b 100644
--- a/drivers/media/dvb-frontends/s921.c
+++ b/drivers/media/dvb-frontends/s921.c
@@ -464,7 +464,7 @@ static int s921_tune(struct dvb_frontend *fe,
 	return rc;
 }
 
-static int s921_get_algo(struct dvb_frontend *fe)
+static enum dvbfe_algo s921_get_algo(struct dvb_frontend *fe)
 {
 	return DVBFE_ALGO_HW;
 }
diff --git a/drivers/media/pci/bt8xx/dst.c b/drivers/media/pci/bt8xx/dst.c
index 7166d22..fa682f9 100644
--- a/drivers/media/pci/bt8xx/dst.c
+++ b/drivers/media/pci/bt8xx/dst.c
@@ -1657,7 +1657,7 @@ static int dst_tune_frontend(struct dvb_frontend* fe,
 	return 0;
 }
 
-static int dst_get_tuning_algo(struct dvb_frontend *fe)
+static enum dvbfe_algo dst_get_tuning_algo(struct dvb_frontend *fe)
 {
 	return dst_algo ? DVBFE_ALGO_HW : DVBFE_ALGO_SW;
 }
diff --git a/drivers/media/pci/pt1/va1j5jf8007s.c b/drivers/media/pci/pt1/va1j5jf8007s.c
index f75f695..d913a60 100644
--- a/drivers/media/pci/pt1/va1j5jf8007s.c
+++ b/drivers/media/pci/pt1/va1j5jf8007s.c
@@ -98,7 +98,7 @@ static int va1j5jf8007s_read_snr(struct dvb_frontend *fe, u16 *snr)
 	return 0;
 }
 
-static int va1j5jf8007s_get_frontend_algo(struct dvb_frontend *fe)
+static enum dvbfe_algo va1j5jf8007s_get_frontend_algo(struct dvb_frontend *fe)
 {
 	return DVBFE_ALGO_HW;
 }
diff --git a/drivers/media/pci/pt1/va1j5jf8007t.c b/drivers/media/pci/pt1/va1j5jf8007t.c
index 63fda79..4115c3c 100644
--- a/drivers/media/pci/pt1/va1j5jf8007t.c
+++ b/drivers/media/pci/pt1/va1j5jf8007t.c
@@ -88,7 +88,7 @@ static int va1j5jf8007t_read_snr(struct dvb_frontend *fe, u16 *snr)
 	return 0;
 }
 
-static int va1j5jf8007t_get_frontend_algo(struct dvb_frontend *fe)
+static enum dvbfe_algo va1j5jf8007t_get_frontend_algo(struct dvb_frontend *fe)
 {
 	return DVBFE_ALGO_HW;
 }
-- 
2.8.1.217.ge6ac6e1
