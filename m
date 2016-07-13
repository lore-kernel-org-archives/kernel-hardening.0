Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 13 Jul 2016 22:34:08 +0200
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20160713223408.8e52842ddda8818cec83d6a6@gmail.com>
In-Reply-To: <CAGXu5j+W2hZGkudskkmEn+beEN04qmg16-k7Rna-QRT3vyEW2g@mail.gmail.com>
References: <20160705013928.396ce4a7cbbc40e6c09efc43@gmail.com>
	<20160705014033.afc9a463b518e2e239c6301b@gmail.com>
	<CAGXu5jLG6bprjCpu2oF6dexsu+8jU-WX59LY-=wUx27U459Y5Q@mail.gmail.com>
	<20160712220717.297fea731dd53123efd7974f@gmail.com>
	<CAGXu5j+W2hZGkudskkmEn+beEN04qmg16-k7Rna-QRT3vyEW2g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2 1/3] Add the initify gcc plugin
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Michal Marek <mmarek@suse.com>, LKML <linux-kernel@vger.kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kbuild <linux-kbuild@vger.kernel.org>, minipli@ld-linux.so, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, David Brown <david.brown@linaro.org>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Jeff Layton <jlayton@poochiereds.net>, Arnd Bergmann <arnd@arndb.de>, Sam Ravnborg <sam@ravnborg.org>, Karsten Keil <isdn@linux-pingi.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 12 Jul 2016 16:05:45 -0400
Kees Cook <keescook@chromium.org> wrote:

> /*
>  * The initify gcc-plugin attempts to identify const arguments that are only
>  * used during init (see __init), so they can be moved to the .init.rodata
>  * section. If an argument is passed to a non-init function, it must
>  * normally be assumed that such an argument has been captured by that
>  * function and may be used in the future when .init has been unmapped from
>  * memory. In order to identify functions that are confirmed to not capture
>  * their arguments, the __nocapture() attribute is used so that initify can
>  * better identify candidate variables.
>  */
> #ifdef INITIFY_PLUGIN
> # define __nocapture(...) __attribute__((nocapture(__VA_ARGS__)))
> #endif

Thanks, I'll take it in the next patch set with some additions (the attribute
also handles __exit functions and the plugin does other things e.g., it can
identify candidate init/exit functions and move them automatically to init.text/exit.text).

-- 
Emese
