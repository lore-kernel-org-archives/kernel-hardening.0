MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1490811363-93944-2-git-send-email-keescook@chromium.org>
References: <1490811363-93944-1-git-send-email-keescook@chromium.org> <1490811363-93944-2-git-send-email-keescook@chromium.org>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 29 Mar 2017 11:23:57 -0700
Message-ID: <CAGXu5jJuuUSwS61d7Joc=6y2BUyTo6koEsrVxeqMu_u7j9Mb9w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC v2][PATCH 01/11] Introduce rare_write() infrastructure
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>, Hoeun Ryu <hoeun.ryu@gmail.com>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 29, 2017 at 11:15 AM, Kees Cook <keescook@chromium.org> wrote:
> +/*
> + * Build "write rarely" infrastructure for flipping memory r/w
> + * on a per-CPU basis.
> + */
> +#ifndef CONFIG_HAVE_ARCH_RARE_WRITE
> +# define __wr_rare
> +# define __wr_rare_type
> +# define __rare_write(__var, __val)    (__var = (__val))
> +# define rare_write_begin()            do { } while (0)
> +# define rare_write_end()              do { } while (0)
> +#else
> +# define __wr_rare                     __ro_after_init
> +# define __wr_rare_type                        const
> +# ifdef CONFIG_HAVE_ARCH_RARE_WRITE_MEMCPY
> +#  define __rare_write_n(dst, src, len)        ({                      \
> +               BUILD_BUG(!builtin_const(len));                 \
> +               __arch_rare_write_memcpy((dst), (src), (len));  \
> +       })
> +#  define __rare_write(var, val)  __rare_write_n(&(var), &(val), sizeof(var))
> +# else
> +#  define __rare_write(var, val)  ((*(typeof((typeof(var))0) *)&(var)) = (val))
> +# endif
> +# define rare_write_begin()    __arch_rare_write_begin()
> +# define rare_write_end()      __arch_rare_write_end()
> +#endif
> +#define rare_write(__var, __val) ({                    \
> +       rare_write_begin();                             \
> +       __rare_write(__var, __val);                     \
> +       rare_write_end();                               \
> +       __var;                                          \
> +})
> +

Of course, only after sending this do I realize that the MEMCPY case
will need to be further adjusted, since it currently can't take
literals. I guess something like this needs to be done:

#define __rare_write(var, val) ({ \
    typeof(var) __src = (val);     \
    __rare_write_n(&(var), &(__src), sizeof(var)); \
})

-Kees

-- 
Kees Cook
Pixel Security
