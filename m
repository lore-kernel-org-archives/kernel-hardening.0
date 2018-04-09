From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Subject: [PATCH 1/6] crypto: api - laying macros for statically allocated buffers
Date: Mon,  9 Apr 2018 15:53:59 +0200
Message-Id: <1523282044-22075-2-git-send-email-s.mesoraca16@gmail.com>
In-Reply-To: <1523282044-22075-1-git-send-email-s.mesoraca16@gmail.com>
References: <1523282044-22075-1-git-send-email-s.mesoraca16@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: kernel-hardening@lists.openwall.com, linux-crypto@vger.kernel.org, "David S. Miller" <davem@davemloft.net>, Herbert Xu <herbert@gondor.apana.org.au>, Kees Cook <keescook@chromium.org>, Salvatore Mesoraca <s.mesoraca16@gmail.com>, Eric Biggers <ebiggers3@gmail.com>, Laura Abbott <labbott@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

Creating 2 new compile-time constants for internal use,
in preparation for the removal of VLAs[1] from crypto code.
All ciphers implemented in Linux have a block size less than or
equal to 16 bytes and the most demanding hw require 16 bytes
alignment for the block buffer.

[1] http://lkml.kernel.org/r/CA+55aFzCG-zNmZwX4A2FQpadafLfEzK6CC=qPXydAacU1RqZWA@mail.gmail.com

Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
---
 crypto/internal.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/crypto/internal.h b/crypto/internal.h
index 9a3f399..89ae41e 100644
--- a/crypto/internal.h
+++ b/crypto/internal.h
@@ -26,6 +26,14 @@
 #include <linux/rwsem.h>
 #include <linux/slab.h>
 
+/*
+ * Maximum values for blocksize and alignmask, used to allocate
+ * static buffers that are big enough for any combination of
+ * ciphers and architectures.
+ */
+#define MAX_BLOCKSIZE			16
+#define MAX_ALIGNMASK			15
+
 /* Crypto notification events. */
 enum {
 	CRYPTO_MSG_ALG_REQUEST,
-- 
1.9.1
