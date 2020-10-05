Return-Path: <SRS0=hgjd=DM=lists.openwall.com=kernel-hardening-return-20092-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 24433C4363A
	for <kernel-hardening@archiver.kernel.org>; Mon,  5 Oct 2020 16:03:20 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 40E4E206CB
	for <kernel-hardening@archiver.kernel.org>; Mon,  5 Oct 2020 16:03:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 40E4E206CB
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=mit.edu
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20092-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 21666 invoked by uid 550); 5 Oct 2020 16:03:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21631 invoked from network); 5 Oct 2020 16:03:09 -0000
Date: Mon, 5 Oct 2020 12:02:55 -0400
From: "Theodore Y. Ts'o" <tytso@mit.edu>
To: Solar Designer <solar@openwall.com>
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com,
        linux-hardening@vger.kernel.org
Subject: Re: Linux-specific kernel hardening
Message-ID: <20201005160255.GA4540@mit.edu>
References: <202009281907.946FBE7B@keescook>
 <20200929192517.GA2718@openwall.com>
 <202009291558.04F4D35@keescook>
 <20200930090232.GA5067@openwall.com>
 <20201005141456.GA6528@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005141456.GA6528@openwall.com>

On Mon, Oct 05, 2020 at 04:14:56PM +0200, Solar Designer wrote:
> > So your suggested use of kernel-hardening@ is for discussions of Linux
> > kernel hardening projects or work-in-progress that isn't to be submitted
> > upstream or isn't yet submitted upstream.  If, and as soon as, a patch
> > series is sent upstream, that should go on the new linux-hardening@
> > list?  And only in there or also CC'ed to kernel-hardening@?  I'm just
> > trying to understand.
> 
> We need you to comment on the above.  I hope you did have some idea of
> how the topics would be split between the two lists, but you haven't
> really specified that yet.  I tried to make guesses in the paragrapht
> above, so at least you need to confirm whether my guesses are correct,
> or correct me if they are not.

Perhaps this would be a helpful way of framing the issue.  The list
specified in the MAINTAINERS list is the one that is going to be
automatically returned by the scripts/get_maintainer_pl script.  This
gets used by kernel newbies who send things like white space fixes and
spelling corrections to said developer's list.  For most
vger.kernel.org lists, we mix high-level architectural discussions
with things like trivial patches.  It sounds like you don't want these
sorts of administrivia messages sent to the openwall list.  Is that
correct?

If that is true, it's not something that moderation will fix by
somewhere, but it that traffic needs to go *somewhere*.

> I see there are already a few threads on linux-hardening, and those are
> not CC'ed to kernel-hardening.  I am pleasantly surprised that those
> threads are about rather minor changes, which while acceptable to have
> on kernel-hardening as well IMO do not add much value to discussions
> desirable on kernel-hardening: "Replace one-element array with
> flexible-array member", "Use flex_array_size() helper", "Use
> array_size() helper", "Replace one-element array and save heap space",
> "Use fallthrough pseudo-keyword".

Exactly, that's the sort of thing that needs its own mailing list, and
moderation won't fix.

The challenge is whether we can get people to subscribe to two lists,
and redirect messages to the right list when the topic changes.
Sometimes what starts off as a seemingly trivial patch fix turns intot
an arhitectural discussion.  Expecting people to change the mailing
list name when the scope of the discussion changes is probably not
realistic --- not to mention that when such a change *does* happen,
there may be missing context that will be lost since the original
message started out on "administrivia" list.  (Which is why we
generally don't separate out those two buckets on the standard kernel
subsystem lists on vger.)

Cheers,

					- Ted
 
