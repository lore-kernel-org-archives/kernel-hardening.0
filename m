Return-Path: <SRS0=8ukR=NI=lists.openwall.com=kernel-hardening-return-21343-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A620CC4338F
	for <kernel-hardening@archiver.kernel.org>; Tue, 17 Aug 2021 15:48:30 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id C4F5A60FD7
	for <kernel-hardening@archiver.kernel.org>; Tue, 17 Aug 2021 15:48:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org C4F5A60FD7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=xmission.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 1611 invoked by uid 550); 17 Aug 2021 15:48:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1591 invoked from network); 17 Aug 2021 15:48:21 -0000
From: ebiederm@xmission.com (Eric W. Biederman)
To: "Ma\, XinjianX" <xinjianx.ma@intel.com>
Cc: "legion\@kernel.org" <legion@kernel.org>,  "linux-kselftest\@vger.kernel.org" <linux-kselftest@vger.kernel.org>,  lkp <lkp@intel.com>,  "akpm\@linux-foundation.org" <akpm@linux-foundation.org>,  "axboe\@kernel.dk" <axboe@kernel.dk>,  "christian.brauner\@ubuntu.com" <christian.brauner@ubuntu.com>,  "containers\@lists.linux-foundation.org" <containers@lists.linux-foundation.org>,  "jannh\@google.com" <jannh@google.com>,  "keescook\@chromium.org" <keescook@chromium.org>,  "kernel-hardening\@lists.openwall.com" <kernel-hardening@lists.openwall.com>,  "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,  "linux-mm\@kvack.org" <linux-mm@kvack.org>,  "oleg\@redhat.com" <oleg@redhat.com>,  "torvalds\@linux-foundation.org" <torvalds@linux-foundation.org>
References: <d650b7794e264d5f8aa107644cc9784f@intel.com>
Date: Tue, 17 Aug 2021 10:47:14 -0500
In-Reply-To: <d650b7794e264d5f8aa107644cc9784f@intel.com> (XinjianX Ma's
	message of "Tue, 17 Aug 2021 04:03:50 +0000")
Message-ID: <87a6lgysxp.fsf@disp2133>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-XM-SPF: eid=1mG1Jq-008gTq-AD;;;mid=<87a6lgysxp.fsf@disp2133>;;;hst=in01.mta.xmission.com;;;ip=68.227.160.95;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+YR/Sxbe0UH84qAcIuO7Yi3l0O0ew6ZBk=
X-SA-Exim-Connect-IP: 68.227.160.95
X-SA-Exim-Mail-From: ebiederm@xmission.com
Subject: Re: [PATCH v11 5/9] Reimplement RLIMIT_MSGQUEUE on top of ucounts
X-SA-Exim-Version: 4.2.1 (built Sat, 08 Feb 2020 21:53:50 +0000)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)

"Ma, XinjianX" <xinjianx.ma@intel.com> writes:

> Hi Alexey,
>
> When lkp team run kernel selftests, we found after these series of patches, testcase mqueue: mq_perf_tests
> in kselftest failed with following message.

Which kernel was this run against?

Where can the mq_perf_tests that you ran and had problems with be found?

During your run were you using user namespaces as part of your test
environment?

The error message too many files corresponds to the error code EMFILES
which is the error code that is returned when the rlimit is reached.

One possibility is that your test environment was run in a user
namespace and so you wound up limited by rlimit of the user who created
the user namespace at the point of user namespace creation. 

At this point if you can give us enough information to look into this
and attempt to reproduce it that would be appreciated.

> If you confirm and fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot lkp@intel.com
>
> ```
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
>
> ------
> Thanks 
> Ma Xinjian

Eric
