From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Thu,  8 Jun 2017 01:26:05 +0200
Message-Id: <20170607232607.26870-12-Jason@zx2c4.com>
In-Reply-To: <20170607232607.26870-1-Jason@zx2c4.com>
References: <20170607232607.26870-1-Jason@zx2c4.com>
Subject: [kernel-hardening] [PATCH v5 11/13] net/route: use get_random_int for random counter
To: Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Eric Biggers <ebiggers3@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, David Miller <davem@davemloft.net>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

Using get_random_int here is faster, more fitting of the use case, and
just as cryptographically secure. It also has the benefit of providing
better randomness at early boot, which is when many of these structures
are assigned.

Also, semantically, it's not really proper to have been assigning an
atomic_t in this way before, even if in practice it works fine.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: David Miller <davem@davemloft.net>
---
 net/ipv4/route.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/ipv4/route.c b/net/ipv4/route.c
index 6883b3d4ba8f..32a3332ec9cf 100644
--- a/net/ipv4/route.c
+++ b/net/ipv4/route.c
@@ -2944,8 +2944,7 @@ static __net_init int rt_genid_init(struct net *net)
 {
 	atomic_set(&net->ipv4.rt_genid, 0);
 	atomic_set(&net->fnhe_genid, 0);
-	get_random_bytes(&net->ipv4.dev_addr_genid,
-			 sizeof(net->ipv4.dev_addr_genid));
+	atomic_set(&net->ipv4.dev_addr_genid, get_random_int());
 	return 0;
 }
 
-- 
2.13.0
