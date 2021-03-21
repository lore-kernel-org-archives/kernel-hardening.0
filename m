Return-Path: <SRS0=9RZQ=IT=lists.openwall.com=kernel-hardening-return-21029-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9D65C433E1
	for <kernel-hardening@archiver.kernel.org>; Sun, 21 Mar 2021 18:46:22 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B64BB6195A
	for <kernel-hardening@archiver.kernel.org>; Sun, 21 Mar 2021 18:46:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B64BB6195A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21029-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17554 invoked by uid 550); 21 Mar 2021 18:46:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17522 invoked from network); 21 Mar 2021 18:46:13 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=I2tsQ4ylBo8/TJz8vm2hQjJ8of8T2dTjrO6yNcNWrkk=;
        b=OiGAyhADXEEH8oYfxOTB6RtF7R38GK31gdHCFhEARbI0QlW+wRSin3pCQJdd1wN8p6
         WFPyTtEr87Ps6MHILvlHUDvk27FJoyHP76HHQ5pjFWsB9nmBRQ2r/DgdHC11QZW4gLXJ
         j/q7TpSgVeNPeLm2BxIWCC7oxG3KmgKN/WRug=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=I2tsQ4ylBo8/TJz8vm2hQjJ8of8T2dTjrO6yNcNWrkk=;
        b=BYQ5Trksd1dSja/VK588wFjLsB5G3TS+6ovfWypeIK0zvXGg9Q+QGWHyc5AIjyJ94W
         n7klN1LDpTXzk0kN2ScqYSgU4V5Q8H/o80zPBWDRFIZI7GAiEBWNzfVCOQvND6Zl/5dt
         fA63de2LDqaiWfEgQxZJo9tdOMnHwSGNemaFBo10Sf0vYshH4prD/IaQNvDxXeBUKO6b
         DV2ECxkgwOMu/0sekVopLTl995ecORcituhxQQrZ2HNSB5ZFIR9Zd33iaJjBJH4AjOA8
         YlIxJtLOw/chq0Nbuw37NTD32R83s1DaMZMuTuBLcZeaCyzsVMwwRSNYVBDenpTWew5U
         vzNA==
X-Gm-Message-State: AOAM533Aswjgv7cp6xWRHcMgfbLGUgThxEspPIFPhxcTzVtRgG0cLZ44
	8J7QPSjeWNRpXe4z/CU0819FZg==
X-Google-Smtp-Source: ABdhPJyZFwycnnHM1xKnOtyD0ckDOmNz6J+0nWK8EHwNFXlkVVBtFRZkGaZnKFCIOcC5cp0Iv9lzSA==
X-Received: by 2002:a17:90a:f194:: with SMTP id bv20mr9515969pjb.229.1616352361814;
        Sun, 21 Mar 2021 11:46:01 -0700 (PDT)
Date: Sun, 21 Mar 2021 11:45:59 -0700
From: Kees Cook <keescook@chromium.org>
To: John Wood <john.wood@gmx.com>
Cc: Jann Horn <jannh@google.com>, Randy Dunlap <rdunlap@infradead.org>,
	Jonathan Corbet <corbet@lwn.net>, James Morris <jmorris@namei.org>,
	Shuah Khan <shuah@kernel.org>, "Serge E. Hallyn" <serge@hallyn.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Andi Kleen <ak@linux.intel.com>,
	kernel test robot <oliver.sang@intel.com>,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kernel-hardening@lists.openwall.com
Subject: Re: [PATCH v6 3/8] securtiy/brute: Detect a brute force attack
Message-ID: <202103211128.B59FEB91F@keescook>
References: <20210307113031.11671-1-john.wood@gmx.com>
 <20210307113031.11671-4-john.wood@gmx.com>
 <202103171902.E6F55172@keescook>
 <20210321150118.GA3403@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210321150118.GA3403@ubuntu>

On Sun, Mar 21, 2021 at 04:01:18PM +0100, John Wood wrote:
> On Wed, Mar 17, 2021 at 07:57:10PM -0700, Kees Cook wrote:
> > On Sun, Mar 07, 2021 at 12:30:26PM +0100, John Wood wrote:
> > > +static u64 brute_update_crash_period(struct brute_stats *stats, u64 now)
> > > +{
> > > +	u64 current_period;
> > > +	u64 last_crash_timestamp;
> > > +
> > > +	spin_lock(&stats->lock);
> > > +	current_period = now - stats->jiffies;
> > > +	last_crash_timestamp = stats->jiffies;
> > > +	stats->jiffies = now;
> > > +
> > > +	stats->period -= brute_mul_by_ema_weight(stats->period);
> > > +	stats->period += brute_mul_by_ema_weight(current_period);
> > > +
> > > +	if (stats->faults < BRUTE_MAX_FAULTS)
> > > +		stats->faults += 1;
> > > +
> > > +	spin_unlock(&stats->lock);
> > > +	return last_crash_timestamp;
> > > +}
> >
> > Now *here* locking makes sense, and it only needs to be per-stat, not
> > global, since multiple processes may be operating on the same stat
> > struct. To make this more no-reader-locking-friendly, I'd also update
> > everything at the end, and use WRITE_ONCE():
> >
> > 	u64 current_period, period;
> > 	u64 last_crash_timestamp;
> > 	u64 faults;
> >
> > 	spin_lock(&stats->lock);
> > 	current_period = now - stats->jiffies;
> > 	last_crash_timestamp = stats->jiffies;
> >
> > 	WRITE_ONCE(stats->period,
> > 		   stats->period - brute_mul_by_ema_weight(stats->period) +
> > 		   brute_mul_by_ema_weight(current_period));
> >
> > 	if (stats->faults < BRUTE_MAX_FAULTS)
> > 		WRITE_ONCE(stats->faults, stats->faults + 1);
> >
> > 	WRITE_ONCE(stats->jiffies, now);
> >
> > 	spin_unlock(&stats->lock);
> > 	return last_crash_timestamp;
> >
> > That way readers can (IIUC) safely use READ_ONCE() on jiffies and faults
> > without needing to hold the &stats->lock (unless they need perfectly matching
> > jiffies, period, and faults).
> 
> Sorry, but I try to understand how to use locking properly without luck.
> 
> I have read (and tried to understand):
>    tools/memory-model/Documentation/simple.txt
>    tools/memory-model/Documentation/ordering.txt
>    tools/memory-model/Documentation/recipes.txt
>    Documentation/memory-barriers.txt
> 
> And I don't find the responses that I need. I'm not saying they aren't
> there but I don't see them. So my questions:
> 
> If in the above function makes sense to use locking, and it is called from
> the brute_task_fatal_signal hook, then, all the functions that are called
> from this hook need locking (more than one process can access stats at the
> same time).
> 
> So, as you point, how it is possible and safe to read jiffies and faults
> (and I think period even though you not mention it) using READ_ONCE() but
> without holding brute_stats::lock? I'm very confused.

There are, I think, 3 considerations:

- is "stats", itself, a valid allocation in kernel memory? This is the
  "lifetime" management of the structure: it will only stay allocated as
  long as there is a task still alive that is attached to it. The use of
  refcount_t on task creation/death should entirely solve this issue, so
  that all the other places where you access "stats", the memory will be
  valid. AFAICT, this one is fine: you're doing all the correct lifetime
  management.

- changing a task's stats pointer: this is related to lifetime
  management, but it, I think, entirely solved by the existing
  refcounting. (And isn't helped by holding stats->lock since this is
  about stats itself being a valid pointer.) Again, I think this is all
  correct already in your existing code (due to the implicit locking of
  "current"). Perhaps I've missed something here, but I guess we'll see!

- are the values in stats getting written by multiple writers, or read
  during a write, etc?

This last one is the core of what I think could be improved here:

To keep the writes serialized, you (correctly) perform locking in the
writers. This is fine.

There is also locking in the readers, which I think is not needed.
AFAICT, READ_ONCE() (with WRITE_ONCE() in the writers) is sufficient for
the readers here.

> IIUC (during the reading of the documentation) READ_ONCE and WRITE_ONCE only
> guarantees that a variable loaded with WRITE_ONCE can be read safely with
> READ_ONCE avoiding tearing, etc. So, I see these functions like a form of
> guarantee atomicity in variables.

Right -- from what I can see about how you're reading the statistics, I
don't see a way to have the values get confused (assuming locked writes
and READ/WRITE_ONCE()).

> Another question. Is it also safe to use WRITE_ONCE without holding the lock?
> Or this is only appliable to read operations?

No -- you'll still want the writer locked since you update multiple fields
in stats during a write, so you could miss increments, or interleave
count vs jiffies writes, etc. But the WRITE_ONCE() makes sure that the
READ_ONCE() readers will see a stable value (as I understand it), and
in the order they were written.

> Any light on this will help me to do the best job in the next patches. If
> somebody can point me to the right direction it would be greatly appreciated.
> 
> Is there any documentation for newbies regarding this theme? I'm stuck.
> I have also read the documentation about spinlocks, semaphores, mutex, etc..
> but nothing clears me the concept expose.
> 
> Apologies if this question has been answered in the past. But the search in
> the mailing list has not been lucky.

It's a complex subject! Here are some other docs that might help:

tools/memory-model/Documentation/explanation.txt
Documentation/core-api/refcount-vs-atomic.rst

or they may melt your brain further! :) I know mine is always mushy
after reading them.

> Thanks for your time and patience.

You're welcome; and thank you for your work on this! I've wanted a robust
brute force mitigation in the kernel for a long time. :)

-Kees

-- 
Kees Cook
