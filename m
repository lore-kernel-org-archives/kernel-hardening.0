Return-Path: <SRS0=8Qqy=6Y=lists.openwall.com=kernel-hardening-return-18746-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EAD1C38A2A
	for <kernel-hardening@archiver.kernel.org>; Sun, 10 May 2020 21:18:00 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A33B820731
	for <kernel-hardening@archiver.kernel.org>; Sun, 10 May 2020 21:17:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="vXemduiy"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A33B820731
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18746-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3268 invoked by uid 550); 10 May 2020 21:17:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3245 invoked from network); 10 May 2020 21:17:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589145459;
	bh=jDSgHIjSdcfbYEeaUJK6949KQKrnH33OZMXTagwol1U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=vXemduiy0JPU9WekcwJ5wX3mMkCUeEHrZUwXA70apj+RBQrmHlTmKH50aZ3Dqfcl0
	 zgpQ7miVlv71rVkLP1LZ1XFtZj6wPaDkpSXInRXzOU2vpjrvaPcfPS3aM4nzj67yKC
	 0DtwvWZ2jfiD5hM+GfpMJc4uC5E28I0Mxh0UBkE4=
Date: Sun, 10 May 2020 14:17:38 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: dhowells@redhat.com, keyrings@vger.kernel.org,
	Andy Lutomirski <luto@kernel.org>,
	Greg KH <gregkh@linuxfoundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v2] security/keys: rewrite big_key crypto to use Zinc
Message-ID: <20200510211738.GA52708@sol.localdomain>
References: <CAHmME9rvp4JrER0RPp=VgYwYL87jntwW8vWNANzubH3Ah_8Oow@mail.gmail.com>
 <20200502001942.626523-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200502001942.626523-1-Jason@zx2c4.com>

On Fri, May 01, 2020 at 06:19:42PM -0600, Jason A. Donenfeld wrote:
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
> Cc: Eric Biggers <ebiggers@kernel.org>
> Cc: kernel-hardening@lists.openwall.com
> Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>

You can add:

	Reviewed-by: Eric Biggers <ebiggers@google.com>

But, a couple minor suggestions:

The commit message should say "lib/crypto", not Zinc.  Nothing in the source
tree actually says Zinc, so it will confuse people who haven't read all the
previous discussions.

>  		/* read file to kernel and decrypt */
> -		ret = kernel_read(file, buf->virt, enclen, &pos);
> +		ret = kernel_read(file, buf, enclen, &pos);
>  		if (ret >= 0 && ret != enclen) {
>  			ret = -EIO;
>  			goto err_fput;
> +		} else if (ret < 0) {
> +			goto err_fput;
>  		}

It would make sense to write this as the following, to make it consistent with
how the return value of kernel_write() is checked in big_key_preparse():

		ret = kernel_read(file, buf, enclen, &pos);
		if (ret != enclen) {
			if (ret >= 0)
				ret = -ENOMEM;
			goto err_fput;
		}

- Eric
