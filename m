Return-Path: <SRS0=c12Z=D5=lists.openwall.com=kernel-hardening-return-20253-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4FDBFC388F9
	for <kernel-hardening@archiver.kernel.org>; Thu, 22 Oct 2020 23:34:22 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 28ABA24248
	for <kernel-hardening@archiver.kernel.org>; Thu, 22 Oct 2020 23:34:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ng91Tdl3"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 28ABA24248
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20253-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9849 invoked by uid 550); 22 Oct 2020 23:34:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32051 invoked from network); 22 Oct 2020 22:24:47 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=UkMo9YSByP/9a+a4AdI+yi1vCaJEUjkdx9AvlbGG/VA=;
        b=ng91Tdl3pBDoUkFKc2xVpnTG6o2MSBkFORHCAoFWFxOTuXcSSix3p48H5kxjR3nEWa
         AdVvc0c2ziFBrWsswAVwD1yD+S5SzTPqtfzqXo0aodkq+OiTrgVdN1/4GuKOdUqyUmQr
         +GRE7KLCrzhSUdATfpPd+h+gOp/E8oy30yyrWHiuTytbDUgoEFIP3XRcYPkG88+etdbU
         vNLQHlrvXgYoqwCfudllzcoqxrgW33i8LHTj89uBQjW5chudCu5CNynRRKRbBl+MZoXV
         TTOkrpS3bZ2Y3zJ3QgwHg33LdIYo3UBPzNPWNwaAlw1p/NaVd2Wp5fg6n9fJ4micW7KS
         /PYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=UkMo9YSByP/9a+a4AdI+yi1vCaJEUjkdx9AvlbGG/VA=;
        b=GpsmmlYCfc1KFjZ5goRG99C3qWgSiPdx5IGFmdZhXtkAERa53u1zRK6DxU1/seKpdI
         yV2c5srUdTM/85ZP85WrbY3JeNsJ7QOak5qjXdirNWK50uDobxcTkkPqhOMzu4x/axCQ
         tNsx+pqoF8ArtgWLMLMQtfroSyw/B2uL/mcf+4svTY6oiTkb12BCh6RFc0WBdV9QoEpb
         rKZLuPvMR7iRBl14Emlz3WIs3uBhtDACfzC1b5Thk4cfxsP+pQHrdkasUNxeEt7Yqyaf
         /9htGVTPyLQa0W0Se6ekiT7PNG7Idz/gTwu0icVp1YfwuotnZcFG6iQo2ShyedlgThdP
         LoEQ==
X-Gm-Message-State: AOAM531JTMRXX17TLF5ddu0UVcW3jba9rrCU1Wf3T+t0gfzeEj0Hrcs+
	kb0MBDMgws3RUvajcpTZh4A=
X-Google-Smtp-Source: ABdhPJx5YviZO9AmLfC4zO4HDKLBOEanXPu68ZVGSRTNYTaA44O+Q72epSPqVvZXgnaj8XxH5i8bEw==
X-Received: by 2002:a05:651c:1194:: with SMTP id w20mr1737072ljo.174.1603405475827;
        Thu, 22 Oct 2020 15:24:35 -0700 (PDT)
Subject: Re: BTI interaction between seccomp filters in systemd and glibc
 mprotect calls, causing service failures
To: Kees Cook <keescook@chromium.org>
Cc: Szabolcs Nagy <szabolcs.nagy@arm.com>,
 Jeremy Linton <jeremy.linton@arm.com>,
 "linux-arm-kernel@lists.infradead.org"
 <linux-arm-kernel@lists.infradead.org>, libc-alpha@sourceware.org,
 systemd-devel@lists.freedesktop.org,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Mark Brown <broonie@kernel.org>,
 Dave Martin <dave.martin@arm.com>, Catalin Marinas
 <Catalin.Marinas@arm.com>, Will Deacon <will.deacon@arm.com>,
 Salvatore Mesoraca <s.mesoraca16@gmail.com>,
 kernel-hardening@lists.openwall.com, linux-hardening@vger.kernel.org
References: <8584c14f-5c28-9d70-c054-7c78127d84ea@arm.com>
 <20201022075447.GO3819@arm.com>
 <78464155-f459-773f-d0ee-c5bdbeb39e5d@gmail.com>
 <202010221256.A4F95FD11@keescook>
From: Topi Miettinen <toiwoton@gmail.com>
Message-ID: <180cd894-d42d-2bdb-093c-b5360b0ecb1e@gmail.com>
Date: Fri, 23 Oct 2020 01:24:14 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <202010221256.A4F95FD11@keescook>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit

On 22.10.2020 23.02, Kees Cook wrote:
> On Thu, Oct 22, 2020 at 01:39:07PM +0300, Topi Miettinen wrote:
>> But I think SELinux has a more complete solution (execmem) which can track
>> the pages better than is possible with seccomp solution which has a very
>> narrow field of view. Maybe this facility could be made available to
>> non-SELinux systems, for example with prctl()? Then the in-kernel MDWX could
>> allow mprotect(PROT_EXEC | PROT_BTI) in case the backing file hasn't been
>> modified, the source filesystem isn't writable for the calling process and
>> the file descriptor isn't created with memfd_create().
> 
> Right. The problem here is that systemd is attempting to mediate a
> state change using only syscall details (i.e. with seccomp) instead of
> a stateful analysis. Using a MAC is likely the only sane way to do that.
> SELinux is a bit difficult to adjust "on the fly" the way systemd would
> like to do things, and the more dynamic approach seen with SARA[1] isn't
> yet in the kernel.

SARA looks interesting. What is missing is a prctl() to enable all W^X 
protections irrevocably for the current process, then systemd could 
enable it for services with MemoryDenyWriteExecute=yes.

I didn't also see specific measures against memfd_create() or file 
system W&X, but perhaps those can be added later. Maybe pkey_mprotect() 
is not handled either unless it uses the same LSM hook as mprotect().

> Trying to enforce memory W^X protection correctly
> via seccomp isn't really going to work well, as far as I can see.

Not in general, but I think it can work well in context of system 
services. Then you can ensure that for a specific service, 
memfd_create() is blocked by seccomp and the file systems are W^X 
because of mount namespaces etc., so there should not be any means to 
construct arbitrary executable pages.

-Topi
