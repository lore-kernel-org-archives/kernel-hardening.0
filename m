From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue,  6 Jun 2017 02:51:03 +0200
Message-Id: <20170606005108.5646-9-Jason@zx2c4.com>
In-Reply-To: <20170606005108.5646-1-Jason@zx2c4.com>
References: <20170606005108.5646-1-Jason@zx2c4.com>
Subject: [kernel-hardening] [PATCH v3 08/13] cifs: use get_random_u32 for 32-bit lock random
To: Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, David Miller <davem@davemloft.net>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Steve French <sfrench@samba.org>
List-ID: <kernel-hardening.lists.openwall.com>

Using get_random_u32 here is faster, more fitting of the use case, and
just as cryptographically secure. It also has the benefit of providing
better randomness at early boot, which is sometimes when this is used.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Steve French <sfrench@samba.org>
---
 fs/cifs/cifsfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/cifs/cifsfs.c b/fs/cifs/cifsfs.c
index 9a1667e0e8d6..fe0c8dcc7dc7 100644
--- a/fs/cifs/cifsfs.c
+++ b/fs/cifs/cifsfs.c
@@ -1359,7 +1359,7 @@ init_cifs(void)
 	spin_lock_init(&cifs_tcp_ses_lock);
 	spin_lock_init(&GlobalMid_Lock);
 
-	get_random_bytes(&cifs_lock_secret, sizeof(cifs_lock_secret));
+	cifs_lock_secret = get_random_u32();
 
 	if (cifs_max_pending < 2) {
 		cifs_max_pending = 2;
-- 
2.13.0
