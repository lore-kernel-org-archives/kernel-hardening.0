Return-Path: <SRS0=0+6A=DA=lists.openwall.com=kernel-hardening-return-19985-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30631C2D0A8
	for <kernel-hardening@archiver.kernel.org>; Wed, 23 Sep 2020 18:14:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 55CF82220D
	for <kernel-hardening@archiver.kernel.org>; Wed, 23 Sep 2020 18:14:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 55CF82220D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=openwall.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19985-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13443 invoked by uid 550); 23 Sep 2020 18:14:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 8044 invoked from network); 23 Sep 2020 18:11:39 -0000
Date: Wed, 23 Sep 2020 20:11:36 +0200
From: Solar Designer <solar@openwall.com>
To: Florian Weimer <fweimer@redhat.com>
Cc: Pavel Machek <pavel@ucw.cz>, madvenka@linux.microsoft.com,
	kernel-hardening@lists.openwall.com, linux-api@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-fsdevel@vger.kernel.org,
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-security-module@vger.kernel.org, oleg@redhat.com,
	x86@kernel.org, luto@kernel.org, David.Laight@ACULAB.COM,
	mark.rutland@arm.com, mic@digikod.net,
	Rich Felker <dalias@libc.org>
Subject: Re: [PATCH v2 0/4] [RFC] Implement Trampoline File Descriptor
Message-ID: <20200923181136.GA8846@openwall.com>
References: <20200922215326.4603-1-madvenka@linux.microsoft.com> <20200923081426.GA30279@amd> <20200923091456.GA6177@openwall.com> <87wo0ko8v0.fsf@oldenburg2.str.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87wo0ko8v0.fsf@oldenburg2.str.redhat.com>
User-Agent: Mutt/1.4.2.3i

On Wed, Sep 23, 2020 at 04:39:31PM +0200, Florian Weimer wrote:
> * Solar Designer:
> 
> > While I share my opinion here, I don't mean that to block Madhavan's
> > work.  I'd rather defer to people more knowledgeable in current userland
> > and ABI issues/limitations and plans on dealing with those, especially
> > to Florian Weimer.  I haven't seen Florian say anything specific for or
> > against Madhavan's proposal, and I'd like to.  (Have I missed that?)

[...]
> I think it's unnecessary for the libffi use case.
[...]

> I don't know if kernel support could
> make sense in this context, but it would be a completely different
> patch.

Thanks.  Are there currently relevant use cases where the proposed
trampfd would be useful and likely actually made use of by userland -
e.g., specific userland project developers saying they'd use it, or
Madhavan intending to develop and contribute userland patches?

Alexander
