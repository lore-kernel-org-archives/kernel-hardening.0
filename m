Return-Path: <SRS0=z1Ne=DH=lists.openwall.com=kernel-hardening-return-20064-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A1BEC4727F
	for <kernel-hardening@archiver.kernel.org>; Wed, 30 Sep 2020 09:12:42 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0080D2071E
	for <kernel-hardening@archiver.kernel.org>; Wed, 30 Sep 2020 09:12:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0080D2071E
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=openwall.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20064-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 2024 invoked by uid 550); 30 Sep 2020 09:12:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 31945 invoked from network); 30 Sep 2020 09:02:36 -0000
Date: Wed, 30 Sep 2020 11:02:32 +0200
From: Solar Designer <solar@openwall.com>
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, linux-hardening@vger.kernel.org
Subject: Re: Linux-specific kernel hardening
Message-ID: <20200930090232.GA5067@openwall.com>
References: <202009281907.946FBE7B@keescook> <20200929192517.GA2718@openwall.com> <202009291558.04F4D35@keescook>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202009291558.04F4D35@keescook>
User-Agent: Mutt/1.4.2.3i

On Tue, Sep 29, 2020 at 04:41:45PM -0700, Kees Cook wrote:
> On Tue, Sep 29, 2020 at 09:25:17PM +0200, Solar Designer wrote:
> > On Tue, Sep 29, 2020 at 10:14:03AM -0700, Kees Cook wrote:
> > > New topics and on-going work will be discussed there, and I urge
> > > anyone interested in Linux kernel hardening to join the new list. It's
> > > my intention that all future upstream work can be CCed there, following
> > > the standard conventions of the Linux development model, for better or
> > > worse. ;)
> > > 
> > > For anyone discussing new topics or ideas, please continue to CC
> > > kernel-hardening too, as there will likely be many people only subscribed
> > > there. Hopefully this will get the desired split of topics between the
> > > two lists.
> > 
> > I find this confusing.  Given that "new topics and on-going work will be
> > discussed" on the new linux-hardening list, what's left for the old
> > kernel-hardening list?  Just a legacy list to be CC'ed because people
> 
> My intention is to allow for linux-hardening@ to be the defacto place
> for upstream Linux kernel hardening work. (And I include "upstream"
> there again intentionally, and "work", which is larger than just
> discussing new features.) Such a place must exist for the mechanical
> and social processes inherent in the Linux kernel development model to
> operate. Something needs to be listed in the MAINTAINERS file, and tools
> direct email delivery much more commonly than individuals.
> 
> Since it is not part of the established Linux development processes to
> _remove_ lists from CC when they're part of the maintainership chain or
> git history, it's simply not possible for kernel-hardening@ to serve in
> that role, given the constraints on topic applicability.

We could simply keep the constraints relaxed as necessary.  I didn't
even suggest removing the list from CC on messages sent per git history;
in fact, I don't recall that ever resulting in undesirable messages in
here.  I merely suggested removing the list from the MAINTAINERS file.
I don't see why that couldn't simply be done, but I didn't insist.  What
you're doing now is far worse than keeping the list in MAINTAINERS or
removing it from there, in my opinion.

> For stuff that IS a new topic, where people are explicitly choosing
> what lists to send to, CCing both linux-hardening@ and kernel-hardening@
> seems like the right thing to do to get that topic split.

I think this will most likely result in one of 3 things:

1. 90%+ of messages CC'ed to both lists.

2. Topics arbitrarily limited to just one of the two lists, with no
clear separation on what goes where, and some CC'ed to both lists.

3. Everything staying on/moving to just one of the two lists eventually,
after struggling with 1 or 2 above for a while.

It'll be really hard (almost unrealistic) for us to arrive at a
reasonable topic split between the lists now.  Moreover, I don't know of
such reasonable split even if we could somehow make it happen.

> > are still subscribed to it?  If so, it looks like basically because of
> > my concern about a minor issue you chose to move the list from one place
> > to another without actually addressing my concern in any way but causing
> > lots of inconvenience.  That would be weird, so I hope I misunderstand.
> 
> I don't think the Linux kernel's (email) development model is compatible
> with having a "strictly on-topic" mailing list as part of the standard
> process. Your concerns are perfectly valid, but just not something that
> I see a way to solving without significant effort (e.g. making the list
> entirely moderated, etc).

Removing the list from the MAINTAINERS file (maybe replacing it with the
new list as you suggest) wouldn't be significant effort.  If that is
somehow not suitable, we can live with the occasional noise that brings.

My concerns were not related to Openwall hosting the list.  They were
related to well-being of KSPP, no matter where the list is hosted.  So
by moving the list you have not addressed my concerns at all.  You've
only made things far worse.

> And moderation is actually another aspect of
> the desire to move; emails are regularly auto-moderated which just
> creates more manual work (for both of us).

Messages that are auto-approved don't create any work for either of us,
and that's the majority of them.  Messages that are held for moderation
(until I add the sender to moderation bypass) do involve some work, but
that's the only way to avoid spam on the list.  I think that amount of
work is small compared to all subscribers' time wasted on occasional
spam on the list.  If it's unacceptable for you, I can remove you from
list moderators and maybe add someone else as a co-moderator.  I think
it wouldn't be hard for us to find a volunteer.  Please let me know.

Besides, the split doesn't solve this problem for kernel-hardening@.

> > To me, "new topics" are certainly desirable on kernel-hardening.  Ditto
> > for "on-going work" as long as it's work on kernel hardening per se
> > (patch review, etc.) rather than e.g. documentation formatting fixes for
> > former kernel hardening changes that are already accepted upstream and
> > are only CC'ed here because of a formality (link from MAINTAINERS)
> > rather than anyone's well-reasoned decision.
> 
> I don't want myself or anyone else to have to worry about where the line
> is drawn. If kernel-hardening@ is on CC for new topics, we're all good.
> With the MAINTAINERS file updated, and a .mailmap entry added to redirect
> kernel-hardening@ to linux-hardening@, all the "mechanical" threads will
> avoid kernel-hardening@, and we'll be close to what will work best for
> the topic split.

OK, let's hope this will work, although I doubt it and I don't know what
topic split is desirable.

> > I suggested that a small minority of messages on kernel-hardening be
> > removed from here.  You're effectively replacing one list with another,
> > or if that's not what you're doing then you haven't described it well,
> > and I wouldn't expect to "get the desired split of topics".
> 
> I understand what you mean, but I think the effort required to remove
> those messages is too high. As an upstream Linux kernel maintainer, I
> have different constraints on how I need a development discussion list
> to operate. In the quoted thread[2] from earlier, I explained (perhaps
> badly) those constraints, and you disagreed and additionally said
> further discussion would hinder kernel-hardening@. It's your list and
> list server, so I obviously can't make you agree to operate it the way
> Linux kernel development lists are expected to work, so I didn't really
> have any other choice but to start a new list.

That's a major misunderstanding.  I cared primarily about the well-being
of KSPP, and not so much about hosting/administering a list with a
policy I disagree with in a minor way, which I accepted.  I didn't want
to continue that discussion "for very long" as it "hurts actual work",
not because I disagreed with you (although I did) and insisted on that
deciding list policy (I did not, and it did not).  BTW, now we're having
another such discussion that hurts actual work, so I am also not going
to continue it for very long.

If you didn't want to add to a thread given my comment about it hurting,
you could always e-mail me off-list, and I'd tell you that you certainly
did have other choices.

> I recognize you've made a
> lot of changes over the past several years (e.g. Subject prefixes, etc)
> to adapt to those norms, but the list's acceptable "range of discussion"
> seemed like a pretty fundamental difference that was unlikely to be
> easily solved with a single list.

Fair enough, although I only suggested excluding CC's resulting from
MAINTAINERS, which didn't feel fundamental enough to insist on it (so I
did not), let alone to split the list in two.

> > Then there's also the lists' naming and the Subject on this message.
> > Are you suggesting that the kernel-hardening list be used for kernel
> > hardening that is not Linux specific?  That would be a reuse of an
> 
> The better distinction is between upstream and not. Another aspect driving
> this change is the belief by people that the Linux Kernel Self-Protection
> Project is somehow not upstream, which I think is somewhat reinforced
> by the mailing list not living on vger.kernel.org. It's hardly a strong
> enough reason to move (much like the auto-moderation hassles), but when
> all are combined, I found the move sufficiently justified.

Actually, that feels like the only valid reason to me.

> > abandoned list, if it would be, but I don't know whether there's demand
> > for that and it's probably incompatible with continuing to CC the list
> > on Linux-specific topics and it might not be well-received by all
> > current subscribers who assumed it was a Linux list, which it was.
> 
> Agreed, I should have said "upstream-specific" in the Subject. That was
> not clear there.

So your suggested use of kernel-hardening@ is for discussions of Linux
kernel hardening projects or work-in-progress that isn't to be submitted
upstream or isn't yet submitted upstream.  If, and as soon as, a patch
series is sent upstream, that should go on the new linux-hardening@
list?  And only in there or also CC'ed to kernel-hardening@?  I'm just
trying to understand.

> Hopefully this clears things up. I'm fundamentally seeking less
> work/irritation for both of us, as well as for the folks doing upstream
> work who find themselves CCing a development mailing list, and the folks
> who want to just see the discussion of new features.

I currently don't expect this to work well, but let's see.

> > [2] https://lore.kernel.org/kernel-hardening/20200902121604.GA10684@openwall.com/

Alexander
