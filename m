Return-Path: <SRS0=tkzH=GX=lists.openwall.com=kernel-hardening-return-20670-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB170C433E0
	for <kernel-hardening@archiver.kernel.org>; Wed, 20 Jan 2021 02:00:18 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D299F21D79
	for <kernel-hardening@archiver.kernel.org>; Wed, 20 Jan 2021 02:00:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D299F21D79
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=xmission.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20670-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26243 invoked by uid 550); 20 Jan 2021 02:00:10 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 26211 invoked from network); 20 Jan 2021 02:00:09 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alexey Gladkov <gladkov.alexey@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,  LKML <linux-kernel@vger.kernel.org>,  io-uring <io-uring@vger.kernel.org>,  Kernel Hardening <kernel-hardening@lists.openwall.com>,  Linux Containers <containers@lists.linux-foundation.org>,  Linux-MM <linux-mm@kvack.org>,  Andrew Morton <akpm@linux-foundation.org>,  Christian Brauner <christian.brauner@ubuntu.com>,  Jann Horn <jannh@google.com>,  Jens Axboe <axboe@kernel.dk>,  Kees Cook <keescook@chromium.org>,  Oleg Nesterov <oleg@redhat.com>
References: <cover.1610722473.git.gladkov.alexey@gmail.com>
	<116c7669744404364651e3b380db2d82bb23f983.1610722473.git.gladkov.alexey@gmail.com>
	<CAHk-=wjsg0Lgf1Mh2UiJE4sqBDDo0VhFVBUbhed47ot2CQQwfQ@mail.gmail.com>
	<20210118194551.h2hrwof7b3q5vgoi@example.org>
	<CAHk-=wiNpc5BS2BfZhdDqofJx1G=uasBa2Q1eY4cr8O59Rev2A@mail.gmail.com>
	<20210118205629.zro2qkd3ut42bpyq@example.org>
	<87eeig74kv.fsf@x220.int.ebiederm.org>
Date: Tue, 19 Jan 2021 19:58:44 -0600
In-Reply-To: <87eeig74kv.fsf@x220.int.ebiederm.org> (Eric W. Biederman's
	message of "Tue, 19 Jan 2021 19:57:36 -0600")
Message-ID: <878s8o74iz.fsf@x220.int.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1l22mo-00B0pL-8x;;;mid=<878s8o74iz.fsf@x220.int.ebiederm.org>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1/T2B95TMqxtikO/3YyPpBrhK2ILrwugMw=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [RFC PATCH v3 1/8] Use refcount_t for ucounts reference counting
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)

ebiederm@xmission.com (Eric W. Biederman) writes:

> Alexey Gladkov <gladkov.alexey@gmail.com> writes:
>
>> On Mon, Jan 18, 2021 at 12:34:29PM -0800, Linus Torvalds wrote:
>>> On Mon, Jan 18, 2021 at 11:46 AM Alexey Gladkov
>>> <gladkov.alexey@gmail.com> wrote:
>>> >
>>> > Sorry about that. I thought that this code is not needed when switching
>>> > from int to refcount_t. I was wrong.
>>> 
>>> Well, you _may_ be right. I personally didn't check how the return
>>> value is used.
>>> 
>>> I only reacted to "it certainly _may_ be used, and there is absolutely
>>> no comment anywhere about why it wouldn't matter".
>>
>> I have not found examples where checked the overflow after calling
>> refcount_inc/refcount_add.
>>
>> For example in kernel/fork.c:2298 :
>>
>>    current->signal->nr_threads++;                           
>>    atomic_inc(&current->signal->live);                      
>>    refcount_inc(&current->signal->sigcnt);  
>>
>> $ semind search signal_struct.sigcnt
>> def include/linux/sched/signal.h:83  		refcount_t		sigcnt;
>> m-- kernel/fork.c:723 put_signal_struct 		if (refcount_dec_and_test(&sig->sigcnt))
>> m-- kernel/fork.c:1571 copy_signal 		refcount_set(&sig->sigcnt, 1);
>> m-- kernel/fork.c:2298 copy_process 				refcount_inc(&current->signal->sigcnt);
>>
>> It seems to me that the only way is to use __refcount_inc and then compare
>> the old value with REFCOUNT_MAX
>>
>> Since I have not seen examples of such checks, I thought that this is
>> acceptable. Sorry once again. I have not tried to hide these changes.
>
> The current ucount code does check for overflow and fails the increment
> in every case.
>
> So arguably it will be a regression and inferior error handling behavior
> if the code switches to the ``better'' refcount_t data structure.
>
> I originally didn't use refcount_t because silently saturating and not
> bothering to handle the error makes me uncomfortable.
>
> Not having to acquire the ucounts_lock every time seems nice.  Perhaps
> the path forward would be to start with stupid/correct code that always
> takes the ucounts_lock for every increment of ucounts->count, that is
> later replaced with something more optimal.
>
> Not impacting performance in the non-namespace cases and having good
> performance in the other cases is a fundamental requirement of merging
> code like this.

So starting with something easy to comprehend and simple, may make it
easier to figure out how to optimize the code.

Eric

