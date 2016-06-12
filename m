Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160613001244.b4b3c675d59e3ad3d8d656a4@gmail.com>
References: <20160611161212.GA29370@www.outflux.net> <20160611162926.GL12567@windriver.com>
 <20160613001244.b4b3c675d59e3ad3d8d656a4@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Sun, 12 Jun 2016 15:25:39 -0700
Message-ID: <CAGXu5jJ_+azG6H0tB7W0mJTUzXp18Y7qN7dx7EEKng+0nO-dig@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] gcc-plugins: disable under COMPILE_TEST
To: Emese Revfy <re.emese@gmail.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, Michal Marek <mmarek@suse.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Sudip Mukherjee <sudipm.mukherjee@gmail.com>, Linux-Next <linux-next@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jun 12, 2016 at 3:12 PM, Emese Revfy <re.emese@gmail.com> wrote:
> On Sat, 11 Jun 2016 12:29:26 -0400
> Paul Gortmaker <paul.gortmaker@windriver.com> wrote:
>
>> [[PATCH] gcc-plugins: disable under COMPILE_TEST] On 11/06/2016 (Sat 09:12) Kees Cook wrote:
>>
>> > Since adding the gcc plugin development headers is required for the
>> > gcc plugin support, we should ease into this new kernel build dependency
>> > more slowly. For now, disable the gcc plugins under COMPILE_TEST so that
>> > all*config builds will skip it.
>>
>> Wouldn't it be better to test compile a one line program that tries to
>> source the header(s) and then react accordingly?
>
> The scripts/gcc-plugin.sh script does exactly that.
>
>> Then at least you would get the test coverage from people who have the
>> headers installed who are doing all[yes|mod]config.  This "for now"
>> solution doesn't really have a path forward other than assuming all
>> distros install the plugin headers sometime in the future.
>>
>> Either way, this is an improvement over the current situation, so thanks
>> for that.
>
> If it is not too late I think this patch would be better:

I don't like this because it means if someone specifically selects
some plugins in their .config, and the headers are missing, the kernel
will successfully compile. For many plugins, this results in a kernel
that lacks the requested security features, and that I really do not
want to have happening. I'm okay leaving these disabled for compile
tests for now. We can revisit this once more distros have plugins
enabled by default.

-Kees

>
>
> When there is no gcc plugin support then don't compile the plugins
> (but still print a warning). This allows building allyes/allmod configs
> until the gcc plugin headers get installed.
>
> Signed-off-by: Emese Revfy <re.emese@gmail.com>
> ---
>  Makefile                     | 6 +++---
>  scripts/Makefile.gcc-plugins | 8 ++++----
>  2 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/Makefile b/Makefile
> index a49c075..715210c 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -623,15 +623,15 @@ endif
>  # Tell gcc to never replace conditional load with a non-conditional one
>  KBUILD_CFLAGS  += $(call cc-option,--param=allow-store-data-races=0)
>
> +include scripts/Makefile.gcc-plugins
> +
>  PHONY += gcc-plugins
>  gcc-plugins: scripts_basic
> -ifdef CONFIG_GCC_PLUGINS
> +ifneq ($(GCC_PLUGINS_CFLAGS),)
>         $(Q)$(MAKE) $(build)=scripts/gcc-plugins
>  endif
>         @:
>
> -include scripts/Makefile.gcc-plugins
> -
>  ifdef CONFIG_READABLE_ASM
>  # Disable optimizations that make assembler listings hard to read.
>  # reorder blocks reorders the control in the function
> diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
> index c7372cb..2f101ea 100644
> --- a/scripts/Makefile.gcc-plugins
> +++ b/scripts/Makefile.gcc-plugins
> @@ -21,6 +21,7 @@ ifdef CONFIG_GCC_PLUGINS
>          CFLAGS_KCOV := $(SANCOV_PLUGIN)
>        else
>          $(warning warning: cannot use CONFIG_KCOV: -fsanitize-coverage=trace-pc is not supported by compiler)
> +        CFLAGS_KCOV =
>        endif
>      endif
>    endif
> @@ -37,13 +38,12 @@ ifdef CONFIG_GCC_PLUGINS
>        else
>          $(warning warning: your gcc version does not support plugins, you should upgrade it to gcc 4.5 at least)
>        endif
> +      GCC_PLUGINS_CFLAGS =
>      endif
> -  else
> -    # SANCOV_PLUGIN can be only in CFLAGS_KCOV because avoid duplication.
> -    GCC_PLUGINS_CFLAGS := $(filter-out $(SANCOV_PLUGIN), $(GCC_PLUGINS_CFLAGS))
>    endif
>
> -  KBUILD_CFLAGS += $(GCC_PLUGINS_CFLAGS)
> +  # SANCOV_PLUGIN can be only in CFLAGS_KCOV because avoid duplication.
> +  KBUILD_CFLAGS += $(filter-out $(SANCOV_PLUGIN), $(GCC_PLUGINS_CFLAGS))
>    GCC_PLUGIN := $(gcc-plugin-y)
>
>  endif
>
> --
> 2.8.1



-- 
Kees Cook
Chrome OS & Brillo Security
