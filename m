From: Tycho Andersen <tycho@tycho.ws>
Subject: [PATCH 2/3] dh key: get rid of stack allocated array
Date: Mon, 23 Apr 2018 19:03:20 -0600
Message-Id: <20180424010321.14739-2-tycho@tycho.ws>
In-Reply-To: <20180424010321.14739-1-tycho@tycho.ws>
References: <20180424010321.14739-1-tycho@tycho.ws>
To: David Howells <dhowells@redhat.com>
Cc: keyrings@vger.kernel.org, linux-security-module@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Tycho Andersen <tycho@tycho.ws>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Eric Biggers <ebiggers3@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

We're interested in getting rid of all of the stack allocated arrays in the
kernel: https://lkml.org/lkml/2018/3/7/621

This particular vla is used as a temporary output buffer in case there is
too much hash output for the destination buffer. Instead, let's just
allocate a buffer that's big enough initially, but only copy back to
userspace the amount that was originally asked for.

v2: allocate enough in the original output buffer vs creating a temporary
    output buffer

Signed-off-by: Tycho Andersen <tycho@tycho.ws>
CC: David Howells <dhowells@redhat.com>
CC: James Morris <jmorris@namei.org>
CC: "Serge E. Hallyn" <serge@hallyn.com>
CC: Eric Biggers <ebiggers3@gmail.com>
---
 security/keys/dh.c | 29 ++++++++++-------------------
 1 file changed, 10 insertions(+), 19 deletions(-)

diff --git a/security/keys/dh.c b/security/keys/dh.c
index d1ea9f325f94..9fecaea6c298 100644
--- a/security/keys/dh.c
+++ b/security/keys/dh.c
@@ -183,24 +183,13 @@ static int kdf_ctr(struct kdf_sdesc *sdesc, const u8 *src, unsigned int slen,
 				goto err;
 		}
 
-		if (dlen < h) {
-			u8 tmpbuffer[h];
-
-			err = crypto_shash_final(desc, tmpbuffer);
-			if (err)
-				goto err;
-			memcpy(dst, tmpbuffer, dlen);
-			memzero_explicit(tmpbuffer, h);
-			return 0;
-		} else {
-			err = crypto_shash_final(desc, dst);
-			if (err)
-				goto err;
+		err = crypto_shash_final(desc, dst);
+		if (err)
+			goto err;
 
-			dlen -= h;
-			dst += h;
-			counter = cpu_to_be32(be32_to_cpu(counter) + 1);
-		}
+		dlen -= h;
+		dst += h;
+		counter = cpu_to_be32(be32_to_cpu(counter) + 1);
 	}
 
 	return 0;
@@ -216,14 +205,16 @@ static int keyctl_dh_compute_kdf(struct kdf_sdesc *sdesc,
 {
 	uint8_t *outbuf = NULL;
 	int ret;
+	size_t outbuf_len = round_up(buflen,
+			             crypto_shash_digestsize(sdesc->shash.tfm));
 
-	outbuf = kmalloc(buflen, GFP_KERNEL);
+	outbuf = kmalloc(outbuf_len, GFP_KERNEL);
 	if (!outbuf) {
 		ret = -ENOMEM;
 		goto err;
 	}
 
-	ret = kdf_ctr(sdesc, kbuf, kbuflen, outbuf, buflen, lzero);
+	ret = kdf_ctr(sdesc, kbuf, kbuflen, outbuf, outbuf_len, lzero);
 	if (ret)
 		goto err;
 
-- 
2.17.0
