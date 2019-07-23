Return-Path: <SRS0=osG4=VU=lists.openwall.com=kernel-hardening-return-16564-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BEF2EC76186
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jul 2019 21:35:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1FC7E218D4
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jul 2019 21:35:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="lt80K4Z+"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1FC7E218D4
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16564-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32610 invoked by uid 550); 23 Jul 2019 21:34:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32575 invoked from network); 23 Jul 2019 21:34:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=VWIEpkB+n44qq++ScgWqxmeSI/uO47Tg9yPkq7RW5zM=;
        b=lt80K4Z+V8K9yGobfELvvO6KN7cDAATkM5sB7/0W8IECrsCK4UHj1uU0WAdzz/ZO26
         r/HOZ8OnsLZP/RZkGSvpfHuHv524maccj1Ez/vGHlwE2piDXhMMnNArlJD3hYEWLROca
         3AUzSTQir2yk7D3E4PR+ub3J5xlSjQq2S2e2Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=VWIEpkB+n44qq++ScgWqxmeSI/uO47Tg9yPkq7RW5zM=;
        b=q0n5rsxVPhtK8YerEeRj0W30uQWBYYqpydb+fyXpscZkgbJKFdEyRAGH6KPmiRHhtT
         0lFIi2+5u1oNKGQuzXMj/1pCl3A6casRdMhu366TSaDD5xZpNPmULpxCQN9W7fMuFFoe
         UR4rwiAbdboGKgoRyf6pWq49rvlEwuaZ5rypepKAd+BigFZMWXrhaRM1m0Zk7QnQcqY+
         NxKzxGlnAxRYcJtJtMLTZOVWC0La1s3NdbcICqxSs/A+9XkoamH/edvPvk0cJcN+Lyjm
         szSIF5MtyhzeN8LJuwFADIBcuYrBj5L002pN+pU/Iw42Jzu2+0OCAkKi7SxwMO8pJfSN
         FBXw==
X-Gm-Message-State: APjAAAWeDOt2oej4Uwd+n3LUnGOgkFVGxHxCN5dOlTI2qWrLs/5ja3jn
	IRms/uTdLxaf+Nh2xw8iGYqaqA==
X-Google-Smtp-Source: APXvYqyxvdPPh9QAyeti89rkI4S8NU/d5TsJiHGgO3K6q0Ueyy23O+JaTEclPIDV2V5HehfwXgHf1g==
X-Received: by 2002:aa7:9afc:: with SMTP id y28mr7646026pfp.252.1563917686160;
        Tue, 23 Jul 2019 14:34:46 -0700 (PDT)
Date: Tue, 23 Jul 2019 14:34:44 -0700
From: Kees Cook <keescook@chromium.org>
To: David Laight <David.Laight@ACULAB.COM>
Cc: 'Rasmus Villemoes' <linux@rasmusvillemoes.dk>,
	Joe Perches <joe@perches.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	Jonathan Corbet <corbet@lwn.net>, Stephen Kitt <steve@sk2.org>,
	Nitin Gote <nitin.r.gote@intel.com>,
	"jannh@google.com" <jannh@google.com>,
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/2] string: Add stracpy and stracpy_pad mechanisms
Message-ID: <201907231430.C679A37EC@keescook>
References: <cover.1563841972.git.joe@perches.com>
 <7ab8957eaf9b0931a59eff6e2bd8c5169f2f6c41.1563841972.git.joe@perches.com>
 <eec901c6-ca51-89e4-1887-1ccab0288bee@rasmusvillemoes.dk>
 <5ffdbf4f87054b47a2daf23a6afabecf@AcuMS.aculab.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5ffdbf4f87054b47a2daf23a6afabecf@AcuMS.aculab.com>

On Tue, Jul 23, 2019 at 03:41:27PM +0000, David Laight wrote:
> From: Rasmus Villemoes
> > Sent: 23 July 2019 07:56
> ...
> > > +/**
> > > + * stracpy - Copy a C-string into an array of char
> > > + * @to: Where to copy the string, must be an array of char and not a pointer
> > > + * @from: String to copy, may be a pointer or const char array
> > > + *
> > > + * Helper for strscpy.
> > > + * Copies a maximum of sizeof(@to) bytes of @from with %NUL termination.
> > > + *
> > > + * Returns:
> > > + * * The number of characters copied (not including the trailing %NUL)
> > > + * * -E2BIG if @to is a zero size array.
> > 
> > Well, yes, but more importantly and generally: -E2BIG if the copy
> > including %NUL didn't fit. [The zero size array thing could be made into
> > a build bug for these stra* variants if one thinks that might actually
> > occur in real code.]
> 
> Probably better is to return the size of the destination if the copy didn't fit
> (zero if the buffer is zero length).
> This allows code to do repeated:
> 	offset += str*cpy(buf + offset, src, sizeof buf - offset);
> and do a final check for overflow after all the copies.
> 
> The same is true for a snprintf()like function

Please no; I understand the utility of the "max on error" condition for
chaining, but chaining is less common than standard operations. And it
requires that the size of the destination be known in multiple places,
which isn't robust either.

The very point of stracpy() is to not need to know the size of the
destination (i.e. it's handled by the compiler). (And it can't be
chained since it requires the base address of the array, not a char *.)

-- 
Kees Cook
