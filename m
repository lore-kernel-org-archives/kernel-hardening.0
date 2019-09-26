Return-Path: <SRS0=wjGh=XV=lists.openwall.com=kernel-hardening-return-16946-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17B14C4360C
	for <kernel-hardening@archiver.kernel.org>; Thu, 26 Sep 2019 15:45:28 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 49E2921D6C
	for <kernel-hardening@archiver.kernel.org>; Thu, 26 Sep 2019 15:45:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="hu1Avh6H"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 49E2921D6C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16946-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5671 invoked by uid 550); 26 Sep 2019 15:45:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5636 invoked from network); 26 Sep 2019 15:45:20 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5ZbnURneNamOfnAb8QQHRVCtDN7XxRbs7mNJ0pCMRFE=;
        b=hu1Avh6HcqLpy5a9yjDIQN3+CC8g6gnkJFoWqDCO74VwYbTG2Id9OyLgbNOP4Zax2v
         21g4LHuBUdfx0xCL4QtJXtzPd20X3Ti4LQkQb1fq7Gn/gBRxQ1++jWdW3ENuPcpEPT15
         xsp4sYKWdHQzYVDTqdJgT/FZm3JyuDW95iOos=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5ZbnURneNamOfnAb8QQHRVCtDN7XxRbs7mNJ0pCMRFE=;
        b=MV+Aub0626+f2zLaxIjyQOJNDyB4VCyEi67fmm8HHhwnETRoBPEIUu3jw1+eLtB9TB
         wqPJ/K5Y+zNLq4i1wpSs1w7sKWf7EqPvF5IFY3bmyWTm6VQyesIf1UeQpYlcIGKk5aBY
         j5/L0NZvrx+jCtLRQWqcPJYofGoy1EQ9SO8BOXKo1bFheycUY20d8jVc4BzgFS4QRzO/
         ES43HSmoX2O3/FMwqu3sFTA/pIgwnoi3NZsckHnn7ptN9G4tsGeH2MGn/oY8AuFjoLvg
         VzKEFcOkFpOV+ISnvXnamUzN9lqaTwDQakQipNIGwHag2tKf+3Y1SCh4/Ipo/x5j3MXO
         E3+Q==
X-Gm-Message-State: APjAAAVMqOgsWO7Ue4F0cQC1M07qUWVFywCDF8YoDYFfFhyNTEDHRDEg
	E3m4hDncDPtmOcmTSNhZlipXsQ==
X-Google-Smtp-Source: APXvYqyRWOw7NC3cIB/icwsVtP2c9OsHdjRQyM9HlOPbwyDbiFymIUe7WfhkJqhXzzbCwFieKj9yZg==
X-Received: by 2002:a63:2b01:: with SMTP id r1mr3806943pgr.19.1569512707669;
        Thu, 26 Sep 2019 08:45:07 -0700 (PDT)
Date: Thu, 26 Sep 2019 08:45:05 -0700
From: Kees Cook <keescook@chromium.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Julia Lawall <julia.lawall@lip6.fr>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
	Stephen Kitt <steve@sk2.org>, Nitin Gote <nitin.r.gote@intel.com>,
	jannh@google.com, kernel-hardening@lists.openwall.com,
	Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Subject: Re: [PATCH V2 1/2] string: Add stracpy and stracpy_pad mechanisms
Message-ID: <201909260842.CDA50B7E3@keescook>
References: <cover.1563889130.git.joe@perches.com>
 <ed4611a4a96057bf8076856560bfbf9b5e95d390.1563889130.git.joe@perches.com>
 <20190925145011.c80c89b56fcee3060cf87773@linux-foundation.org>
 <56dc4de7e0db153cb10954ac251cb6c27c33da4a.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <56dc4de7e0db153cb10954ac251cb6c27c33da4a.camel@perches.com>

On Thu, Sep 26, 2019 at 01:34:36AM -0700, Joe Perches wrote:
> On Wed, 2019-09-25 at 14:50 -0700, Andrew Morton wrote:
> > On Tue, 23 Jul 2019 06:51:36 -0700 Joe Perches <joe@perches.com> wrote:
> > 
> > > Several uses of strlcpy and strscpy have had defects because the
> > > last argument of each function is misused or typoed.
> > > 
> > > Add macro mechanisms to avoid this defect.
> > > 
> > > stracpy (copy a string to a string array) must have a string
> > > array as the first argument (dest) and uses sizeof(dest) as the
> > > count of bytes to copy.
> > > 
> > > These mechanisms verify that the dest argument is an array of
> > > char or other compatible types like u8 or s8 or equivalent.
> > > 
> > > A BUILD_BUG is emitted when the type of dest is not compatible.
> > > 
> > 
> > I'm still reluctant to merge this because we don't have code in -next
> > which *uses* it.  You did have a patch for that against v1, I believe? 
> > Please dust it off and send it along?
> 
> https://lore.kernel.org/lkml/CAHk-=wgqQKoAnhmhGE-2PBFt7oQs9LLAATKbYa573UO=DPBE0Q@mail.gmail.com/
> 
> I gave up, especially after the snark from Linus
> where he wrote I don't understand this stuff.
> 
> He's just too full of himself here merely using
> argument from authority.
> 
> Creating and using a function like copy_string with
> both source and destination lengths specified is
> is also potentially a large source of defects where
> the stracpy macro atop strscpy does not have a
> defect path other than the src not being a string
> at all.
> 
> I think the analysis of defects in string function
> in the kernel is overly difficult today given the
> number of possible uses of pointer and length in
> strcpy/strncpy/strlcpy/stracpy.
> 
> I think also that there is some sense in what he
> wrote against the "word salad" use of str<foo>cpy,
> but using stracpy as a macro when possible instead
> of strscpy also makes the analysis of defects rather
> simpler.
> 
> The trivial script cocci I posted works well for the
> simple cases.
> 
> https://lore.kernel.org/cocci/66fcdbf607d7d0bea41edb39e5579d63b62b7d84.camel@perches.com/
> 
> The more complicated cocci script Julia posted is
> still not quite correct as it required intermediate
> compilation for verification of specified lengths.
> 
> https://lkml.org/lkml/2019/7/25/1406
> 
> Tell me again if you still want it and maybe the
> couple conversions that mm/ would get.

FWIW, I want it because it creates a compile-time-verifiable API for a
non-trivial set of common string copying flaws.

CONFIG_FORTIFY_SOURCE isn't able to handle these (yet?) because it's
examining the outer size of structures that hold char arrays. And even
if we built in the logic to deal with it correctly, it'd still split
the detection between compile time and run time.

-Kees

-- 
Kees Cook
