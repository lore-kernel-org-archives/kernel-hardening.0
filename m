Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160207223140.830691e83ab579f46f991410@gmail.com>
References: <20160207222721.e0087a07fa604b5dac79a109@gmail.com>
	<20160207223140.830691e83ab579f46f991410@gmail.com>
Date: Mon, 8 Feb 2016 20:23:12 -0800
Message-ID: <CAGXu5jJb4aJKQDTscJqUve6tO4S=5zU+X7ZGw87MfDoFMQSxLw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH 2/3] Add Cyclomatic complexity GCC plugin
To: Emese Revfy <re.emese@gmail.com>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Michal Marek <mmarek@suse.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Feb 7, 2016 at 1:31 PM, Emese Revfy <re.emese@gmail.com> wrote:
> Add a very simple plugin to demonstrate the GCC plugin infrastructure. This GCC
> plugin computes the cyclomatic complexity of each function.
>
> The complexity M of a function's control flow graph is defined as:
>  M = E - N + 2P
> where
>  E = the number of edges
>  N = the number of nodes
>  P = the number of connected components (exit nodes).
>
> ---
>  Makefile                          |   6 +-
>  arch/Kconfig                      |  16 +++++
>  tools/gcc/Makefile                |   4 ++
>  tools/gcc/cyc_complexity_plugin.c | 120 ++++++++++++++++++++++++++++++++++++++
>  4 files changed, 145 insertions(+), 1 deletion(-)
>  create mode 100644 tools/gcc/cyc_complexity_plugin.c
>
> diff --git a/Makefile b/Makefile
> index 96ce015..9f76c26 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -628,7 +628,11 @@ else
>  PLUGINCC := $(shell $(CONFIG_SHELL) $(srctree)/scripts/gcc-plugin.sh "$(HOSTCC)" "$(HOSTCXX)" "$(CC)")
>  endif
>  ifneq ($(PLUGINCC),)
> -export PLUGINCC GCC_PLUGINS_CFLAGS GCC_PLUGINS_AFLAGS
> +ifdef CONFIG_GCC_PLUGIN_CYC_COMPLEXITY
> +GCC_PLUGIN_CYC_COMPLEXITY_CFLAGS := -fplugin=$(objtree)/tools/gcc/cyc_complexity_plugin.so -DGCC_PLUGIN_CYC_COMPLEXITY
> +endif
> +GCC_PLUGINS_CFLAGS := $(GCC_PLUGIN_CYC_COMPLEXITY_CFLAGS)
> +export PLUGINCC GCC_PLUGINS_CFLAGS GCC_PLUGINS_AFLAGS GCC_PLUGIN_CYC_COMPLEXITY
>  ifeq ($(KBUILD_EXTMOD),)
>  gcc-plugins:
>         $(Q)$(MAKE) $(build)=tools/gcc
> diff --git a/arch/Kconfig b/arch/Kconfig
> index a95e5b1..6b7d4de 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -365,6 +365,22 @@ config HAVE_GCC_PLUGINS
>           An arch should select this symbol if it supports building with
>           gcc plugins.
>
> +if HAVE_GCC_PLUGINS
> +
> +config GCC_PLUGIN_CYC_COMPLEXITY
> +       bool "Compute the cyclomatic complexity of a function"
> +       help

Rather than the "if HAVE_GCC_PLUGINS" / endif section, I would add
"depends HAVE_GCC_PLUGINS" to the config, which makes things more
discoverable.

> +         The complexity M of a function's control flow graph is defined as:
> +          M = E - N + 2P
> +         where
> +
> +         E = the number of edges
> +         N = the number of nodes
> +         P = the number of connected components (exit nodes).
> +
> +         See Documentation/gcc-plugins.txt for details.

Is this plugin documented there? I don't see a chunk for that in this patch.

> +
> +endif # HAVE_GCC_PLUGINS
>  endmenu # "GCC plugins"
>
>  config HAVE_CC_STACKPROTECTOR
> diff --git a/tools/gcc/Makefile b/tools/gcc/Makefile
> index b2d64af..31c72bf 100644
> --- a/tools/gcc/Makefile
> +++ b/tools/gcc/Makefile
> @@ -12,4 +12,8 @@ endif
>
>  export GCCPLUGINS_DIR HOSTLIBS
>
> +$(HOSTLIBS)-$(CONFIG_GCC_PLUGIN_CYC_COMPLEXITY) := cyc_complexity_plugin.so
> +
>  always := $($(HOSTLIBS)-y)
> +
> +cyc_complexity_plugin-objs := cyc_complexity_plugin.o
> diff --git a/tools/gcc/cyc_complexity_plugin.c b/tools/gcc/cyc_complexity_plugin.c
> new file mode 100644
> index 0000000..c6f0d58
> --- /dev/null
> +++ b/tools/gcc/cyc_complexity_plugin.c
> @@ -0,0 +1,120 @@
> +/*
> + * Copyright 2011-2016 by Emese Revfy <re.emese@gmail.com>
> + * Licensed under the GPL v2, or (at your option) v3
> + *
> + * Homepage:
> + * https://github.com/ephox-gcc-plugins/cyclomatic_complexity
> + *
> + * http://en.wikipedia.org/wiki/Cyclomatic_complexity
> + * The complexity M is then defined as:
> + * M = E - N + 2P
> + * where
> + *
> + *  E = the number of edges of the graph
> + *  N = the number of nodes of the graph
> + *  P = the number of connected components (exit nodes).
> + *
> + * Usage (4.5 - 5):
> + * $ make clean; make run
> + */
> +
> +#include "gcc-common.h"
> +
> +int plugin_is_GPL_compatible;
> +
> +static struct plugin_info cyc_complexity_plugin_info = {
> +       .version        = "20150523",
> +       .help           = "Cyclomatic Complexity\n",
> +};
> +
> +static unsigned int handle_function(void)
> +{
> +       int complexity;
> +       expanded_location xloc;
> +
> +       // M = E - N + 2P
> +       complexity = n_edges_for_fn(cfun) - n_basic_blocks_for_fn(cfun) + 2;
> +
> +       xloc = expand_location(DECL_SOURCE_LOCATION(current_function_decl));
> +       fprintf(stderr, "Cyclomatic Complexity %d %s:%s\n", complexity, xloc.file, DECL_NAME_POINTER(current_function_decl));
> +
> +       return 0;
> +}
> +
> +#if BUILDING_GCC_VERSION >= 4009
> +namespace {
> +static const struct pass_data cyc_complexity_pass_data = {
> +#else
> +static struct gimple_opt_pass cyc_complexity_pass = {
> +       .pass = {
> +#endif
> +               .type                   = GIMPLE_PASS,
> +               .name                   = "cyc_complexity",
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
> +class cyc_complexity_pass : public gimple_opt_pass {
> +public:
> +       cyc_complexity_pass() : gimple_opt_pass(cyc_complexity_pass_data, g) {}
> +#if BUILDING_GCC_VERSION >= 5000
> +       virtual unsigned int execute(function *) { return handle_function(); }
> +#else
> +       unsigned int execute() { return handle_function(); }
> +#endif
> +};
> +}
> +
> +static struct opt_pass *make_cyc_complexity_pass(void)
> +{
> +       return new cyc_complexity_pass();
> +}
> +#else
> +static struct opt_pass *make_cyc_complexity_pass(void)
> +{
> +       return &cyc_complexity_pass.pass;
> +}
> +#endif
> +
> +int plugin_init(struct plugin_name_args *plugin_info, struct plugin_gcc_version *version)
> +{
> +       const char * const plugin_name = plugin_info->base_name;
> +       struct register_pass_info cyc_complexity_pass_info;
> +
> +       cyc_complexity_pass_info.pass                           = make_cyc_complexity_pass();
> +       cyc_complexity_pass_info.reference_pass_name            = "ssa";
> +       cyc_complexity_pass_info.ref_pass_instance_number       = 1;
> +       cyc_complexity_pass_info.pos_op                         = PASS_POS_INSERT_AFTER;
> +
> +       if (!plugin_default_version_check(version, &gcc_version)) {
> +               error(G_("incompatible gcc/plugin versions"));
> +               return 1;
> +       }
> +
> +       register_callback(plugin_name, PLUGIN_INFO, NULL, &cyc_complexity_plugin_info);
> +       register_callback(plugin_name, PLUGIN_PASS_MANAGER_SETUP, NULL, &cyc_complexity_pass_info);
> +
> +       return 0;
> +}
>



-- 
Kees Cook
Chrome OS & Brillo Security
