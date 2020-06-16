Return-Path: <SRS0=oh+V=75=lists.openwall.com=kernel-hardening-return-18995-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F2D1C433E0
	for <kernel-hardening@archiver.kernel.org>; Tue, 16 Jun 2020 22:21:15 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 701E920739
	for <kernel-hardening@archiver.kernel.org>; Tue, 16 Jun 2020 22:21:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="zwqQ/g3X"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 701E920739
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=zx2c4.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18995-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 19899 invoked by uid 550); 16 Jun 2020 22:21:07 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 19867 invoked from network); 16 Jun 2020 22:21:06 -0000
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
	:references:in-reply-to:from:date:message-id:subject:to:cc
	:content-type; s=mail; bh=RQicizWyLHOE2iCPPK+/7SOXm9U=; b=zwqQ/g
	3Xq/tR7g2fHoBQXiJS3CWnnxoDeJkGT47tGoxmHOECjg2pvQJPYNo/Ejq0CvHM1o
	NCmge4rzYj7J/eHj9zJSeCG2eCkYQL9HaXTBeZrPxQo/3F7GTUifv5/bO4a4v1Ud
	tX/Z6mwcr0ATqWjJ5YOhLIS4J3U4wYUmcvjLJYoTjsmMdQqd2L5YBxtCdTOUFHKq
	mTD5KglvYfKuW154UJWyquve3RxyAMu6/S9EDsGIU4oyJc7XHMpgyuPBZdABo96n
	hzaxhz0tYYJKgIhXTZEKROYDp4gxesLOTbEKAPzbpWOQ+zn5bn7B9Bm251JldpEA
	sspq8gtWfQRzWYpw==
X-Gm-Message-State: AOAM532oWxUTnCwt/nnfNeMP/5sxUXFBV057oHvQ3vg0hqhIWGQE25Q+
	niIvfvleSv/Ux3GzM1Ic8xBAfHoGDkDQhemXFvA=
X-Google-Smtp-Source: ABdhPJzh/Fg/J98wbBnb2dT30/tZcvAhpbVxMckFzIR66mY0R34JuTMP4lkUQFiOJY295tUKmsjnNdvjO8f57XidyrQ=
X-Received: by 2002:a05:6638:216f:: with SMTP id p15mr28530779jak.86.1592346052223;
 Tue, 16 Jun 2020 15:20:52 -0700 (PDT)
MIME-Version: 1.0
References: <CAHmME9rmAznrAmEQTOaLeMM82iMFTfCNfpxDGXw4CJjuVEF_gQ@mail.gmail.com>
 <20200615104332.901519-1-Jason@zx2c4.com>
In-Reply-To: <20200615104332.901519-1-Jason@zx2c4.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Tue, 16 Jun 2020 16:20:41 -0600
X-Gmail-Original-Message-ID: <CAHmME9oemScgo2mg8fzqtJCbKJfu-op0WvG5RcpBCS1hHNmpZw@mail.gmail.com>
Message-ID: <CAHmME9oemScgo2mg8fzqtJCbKJfu-op0WvG5RcpBCS1hHNmpZw@mail.gmail.com>
Subject: Re: [PATCH] acpi: disallow loading configfs acpi tables when locked down
To: Len Brown <lenb@kernel.org>, rjw@rjwysocki.net
Cc: LKML <linux-kernel@vger.kernel.org>, linux-acpi@vger.kernel.org, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

Hi Rafael, Len,

Looks like I should have CC'd you on this patch. This is probably
something we should get into 5.8-rc2, so that it can then get put into
stable kernels, as some people think this is security sensitive.
Bigger picture is this:

https://data.zx2c4.com/american-unsigned-language-2.gif
https://data.zx2c4.com/american-unsigned-language-2-fedora-5.8.png

Also, somebody mentioned to me that Microsoft's ACPI implementation
disallows writes to system memory as a security mitigation. I haven't
looked at what that actually entails, but I wonder if entirely
disabling support for ACPI_ADR_SPACE_SYSTEM_MEMORY would be sensible.
I haven't looked at too many DSDTs. Would that break real hardware, or
does nobody do that? Alternatively, the range of acceptable addresses
for SystemMemory could exclude kernel memory. Would that break
anything? Have you heard about Microsoft's mitigation to know more
details on what they figured out they could safely restrict without
breaking hardware? Either way, food for thought I suppose.

Jason
