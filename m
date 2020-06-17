Return-Path: <SRS0=gOw2=76=lists.openwall.com=kernel-hardening-return-18996-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93CD3C433DF
	for <kernel-hardening@archiver.kernel.org>; Wed, 17 Jun 2020 08:38:25 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E93D52100A
	for <kernel-hardening@archiver.kernel.org>; Wed, 17 Jun 2020 08:38:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="E5Pk/q21"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E93D52100A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18996-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 29986 invoked by uid 550); 17 Jun 2020 08:38:17 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 29951 invoked from network); 17 Jun 2020 08:38:16 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1592383084;
	bh=eWxs3nB/7UcJdvfwSzWTNvyv1bWD2Dy3QiER8xtR+Qo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=E5Pk/q21L4XYpxwsPRqpQvJFKWBqQfH+fQbSfBBfdgjkN2G2l+qH5bfVBVKN5b3zV
	 RFdwLJkO66yeNRhrwzK/X/NwGgJyf3k8yhT4nSlZ3UZxgXSzrNJp4JfGoIRc/dfHaw
	 S+/yBwBXAg3GryE113CQ8pbAaumSZ7nQ0HV4/VCM=
X-Gm-Message-State: AOAM532qLQV4QpQcyRmW3QcFinFe0ICWrdfbjhXeUdWmc7Rxfu5oC6eO
	1ATo+c3y1KvZ34dBEmNwiJtBSMiJYxCb2ZH3ufE=
X-Google-Smtp-Source: ABdhPJznxjKPV69wdlQPGPVd/LwNYP59TKkGepzbjZIAhXvJ+C+a7wEcmwlw4MwfiLqy0B/zTH9gnBN96UqNEJURyu8=
X-Received: by 2002:a9d:476:: with SMTP id 109mr6237581otc.77.1592383083393;
 Wed, 17 Jun 2020 01:38:03 -0700 (PDT)
MIME-Version: 1.0
References: <CAHmME9rmAznrAmEQTOaLeMM82iMFTfCNfpxDGXw4CJjuVEF_gQ@mail.gmail.com>
 <20200615104332.901519-1-Jason@zx2c4.com> <CAHmME9oemScgo2mg8fzqtJCbKJfu-op0WvG5RcpBCS1hHNmpZw@mail.gmail.com>
In-Reply-To: <CAHmME9oemScgo2mg8fzqtJCbKJfu-op0WvG5RcpBCS1hHNmpZw@mail.gmail.com>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Wed, 17 Jun 2020 10:37:52 +0200
X-Gmail-Original-Message-ID: <CAMj1kXGWma7T+C5TJ2wYZ22MJr=3FQRqDjF--YuGuzFdAygP-g@mail.gmail.com>
Message-ID: <CAMj1kXGWma7T+C5TJ2wYZ22MJr=3FQRqDjF--YuGuzFdAygP-g@mail.gmail.com>
Subject: Re: [PATCH] acpi: disallow loading configfs acpi tables when locked down
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, 
	LKML <linux-kernel@vger.kernel.org>, 
	ACPI Devel Maling List <linux-acpi@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 17 Jun 2020 at 00:21, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
>
> Hi Rafael, Len,
>
> Looks like I should have CC'd you on this patch. This is probably
> something we should get into 5.8-rc2, so that it can then get put into
> stable kernels, as some people think this is security sensitive.
> Bigger picture is this:
>
> https://data.zx2c4.com/american-unsigned-language-2.gif
> https://data.zx2c4.com/american-unsigned-language-2-fedora-5.8.png
>
> Also, somebody mentioned to me that Microsoft's ACPI implementation
> disallows writes to system memory as a security mitigation. I haven't
> looked at what that actually entails, but I wonder if entirely
> disabling support for ACPI_ADR_SPACE_SYSTEM_MEMORY would be sensible.
> I haven't looked at too many DSDTs. Would that break real hardware, or
> does nobody do that? Alternatively, the range of acceptable addresses
> for SystemMemory could exclude kernel memory. Would that break
> anything? Have you heard about Microsoft's mitigation to know more
> details on what they figured out they could safely restrict without
> breaking hardware? Either way, food for thought I suppose.
>

ACPI_ADR_SPACE_SYSTEM_MEMORY may be used for everything that is memory
mapped, i.e., PCIe ECAM space, GPIO control registers etc.

I agree that using ACPI_ADR_SPACE_SYSTEM_MEMORY for any memory that is
under the kernel's control is a bad idea, and this should be easy to
filter out: the SystemMemory address space handler needs the ACPI
support routines to map the physical addresses used by AML into
virtual kernel addresses, so all these accesses go through
acpi_os_ioremap(). So as a first step, it should be reasonable to put
a lockdown check there, and fail any access to OS owned memory if
lockdown is enabled, and print a warning if it is not.
