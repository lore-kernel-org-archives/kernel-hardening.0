From: Dan Aloni <dan@kernelim.com>
Date: Sat, 30 Dec 2017 19:58:01 +0200
Message-Id: <20171230175804.7354-3-alonid@gmail.com>
In-Reply-To: <20171230175804.7354-1-alonid@gmail.com>
References: <20171230175804.7354-1-alonid@gmail.com>
Subject: [kernel-hardening] [PATCH 2/5] certs: allow in-kernel access of trusted keys
To: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: Dan Aloni <dan@kernelim.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Dan Aloni <dan@kernelim.com>

Signed-off-by: Dan Aloni <dan@kernelim.com>
---
 certs/system_keyring.c        | 56 ++++++++++++++++++++++++++++++++++++++++++-
 include/keys/system_keyring.h |  3 +++
 2 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/certs/system_keyring.c b/certs/system_keyring.c
index 6251d1b27f0c..ff7c18d8e67c 100644
--- a/certs/system_keyring.c
+++ b/certs/system_keyring.c
@@ -131,6 +131,8 @@ static __init int system_trusted_keyring_init(void)
  */
 device_initcall(system_trusted_keyring_init);
 
+static char *first_asymmetric_key_description;
+
 /*
  * Load the compiled-in list of X.509 certificates.
  */
@@ -172,8 +174,11 @@ static __init int load_system_certificate_list(void)
 			pr_err("Problem loading in-kernel X.509 certificate (%ld)\n",
 			       PTR_ERR(key));
 		} else {
+			first_asymmetric_key_description =
+				kstrdup(key_ref_to_ptr(key)->description,
+					GFP_KERNEL);
 			pr_notice("Loaded X.509 cert '%s'\n",
-				  key_ref_to_ptr(key)->description);
+				  first_asymmetric_key_description);
 			key_ref_put(key);
 		}
 		p += plen;
@@ -265,3 +270,52 @@ int verify_pkcs7_signature(const void *data, size_t len,
 EXPORT_SYMBOL_GPL(verify_pkcs7_signature);
 
 #endif /* CONFIG_SYSTEM_DATA_VERIFICATION */
+
+/**
+ * get_first_asymmetric_key - Find a key by ID.
+ * @keyring: The keys to search.
+ *
+ * Return the first assymmetric key in a keyring.
+ */
+static struct key *get_first_asymmetric_key(struct key *keyring)
+{
+	key_ref_t ref;
+
+	ref = keyring_search(make_key_ref(keyring, 1),
+	          &key_type_asymmetric,
+		  first_asymmetric_key_description);
+	if (IS_ERR(ref)) {
+		switch (PTR_ERR(ref)) {
+		case -EACCES:
+		case -ENOTDIR:
+		case -EAGAIN:
+			return ERR_PTR(-ENOKEY);
+		default:
+			return ERR_CAST(ref);
+		}
+	}
+
+	return key_ref_to_ptr(ref);
+}
+
+/**
+ * find_asymmetric_key - Find a key by ID in the builtin trusted keys
+ * keyring, or return the first key in that keyring.
+ *
+ * @id_0: The first ID to look for or NULL.
+ * @id_1: The second ID to look for or NULL.
+ *
+ * The preferred identifier is the id_0 and the fallback identifier is
+ * the id_1. If both are given, the lookup is by the former, but the
+ * latter must also match. If none are given, the first key is returned.
+ */
+struct key *find_trusted_asymmetric_key(const struct asymmetric_key_id *id_0,
+					const struct asymmetric_key_id *id_1)
+{
+	struct key *keyring = builtin_trusted_keys;
+	if (!id_0 && !id_1) {
+		return get_first_asymmetric_key(keyring);
+	}
+
+	return find_asymmetric_key(keyring, id_0, id_1, false);
+}
diff --git a/include/keys/system_keyring.h b/include/keys/system_keyring.h
index 359c2f936004..0bef29eb8297 100644
--- a/include/keys/system_keyring.h
+++ b/include/keys/system_keyring.h
@@ -13,6 +13,7 @@
 #define _KEYS_SYSTEM_KEYRING_H
 
 #include <linux/key.h>
+#include <keys/asymmetric-type.h>
 
 #ifdef CONFIG_SYSTEM_TRUSTED_KEYRING
 
@@ -61,5 +62,7 @@ static inline struct key *get_ima_blacklist_keyring(void)
 }
 #endif /* CONFIG_IMA_BLACKLIST_KEYRING */
 
+struct key *find_trusted_asymmetric_key(const struct asymmetric_key_id *id_0,
+					const struct asymmetric_key_id *id_1);
 
 #endif /* _KEYS_SYSTEM_KEYRING_H */
-- 
2.13.6
