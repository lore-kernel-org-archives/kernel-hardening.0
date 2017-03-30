MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <466B31B4-0535-44EE-B0F0-F758A79A7B4F@gmail.com>
References: <1490811363-93944-1-git-send-email-keescook@chromium.org>
 <1490811363-93944-2-git-send-email-keescook@chromium.org> <CAGXu5jJuuUSwS61d7Joc=6y2BUyTo6koEsrVxeqMu_u7j9Mb9w@mail.gmail.com>
 <466B31B4-0535-44EE-B0F0-F758A79A7B4F@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 30 Mar 2017 10:02:55 -0700
Message-ID: <CAGXu5j+ym33s=nUqmpViR0UJrHo6Bu7+LxsMtvKgvpOzhYxXkw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC v2][PATCH 01/11] Introduce rare_write() infrastructure
To: Ho-Eun Ryu <hoeun.ryu@gmail.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Mark Rutland <mark.rutland@arm.com>, Andy Lutomirski <luto@kernel.org>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, Russell King <linux@armlinux.org.uk>, "x86@kernel.org" <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 30, 2017 at 12:44 AM, Ho-Eun Ryu <hoeun.ryu@gmail.com> wrote:
>
>> On 30 Mar 2017, at 3:23 AM, Kees Cook <keescook@chromium.org> wrote:
>>
>> On Wed, Mar 29, 2017 at 11:15 AM, Kees Cook <keescook@chromium.org> wrote:
>>> +/*
>>> + * Build "write rarely" infrastructure for flipping memory r/w
>>> + * on a per-CPU basis.
>>> + */
>>> +#ifndef CONFIG_HAVE_ARCH_RARE_WRITE
>>> +# define __wr_rare
>>> +# define __wr_rare_type
>>> +# define __rare_write(__var, __val)    (__var = (__val))
>>> +# define rare_write_begin()            do { } while (0)
>>> +# define rare_write_end()              do { } while (0)
>>> +#else
>>> +# define __wr_rare                     __ro_after_init
>>> +# define __wr_rare_type                        const
>>> +# ifdef CONFIG_HAVE_ARCH_RARE_WRITE_MEMCPY
>>> +#  define __rare_write_n(dst, src, len)        ({                      \
>>> +               BUILD_BUG(!builtin_const(len));                 \
>>> +               __arch_rare_write_memcpy((dst), (src), (len));  \
>>> +       })
>>> +#  define __rare_write(var, val)  __rare_write_n(&(var), &(val), sizeof(var))
>>> +# else
>>> +#  define __rare_write(var, val)  ((*(typeof((typeof(var))0) *)&(var)) = (val))
>>> +# endif
>>> +# define rare_write_begin()    __arch_rare_write_begin()
>>> +# define rare_write_end()      __arch_rare_write_end()
>>> +#endif
>>> +#define rare_write(__var, __val) ({                    \
>>> +       rare_write_begin();                             \
>>> +       __rare_write(__var, __val);                     \
>>> +       rare_write_end();                               \
>>> +       __var;                                          \
>>> +})
>>> +
>>
>> Of course, only after sending this do I realize that the MEMCPY case
>> will need to be further adjusted, since it currently can't take
>> literals. I guess something like this needs to be done:
>>
>> #define __rare_write(var, val) ({ \
>>    typeof(var) __src = (val);     \
>>    __rare_write_n(&(var), &(__src), sizeof(var)); \
>> })
>>
>
> Right, and it has a problem with BUILD_BUG, which causes compilation error when CONFIG_HABE_ARCH_RARE_WRITE_MEMCPY is true
> BUILD_BUG is defined in <linux/bug.h> but <linux/bug.h> includes <linux/compiler.h>
>
> Please see the following.
>
> diff --git a/include/linux/compiler.h b/include/linux/compiler.h
> index 3334fa9..3fa50e1 100644
> --- a/include/linux/compiler.h
> +++ b/include/linux/compiler.h
> @@ -350,11 +350,11 @@ static __always_inline void __write_once_size(volatile vo\
> id *p, void *res, int s
>  # define __wr_rare                     __ro_after_init
>  # define __wr_rare_type                        const
>  # ifdef CONFIG_HAVE_ARCH_RARE_WRITE_MEMCPY
> -#  define __rare_write_n(dst, src, len)        ({                      \
> -               BUILD_BUG(!builtin_const(len));                         \
> -               __arch_rare_write_memcpy((dst), (src), (len));   \
> +#  define __rare_write_n(var, val, len)        ({                                 \
> +               typeof(val) __val = val;                                                    \
> +               __arch_rare_write_memcpy(&(var), &(__val), (len));      \
>         })
> -#  define __rare_write(var, val)  __rare_write_n(&(var), &(val), sizeof(var))
> +#  define __rare_write(var, val)  __rare_write_n((var), (val), sizeof(var))
>  # else
>  #  define __rare_write(var, val)  ((*(typeof((typeof(var))0) *)&(var)) = (val)\
> )
>  # endif

Thanks for the catch, I'll update this (I'll use compiletime_assert,
which is defined in compiler.h).

-Kees

-- 
Kees Cook
Pixel Security
