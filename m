MIME-Version: 1.0
Sender: geert.uytterhoeven@gmail.com
In-Reply-To: <20170214204039.GA125586@beast>
References: <20170214204039.GA125586@beast>
From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Wed, 15 Feb 2017 09:50:14 +0100
Message-ID: <CAMuHMdWEH0OiBOJJrJLr27sZHo20sa2Qz5Acq9SZWBGav2FXdw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] usercopy: Add tests for all get_user() sizes
To: Kees Cook <keescook@chromium.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Hoeun Ryu <hoeun.ryu@gmail.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 14, 2017 at 9:40 PM, Kees Cook <keescook@chromium.org> wrote:
> The existing test was only exercising native unsigned long size
> get_user(). For completeness, we should check all sizes.
>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  lib/test_user_copy.c | 45 ++++++++++++++++++++++++++++++++++-----------
>  1 file changed, 34 insertions(+), 11 deletions(-)
>
> diff --git a/lib/test_user_copy.c b/lib/test_user_copy.c
> index ac3a60ba9331..49569125b7c5 100644
> --- a/lib/test_user_copy.c
> +++ b/lib/test_user_copy.c
> @@ -40,8 +40,11 @@ static int __init test_user_copy_init(void)
>         char __user *usermem;
>         char *bad_usermem;
>         unsigned long user_addr;
> -       unsigned long value = 0x5A;
>         char *zerokmem;
> +       u8 val_u8;
> +       u16 val_u16;
> +       u32 val_u32;
> +       u64 val_u64;
>
>         kmem = kmalloc(PAGE_SIZE * 2, GFP_KERNEL);
>         if (!kmem)
> @@ -72,10 +75,20 @@ static int __init test_user_copy_init(void)
>                     "legitimate copy_from_user failed");
>         ret |= test(copy_to_user(usermem, kmem, PAGE_SIZE),
>                     "legitimate copy_to_user failed");
> -       ret |= test(get_user(value, (unsigned long __user *)usermem),
> -                   "legitimate get_user failed");
> -       ret |= test(put_user(value, (unsigned long __user *)usermem),
> -                   "legitimate put_user failed");
> +
> +#define test_legit(size)                                                 \
> +       do {                                                              \
> +               ret |= test(get_user(val_##size, (size __user *)usermem), \
> +                   "legitimate get_user (" #size ") failed");            \
> +               ret |= test(put_user(val_##size, (size __user *)usermem), \
> +                   "legitimate put_user (" #size ") failed");            \
> +       } while (0)
> +
> +       test_legit(u8);
> +       test_legit(u16);
> +       test_legit(u32);
> +       test_legit(u64);
> +#undef test_legit

ERROR: "__get_user_bad" [lib/test_user_copy.ko] undefined!

http://kisskb.ellerman.id.au/kisskb/buildresult/12936728/

So 64-bit get_user() support is mandatory now?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
