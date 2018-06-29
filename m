MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20180629190553.7282-1-labbott@redhat.com>
References: <20180629190553.7282-1-labbott@redhat.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 29 Jun 2018 13:19:47 -0700
Message-ID: <CAGXu5jL8kZHtg-MdScZ5m_6xH_Ho4TsdKGWH83zEL9Y5rutncw@mail.gmail.com>
Subject: Re: [PATCH] arm64: Clear the stack
Content-Type: text/plain; charset="UTF-8"
To: Laura Abbott <labbott@redhat.com>
Cc: Alexander Popov <alex.popov@linux.com>, Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 29, 2018 at 12:05 PM, Laura Abbott <labbott@redhat.com> wrote:
> Implementation of stackleak based heavily on the x86 version
>
> Signed-off-by: Laura Abbott <labbott@redhat.com>
> [...]
> +#define current_top_of_stack() (task_stack_page(current) + THREAD_SIZE)
> +#define on_thread_stack()      (on_task_stack(current, current_stack_pointer))

nit on types here. I get some warnings:

kernel/stackleak.c:55:12: warning: assignment makes integer from
pointer without a cast [-Wint-conversion]
   boundary = current_top_of_stack();
            ^
kernel/stackleak.c:65:24: warning: assignment makes integer from
pointer without a cast [-Wint-conversion]
  current->lowest_stack = current_top_of_stack() - THREAD_SIZE / 64;
                        ^

So I think this needs to be:

+#define current_top_of_stack() ((unsigned long)task_stack_page(current) + \
+                                THREAD_SIZE)

> diff --git a/scripts/Makefile.gcc-plugins b/scripts/Makefile.gcc-plugins
> index a535742a1c06..972ce4ca7f6a 100644
> --- a/scripts/Makefile.gcc-plugins
> +++ b/scripts/Makefile.gcc-plugins
> @@ -37,11 +37,14 @@ ifdef CONFIG_GCC_PLUGINS
>
>    gcc-plugin-$(CONFIG_GCC_PLUGIN_STACKLEAK)    += stackleak_plugin.so
>    gcc-plugin-cflags-$(CONFIG_GCC_PLUGIN_STACKLEAK)     += -DSTACKLEAK_PLUGIN -fplugin-arg-stackleak_plugin-track-min-size=$(CONFIG_STACKLEAK_TRACK_MIN_SIZE)
> +  ifdef CONFIG_GCC_PLUGIN_STACKLEAK
> +    DISABLE_STACKLEAK_PLUGIN           += -fplugin-arg-stackleak_plugin-disable
> +  endif
>
>    GCC_PLUGINS_CFLAGS := $(strip $(addprefix -fplugin=$(objtree)/scripts/gcc-plugins/, $(gcc-plugin-y)) $(gcc-plugin-cflags-y))
>
>    export PLUGINCC GCC_PLUGINS_CFLAGS GCC_PLUGIN GCC_PLUGIN_SUBDIR
> -  export SANCOV_PLUGIN DISABLE_LATENT_ENTROPY_PLUGIN
> +  export SANCOV_PLUGIN DISABLE_LATENT_ENTROPY_PLUGIN DISABLE_STACKLEAK_PLUGIN
>
>    ifneq ($(PLUGINCC),)
>      # SANCOV_PLUGIN can be only in CFLAGS_KCOV because avoid duplication.

If there is a v14, I think this hunk should be taken there, since it's
part of the common code.

Otherwise, this works for me and passes the lkdtm tests.

-Kees

-- 
Kees Cook
Pixel Security
