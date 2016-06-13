Return-Path: <linux-next-owner@vger.kernel.org>
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20160611161212.GA29370@www.outflux.net>
References: <20160611161212.GA29370@www.outflux.net>
From: Sedat Dilek <sedat.dilek@gmail.com>
Date: Mon, 13 Jun 2016 10:40:11 +0200
Message-ID: <CA+icZUW-OZMh2foyiQK=0NfakwbiFHTkouMjptgokKTFLZQFQQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-next-owner@vger.kernel.org
Subject: Re: [PATCH] gcc-plugins: disable under COMPILE_TEST
Content-Transfer-Encoding: 8bit
To: Kees Cook <keescook@chromium.org>
Cc: Michal Marek <mmarek@suse.com>, Stephen Rothwell <sfr@canb.auug.org.au>, Emese Revfy <re.emese@gmail.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Sudip Mukherjee <sudipm.mukherjee@gmail.com>, Linux-Next <linux-next@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Jun 11, 2016 at 6:12 PM, Kees Cook <keescook@chromium.org> wrote:
> Since adding the gcc plugin development headers is required for the
> gcc plugin support, we should ease into this new kernel build dependency
> more slowly. For now, disable the gcc plugins under COMPILE_TEST so that
> all*config builds will skip it.
>

[ This might be a bit off-topic - Feel free to answer ]

Hi,

I want to try that new "GCC-plugin" feature.
Do you have a Git repo for "easy-testing"?

Does the kernel's build-system check for installed "gcc-plugin
development headers"?
Which GCC versions support "gcc-plugin" feature?
I am here on Ubuntu/precise AMD64 and have gcc-4.6.4 and gcc-4.9.2.

[ Optional ]
What about the topic and support for "LLVM/Clang and hardening" of the
Linux-kernel?

Regards,
- Sedat -

> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  arch/Kconfig      | 1 +
>  lib/Kconfig.debug | 4 ++--
>  2 files changed, 3 insertions(+), 2 deletions(-)
>
> diff --git a/arch/Kconfig b/arch/Kconfig
> index 83aa2a3c470d..3f06d678b1d7 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -366,6 +366,7 @@ config HAVE_GCC_PLUGINS
>  menuconfig GCC_PLUGINS
>         bool "GCC plugins"
>         depends on HAVE_GCC_PLUGINS
> +       depends on !COMPILE_TEST
>         help
>           GCC plugins are loadable modules that provide extra features to the
>           compiler. They are useful for runtime instrumentation and static analysis.
> diff --git a/lib/Kconfig.debug b/lib/Kconfig.debug
> index d40833b9b7f4..0f9981999a27 100644
> --- a/lib/Kconfig.debug
> +++ b/lib/Kconfig.debug
> @@ -713,8 +713,8 @@ config KCOV
>         bool "Code coverage for fuzzing"
>         depends on ARCH_HAS_KCOV
>         select DEBUG_FS
> -       select GCC_PLUGINS
> -       select GCC_PLUGIN_SANCOV
> +       select GCC_PLUGINS if !COMPILE_TEST
> +       select GCC_PLUGIN_SANCOV if !COMPILE_TEST
>         help
>           KCOV exposes kernel code coverage information in a form suitable
>           for coverage-guided fuzzing (randomized testing).
> --
> 2.7.4
>
>
> --
> Kees Cook
> Chrome OS & Brillo Security
> --
> To unsubscribe from this list: send the line "unsubscribe linux-next" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
