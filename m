MIME-Version: 1.0
In-Reply-To: <20180601004233.37822-6-keescook@chromium.org>
References: <20180601004233.37822-1-keescook@chromium.org> <20180601004233.37822-6-keescook@chromium.org>
From: Andy Shevchenko <andy.shevchenko@gmail.com>
Date: Fri, 1 Jun 2018 13:18:29 +0300
Message-ID: <CAHp75Vdgz7edHYnqyC9d0ciSwDDyMEF7Jwr1bgnBe-UvUqoUtg@mail.gmail.com>
Subject: Re: [PATCH v3 05/16] lib: overflow: Add memory allocation overflow tests
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: Matthew Wilcox <mawilcox@microsoft.com>, Linus Torvalds <torvalds@linux-foundation.org>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Matthew Wilcox <willy@infradead.org>, LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 1, 2018 at 3:42 AM, Kees Cook <keescook@chromium.org> wrote:
> Make sure that the memory allocators are behaving as expected in the face
> of overflows.

>  #include <linux/module.h>
>  #include <linux/overflow.h>
>  #include <linux/types.h>
> +#include <linux/slab.h>
> +#include <linux/device.h>
> +#include <linux/mm.h>

A nit, can we keep it in order?

-- 
With Best Regards,
Andy Shevchenko
