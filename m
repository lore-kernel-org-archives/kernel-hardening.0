MIME-Version: 1.0
Sender: arndbergmann@gmail.com
In-Reply-To: <1495829844-69341-5-git-send-email-keescook@chromium.org>
References: <1495829844-69341-1-git-send-email-keescook@chromium.org> <1495829844-69341-5-git-send-email-keescook@chromium.org>
From: Arnd Bergmann <arnd@arndb.de>
Date: Fri, 30 Jun 2017 00:08:57 +0200
Message-ID: <CAK8P3a0beV+ZUUKxzufXtZRszbXvgC3eQO4Rc1+ZYo_nAmcaaA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH v2 04/20] gcc-plugins: Add the randstruct plugin
To: Kees Cook <keescook@chromium.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Laura Abbott <labbott@redhat.com>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, May 26, 2017 at 10:17 PM, Kees Cook <keescook@chromium.org> wrote:
> This feature is ported from grsecurity. The implementation is almost
> entirely identical to the original code written by the PaX Team and
> Brad Spengler.

Hi Kees,

I noticed new build errors that bisected back to this patch, which has
now showed up
in linux-next again:


/git/arm-soc/arch/arm/kernel/entry-armv.S: Assembler messages:
/git/arm-soc/arch/arm/kernel/entry-armv.S:800: Error: bad immediate
value for offset (4644)
/git/arm-soc/scripts/Makefile.build:403: recipe for target
'arch/arm/kernel/entry-armv.o' failed
make[3]: *** [arch/arm/kernel/entry-armv.o] Error 1
/git/arm-soc/arch/arm/kernel/entry-armv.S: Assembler messages:
/git/arm-soc/arch/arm/kernel/entry-armv.S:800: Error: bad immediate
value for offset (5584)
/git/arm-soc/scripts/Makefile.build:403: recipe for target
'arch/arm/kernel/entry-armv.o' failed
make[3]: *** [arch/arm/kernel/entry-armv.o] Error 1
/git/arm-soc/arch/arm/mm/tlb-v4.S: Assembler messages:
/git/arm-soc/arch/arm/mm/tlb-v4.S:35: Error: bad immediate value for
offset (4928)
/git/arm-soc/scripts/Makefile.build:403: recipe for target
'arch/arm/mm/tlb-v4.o' failed
make[3]: *** [arch/arm/mm/tlb-v4.o] Error 1
/git/arm-soc/arch/arm/mm/tlb-v4wbi.S: Assembler messages:
/git/arm-soc/arch/arm/mm/tlb-v4wbi.S:34: Error: bad immediate value
for offset (4928)
/git/arm-soc/scripts/Makefile.build:403: recipe for target
'arch/arm/mm/tlb-v4wbi.o' failed

So far, that's the only thing that goes wrong for me though, and this
is probably
easy to fix.

        Arnd
