Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 2 May 2016 19:59:03 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160502195903.8a07c51ebf1cce1c0a1ccd6f@gmail.com>
In-Reply-To: <CAK7LNATV=DfFwqSvwMHk0RnammN=-Nx8UjAqJV5F+8BmRTtW0g@mail.gmail.com>
References: <20160422201957.97ce16f0e67377d0ce613d19@gmail.com>
	<20160422202248.f3a31c6956a9135e9bdc0205@gmail.com>
	<CAK7LNATV=DfFwqSvwMHk0RnammN=-Nx8UjAqJV5F+8BmRTtW0g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCH v7 2/6] GCC plugin infrastructure
To: kernel-hardening@lists.openwall.com
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Michal Marek <mmarek@suse.com>, Kees Cook <keescook@chromium.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Fengguang Wu <fengguang.wu@intel.com>, Dmitry Vyukov <dvyukov@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, David Brown <david.brown@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 2 May 2016 14:07:35 +0900
Masahiro Yamada <yamada.masahiro@socionext.com> wrote:

Hi,

> > diff --git a/arch/x86/entry/vdso/Makefile b/arch/x86/entry/vdso/Makefile
> > index 253b72e..f912316 100644
> > --- a/arch/x86/entry/vdso/Makefile
> > +++ b/arch/x86/entry/vdso/Makefile
> > @@ -75,7 +75,7 @@ CFL := $(PROFILING) -mcmodel=small -fPIC -O2 -fasynchronous-unwind-tables -m64 \
> >         -fno-omit-frame-pointer -foptimize-sibling-calls \
> >         -DDISABLE_BRANCH_PROFILING -DBUILD_VDSO
> >
> > -$(vobjs): KBUILD_CFLAGS += $(CFL)
> > +$(vobjs): KBUILD_CFLAGS := $(filter-out $(GCC_PLUGINS_CFLAGS),$(KBUILD_CFLAGS)) $(CFL)
> >
> >  #
> >  # vDSO code runs in userspace and -pg doesn't help with profiling anyway.
> > @@ -145,6 +145,7 @@ KBUILD_CFLAGS_32 := $(filter-out -m64,$(KBUILD_CFLAGS))
> >  KBUILD_CFLAGS_32 := $(filter-out -mcmodel=kernel,$(KBUILD_CFLAGS_32))
> >  KBUILD_CFLAGS_32 := $(filter-out -fno-pic,$(KBUILD_CFLAGS_32))
> >  KBUILD_CFLAGS_32 := $(filter-out -mfentry,$(KBUILD_CFLAGS_32))
> > +KBUILD_CFLAGS_32 := $(filter-out $(GCC_PLUGINS_CFLAGS),$(KBUILD_CFLAGS_32))
> >  KBUILD_CFLAGS_32 += -m32 -msoft-float -mregparm=0 -fpic
> >  KBUILD_CFLAGS_32 += $(call cc-option, -fno-stack-protector)
> >  KBUILD_CFLAGS_32 += $(call cc-option, -foptimize-sibling-calls)
> 
> 
> Looks like gcc-plugins should be omitted only for this directory.
> Please tell me why.
> I am not familiar with x86 architecture, so this is not clear to me.

The vdso is userland code so in general kernel instrumentation/analysis doesn't apply to it.

-- 
Emese
