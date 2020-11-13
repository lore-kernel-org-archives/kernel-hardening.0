Return-Path: <SRS0=QoET=ET=lists.openwall.com=kernel-hardening-return-20398-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.4 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C8CCBC4742C
	for <kernel-hardening@archiver.kernel.org>; Fri, 13 Nov 2020 22:55:04 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id D8CC92225D
	for <kernel-hardening@archiver.kernel.org>; Fri, 13 Nov 2020 22:55:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="E/DaHCUs"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org D8CC92225D
Authentication-Results: mail.kernel.org; dmarc=fail (p=reject dis=none) header.from=google.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20398-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 32698 invoked by uid 550); 13 Nov 2020 22:54:56 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 32678 invoked from network); 13 Nov 2020 22:54:56 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=x7PN1px9ytV6KoYCs0MN8nIig7IfEqAMiUFMKSdwj8o=;
        b=E/DaHCUsxm9boUEUHR77XASfe1K99YXKl7duBooJylavKxm0tOGa/ZPK6xjyi2fAmj
         OYWDrTJOnFXwWt5S1pKJ6s8UxL+U3rZbepSwCXbZJRMhsO/oaNcGV6l2VgGjr5evZtSz
         yye6NpoiB+nakm0oK6uQ3sQViWHFOTTwEdtfu1R5mD/VgZzVhriCR2Y85MJT5y8nazB0
         NR1BZldS24JnVXgr+Ovb7PrDJwr+3Atcw4eToXXk9DLqZMzDtjrCymZ+KKaYr49Oz2wG
         03mdefjS8C7FER66kGpwiyb+EPHalvUWh8ADfLZXcOqSslaUx80S/cRhipC8ekjXSqmD
         cGOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=x7PN1px9ytV6KoYCs0MN8nIig7IfEqAMiUFMKSdwj8o=;
        b=FWB3RZyAq1caMwaHMHkv1FkSh+yYdih67ViQexxxIHLlmIZv3hKwBwXbsCG68rjz20
         swDC0GC9uyw2BSiDatOEYFdMjeV0LOzWjKQSKv81HGMcIb30TnLClkk+qQpuG09fiZyX
         BvMrcprK26r2XfV8j0/tbPQ1NCmviPwOpMmRZt0xUVz9OSnQpFru4tSDXFNU9a9elwSX
         0MJV6n5k0rh25cou+WzlCeU7XSdeMbkGYVOA1naDaJSFA3EuCPdGY5w3S8pSnDZ1Xc+N
         Hqtp0NivuGzMCiRQhuuy+g1nDJu0HrROWmqr0LsgSBFsOgKemJ51qbpgFD367APRkb3l
         dZKA==
X-Gm-Message-State: AOAM533c0lvGUIgnJ9AvO92XlS9hFXpx3wDX1aLlyQsVugcd4wQMvSob
	6dfRyem9ch5iMHfOSWqdUfMXCTTxNOHTmdEjvK+QPw==
X-Google-Smtp-Source: ABdhPJygwOP2IUwJzonbqdQUEI4r2KfzeUcxt3t9CVTdz7Ir0TADwtgbrh1R8/xsj+WLPbsqPnxXtDMz7YsGC5N32I8=
X-Received: by 2002:a1f:3655:: with SMTP id d82mr3109788vka.22.1605308083978;
 Fri, 13 Nov 2020 14:54:43 -0800 (PST)
MIME-Version: 1.0
References: <CABCJKucVjFtrOsw58kn4OnW5kdkUh8G7Zs4s6QU9s6O7soRiAA@mail.gmail.com>
 <20201021085606.GZ2628@hirez.programming.kicks-ass.net> <CABCJKufL6=FiaeD8T0P+mK4JeR9J80hhjvJ6Z9S-m9UnCESxVA@mail.gmail.com>
 <20201023173617.GA3021099@google.com> <CABCJKuee7hUQSiksdRMYNNx05bW7pWaDm4fQ__znGQ99z9-dEw@mail.gmail.com>
 <20201110022924.tekltjo25wtrao7z@treble> <20201110174606.mp5m33lgqksks4mt@treble>
 <CABCJKuf+Ev=hpCUfDpCFR_wBACr-539opJsSFrDcpDA9Ctp7rg@mail.gmail.com>
 <20201113195408.atbpjizijnhuinzy@treble> <CABCJKufA-aOcsOqb1NiMQeBGm9Q-JxjoPjsuNpHh0kL4LzfO0w@mail.gmail.com>
 <20201113223412.inono2ekrs7ky7rm@treble>
In-Reply-To: <20201113223412.inono2ekrs7ky7rm@treble>
From: Sami Tolvanen <samitolvanen@google.com>
Date: Fri, 13 Nov 2020 14:54:32 -0800
Message-ID: <CABCJKufBEBcPPrUZcAvh1LXX_GwRG1S1sg2ED2DPZ53MPy_VbQ@mail.gmail.com>
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

On Fri, Nov 13, 2020 at 2:34 PM Josh Poimboeuf <jpoimboe@redhat.com> wrote:
>
> On Fri, Nov 13, 2020 at 12:24:32PM -0800, Sami Tolvanen wrote:
> > > I still don't see this warning for some reason.
> >
> > Do you have CONFIG_XEN enabled? I can reproduce this on ToT master as follows:
> >
> > $ git rev-parse HEAD
> > 585e5b17b92dead8a3aca4e3c9876fbca5f7e0ba
> > $ make defconfig && \
> > ./scripts/config -e HYPERVISOR_GUEST -e PARAVIRT -e XEN && \
> > make olddefconfig && \
> > make -j110
> > ...
> > $ ./tools/objtool/objtool check -arfld vmlinux.o 2>&1 | grep secondary
> > vmlinux.o: warning: objtool: __startup_secondary_64()+0x2: return with
> > modified stack frame
> >
> > > Is it fixed by adding cpu_bringup_and_idle() to global_noreturns[] in
> > > tools/objtool/check.c?
> >
> > No, that didn't fix the warning. Here's what I tested:
>
> I think this fixes it:
>
> From: Josh Poimboeuf <jpoimboe@redhat.com>
> Subject: [PATCH] x86/xen: Fix objtool vmlinux.o validation of xen hypercalls
>
> Objtool vmlinux.o validation is showing warnings like the following:
>
>   # tools/objtool/objtool check -barfld vmlinux.o
>   vmlinux.o: warning: objtool: __startup_secondary_64()+0x2: return with modified stack frame
>   vmlinux.o: warning: objtool:   xen_hypercall_set_trap_table()+0x0: <=== (sym)
>
> Objtool falls through all the empty hypercall text and gets confused
> when it encounters the first real function afterwards.  The empty unwind
> hints in the hypercalls aren't working for some reason.  Replace them
> with a more straightforward use of STACK_FRAME_NON_STANDARD.
>
> Reported-by: Sami Tolvanen <samitolvanen@google.com>
> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>
> ---
>  arch/x86/xen/xen-head.S | 9 ++++-----
>  include/linux/objtool.h | 8 ++++++++
>  2 files changed, 12 insertions(+), 5 deletions(-)

Confirmed, this fixes the warning, also in LTO builds. Thanks!

Tested-by: Sami Tolvanen <samitolvanen@google.com>

Sami
