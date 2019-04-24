MIME-Version: 1.0
References: <20190423194925.32151-1-keescook@chromium.org> <CAK7LNARuX8XfO=YRX9dYpipyBTCtMbQqLJfuk6iMLfLdZe1-KQ@mail.gmail.com>
In-Reply-To: <CAK7LNARuX8XfO=YRX9dYpipyBTCtMbQqLJfuk6iMLfLdZe1-KQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 24 Apr 2019 13:46:45 -0700
Message-ID: <CAGXu5jJfYBTt836K7-SNdwZcHf9RhXKxRj+xefn_hhogt2UEnA@mail.gmail.com>
Subject: Re: [PATCH v3 0/3] Refactor memory initialization hardening
Content-Type: text/plain; charset="UTF-8"
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Alexander Potapenko <glider@google.com>, James Morris <jmorris@namei.org>, Alexander Popov <alex.popov@linux.com>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Michal Marek <michal.lkml@markovi.net>, Emese Revfy <re.emese@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-security-module <linux-security-module@vger.kernel.org>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Apr 23, 2019 at 9:07 PM Masahiro Yamada
<yamada.masahiro@socionext.com> wrote:
>
> On Wed, Apr 24, 2019 at 4:49 AM Kees Cook <keescook@chromium.org> wrote:
> >
> > This refactors the stack memory initialization configs in order to
> > keep things together when adding Clang stack initialization, and in
> > preparation for future heap memory initialization configs.
> >
> > I intend to carry this in the gcc-plugins tree, but I'd really like
> > to get Acks from Masahiro (Kconfig changes, Makefile change), and
> > from James (adding the new Kconfig.hardening to security/Kconfig).
>
> If needed,
> Acked-by: Masahiro Yamada <yamada.masahiro@socionext.com>

Great; thanks! :)

-- 
Kees Cook
