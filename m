MIME-Version: 1.0
Sender: arndbergmann@gmail.com
In-Reply-To: <CAK8P3a1Oi5pf1DeZRkSD+08Xa0ez_0wMQxi8HvOb4cHrT3TyYA@mail.gmail.com>
References: <1485894263-91051-1-git-send-email-keescook@chromium.org>
 <1485894263-91051-2-git-send-email-keescook@chromium.org> <CAK8P3a1Oi5pf1DeZRkSD+08Xa0ez_0wMQxi8HvOb4cHrT3TyYA@mail.gmail.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 29 Mar 2017 10:56:24 +0200
Message-ID: <CAK8P3a24SAf18a5308qQVM0ZvqT+CycSS9CFJAUowvr1zKRteQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v5 1/4] gcc-plugins: Add the initify gcc plugin
To: Kees Cook <keescook@chromium.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Emese Revfy <re.emese@gmail.com>, Josh Triplett <josh@joshtriplett.org>, PaX Team <pageexec@freemail.hu>, Masahiro Yamada <yamada.masahiro@socionext.com>, minipli@ld-linux.so, Russell King - ARM Linux <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, David Brown <david.brown@linaro.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Jeff Layton <jlayton@poochiereds.net>, Sam Ravnborg <sam@ravnborg.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

And here is a workaround that I applied locally to avoid the ICE, but
I wouldn't want to have this upstream.

commit 8712fd8979a5730318a84922fbcb8791ea5af40e
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Wed Mar 29 10:53:48 2017 +0200

    work around initify ICE

    arch/arm/mach-mv78xx0/common.i: In function 'mv78xx0_init':
    arch/arm/mach-mv78xx0/common.i:28:38: internal compiler error: in
search_constant_strings, at
git/arm-soc/scripts/gcc-plugins/initify_plugin.c:1375
         __attribute__ ((latent_entropy)) mv78xx0_init(void)
                                          ^~~~~~~~~~~~
    0x7fe5cd711b9d search_constant_strings
            /git/arm-soc/scripts/gcc-plugins/initify_plugin.c:1375
    0x7fe5cd711950 search_constant_strings
            /git/arm-soc/scripts/gcc-plugins/initify_plugin.c:1335
    0x7fe5cd711950 search_constant_strings
            /git/arm-soc/scripts/gcc-plugins/initify_plugin.c:1367
    0x7fe5cd712abe search_constant_strings
            /git/arm-soc/scripts/gcc-plugins/initify_plugin.c:1506
    0x7fe5cd712abe search_var_param
            /git/arm-soc/scripts/gcc-plugins/initify_plugin.c:1419
    0x7fe5cd712abe search_const_strs
            /git/arm-soc/scripts/gcc-plugins/initify_plugin.c:1471
    0x7fe5cd712abe initify_function_transform
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

    Signed-off-by: Arnd Bergmann <arnd@arndb.de>

diff --git a/arch/arm/mach-mv78xx0/common.c b/arch/arm/mach-mv78xx0/common.c
index f72e1e9f5fc5..66e04a770e32 100644
--- a/arch/arm/mach-mv78xx0/common.c
+++ b/arch/arm/mach-mv78xx0/common.c
@@ -348,31 +348,41 @@ void __ref mv78xx0_timer_init(void)
 /*****************************************************************************
  * General
  ****************************************************************************/
-static char * __init mv78xx0_id(void)
+static const char * __init mv78xx0_id(void)
 {
        u32 dev, rev;
+       static const char *chip_ids[] = {
+               "MV78X00-Z0",
+               "MV78X00-Rev-Unsupported",
+               "MV78100-A0",
+               "MV78100-A1",
+               "MV78100-Rev-Unsupported",
+               "MV78200-A0",
+               "MV78200-Rev-Unsupported",
+               "Device-Unknown",
+       };

        mv78xx0_pcie_id(&dev, &rev);

        if (dev == MV78X00_Z0_DEV_ID) {
                if (rev == MV78X00_REV_Z0)
-                       return "MV78X00-Z0";
+                       return chip_ids[0];
                else
-                       return "MV78X00-Rev-Unsupported";
+                       return chip_ids[1];
        } else if (dev == MV78100_DEV_ID) {
                if (rev == MV78100_REV_A0)
-                       return "MV78100-A0";
+                       return chip_ids[2];
                else if (rev == MV78100_REV_A1)
-                       return "MV78100-A1";
+                       return chip_ids[3];
                else
-                       return "MV78100-Rev-Unsupported";
+                       return chip_ids[4];
        } else if (dev == MV78200_DEV_ID) {
                if (rev == MV78100_REV_A0)
-                       return "MV78200-A0";
+                       return chip_ids[5];
                else
-                       return "MV78200-Rev-Unsupported";
+                       return chip_ids[6];
        } else {
-               return "Device-Unknown";
+               return chip_ids[7];
        }
 }
