Return-Path: <SRS0=QNdM=EB=lists.openwall.com=kernel-hardening-return-20274-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 163E8C388F9
	for <kernel-hardening@archiver.kernel.org>; Mon, 26 Oct 2020 16:32:32 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E5576206FB
	for <kernel-hardening@archiver.kernel.org>; Mon, 26 Oct 2020 16:32:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ilyK4nri"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E5576206FB
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20274-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 22122 invoked by uid 550); 26 Oct 2020 16:32:22 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 22087 invoked from network); 26 Oct 2020 16:32:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=81sFbAVwzGBYdqNxSKasnwihrmLk5qFx2xW7a2yOVFA=;
        b=ilyK4nriJpTU+ZsR5TzVNUPI2EICBAV+EtzdIfm0c8gnj9uEXsmcIlrH4esm52Sof5
         Z9W3RF1ohEzkLaXmgew/evfyvbKalDRv4wGUlakWh1vwJi+Holvp1iFQavUz7IIINteZ
         DXfWJqJcuIjSWoOYQlpTF8qMEVNtDnTAy14ZhUAoO6a9psISAvTf4eiGo88ojEk0OVOt
         DoluxxDfBapo4lA0C3ZHtuZ8p4Qzmm8/zACDjcDNBsCtA/MAYCoro7MwWTB4NW5u7X6u
         DympMB1G1hMAQePPLbaLhpIDiugGlLowk9LLdoo0k7DAhyw+bMfwmtOEMfW0IrE3liO8
         VgLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=81sFbAVwzGBYdqNxSKasnwihrmLk5qFx2xW7a2yOVFA=;
        b=Cl5i2qNkeZw4sWWkGZUUSboi9+AwMs2hp/90s+ODoiWmH4CIwaJ9xUPjdMKhJ45B5p
         Cl1+CRQwEV5IcmCSw5RqyM67JnPvkllLHBiyawWLiuJVquZkJHbiV673b7Zp08a1fIuw
         ugaDAwwBF3MjtOGBlQ2UE2kSMogI28xh7FH6M4loDU203DyKwiuK84pxw79TQhDP6qbL
         3ieNay9Mbaar23aI+bWudp1D+gi44vw6aHVTWQAQER1wGQ1RGl5cQHMKiDJlR3QULrpl
         cTbAkmHIu0MZd/yJVPmkzAs3SInDQmpRBFloW+8YHxe5/R4RLg+yVMV5iWsZuP10rFO0
         uoAg==
X-Gm-Message-State: AOAM532CY4YjId0iygRuyO2XF7bCCyGGXB+3BAIr8RJWJTfurw8A0rTM
	QtXKYrNCSJgCCkCbsGISGqg=
X-Google-Smtp-Source: ABdhPJyBBZepygrfLeS9IiJiGCwiL99FGQQQhPP2SALgITxO/hNm/8c7G2c/C1WBoQBEiojldvEEsA==
X-Received: by 2002:a2e:2ac6:: with SMTP id q189mr5924430ljq.269.1603729930410;
        Mon, 26 Oct 2020 09:32:10 -0700 (PDT)
Subject: Re: BTI interaction between seccomp filters in systemd and glibc
 mprotect calls, causing service failures
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: Kees Cook <keescook@chromium.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>,
 Jeremy Linton <jeremy.linton@arm.com>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, libc-alpha@sourceware.org,
 systemd-devel@lists.freedesktop.org,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Mark Brown <broonie@kernel.org>,
 Dave Martin <dave.martin@arm.com>, Will Deacon <will.deacon@arm.com>,
 Salvatore Mesoraca <s.mesoraca16@gmail.com>,
 kernel-hardening@lists.openwall.com, linux-hardening@vger.kernel.org
References: <8584c14f-5c28-9d70-c054-7c78127d84ea@arm.com>
 <20201022075447.GO3819@arm.com>
 <78464155-f459-773f-d0ee-c5bdbeb39e5d@gmail.com>
 <202010221256.A4F95FD11@keescook> <20201023090232.GA25736@gaia>
 <cf655c11-d854-281a-17ae-262ddf0aaa08@gmail.com> <20201026145245.GD3117@gaia>
From: Topi Miettinen <toiwoton@gmail.com>
Message-ID: <d7f45447-0f71-2855-98ac-6e873291ed09@gmail.com>
Date: Mon, 26 Oct 2020 18:31:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201026145245.GD3117@gaia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 26.10.2020 16.52, Catalin Marinas wrote:
> On Sat, Oct 24, 2020 at 02:01:30PM +0300, Topi Miettinen wrote:
>> On 23.10.2020 12.02, Catalin Marinas wrote:
>>> On Thu, Oct 22, 2020 at 01:02:18PM -0700, Kees Cook wrote:
>>>> Regardless, it makes sense to me to have the kernel load the executable
>>>> itself with BTI enabled by default. I prefer gaining Catalin's suggested
>>>> patch[2]. :)
>>> [...]
>>>> [2] https://lore.kernel.org/linux-arm-kernel/20201022093104.GB1229@gaia/
>>>
>>> I think I first heard the idea at Mark R ;).
>>>
>>> It still needs glibc changes to avoid the mprotect(), or at least ignore
>>> the error. Since this is an ABI change and we don't know which kernels
>>> would have it backported, maybe better to still issue the mprotect() but
>>> ignore the failure.
>>
>> What about kernel adding an auxiliary vector as a flag to indicate that BTI
>> is supported and recommended by the kernel? Then dynamic loader could use
>> that to detect that a) the main executable is BTI protected and there's no
>> need to mprotect() it and b) PROT_BTI flag should be added to all PROT_EXEC
>> pages.
> 
> We could add a bit to AT_FLAGS, it's always been 0 for Linux.

Great!

>> In absence of the vector, the dynamic loader might choose to skip doing
>> PROT_BTI at all (since the main executable isn't protected anyway either, or
>> maybe even the kernel is up-to-date but it knows that it's not recommended
>> for some reason, or maybe the kernel is so ancient that it doesn't know
>> about BTI). Optionally it could still read the flag from ELF later (for
>> compatibility with old kernels) and then do the mprotect() dance, which may
>> trip seccomp filters, possibly fatally.
> 
> I think the safest is for the dynamic loader to issue an mprotect() and
> ignore the EPERM error. Not all user deployments have this seccomp
> filter, so they can still benefit, and user can't tell whether the
> kernel change has been backported.

But the seccomp filter can be set to kill the process, so that's 
definitely not the safest way. I think safest is that when the AT_FLAGS 
bit is seen, ld.so doesn't do any mprotect() calls but instead when 
mapping the segments, mmap() flags are adjusted to include PROT_BTI, so 
mprotect() calls are not necessary. If there's no seccomp filter, 
there's no disadvantage for avoiding the useless mprotect() calls.

I'd expect the backported kernel change to include both aux vector and 
also using PROT_BTI for the main executable. Then the logic would work 
with backported kernels as well.

If there's no aux vector, all bets are off. The kernel could be old and 
unpatched, even so old that PROT_BTI is not known. Perhaps also in the 
future there may be new technologies which have replaced BTI and the 
kernel could want a previous generation ld.so not to try to use BTI, so 
this could be also indicated with the lack of aux vector. The dynamic 
loader could still attempt to mprotect() the pages, but that could be 
fatal. Getting to the point where the error can be ignored means that 
there's no seccomp filter, at least none set to kill. Perhaps the pain 
is only temporary, new or patched kernels should eventually replace the 
old versions.

> Now, if the dynamic loader silently ignores the mprotect() failure on
> the main executable, is there much value in exposing a flag in the aux
> vectors? It saves a few (one?) mprotect() calls but I don't think it
> matters much. Anyway, I don't mind the flag.

Saving a few system calls is indeed not an issue, but not being able to 
use MDWX and PROT_BTI simultaneously was the original problem (service 
failures).

-Topi
