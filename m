Return-Path: <SRS0=ZSGJ=VU=lists.openwall.com=kernel-hardening-return-16567-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 11BADC76186
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jul 2019 22:18:10 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 633F722387
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Jul 2019 22:18:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="dAZim43y"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 633F722387
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16567-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21645 invoked by uid 550); 23 Jul 2019 22:18:04 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21627 invoked from network); 23 Jul 2019 22:18:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1tRj12XMgs1Y3+O1rqUEapdlbt8lWOQ+IFc7/KZfXPw=;
        b=dAZim43y7Eol9vmjAIB8BeRHMVgrkO1k/3/F/JV1WYKVM9LWLARy0MvDlAwVL63Flo
         MlOPIFFQgonzgSA3mtZL/G9iRF2G47QTYenotSsBUZCEI8uwAit9C+Rif4ZqFQQPdnUY
         8TdVLpPwlPoValbGfPqM1x5pMpvQFl+7gOoEU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1tRj12XMgs1Y3+O1rqUEapdlbt8lWOQ+IFc7/KZfXPw=;
        b=aQn0SKY+AWO/Y34RMDgMqt7+6tu7afZ2h5pDkh7Ae0Ol+AQz2jkUrcQi7gFCqi+uOq
         nvyZfrPT4gs/Y2hZ61jF7uiniRXVcdsaY7MQZPTJwTTD7VOx0Afr1rAd3yrlQvZJQcR2
         tyRFXv8O5U87+jiTpGI7sh3pNubcRClXE0ab8sILm6YRqBkfaPyearYMWuyF+M45FAuL
         HNQGPLWtpWIsGOaukiqI2G5fc15Zoc/bq6DpY/mzzL6Z7sjJB/hrvJbu4648UaoChmuT
         EIdu7Ih7FtGLcK9C94U9iLhApnlmi2DmN2232GKdcbXnvL2J5gFIneIP12G34v0Wk5TG
         9vxg==
X-Gm-Message-State: APjAAAW7qm6EUpwE5YZRZfmxSaqLDf15HbFgr5iDsBjQP6ei2uUF1xTp
	MD+Yaks6nhwQHWA0un1gGS6S4A==
X-Google-Smtp-Source: APXvYqxKDpqoSQmoMeWiZyozdu8jr1jHK0awjq6kY6EUyZIN/fJ86cWjhWRbVYlYok3Jw6Y0JckOvA==
X-Received: by 2002:a63:5452:: with SMTP id e18mr62112901pgm.232.1563920271498;
        Tue, 23 Jul 2019 15:17:51 -0700 (PDT)
Date: Tue, 23 Jul 2019 15:17:49 -0700
From: Kees Cook <keescook@chromium.org>
To: Jann Horn <jannh@google.com>
Cc: Ondrej Mosnacek <omosnace@redhat.com>,
	NitinGote <nitin.r.gote@intel.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Paul Moore <paul@paul-moore.com>,
	Stephen Smalley <sds@tycho.nsa.gov>,
	Eric Paris <eparis@parisplace.org>,
	SElinux list <selinux@vger.kernel.org>,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] selinux: convert struct sidtab count to refcount_t
Message-ID: <201907231516.11DB47AA@keescook>
References: <20190722113151.1584-1-nitin.r.gote@intel.com>
 <CAFqZXNs5vdQwoy2k=_XLiGRdyZCL=n8as6aL01Dw-U62amFREA@mail.gmail.com>
 <CAG48ez3zRoB7awMdb-koKYJyfP9WifTLevxLxLHioLhH=itZ-A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez3zRoB7awMdb-koKYJyfP9WifTLevxLxLHioLhH=itZ-A@mail.gmail.com>

On Tue, Jul 23, 2019 at 04:53:47PM +0200, Jann Horn wrote:
> On Mon, Jul 22, 2019 at 3:44 PM Ondrej Mosnacek <omosnace@redhat.com> wrote:
> > On Mon, Jul 22, 2019 at 1:35 PM NitinGote <nitin.r.gote@intel.com> wrote:
> > > refcount_t type and corresponding API should be
> > > used instead of atomic_t when the variable is used as
> > > a reference counter. This allows to avoid accidental
> > > refcounter overflows that might lead to use-after-free
> > > situations.
> > >
> > > Signed-off-by: NitinGote <nitin.r.gote@intel.com>
> >
> > Nack.
> >
> > The 'count' variable is not used as a reference counter here. It
> > tracks the number of entries in sidtab, which is a very specific
> > lookup table that can only grow (the count never decreases). I only
> > made it atomic because the variable is read outside of the sidtab's
> > spin lock and thus the reads and writes to it need to be guaranteed to
> > be atomic. The counter is only updated under the spin lock, so
> > insertions do not race with each other.
> 
> Probably shouldn't even be atomic_t... quoting Documentation/atomic_t.txt:
> 
> | SEMANTICS
> | ---------
> |
> | Non-RMW ops:
> |
> | The non-RMW ops are (typically) regular LOADs and STOREs and are canonically
> | implemented using READ_ONCE(), WRITE_ONCE(), smp_load_acquire() and
> | smp_store_release() respectively. Therefore, if you find yourself only using
> | the Non-RMW operations of atomic_t, you do not in fact need atomic_t at all
> | and are doing it wrong.
> 
> So I think what you actually want here is a plain "int count", and then:
>  - for unlocked reads, either READ_ONCE()+smp_rmb() or smp_load_acquire()
>  - for writes, either smp_wmb()+WRITE_ONCE() or smp_store_release()
> 
> smp_load_acquire() and smp_store_release() are probably the nicest
> here, since they are semantically clearer than smp_rmb()/smp_wmb().

Perhaps we need a "statistics" counter type for these kinds of counters?
"counter_t"? I bet there are a lot of atomic_t uses that are just trying
to be counters. (likely most of atomic_t that isn't now refcount_t ...)

-- 
Kees Cook
