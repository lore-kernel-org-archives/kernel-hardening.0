Return-Path: <SRS0=sJsb=6P=lists.openwall.com=kernel-hardening-return-18705-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6BF4C47254
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 May 2020 23:09:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 01FBB208DB
	for <kernel-hardening@archiver.kernel.org>; Fri,  1 May 2020 23:09:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="jgkKa20r"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 01FBB208DB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18705-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7600 invoked by uid 550); 1 May 2020 23:09:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7578 invoked from network); 1 May 2020 23:09:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588374554;
	bh=rKN9EDVmXwn6takeqycZAn+iqfP/Fn3tjtdzjzy8GbQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jgkKa20r7/fHkDNLCHyCSdAjcrAkaceeB1q1vetTljZaUzXtmFilQ+Nnt61QjIue0
	 bKJrEME1vDq48Z51WRRfi91SvVk/fObnz0+rlYvBZ2C15p76I2fvKP0pLecbiFy2cJ
	 h8UUMKpm37OHM/Dr8yPtDwww/SI7lTOtbRpQuit8=
Date: Fri, 1 May 2020 16:09:13 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: dhowells@redhat.com, keyrings@vger.kernel.org,
	Andy Lutomirski <luto@kernel.org>,
	Greg KH <gregkh@linuxfoundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH] security/keys: rewrite big_key crypto to use Zinc
Message-ID: <20200501230913.GB915@sol.localdomain>
References: <20200501222357.543312-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200501222357.543312-1-Jason@zx2c4.com>

On Fri, May 01, 2020 at 04:23:57PM -0600, Jason A. Donenfeld wrote:
> A while back, I noticed that the crypto and crypto API usage in big_keys
> were entirely broken in multiple ways, so I rewrote it. Now, I'm
> rewriting it again, but this time using Zinc's ChaCha20Poly1305
> function. This makes the file considerably more simple; the diffstat
> alone should justify this commit. It also should be faster, since it no
> longer requires a mutex around the "aead api object" (nor allocations),
> allowing us to encrypt multiple items in parallel. We also benefit from
> being able to pass any type of pointer, so we can get rid of the
> ridiculously complex custom page allocator that big_key really doesn't
> need.
> 
> Cc: David Howells <dhowells@redhat.com>
> Cc: Andy Lutomirski <luto@kernel.org>
> Cc: Greg KH <gregkh@linuxfoundation.org>
> Cc: Linus Torvalds <torvalds@linux-foundation.org>
> Cc: kernel-hardening@lists.openwall.com
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
> ---
> I finally got around to updating this patch from the mailing list posts
> back in 2017-2018, using the library interface that we eventually merged
> in 2019. I haven't retested this for functionality, but nothing much has
> changed, so I suspect things should still be good to go.
> 
>  security/keys/Kconfig   |   4 +-
>  security/keys/big_key.c | 230 +++++-----------------------------------
>  2 files changed, 28 insertions(+), 206 deletions(-)
> 
> diff --git a/security/keys/Kconfig b/security/keys/Kconfig
> index 47c041563d41..5aa442490d52 100644
> --- a/security/keys/Kconfig
> +++ b/security/keys/Kconfig
> @@ -60,9 +60,7 @@ config BIG_KEYS
>  	bool "Large payload keys"
>  	depends on KEYS
>  	depends on TMPFS
> -	select CRYPTO
> -	select CRYPTO_AES
> -	select CRYPTO_GCM
> +	select CRYPTO_LIB_CHACHA20POLY1305
>  	help
>  	  This option provides support for holding large keys within the kernel
>  	  (for example Kerberos ticket caches).  The data may be stored out to

The 'select CRYPTO' is actually still needed because CRYPTO_LIB_CHACHA20POLY1305
is under the CRYPTO menuconfig:

make allnoconfig
cat >> .config << EOF
CONFIG_SHMEM=y
CONFIG_TMPFS=y
CONFIG_KEYS=y
CONFIG_BIG_KEYS=y
EOF
make olddefconfig

WARNING: unmet direct dependencies detected for CRYPTO_LIB_CHACHA20POLY1305
  Depends on [n]: CRYPTO [=n] && (CRYPTO_ARCH_HAVE_LIB_CHACHA [=n] || !CRYPTO_ARCH_HAVE_LIB_CHACHA [=n]) && (CRYPTO_ARCH_HAVE_LIB_POLY1305 [=n] || !CRYPTO_ARCH_HAVE_LIB_POLY1305 [=n])
  Selected by [y]:
  - BIG_KEYS [=y] && KEYS [=y] && TMPFS [=y]


Maybe the 'source "lib/crypto/Kconfig"' in crypto/Kconfig should be moved to
lib/Kconfig so that it's under "Library routines" and the crypto library options
can be selected without the full CRYPTO framework?

But lib/crypto/libchacha.c uses crypto_xor_cpy(), and
lib/crypto/chacha20poly1305.c uses crypto_memneq().  So those functions would
first need to be pulled into lib/crypto/ too.

> @@ -265,7 +121,7 @@ int big_key_preparse(struct key_preparsed_payload *prep)
>  		*path = file->f_path;
>  		path_get(path);
>  		fput(file);
> -		big_key_free_buffer(buf);
> +		kvfree(buf);
>  	} else {
>  		/* Just store the data in a buffer */
>  		void *data = kmalloc(datalen, GFP_KERNEL);
> @@ -283,7 +139,7 @@ int big_key_preparse(struct key_preparsed_payload *prep)
>  err_enckey:
>  	kzfree(enckey);
>  error:
> -	big_key_free_buffer(buf);
> +	kvfree(buf);
>  	return ret;
>  }

There should be a 'memzero_explicit(buf, enclen);' before the above two calls to
kvfree().

Or even better these should use kvfree_sensitive(), but that hasn't been merged
yet.  It was under discussion last month:
https://lkml.kernel.org/lkml/20200407200318.11711-1-longman@redhat.com/

>  
> -		ret = big_key_crypt(BIG_KEY_DEC, buf, enclen, enckey);
> -		if (ret)
> +		ret = chacha20poly1305_decrypt(buf, buf, enclen, NULL, 0, 0,
> +					       enckey) ? 0 : -EINVAL;
> +		if (unlikely(ret))
>  			goto err_fput;

-EINVAL is often unclear, since everyone uses it for everything.  How about
using -EBADMSG, which is what was used before via crypto_aead_decrypt()?

>  
>  		ret = datalen;
>  
>  		/* copy out decrypted data */
> -		memcpy(buffer, buf->virt, datalen);
> +		memcpy(buffer, buf, datalen);
>  
>  err_fput:
>  		fput(file);
>  error:
> -		big_key_free_buffer(buf);
> +		kvfree(buf);

Likewise, the buffer should be zeroed before freeing here.

- Eric
