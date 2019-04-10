From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 0/3] Kconfig: Refactor memory initialization hardening
Date: Wed, 10 Apr 2019 09:16:09 -0700
Message-Id: <20190410161612.18545-1-keescook@chromium.org>
To: Masahiro Yamada <yamada.masahiro@socionext.com>
Cc: Kees Cook <keescook@chromium.org>, Alexander Potapenko <glider@google.com>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Alexander Popov <alpopov@ptsecurity.com>, Michal Marek <michal.lkml@markovi.net>, Emese Revfy <re.emese@gmail.com>, James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

This is a proposed alternative for the memory initialization series,
which refactoring the existing gcc plugins into a separate Kconfig
file and collects all the related options together with some more
language to describe their differences. The last patch adds the
Clang auto init option, as done by Alexander Potapenko.

Since there isn't really a good way to "select" with dependencies,
I've left out CONFIG_INIT_ALL_MEMORY for the moment...

-Kees

Kees Cook (3):
  Kconfig: Create "kernel hardening" config area
  kbuild: Move stackleak config to Kconfig.hardening
  kbuild: Implement Clang's stack initialization

 Makefile                    |   5 ++
 scripts/gcc-plugins/Kconfig | 121 +-------------------------
 security/Kconfig            |   2 +
 security/Kconfig.hardening  | 165 ++++++++++++++++++++++++++++++++++++
 4 files changed, 175 insertions(+), 118 deletions(-)
 create mode 100644 security/Kconfig.hardening

-- 
2.17.1
