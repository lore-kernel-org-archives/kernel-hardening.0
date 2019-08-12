Return-Path: <SRS0=0TdJ=WI=lists.openwall.com=kernel-hardening-return-16783-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC683C433FF
	for <kernel-hardening@archiver.kernel.org>; Mon, 12 Aug 2019 13:56:35 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2E102206C2
	for <kernel-hardening@archiver.kernel.org>; Mon, 12 Aug 2019 13:56:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=alien8.de header.i=@alien8.de header.b="pYCNqKVD"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2E102206C2
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=alien8.de
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-16783-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 13683 invoked by uid 550); 12 Aug 2019 13:56:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13662 invoked from network); 12 Aug 2019 13:56:28 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
	t=1565618176;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
	bh=sOTJPwoCws/W5B4gjQ5XrTQUGLpEMhk29kPSAYtagHs=;
	b=pYCNqKVDhyKc71xmMVdmJNJ0ZlCt2f7s+xxBa4SW2H6x/Zp/9VOq9niuE+n6B1/pGs0Y1a
	r0+PBSURnEi2J+zAcesR2CXAhK9mfXT8fZhzGZik0v5dLutGf3RDCBbFJW0Y9rjUqLHB9m
	jkk5BvQXM3nNjq7mashohehhgqmXgb0=
Date: Mon, 12 Aug 2019 15:57:01 +0200
From: Borislav Petkov <bp@alien8.de>
To: Thomas Garnier <thgarnie@chromium.org>
Cc: kernel-hardening@lists.openwall.com, kristen@linux.intel.com,
	keescook@chromium.org, Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	x86@kernel.org, Peter Zijlstra <peterz@infradead.org>,
	Nadav Amit <namit@vmware.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 11/11] x86/alternatives: Adapt assembly for PIE support
Message-ID: <20190812135701.GH23772@zn.tnic>
References: <20190730191303.206365-1-thgarnie@chromium.org>
 <20190730191303.206365-12-thgarnie@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20190730191303.206365-12-thgarnie@chromium.org>
User-Agent: Mutt/1.10.1 (2018-07-13)

On Tue, Jul 30, 2019 at 12:12:55PM -0700, Thomas Garnier wrote:
> Change the assembly options to work with pointers instead of integers.

This commit message is too vague. A before/after example would make it a
lot more clear why the change is needed.

Thx.

-- 
Regards/Gruss,
    Boris.

Good mailing practices for 400: avoid top-posting and trim the reply.
