From: Dan Aloni <dan@kernelim.com>
Date: Sat, 30 Dec 2017 19:58:03 +0200
Message-Id: <20171230175804.7354-5-alonid@gmail.com>
In-Reply-To: <20171230175804.7354-1-alonid@gmail.com>
References: <20171230175804.7354-1-alonid@gmail.com>
Subject: [kernel-hardening] [PATCH 4/5] tools: add dmesg decryption program
To: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Cc: Dan Aloni <dan@kernelim.com>
List-ID: <kernel-hardening.lists.openwall.com>

From: Dan Aloni <dan@kernelim.com>

Example execution:

    dmesg | dmesg-decipher <private-key.pem>

Signed-off-by: Dan Aloni <dan@kernelim.com>
---
 tools/Makefile              |   5 +-
 tools/kmsg/.gitignore       |   1 +
 tools/kmsg/Makefile         |  14 ++
 tools/kmsg/dmesg-decipher.c | 316 ++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 335 insertions(+), 1 deletion(-)
 create mode 100644 tools/kmsg/.gitignore
 create mode 100644 tools/kmsg/Makefile
 create mode 100644 tools/kmsg/dmesg-decipher.c

diff --git a/tools/Makefile b/tools/Makefile
index be02c8b904db..d92d86e0227c 100644
--- a/tools/Makefile
+++ b/tools/Makefile
@@ -167,6 +167,9 @@ tmon_clean:
 freefall_clean:
 	$(call descend,laptop/freefall,clean)
 
+kmsg:
+	$(call descend,kmsg,clean)
+
 build_clean:
 	$(call descend,build,clean)
 
@@ -174,6 +177,6 @@ clean: acpi_clean cgroup_clean cpupower_clean hv_clean firewire_clean \
 		perf_clean selftests_clean turbostat_clean spi_clean usb_clean virtio_clean \
 		vm_clean bpf_clean iio_clean x86_energy_perf_policy_clean tmon_clean \
 		freefall_clean build_clean libbpf_clean libsubcmd_clean liblockdep_clean \
-		gpio_clean objtool_clean leds_clean wmi_clean
+		gpio_clean objtool_clean leds_clean wmi_clean kmsg
 
 .PHONY: FORCE
diff --git a/tools/kmsg/.gitignore b/tools/kmsg/.gitignore
new file mode 100644
index 000000000000..a5b4e26b8d0b
--- /dev/null
+++ b/tools/kmsg/.gitignore
@@ -0,0 +1 @@
+dmesg-decipher
diff --git a/tools/kmsg/Makefile b/tools/kmsg/Makefile
new file mode 100644
index 000000000000..9f4ef7b11798
--- /dev/null
+++ b/tools/kmsg/Makefile
@@ -0,0 +1,14 @@
+# SPDX-License-Identifier: GPL-2.0
+CC := $(CROSS_COMPILE)gcc
+
+CFLAGS := -O2 -Wall $$(pkg-config --libs openssl)
+
+PROGS := dmesg-decipher
+
+%: %.c
+	$(CC) $(CFLAGS) -o $@ $^
+
+all: $(PROGS)
+
+clean:
+	rm -fr $(PROGS)
diff --git a/tools/kmsg/dmesg-decipher.c b/tools/kmsg/dmesg-decipher.c
new file mode 100644
index 000000000000..c7149fe7dc17
--- /dev/null
+++ b/tools/kmsg/dmesg-decipher.c
@@ -0,0 +1,316 @@
+// SPDX-License-Identifier: GPL-2.0
+/*
+ * dmesg-decipher.c
+ *
+ * A sample utility to decrypt an encrypted dmesg output, for
+ * developement with kernels having kmsg encryption enabled.
+ *
+ * Copyright (c) Dan Aloni, 2017
+ *
+ * Compile with
+ *	gcc -I/usr/src/linux/include getdelays.c -o getdelays
+ */
+
+#include <openssl/pem.h>
+#include <openssl/pkcs7.h>
+#include <openssl/err.h>
+
+#include <stdbool.h>
+#include <stdint.h>
+#include <string.h>
+#include <regex.h>
+
+/*
+ * The following is based on code from:
+ *
+ *    https://wiki.openssl.org/index.php/EVP_Authenticated_Encryption_and_Decryption
+ */
+static int aes_256_gcm_decrypt(unsigned char *ciphertext, size_t ciphertext_len,
+			       unsigned char *aad, size_t aad_len,
+			       unsigned char *tag, unsigned char *key,
+			       unsigned char *iv, size_t iv_len,
+			       unsigned char *plaintext)
+{
+	EVP_CIPHER_CTX *ctx;
+	int len;
+	int plaintext_len;
+	int ret = -1;
+
+	/* Create and initialise the context */
+	if (!(ctx = EVP_CIPHER_CTX_new()))
+		return -1;
+
+	/* Initialise the decryption operation. */
+	if (!EVP_DecryptInit_ex(ctx, EVP_aes_128_gcm(), NULL, NULL, NULL))
+		goto free;
+
+	/* Set IV length. Not necessary if this is 12 bytes (96 bits) */
+	if (!EVP_CIPHER_CTX_ctrl(ctx, EVP_CTRL_GCM_SET_IVLEN, iv_len, NULL))
+		goto free;
+
+	/* Initialise key and IV */
+	if (!EVP_DecryptInit_ex(ctx, NULL, NULL, key, iv))
+		goto free;
+
+	/* Provide any AAD data. This can be called zero or more times as
+	 * required
+	 */
+	if (aad_len != 0) {
+		if (!EVP_DecryptUpdate(ctx, NULL, &len, aad, aad_len))
+			goto free;
+	}
+
+	/* Provide the message to be decrypted, and obtain the plaintext output.
+	 * EVP_DecryptUpdate can be called multiple times if necessary
+	 */
+	if (!EVP_DecryptUpdate(ctx, plaintext, &len, ciphertext,
+			       ciphertext_len))
+		goto free;
+	plaintext_len = len;
+
+	/* Set expected tag value. Works in OpenSSL 1.0.1d and later */
+	if (!EVP_CIPHER_CTX_ctrl(ctx, EVP_CTRL_GCM_SET_TAG, 16, tag))
+		goto free;
+
+	/* Finalise the decryption. A positive return value indicates success,
+	 * anything else is a failure - the plaintext is not trustworthy.
+	 */
+	ret = EVP_DecryptFinal_ex(ctx, plaintext + len, &len);
+
+free:
+	/* Clean up */
+	EVP_CIPHER_CTX_free(ctx);
+
+	if (ret > 0) {
+		/* Success */
+		plaintext_len += len;
+		return plaintext_len;
+	} else {
+		/* Verify failed */
+		return -1;
+	}
+}
+
+static int hex_char_decode(char input, uint8_t *output)
+{
+	if ('a' <= input && input <= 'f')
+		*output = 10 + input - 'a';
+	else if ('0' <= input && input <= '9')
+		*output = input - '0';
+	else
+		return -1;
+
+	return 0;
+}
+
+static int hex_string_decode(const char *input, size_t ninput, void *output,
+			     size_t *noutput)
+{
+	uint8_t *output_buffer = output;
+	int ret;
+	uint8_t hexval_a;
+	uint8_t hexval_b;
+
+	if (ninput % 2)
+		return -1;
+	if (ninput / 2 > *noutput)
+		return -2;
+
+	*noutput = 0;
+	while (ninput > 0) {
+		ret = hex_char_decode(input[0], &hexval_a);
+		if (ret < 0)
+			break;
+
+		ret = hex_char_decode(input[1], &hexval_b);
+		if (ret < 0)
+			break;
+
+		*output_buffer = (hexval_a << 4) | hexval_b;
+		output_buffer++;
+		*noutput += 1;
+
+		input += 2;
+		ninput -= 2;
+	}
+
+	if (ninput == 0)
+		return 0;
+
+	return -2 + ret;
+}
+
+static int parse_int_regex_match(const char *source, regmatch_t match,
+				 size_t *output)
+{
+	char decimal_number[0x10] = {
+		0,
+	};
+	size_t len = match.rm_eo - match.rm_so;
+
+	if (len >= sizeof(decimal_number))
+		return -1;
+
+	memcpy(&decimal_number[0], &source[match.rm_so], len);
+
+	*output = atoi(decimal_number);
+	return 0;
+}
+
+static const char session_key_pattern[] = "(.*)K:([0-9a-f]+)";
+static const char message_pattern[] =
+	".*M:([0-9a-f]+),([0-9]+),([0-9]+)";
+
+static int decrypt_message(const char *line, regmatch_t *matches,
+			   uint8_t *sess_key)
+{
+	char plain_text[0x1000];
+	uint8_t cipher_msg_bin[0x1000];
+	size_t cipher_msg_size = sizeof(cipher_msg_bin);
+	size_t cipher_size;
+	const regmatch_t prefix = matches[1];
+	const regmatch_t ciphermsg = matches[2];
+	const regmatch_t auth_str_len = matches[3];
+	const regmatch_t iv_str_len = matches[4];
+	size_t auth_len;
+	size_t iv_len;
+	size_t ciphertext_auth_iv_len = ciphermsg.rm_eo - ciphermsg.rm_so;
+	int ret;
+
+	ret = parse_int_regex_match(line, auth_str_len, &auth_len);
+	if (ret)
+		return -1;
+
+	ret = parse_int_regex_match(line, iv_str_len, &iv_len);
+	if (ret)
+		return -1;
+
+	ret = hex_string_decode(&line[ciphermsg.rm_so],  ciphertext_auth_iv_len,
+				cipher_msg_bin, &cipher_msg_size);
+	if (ret)
+		return -1;
+
+	if (iv_len >= cipher_msg_size
+	    || auth_len >= cipher_msg_size
+	    || auth_len + iv_len > cipher_msg_size) {
+		return -1;
+	}
+
+	cipher_size = cipher_msg_size - auth_len - iv_len;
+
+	ret = aes_256_gcm_decrypt(/* Ciphertext */
+			    (uint8_t *)cipher_msg_bin,
+			    cipher_size,
+
+			    /* AAD */
+			    NULL,
+			    0,
+
+			    /* tag */
+			    (uint8_t *)&cipher_msg_bin[cipher_size],
+
+			    /* key */
+			    sess_key,
+
+			    /* IV */
+			    (uint8_t *)&cipher_msg_bin[cipher_size + auth_len], iv_len,
+
+			    /* Plain text */
+			    (uint8_t *)plain_text);
+	if (ret > 0) {
+		fwrite(line, prefix.rm_eo, 1, stdout);
+		fwrite(plain_text, ret, 1, stdout);
+		fwrite("\n", 1, 1, stdout);
+	}
+
+	return ret;
+}
+
+int main(int argc, char **argv)
+{
+	BIO *tbio = NULL;
+	RSA *rsa;
+	int ret = 1;
+	char line[0x1000];
+	uint8_t enc_sess_key[0x200];
+	uint8_t sess_key[0x200] = {0, };
+	bool got_key = false;
+
+	OpenSSL_add_all_algorithms();
+	ERR_load_crypto_strings();
+
+	regex_t session_key_regex;
+	regex_t message_regex;
+
+	ret = regcomp(&session_key_regex, session_key_pattern, REG_EXTENDED);
+	if (ret) {
+		goto err;
+	}
+
+	ret = regcomp(&message_regex, message_pattern, REG_EXTENDED);
+	if (ret) {
+		goto err;
+	}
+
+	if (argc < 2) {
+		fprintf(stderr, "not enough paramters\n");
+		return -1;
+	}
+
+	/* Read in recipient certificate and private key */
+	tbio = BIO_new_file(argv[1], "r");
+	if (!tbio) {
+		fprintf(stderr, "BIO_new_file - error\n");
+		goto err;
+	}
+
+	rsa = PEM_read_bio_RSAPrivateKey(tbio, NULL, NULL, NULL);
+	if (!rsa)
+		goto err;
+
+	while (true) {
+		regmatch_t matches[5];
+
+		if (!fgets(line, sizeof(line), stdin))
+			break;
+
+		if (!got_key
+		    && !regexec(&session_key_regex, line, 5, matches, 0)) {
+			const regmatch_t match = matches[2];
+			size_t enc_sess_key_size = sizeof(enc_sess_key);
+
+			ret = hex_string_decode(
+				&line[match.rm_so], match.rm_eo - match.rm_so,
+				&enc_sess_key, &enc_sess_key_size);
+			if (ret)
+				goto err;
+
+			ret = RSA_private_decrypt(enc_sess_key_size,
+						  enc_sess_key, sess_key, rsa,
+						  RSA_PKCS1_PADDING);
+			if (ret < 0)
+				goto err;
+
+			got_key = true;
+		}
+
+		if (!regexec(&message_regex, line, 5, matches, 0)) {
+			if (!got_key) {
+				fprintf(stderr,
+					"session key must precede messages\n");
+				break;
+			}
+
+			ret = decrypt_message(line, matches, sess_key);
+			if (ret < 0) {
+				break;
+			}
+		}
+	}
+
+	regfree(&session_key_regex);
+	regfree(&message_regex);
+
+err:
+	return -1;
+}
-- 
2.13.6
