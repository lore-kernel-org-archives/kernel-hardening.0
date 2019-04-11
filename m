MIME-Version: 1.0
References: <20190410161612.18545-1-keescook@chromium.org>
In-Reply-To: <20190410161612.18545-1-keescook@chromium.org>
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Date: Thu, 11 Apr 2019 16:59:13 +0900
Message-ID: <CAK7LNATj3_=4pW6R7ie_EXh_X3U+JNK_6Y6NLT8XjftmezAbFA@mail.gmail.com>
Subject: Re: [PATCH 0/3] Kconfig: Refactor memory initialization hardening
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: Alexander Potapenko <glider@google.com>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Alexander Popov <alpopov@ptsecurity.com>, Michal Marek <michal.lkml@markovi.net>, Emese Revfy <re.emese@gmail.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-security-module@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Apr 11, 2019 at 1:16 AM Kees Cook <keescook@chromium.org> wrote:
>
> This is a proposed alternative for the memory initialization series,
> which refactoring the existing gcc plugins into a separate Kconfig
> file and collects all the related options together with some more
> language to describe their differences. The last patch adds the
> Clang auto init option, as done by Alexander Potapenko.
>
> Since there isn't really a good way to "select" with dependencies,
> I've left out CONFIG_INIT_ALL_MEMORY for the moment...
>
> -Kees
>
> Kees Cook (3):
>   Kconfig: Create "kernel hardening" config area

I want to see "kconfig:" prefix in the subject line
only for changed in scripts/kconfig/.


>   kbuild: Move stackleak config to Kconfig.hardening

This is not a change in the build system.

>   kbuild: Implement Clang's stack initialization


I think "gcc-plugin:", "security:' or something is better for the
patch subjects, and this patch series is out of
my maintenance area.





>  Makefile                    |   5 ++
>  scripts/gcc-plugins/Kconfig | 121 +-------------------------
>  security/Kconfig            |   2 +
>  security/Kconfig.hardening  | 165 ++++++++++++++++++++++++++++++++++++
>  4 files changed, 175 insertions(+), 118 deletions(-)
>  create mode 100644 security/Kconfig.hardening
>
> --
> 2.17.1
>


--
Best Regards
Masahiro Yamada
