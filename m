Return-Path: <SRS0=8GpG=DM=lists.openwall.com=kernel-hardening-return-20091-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D64AC4363A
	for <kernel-hardening@archiver.kernel.org>; Mon,  5 Oct 2020 14:16:17 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 73991205F4
	for <kernel-hardening@archiver.kernel.org>; Mon,  5 Oct 2020 14:16:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 73991205F4
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=openwall.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20091-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 6134 invoked by uid 550); 5 Oct 2020 14:16:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 5571 invoked from network); 5 Oct 2020 14:15:02 -0000
Date: Mon, 5 Oct 2020 16:14:56 +0200
From: Solar Designer <solar@openwall.com>
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, linux-hardening@vger.kernel.org
Subject: Re: Linux-specific kernel hardening
Message-ID: <20201005141456.GA6528@openwall.com>
References: <202009281907.946FBE7B@keescook> <20200929192517.GA2718@openwall.com> <202009291558.04F4D35@keescook> <20200930090232.GA5067@openwall.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200930090232.GA5067@openwall.com>
User-Agent: Mutt/1.4.2.3i

Hi Kees,

On Wed, Sep 30, 2020 at 11:02:32AM +0200, Solar Designer wrote:
> Messages that are auto-approved don't create any work for either of us,
> and that's the majority of them.  Messages that are held for moderation
> (until I add the sender to moderation bypass) do involve some work, but
> that's the only way to avoid spam on the list.  I think that amount of
> work is small compared to all subscribers' time wasted on occasional
> spam on the list.  If it's unacceptable for you, I can remove you from
> list moderators and maybe add someone else as a co-moderator.  I think
> it wouldn't be hard for us to find a volunteer.  Please let me know.

Someone has already volunteered.  I'd also like to hear from someone
possibly not as over-qualified and as busy as that person is. ;-)

Kees, if you'd like to step down as a co-moderator for kernel-hardening,
please let me know.  We'll add someone else (so that this doesn't depend
solely on me being around).

To avoid misinterpretation: I am not suggesting that you need to step
down, totally not.  I merely feel that you need to have the option since
you expressed unhappiness with having to spend effort on that.

> That's a major misunderstanding.  I cared primarily about the well-being
> of KSPP, and not so much about hosting/administering a list with a
> policy I disagree with in a minor way, which I accepted.  I didn't want
> to continue that discussion "for very long" as it "hurts actual work",
> not because I disagreed with you (although I did) and insisted on that
> deciding list policy (I did not, and it did not).  BTW, now we're having
> another such discussion that hurts actual work, so I am also not going
> to continue it for very long.

It is weird that I now feel I have to spell it out explicitly, but I do,
so: Kees, please don't use my saying that I don't want to continue this
bikeshed discussion "for very long" as an excuse for lack of
coordination on your part, again.  That's not a valid excuse, nor do you
need one.  You can always coordinate with me off-list if you prefer, but
I don't mind this thread continuing on the list for a little while.

> So your suggested use of kernel-hardening@ is for discussions of Linux
> kernel hardening projects or work-in-progress that isn't to be submitted
> upstream or isn't yet submitted upstream.  If, and as soon as, a patch
> series is sent upstream, that should go on the new linux-hardening@
> list?  And only in there or also CC'ed to kernel-hardening@?  I'm just
> trying to understand.

We need you to comment on the above.  I hope you did have some idea of
how the topics would be split between the two lists, but you haven't
really specified that yet.  I tried to make guesses in the paragraph
above, so at least you need to confirm whether my guesses are correct,
or correct me if they are not.

I see there are already a few threads on linux-hardening, and those are
not CC'ed to kernel-hardening.  I am pleasantly surprised that those
threads are about rather minor changes, which while acceptable to have
on kernel-hardening as well IMO do not add much value to discussions
desirable on kernel-hardening: "Replace one-element array with
flexible-array member", "Use flex_array_size() helper", "Use
array_size() helper", "Replace one-element array and save heap space",
"Use fallthrough pseudo-keyword".

I think topics more desirable on kernel-hardening would be deciding on
such replacements in general (not patches for individual instances),
introduction of such helpers, etc.  Also summaries of work done (e.g.,
"this-many instances of that-thing were updated to new conventions in
the kernel over the last month as discussed in those threads seen in
that list archive").  I use examples from the past because that's what
we have, but I use them to illustrate roughly what kinds of things we
could possibly have on one list vs. the other in the future.

Thanks,

Alexander
