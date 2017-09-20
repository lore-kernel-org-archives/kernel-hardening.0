From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Wed, 20 Sep 2017 16:58:38 +0200
Message-Id: <20170920145839.27511-1-Jason@zx2c4.com>
Subject: [kernel-hardening] [PATCH v7 1/2] security/keys: properly zero out sensitive key material in big_key
To: linux-security-module@vger.kernel.org, keyrings@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, dhowells@redhat.com, ebiggers3@gmail.com
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, Herbert Xu <herbert@gondor.apana.org.au>, Kirill Marinushkin <k.marinushkin@gmail.com>, security@kernel.org, stable@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Error paths forgot to zero out sensitive material, so this patch changes
some kfrees into a kzfrees.

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Reviewed-by: Eric Biggers <ebiggers3@gmail.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Kirill Marinushkin <k.marinushkin@gmail.com>
Cc: security@kernel.org
Cc: stable@vger.kernel.org
---
 security/keys/big_key.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/security/keys/big_key.c b/security/keys/big_key.c
index 6acb00f6f22c..507d6fb86a4f 100644
--- a/security/keys/big_key.c
+++ b/security/keys/big_key.c
@@ -195,7 +195,7 @@ int big_key_preparse(struct key_preparsed_payload *prep)
 		*path = file->f_path;
 		path_get(path);
 		fput(file);
-		kfree(data);
+		kzfree(data);
 	} else {
 		/* Just store the data in a buffer */
 		void *data = kmalloc(datalen, GFP_KERNEL);
@@ -211,9 +211,9 @@ int big_key_preparse(struct key_preparsed_payload *prep)
 err_fput:
 	fput(file);
 err_enckey:
-	kfree(enckey);
+	kzfree(enckey);
 error:
-	kfree(data);
+	kzfree(data);
 	return ret;
 }
 
@@ -227,7 +227,7 @@ void big_key_free_preparse(struct key_preparsed_payload *prep)
 
 		path_put(path);
 	}
-	kfree(prep->payload.data[big_key_data]);
+	kzfree(prep->payload.data[big_key_data]);
 }
 
 /*
@@ -259,7 +259,7 @@ void big_key_destroy(struct key *key)
 		path->mnt = NULL;
 		path->dentry = NULL;
 	}
-	kfree(key->payload.data[big_key_data]);
+	kzfree(key->payload.data[big_key_data]);
 	key->payload.data[big_key_data] = NULL;
 }
 
@@ -328,7 +328,7 @@ long big_key_read(const struct key *key, char __user *buffer, size_t buflen)
 err_fput:
 		fput(file);
 error:
-		kfree(data);
+		kzfree(data);
 	} else {
 		ret = datalen;
 		if (copy_to_user(buffer, key->payload.data[big_key_data],
-- 
2.14.1
