Return-Path: <SRS0=WxGx=77=lists.openwall.com=kernel-hardening-return-19012-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A896C433DF
	for <kernel-hardening@archiver.kernel.org>; Thu, 18 Jun 2020 03:19:03 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 678C821BE5
	for <kernel-hardening@archiver.kernel.org>; Thu, 18 Jun 2020 03:19:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dxmE6qRj"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 678C821BE5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19012-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 30706 invoked by uid 550); 18 Jun 2020 03:18:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 30683 invoked from network); 18 Jun 2020 03:18:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=1Nb0OKkrYI7UdUwYs4M/9iCS139uCuO87Yk1yKcZKtM=;
        b=dxmE6qRji4kPvuNtROXvm9eYHXzOZJvRUOt6F65MtnCl8R5EgI/5TTzvzskNvyD2Jk
         UiMqiRR3227QZLfSNc34aZ7iyWb15yQ2f2YBCsdfKArbvnT2NpayWJKLyebSubR+CV1j
         0VCXJ6TOrnnurUOxVUf1jmIuvm0DHZY/bKwWUnmahlVgAof3lGfwzsWvT1C3+7bPK8c8
         e7huquqCC9u46IpRv8llWpRa0mTWAfzekFrsXpyC8j8txHHc+O70VgI6S7ihhuQVdFLD
         Nrm9gE7YUImWS4wGL3w7XAuYjF2AHm9KwfoANJfx/Fur0KX+nNzj9PIytgDgkIivTKKE
         ndyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=1Nb0OKkrYI7UdUwYs4M/9iCS139uCuO87Yk1yKcZKtM=;
        b=Yh8hSxp7iZT7o8c2dwN8gioO71gNer9ccXe71l6ZSGslOav2Sakx3CzuC7dIwdgfEc
         rGr8xlF4bkE0aSsj/kgypFRQVN8iCsNyxqxG1sIGqlQp6q/LPyptavg7qoW6+RRHdy3Z
         ldjFw3J71i7DEwSZJ+YwBmZ7EjUEk/+nqjruQGM7Iza1Ma/3L/WwyOTYpGMVJubaaEPB
         +oz0vLCIEWza54GHjL8+R4IuDW9lH4SPZ8HJhojaK49b4GomjnjcPvaymtw6QsUrqrEo
         LJAfcUhTw7u80WxD0fDZs1c4/p9ppk8XNFmTcsdxHesYS78iNM+b+0gCDYiGZ5F/OrIz
         TYeg==
X-Gm-Message-State: AOAM532sCn3fbKyVjEz3fXu2SP4Y2QFYKhRaTG9tCQuFdCV28D9UVcBT
	WYfEeFaDxR/fx7n6UR0+n2E=
X-Google-Smtp-Source: ABdhPJz4iVX0Bfn2/xKEDVp/mXf3F0o1/6hYnthCSZOlZbSvlfZvDuA9Kd5G7XPIPXPyeqiXXIqzyA==
X-Received: by 2002:a17:902:ab98:: with SMTP id f24mr2090076plr.154.1592450322312;
        Wed, 17 Jun 2020 20:18:42 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [kvm-unit-tests PATCH] x86: Add control register pinning tests
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <ACCCF382-0077-4B08-8CF1-73C561F930CD@gmail.com>
Date: Wed, 17 Jun 2020 20:18:39 -0700
Cc: corbet@lwn.net,
 Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 mingo <mingo@redhat.com>,
 bp <bp@alien8.de>,
 hpa@zytor.com,
 shuah@kernel.org,
 sean.j.christopherson@intel.com,
 rick.p.edgecombe@intel.com,
 kvm@vger.kernel.org,
 kernel-hardening@lists.openwall.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <5D576A1A-AD52-4BB1-A514-1E6641982465@gmail.com>
References: <20200617224606.27954-1-john.s.andersen@intel.com>
 <ACCCF382-0077-4B08-8CF1-73C561F930CD@gmail.com>
To: John Andersen <john.s.andersen@intel.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)

> On Jun 17, 2020, at 3:52 PM, Nadav Amit <nadav.amit@gmail.com> wrote:
>=20
>> On Jun 17, 2020, at 3:46 PM, John Andersen =
<john.s.andersen@intel.com> wrote:
>>=20
>> Paravirutalized control register pinning adds MSRs guests can use to
>> discover which bits in CR0/4 they may pin, and MSRs for activating
>> pinning for any of those bits.
>=20
> [ sni[
>=20
>> +static void vmx_cr_pin_test_guest(void)
>> +{
>> +	unsigned long i, cr0, cr4;
>> +
>> +	/* Step 1. Skip feature detection to skip handling VMX_CPUID */
>> +	/* nop */
>=20
> I do not quite get this comment. Why do you skip checking whether the
> feature is enabled? What happens if KVM/bare-metal/other-hypervisor =
that
> runs this test does not support this feature?

My bad, I was confused between the nested checks and the non-nested =
ones.

Nevertheless, can we avoid situations in which
rdmsr(MSR_KVM_CR0_PIN_ALLOWED) causes #GP when the feature is not
implemented? Is there some protocol for detection that this feature is
supported by the hypervisor, or do we need something like rdmsr_safe()?

