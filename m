Return-Path: <SRS0=Y39/=FK=lists.openwall.com=kernel-hardening-return-20537-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9136EC433FE
	for <kernel-hardening@archiver.kernel.org>; Sun,  6 Dec 2020 20:10:05 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 504582310B
	for <kernel-hardening@archiver.kernel.org>; Sun,  6 Dec 2020 20:10:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 504582310B
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20537-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 20063 invoked by uid 550); 6 Dec 2020 20:09:55 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 20036 invoked from network); 6 Dec 2020 20:09:54 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iz05We4T6eIjQaXBvxz0eSpPimwSlGMKW8WGflLLLgw=;
        b=iS/yxV/uv33bWygYcp3w94mm68WCg/cooZBDHGRBRFCb+HEVGfBEws+dpr/6P25Mqk
         CGF0txaBIDtDjqi1yLxaRHzbKNu312tAIiWry1c6H2XUemwifDXDJ3xgms3nJQh018Ju
         tSfem3j42gdxUipuE2UCBGdP6HbCXjgyA35rk3ybR2x5sUXsvaX34+w/11PCnDP3wUw3
         VXU3d3GrfxpXDM3mNsWNN8WzS04oerefikrSUgI3Sa41DzU+d/SyYsbVuDLVrcBbBAFd
         TPfpfk+LViEDwCmkthUfnAh26cBtd4O/zl0ILiNY2vgWj3ccwdwRthGGUZbaHtAB4IuL
         4E/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iz05We4T6eIjQaXBvxz0eSpPimwSlGMKW8WGflLLLgw=;
        b=oVi9SZNwosmgtcmCT6D+Rx/ZB3QU8Q7rYeb89d4d8N+ky1YkRiVUry7lwS3usG2OfX
         wb8IaKIWad5xGAjxAi1KMQdJPZJQmAJPTrRiYLeq0CYgRNO25FrZYhGu9ykYY8vTFu3f
         0YUKHr9U722w3cnjlQ8+4L8w7rdjWtSacVDFHp6NrN3qh+ZgKtIaUAwwbRm7eS3ysSJM
         NrAQhmbfHjbXy76iepEQTIZTH97jMcPQmPEYZ/uoFvnFHCxxbUMDHDrzbS/0cVRM3LSs
         X/Ml0zmWiQ14H6k9l9rAl9vYUuDaiPsWlbV2s5KKGMI4RSgZtNigfEw9eocOs6XlqWMv
         CIxw==
X-Gm-Message-State: AOAM531NfEUtHCHQm7Nd70jCoHKNxbb3qLIBk+5eiBCCJ83qkyv4ZLJh
	poB77irO/xWLJINAuyUyTytPVA4uWCugnrySLrXf+g==
X-Google-Smtp-Source: ABdhPJyKCb8VYAdpRAyuT9QnDEa4WUbLFAwf7yIvP0eytyeCFIBxggFhwRm1Itv8d1sjhOU4I4dMU+iMqgn79bJuOn0=
X-Received: by 2002:ab0:6f0f:: with SMTP id r15mr3484878uah.52.1607285382144;
 Sun, 06 Dec 2020 12:09:42 -0800 (PST)
MIME-Version: 1.0
References: <20201201213707.541432-1-samitolvanen@google.com>
 <20201203112622.GA31188@willie-the-truck> <CABCJKueby8pUoN7f5=6RoyLSt4PgWNx8idUej0sNwAi0F3Xqzw@mail.gmail.com>
 <20201203182252.GA32011@willie-the-truck> <CAKwvOdnvq=L=gQMv9MHaStmKMOuD5jvffzMedhp3gytYB6R7TQ@mail.gmail.com>
 <CABCJKufgkq+k0DeYaXrzjXniy=T_N4sN1bxoK9=cUxTZN5xSVQ@mail.gmail.com> <20201206065028.GA2819096@ubuntu-m3-large-x86>
In-Reply-To: <20201206065028.GA2819096@ubuntu-m3-large-x86>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Sun, 6 Dec 2020 12:09:31 -0800
Message-ID: <CABCJKue9TJnhge6TVPj9vfZXPGD4RW2JYiN3kNwVKNovTCq8ZA@mail.gmail.com>
Subject: Re: [PATCH v8 00/16] Add support for Clang LTO
To: Nathan Chancellor <natechancellor@gmail.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>, Will Deacon <will@kernel.org>, 
	Masahiro Yamada <masahiroy@kernel.org>, Steven Rostedt <rostedt@goodmis.org>, 
	Josh Poimboeuf <jpoimboe@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Kees Cook <keescook@chromium.org>, 
	clang-built-linux <clang-built-linux@googlegroups.com>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	linux-arch <linux-arch@vger.kernel.org>, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	linux-kbuild <linux-kbuild@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	PCI <linux-pci@vger.kernel.org>, Jian Cai <jiancai@google.com>, 
	Kristof Beyls <Kristof.Beyls@arm.com>
Content-Type: text/plain; charset="UTF-8"

On Sat, Dec 5, 2020 at 10:50 PM Nathan Chancellor
<natechancellor@gmail.com> wrote:
>
> On Fri, Dec 04, 2020 at 02:52:41PM -0800, Sami Tolvanen wrote:
> > On Thu, Dec 3, 2020 at 2:32 PM Nick Desaulniers <ndesaulniers@google.com> wrote:
> > >
> > > So I'd recommend to Sami to simply make the Kconfig also depend on
> > > clang's integrated assembler (not just llvm-nm and llvm-ar).
> >
> > Sure, sounds good to me. What's the preferred way to test for this in Kconfig?
> >
> > It looks like actually trying to test if we have an LLVM assembler
> > (e.g. using $(as-instr,.section
> > ".linker-options","e",@llvm_linker_options)) doesn't work as Kconfig
> > doesn't pass -no-integrated-as to clang here.

After a closer look, that's actually not correct, this seems to work
with Clang+LLD no matter which assembler is used. I suppose we could
test for .gasversion. to detect GNU as, but that's hardly ideal.

> >I could do something
> > simple like $(success,echo $(LLVM) $(LLVM_IAS) | grep -q "1 1").
> >
> > Thoughts?
> >
> > Sami
>
> I think
>
>     depends on $(success,test $(LLVM_IAS) -eq 1)
>
> should work, at least according to my brief test.

Sure, looks good to me. However, I think we should also test for
LLVM=1 to avoid possible further issues with mismatched toolchains
instead of only checking for llvm-nm and llvm-ar.

Sami
