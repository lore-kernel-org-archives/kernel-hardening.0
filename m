Return-Path: <SRS0=xsOg=NO=lists.openwall.com=kernel-hardening-return-21348-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F4E4C4338F
	for <kernel-hardening@archiver.kernel.org>; Mon, 23 Aug 2021 21:08:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 54D3F613CD
	for <kernel-hardening@archiver.kernel.org>; Mon, 23 Aug 2021 21:08:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 54D3F613CD
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=xmission.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 8167 invoked by uid 550); 23 Aug 2021 21:08:05 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 8144 invoked from network); 23 Aug 2021 21:08:04 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: Alexey Gladkov <legion@kernel.org>
Cc: "Ma\, XinjianX" <xinjianx.ma@intel.com>,  "linux-kselftest\@vger.kernel.org" <linux-kselftest@vger.kernel.org>,  lkp <lkp@intel.com>,  "akpm\@linux-foundation.org" <akpm@linux-foundation.org>,  "axboe\@kernel.dk" <axboe@kernel.dk>,  "christian.brauner\@ubuntu.com" <christian.brauner@ubuntu.com>,  "containers\@lists.linux-foundation.org" <containers@lists.linux-foundation.org>,  "jannh\@google.com" <jannh@google.com>,  "keescook\@chromium.org" <keescook@chromium.org>,  "kernel-hardening\@lists.openwall.com" <kernel-hardening@lists.openwall.com>,  "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,  "linux-mm\@kvack.org" <linux-mm@kvack.org>,  "oleg\@redhat.com" <oleg@redhat.com>,  "torvalds\@linux-foundation.org" <torvalds@linux-foundation.org>
References: <d650b7794e264d5f8aa107644cc9784f@intel.com>
	<87a6lgysxp.fsf@disp2133>
	<20210818131117.x7omzb2wkjq7le3s@example.org>
	<87o89ttqql.fsf@disp2133>
	<20210819172618.qwrrw4m7wt33wfmz@example.org>
Date: Mon, 23 Aug 2021 16:06:31 -0500
In-Reply-To: <20210819172618.qwrrw4m7wt33wfmz@example.org> (Alexey Gladkov's
	message of "Thu, 19 Aug 2021 19:26:18 +0200")
Message-ID: <87eeajswfc.fsf_-_@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1mIHAb-003Zot-KN;;;mid=<87eeajswfc.fsf_-_@disp2133>;;;hst=in02.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX19pToonl64FWbIbj8aFLkyc+Dgo1JmkbVU=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: [PATCH] ucounts: Fix regression preventing increasing of rlimits in init_user_ns
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in02.mta.xmission.com)


"Ma, XinjianX" <xinjianx.ma@intel.com> reported:

> When lkp team run kernel selftests, we found after these series of patches, testcase mqueue: mq_perf_tests
> in kselftest failed with following message.
>
> # selftests: mqueue: mq_perf_tests
> #
> # Initial system state:
> #       Using queue path:                       /mq_perf_tests
> #       RLIMIT_MSGQUEUE(soft):                  819200
> #       RLIMIT_MSGQUEUE(hard):                  819200
> #       Maximum Message Size:                   8192
> #       Maximum Queue Size:                     10
> #       Nice value:                             0
> #
> # Adjusted system state for testing:
> #       RLIMIT_MSGQUEUE(soft):                  (unlimited)
> #       RLIMIT_MSGQUEUE(hard):                  (unlimited)
> #       Maximum Message Size:                   16777216
> #       Maximum Queue Size:                     65530
> #       Nice value:                             -20
> #       Continuous mode:                        (disabled)
> #       CPUs to pin:                            3
> # ./mq_perf_tests: mq_open() at 296: Too many open files
> not ok 2 selftests: mqueue: mq_perf_tests # exit=1
> ```
>
> Test env:
> rootfs: debian-10
> gcc version: 9

After investigation the problem turned out to be that ucount_max for
the rlimits in init_user_ns was being set to the initial rlimit value.
The practical problem is that ucount_max provides a limit that
applications inside the user namespace can not exceed.  Which means in
practice that rlimits that have been converted to use the ucount
infrastructure were not able to exceend their initial rlimits.

Solve this by setting the relevant values of ucount_max to
RLIM_INIFINITY.  A limit in init_user_ns is pointless so the code
should allow the values to grow as large as possible without riscking
an underflow or an overflow.

As the ltp test case was a bit of a pain I have reproduced the rlimit failure
and tested the fix with the following little C program:
> #include <stdio.h>
> #include <fcntl.h>
> #include <sys/stat.h>
> #include <mqueue.h>
> #include <sys/time.h>
> #include <sys/resource.h>
> #include <errno.h>
> #include <string.h>
> #include <stdlib.h>
> #include <limits.h>
> #include <unistd.h>
>
> int main(int argc, char **argv)
> {
> 	struct mq_attr mq_attr;
> 	struct rlimit rlim;
> 	mqd_t mqd;
> 	int ret;
>
> 	ret = getrlimit(RLIMIT_MSGQUEUE, &rlim);
> 	if (ret != 0) {
> 		fprintf(stderr, "getrlimit(RLIMIT_MSGQUEUE) failed: %s\n", strerror(errno));
> 		exit(EXIT_FAILURE);
> 	}
> 	printf("RLIMIT_MSGQUEUE %lu %lu\n",
> 	       rlim.rlim_cur, rlim.rlim_max);
> 	rlim.rlim_cur = RLIM_INFINITY;
> 	rlim.rlim_max = RLIM_INFINITY;
> 	ret = setrlimit(RLIMIT_MSGQUEUE, &rlim);
> 	if (ret != 0) {
> 		fprintf(stderr, "setrlimit(RLIMIT_MSGQUEUE, RLIM_INFINITY) failed: %s\n", strerror(errno));
> 		exit(EXIT_FAILURE);
> 	}
>
> 	memset(&mq_attr, 0, sizeof(struct mq_attr));
> 	mq_attr.mq_maxmsg = 65536 - 1;
> 	mq_attr.mq_msgsize = 16*1024*1024 - 1;
>
> 	mqd = mq_open("/mq_rlimit_test", O_RDONLY|O_CREAT, 0600, &mq_attr);
> 	if (mqd == (mqd_t)-1) {
> 		fprintf(stderr, "mq_open failed: %s\n", strerror(errno));
> 		exit(EXIT_FAILURE);
> 	}
> 	ret = mq_close(mqd);
> 	if (ret) {
> 		fprintf(stderr, "mq_close failed; %s\n", strerror(errno));
> 		exit(EXIT_FAILURE);
> 	}
>
> 	return EXIT_SUCCESS;
> }

Fixes: 6e52a9f0532f ("Reimplement RLIMIT_MSGQUEUE on top of ucounts")
Fixes: d7c9e99aee48 ("Reimplement RLIMIT_MEMLOCK on top of ucounts")
Fixes: d64696905554 ("Reimplement RLIMIT_SIGPENDING on top of ucounts")
Fixes: 21d1c5e386bc ("Reimplement RLIMIT_NPROC on top of ucounts")
Reported-by: kernel test robot lkp@intel.com
Acked-by: Alexey Gladkov <legion@kernel.org>
Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
---

This is a simplified version of my previous change that I have tested
and will push out to linux-next and then to Linus shortly.

 kernel/fork.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index bc94b2cc5995..44f4c2d83763 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -828,10 +828,10 @@ void __init fork_init(void)
 	for (i = 0; i < MAX_PER_NAMESPACE_UCOUNTS; i++)
 		init_user_ns.ucount_max[i] = max_threads/2;
 
-	set_rlimit_ucount_max(&init_user_ns, UCOUNT_RLIMIT_NPROC, task_rlimit(&init_task, RLIMIT_NPROC));
-	set_rlimit_ucount_max(&init_user_ns, UCOUNT_RLIMIT_MSGQUEUE, task_rlimit(&init_task, RLIMIT_MSGQUEUE));
-	set_rlimit_ucount_max(&init_user_ns, UCOUNT_RLIMIT_SIGPENDING, task_rlimit(&init_task, RLIMIT_SIGPENDING));
-	set_rlimit_ucount_max(&init_user_ns, UCOUNT_RLIMIT_MEMLOCK, task_rlimit(&init_task, RLIMIT_MEMLOCK));
+	set_rlimit_ucount_max(&init_user_ns, UCOUNT_RLIMIT_NPROC,      RLIM_INFINITY);
+	set_rlimit_ucount_max(&init_user_ns, UCOUNT_RLIMIT_MSGQUEUE,   RLIM_INFINITY);
+	set_rlimit_ucount_max(&init_user_ns, UCOUNT_RLIMIT_SIGPENDING, RLIM_INFINITY);
+	set_rlimit_ucount_max(&init_user_ns, UCOUNT_RLIMIT_MEMLOCK,    RLIM_INFINITY);
 
 #ifdef CONFIG_VMAP_STACK
 	cpuhp_setup_state(CPUHP_BP_PREPARE_DYN, "fork:vm_stack_cache",
-- 
2.20.1

