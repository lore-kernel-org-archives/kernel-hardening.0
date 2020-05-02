Return-Path: <SRS0=8AAj=6Q=lists.openwall.com=kernel-hardening-return-18707-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E68C4C47254
	for <kernel-hardening@archiver.kernel.org>; Sat,  2 May 2020 00:14:30 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1137D2072E
	for <kernel-hardening@archiver.kernel.org>; Sat,  2 May 2020 00:14:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="z9/O7Lpb"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1137D2072E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18707-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30546 invoked by uid 550); 2 May 2020 00:14:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30523 invoked from network); 2 May 2020 00:14:23 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588378451;
	bh=HnHf+gY7BYBzhEDwTYb/tWB822HC2bvXB5orRTh9yoE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=z9/O7Lpbg/dt2rEg7S3R1AHnUBuQDUrs/bYIM/Zc+aMpkXVvPeVLUmGlmqU0wIY3s
	 J3hXFgd0R/tU50eKwcGsJr3f/R+g3Rsb1hjd7AgyJR01rS5J+9bkG8TNwuffMwV3J7
	 xsNZro8FiE6b/j4d3WBwnDKG9jfpsD+SAMrD+JYY=
Date: Fri, 1 May 2020 17:14:09 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org,
	Andy Lutomirski <luto@kernel.org>,
	Greg KH <gregkh@linuxfoundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH] security/keys: rewrite big_key crypto to use Zinc
Message-ID: <20200502001409.GD915@sol.localdomain>
References: <20200501222357.543312-1-Jason@zx2c4.com>
 <20200501230913.GB915@sol.localdomain>
 <CAHmME9rpZGiwrK93=+6z8qBdDVs273MaR_boDd1xjjZRwbqpKQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9rpZGiwrK93=+6z8qBdDVs273MaR_boDd1xjjZRwbqpKQ@mail.gmail.com>

On Fri, May 01, 2020 at 06:06:17PM -0600, Jason A. Donenfeld wrote:
> Hey Eric,
> 
> Thanks for the review.
> 
> I'll add `select CONFIG` as you suggested. I agree about trying to
> move as much as possible out of crypto and into lib/crypto. Breaking
> those dependency cycles won't be easy but perhaps it'll be possible to
> chip away at that gradually. (I'd also lib a
> lib/crypto/arch/{arch}/..., but I guess that's a separate discussion.)
> 
> I'll also change -EINVAL to -EBADMSG. Nice catch.
> 
> Regarding the buffer zeroing... are you sure? These buffers are
> already being copied into filesystem caches and all sorts of places
> over which we have zero control. At that point, does it matter? Or do
> you argue that because it's still technically key material, we should
> zero out both the plaintext and ciphertext everywhere we can, and
> hopefully at some point the places where we can't will go away? IOW,
> I'm fine doing that, but would like to learn your explicit reasoning
> before.

It's true that the buffer zeroing doesn't matter in big_key_preparse() because
the buffer only holds the encrypted key (which is what the shmem file will
contain).  But in big_key_read(), the buffer holds the decrypted key.  So it's
at least needed there.  Having it in both places for consistency might be a good
idea.

- Eric
