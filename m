MIME-Version: 1.0
Sender: arndbergmann@gmail.com
In-Reply-To: <1485894263-91051-2-git-send-email-keescook@chromium.org>
References: <1485894263-91051-1-git-send-email-keescook@chromium.org> <1485894263-91051-2-git-send-email-keescook@chromium.org>
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 29 Mar 2017 10:32:35 +0200
Message-ID: <CAK8P3a1Oi5pf1DeZRkSD+08Xa0ez_0wMQxi8HvOb4cHrT3TyYA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v5 1/4] gcc-plugins: Add the initify gcc plugin
To: Kees Cook <keescook@chromium.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Emese Revfy <re.emese@gmail.com>, Josh Triplett <josh@joshtriplett.org>, PaX Team <pageexec@freemail.hu>, Masahiro Yamada <yamada.masahiro@socionext.com>, minipli@ld-linux.so, Russell King - ARM Linux <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, David Brown <david.brown@linaro.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Jeff Layton <jlayton@poochiereds.net>, Sam Ravnborg <sam@ravnborg.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Here is a reduced test case for one assertion failure I get with the
initify plugin:

8<------------
typedef unsigned int u32;

__attribute__ ((format(printf, 1, 2))) __attribute__ ((__cold__))
int printk(const char *fmt, ...);

void mv78xx0_pcie_id(u32 * dev, u32 * rev);

static char * __attribute__ ((__section__(".init.text")))
    __attribute__ ((__cold__)) __attribute__ ((no_instrument_function))
    __attribute__ ((latent_entropy)) mv78xx0_id(void)
{
        u32 dev, rev;
        mv78xx0_pcie_id(&dev, &rev);
        if (dev == 0x7820) {
                return "MV78200-A0";
        } else {
                return "Device-Unknown";
        }
}

void __attribute__ ((__section__(".init.text"))) __attribute__ ((__cold__))
    __attribute__ ((no_instrument_function))
    __attribute__ ((latent_entropy)) mv78xx0_init(void)
{
        printk("\001" "6" "%s ", mv78xx0_id());
}
------------->8

arm-linux-gnueabi-gcc-7.0.1 -Wimplicit-fallthrough=0
-Wno-duplicate-decl-specifier -Wno-override-init
-Wno-int-in-bool-context -Wno-bool-operation -Wno-format-truncation
-Werror -Wa,--fatal-warnings -DKCONFIG_SEED= -wrapper
/usr/bin/time,--format=%M:%U:%C,-o,/home/arnd/arm-soc/defconfig-kbytes,--append
-Wp,-MD,arch/arm/mach-mv78xx0/.common.o.d  -nostdinc -isystem
/home/arnd/cross-gcc/lib/gcc/arm-linux-gnueabi/7.0.1/include
-I/git/arm-soc/arch/arm/include -I./arch/arm/include/generated/uapi
-I./arch/arm/include/generated  -I/git/arm-soc/include -I./include
-I/git/arm-soc/arch/arm/include/uapi -I/git/arm-soc/include/uapi
-I./include/generated/uapi -include
/git/arm-soc/include/linux/kconfig.h
-I/git/arm-soc/arch/arm/mach-mv78xx0 -Iarch/arm/mach-mv78xx0
-D__KERNEL__ -mbig-endian -Wall -Wundef -Wstrict-prototypes
-fno-strict-aliasing -fno-common -Werror-implicit-function-declaration
-std=gnu89 -fno-PIE -fno-dwarf2-cfi-asm -fno-ipa-sra -mabi=aapcs-linux
-mno-thumb-interwork -mfpu=vfp -funwind-tables -marm
-D__LINUX_ARM_ARCH__=5 -march=armv5te -mtune=xscale -msoft-float -Uarm
-Wextra -Wno-frame-address -ffunction-sections -fdata-sections -O2
--param=allow-store-data-races=0 -DCC_HAVE_ASM_GOTO
-fplugin=./scripts/gcc-plugins/initify_plugin.so
-fplugin=./scripts/gcc-plugins/latent_entropy_plugin.so
-DINITIFY_PLUGIN
-fplugin-arg-initify_plugin-search_init_exit_functions
-DLATENT_ENTROPY_PLUGIN -Wframe-larger-than=1024
-fstack-protector-strong -fno-delete-null-pointer-checks
-Wno-unused-but-set-variable -Wno-unused-const-variable
-fomit-frame-pointer -fno-var-tracking-assignments
-fno-inline-functions-called-once -Wdeclaration-after-statement
-Wno-pointer-sign -fno-strict-overflow -fconserve-stack
-Werror=implicit-int -Werror=strict-prototypes -Werror=date-time
-Werror=incompatible-pointer-types -Werror=designated-init
-Wno-type-limits -Wno-unused-parameter -Wno-missing-field-initializers
-Wno-sign-compare -Wmissing-include-dirs -Wformat=2
-Wno-format-nonliteral -Wtrampolines -Wold-style-definition
-Wnormalized -Wvolatile-register-var -Wdisabled-optimization
-Wno-format-security -Wimplicit-fallthrough=0
-Wno-duplicate-decl-specifier -Wno-int-in-bool-context
-Wno-bool-operation -Wformat-truncation=0 -Wformat-overflow=0
-I/git/arm-soc/arch/arm/plat-orion/include
-DKBUILD_BASENAME='"common"'  -DKBUILD_MODNAME='"common"' -c
arch/arm/mach-mv78xx0/common.c
*** WARNING *** there are active plugins, do not report this as a bug
unless you can reproduce it without enabling any plugins.
Event                            | Plugins
PLUGIN_ATTRIBUTES                | latent_entropy_plugin initify_plugin
PLUGIN_START_UNIT                | latent_entropy_plugin initify_plugin
arch/arm/mach-mv78xx0/common.i: In function 'mv78xx0_init':
arch/arm/mach-mv78xx0/common.i:23:38: internal compiler error: in
search_constant_strings, at
git/arm-soc/scripts/gcc-plugins/initify_plugin.c:1375
     __attribute__ ((latent_entropy)) mv78xx0_init(void)
                                      ^~~~~~~~~~~~
0x7f319a009b9d search_constant_strings
/git/arm-soc/scripts/gcc-plugins/initify_plugin.c:1375
0x7f319a009950 search_constant_strings
/git/arm-soc/scripts/gcc-plugins/initify_plugin.c:1335
0x7f319a009950 search_constant_strings
/git/arm-soc/scripts/gcc-plugins/initify_plugin.c:1367
0x7f319a00aabe search_constant_strings
/git/arm-soc/scripts/gcc-plugins/initify_plugin.c:1506
0x7f319a00aabe search_var_param
/git/arm-soc/scripts/gcc-plugins/initify_plugin.c:1419
0x7f319a00aabe search_const_strs
/git/arm-soc/scripts/gcc-plugins/initify_plugin.c:1471
0x7f319a00aabe initify_function_transform
/git/arm-soc/scripts/gcc-plugins/initify_plugin.c:1519
0x932ce7 execute_one_ipa_transform_pass
/home/arnd/git/gcc/gcc/passes.c:2207
0x932ce7 execute_all_ipa_transforms()
/home/arnd/git/gcc/gcc/passes.c:2249
0x6b28fc cgraph_node::expand()
/home/arnd/git/gcc/gcc/cgraphunit.c:2031
0x6b3e5c expand_all_functions
/home/arnd/git/gcc/gcc/cgraphunit.c:2174
0x6b3e5c symbol_table::compile()
/home/arnd/git/gcc/gcc/cgraphunit.c:2531
0x6b58b7 symbol_table::compile()
/home/arnd/git/gcc/gcc/cgraphunit.c:2595
0x6b58b7 symbol_table::finalize_compilation_unit()
/home/arnd/git/gcc/gcc/cgraphunit.c:2621
Please submit a full bug report,
with preprocessed source if appropriate.
Please include the complete backtrace with any bug report.
See <https://gcc.gnu.org/bugs/> for instructions.
