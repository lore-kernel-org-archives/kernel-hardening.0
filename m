From: Kees Cook <keescook@chromium.org>
Subject: [PATCH 0/2] gcc-plugins: structleak: Generalize to all variable types
Date: Tue, 12 Feb 2019 10:04:39 -0800
Message-Id: <20190212180441.15340-1-keescook@chromium.org>
To: linux-kernel@vger.kernel.org
Cc: Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>, Alexander Popov <alex.popov@linux.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Laura Abbott <labbott@redhat.com>, Jann Horn <jannh@google.com>, Alexander Potapenko <glider@google.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Instead of a new plugin for stack initialization[1], this improves
structleak to handle initialization of all variable types. Since the
instrumentation happens at a different point, the "switch" statement
changes from the earlier posting[2] are no longer needed. As before,
this also introduces a stack initialization regression testing module to
validate various kinds of stack variable usage vs compiler instrumentation
for initialization. See the individual patches for more details.

Thanks!

-Kees

[1] https://lkml.kernel.org/r/CA+55aFykZL+cSBJjBBts7ebEFfyGPdMzTmLSxKnT_29=j942dA@mail.gmail.com
[2] https://lkml.kernel.org/r/20190123110349.35882-1-keescook@chromium.org

Kees Cook (2):
  gcc-plugins: structleak: Generalize to all variable types
  lib: Introduce test_stackinit module

 lib/Kconfig.debug                       |  10 +
 lib/Makefile                            |   1 +
 lib/test_stackinit.c                    | 378 ++++++++++++++++++++++++
 scripts/Makefile.gcc-plugins            |   2 +
 scripts/gcc-plugins/Kconfig             |  58 +++-
 scripts/gcc-plugins/structleak_plugin.c |  36 ++-
 6 files changed, 463 insertions(+), 22 deletions(-)
 create mode 100644 lib/test_stackinit.c

-- 
2.17.1
