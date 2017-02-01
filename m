MIME-Version: 1.0
Sender: arndbergmann@gmail.com
In-Reply-To: <CAK8P3a18Vd1ege8U1TC26zHJN6om6PogNSFZyuapg5UJhvmuQQ@mail.gmail.com>
References: <1993222.Sl7urNjWky@wuerfel> <5891FA4B.32537.F0660DA@pageexec.freemail.hu>
 <2760877.KV1ZkH9Fsg@wuerfel> <589207D5.4002.F3B42D0@pageexec.freemail.hu> <CAK8P3a18Vd1ege8U1TC26zHJN6om6PogNSFZyuapg5UJhvmuQQ@mail.gmail.com>
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 1 Feb 2017 22:47:57 +0100
Message-ID: <CAK8P3a0CX4Aqv16dOAqw1YiY0exBGuxshiejGmXwSvPzgKzxww@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: initify plugin crashes on arm allmodconfig
To: pageexec@freemail.hu
Cc: Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Josh Triplett <josh@joshtriplett.org>, yamada.masahiro@socionext.com, minipli@ld-linux.so, Russell King - ARM Linux <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, linux@rasmusvillemoes.dk, david.brown@linaro.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, tglx@linutronix.de, Andrew Morton <akpm@linux-foundation.org>, jlayton@poochiereds.net, sam@ravnborg.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

I ran into three more problems now that I haven't analysed yet:


1. I suspect this one is from a string that got deduplicated but is
used from both __init and non-__init functions now. Same tree,
randconfig output at http://pastebin.com/dl/XA3fXTtp

==> build/x86/0x27D13D98_defconfig/log <==
WARNING: drivers/clk/built-in.o(.text+0x9324): Section mismatch in
reference from the function clk_gate() to the variable
.init.rodata.str:__func__.27925
The function clk_gate() references
the variable __initconst __func__.27925.
This is often because clk_gate lacks a __initconst
annotation or the annotation of __func__.27925 is wrong.

WARNING: drivers/clk/built-in.o(.text+0x9365): Section mismatch in
reference from the function clk_gate() to the variable
.init.rodata.str:__func__.27929
The function clk_gate() references
the variable __initconst __func__.27929.
This is often because clk_gate lacks a __initconst
annotation or the annotation of __func__.27929 is wrong.

WARNING: drivers/clk/built-in.o(.text+0x95d6): Section mismatch in
reference from the function kona_peri_clk_set_parent() to the variable
.init.rodata.str:__func__.27925
The function kona_peri_clk_set_parent() references
the variable __initconst __func__.27925.
This is often because kona_peri_clk_set_parent lacks a __initconst
annotation or the annotation of __func__.27925 is wrong.

WARNING: drivers/clk/built-in.o(.text+0x961d): Section mismatch in
reference from the function kona_peri_clk_set_parent() to the variable
.init.rodata.str:__func__.27929
The function kona_peri_clk_set_parent() references
the variable __initconst __func__.27929.
This is often because kona_peri_clk_set_parent lacks a __initconst
annotation or the annotation of __func__.27929 is wrong.

2. futher incorrect nocapture annotations, same tree, randconfig file
at http://pastebin.com/dl/xZrAHAfU
/git/arm-soc/mm/util.c: In function 'kstrdup':
/git/arm-soc/mm/util.c:44:7: error: 'kstrdup' captures its 1 ('s')
parameter, please remove it from the nocapture attribute. [-Werror]
 char *kstrdup(const char *s, gfp_t gfp)
       ^~~~~~~
/git/arm-soc/mm/util.c: In function 'kmemdup':
/git/arm-soc/mm/util.c:109:7: error: 'kmemdup' captures its 1 ('src')
parameter, please remove it from the nocapture attribute. [-Werror]
 void *kmemdup(const void *src, size_t len, gfp_t gfp)
       ^~~~~~~
/git/arm-soc/mm/util.c: In function 'kstrndup':
/git/arm-soc/mm/util.c:84:7: error: 'kstrndup' captures its 1 ('s')
parameter, please remove it from the nocapture attribute. [-Werror]
 char *kstrndup(const char *s, size_t max, gfp_t gfp)
       ^~~~~~~~
/git/arm-soc/lib/string.c: In function 'strlcpy':
/git/arm-soc/lib/string.c:139:8: error: 'strlcpy' captures its 2
('src') parameter, please remove it from the nocapture attribute.
[-Werror]
 size_t strlcpy(char *dest, const char *src, size_t size)
        ^~~~~~~
/git/arm-soc/lib/string.c: In function 'strlcat':
/git/arm-soc/lib/string.c:294:8: error: 'strlcat' captures its 2
('src') parameter, please remove it from the nocapture attribute.
[-Werror]
 size_t strlcat(char *dest, const char *src, size_t count)
        ^~~~~~~
cc1: all warnings being treated as errors
/git/arm-soc/scripts/Makefile.build:307: recipe for target 'lib/string.o' failed
make[3]: *** [lib/string.o] Error 1
/git/arm-soc/lib/vsprintf.c: In function 'bstr_printf':
/git/arm-soc/lib/vsprintf.c:2406:5: error: 'bstr_printf' captures its
3 ('fmt') parameter, please remove it from the nocapture attribute.
[-Werror]
 int bstr_printf(char *buf, size_t size, const char *fmt, const u32 *bin_buf)
     ^~~~~~~~~~~
cc1: all warnings being treated as errors

3. some configurations seem to take very long to build, over 10
minutes instead of the usual 3. Haven't done any concrete measurements
yet to confirm that it's the initify plugin causing this.

I'll turn off the plugin for my build testing now.

     Arnd
