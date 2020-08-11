Return-Path: <SRS0=99tM=BV=lists.openwall.com=kernel-hardening-return-19590-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D075BC433E0
	for <kernel-hardening@archiver.kernel.org>; Tue, 11 Aug 2020 12:17:02 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2A20D20578
	for <kernel-hardening@archiver.kernel.org>; Tue, 11 Aug 2020 12:17:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SUZSVEhC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2A20D20578
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19590-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 18120 invoked by uid 550); 11 Aug 2020 12:16:53 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 18079 invoked from network); 11 Aug 2020 12:16:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BfaOWSVdZQ07T1WYL8SAoDKGztX/6CbsXqzUzK0St8s=;
        b=SUZSVEhCg6bsE5g5AFV3Nu7ILrIBK14FCJeQTRW4bRuMioqVg6Xp+cvlp3Yg1AIoqp
         +KJKITEVIQCC1qHMKKl6em+lfdg+/slX9FriU4yJcV/PdONBjp+w5Vg7c5lA5H/B30xo
         kbK88mNEzpr+gxCHW2krRACRsrCFrXErLis+oz+OGxiTog21ZC3h/ORMHGljsYc9qYWV
         ZeSRskj+HxmoIBBv6sNByjudCtnXj72+c/p3RBZs0DnyCBEZoD1zrdj3FaN1e60XJNeh
         zDBtXC4LSVsOIfENZwvo9yqNGeotY1MPPOUoEKYypDhOkuCUPSA4AiGeNj248+s7ZXKA
         jOMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BfaOWSVdZQ07T1WYL8SAoDKGztX/6CbsXqzUzK0St8s=;
        b=MOCzGLXaGpitXEykpMKHYh9gT6zIZDQP/yNQO+JwwGdPvHfh7InVzCSJqsQxvtqgXc
         6qdv1e88UXIYvJEo11hnKaofynQpW4hvXpfgPSvA3Gqfd5Ki7PkPkoi0cniMHHFyTSbJ
         4W3DREoaD8JXC6TqkO4mfd11+7H6UKP4tNZ1a6AFtoqpRilL6xyJP6n1/fn4qlh/TYhX
         bepTdM+LulyI7qhQzdBVd8CoZqhIrr7g2IMnzezZA7cGPoHajmvUZBgc9mVx6ICyF91B
         Uo0kICzoA8BI8FzeBQFktZR2GvRs/p2y478loaezjNftOu+tRGhXF0tPgM4jfmsTW3+e
         /LtQ==
X-Gm-Message-State: AOAM533uh4lw/K7mXvwzDLOfuacJII29ROm1jB22TFM/kWy1sKx0YcFF
	1iIZpken7fTqJhMTiMtWl6lUFKfJFUjKk+JHGgw=
X-Google-Smtp-Source: ABdhPJzSaTIBww3RVWzclOnCFAapTOONrFiRaRjDySuKQvXkeW9wMlyEhPPRLW4/2hyPS3tLM0iChxXJ4fWU8jt/XPY=
X-Received: by 2002:a4a:2c83:: with SMTP id o125mr823335ooo.84.1597148201081;
 Tue, 11 Aug 2020 05:16:41 -0700 (PDT)
MIME-Version: 1.0
References: <20200716030847.1564131-1-keescook@chromium.org>
 <87h7tpa3hg.fsf@nanos.tec.linutronix.de> <202007301113.45D24C9D@keescook> <CAOMdWSJQKHAWY1P297b9koOLd8sVtezEYEyWGtymN1YeY27M6A@mail.gmail.com>
In-Reply-To: <CAOMdWSJQKHAWY1P297b9koOLd8sVtezEYEyWGtymN1YeY27M6A@mail.gmail.com>
From: Allen <allen.lkml@gmail.com>
Date: Tue, 11 Aug 2020 17:46:29 +0530
Message-ID: <CAOMdWSLef4Vy=k-Kfp8RJ++=SsMwCQTU4+hEueK_APDGvJ-PaA@mail.gmail.com>
Subject: Re: [PATCH 0/3] Modernize tasklet callback API
To: Kees Cook <keescook@chromium.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Oscar Carter <oscar.carter@gmx.com>, Romain Perier <romain.perier@gmail.com>, 
	"David S. Miller" <davem@davemloft.net>, Peter Zijlstra <peterz@infradead.org>, 
	Will Deacon <will@kernel.org>, linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, linux-s390@vger.kernel.org, 
	devel@driverdev.osuosl.org, linux-usb@vger.kernel.org, 
	kgdb-bugreport@lists.sourceforge.net, alsa-devel@alsa-project.org, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

Kees,

> >
>
> Here's the series re-based on top of 5.8
> https://github.com/allenpais/tasklets/tree/V3
>
> Let me know how you would want these to be reviewed.
>

  I see the first set of infrastructure patches for tasklets have
landed in Linus's tree. Good time to send out the ~200 patches?

- Allen
