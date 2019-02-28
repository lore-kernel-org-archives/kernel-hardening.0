MIME-Version: 1.0
References: <20190212180441.15340-1-keescook@chromium.org> <20190212180441.15340-2-keescook@chromium.org>
In-Reply-To: <20190212180441.15340-2-keescook@chromium.org>
From: Arnd Bergmann <arnd@arndb.de>
Date: Thu, 28 Feb 2019 21:27:08 +0100
Message-ID: <CAK8P3a2xC3OVckPnweSjor3AH5LpSzichKxAjkAcgXDtCf0QmQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] gcc-plugins: structleak: Generalize to all variable types
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Emese Revfy <re.emese@gmail.com>, Alexander Popov <alex.popov@linux.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Laura Abbott <labbott@redhat.com>, Jann Horn <jannh@google.com>, Alexander Potapenko <glider@google.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 12, 2019 at 7:08 PM Kees Cook <keescook@chromium.org> wrote:
>
> This adjusts structleak to also work with non-struct types when they
> are passed by reference, since those variables may leak just like
> anything else. This is exposed via an improved set of Kconfig options.
> (This does mean structleak is slightly misnamed now.)
>
> Building with CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL should give the
> kernel complete initialization coverage of all stack variables passed
> by reference, including padding (see lib/test_stackinit.c).
>
> Using CONFIG_GCC_PLUGIN_STRUCTLEAK_VERBOSE to count added initializations
> under defconfig:
>
>         ..._BYREF:      5945 added initializations
>         ..._BYREF_ALL: 16606 added initializations
>
> There is virtually no change to text+data size (both have less than 0.05%
> growth):

I just resumed my randconfig build testing after a longer break, and found
a regression for stack usage that I bisected to your change. It shows up in a
variety of files depending on the configuration, so far the worst one is the
configuration at https://pastebin.com/UK54qbKa that leads to

../drivers/media/dvb-frontends/stv090x.c: In function 'stv090x_start_search':
../drivers/media/dvb-frontends/stv090x.c:1595:1: error: the frame size
of 5320 bytes is larger than 2048 bytes [-Werror=frame-larger-than=]
../drivers/media/dvb-frontends/stv090x.c: In function 'stv090x_optimize_track':
../drivers/media/dvb-frontends/stv090x.c:3090:1: error: the frame size
of 5872 bytes is larger than 2048 bytes [-Werror=frame-larger-than=]
../drivers/media/dvb-frontends/stv090x.c: In function 'stv090x_algo':
../drivers/media/dvb-frontends/stv090x.c:3431:1: error: the frame size
of 5144 bytes is larger than 2048 bytes [-Werror=frame-larger-than=]
 }

At least for this specific file, I also see a significant (though not alarming)
increase in code size:

   text       data        bss        dec        hex    filename
179196       4632        256     184084      2cf14
obj-x86/drivers/media/dvb-frontends/stv090x-before.o
 216740       4632        256     221628      361bc
obj-x86/drivers/media/dvb-frontends/stv090x-after.o

Part of the problem here is definitely interaction with the asan-stack
sanitizer. Changing asan-stack=1 to asan-stack=0, it looks a lot
better:

../drivers/media/dvb-frontends/stv090x.c: In function 'stv090x_start_search':
../drivers/media/dvb-frontends/stv090x.c:1595:1: warning: the frame
size of 120 bytes is larger than 20 bytes [-Wframe-larger-than=]
../drivers/media/dvb-frontends/stv090x.c: In function 'stv090x_optimize_track':
../drivers/media/dvb-frontends/stv090x.c:3090:1: warning: the frame
size of 168 bytes is larger than 20 bytes [-Wframe-larger-than=]
../drivers/media/dvb-frontends/stv090x.c: In function 'stv090x_algo':
../drivers/media/dvb-frontends/stv090x.c:3431:1: warning: the frame
size of 192 bytes is larger than 20 bytes [-Wframe-larger-than=]

   text       data        bss        dec        hex    filename
184061       4632        256     188949      2e215
obj-x86/drivers/media/dvb-frontends/stv090x.o

I get similar results with asan-stack=1 but without your plugin, only
the combination of the two has the explosive stack size growth.

I can help analyze this further, but maybe you can have a look first,
there might be something obvious when you read the input to the
plugin.

      Arnd
