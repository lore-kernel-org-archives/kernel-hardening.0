Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160301181400.9c623ee9230381da90b89b2a@gmail.com>
References: <20160301181400.9c623ee9230381da90b89b2a@gmail.com>
Date: Tue, 1 Mar 2016 11:09:15 -0800
Message-ID: <CAGXu5jL=zXMTVvUqFDavuVYZcQg3cwjFQwZpgrdyjxkzCB-cxw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v4 0/3] Introduce GCC plugin infrastructure
To: Emese Revfy <re.emese@gmail.com>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Michal Marek <mmarek@suse.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Fengguang Wu <fengguang.wu@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Mar 1, 2016 at 9:14 AM, Emese Revfy <re.emese@gmail.com> wrote:
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
>
> Changes from v3:
>  * Fix some indentation related warnings
>    (Suggested by checkpatch.pl)
>  * Add maintainer entries
>  * Don't run gcc_plugin.sh when the GCC_PLUGINS option is disabled or unsupported
>    (Reported-by: Fengguang Wu <fengguang.wu@intel.com>)
>
>    I found a kbuild bug (or feature?) related to this patch. When a config option is disabled
>    then the symbol gets undefined only when you run make clean.
>    The easiest way to reproduce it is with e.g., CC_STACKPROTECTOR_STRONG:

Yeah, I fought this when adding _STRONG. It seems there are two
"phases" of Kbuild where it rebuilds the .config during phase 1 then
does the actual build in phase 2. I couldn't make the stack protector
detection kill the build because it would kill the config rewriter
too. So I had to leave it a warning and let the compiler die later
instead.

-Kees

>
>      * patch in warning here:
>
> diff --git a/Makefile b/Makefile
> index a1a7708..9e6961f 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -664,6 +664,7 @@ ifdef CONFIG_CC_STACKPROTECTOR_REGULAR
>  else
>  ifdef CONFIG_CC_STACKPROTECTOR_STRONG
>    stackp-flag := -fstack-protector-strong
> +  $(warning AAAAAAAA)
>    ifeq ($(call cc-option, $(stackp-flag)),)
>      $(warning Cannot use CONFIG_CC_STACKPROTECTOR_STRONG: \
>               -fstack-protector-strong not supported by compiler)
>
>      * enable CC_STACKPROTECTOR_STRONG in menuconfig
>      * run make and it prints out the "AAAAAAAA"
>      * enable CC_STACKPROTECTOR_NONE in menuconfig
>      * run make and it prints out the "AAAAAAAA"
>      * run make clean, run make again and it doesn't print out the "AAAAAAAA"
>
>
> Changes from v2:
>  * Fixed incorrectly encoded characters
>  * Generate the GIMPLE, IPA, SIMPLE_IPA and RTL pass structures
>    (Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>)
>  * Write plugin related warning messages to stderr instead of stdout
>    (Suggested-by: Kees Cook <keescook@chromium.org>)
>  * Mention the installation of the gcc plugin headers (Documentation)
>
>
> Changes from v1:
>  * Move the gcc-plugins make target into a separate Makefile because there may
>    be a lot of plugins (Suggested-by: Rasmus Villemoes)
>  * Simplify the dependencies of the plugin related config option
>    (Suggested-by: Kees Cook <keescook@chromium.org>)
>  * Removed the unnecessary example plugin
> ---
>  Documentation/dontdiff                   |   1 +
>  Documentation/gcc-plugins.txt            |  82 ++++
>  MAINTAINERS                              |   8 +
>  Makefile                                 |  41 +-
>  arch/Kconfig                             |  24 +
>  arch/x86/Kconfig                         |   1 +
>  init/Makefile                            |   3 +
>  scripts/Makefile.build                   |   2 +-
>  scripts/Makefile.clean                   |   3 +-
>  scripts/Makefile.gcc-plugins             |  32 ++
>  scripts/Makefile.host                    |  69 ++-
>  scripts/gcc-plugin.sh                    |  51 ++
>  scripts/link-vmlinux.sh                  |   2 +-
>  scripts/package/builddeb                 |   1 +
>  tools/gcc/Makefile                       |  19 +
>  tools/gcc/cyc_complexity_plugin.c        |  73 +++
>  tools/gcc/gcc-common.h                   | 803 +++++++++++++++++++++++++++++++
>  tools/gcc/gcc-generate-gimple-pass.h     | 173 +++++++
>  tools/gcc/gcc-generate-ipa-pass.h        | 287 +++++++++++
>  tools/gcc/gcc-generate-rtl-pass.h        | 173 +++++++
>  tools/gcc/gcc-generate-simple_ipa-pass.h | 173 +++++++
>  21 files changed, 2006 insertions(+), 15 deletions(-)



-- 
Kees Cook
Chrome OS & Brillo Security
