MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170724133824.27223-4-LiljestrandH@gmail.com>
References: <20170724133824.27223-1-LiljestrandH@gmail.com> <20170724133824.27223-4-LiljestrandH@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 24 Jul 2017 19:45:21 -0700
Message-ID: <CAGXu5jKLFoF584WMYG2CEaON-RSV6TjEzVJtvbuT1ahs0ER6cw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [RFC PATCH 3/5] x86: add mpxk-wrappers
To: Hans Liljestrand <liljestrandh@gmail.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Reshetova, Elena" <elena.reshetova@intel.com>, Dave Hansen <dave.hansen@intel.com>, "H. Peter Anvin" <hpa@zytor.com>, Daniel Micay <danielmicay@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jul 24, 2017 at 6:38 AM, Hans Liljestrand
<liljestrandh@gmail.com> wrote:
> This adds actual implementation for mpxk-wrapper functions. The wrapper
> function are used by the instrumentation to update and check pointer bounds
> on functions that alter memory, e.g. kmalloc and memcpy. The kmalloc
> wrapper function for instance simply executes kmalloc, associates bounds
> with the returned pointer, and returns both. Other wrapper functions, such
> as for memcpy, also check the bounds of incoming arguments.
>
> For future work these wrappers could potentially be replaced by direct
> instrumentation without the need to incur the cost of calling the wrapper
> function. In this scenario every kmalloc would simply be preceded by an
> appropriate mkbnd instruction, and memcpy preceded by bndcu+bndcl
> instructions.
>
> The wrappers are added by the MPXK gcc-plugin, and as such work on
> preprocessed code. This introduces another problem with our
> implementation since macros might actually be used to direct "base
> functions" into specific implementations (e.g. memcpy might be a macro
> pointing to __memcpy). One solution is covering all possibilities, but
> this might introduce unwanted code bloat.

I'd be curious to see how (if?) this interacts with CONFIG_FORTIFY. It
seems that currently the MPXK checks would be similar to the
inter-object checks as they exist (e.g. checking the size of the whole
kmalloc allocation), but it wouldn't work on intra-object copies (i.e.
bounds checking a field within an object).

More directly, I'd be curious to see coverage and performance
comparisons between FORTIFY and MPXK.

-Kees

-- 
Kees Cook
Pixel Security
