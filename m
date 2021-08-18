Return-Path: <SRS0=qMny=NJ=lists.openwall.com=kernel-hardening-return-21344-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4B8D5C4338F
	for <kernel-hardening@archiver.kernel.org>; Wed, 18 Aug 2021 13:11:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4FABC61058
	for <kernel-hardening@archiver.kernel.org>; Wed, 18 Aug 2021 13:11:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 mail.kernel.org 4FABC61058
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=lists.openwall.com
Received: (qmail 3167 invoked by uid 550); 18 Aug 2021 13:11:35 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3142 invoked from network); 18 Aug 2021 13:11:34 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1629292282;
	bh=ARE/Rk5keQAVcABEXYM4kZItEQ5ez+wONw4AP1rt1t8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uJjiNHO6VTs2nYfLIe+ooWLNFQrHXNSoC9M5jZ1S+GlgXwnCeVNNbyWMqPPNyWjh0
	 G07H4IG9vne+ahMyDDY4DGIqnXT2WGwiqeZP6cIPDXIAaXoo0M+5H87qrCIupEe1RR
	 W8EWtuncctE16zUTgEjk7pD3HafRR2rFsMSMNl8oCLOVpseKpYQ9Cxbl7TS94Vs0aV
	 7drJoz6meBstLcvxYuF4akaxIEpx9VLkudXu1W+023VF6xOTuH/uUwXsOJ0kZ9nAMl
	 +pIHgKF6l1C7HQpICRIOxpRIaaRIJG/7n2EJJYaRLkeF5EaJEQoh773yloB/Wi1hYw
	 C03g/go8TbUrw==
Date: Wed, 18 Aug 2021 15:11:17 +0200
From: Alexey Gladkov <legion@kernel.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: "Ma, XinjianX" <xinjianx.ma@intel.com>,
	"linux-kselftest@vger.kernel.org" <linux-kselftest@vger.kernel.org>,
	lkp <lkp@intel.com>,
	"akpm@linux-foundation.org" <akpm@linux-foundation.org>,
	"axboe@kernel.dk" <axboe@kernel.dk>,
	"christian.brauner@ubuntu.com" <christian.brauner@ubuntu.com>,
	"containers@lists.linux-foundation.org" <containers@lists.linux-foundation.org>,
	"jannh@google.com" <jannh@google.com>,
	"keescook@chromium.org" <keescook@chromium.org>,
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-mm@kvack.org" <linux-mm@kvack.org>,
	"oleg@redhat.com" <oleg@redhat.com>,
	"torvalds@linux-foundation.org" <torvalds@linux-foundation.org>
Subject: Re: [PATCH v11 5/9] Reimplement RLIMIT_MSGQUEUE on top of ucounts
Message-ID: <20210818131117.x7omzb2wkjq7le3s@example.org>
References: <d650b7794e264d5f8aa107644cc9784f@intel.com>
 <87a6lgysxp.fsf@disp2133>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a6lgysxp.fsf@disp2133>

On Tue, Aug 17, 2021 at 10:47:14AM -0500, Eric W. Biederman wrote:
> "Ma, XinjianX" <xinjianx.ma@intel.com> writes:
> 
> > Hi Alexey,
> >
> > When lkp team run kernel selftests, we found after these series of patches, testcase mqueue: mq_perf_tests
> > in kselftest failed with following message.
> 
> Which kernel was this run against?
> 
> Where can the mq_perf_tests that you ran and had problems with be found?
> 
> During your run were you using user namespaces as part of your test
> environment?
> 
> The error message too many files corresponds to the error code EMFILES
> which is the error code that is returned when the rlimit is reached.
> 
> One possibility is that your test environment was run in a user
> namespace and so you wound up limited by rlimit of the user who created
> the user namespace at the point of user namespace creation. 
> 
> At this point if you can give us enough information to look into this
> and attempt to reproduce it that would be appreciated.

I was able to reproduce it on master without using user namespace.
I suspect that the maximum value is not assigned here [1]:

set_rlimit_ucount_max(&init_user_ns, UCOUNT_RLIMIT_MSGQUEUE, task_rlimit(&init_task, RLIMIT_MSGQUEUE));

[1] https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/kernel/fork.c#n832

> > If you confirm and fix the issue, kindly add following tag as appropriate
> > Reported-by: kernel test robot lkp@intel.com
> >
> > ```
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
> > # ./mq_perf_tests: mq_open() at 296: Too many open files
> > not ok 2 selftests: mqueue: mq_perf_tests # exit=1
> > ```    
> >
> > Test env:
> > rootfs: debian-10
> > gcc version: 9
> >
> > ------
> > Thanks 
> > Ma Xinjian
> 
> Eric
> 

-- 
Rgrds, legion

