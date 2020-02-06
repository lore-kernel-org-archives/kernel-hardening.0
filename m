Return-Path: <SRS0=tvwV=32=lists.openwall.com=kernel-hardening-return-17699-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA203C352A2
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 11:56:57 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3AD9320661
	for <kernel-hardening@archiver.kernel.org>; Thu,  6 Feb 2020 11:56:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="je7nbPRU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3AD9320661
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17699-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11625 invoked by uid 550); 6 Feb 2020 11:56:51 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11597 invoked from network); 6 Feb 2020 11:56:50 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=uMsAapITXkLzJOLckwG4XojxmW0d1pjkgV4d2lZV/fE=;
        b=je7nbPRUzIurBISR1NYTtbJqnOaJQ4blgePkVkAxhJOR6ulsvPl17K4jqdMdXsqHZD
         J+zSsq5WaLrrOawSLfzQmIhC4S8hICmpxOxLejMF+c4DojYJja4JBhGMcRsBBuqqP/g+
         Onr9hXuFP7e5B+xORxzxCo3KFoIlBRUegbaUI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=uMsAapITXkLzJOLckwG4XojxmW0d1pjkgV4d2lZV/fE=;
        b=nxfU13fTzY5Vlg9lKCDXw/mYLZu9nnruTXYvrWjMHYf2EDwY14L6eJ/m60QRKFnmoI
         gJI635LPSSe4BFo1pzOYGuvpUAZz1vZhlDfKZGBW44CIpC0gWZABNBFRnDrcbxEefr+T
         7s5ZcJpPv4lbha8yYiMyvS3webl83ZXirhCUuJ55wMHgG/tHQ/piq2BdZPFAqwP/ok6t
         w9rduoOZyX1f/PAKmu+0nNZB0jBpwHTV0V0xpXmPyoyTi5FoT4586fGTQDO5RWfhkZMK
         8U/fBLjNhC4N76UTX1kVPDnbMQR0shkXYMnn2UAXGAqyMCtxRmyx1oLukyP5VBKjTX8K
         5rmw==
X-Gm-Message-State: APjAAAXDhriZTrUeXr8hgorCR6vdbg1Hj/IEELpYWhUdxMHYWr5yCojw
	cyyJ7r7I4wr20KAPsulKkCHyeQ==
X-Google-Smtp-Source: APXvYqzwToTMXn+aTOh/gblkFv/dlH3X35itT+RX5M+r5t5nmrsjGr3xv3LwBksLl8Co9w1+D/M2Ww==
X-Received: by 2002:a9d:6f07:: with SMTP id n7mr29037601otq.112.1580990198850;
        Thu, 06 Feb 2020 03:56:38 -0800 (PST)
Date: Thu, 6 Feb 2020 03:56:36 -0800
From: Kees Cook <keescook@chromium.org>
To: Andy Lutomirski <luto@kernel.org>
Cc: Kristen Carlson Accardi <kristen@linux.intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Arjan van de Ven <arjan@linux.intel.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: [RFC PATCH 08/11] x86: Add support for finer grained KASLR
Message-ID: <202002060353.A6A064A@keescook>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
 <20200205223950.1212394-9-kristen@linux.intel.com>
 <CALCETrVnCAzj0atoE1hLjHgmWjWAKVdSLm-UMtukUwWgr7-N9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrVnCAzj0atoE1hLjHgmWjWAKVdSLm-UMtukUwWgr7-N9Q@mail.gmail.com>

On Wed, Feb 05, 2020 at 05:17:11PM -0800, Andy Lutomirski wrote:
> On Wed, Feb 5, 2020 at 2:39 PM Kristen Carlson Accardi
> <kristen@linux.intel.com> wrote:
> >
> > At boot time, find all the function sections that have separate .text
> > sections, shuffle them, and then copy them to new locations. Adjust
> > any relocations accordingly.
> >
> 
> > +       sort(base, num_syms, sizeof(int), kallsyms_cmp, kallsyms_swp);
> 
> Hah, here's a huge bottleneck.  Unless you are severely
> memory-constrained, never do a sort with an expensive swap function
> like this.  Instead allocate an array of indices that starts out as
> [0, 1, 2, ...].  Sort *that* where the swap function just swaps the
> indices.  Then use the sorted list of indices to permute the actual
> data.  The result is exactly one expensive swap per item instead of
> one expensive swap per swap.

I think there are few places where memory-vs-speed need to be examined.
I remain surprised about how much memory the entire series already uses
(58MB in my local tests), but I suspect this is likely dominated by the
two factors: a full copy of the decompressed kernel, and that the
"allocator" in the image doesn't really implement free():
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/include/linux/decompress/mm.h#n55

-- 
Kees Cook
