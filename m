MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20171108223020.24487-5-linux@rasmusvillemoes.dk>
References: <20171108223020.24487-1-linux@rasmusvillemoes.dk> <20171108223020.24487-5-linux@rasmusvillemoes.dk>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 8 Nov 2017 17:08:22 -0800
Message-ID: <CAGXu5jJF6LjH8tuMNGNtb=mqwRio-xmNt9xL0-+18dQzQQZdXA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [RFC 4/6] lib/vsprintf.c: add fmtcheck utility
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Nov 8, 2017 at 2:30 PM, Rasmus Villemoes
<linux@rasmusvillemoes.dk> wrote:
> We have a few places in the kernel where a *printf function is used with
> a non-constant format string, making the ordinary static type checking
> done by gcc et al. impossible. Some things can still be caught at build
> time with appropriate instrumentation (I'm sure one can do much better
> than the format_template plugin), but that still leaves a number of
> places unchecked. So this patch adds a function for doing run-time
> verification of a given format string against a template.
>
> The fmtcheck() function takes two format string arguments and checks
> whether they contain the same printf specifiers. If they do, the
> first (the string-to-be-checked) string is returned. If not, the
> second (the template) is returned. Regardless of which string is
> returned at run-time, the __format_arg attribute allows the compiler to
> do type-checking if the fmtcheck() function is used inside a *printf
> call, e.g.
>
>   sprintf(buf, fmtcheck(what->ever, "%d %lx", 0), i, m)

Cool, I like this. I wonder if there are any "hot paths" that would
actually make this runtime checking expensive? Seems like anything
that hot shouldn't be using sprintf anyway...

>
> We actually make fmtcheck() a macro that tries very hard to ensure the
> template argument is a string literal - partly to help avoid mixing up
> the two "const char*" arguments, partly because much of the point of
> this sanity checking vanishes if the template is not a literal (e.g.,
> the __format_arg annotation becomes useless).

I wonder how much work it would be to instrument vsnprintf() to warn
about all non-const format strings that are being processed so we
could find all the places where fmtcheck() (and the struct annotation)
are needed.

> We don't treat "%*.*s" and "%d %d %s" as equivalent, despite them
> taking the same vararg types, since they're morally very distinct. In
> fact, at least for now, we don't even treat "%d" and "%u" as
> equivalent. We can relax that, possibly via FMTCHECK_* flags, but let's
> first see which users there might be and what they'd want.
>
> If either string contains a %p, we really should check the following
> alphanumerics to see which (if any) extension is used and check that
> they match as well. For now, just complain loudly, partly because I'm
> lazy, partly because I don't know any in-tree code that might use
> fmtcheck() with a %p in the template, and I can't really imagine
> anyone would use a %pXX extension in a non-constant format string.

Yeah, seems reasonable for the first pass at this.

> I don't know if WARN is too violent; maybe just pr_warn would be ok.

I think WARN gets noticed much more by build and runtime testing
tools, so I think that's the right thing to do here. A mismatch really
should be noticed.

-Kees

-- 
Kees Cook
Pixel Security
