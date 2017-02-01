From: "PaX Team" <pageexec@freemail.hu>
Date: Wed, 01 Feb 2017 17:07:49 +0100
MIME-Version: 1.0
Message-ID: <589207D5.4002.F3B42D0@pageexec.freemail.hu>
In-reply-to: <2760877.KV1ZkH9Fsg@wuerfel>
References: <1993222.Sl7urNjWky@wuerfel>, <5891FA4B.32537.F0660DA@pageexec.freemail.hu>, <2760877.KV1ZkH9Fsg@wuerfel>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: [kernel-hardening] Re: initify plugin crashes on arm allmodconfig
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>, linux-kernel@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>, yamada.masahiro@socionext.com, minipli@ld-linux.so, linux@armlinux.org.uk, catalin.marinas@arm.com, linux@rasmusvillemoes.dk, david.brown@linaro.org, benh@kernel.crashing.org, tglx@linutronix.de, akpm@linux-foundation.org, jlayton@poochiereds.net, sam@ravnborg.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 1 Feb 2017 at 16:26, Arnd Bergmann wrote:
> arm-linux-gnueabi-gcc-4.9.3: internal compiler error: Segmentation fault (program cc1)
> 0x40c0c6 execute
>  /home/arnd/git/gcc/gcc/gcc.c:2854
> 0x40c464 do_spec_1
>  /home/arnd/git/gcc/gcc/gcc.c:4658
> 0x40edc0 process_brace_body
>  /home/arnd/git/gcc/gcc/gcc.c:5941
> 0x40edc0 handle_braces
>  /home/arnd/git/gcc/gcc/gcc.c:5855
> 0x40d16e do_spec_1

considering the repeating pattern, it may be some infinite recursion, perhaps
run with -dH and look at the backtrace in the coredump. also this code seems to
be the language frontend (the specfile parser in particular) that the initify
plugin doesn't affect, perhaps you have some changes there?

> If you can't reproduce with the version below, I'll dig in further.

no dice, both 5.4 and 6.3 worked fine (save for a few -Wunused-but-set-variable
warnings).
