Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170111012459.c0a0c615c99a389e4d89c8b5@gmail.com>
References: <1481925984-98605-1-git-send-email-keescook@chromium.org>
 <CAGXu5jKfwBqEot+30z6Wh6Cow2gv25ojKxmoTS1Vb_LhwFiSnA@mail.gmail.com>
 <20161219121046.646e5ef425178fce8c2cb555@gmail.com> <CAGXu5jKiDUsncxEOCta3fEgh0OQ0oqpi3gzkPWvpu2oPLq2g4g@mail.gmail.com>
 <20170111012459.c0a0c615c99a389e4d89c8b5@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 10 Jan 2017 17:09:31 -0800
Message-ID: <CAGXu5jJRNuLR+Ekt26fxkg5wCkEv5fv-4B7=rt78OfRHN_w1Jw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v4 0/4] Introduce the initify gcc plugin
To: Emese Revfy <re.emese@gmail.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Josh Triplett <josh@joshtriplett.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Michal Marek <mmarek@suse.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kbuild <linux-kbuild@vger.kernel.org>, minipli@ld-linux.so, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, David Brown <david.brown@linaro.org>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Jeff Layton <jlayton@poochiereds.net>, Sam Ravnborg <sam@ravnborg.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jan 10, 2017 at 4:24 PM, Emese Revfy <re.emese@gmail.com> wrote:
> On Tue, 3 Jan 2017 16:23:03 -0800
> Kees Cook <keescook@chromium.org> wrote:
>
>> On Mon, Dec 19, 2016 at 3:10 AM, Emese Revfy <re.emese@gmail.com> wrote:
>> > On Fri, 16 Dec 2016 14:19:10 -0800
>> > Kees Cook <keescook@chromium.org> wrote:
>> >
>> >> FWIW, it still seems to me that these aren't false positives:
>> >>
>> >> WARNING: vmlinux.o(.text.unlikely+0x1b1): Section mismatch in
>> >> reference from the function uncore_pci_exit.part.22() to the function
>> >> .init.text:uncore_free_pcibus_map()
>> >> The function uncore_pci_exit.part.22() references
>> >> the function __init uncore_free_pcibus_map().
>> >> This is often because uncore_pci_exit.part.22 lacks a __init
>> >> annotation or the annotation of uncore_free_pcibus_map is wrong.
>
> Thanks for the report, you can find the fix here:
> https://github.com/ephox-gcc-plugins/initify/commit/5d93a54badd9751b79ef67ce8a8b4081fea37547

Awesome! Thanks, that eliminated almost all of the warnings. I'm still
seeing this:

WARNING: vmlinux.o(.text+0x1087e7): Section mismatch in reference from
the function rebind_subsystems() to the variable
.init.rodata.str:__func__.4400
The function rebind_subsystems() references
the variable __initconst __func__.4400.
This is often because rebind_subsystems lacks a __initconst
annotation or the annotation of __func__.4400 is wrong.

WARNING: vmlinux.o(.text+0x13789d): Section mismatch in reference from
the function register_ftrace_export() to the variable
.init.rodata.str:__func__.4251
The function register_ftrace_export() references
the variable __initconst __func__.4251.
This is often because register_ftrace_export lacks a __initconst
annotation or the annotation of __func__.4251 is wrong.

WARNING: vmlinux.o(.text+0x139d24): Section mismatch in reference from
the function tracepoint_printk_sysctl() to the variable
.init.rodata.str:__func__.4251
The function tracepoint_printk_sysctl() references
the variable __initconst __func__.4251.
This is often because tracepoint_printk_sysctl lacks a __initconst
annotation or the annotation of __func__.4251 is wrong.

I haven't taken a close look yet, but I assume these are from the
const strings in these functions?

-Kees

-- 
Kees Cook
Nexus Security
