From: "Tobin C. Harding" <me@tobin.cc>
Subject: [PATCH] rbd: Remove VLA saving ack buffer size
Date: Mon, 12 Mar 2018 16:00:08 +1100
Message-Id: <1520830808-26991-1-git-send-email-me@tobin.cc>
To: Ilya Dryomov <idryomov@gmail.com>, Sage Weil <sage@redhat.com>, Alex Elder <elder@kernel.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Tycho Andersen <tycho@tycho.ws>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

The kernel would like to have all stack VLA usage removed[1].  Here the
array is declared using a variable that is declared using a constant
statement but the compiler still emits a warning.  We can clear the
warning bu using the constant statement directly.  The buffer size
variable is set to zero on the error path; the buffer size variable is
used later in the function, we can maintain this behavior by setting the
variable using the macro ARRAY_SIZE.

Use constant statement to declare array.

[1]: https://lkml.org/lkml/2018/3/7/621

Signed-off-by: Tobin C. Harding <me@tobin.cc>
---

Excuse the lack of threading, I forgot the second patch ;)  Can re-send
threaded correctly if required.

 drivers/block/rbd.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index 927ecd9a2511..7c228753fddd 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -3618,13 +3618,14 @@ static void __rbd_acknowledge_notify(struct rbd_device *rbd_dev,
 				     u64 notify_id, u64 cookie, s32 *result)
 {
 	struct ceph_osd_client *osdc = &rbd_dev->rbd_client->client->osdc;
-	int buf_size = 4 + CEPH_ENCODING_START_BLK_LEN;
-	char buf[buf_size];
+	char buf[4 + CEPH_ENCODING_START_BLK_LEN];
+	int buf_size;
 	int ret;
 
 	if (result) {
 		void *p = buf;
 
+		buf_size = ARRAY_SIZE(buf);
 		/* encode ResponseMessage */
 		ceph_start_encoding(&p, 1, 1,
 				    buf_size - CEPH_ENCODING_START_BLK_LEN);
-- 
2.7.4
