Return-Path: <SRS0=Fx/N=77=lists.openwall.com=kernel-hardening-return-19013-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 402E9C433DF
	for <kernel-hardening@archiver.kernel.org>; Thu, 18 Jun 2020 06:59:36 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 91A6E21BE5
	for <kernel-hardening@archiver.kernel.org>; Thu, 18 Jun 2020 06:59:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="J4hQkWs6"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 91A6E21BE5
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19013-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25936 invoked by uid 550); 18 Jun 2020 06:59:28 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25911 invoked from network); 18 Jun 2020 06:59:27 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=RRb3SEPgwE9+d3AUs3WkB3zeBWXsniAzFBRNGXnO2Zo=;
        b=J4hQkWs6shQJssVgNa666DcxF0HicvkJiOaAcfsYKPSAo9mSvGPLEsA9xEEnPI0dji
         1fAkZOKl1kQ6Zhb73DEUcvCCL11SBcTCa90iTaAk9qZCKd1F8D2/3rVslYfiNk9/sWV2
         zv2SKB0uxVH9s02xNS9QPQtGhV+vh5a3eDG3omF0hWTb7q20GzHbCG2J9Tin98Xy/YyF
         bEcHq4vhRDszWYQ0YzlDeUkYArdFWsMbTeCDJbJphfcFzpzGuE/NI6+bAeON/2wnOEl3
         /F1/O3vvWBEJp0fn1226fDB0PxmU5GiSCoOKf/iShRDr9Ey5RGMcNRBKdT7wrDXujdjS
         Zw3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=RRb3SEPgwE9+d3AUs3WkB3zeBWXsniAzFBRNGXnO2Zo=;
        b=CX7eB/wuVt6AYMOGGP5E7ToOSOw79iA1au7GeYN6SneGewEowMbUHav9cgX5Kns/ik
         b9301QNBXU589ImQ9vdM9QSLL5O1IAiGzwKdQ9ZDGP570LL/rEsnTiYfy4ehTmeE+gYs
         VxrDWTYW796E9H8pL7UgymKCFGreHyeDNOEzr7WRaLK5kfRz8O5nDIaCCKdno8ccRY3b
         iF3uoujCf/1LQsfSX6klMbFsW3QHGDgiRDPSC73zHJNwYzLMNmO2/i5NllnLIAOAvz5m
         285a0GFr9b6o4u5KtCfoDa1d8h0YDVMdmzNy4hKmdlLSc9wHhbZ5EHKcasgf1LhPfgg1
         MkCw==
X-Gm-Message-State: AOAM530BHJAApltivWoDF9PtQJenokBL6zQlsFgCe5aLwEa/enm62CEf
	SwqJ09nlC/J5RC/+/21iw68=
X-Google-Smtp-Source: ABdhPJwvBrZ7lux26GhYbq3Xge/k+w4GsLSS26rCvDmOg8z9eUhdmm7/C1a4JBGRy2G7s2GnBuWrpw==
X-Received: by 2002:a17:902:9309:: with SMTP id bc9mr2610438plb.232.1592463554870;
        Wed, 17 Jun 2020 23:59:14 -0700 (PDT)
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 13.4 \(3608.80.23.2.2\))
Subject: Re: [kvm-unit-tests PATCH] x86: Add control register pinning tests
From: Nadav Amit <nadav.amit@gmail.com>
In-Reply-To: <20200618050834.GA23@0d4958db2004>
Date: Wed, 17 Jun 2020 23:59:10 -0700
Cc: corbet@lwn.net,
 Paolo Bonzini <pbonzini@redhat.com>,
 Thomas Gleixner <tglx@linutronix.de>,
 mingo <mingo@redhat.com>,
 bp <bp@alien8.de>,
 hpa@zytor.com,
 shuah@kernel.org,
 Sean Christopherson <sean.j.christopherson@intel.com>,
 rick.p.edgecombe@intel.com,
 kvm <kvm@vger.kernel.org>,
 kernel-hardening@lists.openwall.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <FAFB5DA6-FA6F-4A1A-AB10-4B99F314B23D@gmail.com>
References: <20200617224606.27954-1-john.s.andersen@intel.com>
 <ACCCF382-0077-4B08-8CF1-73C561F930CD@gmail.com>
 <5D576A1A-AD52-4BB1-A514-1E6641982465@gmail.com>
 <20200618050834.GA23@0d4958db2004>
To: "Andersen, John" <john.s.andersen@intel.com>
X-Mailer: Apple Mail (2.3608.80.23.2.2)

> On Jun 17, 2020, at 10:08 PM, Andersen, John =
<john.s.andersen@intel.com> wrote:
>=20
> On Wed, Jun 17, 2020 at 08:18:39PM -0700, Nadav Amit wrote:
>>> On Jun 17, 2020, at 3:52 PM, Nadav Amit <nadav.amit@gmail.com> =
wrote:
>>>=20
>>>> On Jun 17, 2020, at 3:46 PM, John Andersen =
<john.s.andersen@intel.com> wrote:
>>>>=20
>>>> Paravirutalized control register pinning adds MSRs guests can use =
to
>>>> discover which bits in CR0/4 they may pin, and MSRs for activating
>>>> pinning for any of those bits.
>>>=20
>>> [ sni[
>>>=20
>>>> +static void vmx_cr_pin_test_guest(void)
>>>> +{
>>>> +	unsigned long i, cr0, cr4;
>>>> +
>>>> +	/* Step 1. Skip feature detection to skip handling VMX_CPUID */
>>>> +	/* nop */
>>>=20
>>> I do not quite get this comment. Why do you skip checking whether =
the
>>> feature is enabled? What happens if KVM/bare-metal/other-hypervisor =
that
>>> runs this test does not support this feature?
>>=20
>> My bad, I was confused between the nested checks and the non-nested =
ones.
>>=20
>> Nevertheless, can we avoid situations in which
>> rdmsr(MSR_KVM_CR0_PIN_ALLOWED) causes #GP when the feature is not
>> implemented? Is there some protocol for detection that this feature =
is
>> supported by the hypervisor, or do we need something like =
rdmsr_safe()?
>=20
> Ah, yes we can. By checking the CPUID for the feature bit. Thanks for =
pointing
> this out, I was confused about this. I was operating under the =
assumption that
> the unit tests assume the features in the latest kvm/next are present =
and
> available when the unit tests are being run.
>=20
> I'm happy to add the check, but I haven't see anywhere else where a
> KVM_FEATURE_ was checked for. Which is why it doesn't check in this =
patch. As
> soon as I get an answer from you or anyone else as to if the unit =
tests assume
> that the features in the latest kvm/next are present and available or =
not when
> the unit tests are being run I'll modify if necessary.

I would appreciate if you add a check of CPUID and not run the test if =
the=20
feature is not supported.

I run the tests on bare-metal (and other non-KVM environment) from time =
to
time. Doing so allows to find bugs in tests due to wrong assumptions of =
KVM
test developers. Liran runs the tests using QEMU/WHPX (non-KVM). So =
allowing
the tests to run on non-KVM environments is important, at least for some =
of
us, and benefits KVM as well.

While I can disable this specific test using the test parameters, I =
prefer
that the test will first check the environment they run on. Debugging =
test
failures on bare-metal is hard enough without the paravirt stuff noise.

