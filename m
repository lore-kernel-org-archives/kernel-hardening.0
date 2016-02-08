Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 8 Feb 2016 22:20:47 +0100
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160208222047.ac76b445fbf38416a6095425@gmail.com>
In-Reply-To: <87mvrcdsus.fsf@rasmusvillemoes.dk>
References: <20160207222721.e0087a07fa604b5dac79a109@gmail.com>
	<20160207223140.830691e83ab579f46f991410@gmail.com>
	<87mvrcdsus.fsf@rasmusvillemoes.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 2/3] Add Cyclomatic complexity GCC plugin
To: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: linux-kbuild@vger.kernel.org, pageexec@freemail.hu, spender@grsecurity.net, kernel-hardening@lists.openwall.com, mmarek@suse.com, keescook@chromium.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 08 Feb 2016 00:05:15 +0100
Rasmus Villemoes <linux@rasmusvillemoes.dk> wrote:

> having all this in the main makefile. Can't all the plugin-related stuff
> live in a separate makefile? The same goes for the Kconfig part.

I will do the Makefile separation but I'm not sure about a separate arch/Kconfig.gcc-plugins
as arch/Kconfig seems to be a general collection of arch/toolchain dependent features
so I would rather stick to it until there is a general decision to break it up into smaller pieces.

> Also, I think the compile command lines are already complicated enough
> (I sometimes use V=1 to see what's going on), so I think it's better
> that the plugins that need to make themselves known do so "from within"
> gcc; something like
> 
> static void define_feature_macro(void __unused *event_data, void __unused *data)
> {
> 	cpp_define(parse_in, "HAVE_ATTRIBUTE_FOOBAR");	
> }

I think it is better in the Makefile because -DPLUGIN doesn't matter much in the compile command
compared to -fplugin and -fplugin-arg. An exmaple compile command with more plugins looks like this:

gcc -Wp,-MD,fs/.exec.o.d  -nostdinc -isystem /usr/lib/gcc/x86_64-pc-linux-gnu/4.9.3/include
-I./arch/x86/include -Iarch/x86/include/generated/uapi -Iarch/x86/include/generated  -Iinclude
-I./arch/x86/include/uapi -Iarch/x86/include/generated/uapi -I./include/uapi -Iinclude/generated/uapi
-include ./include/linux/kconfig.h -D__KERNEL__ -Wall -Wundef -Wstrict-prototypes -Wno-trigraphs
-fno-strict-aliasing -fno-common -Werror-implicit-function-declaration -Wno-format-security -std=gnu89
-mno-sse -mno-mmx -mno-sse2 -mno-3dnow -mno-avx -m64 -falign-jumps=1 -falign-loops=1 -mno-80387 -mno-fp-ret-in-387
-mpreferred-stack-boundary=3 -mtune=generic -mno-red-zone -mcmodel=kernel -funit-at-a-time -maccumulate-outgoing-args
-ffreestanding -DCONFIG_X86_X32_ABI -DCONFIG_AS_FXSAVEQ=1 -DCONFIG_AS_SSSE3=1 -DCONFIG_AS_CRC32=1 -DCONFIG_AS_AVX=1 
-DCONFIG_AS_AVX2=1 -pipe -Wno-sign-compare -fno-asynchronous-unwind-tables -fno-delete-null-pointer-checks -Os
-Wno-maybe-uninitialized --param=allow-store-data-races=0 -fno-reorder-blocks -fno-ipa-cp-clone -fno-partial-inlining
-Wframe-larger-than=2048 -fno-stack-protector -Wno-unused-but-set-variable -fno-omit-frame-pointer
-fno-optimize-sibling-calls -fno-var-tracking-assignments -fno-inline-functions-called-once -Wdeclaration-after-statement
-Wno-pointer-sign -fno-strict-overflow -fconserve-stack -Werror=implicit-int -Werror=strict-prototypes -Werror=date-time
-DCC_HAVE_ASM_GOTO -fplugin=./tools/gcc/stackleak_plugin.so -DSTACKLEAK_PLUGIN
-fplugin-arg-stackleak_plugin-track-lowest-sp=100 -fplugin=./tools/gcc/colorize_plugin.so
-fplugin=./tools/gcc/size_overflow_plugin/size_overflow_plugin.so -DSIZE_OVERFLOW_PLUGIN
-fplugin=./tools/gcc/latent_entropy_plugin.so -DLATENT_ENTROPY_PLUGIN -fplugin=./tools/gcc/structleak_plugin.so 
-DSTRUCTLEAK_PLUGIN -fplugin=./tools/gcc/initify_plugin.so -DINITIFY_PLUGIN -fplugin=./tools/gcc/randomize_layout_plugin.so
-DRANDSTRUCT_PLUGIN -fplugin-arg-randomize_layout_plugin-performance-mode    -D"KBUILD_STR(s)=#s" 
-D"KBUILD_BASENAME=KBUILD_STR(exec)"  -D"KBUILD_MODNAME=KBUILD_STR(exec)" -c -o fs/.tmp_exec.o fs/exec.c

> > +#if BUILDING_GCC_VERSION >= 4009
> > +namespace {
> > +static const struct pass_data cyc_complexity_pass_data = {
> > +#else
> > +static struct gimple_opt_pass cyc_complexity_pass = {
> > +	.pass = {
> > +#endif
> > +		.type			= GIMPLE_PASS,
> > +		.name			= "cyc_complexity",
> > +#if BUILDING_GCC_VERSION >= 4008
> > +		.optinfo_flags		= OPTGROUP_NONE,
> > +#endif
> > +#if BUILDING_GCC_VERSION >= 5000
> > +#elif BUILDING_GCC_VERSION >= 4009
> > +		.has_gate		= false,
> > +		.has_execute		= true,
> > +#else
> > +		.gate			= NULL,
> > +		.execute		= handle_function,
> > +		.sub			= NULL,
> > +		.next			= NULL,
> > +		.static_pass_number	= 0,
> > +#endif
> > +		.tv_id			= TV_NONE,
> > +		.properties_required	= 0,
> > +		.properties_provided	= 0,
> > +		.properties_destroyed	= 0,
> > +		.todo_flags_start	= 0,
> > +		.todo_flags_finish	= TODO_dump_func
> > +#if BUILDING_GCC_VERSION < 4009
> > +	}
> > +#endif
> > +};
> > +
> 
> This is really yucky. Is there any way a mere mortal could figure out
> how to write this? Or could the compatibility layer provide some utility
> macros that would take care of the boilerplate?

Yes, it isn't too nice but if I put them into macros (for GIMPLE, IPA and RTL) then
they would have a lot of parameters because the user can and must define too many values
(especially for an IPA pass which has even more fields).
The compatibility with all gcc versions makes it further complicated so I think
the end result would be uglier than it is now.

-- 
Emese
