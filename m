MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1487410400-28313-1-git-send-email-mpe@ellerman.id.au>
References: <1487410400-28313-1-git-send-email-mpe@ellerman.id.au>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 21 Feb 2017 11:13:28 -0800
Message-ID: <CAGXu5jLTTcyGyY2KtuCX3tCThvGH0mCnFWyLaznyng=nTss6Dw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] usercopy: Don't test 64-bit get/put_user() on 32-bit powerpc
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Geert Uytterhoeven <geert@linux-m68k.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Feb 18, 2017 at 1:33 AM, Michael Ellerman <mpe@ellerman.id.au> wrote:
> Add PPC32 to the opt-out list, otherwise it breaks the build.
>
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> ---
>  lib/test_user_copy.c | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/lib/test_user_copy.c b/lib/test_user_copy.c
> index 4a79f2c1cd6e..6f335a3d4ae2 100644
> --- a/lib/test_user_copy.c
> +++ b/lib/test_user_copy.c
> @@ -37,6 +37,7 @@
>                             !defined(CONFIG_MICROBLAZE) &&      \
>                             !defined(CONFIG_MN10300) &&         \
>                             !defined(CONFIG_NIOS2) &&           \
> +                           !defined(CONFIG_PPC32) &&           \
>                             !defined(CONFIG_SUPERH))
>  # define TEST_U64
>  #endif

I'm fine to add this, but I'm curious why it fails? ppc uaccess.h has:

#define get_user(x, ptr) \
        __get_user_check((x), (ptr), sizeof(*(ptr)))

#define __get_user_check(x, ptr, size)                                  \
({                                                                      \
...
                __get_user_size(__gu_val, __gu_addr, (size), __gu_err); \

#define __get_user_size(x, ptr, size, retval)                   \
do {                                                            \
...
        case 8: __get_user_asm2(x, ptr, retval);  break;        \

#ifdef __powerpc64__
#define __get_user_asm2(x, addr, err)                   \
        __get_user_asm(x, addr, err, "ld")
#else /* __powerpc64__ */
#define __get_user_asm2(x, addr, err)                   \
        __asm__ __volatile__(                           \
...

It looks like __get_user_asm2() was explicitly designed for handling
64-bit get_user()?

-Kees

-- 
Kees Cook
Pixel Security
