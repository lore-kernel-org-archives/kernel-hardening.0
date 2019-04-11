From: Kees Cook <keescook@chromium.org>
Subject: [PATCH v2 0/3] Refactor memory initialization hardening
Date: Thu, 11 Apr 2019 11:01:14 -0700
Message-Id: <20190411180117.27704-1-keescook@chromium.org>
To: Alexander Potapenko <glider@google.com>
Cc: Kees Cook <keescook@chromium.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, James Morris <jmorris@namei.org>, Alexander Popov <alex.popov@linux.com>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Michal Marek <michal.lkml@markovi.net>, Emese Revfy <re.emese@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

This is a proposed alternative for the memory initialization series,
which refactoring the existing gcc plugins into a separate Kconfig
file and collects all the related options together with some more
language to describe their differences. The last patch adds the
Clang auto init option, as done by Alexander Potapenko.

Since there isn't really a good way to "select" with dependencies,
I've left out CONFIG_INIT_ALL_MEMORY for the moment...

I intend to carry this in the gcc-plugins tree, but I'd really like
to get Acks from Masahiro (Kconfig changes, Makefile change), and
from James (adding the new Kconfig.hardening to security/Kconfig).

Thanks!

-Kees

v2:
- add plugin menu (masahiro)
- adjust patch subject prefixes (masahiro)
- drop redundent "depends" (masahiro)
- fixed early use of CC_HAS_AUTO_VAR_INIT (masahiro)
- dropped default-enabled for STACK_INIT_ALL (masahiro)

Kees Cook (3):
  security: Create "kernel hardening" config area
  security: Move stackleak config to Kconfig.hardening
  security: Implement Clang's stack initialization

 Makefile                    |   5 ++
 scripts/gcc-plugins/Kconfig | 125 ++-------------------------
 security/Kconfig            |   2 +
 security/Kconfig.hardening  | 163 ++++++++++++++++++++++++++++++++++++
 4 files changed, 177 insertions(+), 118 deletions(-)
 create mode 100644 security/Kconfig.hardening

-- 
2.17.1
