MIME-Version: 1.0
Sender: arndbergmann@gmail.com
In-Reply-To: <589207D5.4002.F3B42D0@pageexec.freemail.hu>
References: <1993222.Sl7urNjWky@wuerfel> <5891FA4B.32537.F0660DA@pageexec.freemail.hu>
 <2760877.KV1ZkH9Fsg@wuerfel> <589207D5.4002.F3B42D0@pageexec.freemail.hu>
From: Arnd Bergmann <arnd@arndb.de>
Date: Wed, 1 Feb 2017 22:39:55 +0100
Message-ID: <CAK8P3a18Vd1ege8U1TC26zHJN6om6PogNSFZyuapg5UJhvmuQQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: initify plugin crashes on arm allmodconfig
To: pageexec@freemail.hu
Cc: Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Josh Triplett <josh@joshtriplett.org>, yamada.masahiro@socionext.com, minipli@ld-linux.so, Russell King - ARM Linux <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, linux@rasmusvillemoes.dk, david.brown@linaro.org, Benjamin Herrenschmidt <benh@kernel.crashing.org>, tglx@linutronix.de, Andrew Morton <akpm@linux-foundation.org>, jlayton@poochiereds.net, sam@ravnborg.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Feb 1, 2017 at 5:07 PM, PaX Team <pageexec@freemail.hu> wrote:
> On 1 Feb 2017 at 16:26, Arnd Bergmann wrote:
>> If you can't reproduce with the version below, I'll dig in further.
>
> no dice, both 5.4 and 6.3 worked fine (save for a few -Wunused-but-set-variable
> warnings).
>

Maybe one more thing to try, I've uploaded my current branch to
git://git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git#randconfig-4.11-next
now, so maybe try this sequence:

arnd@wuerfel:~/git/arm-soc$ git fetch
git://git.kernel.org/pub/scm/linux/kernel/git/arnd/playground.git
randconfig-4.11-next
>From git://git.kernel.org/pub/scm/linux/kernel/git/arnd/playground
 * branch            randconfig-4.11-next -> FETCH_HEAD

arnd@wuerfel:~/git/arm-soc$ git checkout FETCH_HEAD
HEAD is now at fbb1b68... fixup! [SUBMITTED 20170201] [RFC v2] sched:
make DECLARE_COMPLETION_ONSTACK() work with clang

arnd@wuerfel:~/git/arm-soc$ make -skj20 O=obj-arm
CROSS_COMPILE=/home/arnd/cross-gcc/bin/arm-linux-gnueabi- ARCH=arm
allmodconfig

arnd@wuerfel:~/git/arm-soc$ make -skj20 O=obj-arm
CROSS_COMPILE=/home/arnd/cross-gcc/bin/arm-linux-gnueabi- ARCH=arm
drivers/video/fbdev/atmel_lcdfb.o
CC=/home/arnd/cross-gcc/bin/arm-linux-gnueabi-gcc-5.3.1

Interestingly, the first time I run this, I seem to always get into
out-of-memory, while the second run is then an immediate crash.

     Arnd
