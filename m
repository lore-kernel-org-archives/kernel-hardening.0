MIME-Version: 1.0
Sender: arndbergmann@gmail.com
In-Reply-To: <CAK8P3a24SAf18a5308qQVM0ZvqT+CycSS9CFJAUowvr1zKRteQ@mail.gmail.com>
References: <1485894263-91051-1-git-send-email-keescook@chromium.org>
 <1485894263-91051-2-git-send-email-keescook@chromium.org> <CAK8P3a1Oi5pf1DeZRkSD+08Xa0ez_0wMQxi8HvOb4cHrT3TyYA@mail.gmail.com>
 <CAK8P3a24SAf18a5308qQVM0ZvqT+CycSS9CFJAUowvr1zKRteQ@mail.gmail.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 30 Mar 2017 13:04:40 +0200
Message-ID: <CAK8P3a3eWLcCDP-QUhan8+jRnGgfmCqKcQRVxHoRiyLke55uiw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v5 1/4] gcc-plugins: Add the initify gcc plugin
To: Kees Cook <keescook@chromium.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Emese Revfy <re.emese@gmail.com>, Josh Triplett <josh@joshtriplett.org>, PaX Team <pageexec@freemail.hu>, Masahiro Yamada <yamada.masahiro@socionext.com>, minipli@ld-linux.so, Russell King - ARM Linux <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, David Brown <david.brown@linaro.org>, Benjamin Herrenschmidt <benh@kernel.crashing.org>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Jeff Layton <jlayton@poochiereds.net>, Sam Ravnborg <sam@ravnborg.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Mar 29, 2017 at 10:56 AM, Arnd Bergmann <arnd@arndb.de> wrote:
> And here is a workaround that I applied locally to avoid the ICE, but
> I wouldn't want to have this upstream.
>
> commit 8712fd8979a5730318a84922fbcb8791ea5af40e
> Author: Arnd Bergmann <arnd@arndb.de>
> Date:   Wed Mar 29 10:53:48 2017 +0200
>
>     work around initify ICE
>
>     arch/arm/mach-mv78xx0/common.i: In function 'mv78xx0_init':
>     arch/arm/mach-mv78xx0/common.i:28:38: internal compiler error: in
> search_constant_strings, at
> git/arm-soc/scripts/gcc-plugins/initify_plugin.c:1375
>          __attribute__ ((latent_entropy)) mv78xx0_init(void)
>                                           ^~~~~~~~~~~~
>     0x7fe5cd711b9d search_constant_strings
>             /git/arm-soc/scripts/gcc-plugins/initify_plugin.c:1375
>     0x7fe5cd711950 search_constant_strings
>             /git/arm-soc/scripts/gcc-plugins/initify_plugin.c:1335
>     0x7fe5cd711950 search_constant_strings
>             /git/arm-soc/scripts/gcc-plugins/initify_plugin.c:1367
>     0x7fe5cd712abe search_constant_strings
>             /git/arm-soc/scripts/gcc-plugins/initify_plugin.c:1506


Two more ICEs:

a)
*** WARNING *** there are active plugins, do not report this as a bug
unless you can reproduce it without enabling any plugins.
Event                            | Plugins
PLUGIN_ATTRIBUTES                | latent_entropy_plugin initify_plugin
PLUGIN_START_UNIT                | latent_entropy_plugin initify_plugin
/git/arm-soc/drivers/scsi/gdth.c: In function 'gdth_search_drives':
/git/arm-soc/drivers/scsi/gdth.c:1550:12: internal compiler error: in
search_constant_strings, at
git/arm-soc/scripts/gcc-plugins/initify_plugin.c:1375
 static int gdth_search_drives(gdth_ha_str *ha)
            ^~~~~~~~~~~~~~~~~~
0x2b0f7a831b9d search_constant_strings
        /git/arm-soc/scripts/gcc-plugins/initify_plugin.c:1375
0x2b0f7a831950 search_constant_strings
        /git/arm-soc/scripts/gcc-plugins/initify_plugin.c:1335
0x2b0f7a831950 search_constant_strings
        /git/arm-soc/scripts/gcc-plugins/initify_plugin.c:1367
0x2b0f7a832abe search_constant_strings
        /git/arm-soc/scripts/gcc-plugins/initify_plugin.c:1506
0x2b0f7a832abe search_var_param
        /git/arm-soc/scripts/gcc-plugins/initify_plugin.c:1419
0x2b0f7a832abe search_const_strs
        /git/arm-soc/scripts/gcc-plugins/initify_plugin.c:1471
0x2b0f7a832abe initify_function_transform
        /git/arm-soc/scripts/gcc-plugins/initify_plugin.c:1519
0x9b6c07 execute_one_ipa_transform_pass
        /home/arnd/git/gcc/gcc/passes.c:2207
0x9b6c07 execute_all_ipa_transforms()
        /home/arnd/git/gcc/gcc/passes.c:2249
0x734d6c cgraph_node::expand()
        /home/arnd/git/gcc/gcc/cgraphunit.c:2031
0x7362cc expand_all_functions
        /home/arnd/git/gcc/gcc/cgraphunit.c:2174
0x7362cc symbol_table::compile()
        /home/arnd/git/gcc/gcc/cgraphunit.c:2531
0x737d27 symbol_table::compile()
        /home/arnd/git/gcc/gcc/cgraphunit.c:2595
0x737d27 symbol_table::finalize_compilation_unit()
        /home/arnd/git/gcc/gcc/cgraphunit.c:2621
Please submit a full bug report,
with preprocessed source if appropriate.

This is the probably the same bug as the first, and I've worked around
it incorrectly for now:

diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
index d020a13646ae..37c9cf7a4e82 100644
--- a/drivers/scsi/gdth.c
+++ b/drivers/scsi/gdth.c
@@ -3846,6 +3846,8 @@ static const char *gdth_ctr_name(gdth_ha_str *ha)
 {
     TRACE2(("gdth_ctr_name()\n"));

+       return "";
+
     if (ha->type == GDT_EISA) {
         switch (ha->stype) {
           case GDT3_ID:


b)
*** WARNING *** there are active plugins, do not report this as a bug
unless you can reproduce it without enabling any plugins.
Event                            | Plugins
PLUGIN_ATTRIBUTES                | initify_plugin
PLUGIN_START_UNIT                | initify_plugin
/git/arm-soc/arch/x86/kernel/traps.c:1049:1: internal compiler error:
in set_section, at symtab.c:1514
 }
 ^
0x724dd6 symtab_node::set_section(char const*)
/home/arnd/git/gcc/gcc/symtab.c:1514
0x2b26ed538c51 move_function_to_init_exit_text
/git/arm-soc/scripts/gcc-plugins/initify_plugin.c:1751
0x2b26ed538c51 initify_execute
/git/arm-soc/scripts/gcc-plugins/initify_plugin.c:1771
0x2b26ed538c51 execute
/git/arm-soc/scripts/gcc-plugins/gcc-generate-ipa-pass.h:215
Please submit a full bug report,

This one is different from the other two, and I don't know
much about what happened, but this clearly bogus change
avoids the problem:

diff --git a/arch/x86/include/asm/desc.h b/arch/x86/include/asm/desc.h
index d0a21b12dd58..3793900f7f73 100644
--- a/arch/x86/include/asm/desc.h
+++ b/arch/x86/include/asm/desc.h
@@ -508,7 +508,7 @@ static inline void alloc_system_vector(int vector)
  */
 static inline void set_system_intr_gate(unsigned int n, void *addr)
 {
-       BUG_ON((unsigned)n > 0xFF);
+       //BUG_ON((unsigned)n > 0xFF);
        _set_gate(n, GATE_INTERRUPT, addr, 0x3, 0, __KERNEL_CS);
 }


Aside from these problems and the annotations I sent yesterday, the
initify plugin doesn't cause any more build-time regressions for me,
so I'm leaving it enabled.

       Arnd
