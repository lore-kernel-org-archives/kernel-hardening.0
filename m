From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue,  6 Jun 2017 02:51:05 +0200
Message-Id: <20170606005108.5646-11-Jason@zx2c4.com>
In-Reply-To: <20170606005108.5646-1-Jason@zx2c4.com>
References: <20170606005108.5646-1-Jason@zx2c4.com>
Subject: [kernel-hardening] [PATCH v3 10/13] net/neighbor: use get_random_u32 for 32-bit hash random
To: Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

Using get_random_u32 here is faster, more fitting of the use case, and
just as cryptographically secure. It also has the benefit of providing
better randomness at early boot, which is when many of these structures
are assigned.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: David Miller <davem@davemloft.net>
---
 net/core/neighbour.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/core/neighbour.c b/net/core/neighbour.c
index d274f81fcc2c..9784133b0cdb 100644
--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -312,8 +312,7 @@ static struct neighbour *neigh_alloc(struct neigh_table *tbl, struct net_device
 
 static void neigh_get_hash_rnd(u32 *x)
 {
-	get_random_bytes(x, sizeof(*x));
-	*x |= 1;
+	*x = get_random_u32() | 1;
 }
 
 static struct neigh_hash_table *neigh_hash_alloc(unsigned int shift)
-- 
2.13.0
