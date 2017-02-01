From: "PaX Team" <pageexec@freemail.hu>
Date: Wed, 01 Feb 2017 16:10:03 +0100
MIME-Version: 1.0
Message-ID: <5891FA4B.32537.F0660DA@pageexec.freemail.hu>
In-reply-to: <1993222.Sl7urNjWky@wuerfel>
References: <1993222.Sl7urNjWky@wuerfel>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: [kernel-hardening] Re: initify plugin crashes on arm allmodconfig
To: Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>, yamada.masahiro@socionext.com, minipli@ld-linux.so, linux@armlinux.org.uk, catalin.marinas@arm.com, linux@rasmusvillemoes.dk, david.brown@linaro.org, benh@kernel.crashing.org, tglx@linutronix.de, akpm@linux-foundation.org, jlayton@poochiereds.net, sam@ravnborg.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 1 Feb 2017 at 14:52, Arnd Bergmann wrote:

> On my ARM test builds (using a recent gcc-7 snapshot), allmodconfig failed with a compiler
> crash, I have managed to minimize the test case to this:
> 
> /home/arnd/cross-gcc/bin/arm-linux-gnueabi-gcc-7.0.1 -O2 -Wall -fplugin=/home/arnd/arm-soc/build/tmp/scripts/gcc-plugins/initify_plugin.so -DINITIFY_PLUGIN
> -fplugin-arg-initify_plugin-search_init_exit_functions  -fno-inline-functions-called-once -S atmel_lcdfb.i arm-linux-gnueabi-gcc-7.0.1: internal compiler error: Segmentation fault (program cc1)
> 
[...]
> 
> While trying to reproduce it, one time I ended up killing the gcc task when it
> used more than 80 gigabytes (!) of memory after around six minutes of compiling
> the same file (drivers/video/fbdev/atmel_lcdfb.c), but other times it just crashed
> as above using various ARM cross compilers (4.9.3, 5.3, 6.1.1).

i tried to reproduce it with 5.4 and 6.3 to no avail (arm64->arm cross compiler)
so some more information will be needed. first, which plugin version did you try?
second, if you build your own gcc, can you configure one with this additional
option:

  --enable-checking=assert,df,gimple,misc,rtl,rtlflag,runtime,tree,types

this will enable lots of compile time self-checking in gcc and may pinpoint the
problem sooner (it also increases compile time so you probably want to keep this
gcc as a separate build from your main one).
