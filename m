Return-Path: <SRS0=iL64=AO=lists.openwall.com=kernel-hardening-return-19212-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16BD8C433E1
	for <kernel-hardening@archiver.kernel.org>; Fri,  3 Jul 2020 18:30:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7056120674
	for <kernel-hardening@archiver.kernel.org>; Fri,  3 Jul 2020 18:30:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="wejWeurv"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7056120674
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=kernel.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19212-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30520 invoked by uid 550); 3 Jul 2020 18:29:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30488 invoked from network); 3 Jul 2020 18:29:55 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1593800983;
	bh=ECMWanzjxJwCk3uw9DCF25Cut3vub+RJ7Rjwaen/OBs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=wejWeurvOl/WCDbVJfpJ+pK9CK3we+tH8nscefgoeIjqh7xLbAwtn2305r8S9ZgoG
	 XGBGa5n9PXGHZNt5vcsHbEYx9tNNSYwytLyyypGwJqzrmSMvGpeEe17fg638LHBsyG
	 GRsYmBgqQV+uz0IrXAUlWhUD9pGZCeNY9FHfxxtM=
X-Gm-Message-State: AOAM530qOeQNA8b/m9caj7Z+iFEcrXHomEqwWvB/qvlTYEGVLWTOPexH
	i5jcjgavN8rzCeJMxEMaRwWbN90+3SDpn/xBSbw=
X-Google-Smtp-Source: ABdhPJwcfH735xr65SkQu2llfmK35406ZAiqzkqCVMsSdComb4LpUkWA6JBlpFZ4+LN1mIlclwupeg+Bs70g0GjABlM=
X-Received: by 2002:a9d:5a12:: with SMTP id v18mr31030790oth.90.1593800982877;
 Fri, 03 Jul 2020 11:29:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200623093755.1534006-1-ardb@kernel.org> <20200623162655.GA22650@red-moon.cambridge.arm.com>
 <CAMj1kXEwnDGV=J7kdtzrPY9hT=Bp6XRCw85urK2MLXsZG3zdMw@mail.gmail.com>
 <20200703161429.GA19595@willie-the-truck> <20200703161628.GB19595@willie-the-truck>
In-Reply-To: <20200703161628.GB19595@willie-the-truck>
From: Ard Biesheuvel <ardb@kernel.org>
Date: Fri, 3 Jul 2020 20:29:32 +0200
X-Gmail-Original-Message-ID: <CAMj1kXHaOh=GH3cyAwJEWBQ6OOQboTt5Sc3vBvOaZQ9ugcHPgg@mail.gmail.com>
Message-ID: <CAMj1kXHaOh=GH3cyAwJEWBQ6OOQboTt5Sc3vBvOaZQ9ugcHPgg@mail.gmail.com>
Subject: Re: [RFC PATCH v2] arm64/acpi: disallow AML memory opregions to
 access kernel memory
To: Will Deacon <will@kernel.org>
Cc: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	ACPI Devel Maling List <linux-acpi@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Sudeep Holla <sudeep.holla@arm.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	"Jason A . Donenfeld" <Jason@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 3 Jul 2020 at 18:16, Will Deacon <will@kernel.org> wrote:
>
> On Fri, Jul 03, 2020 at 05:14:29PM +0100, Will Deacon wrote:
> > Is this 5.9 material, or do you want it to go in as a fix?
>
> Sorry, just spotted the v3, but the same question applies there!
>

This needs a bit more test coverage than we have been able to provide
so far, especially regarding kexec/kdump etc. So even though I think
this ultimately belongs in -stable, that does not necessarily mean it
should go into the next -rc right away.
