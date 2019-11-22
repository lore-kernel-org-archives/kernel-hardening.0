Return-Path: <SRS0=SAzB=ZO=lists.openwall.com=kernel-hardening-return-17435-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5183FC432C0
	for <kernel-hardening@archiver.kernel.org>; Fri, 22 Nov 2019 16:52:38 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 9928020672
	for <kernel-hardening@archiver.kernel.org>; Fri, 22 Nov 2019 16:52:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="YcLtVyut"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 9928020672
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-17435-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17703 invoked by uid 550); 22 Nov 2019 16:52:30 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17668 invoked from network); 22 Nov 2019 16:52:29 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bIBZ/pDagkMXdQDKDvezMxRb4iRHYel+ahYnkHe//Mw=;
        b=YcLtVyutJTxK26Jq0OiYsnmEyoQyQFjeO7obWVSHlkjXGA69msCHJ1tBa8EQQRL9BJ
         jtOccOm7EWgUTRF7S9XJcsjIq0zkEfG/N3/29fz0xT/jA7K7rz5FtX7XAPEZ1CgnL2no
         9joKepTABeANY85Wb7q9PUBRCq6t16ZMupPEw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bIBZ/pDagkMXdQDKDvezMxRb4iRHYel+ahYnkHe//Mw=;
        b=Oy+5bTIbLWNiiA8acgtl1qflvxm0pIbqPhRaKmbbZs4wKSa6LziAwDgqnD2S1ByuqT
         2HeawP24Ik6M9J/kHjX3be2M4oBUU8K/4qVlXdfPqNFhw4y7P2x+YHfY88beJ5SI+OJj
         /NfW7t906QAU6Na5/KX7LsmPR2jq9I7BmKLzL1YfMPYvoc3+T6d0Oowrya7ZtUFD7jL6
         s3GDM2QkXAeVPR7wxFxgdyLltdgG2qeQmyW4vewNZjHQcNi535aqoZ4CPlZbR+3I+pPV
         kW7ofWtnzIkLkZM0D1xFk55fmXnKpkS69YsEqHaMImx2Y5Rt7lYRwRoIckWwzJYQbBhv
         QOlg==
X-Gm-Message-State: APjAAAU2hFTPTqPnkPno1aToG/aUByMYaZ/yXfnFmxiDJB8wzgl9BJrn
	l2j1X1PWK6oMiailNeFv+7ROQg==
X-Google-Smtp-Source: APXvYqzZwZG+BeFAjZyROOnizhpZkQHwGQ/kubJmglsdvzHe+7MOqzo4fPiO5n3oqh16frUICgp+OA==
X-Received: by 2002:a17:90a:de4:: with SMTP id 91mr20505683pjv.113.1574441537644;
        Fri, 22 Nov 2019 08:52:17 -0800 (PST)
Date: Fri, 22 Nov 2019 08:52:15 -0800
From: Kees Cook <keescook@chromium.org>
To: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Andrey Ryabinin <aryabinin@virtuozzo.com>,
	Elena Petrova <lenaptr@google.com>,
	Alexander Potapenko <glider@google.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	"Gustavo A. R. Silva" <gustavo@embeddedor.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	kasan-dev <kasan-dev@googlegroups.com>,
	LKML <linux-kernel@vger.kernel.org>,
	kernel-hardening@lists.openwall.com,
	syzkaller <syzkaller@googlegroups.com>
Subject: Re: [PATCH v2 0/3] ubsan: Split out bounds checker
Message-ID: <201911220845.622FDC4@keescook>
References: <20191121181519.28637-1-keescook@chromium.org>
 <CACT4Y+b3JZM=TSvUPZRMiJEPNH69otidRCqq9gmKX53UHxYqLg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACT4Y+b3JZM=TSvUPZRMiJEPNH69otidRCqq9gmKX53UHxYqLg@mail.gmail.com>

On Fri, Nov 22, 2019 at 10:07:29AM +0100, Dmitry Vyukov wrote:
> On Thu, Nov 21, 2019 at 7:15 PM Kees Cook <keescook@chromium.org> wrote:
> >
> > v2:
> >     - clarify Kconfig help text (aryabinin)
> >     - add reviewed-by
> >     - aim series at akpm, which seems to be where ubsan goes through?
> > v1: https://lore.kernel.org/lkml/20191120010636.27368-1-keescook@chromium.org
> >
> > This splits out the bounds checker so it can be individually used. This
> > is expected to be enabled in Android and hopefully for syzbot. Includes
> > LKDTM tests for behavioral corner-cases (beyond just the bounds checker).
> >
> > -Kees
> 
> +syzkaller mailing list
> 
> This is great!
> 
> I wanted to enable UBSAN on syzbot for a long time. And it's
> _probably_ not lots of work. But it was stuck on somebody actually
> dedicating some time specifically for it.
> Kees, or anybody else interested, could you provide relevant configs
> that (1) useful for kernel, (2) we want 100% cleanliness, (3) don't
> fire all the time even without fuzzing? Anything else required to
> enable UBSAN? I don't see anything. syzbot uses gcc 8.something, which
> I assume should be enough (but we can upgrade if necessary).

Nothing external should be needed; GCC and Clang support the ubsan
options. Once this series lands, it should be possible to just enable
this with:

CONFIG_UBSAN=y
CONFIG_UBSAN_BOUNDS=y
# CONFIG_UBSAN_MISC is not set

Based on initial testing, the bounds checker isn't very noisy, but I
haven't spun up a syzbot instance to really confirm this yet (that was
on the TODO list for today to let it run over the weekend).

-- 
Kees Cook
