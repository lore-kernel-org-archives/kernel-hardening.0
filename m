MIME-Version: 1.0
References: <20190408170418.148554-1-glider@google.com> <20190408170418.148554-3-glider@google.com>
In-Reply-To: <20190408170418.148554-3-glider@google.com>
From: Jann Horn <jannh@google.com>
Date: Mon, 8 Apr 2019 19:39:18 +0200
Message-ID: <CAG48ez0BJNhfaCJde0UWrNLztsuAKR3QCm+d-j_Qa3R_KDSKHA@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] initmem: introduce CONFIG_INIT_ALL_HEAP
Content-Type: text/plain; charset="UTF-8"
To: Alexander Potapenko <glider@google.com>
Cc: Masahiro Yamada <yamada.masahiro@socionext.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, linux-security-module <linux-security-module@vger.kernel.org>, linux-kbuild@vger.kernel.org, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Kees Cook <keescook@chromium.org>, sspatil@android.com, Kernel Hardening <kernel-hardening@lists.openwall.com>, Laura Abbott <labbott@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Apr 8, 2019 at 7:20 PM Alexander Potapenko <glider@google.com> wrote:
> This config option enables CONFIG_SLUB_DEBUG and CONFIG_PAGE_POISONING
> without the need to pass any boot parameters.
>
> No performance optimizations are done at the moment to reduce double
> initialization of memory regions.
[...]
> diff --git a/mm/page_poison.c b/mm/page_poison.c
> index 21d4f97cb49b..a1985f33f635 100644
> --- a/mm/page_poison.c
> +++ b/mm/page_poison.c
> @@ -12,9 +12,14 @@ static bool want_page_poisoning __read_mostly;
>
>  static int __init early_page_poison_param(char *buf)
>  {
> +#ifdef CONFIG_INIT_ALL_HEAP
> +       want_page_poisoning = true;
> +       return 0;
> +#else
>         if (!buf)
>                 return -EINVAL;
>         return strtobool(buf, &want_page_poisoning);
> +#endif
>  }
>  early_param("page_poison", early_page_poison_param);
>
> diff --git a/mm/slub.c b/mm/slub.c
> index 1b08fbcb7e61..00e0197d3f35 100644
> --- a/mm/slub.c
> +++ b/mm/slub.c
> @@ -1287,6 +1287,8 @@ static int __init setup_slub_debug(char *str)
>         if (*str == ',')
>                 slub_debug_slabs = str + 1;
>  out:
> +       if (IS_ENABLED(CONFIG_INIT_ALL_HEAP))
> +               slub_debug |= SLAB_POISON;
>         return 1;
>  }

I don't understand how this is supposed to work. As far as I can tell,
the "slub_debug |= SLAB_POISON;" only happens if you actually pass in
a "slub_debug" boot parameter? Same thing for "want_page_poisoning =
true;".

Also, didn't Laura suggest in
https://www.openwall.com/lists/kernel-hardening/2019/04/08/4 that a
different approach might be more sensible to reduce the performance
hit?
