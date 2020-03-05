Return-Path: <SRS0=2g4X=4W=lists.openwall.com=kernel-hardening-return-18086-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54C75C3F2D7
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Mar 2020 20:50:45 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A31F820870
	for <kernel-hardening@archiver.kernel.org>; Thu,  5 Mar 2020 20:50:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho-ws.20150623.gappssmtp.com header.i=@tycho-ws.20150623.gappssmtp.com header.b="KDxK8K+k"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A31F820870
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=tycho.ws
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18086-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22454 invoked by uid 550); 5 Mar 2020 20:50:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22422 invoked from network); 5 Mar 2020 20:50:37 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tycho-ws.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=w+OmpmqF00gA9FGrIOBgOQ4xJK5bBYcQsPPrukOSwVQ=;
        b=KDxK8K+kqZFSM1Ls+1Z0akgc9T4awAnlofZt4GX5sz88Iuz0zEEUi1WzniegxDnLj+
         IS1GPjWA/SAvmrYB8Nzmg3XSYo/yEzalY6+n+VCP8HTtmEQIevxUDAi851sC5TQqgJfI
         S7DFe4x2GzhL3UBSpzu4EFnnaxIxFW8gDyUjp3ZYRHDX2RaLBEyoXyN+PPYV7M22mfb6
         BJ9UUM0kLxwlvuBiIIqKEgfVeYKfGwXuplT0NZbjKSdvh4/zyRawcJHG5LzVeNsKSu4E
         vcWE/Y3R23XFhVkIgze/8lxDatDTgcbiNAhzYdO4NVDiqhHzwDD7EgX/rU+kcZzmn0UB
         UtuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=w+OmpmqF00gA9FGrIOBgOQ4xJK5bBYcQsPPrukOSwVQ=;
        b=ufgUPmERU7Jw09T67qbEQVKCpgxRM8KLLsckKhqdYfgAXiSc5x2cODNxkzjnbvMDMY
         rNhT/0HWrbB8gwYP5SVovE9DDzmpbPe4HoWanNTt6eLrmKYklRZsDJ6IgLRbdLa/7b1j
         kZtLNjn4YySxRE3s5068pL7UvniiVaQRlfcHg7pXTzHC12Nrz8tDvg1+PHvDQPdQsXte
         nJ2Fv5vT3jewrEYANcT3zO227VZCVLWXZuNChYV8xPqo71ZcqlMJGfWNGl7ZTWf8O5aM
         +MRkSsqcbIXJ6lGTWqKD+UNSmKj/Ahf5RM285r/6H5e1cCeizGnrrSSMIutG1JPYABwp
         QkWw==
X-Gm-Message-State: ANhLgQ1yk57WSww3V3USZlLO7nShX2GGDucNcT4lD4s9g5E5xsXgoj7Q
	l43m2+DuxHNLyKASSaf30N4snw==
X-Google-Smtp-Source: ADFU+vvTM/Al7Umv0rKSgmlF123yGh/rmK8r19ETS904XycHgtDzdV5FSkZzB8KqPw0qqLne1Lpu4A==
X-Received: by 2002:a25:664a:: with SMTP id z10mr89446ybm.461.1583441425906;
        Thu, 05 Mar 2020 12:50:25 -0800 (PST)
Date: Thu, 5 Mar 2020 13:50:19 -0700
From: Tycho Andersen <tycho@tycho.ws>
To: Arvind Sankar <nivedita@alum.mit.edu>
Cc: Kees Cook <keescook@chromium.org>, "Tobin C . Harding" <me@tobin.cc>,
	kernel-hardening@lists.openwall.com,
	Michal Simek <monstr@monstr.eu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] microblaze: Stop printing the virtual memory layout
Message-ID: <20200305205019.GB6506@cisco>
References: <202003021038.8F0369D907@keescook>
 <20200305150503.833172-1-nivedita@alum.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200305150503.833172-1-nivedita@alum.mit.edu>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Thu, Mar 05, 2020 at 10:05:03AM -0500, Arvind Sankar wrote:
> For security, don't display the kernel's virtual memory layout.
> 
> Kees Cook points out:
> "These have been entirely removed on other architectures, so let's
> just do the same for ia32 and remove it unconditionally."
> 
> 071929dbdd86 ("arm64: Stop printing the virtual memory layout")
> 1c31d4e96b8c ("ARM: 8820/1: mm: Stop printing the virtual memory layout")
> 31833332f798 ("m68k/mm: Stop printing the virtual memory layout")
> fd8d0ca25631 ("parisc: Hide virtual kernel memory layout")
> adb1fe9ae2ee ("mm/page_alloc: Remove kernel address exposure in free_reserved_area()")
> 
> Signed-off-by: Arvind Sankar <nivedita@alum.mit.edu>

Acked-by: Tycho Andersen <tycho@tycho.ws>
