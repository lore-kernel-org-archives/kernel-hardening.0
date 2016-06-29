Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 29 Jun 2016 18:52:27 +0100
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160629175222.GA8517@leverpostej>
References: <20160628133407.10c2ea1ecd194e8085e84c5a@gmail.com>
 <20160628125748.GK31744@leverpostej>
 <20160628181456.21c1f567271b6f19fac1d886@gmail.com>
 <CAGXu5jLa20aqna_RW6Egd7Y1Wd4yajkZpj8rP5BWWZyUkfWbKQ@mail.gmail.com>
 <20160629082137.GA16387@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20160629082137.GA16387@leverpostej>
Subject: Re: [kernel-hardening] [PATCH v1 0/2] Introduce the initify gcc
 plugin
To: Kees Cook <keescook@chromium.org>
Cc: Emese Revfy <re.emese@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Michal Marek <mmarek@suse.com>, LKML <linux-kernel@vger.kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kbuild <linux-kbuild@vger.kernel.org>, minipli@ld-linux.so, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, David Brown <david.brown@linaro.org>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, jlayton@poochiereds.net, Arnd Bergmann <arnd@arndb.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jun 29, 2016 at 09:21:37AM +0100, Mark Rutland wrote:
> On Tue, Jun 28, 2016 at 01:46:04PM -0700, Kees Cook wrote:
> > On Tue, Jun 28, 2016 at 9:14 AM, Emese Revfy <re.emese@gmail.com> wrote:
> > > On Tue, 28 Jun 2016 13:57:49 +0100
> > > Mark Rutland <mark.rutland@arm.com> wrote:
> > >
> > >> On Tue, Jun 28, 2016 at 01:34:07PM +0200, Emese Revfy wrote:
> > >> > This patch set is based on the "Add support for complex gcc plugins that
> > >> > don't fit in a single file" patch set (git/kees/linux.git#kspp HEAD:
> > >> > e5d4798b284cd192c8b).
> > >>
> > >> I was hoping to give this a spin on arm/arm64, but I couldn't find the
> > >> prerequisite branch/tag/commit in that tree:
> > >>
> > >> https://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/commit/?id=e5d4798b284cd192c8b
> > >>
> > >> Where should I be looking?
> > >
> > > Sorry, this commit was disappear. You can apply these patches to this tree:
> > > https://github.com/ephox-gcc-plugins/gcc-plugins_linux-next.git (initify branch)
> > 
> > The linux-next tree should have what you need for the plugin support.
> > This is merging from my KSPP tree:
> > 
> > https://git.kernel.org/linux/kernel/git/kees/linux.git for-next/kspp
> 
> I didn't see the complex gcc plugins patch in that branch or linux-next,
> so I take it you mean a a base for applying the complex plugin patch and
> initify patches.
> 
> I'll try to give that a go shortly.

I tried to give this a go atop of kees's for-next/kspp branch, but this
doesn't seem to build. With the Linaro 15.08 AArch64 toolchain, I see:

[mark@leverpostej:~/src/linux]% uselinaro 15.08 make V=1 ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu- 
set -e; : '  CHK     include/config/kernel.release'; mkdir -p include/config/;  echo "4.7.0-rc1$(/bin/bash ./scripts/setlocalversion .)" < include/config/auto.conf > include/config/kernel.release.tmp; if [ -r include/config/kernel.release ] && cmp -s include/config/kernel.release include/config/kernel.release.tmp; then rm -f include/config/kernel.release.tmp; else : '  UPD     include/config/kernel.release'; mv -f include/config/kernel.release.tmp include/config/kernel.release; fi
make -f ./scripts/Makefile.asm-generic \
                    src=asm obj=arch/arm64/include/generated/asm
make -f ./scripts/Makefile.asm-generic \
                    src=uapi/asm obj=arch/arm64/include/generated/uapi/asm
set -e; : '  CHK     include/generated/uapi/linux/version.h'; mkdir -p include/generated/uapi/linux/;   (echo \#define LINUX_VERSION_CODE 263936; echo '#define KERNEL_VERSION(a,b,c) (((a) << 16) + ((b) << 8) + (c))';) < Makefile > include/generated/uapi/linux/version.h.tmp; if [ -r include/generated/uapi/linux/version.h ] && cmp -s include/generated/uapi/linux/version.h include/generated/uapi/linux/version.h.tmp; then rm -f include/generated/uapi/linux/version.h.tmp; else : '  UPD     include/generated/uapi/linux/version.h'; mv -f include/generated/uapi/linux/version.h.tmp include/generated/uapi/linux/version.h; fi
rm -f include/linux/version.h
set -e; : '  CHK     include/generated/utsrelease.h'; mkdir -p include/generated/;      if [ `echo -n "4.7.0-rc1+" | wc -c ` -gt 64 ]; then echo '"4.7.0-rc1+" exceeds 64 characters' >&2; exit 1; fi; (echo \#define UTS_RELEASE \"4.7.0-rc1+\";) < include/config/kernel.release > include/generated/utsrelease.h.tmp; if [ -r include/generated/utsrelease.h ] && cmp -s include/generated/utsrelease.h include/generated/utsrelease.h.tmp; then rm -f include/generated/utsrelease.h.tmp; else : '  UPD     include/generated/utsrelease.h'; mv -f include/generated/utsrelease.h.tmp include/generated/utsrelease.h; fi
mkdir -p .tmp_versions ; rm -f .tmp_versions/*
test -e include/generated/autoksyms.h || \
            touch   include/generated/autoksyms.h
make -f ./scripts/Makefile.build obj=scripts/basic
(cat /dev/null; ) > scripts/basic/modules.order
rm -f .tmp_quiet_recordmcount
make -f ./scripts/Makefile.build obj=scripts/gcc-plugins
(cat /dev/null; ) > scripts/gcc-plugins/modules.order
  g++  -shared -o scripts/gcc-plugins/initify_plugin.so   
g++: fatal error: no input files
compilation terminated.
make[1]: *** [scripts/gcc-plugins/initify_plugin.so] Error 4
make: *** [gcc-plugins] Error 2

Any ideas?

Thanks,
Mark.
