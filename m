MIME-Version: 1.0
References: <20190308132701.133598-1-glider@google.com> <20190308132701.133598-3-glider@google.com>
In-Reply-To: <20190308132701.133598-3-glider@google.com>
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Date: Fri, 5 Apr 2019 20:35:26 +0900
Message-ID: <CAK7LNARV+_RNE4E5H37e9wH6iPyrzqsLtcWd0wLSt+vsEvncRA@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] initmem: introduce CONFIG_INIT_ALL_HEAP
Content-Type: text/plain; charset="UTF-8"
To: Alexander Potapenko <glider@google.com>
Cc: James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, linux-security-module@vger.kernel.org, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, Nick Desaulniers <ndesaulniers@google.com>, kcc@google.com, Dmitry Vyukov <dvyukov@google.com>, Kees Cook <keescook@chromium.org>, sspatil@android.com, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Mar 8, 2019 at 10:27 PM Alexander Potapenko <glider@google.com> wrote:
>
> diff --git a/security/Kconfig.initmem b/security/Kconfig.initmem
> index 27aec394365e..5ce49663777a 100644
> --- a/security/Kconfig.initmem
> +++ b/security/Kconfig.initmem
> @@ -13,6 +13,17 @@ config INIT_ALL_MEMORY
>
>  if INIT_ALL_MEMORY
>
> +config INIT_ALL_HEAP
> +       bool "Initialize all heap"
> +       depends on INIT_ALL_MEMORY
> +       select CONFIG_PAGE_POISONING
> +       select CONFIG_PAGE_POISONING_NO_SANITY
> +       select CONFIG_PAGE_POISONING_ZERO
> +       select CONFIG_SLUB_DEBUG

This should like follows (no CONFIG_ prefix):

         select PAGE_POISONING
         select PAGE_POISONING_NO_SANITY
         select PAGE_POISONING_ZERO
         select SLUB_DEBUG

But, again, this causes unmet dependency if SLUB=n





> +       default y
> +       help
> +         Enable page poisoning and slub poisoning by default.
> +
>  config INIT_ALL_STACK
>         bool "Initialize all stack"
>         depends on INIT_ALL_MEMORY
> --
> 2.21.0.360.g471c308f928-goog
>


--
Best Regards
Masahiro Yamada
