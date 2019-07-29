Return-Path: <SRS0=hq9T=V2=lists.openwall.com=kernel-hardening-return-16619-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73765C7618B
	for <kernel-hardening@archiver.kernel.org>; Mon, 29 Jul 2019 16:51:26 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C3B28206A2
	for <kernel-hardening@archiver.kernel.org>; Mon, 29 Jul 2019 16:51:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="eEZM3QuE"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org C3B28206A2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16619-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7654 invoked by uid 550); 29 Jul 2019 16:51:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7632 invoked from network); 29 Jul 2019 16:51:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=aoG/CujPMfUNVlv4vKQLSR0pGlxHql1vt1xZ+SM2evU=;
        b=eEZM3QuEtJ4JN4mdaj3YgffjMFlESFvZpNvVSBcO8QjQXXQKXPwrx7oRmFKdAFTv4O
         e6RMip7uGYfZRrmSxbKwzN3jKE4oPiG8D2pbJVibHbEQZSrsU0IkrOey1LwO4ytEt5eV
         z+gXkKTFPBu2RM4tpLhAffP4/wgkBIsBwtriU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=aoG/CujPMfUNVlv4vKQLSR0pGlxHql1vt1xZ+SM2evU=;
        b=MxzGHRyUF0O1PB/ltZVyxrWyNUwKzm+EJuwbXoWFJjRuEN0SrHIR/+zxr7mDlzWWLv
         FrOvUQON8uRETwN3TR/cau+U61VCf0GTj9WsLc1064CnxNRJN0NVS438BAPHqEKe38gh
         pJ0eR4cytjHgslXqCEBYcbs8+KFq73LVNpXxUow/F4PlioAykLLyZqPWTlVxOJyMKso+
         iSYqU6AWY8hjf/1pTokGB8eqRb2CgKniaPyEPYoBqyFjNYbrOffU6XNg90kJB6iClq3+
         3zflJOhHGAkJORGzCXBO4ntSFv9mAPvGZv3cDSvu8s6RvwwysrNg2VqzTJO46HBtT+iL
         /59w==
X-Gm-Message-State: APjAAAUPROj8xPsTwKlpfuN7phUwQeCmtYJz/eF5hBssGm8bbqfiwgrC
	AzIj226DF6lxM9GAvP55oDqllA==
X-Google-Smtp-Source: APXvYqypNtAKQJZGTSkV39u4c7GLeVZyMUhrP0VaoGlM65upiz6NEPGMAURh5q4KoDvXmPMGybRvRQ==
X-Received: by 2002:aa7:9713:: with SMTP id a19mr19643019pfg.64.1564419066457;
        Mon, 29 Jul 2019 09:51:06 -0700 (PDT)
Date: Mon, 29 Jul 2019 09:51:04 -0700
From: Kees Cook <keescook@chromium.org>
To: Jann Horn <jannh@google.com>
Cc: Ondrej Mosnacek <omosnace@redhat.com>,
	NitinGote <nitin.r.gote@intel.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Paul Moore <paul@paul-moore.com>,
	Stephen Smalley <sds@tycho.nsa.gov>,
	Eric Paris <eparis@parisplace.org>,
	SElinux list <selinux@vger.kernel.org>,
	Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] selinux: convert struct sidtab count to refcount_t
Message-ID: <201907290949.D08EC0379C@keescook>
References: <20190722113151.1584-1-nitin.r.gote@intel.com>
 <CAFqZXNs5vdQwoy2k=_XLiGRdyZCL=n8as6aL01Dw-U62amFREA@mail.gmail.com>
 <CAG48ez3zRoB7awMdb-koKYJyfP9WifTLevxLxLHioLhH=itZ-A@mail.gmail.com>
 <201907231516.11DB47AA@keescook>
 <CAG48ez2eXJwE+vS2_ahR9Vuc3qD8O4CDZ5Lh6DcrrOq+7VKOYQ@mail.gmail.com>
 <201907240852.6D10622B2@keescook>
 <CAG48ez3-qdbnJaEooFrhfBT8czyAZNDp5YfkDRcy5mLH4BQy2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez3-qdbnJaEooFrhfBT8czyAZNDp5YfkDRcy5mLH4BQy2g@mail.gmail.com>

On Wed, Jul 24, 2019 at 06:55:47PM +0200, Jann Horn wrote:
> (Accurate) statistics counters need RMW ops, don't need memory
> ordering, usually can't be locked against writes, and may not care
> about wrapping.
> This thing doesn't need RMW ops, does need memory ordering, can be
> locked against writes, and definitely shouldn't wrap.
> 
> I agree that there are a bunch of statistics counters in the kernel,
> and it's not necessarily a bad idea to use a separate type for them;
> but this is not a statistics counter.

Right, yes, I didn't meant to suggest it should be. I was just bringing
up the "counter type" idea again, since it was on my mind here
originally.

-- 
Kees Cook
