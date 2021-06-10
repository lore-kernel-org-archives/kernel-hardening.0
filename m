Return-Path: <SRS0=Ihmj=LE=lists.openwall.com=kernel-hardening-return-21300-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A3CCEC47094
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Jun 2021 17:07:09 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id B164E613C9
	for <kernel-hardening@archiver.kernel.org>; Thu, 10 Jun 2021 17:07:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org B164E613C9
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=chromium.org
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-21300-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 1700 invoked by uid 550); 10 Jun 2021 17:06:58 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 1663 invoked from network); 10 Jun 2021 17:06:57 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Tf6j48/EA7psoQT0Xa+Ykp/HBTN3iYdEAaBd6YZtNzA=;
        b=BQ5qUY2276upuseKeH0xi1cEhRtHiQIFJX1GijU6PYyl4Cthzv0BUWu+InvJdo0fyc
         nG8Pyy9LtiSpoNHDFjrgilIGZVKGi4qnfmsRJ1Ac9bjV3BFqIKua7PDRe5kS9WxvMPHF
         hGCQOxOSvU3j5mYsPkqMaz++wpX7b6l2jSRXE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Tf6j48/EA7psoQT0Xa+Ykp/HBTN3iYdEAaBd6YZtNzA=;
        b=KcfCM4dvmt2OKmTlVcD6lYoaXn/96wNZtQd7Xbkd2Os2n/CpY03IuU3UZu7PmqTSXI
         eSgx/kq596rgFxJwExNqipXUav76ro54duUB1VpwkQzXHD6zNy1mmtwB0oVs+72JUXWA
         SLwJaGlNQ2k65ktWT45lVJnLPTjY+NTAzMPyPyZKxqY6V8Ox0wrPES88VJYnKPlxoDD7
         VjJ47xDrxFz60klwEo5TDiuYYWKUbph1Tha7eoO+c2PKoDz3BaaZVKVyNuG+STOyfT38
         htuAaukGxZ0+QP9zXTl6igKTNktfCPdkNFbH+LEQdIRnwowCQEAJPZMHVKW0XTy8vVQO
         28GQ==
X-Gm-Message-State: AOAM533OW/V8A6f38Rx0tnw6qxYyJwS5BNJ8chHghZvlR+yW6WViR/0Y
	kfXs/05GMtn3m47CVskBrFL/yw==
X-Google-Smtp-Source: ABdhPJziHTvIoTI9UofEIJVEwXLrrUpuk8JpKcfTDvrABtGPTblS2hWs3BzfsL1cKX8HsFyFIrI8Eg==
X-Received: by 2002:a63:5d66:: with SMTP id o38mr5923418pgm.444.1623344804696;
        Thu, 10 Jun 2021 10:06:44 -0700 (PDT)
Date: Thu, 10 Jun 2021 10:06:42 -0700
From: Kees Cook <keescook@chromium.org>
To: Yonghong Song <yhs@fb.com>
Cc: Dmitry Vyukov <dvyukov@google.com>,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Kurt Manucredo <fuzzybritches0@gmail.com>,
	syzbot+bed360704c521841c85d@syzkaller.appspotmail.com,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	"David S. Miller" <davem@davemloft.net>,
	Jesper Dangaard Brouer <hawk@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Martin KaFai Lau <kafai@fb.com>, KP Singh <kpsingh@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	LKML <linux-kernel@vger.kernel.org>,
	Network Development <netdev@vger.kernel.org>,
	Song Liu <songliubraving@fb.com>,
	syzkaller-bugs <syzkaller-bugs@googlegroups.com>, nathan@kernel.org,
	Nick Desaulniers <ndesaulniers@google.com>,
	Clang-Built-Linux ML <clang-built-linux@googlegroups.com>,
	linux-kernel-mentees@lists.linuxfoundation.org,
	Shuah Khan <skhan@linuxfoundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	kasan-dev <kasan-dev@googlegroups.com>
Subject: Re: [PATCH v4] bpf: core: fix shift-out-of-bounds in ___bpf_prog_run
Message-ID: <202106101002.DF8C7EF@keescook>
References: <20210602212726.7-1-fuzzybritches0@gmail.com>
 <YLhd8BL3HGItbXmx@kroah.com>
 <87609-531187-curtm@phaethon>
 <6a392b66-6f26-4532-d25f-6b09770ce366@fb.com>
 <CAADnVQKexxZQw0yK_7rmFOdaYabaFpi2EmF6RGs5bXvFHtUQaA@mail.gmail.com>
 <CACT4Y+b=si6NCx=nRHKm_pziXnVMmLo-eSuRajsxmx5+Hy_ycg@mail.gmail.com>
 <202106091119.84A88B6FE7@keescook>
 <752cb1ad-a0b1-92b7-4c49-bbb42fdecdbe@fb.com>
 <CACT4Y+a592rxFmNgJgk2zwqBE8EqW1ey9SjF_-U3z6gt3Yc=oA@mail.gmail.com>
 <1aaa2408-94b9-a1e6-beff-7523b66fe73d@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1aaa2408-94b9-a1e6-beff-7523b66fe73d@fb.com>

On Wed, Jun 09, 2021 at 11:06:31PM -0700, Yonghong Song wrote:
> 
> 
> On 6/9/21 10:32 PM, Dmitry Vyukov wrote:
> > On Thu, Jun 10, 2021 at 1:40 AM Yonghong Song <yhs@fb.com> wrote:
> > > On 6/9/21 11:20 AM, Kees Cook wrote:
> > > > On Mon, Jun 07, 2021 at 09:38:43AM +0200, 'Dmitry Vyukov' via Clang Built Linux wrote:
> > > > > On Sat, Jun 5, 2021 at 9:10 PM Alexei Starovoitov
> > > > > <alexei.starovoitov@gmail.com> wrote:
> > > > > > On Sat, Jun 5, 2021 at 10:55 AM Yonghong Song <yhs@fb.com> wrote:
> > > > > > > On 6/5/21 8:01 AM, Kurt Manucredo wrote:
> > > > > > > > Syzbot detects a shift-out-of-bounds in ___bpf_prog_run()
> > > > > > > > kernel/bpf/core.c:1414:2.
> > > > > > > [...]
> > > > > > > 
> > > > > > > I think this is what happens. For the above case, we simply
> > > > > > > marks the dst reg as unknown and didn't fail verification.
> > > > > > > So later on at runtime, the shift optimization will have wrong
> > > > > > > shift value (> 31/64). Please correct me if this is not right
> > > > > > > analysis. As I mentioned in the early please write detailed
> > > > > > > analysis in commit log.
> > > > > > 
> > > > > > The large shift is not wrong. It's just undefined.
> > > > > > syzbot has to ignore such cases.
> > > > > 
> > > > > Hi Alexei,
> > > > > 
> > > > > The report is produced by KUBSAN. I thought there was an agreement on
> > > > > cleaning up KUBSAN reports from the kernel (the subset enabled on
> > > > > syzbot at least).
> > > > > What exactly cases should KUBSAN ignore?
> > > > > +linux-hardening/kasan-dev for KUBSAN false positive
> > > > 
> > > > Can check_shl_overflow() be used at all? Best to just make things
> > > > readable and compiler-happy, whatever the implementation. :)
> > > 
> > > This is not a compile issue. If the shift amount is a constant,
> > > compiler should have warned and user should fix the warning.
> > > 
> > > This is because user code has
> > > something like
> > >       a << s;
> > > where s is a unknown variable and
> > > verifier just marked the result of a << s as unknown value.
> > > Verifier may not reject the code depending on how a << s result
> > > is used.

Ah, gotcha: it's the BPF code itself that needs to catch it.

> > > If bpf program writer uses check_shl_overflow() or some kind
> > > of checking for shift value and won't do shifting if the
> > > shifting may cause an undefined result, there should not
> > > be any kubsan warning.

Right.

> > I guess the main question: what should happen if a bpf program writer
> > does _not_ use compiler nor check_shl_overflow()?

I think the BPF runtime needs to make such actions defined, instead of
doing a blind shift. It needs to check the size of the shift explicitly
when handling the shift instruction.

> If kubsan is not enabled, everything should work as expected even with
> shl overflow may cause undefined result.
> 
> if kubsan is enabled, the reported shift-out-of-bounds warning
> should be ignored. You could disasm the insn to ensure that
> there indeed exists a potential shl overflow.

Sure, but the point of UBSAN is to find and alert about undefined
behavior, so we still need to fix this.


-- 
Kees Cook
