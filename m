Return-Path: <SRS0=Vjh0=NP=lists.openwall.com=kernel-hardening-return-21349-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C728CC4338F
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Aug 2021 01:20:19 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id BAD5E60F11
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Aug 2021 01:20:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org BAD5E60F11
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 9768 invoked by uid 550); 24 Aug 2021 01:20:11 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9746 invoked from network); 24 Aug 2021 01:20:10 -0000
X-IronPort-AV: E=McAfee;i="6200,9189,10085"; a="216933596"
X-IronPort-AV: E=Sophos;i="5.84,346,1620716400"; 
   d="scan'208";a="216933596"
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,346,1620716400"; 
   d="scan'208";a="443630247"
From: "Ma, XinjianX" <xinjianx.ma@intel.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>, Alexey Gladkov
	<legion@kernel.org>
CC: "linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>, lkp
	<lkp@intel.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"axboe@kernel.dk" <axboe@kernel.dk>, "christian.brauner@ubuntu.com"
	<christian.brauner@ubuntu.com>, "containers@lists.linux-foundation.org"
	<containers@lists.linux-foundation.org>, "jannh@google.com"
	<jannh@google.com>, "keescook@chromium.org" <keescook@chromium.org>,
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>, "oleg@redhat.com"
	<oleg@redhat.com>, "torvalds@linux-foundation.org"
	<torvalds@linux-foundation.org>
Subject: RE: [PATCH] ucounts: Fix regression preventing increasing of rlimits
 in init_user_ns
Thread-Topic: [PATCH] ucounts: Fix regression preventing increasing of rlimits
 in init_user_ns
Thread-Index: AQHXmGLx+8SQcsWA7kykjkjhccpFyquB2fCQ
Date: Tue, 24 Aug 2021 01:19:52 +0000
Message-ID: <06bb27f1d79243febf9ddc4633c4e084@intel.com>
References: <d650b7794e264d5f8aa107644cc9784f@intel.com>
	<87a6lgysxp.fsf@disp2133>	<20210818131117.x7omzb2wkjq7le3s@example.org>
	<87o89ttqql.fsf@disp2133>	<20210819172618.qwrrw4m7wt33wfmz@example.org>
 <87eeajswfc.fsf_-_@disp2133>
In-Reply-To: <87eeajswfc.fsf_-_@disp2133>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
dlp-product: dlpe-windows
dlp-version: 11.5.1.3
dlp-reaction: no-action
x-originating-ip: [10.108.32.68]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0



> -----Original Message-----
> From: Eric W. Biederman <ebiederm@xmission.com>
> Sent: Tuesday, August 24, 2021 5:07 AM
> To: Alexey Gladkov <legion@kernel.org>
> Cc: Ma, XinjianX <xinjianx.ma@intel.com>; linux-kselftest@vger.kernel.org=
;
> lkp <lkp@intel.com>; akpm@linux-foundation.org; axboe@kernel.dk;
> christian.brauner@ubuntu.com; containers@lists.linux-foundation.org;
> jannh@google.com; keescook@chromium.org; kernel-
> hardening@lists.openwall.com; linux-kernel@vger.kernel.org; linux-
> mm@kvack.org; oleg@redhat.com; torvalds@linux-foundation.org
> Subject: [PATCH] ucounts: Fix regression preventing increasing of rlimits=
 in
> init_user_ns
>=20
>=20
> "Ma, XinjianX" <xinjianx.ma@intel.com> reported:
>=20
> > When lkp team run kernel selftests, we found after these series of
> > patches, testcase mqueue: mq_perf_tests in kselftest failed with follow=
ing
> message.
> >
> > # selftests: mqueue: mq_perf_tests
> > #
> > # Initial system state:
> > #       Using queue path:                       /mq_perf_tests
> > #       RLIMIT_MSGQUEUE(soft):                  819200
> > #       RLIMIT_MSGQUEUE(hard):                  819200
> > #       Maximum Message Size:                   8192
> > #       Maximum Queue Size:                     10
> > #       Nice value:                             0
> > #
> > # Adjusted system state for testing:
> > #       RLIMIT_MSGQUEUE(soft):                  (unlimited)
> > #       RLIMIT_MSGQUEUE(hard):                  (unlimited)
> > #       Maximum Message Size:                   16777216
> > #       Maximum Queue Size:                     65530
> > #       Nice value:                             -20
> > #       Continuous mode:                        (disabled)
> > #       CPUs to pin:                            3
> > # ./mq_perf_tests: mq_open() at 296: Too many open files not ok 2
> > selftests: mqueue: mq_perf_tests # exit=3D1 ```
> >
> > Test env:
> > rootfs: debian-10
> > gcc version: 9
>=20
> After investigation the problem turned out to be that ucount_max for the
> rlimits in init_user_ns was being set to the initial rlimit value.
> The practical problem is that ucount_max provides a limit that applicatio=
ns
> inside the user namespace can not exceed.  Which means in practice that
> rlimits that have been converted to use the ucount infrastructure were no=
t
> able to exceend their initial rlimits.
>=20
> Solve this by setting the relevant values of ucount_max to RLIM_INIFINITY=
.  A
> limit in init_user_ns is pointless so the code should allow the values to=
 grow
> as large as possible without riscking an underflow or an overflow.
>=20
> As the ltp test case was a bit of a pain I have reproduced the rlimit fai=
lure and
> tested the fix with the following little C program:
> > #include <stdio.h>
> > #include <fcntl.h>
> > #include <sys/stat.h>
> > #include <mqueue.h>
> > #include <sys/time.h>
> > #include <sys/resource.h>
> > #include <errno.h>
> > #include <string.h>
> > #include <stdlib.h>
> > #include <limits.h>
> > #include <unistd.h>
> >
> > int main(int argc, char **argv)
> > {
> > 	struct mq_attr mq_attr;
> > 	struct rlimit rlim;
> > 	mqd_t mqd;
> > 	int ret;
> >
> > 	ret =3D getrlimit(RLIMIT_MSGQUEUE, &rlim);
> > 	if (ret !=3D 0) {
> > 		fprintf(stderr, "getrlimit(RLIMIT_MSGQUEUE) failed: %s\n",
> strerror(errno));
> > 		exit(EXIT_FAILURE);
> > 	}
> > 	printf("RLIMIT_MSGQUEUE %lu %lu\n",
> > 	       rlim.rlim_cur, rlim.rlim_max);
> > 	rlim.rlim_cur =3D RLIM_INFINITY;
> > 	rlim.rlim_max =3D RLIM_INFINITY;
> > 	ret =3D setrlimit(RLIMIT_MSGQUEUE, &rlim);
> > 	if (ret !=3D 0) {
> > 		fprintf(stderr, "setrlimit(RLIMIT_MSGQUEUE, RLIM_INFINITY)
> failed: %s\n", strerror(errno));
> > 		exit(EXIT_FAILURE);
> > 	}
> >
> > 	memset(&mq_attr, 0, sizeof(struct mq_attr));
> > 	mq_attr.mq_maxmsg =3D 65536 - 1;
> > 	mq_attr.mq_msgsize =3D 16*1024*1024 - 1;
> >
> > 	mqd =3D mq_open("/mq_rlimit_test", O_RDONLY|O_CREAT, 0600,
> &mq_attr);
> > 	if (mqd =3D=3D (mqd_t)-1) {
> > 		fprintf(stderr, "mq_open failed: %s\n", strerror(errno));
> > 		exit(EXIT_FAILURE);
> > 	}
> > 	ret =3D mq_close(mqd);
> > 	if (ret) {
> > 		fprintf(stderr, "mq_close failed; %s\n", strerror(errno));
> > 		exit(EXIT_FAILURE);
> > 	}
> >
> > 	return EXIT_SUCCESS;
> > }
>=20
> Fixes: 6e52a9f0532f ("Reimplement RLIMIT_MSGQUEUE on top of ucounts")
> Fixes: d7c9e99aee48 ("Reimplement RLIMIT_MEMLOCK on top of ucounts")
> Fixes: d64696905554 ("Reimplement RLIMIT_SIGPENDING on top of ucounts")
> Fixes: 21d1c5e386bc ("Reimplement RLIMIT_NPROC on top of ucounts")
> Reported-by: kernel test robot lkp@intel.com
Sorry, but <> around email address is needed=20
Reported-by: kernel test robot <lkp@intel.com>

> Acked-by: Alexey Gladkov <legion@kernel.org>
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>=20
> This is a simplified version of my previous change that I have tested and=
 will
> push out to linux-next and then to Linus shortly.
>=20
>  kernel/fork.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>=20
> diff --git a/kernel/fork.c b/kernel/fork.c index bc94b2cc5995..44f4c2d837=
63
> 100644
> --- a/kernel/fork.c
> +++ b/kernel/fork.c
> @@ -828,10 +828,10 @@ void __init fork_init(void)
>  	for (i =3D 0; i < MAX_PER_NAMESPACE_UCOUNTS; i++)
>  		init_user_ns.ucount_max[i] =3D max_threads/2;
>=20
> -	set_rlimit_ucount_max(&init_user_ns, UCOUNT_RLIMIT_NPROC,
> task_rlimit(&init_task, RLIMIT_NPROC));
> -	set_rlimit_ucount_max(&init_user_ns, UCOUNT_RLIMIT_MSGQUEUE,
> task_rlimit(&init_task, RLIMIT_MSGQUEUE));
> -	set_rlimit_ucount_max(&init_user_ns,
> UCOUNT_RLIMIT_SIGPENDING, task_rlimit(&init_task, RLIMIT_SIGPENDING));
> -	set_rlimit_ucount_max(&init_user_ns, UCOUNT_RLIMIT_MEMLOCK,
> task_rlimit(&init_task, RLIMIT_MEMLOCK));
> +	set_rlimit_ucount_max(&init_user_ns, UCOUNT_RLIMIT_NPROC,
> RLIM_INFINITY);
> +	set_rlimit_ucount_max(&init_user_ns, UCOUNT_RLIMIT_MSGQUEUE,
> RLIM_INFINITY);
> +	set_rlimit_ucount_max(&init_user_ns,
> UCOUNT_RLIMIT_SIGPENDING, RLIM_INFINITY);
> +	set_rlimit_ucount_max(&init_user_ns, UCOUNT_RLIMIT_MEMLOCK,
> RLIM_INFINITY);
>=20
>  #ifdef CONFIG_VMAP_STACK
>  	cpuhp_setup_state(CPUHP_BP_PREPARE_DYN,
> "fork:vm_stack_cache",
> --
> 2.20.1

