Return-Path: <SRS0=hL0I=76=lists.openwall.com=kernel-hardening-return-18997-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65A2EC433DF
	for <kernel-hardening@archiver.kernel.org>; Wed, 17 Jun 2020 08:42:47 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B20492073E
	for <kernel-hardening@archiver.kernel.org>; Wed, 17 Jun 2020 08:42:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="kNHdvK3F"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B20492073E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=zx2c4.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18997-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1035 invoked by uid 550); 17 Jun 2020 08:42:40 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32745 invoked from network); 17 Jun 2020 08:42:39 -0000
DKIM-Signature: v=1; a=rsa-sha1; c=relaxed; d=zx2c4.com; h=mime-version
	:references:in-reply-to:from:date:message-id:subject:to:cc
	:content-type; s=mail; bh=E3dus0mAltY1TrmmLK9MI4DIxAo=; b=kNHdvK
	3FaQNYPUv5TymrpkWVzfZzVTDe507P8fhJ03uL/03VzTw+Qg21NKlUH9M3N4BOEh
	56nXQ2H2yWz9xb/rWcckNYXaIFR4sO0YGMzUXGDRBbLPU6iSx5AHaT6U4zq20E7J
	qFYTpQZe29DcZcbqDzEvpBK4fASn87ZPn2RWUft/Ls7ykyBjBWSPd1T7myDkuaEJ
	vB4w0fZBSUKUmHFYPcrGSGGqIULaIBlkMkHFTqtM/ieSXF3j/Lmuh117ECYdCaeA
	vZ1bUbzIyml3Ok3KToC58msuB5QP3ZU4E0eAwxEdvIt3O1H0sTZKTULS+9P7d8AW
	mW0L6Q4ZWdnaXvyw==
X-Gm-Message-State: AOAM5320TETYKqOyF4BXwv/mABdu2KGoYk8p+sEzsMztkaXzsrSqqT3p
	J2k7vEHZFrZqcLpNn0VBk+GKLnadSkc0Z1iwzT4=
X-Google-Smtp-Source: ABdhPJzTYz/LscR65/jJ5KTsW005C2jHQ0GnnD/0q1WTL5nI6l6/fHsGGDp5lRZC/lYo1q8nIBivZ/dL9+SC3Q1A6mI=
X-Received: by 2002:a92:c852:: with SMTP id b18mr7539915ilq.224.1592383346674;
 Wed, 17 Jun 2020 01:42:26 -0700 (PDT)
MIME-Version: 1.0
References: <CAHmME9rmAznrAmEQTOaLeMM82iMFTfCNfpxDGXw4CJjuVEF_gQ@mail.gmail.com>
 <20200615104332.901519-1-Jason@zx2c4.com> <CAHmME9oemScgo2mg8fzqtJCbKJfu-op0WvG5RcpBCS1hHNmpZw@mail.gmail.com>
 <CAMj1kXGWma7T+C5TJ2wYZ22MJr=3FQRqDjF--YuGuzFdAygP-g@mail.gmail.com>
In-Reply-To: <CAMj1kXGWma7T+C5TJ2wYZ22MJr=3FQRqDjF--YuGuzFdAygP-g@mail.gmail.com>
From: "Jason A. Donenfeld" <Jason@zx2c4.com>
Date: Wed, 17 Jun 2020 02:42:15 -0600
X-Gmail-Original-Message-ID: <CAHmME9oJGOH-LwAocAknHFm385Ee_v_itMV4UKj1Sq00SiM4ng@mail.gmail.com>
Message-ID: <CAHmME9oJGOH-LwAocAknHFm385Ee_v_itMV4UKj1Sq00SiM4ng@mail.gmail.com>
Subject: Re: [PATCH] acpi: disallow loading configfs acpi tables when locked down
To: Ard Biesheuvel <ardb@kernel.org>
Cc: Len Brown <lenb@kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, 
	LKML <linux-kernel@vger.kernel.org>, 
	ACPI Devel Maling List <linux-acpi@vger.kernel.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, Jun 17, 2020 at 2:38 AM Ard Biesheuvel <ardb@kernel.org> wrote:
>
> On Wed, 17 Jun 2020 at 00:21, Jason A. Donenfeld <Jason@zx2c4.com> wrote:
> >
> > Hi Rafael, Len,
> >
> > Looks like I should have CC'd you on this patch. This is probably
> > something we should get into 5.8-rc2, so that it can then get put into
> > stable kernels, as some people think this is security sensitive.
> > Bigger picture is this:
> >
> > https://data.zx2c4.com/american-unsigned-language-2.gif
> > https://data.zx2c4.com/american-unsigned-language-2-fedora-5.8.png
> >
> > Also, somebody mentioned to me that Microsoft's ACPI implementation
> > disallows writes to system memory as a security mitigation. I haven't
> > looked at what that actually entails, but I wonder if entirely
> > disabling support for ACPI_ADR_SPACE_SYSTEM_MEMORY would be sensible.
> > I haven't looked at too many DSDTs. Would that break real hardware, or
> > does nobody do that? Alternatively, the range of acceptable addresses
> > for SystemMemory could exclude kernel memory. Would that break
> > anything? Have you heard about Microsoft's mitigation to know more
> > details on what they figured out they could safely restrict without
> > breaking hardware? Either way, food for thought I suppose.
> >
>
> ACPI_ADR_SPACE_SYSTEM_MEMORY may be used for everything that is memory
> mapped, i.e., PCIe ECAM space, GPIO control registers etc.
>
> I agree that using ACPI_ADR_SPACE_SYSTEM_MEMORY for any memory that is
> under the kernel's control is a bad idea, and this should be easy to
> filter out: the SystemMemory address space handler needs the ACPI
> support routines to map the physical addresses used by AML into
> virtual kernel addresses, so all these accesses go through
> acpi_os_ioremap(). So as a first step, it should be reasonable to put
> a lockdown check there, and fail any access to OS owned memory if
> lockdown is enabled, and print a warning if it is not.

Makes sense. Though I was thinking of doing this unconditionally, not
just for lockdown, as a "realer" security mitigation (hence CCing
kernel-hardening), against bugs that manage to mess with acpi things.
A second mitigation might be marking inmemory acpi bytecode pages as
read only.
