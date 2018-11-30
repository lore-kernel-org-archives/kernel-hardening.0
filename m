MIME-Version: 1.0
References: <20181127001534.24075-1-ard.biesheuvel@linaro.org> <nycvar.YSQ.7.76.1811291742340.3623@knanqh.ubzr>
In-Reply-To: <nycvar.YSQ.7.76.1811291742340.3623@knanqh.ubzr>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Fri, 30 Nov 2018 09:42:05 +0100
Message-ID: <CAKv+Gu-kSnndPqmC4_+JOUPbMk4cGmtTktS9WE+Z8_mse9y-2Q@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH v2] ARM: smp: add support for per-task stack canaries
Content-Type: text/plain; charset="UTF-8"
To: Nicolas Pitre <nicolas.pitre@linaro.org>, Kees Cook <keescook@chromium.org>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Russell King <linux@armlinux.org.uk>, Emese Revfy <re.emese@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Laura Abbott <labbott@redhat.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 29 Nov 2018 at 23:58, Nicolas Pitre <nicolas.pitre@linaro.org> wrote:
>
> On Tue, 27 Nov 2018, Ard Biesheuvel wrote:
>
> > On ARM, we currently only change the value of the stack canary when
> > switching tasks if the kernel was built for UP. On SMP kernels, this
> > is impossible since the stack canary value is obtained via a global
> > symbol reference, which means
> > a) all running tasks on all CPUs must use the same value
> > b) we can only modify the value when no kernel stack frames are live
> >    on any CPU, which is effectively never.
> >
> > So instead, use a GCC plugin to add a RTL pass that replaces each
> > reference to the address of the __stack_chk_guard symbol with an
> > expression that produces the address of the 'stack_canary' field
> > that is added to struct thread_info. This way, each task will use
> > its own randomized value.
> >
> > Cc: Russell King <linux@armlinux.org.uk>
> > Cc: Kees Cook <keescook@chromium.org>
> > Cc: Emese Revfy <re.emese@gmail.com>
> > Cc: Arnd Bergmann <arnd@arndb.de>
> > Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
> > Cc: Laura Abbott <labbott@redhat.com>
> > Cc: kernel-hardening@lists.openwall.com
> > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> > ---
> > v2:
> > - adopt powerpc Makefile approach to pass stack canary offset and thread
> >   size to the plugin as command line arguments
> > - depend on !XIP_DEFLATED_DATA
> >
> >  arch/arm/Kconfig                              |  16 +++
> >  arch/arm/Makefile                             |  11 +++
> >  arch/arm/boot/compressed/Makefile             |   1 +
> >  arch/arm/include/asm/stackprotector.h         |  12 ++-
> >  arch/arm/include/asm/thread_info.h            |   3 +
> >  arch/arm/kernel/asm-offsets.c                 |   1 +
> >  arch/arm/kernel/process.c                     |   6 +-
> >  scripts/Makefile.gcc-plugins                  |   6 ++
> >  scripts/gcc-plugins/Kconfig                   |   4 +
> >  scripts/gcc-plugins/arm_ssp_per_task_plugin.c | 103 ++++++++++++++++++++
> >  10 files changed, 160 insertions(+), 3 deletions(-)
> >
> > diff --git a/arch/arm/Kconfig b/arch/arm/Kconfig
> > index 91be74d8df65..6142e83b45da 100644
> > --- a/arch/arm/Kconfig
> > +++ b/arch/arm/Kconfig
> > @@ -1810,6 +1810,22 @@ config XEN
> >       help
> >         Say Y if you want to run Linux in a Virtual Machine on Xen on ARM.
> >
> > +config STACKPROTECTOR_PER_TASK
> > +     bool "Use a unique stack canary value for each task"
> > +     depends on GCC_PLUGINS && STACKPROTECTOR && SMP && !XIP_DEFLATED_DATA
> > +     select GCC_PLUGIN_ARM_SSP_PER_TASK
> > +     help
> > +       Due to the fact that GCC uses an ordinary symbol reference from
> > +       which to load the value of the stack canary, this value can only
> > +       change at reboot time on SMP systems, and all tasks running in the
> > +       kernel's address space are forced to use the same canary value for
> > +       the entire duration that the system is up.
> > +
> > +       Enable this option to switch to a different method that uses a
> > +       different canary value for each task.
> > +
> > +       This is not enabled by default since it relies on a GCC plugin.
>
> Why wouldn't you default it to y and let the dependencies disable it
> when not met?
>
> Other than that:
>
> Acked-by: Nicolas Pitre <nico@linaro.org>
>

Thanks Nico.

I wasn't sure about enabling it by default, though. Perhaps Kees has
any insights?
