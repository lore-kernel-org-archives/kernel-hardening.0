MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170215012319.c7720609f415b2abf725e88f@gmail.com>
References: <1481925984-98605-1-git-send-email-keescook@chromium.org>
 <CAGXu5jKfwBqEot+30z6Wh6Cow2gv25ojKxmoTS1Vb_LhwFiSnA@mail.gmail.com>
 <20161219121046.646e5ef425178fce8c2cb555@gmail.com> <CAGXu5jKiDUsncxEOCta3fEgh0OQ0oqpi3gzkPWvpu2oPLq2g4g@mail.gmail.com>
 <20170111012459.c0a0c615c99a389e4d89c8b5@gmail.com> <CAGXu5jJRNuLR+Ekt26fxkg5wCkEv5fv-4B7=rt78OfRHN_w1Jw@mail.gmail.com>
 <20170112224116.680debbf6f5c288ba51a46c0@gmail.com> <CAGXu5jLB_ZxPcJDsBK0h-HTfb8G-GdC+BnD-1rTL5ePUvcwuzA@mail.gmail.com>
 <CAGXu5jJ_9Gbre2J1HYrY-gwnsStL8P+MKmKQwCBtY4-7m53RLA@mail.gmail.com> <20170215012319.c7720609f415b2abf725e88f@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 15 Feb 2017 11:27:06 -0800
Message-ID: <CAGXu5jKWGANHjA5opm4V9AzCVA27_iZqmypPvBLfzJ0MKNZDvg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v4 0/4] Introduce the initify gcc plugin
To: Emese Revfy <re.emese@gmail.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Josh Triplett <josh@joshtriplett.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Michal Marek <mmarek@suse.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kbuild <linux-kbuild@vger.kernel.org>, minipli@ld-linux.so, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, David Brown <david.brown@linaro.org>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Jeff Layton <jlayton@poochiereds.net>, Sam Ravnborg <sam@ravnborg.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 14, 2017 at 4:23 PM, Emese Revfy <re.emese@gmail.com> wrote:
> On Thu, 12 Jan 2017 15:40:41 -0800
> Kees Cook <keescook@chromium.org> wrote:
>
>> WARNING: drivers/clk/bcm/built-in.o(.text+0xec2): Section mismatch in
>> reference from the function clk_gate() to the variable
>> .init.rodata.str:__func__.29708
>> The function clk_gate() references
>> the variable __initconst __func__.29708.
>> This is often because clk_gate lacks a __initconst
>> annotation or the annotation of __func__.29708 is wrong.
>
> Thanks for the report, it will be fixed in the next grsec patch.

Very cool, thanks! What did the problem turn out to be?

-Kees

-- 
Kees Cook
Pixel Security
