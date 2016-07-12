Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160705014033.afc9a463b518e2e239c6301b@gmail.com>
References: <20160705013928.396ce4a7cbbc40e6c09efc43@gmail.com> <20160705014033.afc9a463b518e2e239c6301b@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 12 Jul 2016 15:45:56 -0400
Message-ID: <CAGXu5jLG6bprjCpu2oF6dexsu+8jU-WX59LY-=wUx27U459Y5Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2 1/3] Add the initify gcc plugin
To: Emese Revfy <re.emese@gmail.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Michal Marek <mmarek@suse.com>, LKML <linux-kernel@vger.kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kbuild <linux-kbuild@vger.kernel.org>, minipli@ld-linux.so, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, David Brown <david.brown@linaro.org>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Jeff Layton <jlayton@poochiereds.net>, Arnd Bergmann <arnd@arndb.de>, Sam Ravnborg <sam@ravnborg.org>, Karsten Keil <isdn@linux-pingi.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jul 4, 2016 at 7:40 PM, Emese Revfy <re.emese@gmail.com> wrote:
> The kernel already has a mechanism to free up code and data memory that
> is only used during kernel or module initialization.
> This plugin will teach the compiler to find more such code and data that
> can be freed after initialization.
> It has two passes. The first one tries to find all functions that
> can be become __init/__exit. The second one moves string constants
> (local variables and function string arguments marked by
> the nocapture attribute) only referenced in __init/__exit functions
> to the __initconst/__exitconst sections.
> It reduces memory usage. This plugin can be useful for embedded systems.
>
> If a function is called by __init and __exit functions as well then
> the plugin moves it to the __exit section. This causes false positive
> section mismatch errors/warnings that I don't know how to handle yet.

Should the mismatch checker be updated to recognize this case? Without
the plugin, I assume these kinds of functions would only ever be
marked for __exit? If so, should the plugin strip the __init marking
and only add __exit?

> The instrumentation pass of the latent_entropy plugin must run after
> the initify plugin to increase coverage.
>
> Signed-off-by: Emese Revfy <re.emese@gmail.com>

Thanks for sending this! I'll get it added to my tree for some 0day
build testing, and then get it into my -next tree.

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
