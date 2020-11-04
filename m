Return-Path: <SRS0=jQa8=EK=lists.openwall.com=kernel-hardening-return-20348-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 41483C388F7
	for <kernel-hardening@archiver.kernel.org>; Wed,  4 Nov 2020 09:02:56 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 2D3132220B
	for <kernel-hardening@archiver.kernel.org>; Wed,  4 Nov 2020 09:02:54 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="r3rL2JTF"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 2D3132220B
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20348-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 24241 invoked by uid 550); 4 Nov 2020 09:02:48 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 24221 invoked from network); 4 Nov 2020 09:02:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=cUfqmk4CS+f0MkoXlQUbUwaniISb0nfd1xI3bjYQruE=;
        b=r3rL2JTFlXYhTBb+MVUgBXn7F05AIlcOzdjKcGAX51JLWJo285Gp8AGwKdb2pmyQ4W
         T87cjxMDq4ETiJJjub3xI/zmbBarCKI3/y2WV3KHlNTZpiQDkyy6dBzvJl+BRdckoyOa
         6/QgtfC4icr20ZJkpymjgIY254pLlNx3RlbeCUBf0fgcVz75lTcEVO3YIIzROC/ywQNo
         7I6REbAONEQrMeoi6GSVLazLawcFAFai2eGZORNJ3YSc6bE5Hxar8EgbGf3/TCS9wEPK
         J9tWU/53KOLYNYGBC9U2NvgsAumAhgsEtRb8FX9C/cO08cFQeH+djmG365tfMG72T3eW
         rjYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=cUfqmk4CS+f0MkoXlQUbUwaniISb0nfd1xI3bjYQruE=;
        b=JSFHNY9Rods2Z4FFO7C1/eh2t/TsxwDLjG/rbEzO3OvDl6jOyiVzItxHTbIoFp5e7F
         28cni+zcbCyLOdjUg37nSp/eeFEi041eUMWOfjqRqF6btMeMnte7yvHQXJkfbEGwTDZq
         we1ECj59tLzr7c0emxwFPNpTPoTcROWgrA4BYE3EaLDneahZi6fnmmnSUSM7q6As8n00
         9CJOPSSsvqo60MdeonbQaVqwSkCVzx1IFlbCub3M68TyYGK8CWYeBqZHfWC2H7xzOPz7
         JbzABMhht6lePusNz8YMto39/LoeY0Wty9qaTNj+FE3zN+VepgXtnHDQ4u2+xA3N9YQW
         1j3A==
X-Gm-Message-State: AOAM532Nq41PEYerqaJSSH56jeUnIhqPUVModNsCd/HI2A9dGt2OWZUC
	Vs2pWsWWyX2z2iS48c8UXbk=
X-Google-Smtp-Source: ABdhPJyhcqd4yRgKGAJDY0HD2ZbWObiFhbBhAkTQ+PRtTbuTm/eKn39jhR+ek9tM2v2eK3mBpnHB9A==
X-Received: by 2002:a19:c013:: with SMTP id q19mr842930lff.96.1604480556236;
        Wed, 04 Nov 2020 01:02:36 -0800 (PST)
Subject: Re: [PATCH 0/4] aarch64: avoid mprotect(PROT_BTI|PROT_EXEC) [BZ
 #26831]
To: Mark Brown <broonie@kernel.org>, Szabolcs Nagy <szabolcs.nagy@arm.com>
Cc: libc-alpha@sourceware.org, Jeremy Linton <jeremy.linton@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Mark Rutland <mark.rutland@arm.com>, Will Deacon <will@kernel.org>,
 Florian Weimer <fweimer@redhat.com>, Kees Cook <keescook@chromium.org>,
 Salvatore Mesoraca <s.mesoraca16@gmail.com>,
 Lennart Poettering <mzxreary@0pointer.de>, linux-kernel@vger.kernel.org,
 linux-arm-kernel@lists.infradead.org, kernel-hardening@lists.openwall.com,
 linux-hardening@vger.kernel.org
References: <cover.1604393169.git.szabolcs.nagy@arm.com>
 <20201103173438.GD5545@sirena.org.uk>
From: Topi Miettinen <toiwoton@gmail.com>
Message-ID: <060292c1-5ce5-0183-8500-c92063351a69@gmail.com>
Date: Wed, 4 Nov 2020 11:02:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <20201103173438.GD5545@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 3.11.2020 19.34, Mark Brown wrote:
> On Tue, Nov 03, 2020 at 10:25:37AM +0000, Szabolcs Nagy wrote:
> 
>> Re-mmap executable segments instead of mprotecting them in
>> case mprotect is seccomp filtered.
> 
>> For the kernel mapped main executable we don't have the fd
>> for re-mmap so linux needs to be updated to add BTI. (In the
>> presence of seccomp filters for mprotect(PROT_EXEC) the libc
>> cannot change BTI protection at runtime based on user space
>> policy so it is better if the kernel maps BTI compatible
>> binaries with PROT_BTI by default.)
> 
> Given that there were still some ongoing discussions on a more robust
> kernel interface here and there seem to be a few concerns with this
> series should we perhaps just take a step back and disable this seccomp
> filter in systemd on arm64, at least for the time being?

Filtering mprotect() and mmap() with seccomp also protects BTI, since 
without it the attacker could remove PROT_BTI from existing pages, or 
map new pages without BTI. This would be possible even with SARA or 
SELinux execmem protections enabled, since they don't care about PROT_BTI.

-Topi
