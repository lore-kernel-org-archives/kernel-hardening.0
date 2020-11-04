Return-Path: <SRS0=0ELb=EK=lists.openwall.com=kernel-hardening-return-20351-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B39DAC2D0A3
	for <kernel-hardening@archiver.kernel.org>; Wed,  4 Nov 2020 09:56:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A5C0E20735
	for <kernel-hardening@archiver.kernel.org>; Wed,  4 Nov 2020 09:56:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="k14IQwEm"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A5C0E20735
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20351-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9971 invoked by uid 550); 4 Nov 2020 09:56:14 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9948 invoked from network); 4 Nov 2020 09:56:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=H/Piybnri0KvjBLh2YcL64mPZyCiqFVi1MfXWajtlaM=;
        b=k14IQwEmiajGjP8KfCafHwcRKINn6x7+hcfsBIAlNRUmV7KJZpo6QNY1S5IUTR+pKM
         OVklo7Lt20KN1Dl/2Ehc1OMCTc8fQb2IBKvNJ/tuo+qO/oF/W2XWLxYHggF0hPEJZhje
         IA3rTa65akyo07p9f6lGSxKQXCxApe2YqiYAwu2PDep3F9BPZuX2OHGovc3HEevhWOhm
         Mb5zCPFYy8gu4QwQxVd+0Bl4leKQDwhKF+NIUhLNvYU6IaTaNiOwV51lqTs3OrOmZCYB
         JfbIiD6Dglr58lO/1+61y7cCn7XGDAilwU5ain8WojrJry6fWfvwNNQAt0N3O+JLLcKB
         V47Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=H/Piybnri0KvjBLh2YcL64mPZyCiqFVi1MfXWajtlaM=;
        b=pSMDzujm2JgvMsv2XD0yNZ2hLGENmy+iuMEyjQ7Mi3OMId+3vu0BQR9+j6DMffhxSO
         LlmobBWjYo/uIN+IraB7J93CrBGVoAWV3fKLlq3O17gtqGGGEAYcGLoWlBFoo7rCIDt4
         FxfYjqidEbyLBky/h+oPLIBuT+E2HJ70gJMfvNR+HdmalV7nCrU+ZGH4AK8jHrYELiOR
         JdJ9/i6I/jFy+CoojE5EkKqzeKWKsWI/AYm61gzkLXQOj0Y2SdWGxjoEvrih0Wy3dW1u
         aHE1bU+FehJ/ixwSZgahf9mqL/Dit7SffraqOY1Ohsx1sm/y9V/1TIO4cfgk0TMQhmS9
         g/xA==
X-Gm-Message-State: AOAM530b0TMoCBkRpZUyLYALy5NCT6LRpSVT8PJePqwxJJGrwPbWfX1T
	pqjohq1w7sYICPSJ+cLIFHU=
X-Google-Smtp-Source: ABdhPJwHI2gk6VHp6DNkwO0HXNvbI6lC+cpZGZLfcD7oHjjfjg/Xa9O2Sve3HOQopC4jnzl2cJOhNg==
X-Received: by 2002:a05:6512:547:: with SMTP id h7mr10361849lfl.132.1604483763075;
        Wed, 04 Nov 2020 01:56:03 -0800 (PST)
Subject: Re: [PATCH 0/4] aarch64: avoid mprotect(PROT_BTI|PROT_EXEC) [BZ
 #26831]
To: Florian Weimer <fweimer@redhat.com>, Will Deacon <will@kernel.org>
Cc: Mark Brown <broonie@kernel.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>,
 libc-alpha@sourceware.org, Jeremy Linton <jeremy.linton@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>,
 Salvatore Mesoraca <s.mesoraca16@gmail.com>,
 Lennart Poettering <mzxreary@0pointer.de>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com,
 linux-hardening@vger.kernel.org
References: <cover.1604393169.git.szabolcs.nagy@arm.com>
 <20201103173438.GD5545@sirena.org.uk>
 <20201104092012.GA6439@willie-the-truck>
 <87h7q54ghy.fsf@oldenburg2.str.redhat.com>
From: Topi Miettinen <toiwoton@gmail.com>
Message-ID: <d2f51a90-c5d6-99bd-35b8-f4fded073f95@gmail.com>
Date: Wed, 4 Nov 2020 11:55:57 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <87h7q54ghy.fsf@oldenburg2.str.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit

On 4.11.2020 11.29, Florian Weimer wrote:
> * Will Deacon:
> 
>> Is there real value in this seccomp filter if it only looks at mprotect(),
>> or was it just implemented because it's easy to do and sounds like a good
>> idea?
> 
> It seems bogus to me.  Everyone will just create alias mappings instead,
> just like they did for the similar SELinux feature.  See “Example code
> to avoid execmem violations” in:
> 
>    <https://www.akkadia.org/drepper/selinux-mem.html>

Also note "But this is very dangerous: programs should never use memory 
regions which are writable and executable at the same time. Assuming 
that it is really necessary to generate executable code while the 
program runs the method employed should be reconsidered."

> As you can see, this reference implementation creates a PROT_WRITE
> mapping aliased to a PROT_EXEC mapping, so it actually reduces security
> compared to something that generates the code in an anonymous mapping
> and calls mprotect to make it executable.

Drepper's methods to avoid SELinux protections are indeed the two ways 
(which I'm aware) to also avoid the seccomp filter: by using 
memfd_create() and using a file system which writable and executable to 
the process to create a new executable file. Both methods can be 
eliminated for many system services, memfd_create() with seccomp and 
filesystem W&X with mount namespaces.

If a service legitimately needs executable and writable mappings (due to 
JIT, trampolines etc), it's easy to disable the filter whenever really 
needed with "MemoryDenyWriteExecute=no" (which is the default) in case 
of systemd or a TE rule like "allow type_t self:process { execmem };" 
for SELinux. But this shouldn't be the default case, since there are 
many services which don't need W&X.

I'd also question what is the value of BTI if it can be easily 
circumvented by removing PROT_BTI with mprotect()?

-Topi
