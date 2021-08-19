Return-Path: <SRS0=N9QJ=NK=lists.openwall.com=kernel-hardening-return-21345-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD274C4338F
	for <kernel-hardening@archiver.kernel.org>; Thu, 19 Aug 2021 09:52:29 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D3918610E6
	for <kernel-hardening@archiver.kernel.org>; Thu, 19 Aug 2021 09:52:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org D3918610E6
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 22398 invoked by uid 550); 19 Aug 2021 09:52:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3964 invoked from network); 19 Aug 2021 01:50:23 -0000
X-IronPort-AV: E=McAfee;i="6200,9189,10080"; a="213345483"
X-IronPort-AV: E=Sophos;i="5.84,333,1620716400"; 
   d="scan'208";a="213345483"
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,333,1620716400"; 
   d="scan'208";a="489106654"
From: "Ma, XinjianX" <xinjianx.ma@intel.com>
To: Alexey Gladkov <legion@kernel.org>, "Eric W. Biederman"
	<ebiederm@xmission.com>
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
Subject: RE: [PATCH v11 5/9] Reimplement RLIMIT_MSGQUEUE on top of ucounts
Thread-Topic: [PATCH v11 5/9] Reimplement RLIMIT_MSGQUEUE on top of ucounts
Thread-Index: AQHXkxd6jQPRg5rF3UWHcji9NSI54at32Gt6gADgWICAAVhdsA==
Date: Thu, 19 Aug 2021 01:50:06 +0000
Message-ID: <54046232de974a3687e4af6366c8ba18@intel.com>
References: <d650b7794e264d5f8aa107644cc9784f@intel.com>
 <87a6lgysxp.fsf@disp2133> <20210818131117.x7omzb2wkjq7le3s@example.org>
In-Reply-To: <20210818131117.x7omzb2wkjq7le3s@example.org>
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
> From: Alexey Gladkov <legion@kernel.org>
> Sent: Wednesday, August 18, 2021 9:11 PM
> To: Eric W. Biederman <ebiederm@xmission.com>
> Cc: Ma, XinjianX <xinjianx.ma@intel.com>; linux-kselftest@vger.kernel.org=
;
> lkp <lkp@intel.com>; akpm@linux-foundation.org; axboe@kernel.dk;
> christian.brauner@ubuntu.com; containers@lists.linux-foundation.org;
> jannh@google.com; keescook@chromium.org; kernel-
> hardening@lists.openwall.com; linux-kernel@vger.kernel.org; linux-
> mm@kvack.org; oleg@redhat.com; torvalds@linux-foundation.org
> Subject: Re: [PATCH v11 5/9] Reimplement RLIMIT_MSGQUEUE on top of
> ucounts
>=20
> On Tue, Aug 17, 2021 at 10:47:14AM -0500, Eric W. Biederman wrote:
> > "Ma, XinjianX" <xinjianx.ma@intel.com> writes:
> >
> > > Hi Alexey,
> > >
> > > When lkp team run kernel selftests, we found after these series of
> > > patches, testcase mqueue: mq_perf_tests in kselftest failed with
> following message.
> >
> > Which kernel was this run against?
> >
> > Where can the mq_perf_tests that you ran and had problems with be
> found?
> >
> > During your run were you using user namespaces as part of your test
> > environment?
> >
> > The error message too many files corresponds to the error code EMFILES
> > which is the error code that is returned when the rlimit is reached.
> >
> > One possibility is that your test environment was run in a user
> > namespace and so you wound up limited by rlimit of the user who
> > created the user namespace at the point of user namespace creation.
> >
> > At this point if you can give us enough information to look into this
> > and attempt to reproduce it that would be appreciated.
>=20
> I was able to reproduce it on master without using user namespace.
> I suspect that the maximum value is not assigned here [1]:
>=20
> set_rlimit_ucount_max(&init_user_ns, UCOUNT_RLIMIT_MSGQUEUE,
> task_rlimit(&init_task, RLIMIT_MSGQUEUE));
>=20
> [1]
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/k=
erne
> l/fork.c#n832
Thank you for confirming the issue. And will you plan to fix this issue?
If it's your plan, kindly add following tag as appropriate
Reported-by: kernel test robot <xinjianx.ma@intel.com>


>=20
> > > If you confirm and fix the issue, kindly add following tag as
> > > appropriate
> > > Reported-by: kernel test robot lkp@intel.com
> > >
> > > ```
> > > # selftests: mqueue: mq_perf_tests
> > > #
> > > # Initial system state:
> > > #       Using queue path:                       /mq_perf_tests
> > > #       RLIMIT_MSGQUEUE(soft):                  819200
> > > #       RLIMIT_MSGQUEUE(hard):                  819200
> > > #       Maximum Message Size:                   8192
> > > #       Maximum Queue Size:                     10
> > > #       Nice value:                             0
> > > #
> > > # Adjusted system state for testing:
> > > #       RLIMIT_MSGQUEUE(soft):                  (unlimited)
> > > #       RLIMIT_MSGQUEUE(hard):                  (unlimited)
> > > #       Maximum Message Size:                   16777216
> > > #       Maximum Queue Size:                     65530
> > > #       Nice value:                             -20
> > > #       Continuous mode:                        (disabled)
> > > #       CPUs to pin:                            3
> > > # ./mq_perf_tests: mq_open() at 296: Too many open files not ok 2
> > > selftests: mqueue: mq_perf_tests # exit=3D1
> > > ```
> > >
> > > Test env:
> > > rootfs: debian-10
> > > gcc version: 9
> > >
> > > ------
> > > Thanks
> > > Ma Xinjian
> >
> > Eric
> >
>=20
> --
> Rgrds, legion

