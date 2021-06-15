Return-Path: <SRS0=eK4s=LJ=lists.openwall.com=kernel-hardening-return-21312-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBE91C48BDF
	for <kernel-hardening@archiver.kernel.org>; Tue, 15 Jun 2021 23:01:53 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B7E9761055
	for <kernel-hardening@archiver.kernel.org>; Tue, 15 Jun 2021 23:01:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B7E9761055
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21312-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 26402 invoked by uid 550); 15 Jun 2021 23:01:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20225 invoked from network); 15 Jun 2021 22:45:05 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=cc:to:from:message-id:in-reply-to:references:date:subject;
        bh=yAsKDxu4OsJzll8QC5S0Yfmf14kqjw1ys0j1yn9M9SA=;
        b=HS0GT+xpHXhIKqjwQv9QddnB8DnaaY421+5pdBr2Y0YekywQ+WjECT1LtO5VxGjLkU
         FXXVSEnPu2QAu2ACeEoiFOFFkXTmjPkWkhzQjGoBjHxi3h+F+uoLhWigpA2J2Dp0ph24
         JqSADk1f8oJaQcVtxqRuXmybcTSfflC/NRZVxuVMrEe6y3TTGIYHCZo+0GCtmF7SXzMx
         o4IEvD5W1C1WONjEUEJLXUm9joNBBb1/0xlKRk4GdCacQPQ+dcNz/5bCsel3BkPzXe1u
         +MoM0Fum5vjnBFjXNsxQ8pNiOKnRNK2TpMz6fU89cEiJQ31nvqVaeK4ovKedFbTgjnpK
         NDOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:cc:to:from:message-id:in-reply-to:references
         :date:subject;
        bh=yAsKDxu4OsJzll8QC5S0Yfmf14kqjw1ys0j1yn9M9SA=;
        b=APT+ZVxkkoEwaGrXb6BRgXcnEcDdYIyx4Eite2J+HwUsWgqhH+N/XwoQCVTbREhWN/
         NyzIKY/AstLEte0R2oPqWVhhIEwOJU/neUj7InP0kbT8TRQ/TVjrfb00E6hdA4hi5Il1
         ENwdYEk3dFLmmo5kosTKsw6lRO6aOx8iI0WMxUZ1h87E1gSaJAw5bHOCpaZlfopBlxA4
         kQRL64UPIQBlKV7jvVWZr7hNPXpdh8pu3s2lRT272qk7KPZKDYTJaQfRnbwnhfYeKMDZ
         58WVPI8/Xo+ASdw6+48vqDM6eOysa/al83IEB/b+kdHkaT2BqIApb9K4i3DpVtK7oXFi
         WhNw==
X-Gm-Message-State: AOAM532xtGKMg16ePErpnAzMx2+n8D8jCTbGi4gno77BoTSA7l9ZbU9t
	ctxg8GvlbOIw5kcuHZEO9kk=
X-Google-Smtp-Source: ABdhPJw/LSBqzOKIGod9rqRZwOqq4UUUOiHo8kr0tNW8SdyA1B5cSD8VfYghOxDTxcnfghCL1uiXaQ==
X-Received: by 2002:a5d:5585:: with SMTP id i5mr1483433wrv.371.1623797093202;
        Tue, 15 Jun 2021 15:44:53 -0700 (PDT)
Cc: ecree.xilinx@gmail.com,
    syzbot+bed360704c521841c85d@syzkaller.appspotmail.com,
    keescook@chromium.org,
    yhs@fb.com,
    dvyukov@google.com,
    andrii@kernel.org,
    ast@kernel.org,
    bpf@vger.kernel.org,
    davem@davemloft.net,
    hawk@kernel.org,
    john.fastabend@gmail.com,
    kafai@fb.com,
    kpsingh@kernel.org,
    kuba@kernel.org,
    linux-kernel@vger.kernel.org,
    netdev@vger.kernel.org,
    songliubraving@fb.com,
    syzkaller-bugs@googlegroups.com,
    nathan@kernel.org,
    ndesaulniers@google.com,
    clang-built-linux@googlegroups.com,
    kernel-hardening@lists.openwall.com,
    kasan-dev@googlegroups.com
To: ebiggers@kernel.org,
    daniel@iogearbox.net
From: "Kurt Manucredo" <fuzzybritches0@gmail.com>
Message-ID: <31138-26823-curtm@phaethon>
In-Reply-To: <YMkkr5G6E8lcFymG@gmail.com>
References: <1aaa2408-94b9-a1e6-beff-7523b66fe73d@fb.com>
 <202106101002.DF8C7EF@keescook>
 <CAADnVQKMwKYgthoQV4RmGpZm9Hm-=wH3DoaNqs=UZRmJKefwGw@mail.gmail.com>
 <85536-177443-curtm@phaethon>
 <bac16d8d-c174-bdc4-91bd-bfa62b410190@gmail.com>
 <YMkAbNQiIBbhD7+P@gmail.com>
 <dbcfb2d3-0054-3ee6-6e76-5bd78023a4f2@iogearbox.net>
 <YMkcYn4dyZBY/ze+@gmail.com>
 <YMkdx1VB0i+fhjAY@gmail.com>
 <4713f6e9-2cfb-e2a6-c42d-b2a62f035bf2@iogearbox.net>
 <YMkkr5G6E8lcFymG@gmail.com>
Date: Wed, 16 Jun 2021 00:31:49 +0200
Subject: Re: [PATCH v5] bpf: core: fix shift-out-of-bounds in ___bpf_prog_run

On Tue, 15 Jun 2021 15:07:43 -0700, Eric Biggers <ebiggers@kernel.org> wrote:
> 
> On Tue, Jun 15, 2021 at 11:54:41PM +0200, Daniel Borkmann wrote:
> > On 6/15/21 11:38 PM, Eric Biggers wrote:
> > > On Tue, Jun 15, 2021 at 02:32:18PM -0700, Eric Biggers wrote:
> > > > On Tue, Jun 15, 2021 at 11:08:18PM +0200, Daniel Borkmann wrote:
> > > > > On 6/15/21 9:33 PM, Eric Biggers wrote:
> > > > > > On Tue, Jun 15, 2021 at 07:51:07PM +0100, Edward Cree wrote:
> > > > > > > 
> > > > > > > As I understand it, the UBSAN report is coming from the eBPF interpreter,
> > > > > > >    which is the *slow path* and indeed on many production systems is
> > > > > > >    compiled out for hardening reasons (CONFIG_BPF_JIT_ALWAYS_ON).
> > > > > > > Perhaps a better approach to the fix would be to change the interpreter
> > > > > > >    to compute "DST = DST << (SRC & 63);" (and similar for other shifts and
> > > > > > >    bitnesses), thus matching the behaviour of most chips' shift opcodes.
> > > > > > > This would shut up UBSAN, without affecting JIT code generation.
> > > > > > 
> > > > > > Yes, I suggested that last week
> > > > > > (https://lkml.kernel.org/netdev/YMJvbGEz0xu9JU9D@gmail.com).  The AND will even
> > > > > > get optimized out when compiling for most CPUs.
> > > > > 
> > > > > Did you check if the generated interpreter code for e.g. x86 is the same
> > > > > before/after with that?
> > > > 
> > > > Yes, on x86_64 with gcc 10.2.1, the disassembly of ___bpf_prog_run() is the same
> > > > both before and after (with UBSAN disabled).  Here is the patch I used:
> > > > 
> > > > diff --git a/kernel/bpf/core.c b/kernel/bpf/core.c
> > > > index 5e31ee9f7512..996db8a1bbfb 100644
> > > > --- a/kernel/bpf/core.c
> > > > +++ b/kernel/bpf/core.c
> > > > @@ -1407,12 +1407,30 @@ static u64 ___bpf_prog_run(u64 *regs, const struct bpf_insn *insn)
> > > >   		DST = (u32) DST OP (u32) IMM;	> > >   		CONT;
> > > > +	/*
> > > > +	 * Explicitly mask the shift amounts with 63 or 31 to avoid undefined
> > > > +	 * behavior.  Normally this won't affect the generated code.
> > 
> > The last one should probably be more specific in terms of 'normally', e.g. that
> > it is expected that the compiler is optimizing this away for archs like x86. Is
> > arm64 also covered by this ... do you happen to know on which archs this won't
> > be the case?
> > 
> > Additionally, I think such comment should probably be more clear in that it also
> > needs to give proper guidance to JIT authors that look at the interpreter code to
> > see what they need to implement, in other words, that they don't end up copying
> > an explicit AND instruction emission if not needed there.
> 
> Same result on arm64 with gcc 10.2.0.
> 
> On arm32 it is different, probably because the 64-bit shifts aren't native in
> that case.  I don't know about other architectures.  But there aren't many ways
> to implement shifts, and using just the low bits of the shift amount is the most
> logical way.
> 
> Please feel free to send out a patch with whatever comment you want.  The diff I
> gave was just an example and I am not an expert in BPF.
> 
> > 
> > > > +	 */
> > > > +#define ALU_SHIFT(OPCODE, OP)		> > > +	ALU64_##OPCODE##_X:		> > > +		DST = DST OP (SRC & 63);> > > +		CONT;			> > > +	ALU_##OPCODE##_X:		> > > +		DST = (u32) DST OP ((u32)SRC & 31);	> > > +		CONT;			> > > +	ALU64_##OPCODE##_K:		> > > +		DST = DST OP (IMM & 63);	> > > +		CONT;			> > > +	ALU_##OPCODE##_K:		> > > +		DST = (u32) DST OP ((u32)IMM & 31);	> > > +		CONT;
> > 
> > For the *_K cases these are explicitly rejected by the verifier already. Is this
> > required here nevertheless to suppress UBSAN false positive?
> > 
> 
> No, I just didn't know that these constants are never out of range.  Please feel
> free to send out a patch that does this properly.
> 
The shift-out-of-bounds on syzbot happens in ALU_##OPCODE##_X only. To
pass the syzbot test, only ALU_##OPCODE##_X needs to be guarded.

This old patch I tested on syzbot puts a check in all four.
https://syzkaller.appspot.com/text?tag=Patch&x=11f8cacbd00000

https://syzkaller.appspot.com/bug?id=edb51be4c9a320186328893287bb30d5eed09231

thanks,

kind regards

Kurt Manucredo
