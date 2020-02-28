Return-Path: <SRS0=LWWr=4Q=lists.openwall.com=kernel-hardening-return-18006-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CC7E0C3F2D2
	for <kernel-hardening@archiver.kernel.org>; Fri, 28 Feb 2020 10:44:00 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2319E24691
	for <kernel-hardening@archiver.kernel.org>; Fri, 28 Feb 2020 10:43:59 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="arxk8kA3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2319E24691
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18006-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1935 invoked by uid 550); 28 Feb 2020 10:43:52 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1893 invoked from network); 28 Feb 2020 10:43:51 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582886618;
	bh=AvNMaGxOXSlQd5OKJHyObGF8VX4ufChH9RWCJCyIJhg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=arxk8kA3Yl7/vMnRjI0LVW7eSd/Buz1jbDwOGbAwplxtlsc4g7i8S5zvEI3ZaxdSt
	 EbUy9kXEqvmrLkFMQRwicKF0JIQZKJ4tMqufK407q8+0H+RKhrh1DXiYdvIuBrvWLp
	 11RIOAJkI7n6XNMjozNAbQIaxFeCI/CC2OeSFXD8=
Date: Fri, 28 Feb 2020 10:43:33 +0000
From: Will Deacon <will@kernel.org>
To: Jann Horn <jannh@google.com>
Cc: kernel list <linux-kernel@vger.kernel.org>,
	Kees Cook <keescook@chromium.org>, Ingo Molnar <mingo@kernel.org>,
	Elena Reshetova <elena.reshetova@intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Hanjun Guo <guohanjun@huawei.com>,
	Jan Glauber <jglauber@marvell.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Subject: Re: [RESEND PATCH v4 05/10] lib/refcount: Improve performance of
 generic REFCOUNT_FULL code
Message-ID: <20200228104332.GB2395@willie-the-truck>
References: <20191121115902.2551-1-will@kernel.org>
 <20191121115902.2551-6-will@kernel.org>
 <CAG48ez0CoY2fuxNkdAn_Jx+hffQ1eyM_V++5q6Q5nra+_tE9hQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAG48ez0CoY2fuxNkdAn_Jx+hffQ1eyM_V++5q6Q5nra+_tE9hQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)

Hi Jann,

On Wed, Feb 26, 2020 at 05:10:46AM +0100, Jann Horn wrote:
> On Thu, Nov 21, 2019 at 12:58 PM Will Deacon <will@kernel.org> wrote:
> > Rewrite the generic REFCOUNT_FULL implementation so that the saturation
> > point is moved to INT_MIN / 2. This allows us to defer the sanity checks
> > until after the atomic operation, which removes many uses of cmpxchg()
> > in favour of atomic_fetch_{add,sub}().
> 
> Oh, I never saw this, this is really neat! CCing the kernel-hardening
> list on this might've been a good idea.

Glad you like it! I'll try to remember to cc them in future but
get_maintainer.pl doesn't tend to mention them very often.

> > + * If another thread also performs a refcount_inc() operation between the two
> > + * atomic operations, then the count will continue to edge closer to 0. If it
> > + * reaches a value of 1 before /any/ of the threads reset it to the saturated
> > + * value, then a concurrent refcount_dec_and_test() may erroneously free the
> > + * underlying object. Given the precise timing details involved with the
> > + * round-robin scheduling of each thread manipulating the refcount and the need
> > + * to hit the race multiple times in succession, there doesn't appear to be a
> > + * practical avenue of attack even if using refcount_add() operations with
> > + * larger increments.
> 
> On top of that, the number of threads that can actually be running at
> a given time is capped. See include/linux/threads.h, where it is
> capped to pow(2, 22):
> 
>     /*
>      * A maximum of 4 million PIDs should be enough for a while.
>      * [NOTE: PID/TIDs are limited to 2^29 ~= 500+ million, see futex.h.]
>      */
>     #define PID_MAX_LIMIT (CONFIG_BASE_SMALL ? PAGE_SIZE * 8 : \
>             (sizeof(long) > 4 ? 4 * 1024 * 1024 : PID_MAX_DEFAULT))
> 
> And in the futex UAPI header, we have this, baking a TID limit into
> the userspace API (note that this is pow(2,30), not pow(2,29) as the
> comment in threads.h claims - I'm not sure where that difference comes
> from):
> 
>     /*
>      * The rest of the robust-futex field is for the TID:
>      */
>     #define FUTEX_TID_MASK 0x3fffffff
> 
> So AFAICS, with the current PID_MAX_LIMIT, if you assume that all
> participating refcount operations are non-batched (delta 1) and the
> attacker can't cause the threads to oops in the middle of the refcount
> operation (maybe that would be possible if you managed to find
> something like a NULL pointer dereference in perf software event code
> and had perf paranoia at <=1 , or something like that? - I'm not
> sure), then even in a theoretical scenario where an attacker spawns
> the maximum number of tasks possible and manages to get all of them to
> sequentially preempt while being in the middle of increment operations
> in several nested contexts (I'm not sure whether that can even happen
> - you're not going to take typical sleeping exceptions like page
> faults in the middle of a refcount op), the attacker will stay
> comfortably inside the saturated range. Even if the PID_MAX_LIMIT is
> at some point raised to the maximum permitted by the futex UAPI, this
> still holds as long as you assume no nesting. Hm, should I send a
> patch to add something like this to the explanatory comment?

Sure, I'd be happy to improve the document by adding this -- please send
out a patch for review. It's probably also worth mentioning the batching
use-cases, although I struggle to reason about the window between the
{under,over}flow occuring and saturation. The idea of oopsing during that
period is interesting, although at least that's not silent (and I think
Android usually (always?) sets panic_on_oops to 1.

> Of course, if someone uses refcount batching with sufficiently large
> values, those guarantees go out of the window - if we wanted to be
> perfectionist about this, we could make the batched operations do slow
> cmpxchg stuff while letting the much more performance-critical
> single-reference case continue to use the fast saturation scheme.
> OTOH, the networking folks would probably hate that, since they're
> using the batched ops for ->sk_wmem_alloc stuff, where they count
> bytes as references? So I guess maybe we should leave it as-is.

Agreed. If we hamper the performance here, then people will either look
to disable the checking or they will switch to atomic_t, which puts us
back to square one. Perfection is the enemy of the good and all that.

Having said that, I'd still be keen to learn about any practical attacks
on this in case there is something smart we can do to mitigate them
without cmpxchg(). For example, one silly approach might be to bound the
maximum increment and split larger ones up using a loop.

Will
