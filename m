From: Masahiro Yamada <yamada.masahiro@socionext.com>
Subject: [PATCH 00/23] kconfig: move compiler capability tests to Kconfig
Date: Sat, 17 Feb 2018 03:38:28 +0900
Message-Id: <1518806331-7101-1-git-send-email-yamada.masahiro@socionext.com>
To: linux-kbuild@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Arnd Bergmann <arnd@arndb.de>, Kees Cook <keescook@chromium.org>, Randy Dunlap <rdunlap@infradead.org>, Ulf Magnusson <ulfalizer@gmail.com>, Sam Ravnborg <sam@ravnborg.org>, Michal Marek <michal.lkml@markovi.net>, Masahiro Yamada <yamada.masahiro@socionext.com>, Peter Oberparleiter <oberpar@linux.vnet.ibm.com>, kernel-hardening@lists.openwall.com, Jonathan Corbet <corbet@lwn.net>, sparclinux@vger.kernel.org, linux-sh@vger.kernel.org, x86@kernel.org, Thomas Gleixner <tglx@linutronix.de>, Rich Felker <dalias@libc.org>, Jeff Dike <jdike@addtoit.com>, "H. Peter Anvin" <hpa@zytor.com>, user-mode-linux-devel@lists.sourceforge.net, Yoshinori Sato <ysato@users.sourceforge.jp>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, linuxppc-dev@lists.ozlabs.org, Paul Mackerras <paulus@samba.org>, user-mode-linux-user@lists.sourceforge.net, Ingo Molnar <mingo@redhat.com>, "David S. Miller" <davem@davemloft.net>, Michael Ellerman <mpe@ellerman.id.au>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>, Emese Revfy <re.emese@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

I brushed up the implementation in this version.

In the previous RFC, CC_HAS_ was described by using 'option shell=',
like this:

config CC_HAS_STACKPROTECTOR
        bool
        option shell="$CC -Werror -fstack-protector -c -x c /dev/null"

After I thought a bit more, the following syntax is more grammatical,
and flexible.

config CC_HAS_STACKPROTECTOR
        bool
        default $(shell $CC -Werror -fstack-protector -c -x c /dev/null)

This version supports cc-option, so it can be written as:

config CC_HAS_STACKPROTECTOR
        bool
        default $(cc-option -fstack-protector)

To support this in a clean way, I introduced a new concept 'function'
like we see in Makefiles.

$(shell ...) is a built-in function.  $(cc-option ...) is implemented
as macro (user-defined function).

I also try cleaning of stack-protector, gcc-plugins since the Makefile
is so dirty.

Current limitations:

Dependency on outside scripts.
  For example, scripts/gcc-x86_64-has-stack-protecter.sh is run from
  Kconfig.  When the shell script is updated, should Kconfig be re-run
  automatically?

Inter-option dependency:
  $(call cc-option,...) in Makefile accumulates added options to
  KBUILD_CFLAGS, but it is difficult to do it in Kconfig.
  If a compiler option check is dependent on another option,
  this is a difficult case.  Let's see how significant it is.

Functions are evaluated statically:
  Functions are only expanded when parsing the Kconfig.  So, it can
  not refelect user configuration.  If this is required, $(shell )
  must be dynamically re-calculated depending on other symbols.
  But, this is difficult, and may cause performance issue.



Masahiro Yamada (22):
  kbuild: remove kbuild cache
  kbuild: remove CONFIG_CROSS_COMPILE support
  kconfig: add xstrdup() helper
  kconfig: set SYMBOL_AUTO to the symbol marked with defconfig_list
  kconfig: move and rename sym_expand_string_value()
  kconfig: reference environments directly and remove 'option env='
    syntax
  kconfig: add function support and implement 'shell' function
  kconfig: add 'macro' keyword to support user-defined function
  kconfig: add 'cc-option' macro
  stack-protector: test compiler capability in Kconfig and drop AUTO
    mode
  kconfig: add 'shell-stdout' function
  kconfig: replace $UNAME_RELEASE with function call
  kconfig: expand environments/functions in (main)menu, comment, prompt
  kconfig: show compiler version text in the top comment
  kconfig: add CC_IS_GCC and GCC_VERSION
  kconfig: add CC_IS_CLANG and CLANG_VERSION
  gcov: remove CONFIG_GCOV_FORMAT_AUTODETECT
  kcov: imply GCC_PLUGINS and GCC_PLUGIN_SANCOV instead of select'ing
    them
  gcc-plugins: always build plugins with C++
  gcc-plugins: move GCC version check for PowerPC to Kconfig
  gcc-plugins: test GCC plugin support in Kconfig
  gcc-plugins: enable GCC_PLUGINS for COMPILE_TEST

Sami Tolvanen (1):
  kbuild: add clang-version.sh

 Documentation/kbuild/kconfig-language.txt |   8 -
 Kconfig                                   |   4 +-
 Makefile                                  | 103 ++----------
 arch/Kconfig                              |  43 +++--
 arch/powerpc/Kconfig                      |   2 +-
 arch/sh/Kconfig                           |   4 +-
 arch/sparc/Kconfig                        |   4 +-
 arch/tile/Kconfig                         |   2 +-
 arch/um/Kconfig.common                    |   4 -
 arch/x86/Kconfig                          |  12 +-
 arch/x86/um/Kconfig                       |   4 +-
 init/Kconfig                              |  44 +++---
 kernel/gcov/Kconfig                       |  18 +--
 kernel/gcov/Makefile                      |   2 -
 lib/Kconfig.debug                         |   7 +-
 scripts/Kbuild.include                    | 101 ++----------
 scripts/Makefile.gcc-plugins              |  95 ++++-------
 scripts/clang-version.sh                  |  31 ++++
 scripts/gcc-plugin.sh                     |  37 +----
 scripts/gcc-plugins/Makefile              |  15 +-
 scripts/gcc-x86_32-has-stack-protector.sh |   7 +-
 scripts/gcc-x86_64-has-stack-protector.sh |   5 -
 scripts/kconfig/confdata.c                |  33 +---
 scripts/kconfig/function.c                | 251 ++++++++++++++++++++++++++++++
 scripts/kconfig/kconf_id.c                |   2 +-
 scripts/kconfig/kxgettext.c               |   2 +-
 scripts/kconfig/lkc.h                     |   6 +-
 scripts/kconfig/lkc_proto.h               |   7 +-
 scripts/kconfig/menu.c                    |   6 +-
 scripts/kconfig/symbol.c                  | 139 +++--------------
 scripts/kconfig/util.c                    | 186 ++++++++++++++++++++--
 scripts/kconfig/zconf.l                   |  40 ++++-
 scripts/kconfig/zconf.y                   |  48 +++---
 33 files changed, 687 insertions(+), 585 deletions(-)
 create mode 100755 scripts/clang-version.sh
 create mode 100644 scripts/kconfig/function.c

-- 
2.7.4
