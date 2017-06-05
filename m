From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Mon,  5 Jun 2017 05:47:54 +0200
Message-Id: <20170605034757.4803-6-Jason@zx2c4.com>
In-Reply-To: <20170605034757.4803-1-Jason@zx2c4.com>
References: <20170605034757.4803-1-Jason@zx2c4.com>
Subject: [kernel-hardening] [PATCH RFC v2 5/8] security/keys: ensure RNG is seeded before use
To: Theodore Ts'o <tytso@mit.edu>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, David Howells <dhowells@redhat.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, David Safford <safford@us.ibm.com>
List-ID: <kernel-hardening.lists.openwall.com>

Otherwise, we might use bad random numbers which, particularly in the
case of IV generation, could be quite bad. It makes sense to use the
synchronous API here, because we're always in process context (as the
code is littered with GFP_KERNEL and the like).

Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: David Safford <safford@us.ibm.com>
---
 security/keys/encrypted-keys/encrypted.c |  8 +++++---
 security/keys/key.c                      | 13 +++++++++----
 2 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/security/keys/encrypted-keys/encrypted.c b/security/keys/encrypted-keys/encrypted.c
index 0010955d7876..d51a28fc5cd5 100644
--- a/security/keys/encrypted-keys/encrypted.c
+++ b/security/keys/encrypted-keys/encrypted.c
@@ -777,10 +777,12 @@ static int encrypted_init(struct encrypted_key_payload *epayload,
 
 	__ekey_init(epayload, format, master_desc, datalen);
 	if (!hex_encoded_iv) {
-		get_random_bytes(epayload->iv, ivsize);
+		ret = get_random_bytes_wait(epayload->iv, ivsize);
+		if (unlikely(ret))
+			return ret;
 
-		get_random_bytes(epayload->decrypted_data,
-				 epayload->decrypted_datalen);
+		ret = get_random_bytes_wait(epayload->decrypted_data,
+					    epayload->decrypted_datalen);
 	} else
 		ret = encrypted_key_decrypt(epayload, format, hex_encoded_iv);
 	return ret;
diff --git a/security/keys/key.c b/security/keys/key.c
index 455c04d80bbb..1e0367475a4c 100644
--- a/security/keys/key.c
+++ b/security/keys/key.c
@@ -134,15 +134,18 @@ void key_user_put(struct key_user *user)
  * Allocate a serial number for a key.  These are assigned randomly to avoid
  * security issues through covert channel problems.
  */
-static inline void key_alloc_serial(struct key *key)
+static inline int key_alloc_serial(struct key *key)
 {
 	struct rb_node *parent, **p;
 	struct key *xkey;
+	int ret;
 
 	/* propose a random serial number and look for a hole for it in the
 	 * serial number tree */
 	do {
-		get_random_bytes(&key->serial, sizeof(key->serial));
+		ret = get_random_bytes_wait(&key->serial, sizeof(key->serial));
+		if (unlikely(ret))
+			return ret;
 
 		key->serial >>= 1; /* negative numbers are not permitted */
 	} while (key->serial < 3);
@@ -170,7 +173,7 @@ static inline void key_alloc_serial(struct key *key)
 	rb_insert_color(&key->serial_node, &key_serial_tree);
 
 	spin_unlock(&key_serial_lock);
-	return;
+	return 0;
 
 	/* we found a key with the proposed serial number - walk the tree from
 	 * that point looking for the next unused serial number */
@@ -314,7 +317,9 @@ struct key *key_alloc(struct key_type *type, const char *desc,
 
 	/* publish the key by giving it a serial number */
 	atomic_inc(&user->nkeys);
-	key_alloc_serial(key);
+	ret = key_alloc_serial(key);
+	if (ret < 0)
+		goto security_error;
 
 error:
 	return key;
-- 
2.13.0
