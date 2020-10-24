Return-Path: <SRS0=pOIm=D7=lists.openwall.com=kernel-hardening-return-20260-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA597C4363A
	for <kernel-hardening@archiver.kernel.org>; Sat, 24 Oct 2020 11:02:13 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id ABEFC24248
	for <kernel-hardening@archiver.kernel.org>; Sat, 24 Oct 2020 11:02:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="RB4Ifw11"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org ABEFC24248
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20260-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 7829 invoked by uid 550); 24 Oct 2020 11:02:03 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 7787 invoked from network); 24 Oct 2020 11:02:03 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=J7AXGwZjHBo0cvQ8nOxRhJ0Ve52DSlFqmlnOi+p9Ml4=;
        b=RB4Ifw11Et8ewDdQ71Y1JyrVaP+QLMh5l+oakjdrwQqGAl+nHe8uPPEeSLuG61NzR1
         sNlfoKNM/zeyich0IQ1x7luJpp1P6jMpoTUVVoSPsU2FWKW0VjThcIA/BY+ubptMqYcP
         3TX7OTFWPFRQe36AXd0enGK0j7/iTZ0RkxsX4jm9C4QkD6paQFYN5MRRUIcmOvvXluLO
         aJBFFdJLrm9qiUoerblrXizM7ULYrs0ROpLNN1rvpc2qY2j+u0jYs0g9nhxBGIYcPuLh
         RlMyDCwNUtdirjqOiqSuOweLQ7UgzXjflCcohOUD/148FRKfYGfxCgeHAR6lJU/HzaV8
         Ampg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=J7AXGwZjHBo0cvQ8nOxRhJ0Ve52DSlFqmlnOi+p9Ml4=;
        b=htx0YWd6b+cPC8IrPIgg7BtQlx3JowwN8B1ZpYF0/TNm2Yso3bxjD59hu69aofSehg
         X+OpMyGkrbSjIKJxXPCcShSgFtK0NFHOwZkhuCW0o5cfYexMreY+C3kEs+RXstzsY7PH
         rhr3HM9Zs8ur+WoQrsSdicum8RrjoWzib8h1SPyu0JZz3BPmAcESO9m2SaDBf3dGOR8s
         Uxd/mwReDRR6PvtDrfkMobcaJz4JC88PnCslk0z/eKpVof+vwY5ayT3p8ollRCRNhhEK
         W5Fj3OvYNnSZdbkXzunOAuCRYhrflQc8XDh7cGhA1wM2Zt2Iyxo0uS+x7oHfROnrw/aL
         bAQg==
X-Gm-Message-State: AOAM532/Nor445eXb1O51BluwSA78wr6bk2TY+YjLu5pHutqSbORqaW2
	XTH8OmN1ox7Y5WbzjznHaug=
X-Google-Smtp-Source: ABdhPJziG/fPpVvjAmCunEwpSNa2+UJyviag/t3AiZqI88dIphjawUEOM+KFCId+O3zeCfP2ehG6zg==
X-Received: by 2002:a2e:8997:: with SMTP id c23mr2256835lji.132.1603537311739;
        Sat, 24 Oct 2020 04:01:51 -0700 (PDT)
Subject: Re: BTI interaction between seccomp filters in systemd and glibc
 mprotect calls, causing service failures
To: Catalin Marinas <catalin.marinas@arm.com>,
 Kees Cook <keescook@chromium.org>
Cc: Szabolcs Nagy <szabolcs.nagy@arm.com>,
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
From: Topi Miettinen <toiwoton@gmail.com>
Message-ID: <cf655c11-d854-281a-17ae-262ddf0aaa08@gmail.com>
Date: Sat, 24 Oct 2020 14:01:30 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201023090232.GA25736@gaia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 23.10.2020 12.02, Catalin Marinas wrote:
> On Thu, Oct 22, 2020 at 01:02:18PM -0700, Kees Cook wrote:
>> Regardless, it makes sense to me to have the kernel load the executable
>> itself with BTI enabled by default. I prefer gaining Catalin's suggested
>> patch[2]. :)
> [...]
>> [2] https://lore.kernel.org/linux-arm-kernel/20201022093104.GB1229@gaia/
> 
> I think I first heard the idea at Mark R ;).
> 
> It still needs glibc changes to avoid the mprotect(), or at least ignore
> the error. Since this is an ABI change and we don't know which kernels
> would have it backported, maybe better to still issue the mprotect() but
> ignore the failure.

What about kernel adding an auxiliary vector as a flag to indicate that 
BTI is supported and recommended by the kernel? Then dynamic loader 
could use that to detect that a) the main executable is BTI protected 
and there's no need to mprotect() it and b) PROT_BTI flag should be 
added to all PROT_EXEC pages.

In absence of the vector, the dynamic loader might choose to skip doing 
PROT_BTI at all (since the main executable isn't protected anyway 
either, or maybe even the kernel is up-to-date but it knows that it's 
not recommended for some reason, or maybe the kernel is so ancient that 
it doesn't know about BTI). Optionally it could still read the flag from 
ELF later (for compatibility with old kernels) and then do the 
mprotect() dance, which may trip seccomp filters, possibly fatally.

-Topi
