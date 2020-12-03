Return-Path: <SRS0=7v45=FH=lists.openwall.com=kernel-hardening-return-20516-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BFCEC433FE
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Dec 2020 17:08:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 5310A207AF
	for <kernel-hardening@archiver.kernel.org>; Thu,  3 Dec 2020 17:08:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5310A207AF
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20516-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 10228 invoked by uid 550); 3 Dec 2020 17:07:54 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 10205 invoked from network); 3 Dec 2020 17:07:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+MQyiUOcMt6gFRBNfnN0H07pYjhZgF4qm1+bZjvfjTY=;
        b=Cx6oEw3asYjWnT8nYuCvr3UMa7sC7zqGfjZH+6NM/LRsctzlYBq4jWYT5t+CTuzy81
         ufA/35gbWjoyI3GR4sHKJJ/dXIYNWsy/BxrQVF9OwKV8d6p4mG8Br2zZ9qAR1jhR1sR5
         XFtBts/povF4EP6Ny/d1T5ZXYf5b7sm8jc1Iq+39jvlvaKhZ804pJUPhzTdzV+xw97qN
         T4REXRSQqTMIj7T7Nw8GXA7uRLUe6tmfZ+hAOZ2AadWxtejiV4KjYgBy29l+9CK6RmgP
         /m7bEmZBumCr+ghR9RTNKJtACi6yZ1mK18q6oD/IvZz6axncMy9glbpDQAxZ3Bj+bHAk
         275w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+MQyiUOcMt6gFRBNfnN0H07pYjhZgF4qm1+bZjvfjTY=;
        b=L/gRcv3yqR4PZL4eP3x//ZpPteNfjox/BXESRzoCB80KRjEkJNSmMSLzoE2vU0TnC3
         hCOI6Cx+pOR0ebw88Ud1wGKI5aeLni2trYeidp/yq2F3P6gmrc244Nky4e3IhIGHQ8KD
         FiWq4fCCJ/Y92UAuY1dobr6vwYtXCH9dEu64TajUdwl/6sDXnrA7vRd3O39s6zAGLSJV
         ad5TynHtAO8hatSceiVc4NTu1Q+gP6h5qm9P2PW51AYKi+R/ROkTE3KvOPUMMBkzVej8
         3xeykfhP/ED6R+tLO1RKC1OBJR2VlM4P5gJFwkA9TFI213jgM+IpP+CUQCy9kFy0ixcu
         EmVA==
X-Gm-Message-State: AOAM531OP6OkDgrKXUvoAadvaqCA6jywVEH9o9y34DxTg2JOWRNp6iuK
	9SqEqC/v5ftwKqUpWlfEl6ZXBTazhtkr3N5HN1TxPw==
X-Google-Smtp-Source: ABdhPJyeNpRimBzFqDhGioLOrE5ouq1kJk4Pby6GpAHMXjB75Cnj+2lIjlrUJWt+qddSs9EdyIaV3e9wcFRpPEdvaH8=
X-Received: by 2002:a19:c815:: with SMTP id y21mr1656793lff.589.1607015262357;
 Thu, 03 Dec 2020 09:07:42 -0800 (PST)
MIME-Version: 1.0
References: <20201201213707.541432-1-samitolvanen@google.com> <20201203112622.GA31188@willie-the-truck>
In-Reply-To: <20201203112622.GA31188@willie-the-truck>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Thu, 3 Dec 2020 09:07:30 -0800
Message-ID: <CABCJKueby8pUoN7f5=6RoyLSt4PgWNx8idUej0sNwAi0F3Xqzw@mail.gmail.com>
Subject: Re: [PATCH v8 00/16] Add support for Clang LTO
To: Will Deacon <will@kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, 
	Nathan Chancellor <natechancellor@gmail.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Josh Poimboeuf <jpoimboe@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	linux-kbuild <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	PCI <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, Dec 3, 2020 at 3:26 AM Will Deacon <will@kernel.org> wrote:
>
> Hi Sami,
>
> On Tue, Dec 01, 2020 at 01:36:51PM -0800, Sami Tolvanen wrote:
> > This patch series adds support for building the kernel with Clang's
> > Link Time Optimization (LTO). In addition to performance, the primary
> > motivation for LTO is to allow Clang's Control-Flow Integrity (CFI)
> > to be used in the kernel. Google has shipped millions of Pixel
> > devices running three major kernel versions with LTO+CFI since 2018.
> >
> > Most of the patches are build system changes for handling LLVM
> > bitcode, which Clang produces with LTO instead of ELF object files,
> > postponing ELF processing until a later stage, and ensuring initcall
> > ordering.
> >
> > Note that arm64 support depends on Will's memory ordering patches
> > [1]. I will post x86_64 patches separately after we have fixed the
> > remaining objtool warnings [2][3].
>
> I took this series for a spin, with my for-next/lto branch merged in but
> I see a failure during the LTO stage with clang 11.0.5 because it doesn't
> understand the '.arch_extension rcpc' directive we throw out in READ_ONCE().

I just tested this with Clang 11.0.0, which I believe is the latest
11.x version, and the current Clang 12 development branch, and both
work for me. Godbolt confirms that '.arch_extension rcpc' is supported
by the integrated assembler starting with Clang 11 (the example fails
with 10.0.1):

https://godbolt.org/z/1csGcT

What does running clang --version and ld.lld --version tell you?

> We actually check that this extension is available before using it in
> the arm64 Kconfig:
>
>         config AS_HAS_LDAPR
>                 def_bool $(as-instr,.arch_extension rcpc)
>
> so this shouldn't happen. I then realised, I wasn't passing LLVM_IAS=1
> on my Make command line; with that, then the detection works correctly
> and the LTO step succeeds.
>
> Why is it necessary to pass LLVM_IAS=1 if LTO is enabled? I think it
> would be _much_ better if this was implicit (or if LTO depended on it).

Without LLVM_IAS=1, Clang uses two different assemblers when LTO is
enabled: the external GNU assembler for stand-alone assembly, and
LLVM's integrated assembler for inline assembly. as-instr tests the
external assembler and makes an admittedly reasonable assumption that
the test is also valid for inline assembly.

I agree that it would reduce confusion in future if we just always
enabled IAS with LTO. Nick, Nathan, any thoughts about this?

Sami
