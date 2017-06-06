MIME-Version: 1.0
In-Reply-To: <20170606173900.29279-1-Jason@zx2c4.com>
References: <20170606173900.29279-1-Jason@zx2c4.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue, 6 Jun 2017 19:49:57 +0200
Message-ID: <CAHmME9rDV-H1kzjMJ9OmzOtTpMzsxs2Ds6qhsSS_wmHhhBUNqQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH] security/keys: rewrite all of big_key crypto
To: keyrings@vger.kernel.org, kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
Cc: Theodore Ts'o <tytso@mit.edu>
List-ID: <kernel-hardening.lists.openwall.com>

Sorry, meant to cross-post the below to these other two mailing lists.

On Tue, Jun 6, 2017 at 7:39 PM, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> This started out as just replacing the use of crypto/rng with
> get_random_bytes, so that we wouldn't use bad randomness at boot time.
> But, upon looking further, it appears that there were even deeper
> underlying cryptographic problems, and that this seems to have been
> committed with very little crypto review. So, I rewrote the whole thing,
> trying to keep to the conventions introduced by the previous author, to
> fix these cryptographic flaws.
>
> First, it makes no sense to seed crypto/rng at boot time and then keep
> using it like this, when in fact there's already get_random_bytes_wait,
> which can ensure there's enough entropy and be a much more standard way
> of generating keys.
>
> Second, since this sensitive material is being stored untrusted, using
> ECB and no authentication is simply not okay at all. I find it surprising
> that this code even made it past basic crypto review, though perhaps
> there's something I'm missing. This patch moves from using AES-ECB to
> using AES-GCM. Since keys are uniquely generated each time, we can set
> the nonce to zero.
>
> So, to summarize, this commit fixes the following vulnerabilities:
>
>   * Low entropy key generation, allowing an attacker to potentially
>     guess or predict keys.
>   * Unauthenticated encryption, allowing an attacker to modify the
>     cipher text in particular ways in order to manipulate the plaintext,
>     which is is even more frightening considering the next point.
>   * Use of ECB mode, allowing an attacker to trivially swap blocks or
>     compare identical plaintext blocks.
>
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> Cc: David Howells <dhowells@redhat.com>
> Cc: Eric Biggers <ebiggers3@gmail.com>
> Cc: Herbert Xu <herbert@gondor.apana.org.au>
> Cc: Kirill Marinushkin <k.marinushkin@gmail.com>
> Cc: security@kernel.org
> Cc: stable@vger.kernel.org
> ---
> This commit has been compile-tested only, so I'd appreciate it if
> somebody else who actually uses this would test it for functionality, or
> if somebody into the kernel's crypto API would check that it's been done
> correctly.
>
>  security/keys/Kconfig   |   5 +-
>  security/keys/big_key.c | 120 +++++++++++++++++++++++-------------------------
>  2 files changed, 59 insertions(+), 66 deletions(-)
>
> diff --git a/security/keys/Kconfig b/security/keys/Kconfig
> index 6fd95f76bfae..2f91f2368d29 100644
> --- a/security/keys/Kconfig
> +++ b/security/keys/Kconfig
> @@ -41,10 +41,9 @@ config BIG_KEYS
>         bool "Large payload keys"
>         depends on KEYS
>         depends on TMPFS
> -       depends on (CRYPTO_ANSI_CPRNG = y || CRYPTO_DRBG = y)
>         select CRYPTO_AES
> -       select CRYPTO_ECB
> -       select CRYPTO_RNG
> +       select CRYPTO_GCM
> +       select CRYPTO_AEAD
>         help
>           This option provides support for holding large keys within the kernel
>           (for example Kerberos ticket caches).  The data may be stored out to
> diff --git a/security/keys/big_key.c b/security/keys/big_key.c
> index 835c1ab30d01..40066cb6b8f4 100644
> --- a/security/keys/big_key.c
> +++ b/security/keys/big_key.c
> @@ -1,5 +1,6 @@
>  /* Large capacity key type
>   *
> + * Copyright (C) 2017 Jason A. Donenfeld <Jason@zx2c4.com>. All Rights Reserved.
>   * Copyright (C) 2013 Red Hat, Inc. All Rights Reserved.
>   * Written by David Howells (dhowells@redhat.com)
>   *
> @@ -16,10 +17,10 @@
>  #include <linux/shmem_fs.h>
>  #include <linux/err.h>
>  #include <linux/scatterlist.h>
> +#include <linux/random.h>
>  #include <keys/user-type.h>
>  #include <keys/big_key-type.h>
> -#include <crypto/rng.h>
> -#include <crypto/skcipher.h>
> +#include <crypto/aead.h>
>
>  /*
>   * Layout of key payload words.
> @@ -49,7 +50,12 @@ enum big_key_op {
>  /*
>   * Key size for big_key data encryption
>   */
> -#define ENC_KEY_SIZE   16
> +#define ENC_KEY_SIZE 32
> +
> +/*
> + * Authentication tag length
> + */
> +#define ENC_AUTHTAG_SIZE 16
>
>  /*
>   * big_key defined keys take an arbitrary string as the description and an
> @@ -67,24 +73,14 @@ struct key_type key_type_big_key = {
>  };
>
>  /*
> - * Crypto names for big_key data encryption
> - */
> -static const char big_key_rng_name[] = "stdrng";
> -static const char big_key_alg_name[] = "ecb(aes)";
> -
> -/*
> - * Crypto algorithms for big_key data encryption
> + * Crypto names for big_key data authenticated encryption
>   */
> -static struct crypto_rng *big_key_rng;
> -static struct crypto_skcipher *big_key_skcipher;
> +static const char big_key_alg_name[] = "gcm(aes)";
>
>  /*
> - * Generate random key to encrypt big_key data
> + * Crypto algorithms for big_key data authenticated encryption
>   */
> -static inline int big_key_gen_enckey(u8 *key)
> -{
> -       return crypto_rng_get_bytes(big_key_rng, key, ENC_KEY_SIZE);
> -}
> +static struct crypto_aead *big_key_aead;
>
>  /*
>   * Encrypt/decrypt big_key data
> @@ -93,27 +89,40 @@ static int big_key_crypt(enum big_key_op op, u8 *data, size_t datalen, u8 *key)
>  {
>         int ret = -EINVAL;
>         struct scatterlist sgio;
> -       SKCIPHER_REQUEST_ON_STACK(req, big_key_skcipher);
> -
> -       if (crypto_skcipher_setkey(big_key_skcipher, key, ENC_KEY_SIZE)) {
> +       u8 req_on_stack[sizeof(struct aead_request) +
> +                       crypto_aead_reqsize(big_key_aead)];
> +       struct aead_request *aead_req = (struct aead_request *)req_on_stack;
> +
> +       /* We always use a zero nonce. The reason we can get away with this is
> +        * because we're using a different randomly generated key for every
> +        * different encryption. Notably, too, key_type_big_key doesn't define
> +        * an .update function, so there's no chance we'll wind up reusing the
> +        * key to encrypt updated data. Simply put: one key, one encryption.
> +        */
> +       u8 zero_nonce[crypto_aead_ivsize(big_key_aead)];
> +
> +       memset(req_on_stack, 0, sizeof(struct aead_request) +
> +                               crypto_aead_reqsize(big_key_aead));
> +       memset(zero_nonce, 0, crypto_aead_ivsize(big_key_aead));
> +       sg_init_one(&sgio, data, datalen + (op == BIG_KEY_ENC ? ENC_AUTHTAG_SIZE : 0));
> +
> +       if (crypto_aead_setkey(big_key_aead, key, ENC_KEY_SIZE)) {
>                 ret = -EAGAIN;
>                 goto error;
>         }
>
> -       skcipher_request_set_tfm(req, big_key_skcipher);
> -       skcipher_request_set_callback(req, CRYPTO_TFM_REQ_MAY_SLEEP,
> -                                     NULL, NULL);
> -
> -       sg_init_one(&sgio, data, datalen);
> -       skcipher_request_set_crypt(req, &sgio, &sgio, datalen, NULL);
> +       aead_request_set_tfm(aead_req, big_key_aead);
> +       aead_request_set_crypt(aead_req, &sgio, &sgio, datalen, zero_nonce);
> +       aead_request_set_callback(aead_req, CRYPTO_TFM_REQ_MAY_SLEEP,
> +                                 NULL, NULL);
>
>         if (op == BIG_KEY_ENC)
> -               ret = crypto_skcipher_encrypt(req);
> +               ret = crypto_aead_encrypt(aead_req);
>         else
> -               ret = crypto_skcipher_decrypt(req);
> -
> -       skcipher_request_zero(req);
> +               ret = crypto_aead_decrypt(aead_req);
>
> +       memzero_explicit(req_on_stack, sizeof(struct aead_request) +
> +                        crypto_aead_reqsize(big_key_aead));
>  error:
>         return ret;
>  }
> @@ -146,7 +155,7 @@ int big_key_preparse(struct key_preparsed_payload *prep)
>                  *
>                  * File content is stored encrypted with randomly generated key.
>                  */
> -               size_t enclen = ALIGN(datalen, crypto_skcipher_blocksize(big_key_skcipher));
> +               size_t enclen = datalen + ENC_AUTHTAG_SIZE;
>
>                 /* prepare aligned data to encrypt */
>                 data = kmalloc(enclen, GFP_KERNEL);
> @@ -162,13 +171,12 @@ int big_key_preparse(struct key_preparsed_payload *prep)
>                         ret = -ENOMEM;
>                         goto error;
>                 }
> -
> -               ret = big_key_gen_enckey(enckey);
> +               ret = get_random_bytes_wait(enckey, ENC_KEY_SIZE);
>                 if (ret)
>                         goto err_enckey;
>
>                 /* encrypt aligned data */
> -               ret = big_key_crypt(BIG_KEY_ENC, data, enclen, enckey);
> +               ret = big_key_crypt(BIG_KEY_ENC, data, datalen, enckey);
>                 if (ret)
>                         goto err_enckey;
>
> @@ -294,7 +302,7 @@ long big_key_read(const struct key *key, char __user *buffer, size_t buflen)
>                 struct file *file;
>                 u8 *data;
>                 u8 *enckey = (u8 *)key->payload.data[big_key_data];
> -               size_t enclen = ALIGN(datalen, crypto_skcipher_blocksize(big_key_skcipher));
> +               size_t enclen = datalen + ENC_AUTHTAG_SIZE;
>
>                 data = kmalloc(enclen, GFP_KERNEL);
>                 if (!data)
> @@ -342,47 +350,33 @@ long big_key_read(const struct key *key, char __user *buffer, size_t buflen)
>   */
>  static int __init big_key_init(void)
>  {
> -       struct crypto_skcipher *cipher;
> -       struct crypto_rng *rng;
> +       struct crypto_aead *tfm;
>         int ret;
>
> -       rng = crypto_alloc_rng(big_key_rng_name, 0, 0);
> -       if (IS_ERR(rng)) {
> -               pr_err("Can't alloc rng: %ld\n", PTR_ERR(rng));
> -               return PTR_ERR(rng);
> -       }
> -
> -       big_key_rng = rng;
> -
> -       /* seed RNG */
> -       ret = crypto_rng_reset(rng, NULL, crypto_rng_seedsize(rng));
> -       if (ret) {
> -               pr_err("Can't reset rng: %d\n", ret);
> -               goto error_rng;
> -       }
> -
>         /* init block cipher */
> -       cipher = crypto_alloc_skcipher(big_key_alg_name, 0, CRYPTO_ALG_ASYNC);
> -       if (IS_ERR(cipher)) {
> -               ret = PTR_ERR(cipher);
> +       tfm = crypto_alloc_aead(big_key_alg_name, 0, CRYPTO_ALG_ASYNC);
> +       if (IS_ERR(tfm)) {
> +               ret = PTR_ERR(tfm);
>                 pr_err("Can't alloc crypto: %d\n", ret);
> -               goto error_rng;
> +               return ret;
> +       }
> +       ret = crypto_aead_setauthsize(tfm, ENC_AUTHTAG_SIZE);
> +       if (ret < 0) {
> +               pr_err("Can't set crypto auth tag len: %d\n", ret);
> +               goto free_aead;
>         }
> -
> -       big_key_skcipher = cipher;
>
>         ret = register_key_type(&key_type_big_key);
>         if (ret < 0) {
>                 pr_err("Can't register type: %d\n", ret);
> -               goto error_cipher;
> +               goto free_aead;
>         }
>
> +       big_key_aead = tfm;
>         return 0;
>
> -error_cipher:
> -       crypto_free_skcipher(big_key_skcipher);
> -error_rng:
> -       crypto_free_rng(big_key_rng);
> +free_aead:
> +       crypto_free_aead(tfm);
>         return ret;
>  }
>
> --
> 2.13.0
>
