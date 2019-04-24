MIME-Version: 1.0
References: <20190411180117.27704-1-keescook@chromium.org> <20190411180117.27704-2-keescook@chromium.org>
 <CAK7LNATvNJprA94Qypfub2rpbEEJkAeV3yqVyuk2aNEraDKZ6w@mail.gmail.com> <CAGXu5jLNwFfG-x-_Q6nTdU21t5B9z7dCgBekRiJ+MnUE14J12A@mail.gmail.com>
In-Reply-To: <CAGXu5jLNwFfG-x-_Q6nTdU21t5B9z7dCgBekRiJ+MnUE14J12A@mail.gmail.com>
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Date: Wed, 24 Apr 2019 13:05:44 +0900
Message-ID: <CAK7LNASwf6Q_q-wtqxCuz7-HOYiBdQ-5QbhOCkhX8Ujh01oLNA@mail.gmail.com>
Subject: Re: [PATCH v2 1/3] security: Create "kernel hardening" config area
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: Alexander Potapenko <glider@google.com>, James Morris <jmorris@namei.org>, Alexander Popov <alex.popov@linux.com>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Michal Marek <michal.lkml@markovi.net>, Emese Revfy <re.emese@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-security-module <linux-security-module@vger.kernel.org>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 24, 2019 at 4:36 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Thu, Apr 11, 2019 at 6:39 PM Masahiro Yamada
> <yamada.masahiro@socionext.com> wrote:
> >
> > On Fri, Apr 12, 2019 at 3:01 AM Kees Cook <keescook@chromium.org> wrote:
> > >
> > > Right now kernel hardening options are scattered around various Kconfig
> > > files. This can be a central place to collect these kinds of options
> > > going forward. This is initially populated with the memory initialization
> > > options from the gcc-plugins.
> > >
> > > Signed-off-by: Kees Cook <keescook@chromium.org>
> > > ---
> > >  scripts/gcc-plugins/Kconfig | 74 +++--------------------------
> > >  security/Kconfig            |  2 +
> > >  security/Kconfig.hardening  | 93 +++++++++++++++++++++++++++++++++++++
> > >  3 files changed, 102 insertions(+), 67 deletions(-)
> > >  create mode 100644 security/Kconfig.hardening
> > >
> > > diff --git a/scripts/gcc-plugins/Kconfig b/scripts/gcc-plugins/Kconfig
> > > index 74271dba4f94..84d471dea2b7 100644
> > > --- a/scripts/gcc-plugins/Kconfig
> > > +++ b/scripts/gcc-plugins/Kconfig
> > > @@ -13,10 +13,11 @@ config HAVE_GCC_PLUGINS
> > >           An arch should select this symbol if it supports building with
> > >           GCC plugins.
> > >
> > > -menuconfig GCC_PLUGINS
> > > -       bool "GCC plugins"
> > > +config GCC_PLUGINS
> > > +       bool
> > >         depends on HAVE_GCC_PLUGINS
> > >         depends on PLUGIN_HOSTCC != ""
> > > +       default y
> > >         help
> > >           GCC plugins are loadable modules that provide extra features to the
> > >           compiler. They are useful for runtime instrumentation and static analysis.
> > > @@ -25,6 +26,8 @@ menuconfig GCC_PLUGINS
> > >
> > >  if GCC_PLUGINS
> > >
> > > +menu "GCC plugins"
> > > +
> >
> >
> >
> > Just a tip to save "if" ... "endif" block.
> >
> >
> > If you like, you can write like follows:
> >
> >
> > menu "GCC plugins"
> >           depends on GCC_PLUGINS
> >
> >   <menu body>
> >
> > endmenu
>
> Ah yes, thanks! Adjusted.
>
> > > +menu "Memory initialization"
> > > +
> > > +choice
> > > +       prompt "Initialize kernel stack variables at function entry"
> > > +       depends on GCC_PLUGINS
> >
> > On second thought,
> > this 'depends on' is unnecessary
> > because INIT_STACK_NONE should be always visible.
>
> Oh yes, excellent point. Adjusted.
>
> > Another behavior change is
> > GCC_PLUGIN_STRUCTLEAK was previously enabled by all{yes,mod}config,
> > and in the compile-test coverage.
>
> I could set the defaults based on CONFIG_COMPILE_TEST, though? I.e.:
>
>         prompt "Initialize kernel stack variables at function entry"
>         default GCC_PLUGIN_STRUCTLEAK_BYREF_ALL if COMPILE_TEST && GCC_PLUGINS
>         default INIT_STACK_ALL if COMPILE_TEST && CC_HAS_AUTO_VAR_INIT
>         default INIT_STACK_NONE

Looks a good idea to me.

Thanks.



-- 
Best Regards
Masahiro Yamada
