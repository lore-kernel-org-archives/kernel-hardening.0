Reply-To: kernel-hardening@lists.openwall.com
From: Quentin Casasnovas <quentin.casasnovas@oracle.com>
Date: Fri, 6 Nov 2015 16:00:49 +0000 (UTC)
Message-ID: <n1iirh$q7o$1@ger.gmane.org>
References: <CAGXu5jJ3FgxXK9WuOLRwnEq=y4dS+CTm+WQBxWe3sYZ7e9p6Gg@mail.gmail.com>
Subject: [kernel-hardening] Re: Kernel Self Protection Project
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 2015-11-05, Kees Cook <keescook@chromium.org> wrote:
> I'm organizing a community of people to work on the various kernel
> self-protection technologies (most of which are found in PaX and
> Grsecurity). I'm building on the presentation I gave at Kernel Summit
> where I sought to convince the other upstream Linux kernel developers
> that security is more than fixing bugs, and that we need to bring in
> proactive defenses:
> http://lwn.net/Articles/662219/
>

Great initiative!

>
> For now, I'm going to focus on taking a look at the PAX_SIZE_OVERFLOW
> gcc plugin, which will also get us the gcc plugin infrastructure.
> Other people, please speak up on what you'd like to tackle.
>

Not that it's complex but I already have a branch with the gcc plugin
infrastructure split up if you're interested and you reckon that can save
you some time.

Quentin
