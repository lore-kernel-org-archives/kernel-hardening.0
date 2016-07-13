Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 13 Jul 2016 23:26:14 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160713232614.94c653f7eb415d8f969a11c0@gmail.com>
In-Reply-To: <CAGXu5j+99nc9s-ci46s3r_CU5-6O6JeHERcW3mYRtnP71871rw@mail.gmail.com>
References: <20160705013928.396ce4a7cbbc40e6c09efc43@gmail.com>
	<20160705014033.afc9a463b518e2e239c6301b@gmail.com>
	<CAGXu5jLG6bprjCpu2oF6dexsu+8jU-WX59LY-=wUx27U459Y5Q@mail.gmail.com>
	<20160712220853.GU1041@n2100.armlinux.org.uk>
	<CAGXu5j+99nc9s-ci46s3r_CU5-6O6JeHERcW3mYRtnP71871rw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2 1/3] Add the initify gcc plugin
To: Kees Cook <keescook@chromium.org>
Cc: Russell King - ARM Linux <linux@armlinux.org.uk>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Michal Marek <mmarek@suse.com>, LKML <linux-kernel@vger.kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kbuild <linux-kbuild@vger.kernel.org>, minipli@ld-linux.so, Catalin Marinas <catalin.marinas@arm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, David Brown <david.brown@linaro.org>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Jeff Layton <jlayton@poochiereds.net>, Arnd Bergmann <arnd@arndb.de>, Sam Ravnborg <sam@ravnborg.org>, Karsten Keil <isdn@linux-pingi.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 12 Jul 2016 18:38:47 -0400
Kees Cook <keescook@chromium.org> wrote:

> On Tue, Jul 12, 2016 at 6:08 PM, Russell King - ARM Linux
> <linux@armlinux.org.uk> wrote:
> > On Tue, Jul 12, 2016 at 03:45:56PM -0400, Kees Cook wrote:
> >> On Mon, Jul 4, 2016 at 7:40 PM, Emese Revfy <re.emese@gmail.com> wrote:
> > That sounds like a problem for architectures that still discard the
> > __exit section at link time to reduce the size of the linked kernel
> > image - though, obviously, if using the plugin results in a smaller
> > kernel image _with_ the exit sections, then there's a net benefit
> > size-wise.
> 
> Ah right, __exit is dropped for non-modular builds. So, for "both
> __init and __exit" it sounds like the behavior depends on the build:
> 
> - if modular: remove __init marking (since we need it after init)
> - if non-modular: remove __exit marking (since we'll never call exit)

When gcc compiles vmlinux these functions should be in __init and when
it compiles *.ko then they can be in __exit. I have no time to do this
now but I added it to my todo list.

The temporary fix can be that I enable this section move only on x86
(on other archs it will decrase the coverage).

-- 
Emese
