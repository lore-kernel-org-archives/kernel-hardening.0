Return-Path: <SRS0=9HPP=CK=lists.openwall.com=kernel-hardening-return-19715-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B86B8C433E2
	for <kernel-hardening@archiver.kernel.org>; Tue,  1 Sep 2020 00:15:42 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 117C62071B
	for <kernel-hardening@archiver.kernel.org>; Tue,  1 Sep 2020 00:15:41 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=tycho-ws.20150623.gappssmtp.com header.i=@tycho-ws.20150623.gappssmtp.com header.b="DoaGZCkr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 117C62071B
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=tycho.ws
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19715-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26048 invoked by uid 550); 1 Sep 2020 00:15:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25992 invoked from network); 1 Sep 2020 00:15:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tycho-ws.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=XlESMETMrSEuJH96+KdMckQf3t/JsW6LWGQZfXlvWP4=;
        b=DoaGZCkr+TmKSj8YG+zSgBkIz9C2eiTGcW/FaBg449gnOYcAhl8XQddiPf/vBLuvzi
         7Fc5FBoOF91NS9LoYpa6bZu3udm3yU3kKKwkuj+QQfeVh1Ybo6iPAQZghxrFEd13MMMK
         mZI//5Nv4wNKUwjpJie+V+M+ej7vS7SIOQ90yCwgIQ3qVUbPYPKFZ5eIWMhFJ6TgxXUF
         Bqj4s9i/QoNJMl5gnqODyE925GE9ghdECkgB0BAVYItzOgxpuKCyYIJhAp5FxzFohvWD
         x1e/HuUr4K3ZRa5drc5kNC5QqxoAZnmqtm6P0nMyuoY+OvXTll3iomyXq4Q45+L4Kcwx
         ra6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=XlESMETMrSEuJH96+KdMckQf3t/JsW6LWGQZfXlvWP4=;
        b=RAMVy+Za8C4mnUWIyD7pf1BP6enZ2VK15KP4a9lUVpCa+pdqCFqGs3to6OrXBalryX
         UNMmszjNoiTereRUFc2tlpGOzn9/itgU7BUawB2H8IW/JazICzB2WKOPHTVm4qtLDOsL
         BMep/Ha+u7G8TpQ22yKJ4YOTc6GsAQNCiycLPoUGpRtoOBa/U1SOV66rhp35hmkcq83q
         ewPsjAmS9MxOKhq4m0llencdv+NK41AJAbj22M1a7cxLNZgBIVp75tPQn91muy2lLVR2
         x+EW6uAA5I3arsf9QqR9kE/FqQhu3UYv3rcss8k99XigXHKYuImS5euSFBYoTNZwybuT
         TQ3A==
X-Gm-Message-State: AOAM533iZ0He5b7LSkKlN6Vo2OuiU9QSn52sCmB1R4JD4Z/oayvMqrB3
	0Vs6FT//wa95/TYKjGUiVTJ7dQ==
X-Google-Smtp-Source: ABdhPJxE95QO975NyM+0SD4OwKsvBLc9dJGgMa1x8gghaXoKrvqFr+Dtepl0hNvJBrHpTjWACP7GEA==
X-Received: by 2002:a17:90a:c781:: with SMTP id gn1mr1647479pjb.151.1598919322304;
        Mon, 31 Aug 2020 17:15:22 -0700 (PDT)
Date: Mon, 31 Aug 2020 18:15:19 -0600
From: Tycho Andersen <tycho@tycho.ws>
To: Kees Cook <keescook@chromium.org>, "Tobin C. Harding" <me@tobin.cc>
Cc: Solar Designer <solar@openwall.com>,
	kernel-hardening@lists.openwall.com,
	Mrinal Pandey <mrinalmni@gmail.com>,
	Tycho Andersen <tycho@tycho.pizza>
Subject: Re: [PATCH] scripts: Add intended executable mode and SPDX license
Message-ID: <20200901001519.GA567924@cisco>
References: <20200827092405.b6hymjxufn2nvgml@mrinalpandey>
 <20200827130653.GA25408@openwall.com>
 <202008271056.8B4B59C9@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202008271056.8B4B59C9@keescook>

On Thu, Aug 27, 2020 at 11:02:00AM -0700, Kees Cook wrote:
> On Thu, Aug 27, 2020 at 03:06:53PM +0200, Solar Designer wrote:
> > On Thu, Aug 27, 2020 at 02:54:05PM +0530, Mrinal Pandey wrote:
> > >  mode change 100644 => 100755 scripts/gcc-plugins/gen-random-seed.sh
> > 
> > This is basically the only change relevant to the contribution initially
> > made via kernel-hardening, and in my opinion (and I am list admin) isn't
> > worth bringing to the list.  Now we have this bikeshed thread in here
> > (and I'm guilty for adding to it), and would have more (which I hope
> > this message of mine will prevent) if changes to something else in the
> > patch(es) are requested (which Greg KH sort of already did).
> > 
> > I recall we previously had lots of "similar" bikeshedding in here when
> > someone was converting the documentation to rST.  The more bikeshedding
> > we have, the less actual kernel-hardening work is going to happen,
> > because the list gets the reputation of yet another kernel maintenance
> > list rather than the place where actual/potential new contributions to
> > improve the kernel's security are discussed, and because bikeshedding
> > makes the most capable people unsubscribe or stop paying attention.
> > 
> > How about we remove kernel-hardening from the MAINTAINERS entries it's
> > currently in? -
> > 
> > GCC PLUGINS
> > M:      Kees Cook <keescook@chromium.org>
> > R:      Emese Revfy <re.emese@gmail.com>
> > L:      kernel-hardening@lists.openwall.com
> > S:      Maintained
> > F:      Documentation/kbuild/gcc-plugins.rst
> > F:      scripts/Makefile.gcc-plugins
> > F:      scripts/gcc-plugin.sh
> > F:      scripts/gcc-plugins/
> > 
> > LEAKING_ADDRESSES
> > M:      Tobin C. Harding <me@tobin.cc>
> > M:      Tycho Andersen <tycho@tycho.ws>
> > L:      kernel-hardening@lists.openwall.com
> > S:      Maintained
> > T:      git git://git.kernel.org/pub/scm/linux/kernel/git/tobin/leaks.git
> > F:      scripts/leaking_addresses.pl
> > 
> > Alternatively, would this be acceptable? -
> > 
> > L:      kernel-hardening@lists.openwall.com (only for messages focused on core functionality, not for maintenance detail)
> > 
> > I think the latter would be best, if allowed.
> > 
> > Kees, please comment (so that we'd hopefully not need that next time),
> > and if you agree please make a change to MAINTAINERS.
> 
> A comment isn't going to really help fix this (much of the CCing is done
> by scripts, etc).
> 
> I've tended to prefer more emails than missing discussions, and I think
> it's not unreasonable to have the list mentioned in MAINTAINERS for
> those things. It does, of course, mean that "maintenance" patches get
> directed there too, as you say.
> 
> If it's really something you'd like to avoid, I can drop those
> references. My instinct is to leave it as-is, but the strength of my
> opinion is pretty small. Let me know what you prefer...

One thing about leaking_addresses.pl is that I'm not sure anyone is
actively using it at this point. I told Tobin I'd help review stuff,
but I don't even have a GPG key with enough signatures to send PRs.
I'm slowly working on figuring that out, but in the meantime I wonder
if we couldn't move it into some self test somehow, so that at least
nobody adds new leaks? Does that seem worth doing?

It would then probably go away as a separate perl script and live
under selftests, which could mean we could drop the reference to the
list. But that's me making it someone else's problem then, kind of :)

Also, I'm switching my e-mail address to tycho@tycho.pizza, so future
replies will be from there.

Tycho
