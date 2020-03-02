Return-Path: <SRS0=a6Er=4T=lists.openwall.com=kernel-hardening-return-18036-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_MED,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F0729C3F2D1
	for <kernel-hardening@archiver.kernel.org>; Mon,  2 Mar 2020 13:06:56 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 236FD21739
	for <kernel-hardening@archiver.kernel.org>; Mon,  2 Mar 2020 13:06:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mg/CO/Mh"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 236FD21739
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18036-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 4048 invoked by uid 550); 2 Mar 2020 13:06:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 4010 invoked from network); 2 Mar 2020 13:06:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pD/gxf0uYDpfv1NMd5/waLUhIiVjzlBFv8IcmQrTdcE=;
        b=mg/CO/Mh1z97WyRAh3G7ze2FpgB9K+haWIJAA/2o2dC08vQNxDhx/MY9XmKnjRC+KZ
         dyJbkcVNnNxEgj1ZKlScAECq+iSG+hQNCAkAd+yEgm3ZUt7dBbCzDUHmmVsbY7PfJ4r+
         GauYsUNCqbX2SO66HEx1L5Vhhog/P+Vi5QiHumRzdQh3JztX84UOZWuB6ZnnpvtDausA
         7JlRxnaoNDWPOhonJpzPTiJEl90Kq9W85gRKASUlfB1HGObSquIYujOOPL4WtikLGKzd
         n+ZbzTrwx36nYpWbk21sJWindpGAHDCmDGvnZNW087Qu/9sIQwY/QcoLrCZTPYGDoBax
         AQsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pD/gxf0uYDpfv1NMd5/waLUhIiVjzlBFv8IcmQrTdcE=;
        b=Zwtvxu1o18i9ttZcHicX7F3RPkvOB6RaFp4QrvNrgdaY4arlobVthvH0OeIP4rvOFO
         +WOy9+Y7S7UeVsSALFInNIjVSS0j5Uv8nwDv/M6/BwNmS8f28ZYqAobVUuZIQ/TMpuU/
         judGoOt8ejPPFa90BloatNZLmQ1mc4bRKm57USE+sNHKN+vmStn2t9VjTsZnCDuBzvvV
         AJTmldZSYAx6pR6YKuYMzEyly9Pfu7f0WHLG0wlk3043PxpYeFwrC0FX9LF3RBkJO4bh
         s/Vo/AJUucv71kH58/E5XNPhj+TxRObeaaxGHKIU68WHcMRwzXe9+BCEKTtijGkilyui
         NBew==
X-Gm-Message-State: ANhLgQ2XFXnoazBRoTA0PG42UY4Ng9eaP9NbaC5Dj73017eelAu8hD85
	3mPPR+YrEgNwbdSg619/tko+Qr6ra/sQaMKDjxyF0g==
X-Google-Smtp-Source: ADFU+vsEtDWpu3CBbW2P4D6BNQQyNyFaj2yT+Fnw3axxVc8I4eTTD3DAN6BYP5Fm0m5y/xAWzQqSHqGF6t1ux27xO5U=
X-Received: by 2002:a05:6830:11a:: with SMTP id i26mr2892609otp.180.1583154395616;
 Mon, 02 Mar 2020 05:06:35 -0800 (PST)
MIME-Version: 1.0
References: <20191121115902.2551-1-will@kernel.org> <20191121115902.2551-6-will@kernel.org>
 <CAG48ez0CoY2fuxNkdAn_Jx+hffQ1eyM_V++5q6Q5nra+_tE9hQ@mail.gmail.com> <20200228104332.GB2395@willie-the-truck>
In-Reply-To: <20200228104332.GB2395@willie-the-truck>
From: Jann Horn <jannh@google.com>
Date: Mon, 2 Mar 2020 14:06:09 +0100
Message-ID: <CAG48ez3n+tNwm8ZCgrRj_L8eWu7vF6-v9EB7hsW09bv5TG6kPg@mail.gmail.com>
Subject: Re: [RESEND PATCH v4 05/10] lib/refcount: Improve performance of
 generic REFCOUNT_FULL code
To: Will Deacon <will@kernel.org>
Cc: kernel list <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, 
	Ingo Molnar <mingo@kernel.org>, Elena Reshetova <elena.reshetova@intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, 
	Hanjun Guo <guohanjun@huawei.com>, Jan Glauber <jglauber@marvell.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, Feb 28, 2020 at 11:43 AM Will Deacon <will@kernel.org> wrote:
> On Wed, Feb 26, 2020 at 05:10:46AM +0100, Jann Horn wrote:
> > On Thu, Nov 21, 2019 at 12:58 PM Will Deacon <will@kernel.org> wrote:
> > > + * If another thread also performs a refcount_inc() operation between the two
> > > + * atomic operations, then the count will continue to edge closer to 0. If it
> > > + * reaches a value of 1 before /any/ of the threads reset it to the saturated
> > > + * value, then a concurrent refcount_dec_and_test() may erroneously free the
> > > + * underlying object. Given the precise timing details involved with the
> > > + * round-robin scheduling of each thread manipulating the refcount and the need
> > > + * to hit the race multiple times in succession, there doesn't appear to be a
> > > + * practical avenue of attack even if using refcount_add() operations with
> > > + * larger increments.
> >
> > On top of that, the number of threads that can actually be running at
> > a given time is capped. See include/linux/threads.h, where it is
> > capped to pow(2, 22):
> >
> >     /*
> >      * A maximum of 4 million PIDs should be enough for a while.
> >      * [NOTE: PID/TIDs are limited to 2^29 ~= 500+ million, see futex.h.]
> >      */
> >     #define PID_MAX_LIMIT (CONFIG_BASE_SMALL ? PAGE_SIZE * 8 : \
> >             (sizeof(long) > 4 ? 4 * 1024 * 1024 : PID_MAX_DEFAULT))
> >
> > And in the futex UAPI header, we have this, baking a TID limit into
> > the userspace API (note that this is pow(2,30), not pow(2,29) as the
> > comment in threads.h claims - I'm not sure where that difference comes
> > from):
> >
> >     /*
> >      * The rest of the robust-futex field is for the TID:
> >      */
> >     #define FUTEX_TID_MASK 0x3fffffff
> >
> > So AFAICS, with the current PID_MAX_LIMIT, if you assume that all
> > participating refcount operations are non-batched (delta 1) and the
> > attacker can't cause the threads to oops in the middle of the refcount
> > operation (maybe that would be possible if you managed to find
> > something like a NULL pointer dereference in perf software event code
> > and had perf paranoia at <=1 , or something like that? - I'm not
> > sure), then even in a theoretical scenario where an attacker spawns
> > the maximum number of tasks possible and manages to get all of them to
> > sequentially preempt while being in the middle of increment operations
> > in several nested contexts (I'm not sure whether that can even happen
> > - you're not going to take typical sleeping exceptions like page
> > faults in the middle of a refcount op), the attacker will stay
> > comfortably inside the saturated range. Even if the PID_MAX_LIMIT is
> > at some point raised to the maximum permitted by the futex UAPI, this
> > still holds as long as you assume no nesting. Hm, should I send a
> > patch to add something like this to the explanatory comment?
>
> Sure, I'd be happy to improve the document by adding this -- please send
> out a patch for review. It's probably also worth mentioning the batching
> use-cases, although I struggle to reason about the window between the
> {under,over}flow occuring and saturation.

In the overflow case, it's fine, right? If you briefly crossed into
the saturation range and then went back down, using some tasks with
half-completed refcounting operations, then the refcount is still
behaving as a correct non-saturating refcount. (And it can't cross
over to the other end of the saturation range, because that's twice as
much distance as you'd need to unpin a saturated refcount.)

And in the underflow case, we can't deterministically protect anyway
without some external mechanism to protect the object's lifetime while
someone is already freeing it - so that's pretty much just a
best-effort thing anyway.

> > Of course, if someone uses refcount batching with sufficiently large
> > values, those guarantees go out of the window - if we wanted to be
> > perfectionist about this, we could make the batched operations do slow
> > cmpxchg stuff while letting the much more performance-critical
> > single-reference case continue to use the fast saturation scheme.
> > OTOH, the networking folks would probably hate that, since they're
> > using the batched ops for ->sk_wmem_alloc stuff, where they count
> > bytes as references? So I guess maybe we should leave it as-is.
>
> Agreed. If we hamper the performance here, then people will either look
> to disable the checking or they will switch to atomic_t, which puts us
> back to square one. Perfection is the enemy of the good and all that.
>
> Having said that, I'd still be keen to learn about any practical attacks
> on this in case there is something smart we can do to mitigate them
> without cmpxchg(). For example, one silly approach might be to bound the
> maximum increment and split larger ones up using a loop.

I guess that'd do the job. I don't know whether it's worth the trouble
in practice though.
