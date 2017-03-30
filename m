MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170330032752.kjh2fml4itgrkrnm@jeyu>
References: <20170326210825.23255-3-ewk@edkovsky.org> <201703271633.xbYHmB37%fengguang.wu@intel.com>
 <CAGXu5jKFPwDTaRq8eiszOoqdm-nQD13UrF_bj+m6FWWCzEnO9g@mail.gmail.com>
 <20170329032825.GA1325@athena> <20170330032752.kjh2fml4itgrkrnm@jeyu>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 30 Mar 2017 09:24:14 -0700
Message-ID: <CAGXu5jLpZ=2GDK4LRJJwvpz-52Ftx75wsJJGoXsWysWooZv68A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v4 2/2] extable: verify address is read-only
To: Jessica Yu <jeyu@redhat.com>
Cc: Jakub Kicinski <jakub.kicinski@netronome.com>, Catalin Marinas <catalin.marinas@arm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, kbuild-all@01.org, kbuild test robot <lkp@intel.com>, Rusty Russell <rusty@rustcorp.com.au>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 29, 2017 at 8:27 PM, Jessica Yu <jeyu@redhat.com> wrote:
> +++ Eddie Kovsky [28/03/17 21:28 -0600]:
>
>> On 03/27/17, Kees Cook wrote:
>>>
>>> On Mon, Mar 27, 2017 at 1:43 AM, kbuild test robot <lkp@intel.com> wrote:
>>> > Hi Eddie,
>>> >
>>> > [auto build test ERROR on next-20170323]
>>> > [cannot apply to linus/master linux/master jeyu/modules-next v4.9-rc8
>>> > v4.9-rc7 v4.9-rc6 v4.11-rc4]
>>> > [if your patch is applied to the wrong git tree, please drop us a note
>>> > to help improve the system]
>>> >
>>> > url:
>>> > https://github.com/0day-ci/linux/commits/Eddie-Kovsky/module-verify-address-is-read-only/20170327-142922
>>> > config: blackfin-BF561-EZKIT-SMP_defconfig (attached as .config)
>>> > compiler: bfin-uclinux-gcc (GCC) 6.2.0
>>> > reproduce:
>>> >         wget
>>> > https://raw.githubusercontent.com/01org/lkp-tests/master/sbin/make.cross -O
>>> > ~/bin/make.cross
>>> >         chmod +x ~/bin/make.cross
>>> >         # save the attached .config to linux build tree
>>> >         make.cross ARCH=blackfin
>>> >
>>> > All errors (new ones prefixed by >>):
>>> >
>>> >    kernel/built-in.o: In function `core_kernel_rodata':
>>> >>> kernel/extable.c:169: undefined reference to
>>> >>> `__start_data_ro_after_init'
>>> >>> kernel/extable.c:169: undefined reference to
>>> >>> `__start_data_ro_after_init'
>>> >>> kernel/extable.c:169: undefined reference to
>>> >>> `__end_data_ro_after_init'
>>> >>> kernel/extable.c:169: undefined reference to
>>> >>> `__end_data_ro_after_init'
>>> >>> kernel/extable.c:169: undefined reference to
>>> >>> `__start_data_ro_after_init'
>>> >>> kernel/extable.c:169: undefined reference to
>>> >>> `__start_data_ro_after_init'
>>> >>> kernel/extable.c:169: undefined reference to
>>> >>> `__end_data_ro_after_init'
>>> >>> kernel/extable.c:169: undefined reference to
>>> >>> `__end_data_ro_after_init'
>>>
>>> Hm, I'm confused about this. blackfin includes
>>> include/asm-generic-vmlinux.lds.h and uses the RO_DATA macro (which
>>> resolves to RO_DATA_SECTION to RO_AFTER_INIT_DATA which defines
>>> __[start|end]_data_ro_after_init.
>>>
>>> Also, it seems that commit d7c19b066dcf4bd19c4385e8065558d4e74f9e73
>>> ("mm: kmemleak: scan .data.ro_after_init") added a potentially
>>> redundant section name (s390 already calls this
>>> __[start|end]_ro_after_init). I'd like to get this cleaned up, since
>>> having multiple names for the same thing is confusing:
>>>
>>> diff --git a/arch/s390/kernel/vmlinux.lds.S
>>> b/arch/s390/kernel/vmlinux.lds.S
>>> index 000e6e91f6a0..3667d20e997f 100644
>>> --- a/arch/s390/kernel/vmlinux.lds.S
>>> +++ b/arch/s390/kernel/vmlinux.lds.S
>>> @@ -62,9 +62,11 @@ SECTIONS
>>>
>>>         . = ALIGN(PAGE_SIZE);
>>>         __start_ro_after_init = .;
>>> +       __start_data_ro_after_init = .;
>>>         .data..ro_after_init : {
>>>                  *(.data..ro_after_init)
>>>         }
>>> +       __end_data_ro_after_init = .;
>>>         EXCEPTION_TABLE(16)
>>>         . = ALIGN(PAGE_SIZE);
>>>         __end_ro_after_init = .;
>>>
>>> And it seems that this hunk is wrong (__end_ro_after_init includes
>>> s390's exception table, etc). I think we should remove the
>>> ..._data_... name and use s390's name.
>>>
>>> I'll send an adjustment patch, but we'll still need to deal with
>>> blackfin.
>>>
>>> -Kees
>>>
>>
>> Kees
>>
>> I applied your patch (mm: fix section name for .data..ro_after_init) and
>> changed the new function in extable.c to use __[start|end]_ro_after_init
>> instead. The new version still builds without errors on x86, which isn't
>> surprising.
>>
>> I've cross compiled this for blackfin and I'm able to reproduce the
>> build error. I'm still not sure why. As you pointed out, blackfin does
>> appear to use 'include/asm-generic/vmlinux.lds.h'.
>
>
> This appears to be because blackfin is one of the 2 arches that
> prepends an underscore '_' to all symbols defined in C. I noticed that
> __{start,end}_data_ro_after_init in vmlinux.lds.h are not wrapped with
> VMLINUX_SYMBOL() which adds the necessary prefix for arches that have
> HAVE_UNDERSCORE_SYMBOL_PREFIX, hence the undefined reference.

Argh. Thank you for catching this! Yeah, that would have taken me
forever to find.

> The below patch fixed the build error for me, if it works for you then
> I can send a formal patch.
>
> diff --git a/include/asm-generic/vmlinux.lds.h
> b/include/asm-generic/vmlinux.lds.h
> index 4e09b28..7b262f7 100644
> --- a/include/asm-generic/vmlinux.lds.h
> +++ b/include/asm-generic/vmlinux.lds.h
> @@ -260,9 +260,9 @@
>  */
> #ifndef RO_AFTER_INIT_DATA
> #define RO_AFTER_INIT_DATA                                              \
> -       __start_data_ro_after_init = .;                                 \
> +       VMLINUX_SYMBOL(__start_data_ro_after_init) = .;                 \
>         *(.data..ro_after_init)                                         \
> -       __end_data_ro_after_init = .;
> +       VMLINUX_SYMBOL(__end_data_ro_after_init) = .;
> #endif

I don't have a blackfin cross-compiler set up, but I'm sure that'll
fix it. If you can, please base it on -next, since I rename
__[start|end]_data_ro_after_init to __[start|end]_ro_after_init (to
match the existing s390 symbols of the same purpose):

https://lkml.org/lkml/2017/3/27/685

akpm is carrying that patch, so this follow-up should likely go to him too.

Thanks!

-Kees

-- 
Kees Cook
Pixel Security
