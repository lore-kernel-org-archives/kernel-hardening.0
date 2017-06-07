From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Thu,  8 Jun 2017 01:26:01 +0200
Message-Id: <20170607232607.26870-8-Jason@zx2c4.com>
In-Reply-To: <20170607232607.26870-1-Jason@zx2c4.com>
References: <20170607232607.26870-1-Jason@zx2c4.com>
Subject: [kernel-hardening] [PATCH v5 07/13] ceph: ensure RNG is seeded before using
To: Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Eric Biggers <ebiggers3@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, David Miller <davem@davemloft.net>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Ilya Dryomov <idryomov@gmail.com>, "Yan, Zheng" <zyan@redhat.com>, Sage Weil <sage@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

Ceph uses the RNG for various nonce generations, and it shouldn't accept
using bad randomness. So, we wait for the RNG to be properly seeded. We
do this by calling wait_for_random_bytes() in a function that is
certainly called in process context, early on, so that all subsequent
calls to get_random_bytes are necessarily acceptable.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Ilya Dryomov <idryomov@gmail.com>
Cc: "Yan, Zheng" <zyan@redhat.com>
Cc: Sage Weil <sage@redhat.com>
---
 net/ceph/ceph_common.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/ceph/ceph_common.c b/net/ceph/ceph_common.c
index 47e94b560ba0..0368a04995b3 100644
--- a/net/ceph/ceph_common.c
+++ b/net/ceph/ceph_common.c
@@ -598,7 +598,11 @@ struct ceph_client *ceph_create_client(struct ceph_options *opt, void *private)
 {
 	struct ceph_client *client;
 	struct ceph_entity_addr *myaddr = NULL;
-	int err = -ENOMEM;
+	int err;
+
+	err = wait_for_random_bytes();
+	if (err < 0)
+		return ERR_PTR(err);
 
 	client = kzalloc(sizeof(*client), GFP_KERNEL);
 	if (client == NULL)
-- 
2.13.0
