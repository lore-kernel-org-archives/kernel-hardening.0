Return-Path: <SRS0=Lbwl=ID=lists.openwall.com=kernel-hardening-return-20874-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5964C433DB
	for <kernel-hardening@archiver.kernel.org>; Fri,  5 Mar 2021 17:57:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BFC54650A3
	for <kernel-hardening@archiver.kernel.org>; Fri,  5 Mar 2021 17:57:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BFC54650A3
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=xmission.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20874-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17892 invoked by uid 550); 5 Mar 2021 17:57:01 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17871 invoked from network); 5 Mar 2021 17:57:00 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: kernel test robot <oliver.sang@intel.com>,  0day robot <lkp@intel.com>,  LKML <linux-kernel@vger.kernel.org>,  lkp@lists.01.org,  ying.huang@intel.com,  feng.tang@intel.com,  zhengjun.xing@intel.com,  io-uring@vger.kernel.org,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  Linux Containers <containers@lists.linux-foundation.org>,  linux-mm@kvack.org,  Andrew Morton <akpm@linux-foundation.org>,  Christian Brauner <christian.brauner@ubuntu.com>,  Jann Horn <jannh@google.com>,  Jens Axboe <axboe@kernel.dk>,  Kees Cook <keescook@chromium.org>,  Linus Torvalds <torvalds@linux-foundation.org>,  Oleg Nesterov <oleg@redhat.com>
References: <20210224051845.GB6114@xsang-OptiPlex-9020>
	<m1czwpl83q.fsf@fess.ebiederm.org>
	<20210224183828.j6uut6sholeo2fzh@example.org>
	<m17dmxl2qa.fsf@fess.ebiederm.org>
	<20210225203657.mjhaqnj5vszna5xw@example.org>
Date: Fri, 05 Mar 2021 11:56:44 -0600
In-Reply-To: <20210225203657.mjhaqnj5vszna5xw@example.org> (Alexey Gladkov's
	message of "Thu, 25 Feb 2021 21:36:57 +0100")
Message-ID: <m1czwd32n7.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1lIEgt-004li8-IX;;;mid=<m1czwd32n7.fsf@fess.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+QpJmPwGjQCYsOz8d21ibu8x9BhUmL7YA=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: d28296d248:  stress-ng.sigsegv.ops_per_sec -82.7% regression
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)

Alexey Gladkov <gladkov.alexey@gmail.com> writes:

> On Wed, Feb 24, 2021 at 12:50:21PM -0600, Eric W. Biederman wrote:
>> Alexey Gladkov <gladkov.alexey@gmail.com> writes:
>> 
>> > On Wed, Feb 24, 2021 at 10:54:17AM -0600, Eric W. Biederman wrote:
>> >> kernel test robot <oliver.sang@intel.com> writes:
>> >> 
>> >> > Greeting,
>> >> >
>> >> > FYI, we noticed a -82.7% regression of stress-ng.sigsegv.ops_per_sec due to commit:
>> >> >
>> >> >
>> >> > commit: d28296d2484fa11e94dff65e93eb25802a443d47 ("[PATCH v7 5/7] Reimplement RLIMIT_SIGPENDING on top of ucounts")
>> >> > url: https://github.com/0day-ci/linux/commits/Alexey-Gladkov/Count-rlimits-in-each-user-namespace/20210222-175836
>> >> > base: https://git.kernel.org/cgit/linux/kernel/git/shuah/linux-kselftest.git next
>> >> >
>> >> > in testcase: stress-ng
>> >> > on test machine: 48 threads Intel(R) Xeon(R) CPU E5-2697 v2 @ 2.70GHz with 112G memory
>> >> > with following parameters:
>> >> >
>> >> > 	nr_threads: 100%
>> >> > 	disk: 1HDD
>> >> > 	testtime: 60s
>> >> > 	class: interrupt
>> >> > 	test: sigsegv
>> >> > 	cpufreq_governor: performance
>> >> > 	ucode: 0x42e
>> >> >
>> >> >
>> >> > In addition to that, the commit also has significant impact on the
>> >> > following tests:
>> >> 
>> >> Thank you.  Now we have a sense of where we need to test the performance
>> >> of these changes carefully.
>> >
>> > One of the reasons for this is that I rolled back the patch that changed
>> > the ucounts.count type to atomic_t. Now get_ucounts() is forced to use a
>> > spin_lock to increase the reference count.
>> 
>> Which given the hickups with getting a working version seems justified.
>> 
>> Now we can add incremental patches on top to improve the performance.
>
> I'm not sure that get_ucounts() should be used in __sigqueue_alloc() [1].
> I tried removing it and running KASAN tests that were failing before. So
> far, I have not found any problems.
>
> [1]
> https://git.kernel.org/pub/scm/linux/kernel/git/legion/linux.git/tree/kernel/signal.c?h=patchset/per-userspace-rlimit/v7.1&id=2d4a2e2be7db42c95acb98abfc2a9b370ddd0604#n428

Hmm.  The code you posted still seems to include the get_ucounts.

I like the idea of not needing to increment and decrement the ucount
reference count every time a signal is sent, unfortunately there is a
problem.  The way we have implemented setresuid allows different threads
in a threaded application to have different cred->user values.

That is actually an extension of what posix supports and pthreads will
keep the creds of a process in sync.  Still I recall looking into this a
few years ago and there were a few applications that take advantage of
the linux behavior.

In principle I think it is possible to hold a ucount reference in
somewhere such as task->signal.  In practice there are enough
complicating factors I don't immediately see how to implement that.

If the creds were stored in signal_struct instead of in task_struct
we could simply move the sigpending counts in set_user, when the uid
of a process changed.

With the current state I don't know how to pick which is the real user.

Eric
