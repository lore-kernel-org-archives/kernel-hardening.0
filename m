Reply-To: kernel-hardening@lists.openwall.com
From: Rasmus Villemoes <linux@rasmusvillemoes.dk>
References: <20160207222721.e0087a07fa604b5dac79a109@gmail.com>
	<20160207223140.830691e83ab579f46f991410@gmail.com>
Date: Mon, 08 Feb 2016 00:05:15 +0100
In-Reply-To: <20160207223140.830691e83ab579f46f991410@gmail.com> (Emese
	Revfy's message of "Sun, 7 Feb 2016 22:31:40 +0100")
Message-ID: <87mvrcdsus.fsf@rasmusvillemoes.dk>
MIME-Version: 1.0
Content-Type: text/plain
Subject: [kernel-hardening] Re: [PATCH 2/3] Add Cyclomatic complexity GCC plugin
To: Emese Revfy <re.emese@gmail.com>
Cc: linux-kbuild@vger.kernel.org, pageexec@freemail.hu, spender@grsecurity.net, kernel-hardening@lists.openwall.com, mmarek@suse.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Feb 07 2016, Emese Revfy <re.emese@gmail.com> wrote:

> Add a very simple plugin to demonstrate the GCC plugin infrastructure.
> This GCC plugin computes the cyclomatic complexity of each function.
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

Hm, when the number of plugins grow, I think it'll be somewhat ugly
having all this in the main makefile. Can't all the plugin-related stuff
live in a separate makefile? The same goes for the Kconfig part.

Also, I think the compile command lines are already complicated enough
(I sometimes use V=1 to see what's going on), so I think it's better
that the plugins that need to make themselves known do so "from within"
gcc; something like

static void define_feature_macro(void __unused *event_data, void __unused *data)
{
	cpp_define(parse_in, "HAVE_ATTRIBUTE_FOOBAR");	
}

...

	register_callback(plugin_name, PLUGIN_START_UNIT, &define_feature_macro, NULL);


> +
> +#include "gcc-common.h"
> +
> +int plugin_is_GPL_compatible;
> +
> +static struct plugin_info cyc_complexity_plugin_info = {
> +	.version	= "20150523",
> +	.help		= "Cyclomatic Complexity\n",
> +};
> +
> +static unsigned int handle_function(void)
> +{
> +	int complexity;
> +	expanded_location xloc;
> +
> +	// M = E - N + 2P
> +	complexity = n_edges_for_fn(cfun) - n_basic_blocks_for_fn(cfun) + 2;
> +
> +	xloc = expand_location(DECL_SOURCE_LOCATION(current_function_decl));
> +	fprintf(stderr, "Cyclomatic Complexity %d %s:%s\n", complexity, xloc.file, DECL_NAME_POINTER(current_function_decl));
> +
> +	return 0;
> +}
> +
> +#if BUILDING_GCC_VERSION >= 4009
> +namespace {
> +static const struct pass_data cyc_complexity_pass_data = {
> +#else
> +static struct gimple_opt_pass cyc_complexity_pass = {
> +	.pass = {
> +#endif
> +		.type			= GIMPLE_PASS,
> +		.name			= "cyc_complexity",
> +#if BUILDING_GCC_VERSION >= 4008
> +		.optinfo_flags		= OPTGROUP_NONE,
> +#endif
> +#if BUILDING_GCC_VERSION >= 5000
> +#elif BUILDING_GCC_VERSION >= 4009
> +		.has_gate		= false,
> +		.has_execute		= true,
> +#else
> +		.gate			= NULL,
> +		.execute		= handle_function,
> +		.sub			= NULL,
> +		.next			= NULL,
> +		.static_pass_number	= 0,
> +#endif
> +		.tv_id			= TV_NONE,
> +		.properties_required	= 0,
> +		.properties_provided	= 0,
> +		.properties_destroyed	= 0,
> +		.todo_flags_start	= 0,
> +		.todo_flags_finish	= TODO_dump_func
> +#if BUILDING_GCC_VERSION < 4009
> +	}
> +#endif
> +};
> +

This is really yucky. Is there any way a mere mortal could figure out
how to write this? Or could the compatibility layer provide some utility
macros that would take care of the boilerplate?

Rasmus
