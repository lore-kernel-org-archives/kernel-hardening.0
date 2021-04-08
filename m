Return-Path: <SRS0=iIU7=JF=lists.openwall.com=kernel-hardening-return-21181-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26AE9C433B4
	for <kernel-hardening@archiver.kernel.org>; Thu,  8 Apr 2021 18:45:16 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 46AE1610CB
	for <kernel-hardening@archiver.kernel.org>; Thu,  8 Apr 2021 18:45:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 46AE1610CB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=xmission.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21181-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7853 invoked by uid 550); 8 Apr 2021 18:45:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7829 invoked from network); 8 Apr 2021 18:45:06 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: kernel test robot <oliver.sang@intel.com>,  Alexey Gladkov <gladkov.alexey@gmail.com>,  0day robot <lkp@intel.com>,  LKML <linux-kernel@vger.kernel.org>,  lkp@lists.01.org,  "Huang\, Ying" <ying.huang@intel.com>,  Feng Tang <feng.tang@intel.com>,  zhengjun.xing@intel.com,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  Linux Containers <containers@lists.linux-foundation.org>,  Linux-MM <linux-mm@kvack.org>,  Alexey Gladkov <legion@kernel.org>,  Andrew Morton <akpm@linux-foundation.org>,  Christian Brauner <christian.brauner@ubuntu.com>,  Jann Horn <jannh@google.com>,  Jens Axboe <axboe@kernel.dk>,  Kees Cook <keescook@chromium.org>,  Oleg Nesterov <oleg@redhat.com>
References: <7abe5ab608c61fc2363ba458bea21cf9a4a64588.1617814298.git.gladkov.alexey@gmail.com>
	<20210408083026.GE1696@xsang-OptiPlex-9020>
	<CAHk-=wigPx+MMQMQ-7EA0pq5_5+kMCNV4qFsOss-WwdCSQmb-w@mail.gmail.com>
Date: Thu, 08 Apr 2021 13:44:43 -0500
In-Reply-To: <CAHk-=wigPx+MMQMQ-7EA0pq5_5+kMCNV4qFsOss-WwdCSQmb-w@mail.gmail.com>
	(Linus Torvalds's message of "Thu, 8 Apr 2021 09:22:40 -0700")
Message-ID: <m1im4wmx9g.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-XM-SPF: eid=1lUZe4-00A0nq-5p;;;mid=<m1im4wmx9g.fsf@fess.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19JLUsOtBvU+Hb1U0UwhyIZDve8LzlJSks=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: 08ed4efad6: stress-ng.sigsegv.ops_per_sec -41.9% regression
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)

Linus Torvalds <torvalds@linux-foundation.org> writes:

> On Thu, Apr 8, 2021 at 1:32 AM kernel test robot <oliver.sang@intel.com> =
wrote:
>>
>> FYI, we noticed a -41.9% regression of stress-ng.sigsegv.ops_per_sec due=
 to commit
>> 08ed4efad684 ("[PATCH v10 6/9] Reimplement RLIMIT_SIGPENDING on top of u=
counts")
>
> Ouch.

We were cautiously optimistic when no test problems showed up from
the last posting that there was nothing to look at here.

Unfortunately it looks like the bots just missed the last posting.=20

So it seems we are finally pretty much at correct code in need
of performance tuning.

> I *think* this test may be testing "send so many signals that it
> triggers the signal queue overflow case".
>
> And I *think* that the performance degradation may be due to lots of
> unnecessary allocations, because ity looks like that commit changes
> __sigqueue_alloc() to do
>
>         struct sigqueue *q =3D kmem_cache_alloc(sigqueue_cachep, flags);
>
> *before* checking the signal limit, and then if the signal limit was
> exceeded, it will just be free'd instead.
>
> The old code would check the signal count against RLIMIT_SIGPENDING
> *first*, and if there were m ore pending signals then it wouldn't do
> anything at all (including not incrementing that expensive atomic
> count).

This is an interesting test in a lot of ways as it is testing the
synchronous signal delivery path caused by an exception.  The test
is either executing *ptr =3D 0 (where ptr points to a read-only page)
or it executes an x86 instruction that is excessively long.

I have found the code but I haven't figured out how it is being
called yet.  The core loop is just:
	for(;;) {
		sigaction(SIGSEGV, &action, NULL);
		sigaction(SIGILL, &action, NULL);
		sigaction(SIGBUS, &action, NULL);

		ret =3D sigsetjmp(jmp_env, 1);
		if (done())
                	break;
		if (ret) {
                	/* verify signal */
                } else {
                	*ptr =3D 0;
                }
	}

Code like that fundamentally can not be multi-threaded.  So the only way
the sigpending limit is being hit is if there are more processes running
that code simultaneously than the size of the limit.

Further it looks like stress-ng pushes RLIMIT_SIGPENDING as high as it
will go before the test starts.


> Also, the old code was very careful to only do the "get_user()" for
> the *first* signal it added to the queue, and do the "put_user()" for
> when removing the last signal. Exactly because those atomics are very
> expensive.
>
> The new code just does a lot of these atomics unconditionally.

Yes. That seems a likely culprit.

> I dunno. The profile data in there is a bit hard to read, but there's
> a lot more cachee misses, and a *lot* of node crossers:
>
>>    5961544          +190.4%   17314361        perf-stat.i.cache-misses
>>   22107466          +119.2%   48457656        perf-stat.i.cache-referenc=
es
>>     163292 =C4=85  3%   +4582.0%    7645410        perf-stat.i.node-load=
-misses
>>     227388 =C4=85  2%   +3708.8%    8660824        perf-stat.i.node-loads
>
> and (probably as a result) average instruction costs have gone up enormou=
sly:
>
>>       3.47           +66.8%       5.79        perf-stat.overall.cpi
>>      22849           -65.6%       7866        perf-stat.overall.cycles-b=
etween-cache-misses
>
> and it does seem to be at least partly about "put_ucounts()":
>
>>       0.00            +4.5        4.46        perf-profile.calltrace.cyc=
les-pp.put_ucounts.__sigqueue_free.get_signal.arch_do_signal_or_restart.exi=
t_to_user_mode_prepare
>
> and a lot of "get_ucounts()".
>
> But it may also be that the new "get sigpending" is just *so* much
> more expensive than it used to be.

That too is possible.

That node-load-misses number does look like something is bouncing back
and forth between the nodes a lot more.  So I suspect stress-ng is
running multiple copies of the sigsegv test in different processes at
once.



That really suggests cache line ping pong from get_ucounts and
incrementing sigpending.

It surprises me that obtaining the cache lines exclusively is
the dominant cost on this code path but obtaining two cache lines
exclusively instead of one cache cache line exclusively is consistent
with a causing the exception delivery to take nearly twice as long.

For the optimization we only care about the leaf count so with a little
care we can restore the optimization.  So that is probably the thing
to do here.  The fewer changes to worry about the less likely to find
surprises.



That said for this specific case there is a lot of potential room for
improvement.  As this is a per thread signal the code update sigpending
in commit_cred and never worry about needing to pin the struct
user_struct or struct ucounts.  As this is a synchronous signal we could
skip the sigpending increment, skip the signal queue entirely, and
deliver the signal to user-space immediately.  The removal of all cache
ping pongs might make it worth it.

There is also Thomas Gleixner's recent optimization to cache one
sigqueue entry per task to give more predictable behavior.  That
would remove the cost of the allocation.

Eric
