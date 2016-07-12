Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160712220853.GU1041@n2100.armlinux.org.uk>
References: <20160705013928.396ce4a7cbbc40e6c09efc43@gmail.com>
 <20160705014033.afc9a463b518e2e239c6301b@gmail.com> <CAGXu5jLG6bprjCpu2oF6dexsu+8jU-WX59LY-=wUx27U459Y5Q@mail.gmail.com>
 <20160712220853.GU1041@n2100.armlinux.org.uk>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 12 Jul 2016 18:38:47 -0400
Message-ID: <CAGXu5j+99nc9s-ci46s3r_CU5-6O6JeHERcW3mYRtnP71871rw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2 1/3] Add the initify gcc plugin
To: Russell King - ARM Linux <linux@armlinux.org.uk>
Cc: Emese Revfy <re.emese@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Michal Marek <mmarek@suse.com>, LKML <linux-kernel@vger.kernel.org>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kbuild <linux-kbuild@vger.kernel.org>, minipli@ld-linux.so, Catalin Marinas <catalin.marinas@arm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, David Brown <david.brown@linaro.org>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Jeff Layton <jlayton@poochiereds.net>, Arnd Bergmann <arnd@arndb.de>, Sam Ravnborg <sam@ravnborg.org>, Karsten Keil <isdn@linux-pingi.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jul 12, 2016 at 6:08 PM, Russell King - ARM Linux
<linux@armlinux.org.uk> wrote:
> On Tue, Jul 12, 2016 at 03:45:56PM -0400, Kees Cook wrote:
>> On Mon, Jul 4, 2016 at 7:40 PM, Emese Revfy <re.emese@gmail.com> wrote:
>> > If a function is called by __init and __exit functions as well then
>> > the plugin moves it to the __exit section. This causes false positive
>> > section mismatch errors/warnings that I don't know how to handle yet.
>>
>> Should the mismatch checker be updated to recognize this case? Without
>> the plugin, I assume these kinds of functions would only ever be
>> marked for __exit? If so, should the plugin strip the __init marking
>> and only add __exit?
>
> That sounds like a problem for architectures that still discard the
> __exit section at link time to reduce the size of the linked kernel
> image - though, obviously, if using the plugin results in a smaller
> kernel image _with_ the exit sections, then there's a net benefit
> size-wise.

Ah right, __exit is dropped for non-modular builds. So, for "both
__init and __exit" it sounds like the behavior depends on the build:

- if modular: remove __init marking (since we need it after init)
- if non-modular: remove __exit marking (since we'll never call exit)

Is this something the build itself (rather than the plugin) could
notice and fix up? Hmmm

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
