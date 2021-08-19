Return-Path: <SRS0=WQt4=NK=lists.openwall.com=kernel-hardening-return-21346-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8FB33C4338F
	for <kernel-hardening@archiver.kernel.org>; Thu, 19 Aug 2021 15:10:58 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A11C76044F
	for <kernel-hardening@archiver.kernel.org>; Thu, 19 Aug 2021 15:10:57 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org A11C76044F
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=xmission.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 6078 invoked by uid 550); 19 Aug 2021 15:10:49 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 6058 invoked from network); 19 Aug 2021 15:10:48 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alexey Gladkov <legion@kernel.org>
Cc: "Ma\, XinjianX" <xinjianx.ma@intel.com>,  "linux-kselftest\@vger.kernel.org" <linux-kselftest@vger.kernel.org>,  lkp <lkp@intel.com>,  "akpm\@linux-foundation.org" <akpm@linux-foundation.org>,  "axboe\@kernel.dk" <axboe@kernel.dk>,  "christian.brauner\@ubuntu.com" <christian.brauner@ubuntu.com>,  "containers\@lists.linux-foundation.org" <containers@lists.linux-foundation.org>,  "jannh\@google.com" <jannh@google.com>,  "keescook\@chromium.org" <keescook@chromium.org>,  "kernel-hardening\@lists.openwall.com" <kernel-hardening@lists.openwall.com>,  "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,  "linux-mm\@kvack.org" <linux-mm@kvack.org>,  "oleg\@redhat.com" <oleg@redhat.com>,  "torvalds\@linux-foundation.org" <torvalds@linux-foundation.org>
References: <d650b7794e264d5f8aa107644cc9784f@intel.com>
	<87a6lgysxp.fsf@disp2133>
	<20210818131117.x7omzb2wkjq7le3s@example.org>
Date: Thu, 19 Aug 2021 10:10:26 -0500
In-Reply-To: <20210818131117.x7omzb2wkjq7le3s@example.org> (Alexey Gladkov's
	message of "Wed, 18 Aug 2021 15:11:17 +0200")
Message-ID: <87o89ttqql.fsf@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1mGjgf-00B3f5-1i;;;mid=<87o89ttqql.fsf@disp2133>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+FJyKRYLudFvOu6Oz0NG+8QSd5IgBNsjA=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v11 5/9] Reimplement RLIMIT_MSGQUEUE on top of ucounts
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)

Alexey Gladkov <legion@kernel.org> writes:

> On Tue, Aug 17, 2021 at 10:47:14AM -0500, Eric W. Biederman wrote:
>> "Ma, XinjianX" <xinjianx.ma@intel.com> writes:
>> 
>> > Hi Alexey,
>> >
>> > When lkp team run kernel selftests, we found after these series of patches, testcase mqueue: mq_perf_tests
>> > in kselftest failed with following message.
>> 
>> Which kernel was this run against?
>> 
>> Where can the mq_perf_tests that you ran and had problems with be found?
>> 
>> During your run were you using user namespaces as part of your test
>> environment?
>> 
>> The error message too many files corresponds to the error code EMFILES
>> which is the error code that is returned when the rlimit is reached.
>> 
>> One possibility is that your test environment was run in a user
>> namespace and so you wound up limited by rlimit of the user who created
>> the user namespace at the point of user namespace creation. 
>> 
>> At this point if you can give us enough information to look into this
>> and attempt to reproduce it that would be appreciated.
>
> I was able to reproduce it on master without using user namespace.
> I suspect that the maximum value is not assigned here [1]:
>
> set_rlimit_ucount_max(&init_user_ns, UCOUNT_RLIMIT_MSGQUEUE, task_rlimit(&init_task, RLIMIT_MSGQUEUE));
>
> [1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/kernel/fork.c#n832

The rlimits for init_task are set to INIT_RLIMITS.
In INIT_RLIMITS RLIMIT_MSGQUEUE is set to MQ_MAX_BYTES

So that definitely means that as the code is current constructed the
rlimit can not be effectively raised.

So it looks like we are just silly and preventing the initial rlimits
from being raised.

So we probably want to do something like:

diff --git a/kernel/fork.c b/kernel/fork.c
index bc94b2cc5995..557ce0083ba3 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -825,13 +825,13 @@ void __init fork_init(void)
 	init_task.signal->rlim[RLIMIT_SIGPENDING] =
 		init_task.signal->rlim[RLIMIT_NPROC];
 
+	/* For non-rlimit ucounts make their default limit max_threads/2 */
 	for (i = 0; i < MAX_PER_NAMESPACE_UCOUNTS; i++)
 		init_user_ns.ucount_max[i] = max_threads/2;
 
-	set_rlimit_ucount_max(&init_user_ns, UCOUNT_RLIMIT_NPROC, task_rlimit(&init_task, RLIMIT_NPROC));
-	set_rlimit_ucount_max(&init_user_ns, UCOUNT_RLIMIT_MSGQUEUE, task_rlimit(&init_task, RLIMIT_MSGQUEUE));
-	set_rlimit_ucount_max(&init_user_ns, UCOUNT_RLIMIT_SIGPENDING, task_rlimit(&init_task, RLIMIT_SIGPENDING));
-	set_rlimit_ucount_max(&init_user_ns, UCOUNT_RLIMIT_MEMLOCK, task_rlimit(&init_task, RLIMIT_MEMLOCK));
+	/* In init_user_ns default rlimit to be the only limit */
+	for (; i < UCOUNT_COUNTS; i++)
+		set_rlimit_ucount_max(&init_user_ns, i, RLIMIT_INFINITY);
 
 #ifdef CONFIG_VMAP_STACK
 	cpuhp_setup_state(CPUHP_BP_PREPARE_DYN, "fork:vm_stack_cache",


Eric
