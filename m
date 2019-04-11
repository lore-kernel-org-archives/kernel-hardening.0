MIME-Version: 1.0
References: <20190410161612.18545-1-keescook@chromium.org> <20190410161612.18545-4-keescook@chromium.org>
 <CAK7LNAQpm5Tz_Fo0rSq00emB7BLnfYB-+mwXd9GiMKAqKCfkrA@mail.gmail.com>
In-Reply-To: <CAK7LNAQpm5Tz_Fo0rSq00emB7BLnfYB-+mwXd9GiMKAqKCfkrA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 11 Apr 2019 10:07:14 -0700
Message-ID: <CAGXu5jJYPO7buixedop=8e_e+Pf-4nmkz-iS3EV5CXC0obKpdA@mail.gmail.com>
Subject: Re: [PATCH 3/3] kbuild: Implement Clang's stack initialization
Content-Type: text/plain; charset="UTF-8"
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Alexander Potapenko <glider@google.com>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Alexander Popov <alpopov@ptsecurity.com>, Michal Marek <michal.lkml@markovi.net>, Emese Revfy <re.emese@gmail.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-security-module <linux-security-module@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Apr 11, 2019 at 1:06 AM Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
>
> On Thu, Apr 11, 2019 at 1:16 AM Kees Cook <keescook@chromium.org> wrote:
> >
> > CONFIG_INIT_STACK_ALL turns on stack initialization based on
> > -ftrivial-auto-var-init in Clang builds and on
> > -fplugin-arg-structleak_plugin-byref-all in GCC builds.
>
> Is CONFIG_INIT_STACK_ALL wired up to GCC plugin in any way?
> I could not understand it from the code.

No, it's only available under Clang. Clang is all-or-nothing, and the
GCC plugin has a degrees up to "all passed by reference" which isn't
truly "all" (i.e. Clang will initialize variables that aren't passed
by reference and trigger a compiler warning about being
uninitialized.)

> >  choice
> >         prompt "Initialize kernel stack variables at function entry"
> >         depends on CC_HAS_AUTO_VAR_INIT || GCC_PLUGINS
> > +       default INIT_STACK_ALL if CC_HAS_AUTO_VAR_INIT
>
> Why should this be enabled by default?
> Ins't it a performance regression
> since it inserts instructions in function prologue?

There are very few users of Clang right now (mainly Android), so I
figured it'd be nice to start Clang builds from a "protected by
default" here, especially given Linus's thoughts on making this always
happen[1]. I don't want to do it for GCC yet, since that would likely
come as a huge surprise to everyone else. :) But I'm happy to change
this, of course.

-Kees

[1] https://lkml.kernel.org/r/CA+55aFykZL+cSBJjBBts7ebEFfyGPdMzTmLSxKnT_29=j942dA@mail.gmail.com

--
Kees Cook
