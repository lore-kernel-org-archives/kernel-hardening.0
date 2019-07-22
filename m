Return-Path: <SRS0=JTqf=VT=lists.openwall.com=kernel-hardening-return-16523-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7534FC7618F
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jul 2019 17:19:36 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C725D2182B
	for <kernel-hardening@archiver.kernel.org>; Mon, 22 Jul 2019 17:19:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="JOxI9X/1"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C725D2182B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16523-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21770 invoked by uid 550); 22 Jul 2019 17:19:29 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21733 invoked from network); 22 Jul 2019 17:19:29 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=QpwwIwoixp2xDznQDmD2IugjJbyyR4SgSTSEyMFshWk=;
        b=JOxI9X/1uWHHCypSU3ys8g6PCl8ZFqF+HCymPLcNC0VD1+ga/VE+uHujIwfGarZD2g
         0q1FS0Vs58UqKRYLOv5tkA3Mgc6fOOE7N+x0Cm/XbWhgOTJCmY+b6VDjQNJDSIMdqOxT
         yz39ZvgeLN11f/3uol2zURhzx4KvN8aMwX+FQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=QpwwIwoixp2xDznQDmD2IugjJbyyR4SgSTSEyMFshWk=;
        b=Aa5U002oKYugkH53P8P1IiuUZWh8E8MO1Uew/guRyCnjVk3SuN3aIlgCfoNLLg2Qaz
         j2u7Sffgka0k0tMFCcJ/sOulAETnuDO+EG54m+pf7xEyIF5LOaA011AQy1c1KIypArr0
         cRxJkbF0G9I5rStj9pxIvEof9EfRpPqmgejiLRcXHCDVjwPWGO6WiCNOrjOcJV2n2HWs
         00OtT2zOxvOt0M3+0K2Jvzp3WIg85rDBSNPUnoVbiBsIyyABER6dgmyJheh/7yogZG/S
         8Yj4yf4cQanNfstp16K23wk6cCMK8chYWt8mHXNxZsIjOHJqyGLJppLgdb744a8StYny
         SiCA==
X-Gm-Message-State: APjAAAVkpMKyuKGhvoZFAA5KtBOvRLF0nT5tNNEso55QCHv0aNSa8ANV
	5sb+4uaXZmQ7lyzoj1xUGp0/4h5VAJc=
X-Google-Smtp-Source: APXvYqxi8r3VRM1mQlYtLyH/lMM9rc40tq/wHYoFDaB85knUjbo4E/wvxAdE9lNOlv4cXuvMBXTIjw==
X-Received: by 2002:a17:90a:a116:: with SMTP id s22mr77568184pjp.47.1563815957491;
        Mon, 22 Jul 2019 10:19:17 -0700 (PDT)
Date: Mon, 22 Jul 2019 10:19:15 -0700
From: Kees Cook <keescook@chromium.org>
To: Romain Perier <romain.perier@gmail.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Shyam Saini <mayhs11saini@gmail.com>
Subject: Re: refactor tasklets to avoid unsigned long argument
Message-ID: <201907221017.F61AFC08E@keescook>
References: <CABgxDoJzu-Pfq78AYJmf61KqJ2A3YXNJ7jMSS6p3kCzhFox0=w@mail.gmail.com>
 <201907020849.FB210CA@keescook>
 <CABgxDoJ6ra4DoPzEk8w25e0iTSHtNuYanHT-s+30JSzjfWestQ@mail.gmail.com>
 <201907031513.8E342FF@keescook>
 <CABgxDoLz76_nTqpdqMMH6+i1ia3k2bgiHkTV4Gc9X7vCe=CKRA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABgxDoLz76_nTqpdqMMH6+i1ia3k2bgiHkTV4Gc9X7vCe=CKRA@mail.gmail.com>

On Sun, Jul 21, 2019 at 07:55:33PM +0200, Romain Perier wrote:
> Ok, thanks for these explanations.

(Reminder: please use inline-context email replies instead of
top-posting, this makes threads much easier to read.)

> The task is in progress, you can follow the status here :
> https://salsa.debian.org/rperier-guest/linux-tree/tree/tasklet_init
> (the commit messages are tagged WIP, I will add a long message and
> signed-off-by , when it's done)

Looks good! I wonder if you're able to use Coccinelle to generate the
conversion patch? There appear to be just under 400 callers of
tasklet_init(), which is a lot to type by hand. :)

Also, have you found any other tasklet users that are NOT using
tasklet_init()? The timer_struct conversion had about three ways
to do initialization. :(

-- 
Kees Cook
