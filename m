Return-Path: <SRS0=5ouP=CR=lists.openwall.com=kernel-hardening-return-19830-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02390C433E2
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Sep 2020 23:47:10 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 12E12206DB
	for <kernel-hardening@archiver.kernel.org>; Tue,  8 Sep 2020 23:47:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o7AAPg2t"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 12E12206DB
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-19830-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 10231 invoked by uid 550); 8 Sep 2020 23:47:02 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 10199 invoked from network); 8 Sep 2020 23:47:02 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=z8KgGGQx1h7YczMCEetfx/jb92oxBiLV/4DApZXEdSc=;
        b=o7AAPg2tGIBeoDCy+SKZSPrMh90LWzBsQz7vIgRgf0gXKcazYi7dMUuiHS6pkeEhe3
         72U8LTqKCD+Y0nvZWHnSCPgKx22WrkcnXsI1zBTHp65y4SK7sUDb96k8i08E7N1I3ndK
         MAbE+qSMIBBIRaP4TaKmNwhLB/bhB54qsZiAh3Ur4seHsvyrTB8t5y34VNrcKVW/C66L
         l7cjL+k9FUiFppFSh3huLQBHCcZYt8E1otUR46Y0GfuzwzhPLhut+2yC5pR2SQvSs0VL
         ilFTrWMA4JBjFg121/n2oGTyDANdfOuIpPL/4ZyE02D71+D1zpI6L2df8XB6haMHzveL
         5RSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=z8KgGGQx1h7YczMCEetfx/jb92oxBiLV/4DApZXEdSc=;
        b=rylqz6x6/TahVK+rz+PMd3FJhGoq5c/g1aaI0hW6qvyBEp8YaWf9ZaJeBPDR3I2gHN
         OxtxWyF8xmFbAUL5QOLSZq37V/h1W/OpqdLjY1sV2gK5Ia4cDE6T/+ewZdCBvYTtRIaU
         lcEGRw7OPTCmCZS2WCs2u5bMZFWBtOv+I3xTHfClLoX1KrvZqFBSib4+AM3w3GbEHt3D
         m27SbqPVo23IgYQgNIM2dwDgPX13g3WWoTH7zHc9YvejaVwYkLtdhODB6chx2xRaxQWG
         YhjB5Q6bu2eADa+N6L7jg8HKi3nAulweuijFJFnjg0jU/8pAH63OTn3V5l4lEP/K7Xuq
         gz7A==
X-Gm-Message-State: AOAM532J5ipaxkAu8ul7x4L3fDXZpFlRTeMF/60cdiiI2PQzhbFt+Pyf
	2X0FcBWbD7mH/X69FHBsuBb9MA==
X-Google-Smtp-Source: ABdhPJyPXjsg2EPOqZVE0HrEMh1e+YhXcjhHaIFb+FoC7uPh34ggtt3CwAG5NZI9KmvOFhjBQ3KjBw==
X-Received: by 2002:a63:4664:: with SMTP id v36mr859465pgk.194.1599608809917;
        Tue, 08 Sep 2020 16:46:49 -0700 (PDT)
Date: Tue, 8 Sep 2020 16:46:43 -0700
From: Sami Tolvanen <samitolvanen@google.com>
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: Will Deacon <will@kernel.org>, Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Kees Cook <keescook@chromium.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	clang-built-linux <clang-built-linux@googlegroups.com>,
	Kernel Hardening <kernel-hardening@lists.openwall.com>,
	linux-arch <linux-arch@vger.kernel.org>,
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
	Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	linux-pci@vger.kernel.org, X86 ML <x86@kernel.org>
Subject: Re: [PATCH v2 00/28] Add support for Clang LTO
Message-ID: <20200908234643.GF1060586@google.com>
References: <20200624203200.78870-1-samitolvanen@google.com>
 <20200903203053.3411268-1-samitolvanen@google.com>
 <CAK7LNASDUkyJMDD0a5K_HT=1q5NEc6dcN4=FUb330yK0BCKcTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK7LNASDUkyJMDD0a5K_HT=1q5NEc6dcN4=FUb330yK0BCKcTw@mail.gmail.com>

On Sun, Sep 06, 2020 at 09:24:38AM +0900, Masahiro Yamada wrote:
> On Fri, Sep 4, 2020 at 5:30 AM Sami Tolvanen <samitolvanen@google.com> wrote:
> >
> > This patch series adds support for building x86_64 and arm64 kernels
> > with Clang's Link Time Optimization (LTO).
> >
> > In addition to performance, the primary motivation for LTO is
> > to allow Clang's Control-Flow Integrity (CFI) to be used in the
> > kernel. Google has shipped millions of Pixel devices running three
> > major kernel versions with LTO+CFI since 2018.
> >
> > Most of the patches are build system changes for handling LLVM
> > bitcode, which Clang produces with LTO instead of ELF object files,
> > postponing ELF processing until a later stage, and ensuring initcall
> > ordering.
> >
> > Note that patches 1-4 are not directly related to LTO, but are
> > needed to compile LTO kernels with ToT Clang, so I'm including them
> > in the series for your convenience:
> >
> >  - Patches 1-3 are required for building the kernel with ToT Clang,
> >    and IAS, and patch 4 is needed to build allmodconfig with LTO.
> >
> >  - Patches 3-4 are already in linux-next, but not yet in 5.9-rc.
> >
> 
> 
> I still do not understand how this patch set works.
> (only me?)
> 
> Please let me ask fundamental questions.
> 
> 
> 
> I applied this series on top of Linus' tree,
> and compiled for ARCH=arm64.
> 
> I compared the kernel size with/without LTO.
> 
> 
> 
> [1] No LTO  (arm64 defconfig, CONFIG_LTO_NONE)
> 
> $ llvm-size   vmlinux
>    text    data     bss     dec     hex filename
> 15848692 10099449 493060 26441201 19375f1 vmlinux
> 
> 
> 
> [2] Clang LTO  (arm64 defconfig + CONFIG_LTO_CLANG)
> 
> $ llvm-size   vmlinux
>    text    data     bss     dec     hex filename
> 15906864 10197445 490804 26595113 195cf29 vmlinux
> 
> 
> I compared the size of raw binary, arch/arm64/boot/Image.
> Its size increased too.
> 
> 
> 
> So, in my experiment, enabling CONFIG_LTO_CLANG
> increases the kernel size.
> Is this correct?

Yes. LTO does produce larger binaries, mostly due to function
inlining between translation units, I believe. The compiler people
can probably give you a more detailed answer here. Without -mllvm
-import-instr-limit, the binaries would be even larger.

> One more thing, could you teach me
> how Clang LTO optimizes the code against
> relocatable objects?
> 
> 
> 
> When I learned Clang LTO first, I read this document:
> https://llvm.org/docs/LinkTimeOptimization.html
> 
> It is easy to confirm the final executable
> does not contain foo2, foo3...
> 
> 
> 
> In contrast to userspace programs,
> kernel modules are basically relocatable objects.
> 
> Does Clang drop unused symbols from relocatable objects?
> If so, how?

I don't think the compiler can legally drop global symbols from
relocatable objects, but it can rename and possibly even drop static
functions. This is why we need global wrappers for initcalls, for
example, to have stable symbol names.

Sami
