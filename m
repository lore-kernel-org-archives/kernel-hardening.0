Return-Path: <SRS0=9IBA=JG=lists.openwall.com=kernel-hardening-return-21185-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACCC8C43460
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Apr 2021 15:06:49 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id CE423610CA
	for <kernel-hardening@archiver.kernel.org>; Fri,  9 Apr 2021 15:06:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org CE423610CA
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=linux.intel.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21185-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28350 invoked by uid 550); 9 Apr 2021 15:06:38 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 28318 invoked from network); 9 Apr 2021 15:06:37 -0000
IronPort-SDR: 9cvajuLgcxqhhWHJh9Vl38A+ssI34bROd+PvIDPvNcQU/0IJFE3J/JV/BGHL7seUR4WVhXO3cc
 +Rjzv1T+DVjg==
X-IronPort-AV: E=McAfee;i="6000,8403,9949"; a="193329890"
X-IronPort-AV: E=Sophos;i="5.82,209,1613462400"; 
   d="scan'208";a="193329890"
IronPort-SDR: /wVm2hicwDL+mPMJldBYgRL/zdJftraLv1zqEdg9igTL/jIoY+gywi1ZJn0rJ6GqFugbQf3xIG
 Oco/Bu8CydIg==
X-IronPort-AV: E=Sophos;i="5.82,209,1613462400"; 
   d="scan'208";a="416297977"
Date: Fri, 9 Apr 2021 08:06:21 -0700
From: Andi Kleen <ak@linux.intel.com>
To: John Wood <john.wood@gmx.com>
Cc: Valdis =?utf-8?Q?Kl=C4=93tnieks?= <valdis.kletnieks@vt.edu>,
	kernelnewbies@kernelnewbies.org, Kees Cook <keescook@chromium.org>,
	kernel-hardening@lists.openwall.com
Subject: Re: Notify special task kill using wait* functions
Message-ID: <20210409150621.GJ3762101@tassilo.jf.intel.com>
References: <20210403070226.GA3002@ubuntu>
 <145687.1617485641@turing-police>
 <20210404094837.GA3263@ubuntu>
 <193167.1617570625@turing-police>
 <20210405073147.GA3053@ubuntu>
 <115437.1617753336@turing-police>
 <20210407175151.GA3301@ubuntu>
 <184666.1617827926@turing-police>
 <20210408015148.GB3762101@tassilo.jf.intel.com>
 <20210409142933.GA3150@ubuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210409142933.GA3150@ubuntu>

> > Any caching of state is inherently insecure because any caches of limited
> > size can be always thrashed by a purposeful attacker. I suppose the
> > only thing that would work is to actually write something to the
> > executable itself on disk, but of course that doesn't always work either.
> 
> I'm also working on this. In the next version I will try to find a way to
> prevent brute force attacks through the execve system call with more than
> one level of forking.

Thanks.

Thinking more about it what I wrote above wasn't quite right. The cache
would only need to be as big as the number of attackable services/suid
binaries. Presumably on many production systems that's rather small,
so a cache (which wouldn't actually be a cache, but a complete database)
might actually work.

-Andi
