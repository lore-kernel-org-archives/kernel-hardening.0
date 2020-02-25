Return-Path: <SRS0=972h=4N=lists.openwall.com=kernel-hardening-return-17918-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D677C35E04
	for <kernel-hardening@archiver.kernel.org>; Tue, 25 Feb 2020 17:50:14 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A21D92082F
	for <kernel-hardening@archiver.kernel.org>; Tue, 25 Feb 2020 17:50:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Le1Nz8N5"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A21D92082F
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=alum.mit.edu
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17918-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21815 invoked by uid 550); 25 Feb 2020 17:50:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21793 invoked from network); 25 Feb 2020 17:50:07 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xRRmwcNUsR+GhcUjy9+SyPV6XEYtfd5D5Ja+YQokWiA=;
        b=Le1Nz8N5wJimx6Cq77znmKci4x87K/gkTCkMfK1j7bJ8Fv9ymgm/XdiSiOnPcw59Uw
         rLt/1/ZWyfPowrtLXK1HsrBUNyO7hODU7ZiV/uvlIkSSg+i8Fr+zjxZ4w+DPEe74w7fn
         Zf6eXtWvTOQnAMfHADwvdXdfpmgR1iX4ijn446/439PzTmMu+JjT6M99asMiUWlI4ioc
         FyiGlNwsZOT9MUA/7uMaUcqfyjRPMSBEaBRs92XACg/xV5HOCOPGbjeFQUrwfIR8F0R7
         m8/NWnpniNXJAuTgdF+aFLOsWCOZCNNSALWVB641OGBBw7N8SkAD154cauwtYpJJ9W7Q
         K1Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=xRRmwcNUsR+GhcUjy9+SyPV6XEYtfd5D5Ja+YQokWiA=;
        b=H4zcd5HDn0lFVBOjUh/N0YciU0awNQYLIjNZbg8tF1YipmHBu6TERPtcMzUWlNzXwN
         nY3/kcYSVEXFfLg/8HBytuB2vTGwXPRlINBY5IEWCf81jmoXhWb/ViHBmZPxqWZk+mD6
         dND/PoDTd9v7uf6+zazz3PF/e6zVkfMIe1Gkkfz+MHhvUncYjGQ1xbCW0lwYLwE01RFl
         tP81WcXD0Ll9ZZ4MXGLQa7TDtB0IDGjKbLTermxRRdxd/mm1v+03yH+8P4f+rsdbVcan
         sC3xqUkVXRvXeo3hw+vjKcdxx6S5fReGesCQJZ2MYbbbZXAFwP3aM0FhP60mPvSrOD+U
         kkrQ==
X-Gm-Message-State: APjAAAUKqLRSX0vthUaeNtVGWMckpjb85pvk1msNkm4A9zoJNxYCCyhH
	YmuGmmYxjoVT8ioTdr5VMV4=
X-Google-Smtp-Source: APXvYqzZa4ogNVvT5VxJnr40/hfAfIF63UJfQH6ZI2z+wrgJCDPOis9RIBPDS3YG3vDgxX31ODwTXQ==
X-Received: by 2002:ac8:1308:: with SMTP id e8mr56613876qtj.242.1582652995139;
        Tue, 25 Feb 2020 09:49:55 -0800 (PST)
Sender: Arvind Sankar <niveditas98@gmail.com>
From: Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date: Tue, 25 Feb 2020 12:49:53 -0500
To: Kristen Carlson Accardi <kristen@linux.intel.com>
Cc: tglx@linutronix.de, mingo@redhat.com, bp@alien8.de, hpa@zytor.com,
	arjan@linux.intel.com, keescook@chromium.org,
	rick.p.edgecombe@intel.com, x86@kernel.org,
	linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
Subject: Re: [RFC PATCH 08/11] x86: Add support for finer grained KASLR
Message-ID: <20200225174951.GA1373392@rani.riverdale.lan>
References: <20200205223950.1212394-1-kristen@linux.intel.com>
 <20200205223950.1212394-9-kristen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200205223950.1212394-9-kristen@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Wed, Feb 05, 2020 at 02:39:47PM -0800, Kristen Carlson Accardi wrote:
> At boot time, find all the function sections that have separate .text
> sections, shuffle them, and then copy them to new locations. Adjust
> any relocations accordingly.
> 
> Signed-off-by: Kristen Carlson Accardi <kristen@linux.intel.com>
> ---
>  arch/x86/boot/compressed/Makefile        |   1 +
>  arch/x86/boot/compressed/fgkaslr.c       | 751 +++++++++++++++++++++++
>  arch/x86/boot/compressed/misc.c          | 106 +++-
>  arch/x86/boot/compressed/misc.h          |  26 +
>  arch/x86/boot/compressed/vmlinux.symbols |  15 +
>  arch/x86/include/asm/boot.h              |  15 +-
>  arch/x86/include/asm/kaslr.h             |   1 +
>  arch/x86/lib/kaslr.c                     |  15 +
>  scripts/kallsyms.c                       |  14 +-
>  scripts/link-vmlinux.sh                  |   4 +
>  10 files changed, 939 insertions(+), 9 deletions(-)
>  create mode 100644 arch/x86/boot/compressed/fgkaslr.c
>  create mode 100644 arch/x86/boot/compressed/vmlinux.symbols
> 
> diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
> index b7e5ea757ef4..60d4c4e59c05 100644
> --- a/arch/x86/boot/compressed/Makefile
> +++ b/arch/x86/boot/compressed/Makefile
> @@ -122,6 +122,7 @@ OBJCOPYFLAGS_vmlinux.bin :=  -R .comment -S
>  
>  ifdef CONFIG_FG_KASLR
>  	RELOCS_ARGS += --fg-kaslr
> +	OBJCOPYFLAGS += --keep-symbols=$(obj)/vmlinux.symbols

I think this should be $(srctree)/$(src) rather than $(obj)? Using a
separate build directory fails currently.
