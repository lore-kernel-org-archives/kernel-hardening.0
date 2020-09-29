Return-Path: <SRS0=A4L5=DG=lists.openwall.com=kernel-hardening-return-20029-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D566C4727C
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 19:25:51 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 3BBC2207F7
	for <kernel-hardening@archiver.kernel.org>; Tue, 29 Sep 2020 19:25:49 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3BBC2207F7
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=openwall.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20029-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 14310 invoked by uid 550); 29 Sep 2020 19:25:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 14121 invoked from network); 29 Sep 2020 19:25:24 -0000
Date: Tue, 29 Sep 2020 21:25:17 +0200
From: Solar Designer <solar@openwall.com>
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, linux-hardening@vger.kernel.org
Subject: Re: Linux-specific kernel hardening
Message-ID: <20200929192517.GA2718@openwall.com>
References: <202009281907.946FBE7B@keescook>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202009281907.946FBE7B@keescook>
User-Agent: Mutt/1.4.2.3i

Hi Kees,

Ouch.  I wouldn't have suggested we do anything at all about that minor
problem if I knew you'd split the list in two as a result.  That's very
confusing.  Assuming that's what you already did anyway, some comments:

On Tue, Sep 29, 2020 at 10:14:03AM -0700, Kees Cook wrote:
> The work of improving the Linux kernel's security is, of course,
> and endless task. While many of the new features come through on the
> kernel-hardening@lists.openwall.com list[1], there is a stated desire
> to avoid "maintenance" topics[2] on the list, and that isn't compatible
> with the on-going work done within the upstream Linux kernel development
> community, which may need to discuss the nuances of performing that work.
> 
> As such there is now a new list, linux-hardening@vger.kernel.org[3],
> which will take kernel-hardening's place in the Linux MAINTAINERS
> file.

OK'ish so far.

> New topics and on-going work will be discussed there, and I urge
> anyone interested in Linux kernel hardening to join the new list. It's
> my intention that all future upstream work can be CCed there, following
> the standard conventions of the Linux development model, for better or
> worse. ;)
> 
> For anyone discussing new topics or ideas, please continue to CC
> kernel-hardening too, as there will likely be many people only subscribed
> there. Hopefully this will get the desired split of topics between the
> two lists.

I find this confusing.  Given that "new topics and on-going work will be
discussed" on the new linux-hardening list, what's left for the old
kernel-hardening list?  Just a legacy list to be CC'ed because people
are still subscribed to it?  If so, it looks like basically because of
my concern about a minor issue you chose to move the list from one place
to another without actually addressing my concern in any way but causing
lots of inconvenience.  That would be weird, so I hope I misunderstand.

To me, "new topics" are certainly desirable on kernel-hardening.  Ditto
for "on-going work" as long as it's work on kernel hardening per se
(patch review, etc.) rather than e.g. documentation formatting fixes for
former kernel hardening changes that are already accepted upstream and
are only CC'ed here because of a formality (link from MAINTAINERS)
rather than anyone's well-reasoned decision.

I suggested that a small minority of messages on kernel-hardening be
removed from here.  You're effectively replacing one list with another,
or if that's not what you're doing then you haven't described it well,
and I wouldn't expect to "get the desired split of topics".

Then there's also the lists' naming and the Subject on this message.
Are you suggesting that the kernel-hardening list be used for kernel
hardening that is not Linux specific?  That would be a reuse of an
abandoned list, if it would be, but I don't know whether there's demand
for that and it's probably incompatible with continuing to CC the list
on Linux-specific topics and it might not be well-received by all
current subscribers who assumed it was a Linux list, which it was.

Please clarify.

> [1] https://www.openwall.com/lists/kernel-hardening/
>     https://lore.kernel.org/kernel-hardening/
> 
> [2] https://lore.kernel.org/kernel-hardening/20200902121604.GA10684@openwall.com/
> 
> [3] http://vger.kernel.org/vger-lists.html#linux-hardening
>     https://lore.kernel.org/linux-hardening/

Alexander
