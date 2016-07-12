Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 12 Jul 2016 22:07:17 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160712220717.297fea731dd53123efd7974f@gmail.com>
In-Reply-To: <CAGXu5jLG6bprjCpu2oF6dexsu+8jU-WX59LY-=wUx27U459Y5Q@mail.gmail.com>
References: <20160705013928.396ce4a7cbbc40e6c09efc43@gmail.com>
	<20160705014033.afc9a463b518e2e239c6301b@gmail.com>
	<CAGXu5jLG6bprjCpu2oF6dexsu+8jU-WX59LY-=wUx27U459Y5Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2 1/3] Add the initify gcc plugin
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Michal Marek <mmarek@suse.com>, LKML <linux-kernel@vger.kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kbuild <linux-kbuild@vger.kernel.org>, minipli@ld-linux.so, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, David Brown <david.brown@linaro.org>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Jeff Layton <jlayton@poochiereds.net>, Arnd Bergmann <arnd@arndb.de>, Sam Ravnborg <sam@ravnborg.org>, Karsten Keil <isdn@linux-pingi.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 12 Jul 2016 15:45:56 -0400
Kees Cook <keescook@chromium.org> wrote:

> On Mon, Jul 4, 2016 at 7:40 PM, Emese Revfy <re.emese@gmail.com> wrote:
> Thanks for sending this! I'll get it added to my tree for some 0day
> build testing, and then get it into my -next tree.

I'll send a new patch set soon. I'm working on some fixes and
I would like to implement the handling of return uses to increase the coverage
(which decreases because of the bug fixes :) ).
So please hold off with testing until the next patch.

-- 
Emese
