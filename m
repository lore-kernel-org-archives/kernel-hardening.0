Return-Path: <SRS0=7cqP=CL=lists.openwall.com=kernel-hardening-return-19718-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B03EBC433E2
	for <kernel-hardening@archiver.kernel.org>; Wed,  2 Sep 2020 12:17:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 0736220767
	for <kernel-hardening@archiver.kernel.org>; Wed,  2 Sep 2020 12:17:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 0736220767
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=openwall.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19718-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 5364 invoked by uid 550); 2 Sep 2020 12:16:59 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3966 invoked from network); 2 Sep 2020 12:16:08 -0000
Date: Wed, 2 Sep 2020 14:16:05 +0200
From: Solar Designer <solar@openwall.com>
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Tycho Andersen <tycho@tycho.ws>, Kees Cook <keescook@chromium.org>,
	kernel-hardening@lists.openwall.com,
	Mrinal Pandey <mrinalmni@gmail.com>,
	Tycho Andersen <tycho@tycho.pizza>
Subject: Re: [PATCH] scripts: Add intended executable mode and SPDX license
Message-ID: <20200902121604.GA10684@openwall.com>
References: <20200827092405.b6hymjxufn2nvgml@mrinalpandey> <20200827130653.GA25408@openwall.com> <202008271056.8B4B59C9@keescook> <20200901001519.GA567924@cisco> <20200901042450.GA780@ares>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200901042450.GA780@ares>
User-Agent: Mutt/1.4.2.3i

On Tue, Sep 01, 2020 at 02:24:50PM +1000, Tobin C. Harding wrote:
> On Mon, Aug 31, 2020 at 06:15:19PM -0600, Tycho Andersen wrote:
> > On Thu, Aug 27, 2020 at 11:02:00AM -0700, Kees Cook wrote:
> > > On Thu, Aug 27, 2020 at 03:06:53PM +0200, Solar Designer wrote:
> > > > How about we remove kernel-hardening from the MAINTAINERS entries it's
> > > > currently in? -
> > > > 
> > > > GCC PLUGINS
> > > > M:      Kees Cook <keescook@chromium.org>
> > > > R:      Emese Revfy <re.emese@gmail.com>
> > > > L:      kernel-hardening@lists.openwall.com
> > > > S:      Maintained
> > > > F:      Documentation/kbuild/gcc-plugins.rst
> > > > F:      scripts/Makefile.gcc-plugins
> > > > F:      scripts/gcc-plugin.sh
> > > > F:      scripts/gcc-plugins/
> > > > 
> > > > LEAKING_ADDRESSES
> > > > M:      Tobin C. Harding <me@tobin.cc>
> > > > M:      Tycho Andersen <tycho@tycho.ws>
> > > > L:      kernel-hardening@lists.openwall.com
> > > > S:      Maintained
> > > > T:      git git://git.kernel.org/pub/scm/linux/kernel/git/tobin/leaks.git
> > > > F:      scripts/leaking_addresses.pl
> > > > 
> > > > Alternatively, would this be acceptable? -
> > > > 
> > > > L:      kernel-hardening@lists.openwall.com (only for messages focused on core functionality, not for maintenance detail)
> > > > 
> > > > I think the latter would be best, if allowed.
> > > > 
> > > > Kees, please comment (so that we'd hopefully not need that next time),
> > > > and if you agree please make a change to MAINTAINERS.
> > > 
> > > A comment isn't going to really help fix this (much of the CCing is done
> > > by scripts, etc).

Understood.  Maybe some other agreed-upon syntax would help - a new tag
letter in place of "L" and/or e-mail address obfuscation or an https URL
for further information instead of a direct posting address - but I
guess this is only worth introducing if we're not unique with this wish.

> > > I've tended to prefer more emails than missing discussions, and I think
> > > it's not unreasonable to have the list mentioned in MAINTAINERS for
> > > those things. It does, of course, mean that "maintenance" patches get
> > > directed there too, as you say.
> > > 
> > > If it's really something you'd like to avoid, I can drop those
> > > references. My instinct is to leave it as-is, but the strength of my
> > > opinion is pretty small. Let me know what you prefer...

Thank you for your comments, Kees.

It's not a matter of my preference, but of what works best for getting
more actual work done.  Unfortunately, we have to make our subjective
guesses on this.  FYI, when we dropped the [kernel-hardening] prefix on
Subjects this appears to have resulted in some people unsubscribing.
I agree we had to do that anyway because of CC'ing other lists, which
is customary in Linux kernel development.  Before that change, we had a
slow but steady growth in the number of subscribers.  When we made that
change, the numbers of people joining and leaving became about the same,
so we're staying at 600 to 650 subscribed addresses for a long time now.
These numbers are fine by themselves; it's more relevant who is on the
list, not how many.  I think we might have "forced" some capable people
to unsubscribe, but like I explained we kind of had to.  Now I think
we're doing the same with these maintenance-only threads, and I think we
don't have to.  This is why I think we should preferably either somehow
limit the requested CC's to messages focused on core functionality, or
if we can't then drop the list references from MAINTAINERS.  We should
also not discuss this for very long, as this discussion itself hurts
actual work in a similar way.

> > One thing about leaking_addresses.pl is that I'm not sure anyone is
> > actively using it at this point. I told Tobin I'd help review stuff,
> > but I don't even have a GPG key with enough signatures to send PRs.
> > I'm slowly working on figuring that out, but in the meantime I wonder
> > if we couldn't move it into some self test somehow, so that at least
> > nobody adds new leaks? Does that seem worth doing?
> > 
> > It would then probably go away as a separate perl script and live
> > under selftests, which could mean we could drop the reference to the
> > list. But that's me making it someone else's problem then, kind of :)
> > 
> > Also, I'm switching my e-mail address to tycho@tycho.pizza, so future
> > replies will be from there.
> 
> I don't mind if the reference to kernel-hardening is removed, if in
> the event that someone sends a patch that needs input from the kernel
> hardening community we can always mail the list.

Thank you for your comments as well, Tycho and Tobin.

Alexander
