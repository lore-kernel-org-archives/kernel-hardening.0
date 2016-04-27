Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAGXu5j+sZrifFG8=wYC46b=7JRnqg0SXV0-6B5d=xXbCFhYxkQ@mail.gmail.com>
References: <20160422201957.97ce16f0e67377d0ce613d19@gmail.com>
	<CAGXu5j+sZrifFG8=wYC46b=7JRnqg0SXV0-6B5d=xXbCFhYxkQ@mail.gmail.com>
Date: Wed, 27 Apr 2016 10:40:30 +0900
Message-ID: <CAK7LNASyO2qCEaG6SMm7XiFQMSZZ8rCjOpJo0cA6-VJky47Y3A@mail.gmail.com>
From: Masahiro Yamada <yamada.masahiro@socionext.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v7 0/6] Introduce GCC plugin infrastructure
To: Kees Cook <keescook@chromium.org>
Cc: Emese Revfy <re.emese@gmail.com>, Michal Marek <mmarek@suse.com>, linux-kbuild <linux-kbuild@vger.kernel.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Fengguang Wu <fengguang.wu@intel.com>, Dmitry Vyukov <dvyukov@google.com>, LKML <linux-kernel@vger.kernel.org>, David Brown <david.brown@linaro.org>
List-ID: <kernel-hardening.lists.openwall.com>

2016-04-27 5:40 GMT+09:00 Kees Cook <keescook@chromium.org>:
> On Fri, Apr 22, 2016 at 11:19 AM, Emese Revfy <re.emese@gmail.com> wrote:
>> This patch set introduce the GCC plugin infrastructure with examples for testing
>> and documentation.
>>
>> GCC plugins are loadable modules that provide extra features to the compiler.
>> They are useful for runtime instrumentation and static analysis.
>>
>> The infrastructure supports all gcc versions from 4.5 to 6.0, building
>> out-of-tree modules and building in a separate directory. Cross-compilation
>> is supported too but currently only the x86, arm and arm64 architectures enables plugins.
>>
>> This infrastructure was ported from grsecurity/PaX. It is a CII project
>> supported by the Linux Foundation.
>>
>> Emese Revfy (6):
>>  Shared library support
>>  GCC plugin infrastructure
>>  The GCC plugin infrastructure supports the arm and arm64 architectures too
>>  Add Cyclomatic complexity plugin
>>  Documentations of the GCC plugin infrastructre
>>  Add sancov plugin
>>
>>
>> Changes from v6:
>>  * Disable the sancov plugin whenever KCOV_INSTRUMENT is disabled
>>     (Reported-by: Huang Ying <ying.huang@linux.intel.com>)
>>  * Disable KCOV/sancov plugin because this is not a regular kernel code
>>     (Reported-by: Huang Ying <ying.huang@linux.intel.com>)
>>  * Removed unnecessary gcc plugin cflags
>>     (Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>)
>>  * Removed unnecessary gcc plugin aflags
>>
>> Changes from v5:
>>  * Set important properties on the external fndecl (Add sancov plugin)
>>  * Revert documentation change too (Shared library support)
>>     (Suggested-by: Kees Cook <keescook@chromium.org>)
>>  * The GCC plugin infrastructure now supports the arm and arm64 architectures too
>>     (Signed-off-by: David Brown <david.brown@linaro.org>)
>>  * Simplify the computation of PLUGINCC (GCC plugin infrastructure)
>>     (Suggested-by: Masahiro Yamada <yamada.masahiro@socionext.com>)
>>  * Simplify the invocation of gcc-plugin.sh (GCC plugin infrastructure)
>>     (Suggested-by: Masahiro Yamada <yamada.masahiro@socionext.com>)
>>  * Make use of multi-depend (Shared library support)
>>     (Suggested-by: Masahiro Yamada <yamada.masahiro@socionext.com>)
>>  * Remove unnecessary exports (GCC plugin infrastructure)
>>     (Suggested-by: Masahiro Yamada <yamada.masahiro@socionext.com>)
>>  * Simplify Makefile by using addprefix (GCC plugin infrastructure)
>>     (Suggested-by: Masahiro Yamada <yamada.masahiro@socionext.com>)
>>  * Moved the gcc plugins from tools/ to scripts/ (GCC plugin infrastructure)
>>     (Suggested-by: Masahiro Yamada <yamada.masahiro@socionext.com>)
>>  * Removed plugins from KBUILD_CFLAGS_32 (GCC plugin infrastructure)
>>  * Remove gcc-plugin target everywhere
>>     (Suggested-by and partly Written-by: Masahiro Yamada <yamada.masahiro@socionext.com>)
>>  * There is no leaf gcc attribute in gcc-4.5 (Add sancov plugin)
>>  * Added support to the sancov plugin with kcov (Add sancov plugin)
>>
>> Changes from v4:
>>  * Moved shared library support from the GCC plugin infrastructure patch into
>>    a different patch
>>  * Update gcc-*.h from PaX
>>    * Fixed gcc-common.h for gcc 6
>>    * Added pass cloning support to the gcc pass generators
>>  * Disable all plugins in vdso because it is userland code
>>  * Add sancov gcc plugin: another use case for gcc plugin support in the kernel
>>    is when there is a feature in the latest gcc version and we would like to use
>>    it with older gcc versions as well (e.g., distros).
>>
>> Changes from v3:
>>  * Fix some indentation related warnings
>>    (Suggested by checkpatch.pl)
>>  * Add maintainer entries
>>  * Don't run gcc_plugin.sh when the GCC_PLUGINS option is disabled or unsupported
>>    (Reported-by: Fengguang Wu <fengguang.wu@intel.com>)
>>
>> Changes from v2:
>>  * Fixed incorrectly encoded characters
>>  * Generate the GIMPLE, IPA, SIMPLE_IPA and RTL pass structures
>>    (Suggested-by: Rasmus Villemoes <linux@rasmusvillemoes.dk>)
>>  * Write plugin related warning messages to stderr instead of stdout
>>    (Suggested-by: Kees Cook <keescook@chromium.org>)
>>  * Mention the installation of the gcc plugin headers (Documentation)
>>
>> Changes from v1:
>>  * Move the gcc-plugins make target into a separate Makefile because there may
>>    be a lot of plugins (Suggested-by: Rasmus Villemoes)
>>  * Simplify the dependencies of the plugin related config option
>>    (Suggested-by: Kees Cook <keescook@chromium.org>)
>>  * Removed the unnecessary example plugin
>
> This looks really good to me! Masahiro are there any other things you
> see here that need fixing? Michal, does this look like it's ready for
> -next? I'd be happy to carry it via one of my trees if you want.


I am busy these days, but hopefully I will manage to find some time
to review this series this weekend.




-- 
Best Regards
Masahiro Yamada
