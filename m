MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1506816410-10230-5-git-send-email-me@tobin.cc>
References: <1506816410-10230-1-git-send-email-me@tobin.cc> <1506816410-10230-5-git-send-email-me@tobin.cc>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 4 Oct 2017 09:42:51 -0700
Message-ID: <CAGXu5jJQOduZ5evB=1w5NymUFbDNoeB4Y4u2a7zJ8k8vsAojRQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [RFC V2 4/6] lib: vsprintf: default
 kptr_restrict to the maximum value
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, William Roberts <william.c.roberts@intel.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Sep 30, 2017 at 5:06 PM, Tobin C. Harding <me@tobin.cc> wrote:
> Set the initial value of kptr_restrict to the maximum
> setting rather than the minimum setting, to ensure that
> early boot logging is not leaking information.
>
> Signed-off-by: Tobin C. Harding <me@tobin.cc>
> ---
>  lib/vsprintf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
> index 0271223..e009325 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -396,7 +396,7 @@ struct printf_spec {
>  #define FIELD_WIDTH_MAX ((1 << 23) - 1)
>  #define PRECISION_MAX ((1 << 15) - 1)
>
> -int kptr_restrict __read_mostly;
> +int kptr_restrict __read_mostly = 4; /* maximum setting */
>
>  /*
>   * return non-zero if we should cleanse pointers for %p and %pK specifiers.

I share Linus's concern that making this the unconditional default
will break some people. The intention here (as stated in the
changelog) is to cover anything leaked during early boot before sysctl
settings can change this value. That shouldn't break perf (which
should happen after sysctl settings), but it _may_ break debugging of
early boot. I would hope that nothing would be needed there, but if we
want to make this more configurable, we may want to consider a Kconfig
for the default. Perhaps:

-int kptr_restrict __read_mostly;
+int kptr_restrict __read_mostly = CONFIG_KPTR_RESTRICT_DEFAULT;

...

+config KPTR_RESTRICT_DEFAULT
+ bool "Avoid leaking kernel pointers to userspace"
+ default 0
+ range 0 4
+ help
+   This specifies the initial value of the kptr_restrict sysctl, which
+   controls the level of kernel pointers removed from display
+   to userspace. 0 = off, 1 = %pK not visible to non-root, 2 = %pK
+   not visible for any user, 3 = %p also not visible, 4 = physical and
+   resource addresses also not visible.


I'd argue that a default of "1" would be a sensible starting place,
but that can be a separate patch, IMO.

-Kees

-- 
Kees Cook
Pixel Security
