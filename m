Return-Path: <SRS0=eqvf=KC=lists.openwall.com=kernel-hardening-return-21255-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AF54C433ED
	for <kernel-hardening@archiver.kernel.org>; Fri,  7 May 2021 06:58:03 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 4898E61164
	for <kernel-hardening@archiver.kernel.org>; Fri,  7 May 2021 06:58:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 4898E61164
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21255-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13725 invoked by uid 550); 7 May 2021 06:57:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13699 invoked from network); 7 May 2021 06:57:53 -0000
IronPort-SDR: DFE5U0gVXgeKu+GdL6KLwIAE/s2HdyzGlNuGp4IUJZGj9xIQo7++kTKFtES00kMbypB6anx608
 afDrCTfEbPWw==
X-IronPort-AV: E=McAfee;i="6200,9189,9976"; a="178906268"
X-IronPort-AV: E=Sophos;i="5.82,279,1613462400"; 
   d="scan'208";a="178906268"
IronPort-SDR: UnRDUhXp1YJ7woWBBKXsCQlMusv9ZIYJsasX7Fo8/Ov0wrjePJAgLPUsXswZk9LXN/8OdSjgMH
 5aLf1swSJOdw==
X-IronPort-AV: E=Sophos;i="5.82,279,1613462400"; 
   d="scan'208";a="469793342"
Date: Fri, 7 May 2021 15:14:38 +0800
From: Oliver Sang <oliver.sang@intel.com>
To: Alexey Gladkov <legion@kernel.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Alexey Gladkov <gladkov.alexey@gmail.com>,
	0day robot <lkp@intel.com>, LKML <linux-kernel@vger.kernel.org>,
	lkp@lists.01.org, "Huang, Ying" <ying.huang@intel.com>,
	Feng Tang <feng.tang@intel.com>, zhengjun.xing@intel.com,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	Linux Containers <containers@lists.linux-foundation.org>,
	Linux-MM <linux-mm@kvack.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Christian Brauner <christian.brauner@ubuntu.com>,
	Jann Horn <jannh@google.com>, Jens Axboe <axboe@kernel.dk>,
	Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>
Subject: Re: 08ed4efad6: stress-ng.sigsegv.ops_per_sec -41.9% regression
Message-ID: <20210507071438.GC27263@xsang-OptiPlex-9020>
References: <7abe5ab608c61fc2363ba458bea21cf9a4a64588.1617814298.git.gladkov.alexey@gmail.com>
 <20210408083026.GE1696@xsang-OptiPlex-9020>
 <CAHk-=wigPx+MMQMQ-7EA0pq5_5+kMCNV4qFsOss-WwdCSQmb-w@mail.gmail.com>
 <m1im4wmx9g.fsf@fess.ebiederm.org>
 <20210423024722.GA13968@xsang-OptiPlex-9020>
 <20210423074431.7ob6aqasome2zjbk@example.org>
 <20210428143008.GA19916@xsang-OptiPlex-9020>
 <20210428150952.mdnvl7i4kimgwswh@example.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210428150952.mdnvl7i4kimgwswh@example.org>
User-Agent: Mutt/1.9.4 (2018-02-28)

hi Alexey,

On Wed, Apr 28, 2021 at 05:09:52PM +0200, Alexey Gladkov wrote:
> 
> Thank you very much for testing and good news for me !!!
> 
> Do you have a place where its possible to see if the patch has been tested?
> I mean test passed or not.

sorry for late.

unfortunately, we don't yet have a public place for this currently,
which is a problem for developer to know the test coverage.

