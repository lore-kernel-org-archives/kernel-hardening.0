Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 13 Jul 2016 22:48:49 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160713224849.b42c1260b6ebb3ec1f78fa41@gmail.com>
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
> > If a function is called by __init and __exit functions as well then
> > the plugin moves it to the __exit section. This causes false positive
> > section mismatch errors/warnings that I don't know how to handle yet.
> 
> Should the mismatch checker be updated to recognize this case? Without
> the plugin, I assume these kinds of functions would only ever be
> marked for __exit? If so, should the plugin strip the __init marking
> and only add __exit?

I don't modify the existing attributes. I just add a new __init/__exit when
a function hasn't a section attribute yet.
There are three cases:
 * when the function is called only by __init functions then the plugin adds
   the __init attribute
 * when the function is called only by __exit functions then the plugin adds
   the __exit attribute
 * when the function is called by __init and __exit functions too then the
   plugin adds the __exit attribute.
The last case causes the false positive(?) message of the section mismatch.

-- 
Emese
