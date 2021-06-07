Return-Path: <SRS0=G+5U=LB=lists.openwall.com=kernel-hardening-return-21287-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2D2BC47094
	for <kernel-hardening@archiver.kernel.org>; Mon,  7 Jun 2021 10:28:45 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id F2CC8611AD
	for <kernel-hardening@archiver.kernel.org>; Mon,  7 Jun 2021 10:28:44 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F2CC8611AD
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21287-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21967 invoked by uid 550); 7 Jun 2021 10:28:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21929 invoked from network); 7 Jun 2021 10:28:38 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZfkBsIz55tc2TjLqFxmc/bAmxwRHg1Mbcf6YmSgMAxk=;
        b=mCku7nEhc36iPXmaV5ZpqwDlklutay5KPg6iqsqZxq2CokVccbmE+mUuengvI2Dpsi
         dl1Y91MQ2JtefEGi0EW1mF2TxcfO8A0MFI9Le4owGdL9ocR4It1icWtO/uXO00MUnK4x
         seD41HcQJyxmQVtjryLCfyOGuwvne6gmjvUH16F7f8DjeudkrlCYS9NGryxxJXsfeWjj
         Qs258WegfSalZ30nctr0kz07eIS7+fgayFMx3uZoQQFemq7xk7WUvxpufggYWlJkhWkC
         +qY2ArocvPnjf8rD4IfpXe8vES+5M+eZnJz8p4zQ4rA+wihc3zbxaFvWyrl3czt9UP0Z
         z+QQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZfkBsIz55tc2TjLqFxmc/bAmxwRHg1Mbcf6YmSgMAxk=;
        b=W+WpskHTsburtcewTY6nzICj0HRBeR84wnd1GSdK7AG+0XxXH31UbRIPD+rHNrQdbp
         ddShHjIirPt9g4uijvPGx27mTNI+FhIL2SUakEwhvjFPOkq+kIL/xo5PGHBAOUVEqwf0
         JMz5C8dPGJok8ApFvLZfgo7YduuCSQQg3JgJmlChN4B9ERsAfN43A0prXO+OyU7HLO4c
         NlDwolzqtqEGsDEJklU+LWAcS7UwDl/Ds6vXA4jn7v20SvBfpGBTWBKFoM/sSV/ioB7L
         c8fWGL5pH+xwdXD3gsloZ953IHVL5mUDNV2iAerI6F1tE+0GhgWTJnKVIzWgWPAFYEyq
         nYkg==
X-Gm-Message-State: AOAM530BVN8HjyCN83L+NvNbCGKs4KB67wvdkhRY7RgS3kcFQvL0FyXR
	fKBW8Wl2IxzVy3eiqRvyjFlyz8dp9Nniko1zjxgjaQ==
X-Google-Smtp-Source: ABdhPJyrBYoegPp/hlN/HNK4Ga/7kDespCvl6zt6t9y4843+ugPo0yOhcUJ/bNsMmCY/lhd7y9Zjdv/FNvqe+GRQTvE=
X-Received: by 2002:a0c:d610:: with SMTP id c16mr17480702qvj.13.1623061705667;
 Mon, 07 Jun 2021 03:28:25 -0700 (PDT)
MIME-Version: 1.0
References: <000000000000adea7f05abeb19cf@google.com> <2fb47714-551c-f44b-efe2-c6708749d03f@gmail.com>
 <YL3zGGMRwmD7fNK+@zx2c4.com>
In-Reply-To: <YL3zGGMRwmD7fNK+@zx2c4.com>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Mon, 7 Jun 2021 12:28:14 +0200
Message-ID: <CACT4Y+bcxROH6+xCpf4fn0dUggEqhrngkmo8-7vrdaJULYhD-w@mail.gmail.com>
Subject: Re: KASAN: use-after-free Read in hci_chan_del
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: SyzScope <syzscope@gmail.com>, 
	syzbot <syzbot+305a91e025a73e4fd6ce@syzkaller.appspotmail.com>, 
	David Miller <davem@davemloft.net>, Johan Hedberg <johan.hedberg@gmail.com>, 
	Jakub Kicinski <kuba@kernel.org>, linux-bluetooth <linux-bluetooth@vger.kernel.org>, 
	LKML <linux-kernel@vger.kernel.org>, Marcel Holtmann <marcel@holtmann.org>, 
	netdev <netdev@vger.kernel.org>, syzkaller-bugs <syzkaller-bugs@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

On Mon, Jun 7, 2021 at 12:21 PM Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hi SyzScope,
>
> On Fri, May 28, 2021 at 02:12:01PM -0700, SyzScope wrote:
>
> > The bug was reported by syzbot first in Aug 2020. Since it remains
> > unpatched to this date, we have conducted some analysis to determine its
> > security impact and root causes, which hopefully can help with the
> > patching decisions.
> > Specifically, we find that even though it is labeled as "UAF read" by
> > syzbot, it can in fact lead to double free and control flow hijacking as
> > well. Here is our analysis below (on this kernel version:
> > https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/log/?id=af5043c89a8ef6b6949a245fff355a552eaed240)
> >
> > ----------------------------- Root cause analysis:
> > --------------------------
> > The use-after-free bug happened because the object has two different
> > references. But when it was freed, only one reference was removed,
> > allowing the other reference to be used incorrectly.
> > [...]
>
> Thank you very much for your detailed analysis. I think this is very
> valuable work, and I appreciate you doing it. I wanted to jump in to
> this thread here so as not to discourage you, following Greg's hasty
> dismissal. The bad arguments made I've seen have been something like:
>
> - Who cares about the impact? Bugs are bugs and these should be fixed
>   regardless. Severity ratings are a waste of time.
> - Spend your time writing patches, not writing tools to discover
>   security issues.
> - This doesn't help my interns.
> - "research project" scare quotes.
>
> I think this entire set of argumentation is entirely bogus, and I really
> hope it doesn't dissuade you from continuing to conduct useful research
> on the kernel.
>
> Specifically, it sounds like your tool is scanning through syzbot
> reports, loading them into a symbolic execution engine, and seeing what
> other primitives you can finesse out of the bugs, all in an automated
> way. So, in the end, a developer gets a report that, rather than just
> saying "4 byte out of bounds read into all zeroed memory so not a big
> deal anyway even if it should be fixed," the developer gets a report
> that says, "4 byte out of bounds read, or a UaF if approached in this
> other way." Knowing that seems like very useful information, not just
> for prioritization, but also for the urgency at which patches might be
> deployed. For example, that's a meaningful distinction were that kind of
> bug found in core networking stack or in wifi or ethernet drivers. I
> also think it's great that you're pushing forward the field of automated
> vulnerability discovery and exploit writing. Over time, hopefully that
> leads to crushing all sorts of classes of bugs. It's also impressive
> that you're able to do so much with kernel code in a symbolic execution
> environment; this sounds a few steps beyond Angr ;-)...
>
> My one suggestion would be that your email alerts / follow-ups to syzbot
> reports, if automated, contain a bit more "dumbed-down" information
> about what's happening. Not all kernel developers speak security, and as
> you've seen, in some places it might be an uphill battle to have your
> contributions taken seriously. On the other hand, it sounds like you
> might already be working with Dmitry to integrate this into the
> syzkaller infrastructure itself, somehow? If so, that'd be great.

We discussed this with authors, but no integration work is happening
right now yet.
Yes, it would be useful for syzbot to do this assessment automatically
for all bugs and, say, tag bugs on the dashboard (less noisy then
sending separate emails). If/when syzbot sends, say, monthly
per-subsystem summary, that priority info could also be included
there.
