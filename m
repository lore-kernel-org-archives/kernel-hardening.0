Return-Path: <SRS0=Ylo7=CJ=lists.openwall.com=kernel-hardening-return-19712-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B1464C433E2
	for <kernel-hardening@archiver.kernel.org>; Mon, 31 Aug 2020 00:44:34 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 063722076D
	for <kernel-hardening@archiver.kernel.org>; Mon, 31 Aug 2020 00:44:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="FqO+brb/"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 063722076D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux-foundation.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19712-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15646 invoked by uid 550); 31 Aug 2020 00:44:24 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15611 invoked from network); 31 Aug 2020 00:44:23 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1598834651;
	bh=6LFPsle47n36rc0FcyNKsEGD+oQ4SDQDYywUFSKldSk=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=FqO+brb/S1ZYZR+ybuH+M8gh/BEZ8/GsluEaod9qSVDzwNgYPGNyU7DDH2mFQJtGk
	 1rt59pZPUr/dPHYYhq9IJH9JCvqG/i49ZHYaUV8gikAXPEDtE0GC2ilTIEc2ySqG8J
	 bmXa2J5CykCnsfwLD9XSikkCFf2IWpjf+0P9Yy9s=
Date: Sun, 30 Aug 2020 17:44:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mrinal Pandey <mrinalmni@gmail.com>
Cc: skhan@linuxfoundation.org,
 Linux-kernel-mentees@lists.linuxfoundation.org, lukas.bulwahn@gmail.com,
 keescook@chromium.org, re.emese@gmail.com, maennich@google.com,
 tglx@linutronix.de, gregkh@linuxfoundation.org,
 kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org,
 linux-spdx@vger.kernel.org
Subject: Re: [PATCH] scripts: Add intended executable mode and SPDX license
Message-Id: <20200830174409.c24c3f67addcce0cea9a9d4c@linux-foundation.org>
In-Reply-To: <20200827092405.b6hymjxufn2nvgml@mrinalpandey>
References: <20200827092405.b6hymjxufn2nvgml@mrinalpandey>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Thu, 27 Aug 2020 14:54:05 +0530 Mrinal Pandey <mrinalmni@gmail.com> wrote:

> commit b72231eb7084 ("scripts: add spdxcheck.py self test") added the file
> spdxcheck-test.sh to the repository without the executable flag and license
> information.

The x bit shouldn't matter.

If someone downloads and applies patch-5.9.xz (which is a supported way
of obtaining a kernel) then patch(1) will erase the x bit anyway.

Is some other script invoking spdxcheck-test.sh directly, instead of
using `/bin/sh spdxcheck-test.sh'?  If so, please let's fix that.
