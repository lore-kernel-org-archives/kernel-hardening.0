MIME-Version: 1.0
References: <20190212180441.15340-1-keescook@chromium.org>
In-Reply-To: <20190212180441.15340-1-keescook@chromium.org>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Fri, 15 Feb 2019 18:38:43 +0100
Message-ID: <CAKv+Gu9Cecc1hAurC1TEwqnf5E1gOaUxNgHt64QnziT1enp6YQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] gcc-plugins: structleak: Generalize to all variable types
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Emese Revfy <re.emese@gmail.com>, Alexander Popov <alex.popov@linux.com>, Laura Abbott <labbott@redhat.com>, Jann Horn <jannh@google.com>, Alexander Potapenko <glider@google.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 12 Feb 2019 at 19:04, Kees Cook <keescook@chromium.org> wrote:
>
> Instead of a new plugin for stack initialization[1], this improves
> structleak to handle initialization of all variable types. Since the
> instrumentation happens at a different point, the "switch" statement
> changes from the earlier posting[2] are no longer needed. As before,
> this also introduces a stack initialization regression testing module to
> validate various kinds of stack variable usage vs compiler instrumentation
> for initialization. See the individual patches for more details.
>

For the series,

Reviewed-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>

(although I reviewed 2/2 only cursorily)



> [1] https://lkml.kernel.org/r/CA+55aFykZL+cSBJjBBts7ebEFfyGPdMzTmLSxKnT_29=j942dA@mail.gmail.com
> [2] https://lkml.kernel.org/r/20190123110349.35882-1-keescook@chromium.org
>
> Kees Cook (2):
>   gcc-plugins: structleak: Generalize to all variable types
>   lib: Introduce test_stackinit module
>
>  lib/Kconfig.debug                       |  10 +
>  lib/Makefile                            |   1 +
>  lib/test_stackinit.c                    | 378 ++++++++++++++++++++++++
>  scripts/Makefile.gcc-plugins            |   2 +
>  scripts/gcc-plugins/Kconfig             |  58 +++-
>  scripts/gcc-plugins/structleak_plugin.c |  36 ++-
>  6 files changed, 463 insertions(+), 22 deletions(-)
>  create mode 100644 lib/test_stackinit.c
>
> --
> 2.17.1
>
