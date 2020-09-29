Return-Path: <SRS0=Ibhg=DG=lists.openwall.com=kernel-hardening-return-20060-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 387FEC4727C
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 23:42:11 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7C93C20773
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 23:42:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="EkRtlnWr"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7C93C20773
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20060-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19581 invoked by uid 550); 29 Sep 2020 23:42:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19523 invoked from network); 29 Sep 2020 23:42:00 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dP8I9oyL7TEPrbaEo1IUtt5BofPuI3wthx4WkN4QjrU=;
        b=EkRtlnWrQNgl+R79TCEqwzwX1+mB5/VOtBZOhMyWjDGtmx/59qKQMgPd/tFb5fBK0g
         ld+kzOYXAYEjG1Wo2G2uVkk1ZNNXNn1N/tPunUMHsDoppbrXI0sp5Jf5rS4x/Z7CC69Z
         Wc0tPiO5FViqbkvpZds8DO5KFSSAcmzJT1dhw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dP8I9oyL7TEPrbaEo1IUtt5BofPuI3wthx4WkN4QjrU=;
        b=ITl5S2LqsQf1oniOZ6kQDdZzeRlEd9Tb+Sa5jl/U4E3i3RFRkABGMXaInErQ7DU4WJ
         lX5O4hIMo1xg1jEWFhjpRbsj5DzzoWOi948KNuA+7Drn09h/e6/WHkf9UXjbEQ3nQHs8
         sehFLKnySwDfWpV6VeGbhgAuRBu+ynVSwpXmtT+r6LDCs2kVnT3AY8K21kVsbbjW9lit
         GKQHbI44o00S6eu196NgRqa7votriXH+GKx+dNXcE3ODpFQR1gkmtOs85SCvIaWg4JCV
         30DrPq4lCVdskAzZ4zXzQ2fl5OA5jpAPBtWLGGoPGeuk6vdIhplhgwIEWsdVQgYqxtzX
         1m3w==
X-Gm-Message-State: AOAM533PrJ7fj7+GwJqC1LzxzeWAAZliTp2dPNnlMs7ui6kwNLSwGJ8k
	wJaoq1dzc5NtcXyW1Z/UkAR/MjWtJRIs1ULy
X-Google-Smtp-Source: ABdhPJweioQXF7DB3cNF+Nuo1vdvnCLB0r7/Z7nSyH4ZlW1lj8CADieMNwMg7kmhCNi3Eqq4nVIRQw==
X-Received: by 2002:a17:90b:198c:: with SMTP id mv12mr33129pjb.236.1601422907813;
        Tue, 29 Sep 2020 16:41:47 -0700 (PDT)
Date: Tue, 29 Sep 2020 16:41:45 -0700
From: Kees Cook <keescook@chromium.org>
To: Solar Designer <solar@openwall.com>
Cc: kernel-hardening@lists.openwall.com, linux-hardening@vger.kernel.org
Subject: Re: Linux-specific kernel hardening
Message-ID: <202009291558.04F4D35@keescook>
References: <202009281907.946FBE7B@keescook>
 <20200929192517.GA2718@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200929192517.GA2718@openwall.com>

On Tue, Sep 29, 2020 at 09:25:17PM +0200, Solar Designer wrote:
> On Tue, Sep 29, 2020 at 10:14:03AM -0700, Kees Cook wrote:
> > New topics and on-going work will be discussed there, and I urge
> > anyone interested in Linux kernel hardening to join the new list. It's
> > my intention that all future upstream work can be CCed there, following
> > the standard conventions of the Linux development model, for better or
> > worse. ;)
> > 
> > For anyone discussing new topics or ideas, please continue to CC
> > kernel-hardening too, as there will likely be many people only subscribed
> > there. Hopefully this will get the desired split of topics between the
> > two lists.
> 
> I find this confusing.  Given that "new topics and on-going work will be
> discussed" on the new linux-hardening list, what's left for the old
> kernel-hardening list?  Just a legacy list to be CC'ed because people

My intention is to allow for linux-hardening@ to be the defacto place
for upstream Linux kernel hardening work. (And I include "upstream"
there again intentionally, and "work", which is larger than just
discussing new features.) Such a place must exist for the mechanical
and social processes inherent in the Linux kernel development model to
operate. Something needs to be listed in the MAINTAINERS file, and tools
direct email delivery much more commonly than individuals.

Since it is not part of the established Linux development processes to
_remove_ lists from CC when they're part of the maintainership chain or
git history, it's simply not possible for kernel-hardening@ to serve in
that role, given the constraints on topic applicability.

For stuff that IS a new topic, where people are explicitly choosing
what lists to send to, CCing both linux-hardening@ and kernel-hardening@
seems like the right thing to do to get that topic split.

> are still subscribed to it?  If so, it looks like basically because of
> my concern about a minor issue you chose to move the list from one place
> to another without actually addressing my concern in any way but causing
> lots of inconvenience.  That would be weird, so I hope I misunderstand.

I don't think the Linux kernel's (email) development model is compatible
with having a "strictly on-topic" mailing list as part of the standard
process. Your concerns are perfectly valid, but just not something that
I see a way to solving without significant effort (e.g. making the list
entirely moderated, etc). And moderation is actually another aspect of
the desire to move; emails are regularly auto-moderated which just
creates more manual work (for both of us).

> To me, "new topics" are certainly desirable on kernel-hardening.  Ditto
> for "on-going work" as long as it's work on kernel hardening per se
> (patch review, etc.) rather than e.g. documentation formatting fixes for
> former kernel hardening changes that are already accepted upstream and
> are only CC'ed here because of a formality (link from MAINTAINERS)
> rather than anyone's well-reasoned decision.

I don't want myself or anyone else to have to worry about where the line
is drawn. If kernel-hardening@ is on CC for new topics, we're all good.
With the MAINTAINERS file updated, and a .mailmap entry added to redirect
kernel-hardening@ to linux-hardening@, all the "mechanical" threads will
avoid kernel-hardening@, and we'll be close to what will work best for
the topic split.

> I suggested that a small minority of messages on kernel-hardening be
> removed from here.  You're effectively replacing one list with another,
> or if that's not what you're doing then you haven't described it well,
> and I wouldn't expect to "get the desired split of topics".

I understand what you mean, but I think the effort required to remove
those messages is too high. As an upstream Linux kernel maintainer, I
have different constraints on how I need a development discussion list
to operate. In the quoted thread[2] from earlier, I explained (perhaps
badly) those constraints, and you disagreed and additionally said
further discussion would hinder kernel-hardening@. It's your list and
list server, so I obviously can't make you agree to operate it the way
Linux kernel development lists are expected to work, so I didn't really
have any other choice but to start a new list. I recognize you've made a
lot of changes over the past several years (e.g. Subject prefixes, etc)
to adapt to those norms, but the list's acceptable "range of discussion"
seemed like a pretty fundamental difference that was unlikely to be
easily solved with a single list.

> Then there's also the lists' naming and the Subject on this message.
> Are you suggesting that the kernel-hardening list be used for kernel
> hardening that is not Linux specific?  That would be a reuse of an

The better distinction is between upstream and not. Another aspect driving
this change is the belief by people that the Linux Kernel Self-Protection
Project is somehow not upstream, which I think is somewhat reinforced
by the mailing list not living on vger.kernel.org. It's hardly a strong
enough reason to move (much like the auto-moderation hassles), but when
all are combined, I found the move sufficiently justified.

> abandoned list, if it would be, but I don't know whether there's demand
> for that and it's probably incompatible with continuing to CC the list
> on Linux-specific topics and it might not be well-received by all
> current subscribers who assumed it was a Linux list, which it was.

Agreed, I should have said "upstream-specific" in the Subject. That was
not clear there.

Hopefully this clears things up. I'm fundamentally seeking less
work/irritation for both of us, as well as for the folks doing upstream
work who find themselves CCing a development mailing list, and the folks
who want to just see the discussion of new features.

-Kees

> [2] https://lore.kernel.org/kernel-hardening/20200902121604.GA10684@openwall.com/

-- 
Kees Cook
