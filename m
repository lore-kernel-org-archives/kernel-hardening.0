Return-Path: <SRS0=O/Tj=LJ=lists.openwall.com=kernel-hardening-return-21305-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2207EC48BE5
	for <kernel-hardening@archiver.kernel.org>; Tue, 15 Jun 2021 19:16:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 47E586109E
	for <kernel-hardening@archiver.kernel.org>; Tue, 15 Jun 2021 19:16:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 47E586109E
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21305-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 28562 invoked by uid 550); 15 Jun 2021 19:16:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 17444 invoked from network); 15 Jun 2021 18:51:21 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=QojazdBWoM3SyAlRdVHgqcAEHJPhAD/lO190hYA/8jw=;
        b=keYPy5Ik8+o66m6E25AGSE/i051lEKyA7J37a24FhFdDO+zv5FEgFaR9O03PJ1iQWC
         rivCZbjUHnzjLG67BYdOEW9k3DlTpVilMw7prbTimR5sju+pTpc0bqkk9sNNJo0g2NYH
         +tQqnRDPbUyABwcAqU+H0EY5xFOgIlUVk7N2FY+xmUXHMbnn6FFl3im0LV3xsT6hHSc1
         j4WroaJNJbp4Jl68hvVssfgRfioRbqQhcsBwHsXHwdqP+GT/9N4E2IHpVjhYRqjRs675
         kemdVE3OdgzrWMM2DYxy/Hmw9LEbi7Lojr6gze/7EZSGLIy3DZqPN2oAkaTujgKXgnCR
         /tJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=QojazdBWoM3SyAlRdVHgqcAEHJPhAD/lO190hYA/8jw=;
        b=b1KgBOHm6xrVXweReW8fNMFxUS2J8iQF/a7qbLjqCq7p4qTyjb7wxtIyhz1jvPdZNp
         EOSgL0mPIz63W4rW+DExOgwCYB+8YYOSJFFmCBO7NdO80mJDFCFoOELSzfMT1heh8VWy
         fbjZclMnpUcAav0+YMWgCBcPD4aA/ffbwzBg0HqWJxPSz+WIkrQIULD59a00+MfkT7ra
         H6hEd4dAFf3SF8PpF6/iBbGFeK1ddUkUajEIPR2D2WqdDVxozqGRIA5sOPoHMT25zakI
         Mhxl3YGX8tafeDfE/RrnAoE/5wYfEvox8lbAXo7RaR/jYUNChxKJt3uBBDuqKulP+rdp
         8/fQ==
X-Gm-Message-State: AOAM5335rTSvzb83+jR0P20l6mSb7dlp0xaZVWyL+hKxs4Yc9Yo0hlSq
	1EYhOqFJNAeH55tQlGOdSX4=
X-Google-Smtp-Source: ABdhPJwB6XJA9CTa5qdtOSQ4XzUu9peP7FYU4f0dbek7wM8P79YQW/nuPW3hilLe77UeROzfim0Hdg==
X-Received: by 2002:a5d:658a:: with SMTP id q10mr618994wru.258.1623783069593;
        Tue, 15 Jun 2021 11:51:09 -0700 (PDT)
Subject: Re: [PATCH v5] bpf: core: fix shift-out-of-bounds in ___bpf_prog_run
To: Kurt Manucredo <fuzzybritches0@gmail.com>, ebiggers@kernel.org,
 syzbot+bed360704c521841c85d@syzkaller.appspotmail.com
Cc: keescook@chromium.org, yhs@fb.com, dvyukov@google.com, andrii@kernel.org,
 ast@kernel.org, bpf@vger.kernel.org, daniel@iogearbox.net,
 davem@davemloft.net, hawk@kernel.org, john.fastabend@gmail.com,
 kafai@fb.com, kpsingh@kernel.org, kuba@kernel.org,
 linux-kernel@vger.kernel.org, netdev@vger.kernel.org, songliubraving@fb.com,
 syzkaller-bugs@googlegroups.com, nathan@kernel.org, ndesaulniers@google.com,
 clang-built-linux@googlegroups.com, kernel-hardening@lists.openwall.com,
 kasan-dev@googlegroups.com
References: <87609-531187-curtm@phaethon>
 <6a392b66-6f26-4532-d25f-6b09770ce366@fb.com>
 <CAADnVQKexxZQw0yK_7rmFOdaYabaFpi2EmF6RGs5bXvFHtUQaA@mail.gmail.com>
 <CACT4Y+b=si6NCx=nRHKm_pziXnVMmLo-eSuRajsxmx5+Hy_ycg@mail.gmail.com>
 <202106091119.84A88B6FE7@keescook>
 <752cb1ad-a0b1-92b7-4c49-bbb42fdecdbe@fb.com>
 <CACT4Y+a592rxFmNgJgk2zwqBE8EqW1ey9SjF_-U3z6gt3Yc=oA@mail.gmail.com>
 <1aaa2408-94b9-a1e6-beff-7523b66fe73d@fb.com> <202106101002.DF8C7EF@keescook>
 <CAADnVQKMwKYgthoQV4RmGpZm9Hm-=wH3DoaNqs=UZRmJKefwGw@mail.gmail.com>
 <85536-177443-curtm@phaethon>
From: Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <bac16d8d-c174-bdc4-91bd-bfa62b410190@gmail.com>
Date: Tue, 15 Jun 2021 19:51:07 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <85536-177443-curtm@phaethon>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit

On 15/06/2021 17:42, Kurt Manucredo wrote:
> Syzbot detects a shift-out-of-bounds in ___bpf_prog_run()
> kernel/bpf/core.c:1414:2.
> 
> The shift-out-of-bounds happens when we have BPF_X. This means we have
> to go the same way we go when we want to avoid a divide-by-zero. We do
> it in do_misc_fixups().

Shifts by more than insn_bitness are legal in the eBPF ISA; they are
 implementation-defined behaviour, rather than UB, and have been made
 legal for performance reasons.  Each of the JIT backends compiles the
 eBPF shift operations to machine instructions which produce
 implementation-defined results in such a case; the resulting contents
 of the register may be arbitrary but program behaviour as a whole
 remains defined.
Guard checks in the fast path (i.e. affecting JITted code) will thus
 not be accepted.
The case of division by zero is not truly analogous, as division
 instructions on many of the JIT-targeted architectures will raise a
 machine exception / fault on division by zero, whereas (to the best of
 my knowledge) none will do so on an out-of-bounds shift.
(That said, it would be possible to record from the verifier division
 instructions in the program which are known never to be passed zero as
 divisor, and eliding the fixup patch in those cases.  However, the
 extra complexity may not be worthwhile.)

As I understand it, the UBSAN report is coming from the eBPF interpreter,
 which is the *slow path* and indeed on many production systems is
 compiled out for hardening reasons (CONFIG_BPF_JIT_ALWAYS_ON).
Perhaps a better approach to the fix would be to change the interpreter
 to compute "DST = DST << (SRC & 63);" (and similar for other shifts and
 bitnesses), thus matching the behaviour of most chips' shift opcodes.
This would shut up UBSAN, without affecting JIT code generation.

-ed
