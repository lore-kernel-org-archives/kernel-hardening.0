Date: Tue, 28 Mar 2017 21:28:25 -0600
From: Eddie Kovsky <ewk@edkovsky.org>
Message-ID: <20170329032825.GA1325@athena>
References: <20170326210825.23255-3-ewk@edkovsky.org>
 <201703271633.xbYHmB37%fengguang.wu@intel.com>
 <CAGXu5jKFPwDTaRq8eiszOoqdm-nQD13UrF_bj+m6FWWCzEnO9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jKFPwDTaRq8eiszOoqdm-nQD13UrF_bj+m6FWWCzEnO9g@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v4 2/2] extable: verify address is read-only
To: Kees Cook <keescook@chromium.org>
Cc: Jakub Kicinski <jakub.kicinski@netronome.com>, Catalin Marinas <catalin.marinas@arm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, kbuild-all@01.org, kbuild test robot <lkp@intel.com>, Jessica Yu <jeyu@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 03/27/17, Kees Cook wrote:
> On Mon, Mar 27, 2017 at 1:43 AM, kbuild test robot <lkp@intel.com> wrote:
> > Hi Eddie,
> >
> > [auto build test ERROR on next-20170323]
> > [cannot apply to linus/master linux/master jeyu/modules-next v4.9-rc8 v4.9-rc7 v4.9-rc6 v4.11-rc4]
> > [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
> >
> > url:    https://github.com/0day-ci/linux/commits/Eddie-Kovsky/module-verify-address-is-read-only/20170327-142922
> > config: blackfin-BF561-EZKIT-SMP_defconfig (attached as .config)
> > compiler: bfin-uclinux-gcc (GCC) 6.2.0
> > reproduce:
> >         wget https://raw.githubusercontent.com/01org/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
> >         chmod +x ~/bin/make.cross
> >         # save the attached .config to linux build tree
> >         make.cross ARCH=blackfin
> >
> > All errors (new ones prefixed by >>):
> >
> >    kernel/built-in.o: In function `core_kernel_rodata':
> >>> kernel/extable.c:169: undefined reference to `__start_data_ro_after_init'
> >>> kernel/extable.c:169: undefined reference to `__start_data_ro_after_init'
> >>> kernel/extable.c:169: undefined reference to `__end_data_ro_after_init'
> >>> kernel/extable.c:169: undefined reference to `__end_data_ro_after_init'
> >>> kernel/extable.c:169: undefined reference to `__start_data_ro_after_init'
> >>> kernel/extable.c:169: undefined reference to `__start_data_ro_after_init'
> >>> kernel/extable.c:169: undefined reference to `__end_data_ro_after_init'
> >>> kernel/extable.c:169: undefined reference to `__end_data_ro_after_init'
> 
> Hm, I'm confused about this. blackfin includes
> include/asm-generic-vmlinux.lds.h and uses the RO_DATA macro (which
> resolves to RO_DATA_SECTION to RO_AFTER_INIT_DATA which defines
> __[start|end]_data_ro_after_init.
> 
> Also, it seems that commit d7c19b066dcf4bd19c4385e8065558d4e74f9e73
> ("mm: kmemleak: scan .data.ro_after_init") added a potentially
> redundant section name (s390 already calls this
> __[start|end]_ro_after_init). I'd like to get this cleaned up, since
> having multiple names for the same thing is confusing:
> 
> diff --git a/arch/s390/kernel/vmlinux.lds.S b/arch/s390/kernel/vmlinux.lds.S
> index 000e6e91f6a0..3667d20e997f 100644
> --- a/arch/s390/kernel/vmlinux.lds.S
> +++ b/arch/s390/kernel/vmlinux.lds.S
> @@ -62,9 +62,11 @@ SECTIONS
> 
>         . = ALIGN(PAGE_SIZE);
>         __start_ro_after_init = .;
> +       __start_data_ro_after_init = .;
>         .data..ro_after_init : {
>                  *(.data..ro_after_init)
>         }
> +       __end_data_ro_after_init = .;
>         EXCEPTION_TABLE(16)
>         . = ALIGN(PAGE_SIZE);
>         __end_ro_after_init = .;
> 
> And it seems that this hunk is wrong (__end_ro_after_init includes
> s390's exception table, etc). I think we should remove the
> ..._data_... name and use s390's name.
> 
> I'll send an adjustment patch, but we'll still need to deal with blackfin.
> 
> -Kees
> 

Kees

I applied your patch (mm: fix section name for .data..ro_after_init) and
changed the new function in extable.c to use __[start|end]_ro_after_init
instead. The new version still builds without errors on x86, which isn't
surprising.

I've cross compiled this for blackfin and I'm able to reproduce the
build error. I'm still not sure why. As you pointed out, blackfin does
appear to use 'include/asm-generic/vmlinux.lds.h'. 

Eddie

> >
> > vim +169 kernel/extable.c
> >
> >    163  int core_kernel_rodata(unsigned long addr)
> >    164  {
> >    165          if (addr >= (unsigned long)__start_rodata &&
> >    166              addr < (unsigned long)__end_rodata)
> >    167                  return 1;
> >    168
> >  > 169          if (addr >= (unsigned long)__start_data_ro_after_init &&
> >    170              addr < (unsigned long)__end_data_ro_after_init)
> >    171                  return 1;
> >    172
> >
> > ---
> > 0-DAY kernel test infrastructure                Open Source Technology Center
> > https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
> 
> 
> 
> -- 
> Kees Cook
> Pixel Security
