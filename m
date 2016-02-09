Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160207223257.28ca7020daa09c082e6b9c62@gmail.com>
References: <20160207222721.e0087a07fa604b5dac79a109@gmail.com>
	<20160207223257.28ca7020daa09c082e6b9c62@gmail.com>
Date: Mon, 8 Feb 2016 20:27:31 -0800
Message-ID: <CAGXu5j+ugmECzm7-ppjVLd=oii5tewUxrRVc5T25hdodeVkq2g@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH 3/3] Documentation for the GCC plugin infrastructure
To: Emese Revfy <re.emese@gmail.com>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Michal Marek <mmarek@suse.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Feb 7, 2016 at 1:32 PM, Emese Revfy <re.emese@gmail.com> wrote:
> This is the GCC infrastructure documentation about its operation, how to add
> and use a new plugin with an example.
>
> ---
>  Documentation/example_gcc_plugin.c | 103 +++++++++++++++++++++++++++++++++++++

Perhaps this example should live in samples/gcc_plugin/ ?

>  Documentation/gcc-plugins.txt      |  76 +++++++++++++++++++++++++++
>  2 files changed, 179 insertions(+)
>  create mode 100644 Documentation/example_gcc_plugin.c
>  create mode 100644 Documentation/gcc-plugins.txt
>
> diff --git a/Documentation/example_gcc_plugin.c b/Documentation/example_gcc_plugin.c
> new file mode 100644
> index 0000000..950ff78
> --- /dev/null
> +++ b/Documentation/example_gcc_plugin.c
> @@ -0,0 +1,103 @@
> +/*
> + * Copyright 2011-2016 by Emese Revfy <re.emese@gmail.com>
> + * Licensed under the GPL v2, or (at your option) v3
> + */
> +
> +#include "gcc-common.h"
> +
> +int plugin_is_GPL_compatible;
> +
> +static struct plugin_info example_plugin_info = {
> +       .version        = "0",
> +       .help           = "example plugin\n",
> +};
> +
> +static unsigned int handle_function(void)
> +{
> +       gimple_stmt_iterator gsi;
> +       basic_block bb;
> +
> +       FOR_ALL_BB_FN(bb, cfun) {
> +               for (gsi = gsi_start_bb(bb); !gsi_end_p(gsi); gsi_next(&gsi))
> +                       debug_gimple_stmt(gsi_stmt(gsi));
> +       }
> +       return 0;
> +}
> +
> +#if BUILDING_GCC_VERSION >= 4009
> +namespace {
> +static const struct pass_data example_plugin_pass_data = {
> +#else
> +static struct gimple_opt_pass example_plugin_pass = {
> +       .pass = {
> +#endif
> +               .type                   = GIMPLE_PASS,
> +               .name                   = "example_plugin",
> +#if BUILDING_GCC_VERSION >= 4008
> +               .optinfo_flags          = OPTGROUP_NONE,
> +#endif
> +#if BUILDING_GCC_VERSION >= 5000
> +#elif BUILDING_GCC_VERSION >= 4009
> +               .has_gate               = false,
> +               .has_execute            = true,
> +#else
> +               .gate                   = NULL,
> +               .execute                = handle_function,
> +               .sub                    = NULL,
> +               .next                   = NULL,
> +               .static_pass_number     = 0,
> +#endif
> +               .tv_id                  = TV_NONE,
> +               .properties_required    = 0,
> +               .properties_provided    = 0,
> +               .properties_destroyed   = 0,
> +               .todo_flags_start       = 0,
> +               .todo_flags_finish      = TODO_dump_func
> +#if BUILDING_GCC_VERSION < 4009
> +       }
> +#endif
> +};
> +
> +#if BUILDING_GCC_VERSION >= 4009
> +class example_plugin_pass : public gimple_opt_pass {
> +public:
> +       example_plugin_pass() : gimple_opt_pass(example_plugin_pass_data, g) {}
> +#if BUILDING_GCC_VERSION >= 5000
> +       virtual unsigned int execute(function *) { return handle_function(); }
> +#else
> +       unsigned int execute() { return handle_function(); }
> +#endif
> +};
> +}
> +
> +static opt_pass *make_example_plugin_pass(void)
> +{
> +       return new example_plugin_pass();
> +}
> +#else
> +static struct opt_pass *make_example_plugin_pass(void)
> +{
> +       return &example_plugin_pass.pass;
> +}
> +#endif
> +
> +int plugin_init(struct plugin_name_args *plugin_info, struct plugin_gcc_version *version)
> +{
> +       const char * const plugin_name = plugin_info->base_name;
> +       struct register_pass_info example_plugin_pass_info;
> +
> +       example_plugin_pass_info.pass                           = make_example_plugin_pass();
> +       example_plugin_pass_info.reference_pass_name            = "ssa";
> +       example_plugin_pass_info.ref_pass_instance_number       = 1;
> +       example_plugin_pass_info.pos_op                         = PASS_POS_INSERT_AFTER;
> +
> +       if (!plugin_default_version_check(version, &gcc_version)) {
> +               error(G_("incompatible gcc/plugin versions"));
> +               return 1;
> +       }
> +
> +       register_callback(plugin_name, PLUGIN_INFO, NULL, &example_plugin_info);
> +       register_callback(plugin_name, PLUGIN_PASS_MANAGER_SETUP, NULL, &example_plugin_pass_info);
> +
> +       return 0;
> +}

For an example, I'd expect verbose comments. :) Imagine someone
reading it who knows very little about plugins or compiler internals.

> diff --git a/Documentation/gcc-plugins.txt b/Documentation/gcc-plugins.txt
> new file mode 100644
> index 0000000..e669d83
> --- /dev/null
> +++ b/Documentation/gcc-plugins.txt
> @@ -0,0 +1,76 @@
> +GCC plugin infrastructure
> +=========================
> +
> +
> +1. Introduction
> +===============
> +
> +GCC plugins are loadable modules that provide extra features to the
> +compiler [1]. They are useful for runtime instrumentation and static analysis.
> +We can analyse, change and add further code during compilation via
> +callbacks [2], GIMPLE [3], IPA [4] and RTL passes [5].
> +
> +The GCC plugin infrastructure of the kernel supports all gcc versions from
> +4.5 to 6.0, building out-of-tree modules, cross-compilation and building in a
> +separate directory.
> +
> +Currently the GCC plugin infrastructure supports only the x86 architecture.
> +
> +This infrastructure was ported from grsecurity [6] and PaX [7].
> +
> +--
> +[1] https://gcc.gnu.org/onlinedocs/gccint/Plugins.html
> +[2] https://gcc.gnu.org/onlinedocs/gccint/Plugin-API.html#Plugin-API
> +[3] https://gcc.gnu.org/onlinedocs/gccint/GIMPLE.html
> +[4] https://gcc.gnu.org/onlinedocs/gccint/IPA.html
> +[5] https://gcc.gnu.org/onlinedocs/gccint/RTL.html
> +[6] https://grsecurity.net/
> +[7] https://pax.grsecurity.net/
> +
> +
> +2. Files
> +========
> +
> +$(src)/tools/gcc
> +       This is the directory of the GCC plugins.
> +
> +$(src)/tools/gcc/gcc-common.h
> +       This is a compatibility header for GCC plugins.
> +       It should be always included instead of individual gcc headers.
> +
> +$(src)/scripts/gcc-plugin.sh
> +       This script checks the availability of the included headers in
> +       gcc-common.h and chooses the proper host compiler to build the plugins
> +       (gcc-4.7 can be built by either gcc or g++).
> +
> +
> +3. Usage
> +========
> +
> +Enable a GCC plugin based feature in the kernel config:
> +
> +       CONFIG_GCC_PLUGIN_CYC_COMPLEXITY = y
> +
> +To compile only the plugin(s):
> +
> +       make gcc-plugins
> +
> +or just run the kernel make and compile the whole kernel with
> +the cyclomatic complexity GCC plugin.
> +
> +
> +4. How to add a new GCC plugin
> +==============================
> +
> +The GCC plugins are in $(src)/tools/gcc/. You can use a file or a directory
> +here. It must be added to $(src)/tools/gcc/Makefile, $(src)/Makefile and
> +$(src)/arch/Kconfig.
> +See the cyc_complexity_plugin.c (CONFIG_GCC_PLUGIN_CYC_COMPLEXITY) GCC plugin.
> +
> +
> +5. Example GCC plugin
> +=====================
> +
> +You can find an example plugin under $(src)/Documentation/example_gcc_plugin.c .
> +This plugin has a GIMPLE pass that is inserted after the ssa GCC pass.
> +It prints out all the GIMPLE statements in a translation unit.

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
