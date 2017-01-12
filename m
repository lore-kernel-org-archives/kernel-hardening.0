Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170112224116.680debbf6f5c288ba51a46c0@gmail.com>
References: <1481925984-98605-1-git-send-email-keescook@chromium.org>
 <CAGXu5jKfwBqEot+30z6Wh6Cow2gv25ojKxmoTS1Vb_LhwFiSnA@mail.gmail.com>
 <20161219121046.646e5ef425178fce8c2cb555@gmail.com> <CAGXu5jKiDUsncxEOCta3fEgh0OQ0oqpi3gzkPWvpu2oPLq2g4g@mail.gmail.com>
 <20170111012459.c0a0c615c99a389e4d89c8b5@gmail.com> <CAGXu5jJRNuLR+Ekt26fxkg5wCkEv5fv-4B7=rt78OfRHN_w1Jw@mail.gmail.com>
 <20170112224116.680debbf6f5c288ba51a46c0@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 12 Jan 2017 15:27:22 -0800
Message-ID: <CAGXu5jLB_ZxPcJDsBK0h-HTfb8G-GdC+BnD-1rTL5ePUvcwuzA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v4 0/4] Introduce the initify gcc plugin
To: Emese Revfy <re.emese@gmail.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Josh Triplett <josh@joshtriplett.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Michal Marek <mmarek@suse.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kbuild <linux-kbuild@vger.kernel.org>, minipli@ld-linux.so, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, David Brown <david.brown@linaro.org>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Jeff Layton <jlayton@poochiereds.net>, Sam Ravnborg <sam@ravnborg.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 12, 2017 at 1:41 PM, Emese Revfy <re.emese@gmail.com> wrote:
> On Tue, 10 Jan 2017 17:09:31 -0800
> Kees Cook <keescook@chromium.org> wrote:
>
>> WARNING: vmlinux.o(.text+0x1087e7): Section mismatch in reference from
>> the function rebind_subsystems() to the variable
>> .init.rodata.str:__func__.4400
>> The function rebind_subsystems() references
>> the variable __initconst __func__.4400.
>> This is often because rebind_subsystems lacks a __initconst
>> annotation or the annotation of __func__.4400 is wrong.
>
> Thanks for the report, you can find the fix here:
> https://github.com/ephox-gcc-plugins/initify/commit/25f34834e3373e067133bc5d39d42c50a3592d56

Awesome! I can confirm, it builds without warnings now. Thanks!

-Kees

-- 
Kees Cook
Nexus Security
