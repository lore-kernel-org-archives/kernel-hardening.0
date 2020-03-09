Return-Path: <SRS0=35Yx=42=lists.openwall.com=kernel-hardening-return-18111-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1B71C18E5A
	for <kernel-hardening@archiver.kernel.org>; Mon,  9 Mar 2020 16:59:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5131620727
	for <kernel-hardening@archiver.kernel.org>; Mon,  9 Mar 2020 16:59:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kkDM6ZUx"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5131620727
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18111-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20149 invoked by uid 550); 9 Mar 2020 16:59:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 14335 invoked from network); 9 Mar 2020 16:49:45 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bNoFPXhpvMiuUF7F+uekItlbOQGQEdKTXJsSJYz6wNk=;
        b=kkDM6ZUxQYSDcpRCzqXBzl6yRdTxqvu7JFcn1rImw8v+HOQq5uEy+Sz/qwy5/3C+s3
         KUB+FBs5z4n/A5MqPulS4DKCuhgmvKIaNUHArlCnB0h/4FTfLx81RD+3NgPaOsTFI1sc
         Xht0fVFnt3MfGytquyliFmFlyCRFniOygfHi/nqq5EDEZIh0kzrbvrDR7LEVlhMc98eX
         29sgNmh17iEBtwdaaw3GPVgxtwO9+CmG5NxPouEQhUPQ9nIeCFBa/YA5/1Cb1Wws7s7Y
         +vU04Kr5himrgDw19nt8CDZj7ZuERB70/bdH97/T6iWuj6uLbmoM8YruSAMB5TCOsPlb
         8E3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=bNoFPXhpvMiuUF7F+uekItlbOQGQEdKTXJsSJYz6wNk=;
        b=D3V2Wne0i4j0UE5xbkgiiL9QmYQFLPGtzkjVc0JCzs8IvRDLidFoNSKWQoKe9Dd+/t
         MS0J8Zu06xxzBd2vplV9uTpkW4f3MJtHlJhh4CFHIEhogdYr1qGGoHIM0Xf1DpREgPGj
         RWYsrmUd+Ar/U8g5Sr/wl0FgtvYlsRC7Aep43M3wg8QEZSG14Et8x62v933zWUL8nCI2
         phHCoz86twVunld1kQnMRrVCebN6vcyzXZvfFoEwopv2g7pitjTbzyKc2oZ/HyTDEVuL
         WuZzUYJugND+LEIVo91Z8U6WnG67iSyh9tFY19VA+ZEfOFBZ5kXYW4QD1tHJKfQkum7h
         4eIA==
X-Gm-Message-State: ANhLgQ16ULGcD4U4lVJUD26IPvlTkReSaugwYGmHRdLluG9z5neciGK7
	pXpECHk+0MWrYYqawmosJkY=
X-Google-Smtp-Source: ADFU+vt/onT9cxmuspJ5T+KCU952uWkieCbEwJO4adVK6fLUN8zSNRf6ArvXDJD1xRu8YQakUYup1A==
X-Received: by 2002:a17:90b:1882:: with SMTP id mn2mr105796pjb.139.1583772573044;
        Mon, 09 Mar 2020 09:49:33 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date: Mon, 9 Mar 2020 09:49:31 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
	linux@armlinux.org.uk, Kees Cook <keescook@chromium.org>,
	Emese Revfy <re.emese@gmail.com>, Arnd Bergmann <arnd@arndb.de>,
	Laura Abbott <labbott@redhat.com>,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v3] ARM: smp: add support for per-task stack canaries
Message-ID: <20200309164931.GA23889@roeck-us.net>
References: <20181206083257.9596-1-ard.biesheuvel@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181206083257.9596-1-ard.biesheuvel@linaro.org>
User-Agent: Mutt/1.9.4 (2018-02-28)

On Thu, Dec 06, 2018 at 09:32:57AM +0100, Ard Biesheuvel wrote:
> On ARM, we currently only change the value of the stack canary when
> switching tasks if the kernel was built for UP. On SMP kernels, this
> is impossible since the stack canary value is obtained via a global
> symbol reference, which means
> a) all running tasks on all CPUs must use the same value
> b) we can only modify the value when no kernel stack frames are live
>    on any CPU, which is effectively never.
> 
> So instead, use a GCC plugin to add a RTL pass that replaces each
> reference to the address of the __stack_chk_guard symbol with an
> expression that produces the address of the 'stack_canary' field
> that is added to struct thread_info. This way, each task will use
> its own randomized value.
> 
> Cc: Russell King <linux@armlinux.org.uk>
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Emese Revfy <re.emese@gmail.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Laura Abbott <labbott@redhat.com>
> Cc: kernel-hardening@lists.openwall.com
> Acked-by: Nicolas Pitre <nico@linaro.org>
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

Since this patch is in the tree, cc-option no longer works on
the arm architecture if CONFIG_STACKPROTECTOR_PER_TASK is enabled.

Any idea how to fix that ? 

Thanks,
Guenter
