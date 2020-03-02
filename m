Return-Path: <SRS0=fYUW=4T=lists.openwall.com=kernel-hardening-return-18038-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3116FC3F2CD
	for <kernel-hardening@archiver.kernel.org>; Mon,  2 Mar 2020 18:39:14 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8338C21739
	for <kernel-hardening@archiver.kernel.org>; Mon,  2 Mar 2020 18:39:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="hfP1LWoF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8338C21739
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18038-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30419 invoked by uid 550); 2 Mar 2020 18:39:06 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30375 invoked from network); 2 Mar 2020 18:39:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ej0n7zujhXtajx5o0YH5Dp6SgQHR/F6Xm8CHAXoCQaY=;
        b=hfP1LWoF98HaakBzzPLisRZah3h5wcxUGYhbaD61bTzqmqylwvkkyeXaBM5Uqz1lvD
         SP4xhO+dyxePNM/RIfC19zhyCQYo9ixXDi1Bi+F7dTsIiw27aCNk70BeiYtqEM1fBQT4
         fVHiEK6TYtL1vi4GuRcbFCkXFIauPUBlT/dvg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ej0n7zujhXtajx5o0YH5Dp6SgQHR/F6Xm8CHAXoCQaY=;
        b=lEFrlz9s2Ijsj9M7IA7m+zzDAH4bKagG3cC5J7jarzjFpZFzr1A3Xc9mT8FpejPcuh
         L148eBtwPEpDKoINnkKXfC/qaC0u3hsGf3alvO/7maPjWymY+Wx5TLz1nkYL8lR52iB+
         EwEEaoHLS7i3ELPg3Qn3LdwYQ/Lez/tbKYJSihB/kzW1zQ2cpSKeAUsHehrrZ2r3yE3M
         LMuXOVIIF/8C3FoH4k3csTch3LviL/nLu4R2sKCL1mEtRew8bguAMeYsox508eWhj5vs
         MuwaUDyd5LH+JaFFo49mXl+ceXHV3LBDW0bA7AkCiIcIf8GeuHWgdvMLxc0wDbd/MVoE
         9XBg==
X-Gm-Message-State: ANhLgQ1beauu6U/cuxkjiiNNVLaXJG+SosNzmls8ACNRH9NRVB0yiAsQ
	O9i35vOCiQrupJf3x7ylUz6iDA==
X-Google-Smtp-Source: ADFU+vsv11PyBcLRZxqMDdAd1Q/RQi5ywoEpqoxJWiv3D/4XrUyhginfjW/qzBGk00VMyBgMmY42Fw==
X-Received: by 2002:a63:6202:: with SMTP id w2mr276745pgb.154.1583174333320;
        Mon, 02 Mar 2020 10:38:53 -0800 (PST)
Date: Mon, 2 Mar 2020 10:38:51 -0800
From: Kees Cook <keescook@chromium.org>
To: Arvind Sankar <nivedita@alum.mit.edu>
Cc: dave.hansen@linux.intel.com, kernel-hardening@lists.openwall.com,
	linux-kernel@vger.kernel.org, luto@kernel.org, me@tobin.cc,
	peterz@infradead.org, tycho@tycho.ws, x86@kernel.org
Subject: Re: [PATCH] x86/mm/init_32: Don't print out kernel memory layout if
 KASLR
Message-ID: <202003021038.8F0369D907@keescook>
References: <20200226215039.2842351-1-nivedita@alum.mit.edu>
 <202002291534.ED372CC@keescook>
 <20200301001123.GA1278373@rani.riverdale.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200301001123.GA1278373@rani.riverdale.lan>

On Sat, Feb 29, 2020 at 07:11:23PM -0500, Arvind Sankar wrote:
> On Sat, Feb 29, 2020 at 03:51:45PM -0800, Kees Cook wrote:
> > Arvind Sankar said:
> > > For security, only show the virtual kernel memory layout if KASLR is
> > > disabled.
> > 
> > These have been entirely removed on other architectures, so let's
> > just do the same for ia32 and remove it unconditionally.
> > 
> > 071929dbdd86 ("arm64: Stop printing the virtual memory layout")
> > 1c31d4e96b8c ("ARM: 8820/1: mm: Stop printing the virtual memory layout")
> > 31833332f798 ("m68k/mm: Stop printing the virtual memory layout")
> > fd8d0ca25631 ("parisc: Hide virtual kernel memory layout")
> > adb1fe9ae2ee ("mm/page_alloc: Remove kernel address exposure in free_reserved_area()")
> > 
> > -Kees
> > 
> > -- 
> > Kees Cook
> 
> microblaze (arch/microblaze/mm/init.c) and PPC32 (arch/powerpc/mm/mem.c)
> appear to still print it out. I can't test those, but will resubmit
> x86-32 with it removed.

Might as well fix those up too. :)

-- 
Kees Cook
