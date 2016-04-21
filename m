Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAK7LNAR_nmUKA7+WUDBzGSN=qXja+_DKGNcnER61Q2353Kgm0Q@mail.gmail.com>
References: <20160407231023.5f1307ffc79f0cdd880eedb7@gmail.com>
	<20160407231300.d99272db798388cad1d2e22a@gmail.com>
	<CAK7LNAR_nmUKA7+WUDBzGSN=qXja+_DKGNcnER61Q2353Kgm0Q@mail.gmail.com>
Date: Thu, 21 Apr 2016 09:55:54 -0700
Message-ID: <CAGXu5jJUvcCTOt1-Jy5YzG=HebacAeC9sbsUw5O4HMJ8UWy3Ow@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v6 2/6] GCC plugin infrastructure
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Emese Revfy <re.emese@gmail.com>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Michal Marek <mmarek@suse.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Fengguang Wu <fengguang.wu@intel.com>, Dmitry Vyukov <dvyukov@google.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, David Brown <david.brown@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Apr 12, 2016 at 7:35 PM, Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
> Hi Emese,
>
>
> 2016-04-08 6:13 GMT+09:00 Emese Revfy <re.emese@gmail.com>:
>
>> diff --git a/Makefile b/Makefile
>> index 173437d..3af7b9e 100644
>> --- a/Makefile
>> +++ b/Makefile
>> @@ -418,6 +418,8 @@ export KBUILD_AFLAGS_MODULE KBUILD_CFLAGS_MODULE KBUILD_LDFLAGS_MODULE
>>  export KBUILD_AFLAGS_KERNEL KBUILD_CFLAGS_KERNEL
>>  export KBUILD_ARFLAGS
>>
>> +export PLUGINCC GCC_PLUGINS_CFLAGS GCC_PLUGINS_AFLAGS
>> +
>>  # When compiling out-of-tree modules, put MODVERDIR in the module
>>  # tree rather than in the kernel tree. The kernel tree might
>>  # even be read-only.
>> @@ -548,7 +550,7 @@ ifeq ($(KBUILD_EXTMOD),)
>>  # in parallel
>>  PHONY += scripts
>>  scripts: scripts_basic include/config/auto.conf include/config/tristate.conf \
>> -        asm-generic
>> +        asm-generic gcc-plugins
>>         $(Q)$(MAKE) $(build)=$(@)
>>
>>  # Objects we will link into vmlinux / subdirs we need to visit
>> @@ -623,6 +625,15 @@ endif
>>  # Tell gcc to never replace conditional load with a non-conditional one
>>  KBUILD_CFLAGS  += $(call cc-option,--param=allow-store-data-races=0)
>>
>> +PHONY += gcc-plugins
>> +gcc-plugins: scripts_basic
>> +ifdef CONFIG_GCC_PLUGINS
>> +       $(Q)$(MAKE) $(build)=scripts/gcc-plugins
>> +endif
>> +       @:
>> +
>> +include scripts/Makefile.gcc-plugins
>> +
>>  ifdef CONFIG_READABLE_ASM
>>  # Disable optimizations that make assembler listings hard to read.
>>  # reorder blocks reorders the control in the function
>> @@ -949,6 +960,8 @@ endif
>>
>>  # The actual objects are generated when descending,
>>  # make sure no implicit rule kicks in
>> +$(filter-out $(init-y),$(vmlinux-deps)): KBUILD_CFLAGS += $(GCC_PLUGINS_CFLAGS)
>> +$(filter-out $(init-y),$(vmlinux-deps)): KBUILD_AFLAGS += $(GCC_PLUGINS_AFLAGS)
>>  $(sort $(vmlinux-deps)): $(vmlinux-dirs) ;
>
> I do not get your intention here.
>
> It looks like you are trying to omit plugin flags for init/ directory.
> (Actually this code is not working, though)
>
> Then, you add plug the following lines to init/Makefile
>
> +ccflags-y := $(GCC_PLUGINS_CFLAGS)
> +asflags-y := $(GCC_PLUGINS_AFLAGS)
>
>
>
>
>
>
>>  # Handle descending into subdirectories listed in $(vmlinux-dirs)
>> @@ -1001,10 +1014,13 @@ prepare1: prepare2 $(version_h) include/generated/utsrelease.h \
>>
>>  archprepare: archheaders archscripts prepare1 scripts_basic
>>
>> -prepare0: archprepare FORCE
>> +prepare0: KBUILD_CFLAGS += $(GCC_PLUGINS_CFLAGS)
>> +prepare0: KBUILD_AFLAGS += $(GCC_PLUGINS_AFLAGS)
>> +prepare0: archprepare gcc-plugins FORCE
>>         $(Q)$(MAKE) $(build)=.
>>
>>  # All the preparing..
>> +prepare: KBUILD_CFLAGS := $(filter-out $(GCC_PLUGINS_CFLAGS),$(KBUILD_CFLAGS))
>>  prepare: prepare0 prepare-objtool
>>
>>  ifdef CONFIG_STACK_VALIDATION
>> @@ -1137,6 +1153,8 @@ all: modules
>>  # using awk while concatenating to the final file.
>>
>>  PHONY += modules
>> +modules: KBUILD_CFLAGS += $(GCC_PLUGINS_CFLAGS)
>> +modules: KBUILD_AFLAGS += $(GCC_PLUGINS_AFLAGS)
>>  modules: $(vmlinux-dirs) $(if $(KBUILD_BUILTIN),vmlinux) modules.builtin
>>         $(Q)$(AWK) '!x[$$0]++' $(vmlinux-dirs:%=$(objtree)/%/modules.order) > $(objtree)/modules.order
>>         @$(kecho) '  Building modules, stage 2.';
>> @@ -1257,7 +1275,7 @@ distclean: mrproper
>>         @find $(srctree) $(RCS_FIND_IGNORE) \
>>                 \( -name '*.orig' -o -name '*.rej' -o -name '*~' \
>>                 -o -name '*.bak' -o -name '#*#' -o -name '.*.orig' \
>> -               -o -name '.*.rej' -o -name '*%'  -o -name 'core' \) \
>> +               -o -name '.*.rej' -o -name '*.so' -o -name '*%' -o -name 'core' \) \
>>                 -type f -print | xargs rm -f
>>
>>
>> @@ -1426,6 +1444,8 @@ PHONY += $(module-dirs) modules
>>  $(module-dirs): crmodverdir $(objtree)/Module.symvers
>>         $(Q)$(MAKE) $(build)=$(patsubst _module_%,%,$@)
>>
>> +modules: KBUILD_CFLAGS += $(GCC_PLUGINS_CFLAGS)
>> +modules: KBUILD_AFLAGS += $(GCC_PLUGINS_AFLAGS)
>>  modules: $(module-dirs)
>>         @$(kecho) '  Building modules, stage 2.';
>>         $(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost
>> @@ -1567,10 +1587,14 @@ else
>>          target-dir = $(if $(KBUILD_EXTMOD),$(dir $<),$(dir $@))
>>  endif
>>
>> +%.s: KBUILD_CFLAGS += $(GCC_PLUGINS_CFLAGS)
>> +%.s: KBUILD_AFLAGS += $(GCC_PLUGINS_AFLAGS)
>>  %.s: %.c prepare scripts FORCE
>>         $(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)
>>  %.i: %.c prepare scripts FORCE
>>         $(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)
>> +%.o: KBUILD_CFLAGS += $(GCC_PLUGINS_CFLAGS)
>> +%.o: KBUILD_AFLAGS += $(GCC_PLUGINS_AFLAGS)
>>  %.o: %.c prepare scripts FORCE
>>         $(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)
>>  %.lst: %.c prepare scripts FORCE
>> @@ -1589,10 +1613,14 @@ endif
>>         $(build)=$(build-dir)
>>  # Make sure the latest headers are built for Documentation
>>  Documentation/: headers_install
>> +%/: KBUILD_CFLAGS += $(GCC_PLUGINS_CFLAGS)
>> +%/: KBUILD_AFLAGS += $(GCC_PLUGINS_AFLAGS)
>>  %/: prepare scripts FORCE
>>         $(cmd_crmodverdir)
>>         $(Q)$(MAKE) KBUILD_MODULES=$(if $(CONFIG_MODULES),1) \
>>         $(build)=$(build-dir)
>> +%.ko: KBUILD_CFLAGS += $(GCC_PLUGINS_CFLAGS)
>> +%.ko: KBUILD_AFLAGS += $(GCC_PLUGINS_AFLAGS)
>>  %.ko: prepare scripts FORCE
>>         $(cmd_crmodverdir)
>>         $(Q)$(MAKE) KBUILD_MODULES=$(if $(CONFIG_MODULES),1)   \
>
>
> Why do you need to sprinkle "KBUILD_CFLAGS += $(GCC_PLUGINS_CFLAGS)"
> here and there?
>
>
> Unless I am missing something, I think the following should work.
>
>
>
> diff --git a/Makefile b/Makefile
> index 5d65f4b..f85420b 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -962,8 +962,6 @@ endif
>
>  # The actual objects are generated when descending,
>  # make sure no implicit rule kicks in
> -$(filter-out $(init-y),$(vmlinux-deps)): KBUILD_CFLAGS += $(GCC_PLUGINS_CFLAGS)
> -$(filter-out $(init-y),$(vmlinux-deps)): KBUILD_AFLAGS += $(GCC_PLUGINS_AFLAGS)
>  $(sort $(vmlinux-deps)): $(vmlinux-dirs) ;
>
>  # Handle descending into subdirectories listed in $(vmlinux-dirs)
> @@ -1016,13 +1014,10 @@ prepare1: prepare2 $(version_h)
> include/generated/utsrelease.h
>
>  archprepare: archheaders archscripts prepare1 scripts_basic
>
> -prepare0: KBUILD_CFLAGS += $(GCC_PLUGINS_CFLAGS)
> -prepare0: KBUILD_AFLAGS += $(GCC_PLUGINS_AFLAGS)
>  prepare0: archprepare gcc-plugins FORCE
>         $(Q)$(MAKE) $(build)=.
>
>  # All the preparing..
> -prepare: KBUILD_CFLAGS := $(filter-out $(GCC_PLUGINS_CFLAGS),$(KBUILD_CFLAGS))
>  prepare: prepare0 prepare-objtool
>
>  ifdef CONFIG_STACK_VALIDATION
> @@ -1155,8 +1150,6 @@ all: modules
>  # using awk while concatenating to the final file.
>
>  PHONY += modules
> -modules: KBUILD_CFLAGS += $(GCC_PLUGINS_CFLAGS)
> -modules: KBUILD_AFLAGS += $(GCC_PLUGINS_AFLAGS)
>  modules: $(vmlinux-dirs) $(if $(KBUILD_BUILTIN),vmlinux) modules.builtin
>         $(Q)$(AWK) '!x[$$0]++'
> $(vmlinux-dirs:%=$(objtree)/%/modules.order) > $(objtre
>         @$(kecho) '  Building modules, stage 2.';
> @@ -1446,8 +1439,6 @@ PHONY += $(module-dirs) modules
>  $(module-dirs): crmodverdir $(objtree)/Module.symvers
>         $(Q)$(MAKE) $(build)=$(patsubst _module_%,%,$@)
>
> -modules: KBUILD_CFLAGS += $(GCC_PLUGINS_CFLAGS)
> -modules: KBUILD_AFLAGS += $(GCC_PLUGINS_AFLAGS)
>  modules: $(module-dirs)
>         @$(kecho) '  Building modules, stage 2.';
>         $(Q)$(MAKE) -f $(srctree)/scripts/Makefile.modpost
> @@ -1589,14 +1580,10 @@ else
>          target-dir = $(if $(KBUILD_EXTMOD),$(dir $<),$(dir $@))
>  endif
>
> -%.s: KBUILD_CFLAGS += $(GCC_PLUGINS_CFLAGS)
> -%.s: KBUILD_AFLAGS += $(GCC_PLUGINS_AFLAGS)
>  %.s: %.c prepare scripts FORCE
>         $(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)
>  %.i: %.c prepare scripts FORCE
>         $(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)
> -%.o: KBUILD_CFLAGS += $(GCC_PLUGINS_CFLAGS)
> -%.o: KBUILD_AFLAGS += $(GCC_PLUGINS_AFLAGS)
>  %.o: %.c prepare scripts FORCE
>         $(Q)$(MAKE) $(build)=$(build-dir) $(target-dir)$(notdir $@)
>  %.lst: %.c prepare scripts FORCE
> @@ -1615,14 +1602,10 @@ endif
>         $(build)=$(build-dir)
>  # Make sure the latest headers are built for Documentation
>  Documentation/: headers_install
> -%/: KBUILD_CFLAGS += $(GCC_PLUGINS_CFLAGS)
> -%/: KBUILD_AFLAGS += $(GCC_PLUGINS_AFLAGS)
>  %/: prepare scripts FORCE
>         $(cmd_crmodverdir)
>         $(Q)$(MAKE) KBUILD_MODULES=$(if $(CONFIG_MODULES),1) \
>         $(build)=$(build-dir)
> -%.ko: KBUILD_CFLAGS += $(GCC_PLUGINS_CFLAGS)
> -%.ko: KBUILD_AFLAGS += $(GCC_PLUGINS_AFLAGS)
>  %.ko: prepare scripts FORCE
>         $(cmd_crmodverdir)
>         $(Q)$(MAKE) KBUILD_MODULES=$(if $(CONFIG_MODULES),1)   \
> diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
> index 25a70fb..34d6224 100644
> --- a/scripts/Makefile.gcc-plugins
> +++ b/scripts/Makefile.gcc-plugins
> @@ -26,4 +26,6 @@ ifdef CONFIG_GCC_PLUGINS
>      endif
>    endif
>
> +  KBUILD_CFLAGS += $(GCC_PLUGINS_CFLAGS)
> +
>  endif
>
>
>
>
>
>
> --
> Best Regards
> Masahiro Yamada

Hi Emese,

Any update on this? I'd love to see if we can land the plug-in
infrastructure soon.

Thanks!

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
