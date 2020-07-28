Return-Path: <SRS0=3nQS=BH=lists.openwall.com=kernel-hardening-return-19477-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BC8EC433E5
	for <kernel-hardening@archiver.kernel.org>; Tue, 28 Jul 2020 17:05:41 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6884E20786
	for <kernel-hardening@archiver.kernel.org>; Tue, 28 Jul 2020 17:05:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6884E20786
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=namei.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19477-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25671 invoked by uid 550); 28 Jul 2020 17:05:32 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25643 invoked from network); 28 Jul 2020 17:05:31 -0000
Date: Wed, 29 Jul 2020 03:05:08 +1000 (AEST)
From: James Morris <jmorris@namei.org>
To: Casey Schaufler <casey@schaufler-ca.com>
cc: madvenka@linux.microsoft.com, kernel-hardening@lists.openwall.com,
        linux-api@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-fsdevel@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        oleg@redhat.com, x86@kernel.org
Subject: Re: [PATCH v1 0/4] [RFC] Implement Trampoline File Descriptor
In-Reply-To: <3fd22f92-7f45-1b0f-e4fe-857f3bceedd0@schaufler-ca.com>
Message-ID: <alpine.LRH.2.21.2007290300400.31310@namei.org>
References: <aefc85852ea518982e74b233e11e16d2e707bc32> <20200728131050.24443-1-madvenka@linux.microsoft.com> <3fd22f92-7f45-1b0f-e4fe-857f3bceedd0@schaufler-ca.com>
User-Agent: Alpine 2.21 (LRH 202 2017-01-01)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII

On Tue, 28 Jul 2020, Casey Schaufler wrote:

> You could make a separate LSM to do these checks instead of limiting
> it to SELinux. Your use case, your call, of course.

It's not limited to SELinux. This is hooked via the LSM API and 
implementable by any LSM (similar to execmem, execstack etc.)


-- 
James Morris
<jmorris@namei.org>

