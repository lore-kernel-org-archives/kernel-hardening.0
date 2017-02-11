MIME-Version: 1.0
In-Reply-To: <20170211013758.3288-2-me@jessfraz.com>
References: <20170211013758.3288-1-me@jessfraz.com> <20170211013758.3288-2-me@jessfraz.com>
From: John Stultz <john.stultz@linaro.org>
Date: Fri, 10 Feb 2017 18:12:31 -0800
Message-ID: <CALAqxLWMP7MFNRPTU3Ar3m=D1hFdS=d7_tbhkyrEadUQrRe7qw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2 2/5] time: mark syscore_ops as __ro_after_init
To: Jess Frazelle <me@jessfraz.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Rik van Riel <riel@redhat.com>, open list <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 10, 2017 at 5:37 PM, Jess Frazelle <me@jessfraz.com> wrote:
> Marked syscore_ops structs as __ro_after_init when register_syscore_ops was
> called only during init. Most of the caller functions were already annotated as
> __init.
> unregister_syscore_ops() was never called on these ops.
> This protects the data structure from accidental corruption.
>
> Suggested-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Jess Frazelle <me@jessfraz.com>
> Acked-by: Rik van Riel <riel@redhat.com>

Thanks for sending this out. Looks reasonable to me. I'll queue it for
testing, targeting for 4.12.

thanks
-john
