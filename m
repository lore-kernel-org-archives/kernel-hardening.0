Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160222201335.449323716ca4d929f92424d5@gmail.com>
References: <20160222201335.449323716ca4d929f92424d5@gmail.com>
Date: Mon, 22 Feb 2016 16:20:40 -0800
Message-ID: <CAGXu5jL0-Kq=paYLsq5KC+cKL1-1U=b_CBLuKQr_KtwG2fqdLg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3 0/3] Introduce GCC plugin infrastructure
To: Emese Revfy <re.emese@gmail.com>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Michal Marek <mmarek@suse.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Feb 22, 2016 at 11:13 AM, Emese Revfy <re.emese@gmail.com> wrote:
> This patch set introduce the GCC plugin infrastructure with examples for testing
> and documentation.
>
> GCC plugins are loadable modules that provide extra features to the compiler.
> They are useful for runtime instrumentation and static analysis.
>
> The infrastructure supports all gcc versions from 4.5 to 6.0, building
> out-of-tree modules and building in a separate directory. Cross-compilation
> is supported too but currently only the x86 architecture enables plugins.
>
> This infrastructure was ported from grsecurity/PaX. It is a CII project
> supported by the Linux Foundation.
>
> Emese Revfy (3):
>  GCC plugin infrastructure
>  Add Cyclomatic complexity plugin
>  Documentations of the GCC plugin infrastructre
>
> Changes from v2:
>  * Fixed incorrectly encoded characters
>  * Generate the GIMPLE, IPA, SIMPLE_IPA and RTL pass structures
>    (Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>)
>  * Write plugin related warning messages to stderr instead of stdout
>    (Suggested-by: Kees Cook <keescook@chromium.org>)
>  * Mention the installation of the gcc plugin headers (Documentation)
>
> Changes from v1:
>  * Move the gcc-plugins make target into a separate Makefile because there may
>    be a lot of plugins (Suggested-by: Rasmus Villemoes)
>  * Simplify the dependencies of the plugin related config option
>    (Suggested-by: Kees Cook <keescook@chromium.org>)
>  * Removed the unnecessary example plugin

Oh, I totally missed a detail from v2 that still applies to v3:

You're missing your Signed-off-by lines in the patches.

Running each patch through scripts/checkpatch.pl produces a number of
other warnings (I ignored all the C++isms), mostly around lines >80
characters, function definitions (missing void), and the suggestion to
create yourself a MAINTAINTERS line for this directory.

-Kees

> ---
>  Documentation/dontdiff                   |   1 +
>  Documentation/gcc-plugins.txt            |  80 ++++
>  Makefile                                 |  41 +-
>  arch/Kconfig                             |  24 +
>  arch/x86/Kconfig                         |   1 +
>  init/Makefile                            |   3 +
>  scripts/Makefile.build                   |   2 +-
>  scripts/Makefile.clean                   |   3 +-
>  scripts/Makefile.gcc-plugins             |  30 ++
>  scripts/Makefile.host                    |  69 ++-
>  scripts/gcc-plugin.sh                    |  51 ++
>  scripts/link-vmlinux.sh                  |   2 +-
>  scripts/package/builddeb                 |   1 +
>  tools/gcc/Makefile                       |  19 +
>  tools/gcc/cyc_complexity_plugin.c        |  70 +++
>  tools/gcc/gcc-common.h                   | 794 +++++++++++++++++++++++++++++++
>  tools/gcc/gcc-generate-gimple-pass.h     | 172 +++++++
>  tools/gcc/gcc-generate-ipa-pass.h        | 286 +++++++++++
>  tools/gcc/gcc-generate-rtl-pass.h        | 172 +++++++
>  tools/gcc/gcc-generate-simple_ipa-pass.h | 172 +++++++
>  20 files changed, 1978 insertions(+), 15 deletions(-)



-- 
Kees Cook
Chrome OS & Brillo Security
