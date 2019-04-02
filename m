MIME-Version: 1.0
References: <20190306214226.14598-1-tobin@kernel.org> <20190306214226.14598-2-tobin@kernel.org>
In-Reply-To: <20190306214226.14598-2-tobin@kernel.org>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 2 Apr 2019 14:24:59 -0700
Message-ID: <CAGXu5jKs5PZquDwj3B_7P6UH7aahawDkTdf2RWooiuj1uJy4WQ@mail.gmail.com>
Subject: Re: [PATCH v3 1/7] lib/test_printf: Add empty module_exit function
Content-Type: text/plain; charset="UTF-8"
To: "Tobin C. Harding" <tobin@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>, Jann Horn <jannh@google.com>, Andy Shevchenko <andriy.shevchenko@linux.intel.com>, Randy Dunlap <rdunlap@infradead.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Stephen Rothwell <sfr@canb.auug.org.au>, Andy Lutomirski <luto@amacapital.net>, Daniel Micay <danielmicay@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>, "Gustavo A. R. Silva" <gustavo@embeddedor.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, "open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 6, 2019 at 1:43 PM Tobin C. Harding <tobin@kernel.org> wrote:
>
> Currently the test_printf module does not have an exit function, this
> prevents the module from being unloaded.  If we cannot unload the
> module we cannot run the tests a second time.
>
> Add an empty exit function.
>
> Signed-off-by: Tobin C. Harding <tobin@kernel.org>

Acked-by: Kees Cook <keescook@chromium.org>

-Kees

> ---
>  lib/test_printf.c | 6 ++++++
>  1 file changed, 6 insertions(+)
>
> diff --git a/lib/test_printf.c b/lib/test_printf.c
> index 659b6cc0d483..601e8519319a 100644
> --- a/lib/test_printf.c
> +++ b/lib/test_printf.c
> @@ -615,5 +615,11 @@ test_printf_init(void)
>
>  module_init(test_printf_init);
>
> +static void __exit test_printf_exit(void)
> +{
> +}
> +
> +module_exit(test_printf_exit);
> +
>  MODULE_AUTHOR("Rasmus Villemoes <linux@rasmusvillemoes.dk>");
>  MODULE_LICENSE("GPL");
> --
> 2.20.1
>


-- 
Kees Cook
