Return-Path: <SRS0=6ceA=DM=lists.openwall.com=kernel-hardening-return-20094-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4ACFEC4363A
	for <kernel-hardening@archiver.kernel.org>; Mon,  5 Oct 2020 22:23:30 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5AC1B206CB
	for <kernel-hardening@archiver.kernel.org>; Mon,  5 Oct 2020 22:23:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="RAY3cF0i"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5AC1B206CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20094-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1429 invoked by uid 550); 5 Oct 2020 22:23:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1371 invoked from network); 5 Oct 2020 22:23:19 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=tPhtkZlBx0HdRndNHRRit3OePIrGP7PGyxoDKM6oYqo=;
        b=RAY3cF0iFH1QnO672paSRr4RtBc++9OTMUCz8WS4LK4K4+91RnuNMHoYwDKTb+3o7O
         5+OiiWS0+CYHD8lJOt5nB5OKEYjnBVuQYHBqg96q/6eavN6SocKqepecaprfrzwexPv0
         qsYjOWVoNntG414DZITG9fHym4p4Ww9X9txrk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=tPhtkZlBx0HdRndNHRRit3OePIrGP7PGyxoDKM6oYqo=;
        b=o65gprV7RTlnfmxWPO8WEL5MBghCQ0H3nu5lgYsgrv3eUwEIr+NyA/co5c6iJAk7MY
         YrPkX9JApeXslcDGsQ3jlY4o+06al7SBtt1PLG4KbT1iMLyOzJVNVXmyWbl8hnhWUqvt
         foE3OJYRlu12f3uZLVM7fgm2yAhAASy2TQZNXdpARL7n1VmnHLeXhVrDd3vShiE+X+qi
         cTW3pxgTqVn7CIs+ArasU0q+iLk3q1KctB7WqSbDLtGW4kIqOt8uACPthzBDcWjjnnQk
         GgAYYbqDM7HV8DgsU4Q3wFNAve8EqCLTcId0Q7nLX5bhsegG9qo4GBv/g4782574Wd2S
         p+WQ==
X-Gm-Message-State: AOAM530vkGM5Bz+EHrm0q324vW0Nypel5blE6h1ccczs8nhQISLFKzhq
	YBVz8bcYkYfM0rT34mEcbPxvJ93VoSzeA5ao
X-Google-Smtp-Source: ABdhPJyT3oH9/QjZZTD71sv57tdt3eBqvyidgczvfjn4oxbts3LGwIE5P7nmw+raOF/0Ghd1G6gHtw==
X-Received: by 2002:a65:5c03:: with SMTP id u3mr1410402pgr.452.1601936586852;
        Mon, 05 Oct 2020 15:23:06 -0700 (PDT)
Date: Mon, 5 Oct 2020 15:23:05 -0700
From: Kees Cook <keescook@chromium.org>
To: Solar Designer <solar@openwall.com>
Cc: kernel-hardening@lists.openwall.com, linux-hardening@vger.kernel.org
Subject: Re: Linux-specific kernel hardening
Message-ID: <202010051443.279CC265D@keescook>
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
> On Wed, Sep 30, 2020 at 11:02:32AM +0200, Solar Designer wrote:
> > Messages that are auto-approved don't create any work for either of us,
> > and that's the majority of them.  Messages that are held for moderation
> > (until I add the sender to moderation bypass) do involve some work, but
> > that's the only way to avoid spam on the list.  I think that amount of
> > work is small compared to all subscribers' time wasted on occasional
> > spam on the list.  If it's unacceptable for you, I can remove you from
> > list moderators and maybe add someone else as a co-moderator.  I think
> > it wouldn't be hard for us to find a volunteer.  Please let me know.
> 
> Someone has already volunteered.  I'd also like to hear from someone
> possibly not as over-qualified and as busy as that person is. ;-)
> 
> Kees, if you'd like to step down as a co-moderator for kernel-hardening,
> please let me know.  We'll add someone else (so that this doesn't depend
> solely on me being around).
> 
> To avoid misinterpretation: I am not suggesting that you need to step
> down, totally not.  I merely feel that you need to have the option since
> you expressed unhappiness with having to spend effort on that.

My complaint about moderation is about the list needing to be moderated
at all. (I would note that your own postings to kernel-hardening@ got
moderated...) While vger is certainly not perfect in its spam control,
it is usually fine, and behaves well enough for many other upstream
kernel lists.

> > So your suggested use of kernel-hardening@ is for discussions of Linux
> > kernel hardening projects or work-in-progress that isn't to be submitted
> > upstream or isn't yet submitted upstream.  If, and as soon as, a patch
> > series is sent upstream, that should go on the new linux-hardening@
> > list?  And only in there or also CC'ed to kernel-hardening@?  I'm just
> > trying to understand.
> 
> We need you to comment on the above.  I hope you did have some idea of
> how the topics would be split between the two lists, but you haven't
> really specified that yet.  I tried to make guesses in the paragraph
> above, so at least you need to confirm whether my guesses are correct,
> or correct me if they are not.

My expectation would be that "new topic" RFCs/patches would be CCed to
both lists. Everything else would go to linux-hardening.

> I see there are already a few threads on linux-hardening, and those are
> not CC'ed to kernel-hardening.  I am pleasantly surprised that those
> threads are about rather minor changes, which while acceptable to have
> on kernel-hardening as well IMO do not add much value to discussions
> desirable on kernel-hardening: "Replace one-element array with
> flexible-array member", "Use flex_array_size() helper", "Use
> array_size() helper", "Replace one-element array and save heap space",
> "Use fallthrough pseudo-keyword".

These threads are all on topic, as far as I'm concerned, but they easily
run the "risk" of turning into bike-shedding and nuance, etc. But those
are exactly the kinds of threads I want to have on linux-hardening@ (as
well as the "larger" topics).

> I think topics more desirable on kernel-hardening would be deciding on
> such replacements in general (not patches for individual instances),

Right -- and this is impossible to separate "by default" without a second
list. linux-hardening@ is the default now, as declared by MAINTAINERS
and mailmap. For folks wanting a wider audience for new/big topics,
kernel-hardening@ can be additionally CCed. I have clarified this in the
KSPP wiki now:

https://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project/Get_Involved

> introduction of such helpers, etc.  Also summaries of work done (e.g.,
> "this-many instances of that-thing were updated to new conventions in
> the kernel over the last month as discussed in those threads seen in
> that list archive").  I use examples from the past because that's what
> we have, but I use them to illustrate roughly what kinds of things we
> could possibly have on one list vs. the other in the future.

Agreed.

-- 
Kees Cook
