Return-Path: <SRS0=9wrp=4S=lists.openwall.com=kernel-hardening-return-18028-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BFEB6C3F2C6
	for <kernel-hardening@archiver.kernel.org>; Sun,  1 Mar 2020 00:11:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1EFB224649
	for <kernel-hardening@archiver.kernel.org>; Sun,  1 Mar 2020 00:11:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="u+6DgU7O"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1EFB224649
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=alum.mit.edu
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18028-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22411 invoked by uid 550); 1 Mar 2020 00:11:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22379 invoked from network); 1 Mar 2020 00:11:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=3tYKB2ToaIQnbC0ndiITx7BdT8yRg6GYHGZIM+yZOF4=;
        b=u+6DgU7OlIQLBQ3P8XYjTUI6xh9cKsGzL8N4Zljr++uSy4c/i6KZ+HoT5qHXZOJpiS
         uWvmH2TmNZys7qVxxye6WO0c666s/+5LwCinkCvn/gwWU+tOgHvb4bDFougbqNmSVElQ
         ckqsExJwfHcmWIpGFJZh8n4SeF/UrJ+r6q6lWXcMeA51jUNdzsRmFKOa+Atirmy5KHI6
         eLfnIV6Eegsj5UWiT2p/97M4LhDVje59uKLAnacnZTS473o1YrgZpulzRyc3WkfC4ZfC
         mR0hiWhj3eKtZQpXBIvv982zKW/rWkli4iZO8s68EHZE08d5oqLY6/DZYYns4e6ECp0U
         Kidg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:date:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=3tYKB2ToaIQnbC0ndiITx7BdT8yRg6GYHGZIM+yZOF4=;
        b=JTqRsbvbF4u4K1/BJuV4Wi0kSj2X1qFrqbn1QxE/Qlg28OyFqXSL3q4DfvbNh+VVFB
         tvp2XTWmIqaOIHSmmYLhfG/kjg9hOZtMHGugEabc19u2gMrOyABbRJUsYpohDJKFUOzU
         EKuzJqsAwDmN37rXEdjDHedVAcBbLAJMEvqJYLNX1HfXNbQ9/3DqX1Q4PW1+JFHfrCGI
         FF1fkw1RpGV0XGeEX6Ai+cQ/1dhd+A8fQ987kqkUHHky6dqZM5B8a4GSkhNOjuXSiZCX
         x8ssnOCwTEpeiT4nDSvf7pw5FJUBxnkQoZe+A3AkkiOKoRCbifH9zwYpo7bfkRMRvgBz
         5qRA==
X-Gm-Message-State: APjAAAVadrtmlYifQtCdYFzKx2yj8mxpQqpGNjWnKVB8kHaHADrvpce2
	B3y7JMgPhQ9EqdIH2LsF6L4=
X-Google-Smtp-Source: APXvYqwT6diWdvuhxX543aTn35qI2BUo2FL7gUorP9jX0s3qLtx4AN7mcQ/mmPtoxnEX48v3pq7tMw==
X-Received: by 2002:a0c:b203:: with SMTP id x3mr9403820qvd.197.1583021485669;
        Sat, 29 Feb 2020 16:11:25 -0800 (PST)
Sender: Arvind Sankar <niveditas98@gmail.com>
From: Arvind Sankar <nivedita@alum.mit.edu>
X-Google-Original-From: Arvind Sankar <arvind@rani.riverdale.lan>
Date: Sat, 29 Feb 2020 19:11:23 -0500
To: Kees Cook <keescook@chromium.org>
Cc: Arvind Sankar <nivedita@alum.mit.edu>, dave.hansen@linux.intel.com,
	kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
	luto@kernel.org, me@tobin.cc, peterz@infradead.org, tycho@tycho.ws,
	x86@kernel.org
Subject: Re: [PATCH] x86/mm/init_32: Don't print out kernel memory layout if
 KASLR
Message-ID: <20200301001123.GA1278373@rani.riverdale.lan>
References: <20200226215039.2842351-1-nivedita@alum.mit.edu>
 <202002291534.ED372CC@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202002291534.ED372CC@keescook>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Sat, Feb 29, 2020 at 03:51:45PM -0800, Kees Cook wrote:
> Arvind Sankar said:
> > For security, only show the virtual kernel memory layout if KASLR is
> > disabled.
> 
> These have been entirely removed on other architectures, so let's
> just do the same for ia32 and remove it unconditionally.
> 
> 071929dbdd86 ("arm64: Stop printing the virtual memory layout")
> 1c31d4e96b8c ("ARM: 8820/1: mm: Stop printing the virtual memory layout")
> 31833332f798 ("m68k/mm: Stop printing the virtual memory layout")
> fd8d0ca25631 ("parisc: Hide virtual kernel memory layout")
> adb1fe9ae2ee ("mm/page_alloc: Remove kernel address exposure in free_reserved_area()")
> 
> -Kees
> 
> -- 
> Kees Cook

microblaze (arch/microblaze/mm/init.c) and PPC32 (arch/powerpc/mm/mem.c)
appear to still print it out. I can't test those, but will resubmit
x86-32 with it removed.
