Return-Path: <SRS0=sX3Z=7X=lists.openwall.com=kernel-hardening-return-18951-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F2D4C433E1
	for <kernel-hardening@archiver.kernel.org>; Wed, 10 Jun 2020 15:24:49 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id A06D520734
	for <kernel-hardening@archiver.kernel.org>; Wed, 10 Jun 2020 15:24:48 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A06D520734
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=linux.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18951-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24494 invoked by uid 550); 10 Jun 2020 15:24:42 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24474 invoked from network); 10 Jun 2020 15:24:41 -0000
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=w3siWejRAPilHiUC6jsI5xYy2gYaS5P9S9XuSxXXOMQ=;
        b=IPfLPR8SxDzN+BcVia4GKXWm22nvXSVN1ndyM6p0JN7Cv8Ho71iGwXhRPgm5UVhzIc
         kdZ6c2LVKfTFEoMVW/7THaek8aKbvBdK6Xu9xSZFFMDg176naC1l0ljndS5jJiXq/Q6w
         Ux4lkRiPYVJ+UnOcq6e9l0CGLpucFCsl0WFAZOu62Y0E2Cj8lE7dGQOgKNajK/gSBiiB
         NYcRTxyJ+cDlWgqwYOCUkSNAIyTvn5X1Mih4PguCmRji0lii/zlgqpg4ZrCoe86+Gmiq
         C9s6bWBDYH7HAUjB0XlHKyRTVs+pruGaEIS7PMJ+PtfhZOhDoF+ZhOujHtJ1yAIGrzAB
         UDTQ==
X-Gm-Message-State: AOAM530ZAnjxV+g+XoJS/lDzb09YD0lusBzbECMTCL46I0uipE8g0Uwe
	6uMCjUTVPUPvrae90+V+kTA=
X-Google-Smtp-Source: ABdhPJxowAcpKm07CSV2XZBXzUPwDoILgauuX3JgUNqRvEamsMNgGVkLU/8gw9B1bFDjcmHx26rgIA==
X-Received: by 2002:a05:651c:2d0:: with SMTP id f16mr1971844ljo.387.1591802670288;
        Wed, 10 Jun 2020 08:24:30 -0700 (PDT)
Subject: Re: [PATCH 1/5] gcc-plugins/stackleak: Exclude alloca() from the
 instrumentation logic
To: Kees Cook <keescook@chromium.org>
Cc: Jann Horn <jannh@google.com>, Elena Reshetova
 <elena.reshetova@intel.com>, Emese Revfy <re.emese@gmail.com>,
 Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>,
 Masahiro Yamada <masahiroy@kernel.org>,
 Michal Marek <michal.lkml@markovi.net>,
 Andrew Morton <akpm@linux-foundation.org>,
 Masahiro Yamada <yamada.masahiro@socionext.com>,
 Thiago Jung Bauermann <bauerman@linux.ibm.com>,
 Luis Chamberlain <mcgrof@kernel.org>, Jessica Yu <jeyu@kernel.org>,
 Sven Schnelle <svens@stackframe.org>, Iurii Zaikin <yzaikin@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Thomas Gleixner <tglx@linutronix.de>, Peter Collingbourne <pcc@google.com>,
 Naohiro Aota <naohiro.aota@wdc.com>, Alexander Monakov <amonakov@ispras.ru>,
 Mathias Krause <minipli@googlemail.com>, PaX Team <pageexec@freemail.hu>,
 Brad Spengler <spender@grsecurity.net>, Laura Abbott <labbott@redhat.com>,
 Florian Weimer <fweimer@redhat.com>,
 Kernel Hardening <kernel-hardening@lists.openwall.com>,
 linux-kbuild@vger.kernel.org, the arch/x86 maintainers <x86@kernel.org>,
 Linux ARM <linux-arm-kernel@lists.infradead.org>,
 kernel list <linux-kernel@vger.kernel.org>, gcc@gcc.gnu.org,
 notify@kernel.org
References: <20200604134957.505389-1-alex.popov@linux.com>
 <20200604134957.505389-2-alex.popov@linux.com>
 <CAG48ez05JOvqzYGr3PvyQGwFURspFWvNvf-b8Y613PX0biug8w@mail.gmail.com>
 <70319f78-2c7c-8141-d751-07f28203db7c@linux.com>
 <202006091133.412F0E89@keescook>
From: Alexander Popov <alex.popov@linux.com>
Autocrypt: addr=alex.popov@linux.com; prefer-encrypt=mutual; keydata=
 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
 j3lCqPk=
Message-ID: <3b194cd9-909d-7186-0cc4-bf0a0358fe5d@linux.com>
Date: Wed, 10 Jun 2020 18:24:20 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <202006091133.412F0E89@keescook>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 09.06.2020 21:39, Kees Cook wrote:
> On Thu, Jun 04, 2020 at 06:23:38PM +0300, Alexander Popov wrote:
>> On 04.06.2020 17:01, Jann Horn wrote:
>>> On Thu, Jun 4, 2020 at 3:51 PM Alexander Popov <alex.popov@linux.com> wrote:
>>>> Some time ago Variable Length Arrays (VLA) were removed from the kernel.
>>>> The kernel is built with '-Wvla'. Let's exclude alloca() from the
>>>> instrumentation logic and make it simpler. The build-time assertion
>>>> against alloca() is added instead.
>>> [...]
>>>> +                       /* Variable Length Arrays are forbidden in the kernel */
>>>> +                       gcc_assert(!is_alloca(stmt));
>>>
>>> There is a patch series from Elena and Kees on the kernel-hardening
>>> list that deliberately uses __builtin_alloca() in the syscall entry
>>> path to randomize the stack pointer per-syscall - see
>>> <https://lore.kernel.org/kernel-hardening/20200406231606.37619-4-keescook@chromium.org/>.
>>
>> Thanks, Jann.
>>
>> At first glance, leaving alloca() handling in stackleak instrumentation logic
>> would allow to integrate stackleak and this version of random_kstack_offset.
> 
> Right, it seems there would be a need for this coverage to remain,
> otherwise the depth of stack erasure might be incorrect.
> 
> It doesn't seem like the other patches strictly depend on alloca()
> support being removed, though?

Ok, I will leave alloca() support, reorganize the patch series and send v2.

>> Kees, Elena, did you try random_kstack_offset with upstream stackleak?
> 
> I didn't try that combination yet, no. It seemed there would likely
> still be further discussion about the offset series first (though the
> thread has been silent -- I'll rebase and resend it after rc2).

Ok, please add me to CC list.

Best regards,
Alexander

>> It looks to me that without stackleak erasing random_kstack_offset can be
>> weaker. I mean, if next syscall has a bigger stack randomization gap, the data
>> on thread stack from the previous syscall is not overwritten and can be used. Am
>> I right?
> 
> That's correct. I think the combination is needed, but I don't think
> they need to be strictly tied together.
> 
>> Another aspect: CONFIG_STACKLEAK_METRICS can be used for guessing kernel stack
>> offset, which is bad. It should be disabled if random_kstack_offset is on.
> 
> Agreed.

