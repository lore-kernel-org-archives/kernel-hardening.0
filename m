Return-Path: <SRS0=vEXQ=44=lists.openwall.com=kernel-hardening-return-18123-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60428C2BB1D
	for <kernel-hardening@archiver.kernel.org>; Wed, 11 Mar 2020 17:21:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 597AC20746
	for <kernel-hardening@archiver.kernel.org>; Wed, 11 Mar 2020 17:21:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="hBmJYWBf"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 597AC20746
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18123-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32209 invoked by uid 550); 11 Mar 2020 17:21:34 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32188 invoked from network); 11 Mar 2020 17:21:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=48QMmtUizH1thzm0jNujCj845cQ2EXOxCkSOb8ufm7M=;
        b=hBmJYWBfK3SX/U+Wa4lao0YnvSduvT0NJG7V47ocA+P7MefK8eMomjpe/u+lfXRu15
         xn2lsBH74aGiSSYjBxFvcQm5wdnJipqlMRNpIOXkiI+AmYbIVDCGXMTkE3S2azr3V/iG
         82LN/7oe0JmAHSXXbhgxIZZvf2n5P7G6lOJCw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=48QMmtUizH1thzm0jNujCj845cQ2EXOxCkSOb8ufm7M=;
        b=sQKcygJsr0zr4ezRX4jG2PtwmTVno0P2uz5qr8DfVS7n6HOteJdC9DLXiaeBgNEN7Y
         kEbl2Oe0wLPOPBY7E8/MobKojbtj1V3fAld7UGh2jKyRNTA2DhnVnrKMLjByod94IAqM
         ++OYAQ02XKK/Rm1Q1T9ezLoj9IgGNFax83BQAN7Wies9eSpGPhQkoOXmjKM3uEb89FqM
         MZ+opXsJSioNALzcmGtrmwzszS1F3nISo7iSzUZ3L574gdHHKZljhuqC+9ss2v0wq08/
         NDnm03tua/EG2QJwP84GfCNOLozRCFyxlHxb1v7kaj82YvpH8gcuPEBx0AsHPi2gL8/c
         cq6w==
X-Gm-Message-State: ANhLgQ1BjrYYWiog5O8FqDsn2LPiFton1g5y0Q0vMujDAEeKl1bMQrYr
	zf3v9aow8iiPdIu3u9l7vCFJdA==
X-Google-Smtp-Source: ADFU+vtS/zoEiYrbfBlqHQlR3ycd/w8ksv3ZJl14F8NXwUqH9zruMZSDylPWrhrRh1sygoxYbEZgXg==
X-Received: by 2002:a17:902:8509:: with SMTP id bj9mr4163017plb.123.1583947282062;
        Wed, 11 Mar 2020 10:21:22 -0700 (PDT)
Date: Wed, 11 Mar 2020 10:21:20 -0700
From: Kees Cook <keescook@chromium.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux@armlinux.org.uk, Emese Revfy <re.emese@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>, Laura Abbott <labbott@redhat.com>,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v3] ARM: smp: add support for per-task stack canaries
Message-ID: <202003111020.D543B4332@keescook>
References: <20181206083257.9596-1-ard.biesheuvel@linaro.org>
 <20200309164931.GA23889@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200309164931.GA23889@roeck-us.net>

On Mon, Mar 09, 2020 at 09:49:31AM -0700, Guenter Roeck wrote:
> On Thu, Dec 06, 2018 at 09:32:57AM +0100, Ard Biesheuvel wrote:
> > On ARM, we currently only change the value of the stack canary when
> > switching tasks if the kernel was built for UP. On SMP kernels, this
> > is impossible since the stack canary value is obtained via a global
> > symbol reference, which means
> > a) all running tasks on all CPUs must use the same value
> > b) we can only modify the value when no kernel stack frames are live
> >    on any CPU, which is effectively never.
> > 
> > So instead, use a GCC plugin to add a RTL pass that replaces each
> > reference to the address of the __stack_chk_guard symbol with an
> > expression that produces the address of the 'stack_canary' field
> > that is added to struct thread_info. This way, each task will use
> > its own randomized value.
> > 
> > Cc: Russell King <linux@armlinux.org.uk>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Emese Revfy <re.emese@gmail.com>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Laura Abbott <labbott@redhat.com>
> > Cc: kernel-hardening@lists.openwall.com
> > Acked-by: Nicolas Pitre <nico@linaro.org>
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> 
> Since this patch is in the tree, cc-option no longer works on
> the arm architecture if CONFIG_STACKPROTECTOR_PER_TASK is enabled.
> 
> Any idea how to fix that ? 

I thought Arnd sent a patch to fix it and it got picked up?

-- 
Kees Cook
