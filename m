Return-Path: <SRS0=guLa=EQ=lists.openwall.com=kernel-hardening-return-20379-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F1B6C388F7
	for <kernel-hardening@archiver.kernel.org>; Tue, 10 Nov 2020 19:00:29 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7F78120780
	for <kernel-hardening@archiver.kernel.org>; Tue, 10 Nov 2020 19:00:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UAf9RqBB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7F78120780
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20379-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 15587 invoked by uid 550); 10 Nov 2020 19:00:20 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 15564 invoked from network); 10 Nov 2020 19:00:19 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HQMWJ4qrTrrDaVP4fR8AYbnLL+HhbqUgRWbw+YSQ1PU=;
        b=UAf9RqBB0qr82AsqOtHV2sesZ3cFzDvVPrFOFo9wUuuHJXryVnBngDsIrGvKaE6X19
         0SqjoI+qK8F47wcovy/kBeCPJ4lIKLolgnCYTTAinI6LM/5ys2dh6HlhdigZSrVkC/rn
         ShAlUOfI+vdr9rptwftYPxBYiTijHNtuYVGc3mYzd/3mrO/nNNPGBPmWtes0yy3EJX3R
         sHQB4adTCc34sogEGEr66NVJxa45ZnJ2DpryOQ0DhgNiqen71LLeDBvfUdLT3d4QP0EK
         CCvE4ObR4otzBFPgR6yeCqhZTLFHqyDs2Tr4Y5R18i3xk72lbdkEjxSGufRjUQd0yCL8
         Ojbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HQMWJ4qrTrrDaVP4fR8AYbnLL+HhbqUgRWbw+YSQ1PU=;
        b=ba980DR886YH4x+R+/ppMtffUCkpJ6VJnSUZvaKUCQ6ybS4TyTyqCkERVQap8cM4w/
         tcsbJeiUAIkw3CjeHlhMV/XRQYjhypQhwPgWzwU0VSX6lwsOb7vBoMIEqqzrL3voBimp
         HDAx8Jecbck5M64hhVsnFn3oiHL+rZPpW9q+f+/74weyvyM8rglEGvsgms++z71gB0M/
         ZzTNdMWdMDtU6UDdgEKYonDvSpcmQcrPiRPPAqN8fCWQIeiFtonfwB0BHoOy2koGPLDf
         U+Hfm+9k6OxAUhfNGGmdROHJyNY6/WCf+wJRTT81efEur/BY0mNaySvefrkktLi/s6GY
         voDg==
X-Gm-Message-State: AOAM531ojAxcg9IGqfrIb74+W2xbFU9r8nrVHh38Ji9HLQD2IhaP5i5w
	BpL4abU0URkHnPC+0C1xiw0wZ/fGY5MLtsUhf+CAPQ==
X-Google-Smtp-Source: ABdhPJw/xQbpb4nm+Nf8IkeXZp9mvPOXpptK1b90vfr96ZwBHQ1ynLFLCpnmKb8sXq4PoJSCYGgPJD2CoGITJLPmHok=
X-Received: by 2002:a67:ee93:: with SMTP id n19mr12787183vsp.36.1605034807022;
 Tue, 10 Nov 2020 11:00:07 -0800 (PST)
MIME-Version: 1.0
References: <20201015102216.GB2611@hirez.programming.kicks-ass.net>
 <20201015203942.f3kwcohcwwa6lagd@treble> <CABCJKufDLmBCwmgGnfLcBw_B_4U8VY-R-dSNNp86TFfuMobPMw@mail.gmail.com>
 <20201020185217.ilg6w5l7ujau2246@treble> <CABCJKucVjFtrOsw58kn4OnW5kdkUh8G7Zs4s6QU9s6O7soRiAA@mail.gmail.com>
 <20201021085606.GZ2628@hirez.programming.kicks-ass.net> <CABCJKufL6=FiaeD8T0P+mK4JeR9J80hhjvJ6Z9S-m9UnCESxVA@mail.gmail.com>
 <20201023173617.GA3021099@google.com> <CABCJKuee7hUQSiksdRMYNNx05bW7pWaDm4fQ__znGQ99z9-dEw@mail.gmail.com>
 <20201110022924.tekltjo25wtrao7z@treble> <20201110174606.mp5m33lgqksks4mt@treble>
In-Reply-To: <20201110174606.mp5m33lgqksks4mt@treble>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Tue, 10 Nov 2020 10:59:55 -0800
Message-ID: <CABCJKuf+Ev=hpCUfDpCFR_wBACr-539opJsSFrDcpDA9Ctp7rg@mail.gmail.com>
Subject: Re: [PATCH v6 22/25] x86/asm: annotate indirect jumps
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
	"the arch/x86 maintainers" <x86@kernel.org>, Masahiro Yamada <masahiroy@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, Will Deacon <will@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, 
	linux-kbuild <linux-kbuild@vger.kernel.org>, kernel list <linux-kernel@vger.kernel.org>, 
	linux-pci@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, Nov 10, 2020 at 9:46 AM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
>
> On Mon, Nov 09, 2020 at 08:29:24PM -0600, Josh Poimboeuf wrote:
> > On Mon, Nov 09, 2020 at 03:11:41PM -0800, Sami Tolvanen wrote:
> > > CONFIG_XEN
> > >
> > > __switch_to_asm()+0x0: undefined stack state
> > >   xen_hypercall_set_trap_table()+0x0: <=== (sym)
>
> With your branch + GCC 9 I can recreate all the warnings except this
> one.

In a gcc build this warning is replaced with a different one:

vmlinux.o: warning: objtool: __startup_secondary_64()+0x7: return with
modified stack frame

This just seems to depend on which function is placed right after the
code in xen-head.S. With gcc, the disassembly looks like this:

0000000000000000 <asm_cpu_bringup_and_idle>:
       0:       e8 00 00 00 00          callq  5 <asm_cpu_bringup_and_idle+0x5>
                        1: R_X86_64_PLT32       cpu_bringup_and_idle-0x4
       5:       e9 f6 0f 00 00          jmpq   1000
<xen_hypercall_set_trap_table>
...
0000000000001000 <xen_hypercall_set_trap_table>:
        ...
...
0000000000002000 <__startup_secondary_64>:

With Clang+LTO, we end up with __switch_to_asm here instead of
__startup_secondary_64.

> Will do some digging on the others...

Thanks!

Sami
