From: "Tobin C. Harding" <me@tobin.cc>
Subject: [PATCH] rbd: Remove VLA stack usage
Date: Mon, 12 Mar 2018 15:49:40 +1100
Message-Id: <1520830180-25452-1-git-send-email-me@tobin.cc>
To: Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>, Alex Elder <elder@kernel.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Tycho Andersen <tycho@tycho.ws>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

The kernel would like to have all stack VLA usage removed[1].  Here the
array is declared using a variable that is declared using a constant
statement but the compiler still emits a warning.  We can clear the
warning bu using the constant statement directly.  In place of later
usage of the size variable we can use the ARRAY_SIZE() macro.

Use constant statement to declare array.

[1]: https://lkml.org/lkml/2018/3/7/621

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---
 drivers/block/rbd.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 0016170cde0a..927ecd9a2511 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -3100,20 +3100,19 @@ static int __rbd_notify_op_lock(struct rbd_device *rbd_dev,
 {
 	struct ceph_osd_client *osdc = &rbd_dev->rbd_client->client->osdc;
 	struct rbd_client_id cid = rbd_get_cid(rbd_dev);
-	int buf_size = 4 + 8 + 8 + CEPH_ENCODING_START_BLK_LEN;
-	char buf[buf_size];
+	char buf[4 + 8 + 8 + CEPH_ENCODING_START_BLK_LEN];
 	void *p = buf;
 
 	dout("%s rbd_dev %p notify_op %d\n", __func__, rbd_dev, notify_op);
 
 	/* encode *LockPayload NotifyMessage (op + ClientId) */
-	ceph_start_encoding(&p, 2, 1, buf_size - CEPH_ENCODING_START_BLK_LEN);
+	ceph_start_encoding(&p, 2, 1, ARRAY_SIZE(buf) - CEPH_ENCODING_START_BLK_LEN);
 	ceph_encode_32(&p, notify_op);
 	ceph_encode_64(&p, cid.gid);
 	ceph_encode_64(&p, cid.handle);
 
 	return ceph_osdc_notify(osdc, &rbd_dev->header_oid,
-				&rbd_dev->header_oloc, buf, buf_size,
+				&rbd_dev->header_oloc, buf, ARRAY_SIZE(buf),
 				RBD_NOTIFY_TIMEOUT, preply_pages, preply_len);
 }
 
-- 
2.7.4
