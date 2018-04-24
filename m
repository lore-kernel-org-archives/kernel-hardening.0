From: Tycho Andersen <tycho@tycho.ws>
Subject: [PATCH v3 3/3] dh key: get rid of stack allocated array for zeroes
Date: Tue, 24 Apr 2018 14:26:39 -0600
Message-Id: <20180424202639.19830-3-tycho@tycho.ws>
In-Reply-To: <20180424202639.19830-1-tycho@tycho.ws>
References: <20180424202639.19830-1-tycho@tycho.ws>
To: David Howells <dhowells@redhat.com>
Cc: keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Tycho Andersen <tycho@tycho.ws>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Eric Biggers <ebiggers3@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

We're interested in getting rid of all of the stack allocated arrays in
the kernel: https://lkml.org/lkml/2018/3/7/621

This case is interesting, since we really just need an array of bytes that
are zero. The loop already ensures that if the array isn't exactly the
right size that enough zero bytes will be copied in. So, instead of
choosing this value to be the size of the hash, let's just choose it to be
32, since that is a common size, is not too big, and will not result in too
many extra iterations of the loop.

v2: split out from other patch, just hardcode array size instead of
    dynamically allocating something the right size
v3: fix typo of 256 -> 32

Signed-off-by: Tycho Andersen <tycho@tycho.ws>
CC: David Howells <dhowells@redhat.com>
CC: James Morris <jmorris@namei.org>
CC: "Serge E. Hallyn" <serge@hallyn.com>
CC: Eric Biggers <ebiggers3@gmail.com>
---
 security/keys/dh.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/security/keys/dh.c b/security/keys/dh.c
index 9fecaea6c298..f7403821db7f 100644
--- a/security/keys/dh.c
+++ b/security/keys/dh.c
@@ -162,8 +162,8 @@ static int kdf_ctr(struct kdf_sdesc *sdesc, const u8 *src, unsigned int slen,
 			goto err;
 
 		if (zlen && h) {
-			u8 tmpbuffer[h];
-			size_t chunk = min_t(size_t, zlen, h);
+			u8 tmpbuffer[32];
+			size_t chunk = min_t(size_t, zlen, sizeof(tmpbuffer));
 			memset(tmpbuffer, 0, chunk);
 
 			do {
@@ -173,7 +173,7 @@ static int kdf_ctr(struct kdf_sdesc *sdesc, const u8 *src, unsigned int slen,
 					goto err;
 
 				zlen -= chunk;
-				chunk = min_t(size_t, zlen, h);
+				chunk = min_t(size_t, zlen, sizeof(tmpbuffer));
 			} while (zlen);
 		}
 
-- 
2.17.0
