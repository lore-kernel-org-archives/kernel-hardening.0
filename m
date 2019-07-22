Return-Path: <SRS0=guv4=VT=lists.openwall.com=kernel-hardening-return-16522-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82F91C76190
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jul 2019 17:11:08 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A8F45219BE
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jul 2019 17:11:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="hXY5yRJH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A8F45219BE
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16522-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13425 invoked by uid 550); 22 Jul 2019 17:11:00 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13390 invoked from network); 22 Jul 2019 17:10:59 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=gyvxRiQhx5U4/US8oR3hAV0kUCO+Ojwhztb8U5iQAyQ=;
        b=hXY5yRJH5j0MZUiO4kf/htNJhGANDDArQIl7/EnVitpM373JjlUY25D8BNyL5UXhzD
         fPDSTpgQYGcA9WUAYvG6WS6/RM8aCk9erdtr1rmmqNVCr3l4NBFvtIuCuSM5mBluQ6Ol
         51O+L1c90OBj+OwE/lAU7C61Pt7peIS1zRk/g=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=gyvxRiQhx5U4/US8oR3hAV0kUCO+Ojwhztb8U5iQAyQ=;
        b=mIdXSIbIBwajHSBn6i4Pl1bI6iqDslTj11R8HRq6vryMlgWIzGpJXAqfcVv5OYpi2B
         H1s11rdgN+b6/779Rsn7cSZVuOvHonDGPZiLdTogmrBtqazJjf6gFIxyXC2d2fxPbSU6
         JM0NioVFyKmlKvTNIMiCe1hk5b5iiEChY+QJp06HU2P8xdHsph0bRZDkktjDQVIakp6M
         onGvrDJhX8wRb0a36ZfrbHwEQXcjyItqDJiTvfa8pc6pQw5v4T4oriFs4CCwgKhtrSkX
         we0rKQW5/MtHqezJl1/UIzfY9VbeZ6h81/Nvnne21DC+fo3OQBvq8uVSU24FKmMq1d1L
         w3wQ==
X-Gm-Message-State: APjAAAV7pWEEVIE9QLBbL/ahIrsSKd/uvnvZgsGsWEUOaStgKX+3gN/Z
	oKClYPnI1Invgdw/XBzuKdXwow==
X-Google-Smtp-Source: APXvYqxHz01DPkMMp2emZoAc78Aa+lWuFRMIUHk2yOt1ZQv3XrEIa0uTytx485lOPtVHI8gojk7J+Q==
X-Received: by 2002:a63:f817:: with SMTP id n23mr73142761pgh.35.1563815447797;
        Mon, 22 Jul 2019 10:10:47 -0700 (PDT)
Date: Mon, 22 Jul 2019 10:10:46 -0700
From: Kees Cook <keescook@chromium.org>
To: "Gote, Nitin R" <nitin.r.gote@intel.com>
Cc: Vegard Nossum <vegard.nossum@gmail.com>,
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Subject: Re: Regarding have kfree() (and related) set the pointer to NULL too
Message-ID: <201907221004.E8583B5F28@keescook>
References: <12356C813DFF6F479B608F81178A561586BDFE@BGSMSX101.gar.corp.intel.com>
 <CAOMGZ=FfWUf=2wMKXJVOsfr5b394ERUbhQehEFOtMx8zh26M4w@mail.gmail.com>
 <201906270908.28E5E1FDC3@keescook>
 <12356C813DFF6F479B608F81178A5615875DA9@BGSMSX101.gar.corp.intel.com>
 <12356C813DFF6F479B608F81178A561587A39C@BGSMSX101.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <12356C813DFF6F479B608F81178A561587A39C@BGSMSX101.gar.corp.intel.com>

On Wed, Jul 17, 2019 at 10:01:21AM +0000, Gote, Nitin R wrote:
> > > -----Original Message-----
> > > From: Kees Cook [mailto:keescook@chromium.org]
> > > Sent: Thursday, June 27, 2019 9:52 PM
> > > To: Vegard Nossum <vegard.nossum@gmail.com>
> > > Cc: Gote, Nitin R <nitin.r.gote@intel.com>; kernel-
> > > hardening@lists.openwall.com
> > > Subject: Re: Regarding have kfree() (and related) set the pointer to
> > > NULL too
> > >
> > > On Thu, Jun 27, 2019 at 01:45:06PM +0200, Vegard Nossum wrote:
> > > > On Thu, 27 Jun 2019 at 12:23, Gote, Nitin R <nitin.r.gote@intel.com>
> > wrote:
> > > > > Hi,
> > > > >
> > > > > I’m looking  into “have kfree() (and related) set the pointer to NULL too”
> > > task.
> > > > >
> > > > > As per my understanding, I did below changes :
> > > > >
> > > > > Could you please provide some points on below ways ?
> > > > > @@ -3754,6 +3754,7 @@ void kfree(const void *objp)
> > > > >         debug_check_no_obj_freed(objp, c->object_size);
> > > > >         __cache_free(c, (void *)objp, _RET_IP_);
> > > > >         local_irq_restore(flags);
> > > > > +       objp = NULL;
> > > > >
> > > > > }
> > > >
> > > > This will not do anything, since the assignment happens to the local
> > > > variable inside kfree() rather than to the original expression that
> > > > was passed to it as an argument.
> > > >
> > > > Consider that the code in the caller looks like this:
> > > >
> > > > void *x = kmalloc(...);
> > > > kfree(x);
> > > > pr_info("x = %p\n", x);
> > > >
> > > > this will still print "x = (some non-NULL address)" because the
> > > > variable 'x' in the caller still retains its original value.
> > > >
> > > > You could try wrapping kfree() in a C macro, something like
> > > >
> > > > #define kfree(x) real_kfree(x); (x) = NULL;
> > >
> > > Right, though we want to avoid silent double-evaluation, so we have to
> > > do some macro tricks. I suspect the starting point is something like:
> > >
> > > #define kfree(x)			\
> > > 	do {				\
> > > 		typeof(x) *ptr = &(x);	\
> > > 		real_kfree(*ptr);	\
> > > 		*ptr = NULL;		\
> > > 	} while (0)
> > >
> > > However, there are a non-zero number of places in the kernel where
> > > kfree() is used on things that are not simple memory references, like
> > > function return values, or copies of the actual reference:
> > >
> > > 	kfree(get_my_allocation(foo));
> > >
> 
> We have not found any clue or compiler extension on this case to know x 
> is value or variable.

Do you mean find a way to detect if this is a function return value?
Yeah, this seems like a needed step.

> There are around 300 such cases in kernel where kfree() is used on function return values. 
> 
> One proposal is we can refactor the kfree() call by assigning it to local variable so that
> we can overcome the compilation issue (error: lvalue required as unary & operand).

What were you thinking for an implementation? Universally using a local
variable doesn't gain very much (since you're just setting the local
variable NULL, not the one that lives on outside the call to kfree()).

> Please let us know that we should proceed with this proposal or you (or anyone)
> have other proposals.
> 
> > > or
> > >
> > > 	previous = something->allocation;
> > > 	...
> > > 	kfree(previous)
> > >
> 
> As of now, we don't have any idea to overcome this case. 
> So, we are keeping this for later stage. 

It sounds like this may not be possible with the existing APIs -- maybe
a compiler feature is needed to do the variable tracking (and also the
"was this a function return value?" check).

> 
> In case anyone has idea on this then let me know, 
> we are ready to work on this. 
> 
> > > So the larger work is figuring out how to gracefully deal with those
> > > using a reasonable API, or through refactoring.
> > >
> > > However, before getting too far, it's worth going though past
> > > use-after-free vulnerabilities to figure out how many would have been
> > > rendered harmless (NULL deref instead of UaF) with this change. Has
> > > this been studied before, etc. With this information it's easier to
> > > decide if the benefit of this refactoring is worth the work to do it.

This part is still worth checking: is there a real-world benefit to this
idea? (It seems like it should make some classes of UAF go away, but
it'd be nice to back this up with some "proof" from existing prior
exploits.)

-- 
Kees Cook
