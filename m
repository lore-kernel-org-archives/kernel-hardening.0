Return-Path: <SRS0=koEE=4X=lists.openwall.com=kernel-hardening-return-18100-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DAB7C10F00
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Mar 2020 08:05:11 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id F3F292073D
	for <kernel-hardening@archiver.kernel.org>; Fri,  6 Mar 2020 08:05:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F3F292073D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-m68k.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18100-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19589 invoked by uid 550); 6 Mar 2020 08:05:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19557 invoked from network); 6 Mar 2020 08:05:03 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=amxHAEVuD5PKAqXH5UoPsqWC2PaLt0se617vrFyjmJ8=;
        b=pj2hYTtGssuQgi3V7ry7qTbyUfejSHDdevuBo9YURGixCsMNUQCgvHHS7afihEzbRW
         RftsawTbF5Y75eBh78pzjQ60LYS+6QktFp6WOsRna9pwOgHisrkJAAvwr66QJCvUYd3N
         Sa+Bf2wCvNfMiGxodvv5bEMSW2B0Xy5/Wy2y/S83et7EHNg6bSf6z0b/O79HY8NRxcmW
         HHTyjZUqvgdYFrgRODk1WNngp8M/WVdWGFd8j4IDzWku3DXoqNbnWnrOz3E1PUcur9c5
         0+hvbIR3r2OkxcaQRVzhflFs5oMGLxn8RNSa+G150ifdD7aM2LmDhJpS1bXD4PK49HFm
         SRzw==
X-Gm-Message-State: ANhLgQ2tn/wlmrTQSWzbLNEZEbZ+1JD7QuKA60snXVWU88w1uPNbu/FU
	jg01Ybe1lyWnK0IzMflx3e6Ey8syllB7aEse8JU=
X-Google-Smtp-Source: ADFU+vtlDpFfaubyko7ZpC8uPYldjA9crYo8K9PGRZCVsCWdWiwtdf++OIGRPvYIF5xT5MGmJTUCJyiSR233bJUOsaU=
X-Received: by 2002:a05:6830:12d1:: with SMTP id a17mr1547778otq.39.1583481891563;
 Fri, 06 Mar 2020 00:04:51 -0800 (PST)
MIME-Version: 1.0
References: <202003021038.8F0369D907@keescook> <20200305151010.835954-1-nivedita@alum.mit.edu>
 <f672417e-1323-4ef2-58a1-1158c482d569@physik.fu-berlin.de>
In-Reply-To: <f672417e-1323-4ef2-58a1-1158c482d569@physik.fu-berlin.de>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Fri, 6 Mar 2020 09:04:40 +0100
Message-ID: <CAMuHMdVG+ueSeMw1BEKSv15zun4eOB1ZzdGidH8quy2zMp7tdg@mail.gmail.com>
Subject: Re: [PATCH] sh: Stop printing the virtual memory layout
To: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Arvind Sankar <nivedita@alum.mit.edu>, Kees Cook <keescook@chromium.org>, 
	"Tobin C . Harding" <me@tobin.cc>, Tycho Andersen <tycho@tycho.ws>, kernel-hardening@lists.openwall.com, 
	Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, 
	Linux-sh list <linux-sh@vger.kernel.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Adrian,

On Thu, Mar 5, 2020 at 4:18 PM John Paul Adrian Glaubitz
<glaubitz@physik.fu-berlin.de> wrote:
> On 3/5/20 4:10 PM, Arvind Sankar wrote:
> > For security, don't display the kernel's virtual memory layout.
> >
> > Kees Cook points out:
> > "These have been entirely removed on other architectures, so let's
> > just do the same for ia32 and remove it unconditionally."
> >
> > 071929dbdd86 ("arm64: Stop printing the virtual memory layout")
> > 1c31d4e96b8c ("ARM: 8820/1: mm: Stop printing the virtual memory layout")
> > 31833332f798 ("m68k/mm: Stop printing the virtual memory layout")
> > fd8d0ca25631 ("parisc: Hide virtual kernel memory layout")
> > adb1fe9ae2ee ("mm/page_alloc: Remove kernel address exposure in free_reserved_area()")
> Aww, why wasn't this made configurable? I found these memory map printouts
> very useful for development.

In most of the above (but not in this patch), "%p" was used to print
addresses, which started showing useless hashed addresses since commit
ad67b74d2469d9b8 ("printk: hash addresses printed with %p").

Instead of changing them all to print usable addresses instead, it was
agreed upon to just remove them.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
