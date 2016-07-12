Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160712220717.297fea731dd53123efd7974f@gmail.com>
References: <20160705013928.396ce4a7cbbc40e6c09efc43@gmail.com>
 <20160705014033.afc9a463b518e2e239c6301b@gmail.com> <CAGXu5jLG6bprjCpu2oF6dexsu+8jU-WX59LY-=wUx27U459Y5Q@mail.gmail.com>
 <20160712220717.297fea731dd53123efd7974f@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 12 Jul 2016 16:05:45 -0400
Message-ID: <CAGXu5j+W2hZGkudskkmEn+beEN04qmg16-k7Rna-QRT3vyEW2g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2 1/3] Add the initify gcc plugin
To: Emese Revfy <re.emese@gmail.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Michal Marek <mmarek@suse.com>, LKML <linux-kernel@vger.kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kbuild <linux-kbuild@vger.kernel.org>, minipli@ld-linux.so, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, David Brown <david.brown@linaro.org>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Jeff Layton <jlayton@poochiereds.net>, Arnd Bergmann <arnd@arndb.de>, Sam Ravnborg <sam@ravnborg.org>, Karsten Keil <isdn@linux-pingi.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jul 12, 2016 at 4:07 PM, Emese Revfy <re.emese@gmail.com> wrote:
> On Tue, 12 Jul 2016 15:45:56 -0400
> Kees Cook <keescook@chromium.org> wrote:
>
>> On Mon, Jul 4, 2016 at 7:40 PM, Emese Revfy <re.emese@gmail.com> wrote:
>> Thanks for sending this! I'll get it added to my tree for some 0day
>> build testing, and then get it into my -next tree.
>
> I'll send a new patch set soon. I'm working on some fixes and
> I would like to implement the handling of return uses to increase the coverage
> (which decreases because of the bug fixes :) ).
> So please hold off with testing until the next patch.

Okay, cool. I'll just do some simple tests with what I have so I can
feel like I understand its intended use, etc. :)

One change I made was to add this comment in compiler-gcc.h for people
that become curious about __nocapture and go looking for its
definition (please feel free to adjust for accuracy, etc):


/*
 * The initify gcc-plugin attempts to identify const arguments that are only
 * used during init (see __init), so they can be moved to the .init.rodata
 * section. If an argument is passed to a non-init function, it must
 * normally be assumed that such an argument has been captured by that
 * function and may be used in the future when .init has been unmapped from
 * memory. In order to identify functions that are confirmed to not capture
 * their arguments, the __nocapture() attribute is used so that initify can
 * better identify candidate variables.
 */
#ifdef INITIFY_PLUGIN
# define __nocapture(...) __attribute__((nocapture(__VA_ARGS__)))
#endif


-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
