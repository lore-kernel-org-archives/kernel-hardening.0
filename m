Return-Path: <SRS0=/GEo=CF=lists.openwall.com=kernel-hardening-return-19707-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD980C433E1
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Aug 2020 18:02:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 1825C2087C
	for <kernel-hardening@archiver.kernel.org>; Thu, 27 Aug 2020 18:02:23 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Mb9d0EXH"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1825C2087C
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19707-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26468 invoked by uid 550); 27 Aug 2020 18:02:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26432 invoked from network); 27 Aug 2020 18:02:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=sgHpcLkcEnma5Hp6Mj3xRZNlMSEAg/shzlRQ+twt1iA=;
        b=Mb9d0EXHcqiVMSSmMuCj7b4tinofnbJ4SxUth/kYBrFUBYA9jWxI5xfZZXHO7PfV85
         ADwT5MpK1OPAFyfuzwWXuzG5i+cEa7gGxbA/ASrbRN/OOKkftYuWXwLveesmHUv3hNcY
         ke+hRspgyaqxb3DUZLdCmuLhScVTbgp0/vcRc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=sgHpcLkcEnma5Hp6Mj3xRZNlMSEAg/shzlRQ+twt1iA=;
        b=O1Vl9OcjVh7fPucIpbz5S86I6WplCGxieTY5AF8nApVDtIfWo2X1rSGDVHt2o2UB4m
         SZLQCjPJw8hKfd8lc1xDns4Y3moVvxSaTSi9UF1T4cqu8VxC9ThypJZVukSLZDjNdnvA
         6n9iiehvVBuyu5udYeM8dQ9X+v8sfnSyIm0XuUkn4fmIIJ8winSFWSnJnQbMICv/pOjO
         FavcIJhFETpi09+0qTHho9XVXxaxx59Gug8ywx4Qbjni2ZE4UqVgdjGTc8/SJNweETAX
         d0FL1HeusYeOSJ0y4XAyJsbA0SB+Ei6Xd38CaAanafqM84rBzcg06HicyPHFA5iRpRon
         J6eA==
X-Gm-Message-State: AOAM532ql3QrfWKZSMlzZQEtTFIs3J7bbYVIVOgQH6DQf+Eyw9BYCpXM
	LnyJwrZBcBg+Qs6oKRCi8G1sWQ==
X-Google-Smtp-Source: ABdhPJz9aKRxAYD5aD49pGytJWWye5v2oWOwOFa8uY1gxcF6pQ0GugJ7TRJTNykW9vcOTuVIYIEYAg==
X-Received: by 2002:a17:902:6bca:: with SMTP id m10mr17505435plt.210.1598551322485;
        Thu, 27 Aug 2020 11:02:02 -0700 (PDT)
Date: Thu, 27 Aug 2020 11:02:00 -0700
From: Kees Cook <keescook@chromium.org>
To: Solar Designer <solar@openwall.com>
Cc: kernel-hardening@lists.openwall.com,
	Mrinal Pandey <mrinalmni@gmail.com>
Subject: Re: [PATCH] scripts: Add intended executable mode and SPDX license
Message-ID: <202008271056.8B4B59C9@keescook>
References: <20200827092405.b6hymjxufn2nvgml@mrinalpandey>
 <20200827130653.GA25408@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200827130653.GA25408@openwall.com>

On Thu, Aug 27, 2020 at 03:06:53PM +0200, Solar Designer wrote:
> On Thu, Aug 27, 2020 at 02:54:05PM +0530, Mrinal Pandey wrote:
> >  mode change 100644 => 100755 scripts/gcc-plugins/gen-random-seed.sh
> 
> This is basically the only change relevant to the contribution initially
> made via kernel-hardening, and in my opinion (and I am list admin) isn't
> worth bringing to the list.  Now we have this bikeshed thread in here
> (and I'm guilty for adding to it), and would have more (which I hope
> this message of mine will prevent) if changes to something else in the
> patch(es) are requested (which Greg KH sort of already did).
> 
> I recall we previously had lots of "similar" bikeshedding in here when
> someone was converting the documentation to rST.  The more bikeshedding
> we have, the less actual kernel-hardening work is going to happen,
> because the list gets the reputation of yet another kernel maintenance
> list rather than the place where actual/potential new contributions to
> improve the kernel's security are discussed, and because bikeshedding
> makes the most capable people unsubscribe or stop paying attention.
> 
> How about we remove kernel-hardening from the MAINTAINERS entries it's
> currently in? -
> 
> GCC PLUGINS
> M:      Kees Cook <keescook@chromium.org>
> R:      Emese Revfy <re.emese@gmail.com>
> L:      kernel-hardening@lists.openwall.com
> S:      Maintained
> F:      Documentation/kbuild/gcc-plugins.rst
> F:      scripts/Makefile.gcc-plugins
> F:      scripts/gcc-plugin.sh
> F:      scripts/gcc-plugins/
> 
> LEAKING_ADDRESSES
> M:      Tobin C. Harding <me@tobin.cc>
> M:      Tycho Andersen <tycho@tycho.ws>
> L:      kernel-hardening@lists.openwall.com
> S:      Maintained
> T:      git git://git.kernel.org/pub/scm/linux/kernel/git/tobin/leaks.git
> F:      scripts/leaking_addresses.pl
> 
> Alternatively, would this be acceptable? -
> 
> L:      kernel-hardening@lists.openwall.com (only for messages focused on core functionality, not for maintenance detail)
> 
> I think the latter would be best, if allowed.
> 
> Kees, please comment (so that we'd hopefully not need that next time),
> and if you agree please make a change to MAINTAINERS.

A comment isn't going to really help fix this (much of the CCing is done
by scripts, etc).

I've tended to prefer more emails than missing discussions, and I think
it's not unreasonable to have the list mentioned in MAINTAINERS for
those things. It does, of course, mean that "maintenance" patches get
directed there too, as you say.

If it's really something you'd like to avoid, I can drop those
references. My instinct is to leave it as-is, but the strength of my
opinion is pretty small. Let me know what you prefer...

-- 
Kees Cook
