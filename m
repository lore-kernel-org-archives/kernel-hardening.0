Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAGXu5jLB_ZxPcJDsBK0h-HTfb8G-GdC+BnD-1rTL5ePUvcwuzA@mail.gmail.com>
References: <1481925984-98605-1-git-send-email-keescook@chromium.org>
 <CAGXu5jKfwBqEot+30z6Wh6Cow2gv25ojKxmoTS1Vb_LhwFiSnA@mail.gmail.com>
 <20161219121046.646e5ef425178fce8c2cb555@gmail.com> <CAGXu5jKiDUsncxEOCta3fEgh0OQ0oqpi3gzkPWvpu2oPLq2g4g@mail.gmail.com>
 <20170111012459.c0a0c615c99a389e4d89c8b5@gmail.com> <CAGXu5jJRNuLR+Ekt26fxkg5wCkEv5fv-4B7=rt78OfRHN_w1Jw@mail.gmail.com>
 <20170112224116.680debbf6f5c288ba51a46c0@gmail.com> <CAGXu5jLB_ZxPcJDsBK0h-HTfb8G-GdC+BnD-1rTL5ePUvcwuzA@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 12 Jan 2017 15:40:41 -0800
Message-ID: <CAGXu5jJ_9Gbre2J1HYrY-gwnsStL8P+MKmKQwCBtY4-7m53RLA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH v4 0/4] Introduce the initify gcc plugin
To: Emese Revfy <re.emese@gmail.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>, Josh Triplett <josh@joshtriplett.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Michal Marek <mmarek@suse.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, linux-kbuild <linux-kbuild@vger.kernel.org>, minipli@ld-linux.so, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, David Brown <david.brown@linaro.org>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Jeff Layton <jlayton@poochiereds.net>, Sam Ravnborg <sam@ravnborg.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 12, 2017 at 3:27 PM, Kees Cook <keescook@chromium.org> wrote:
> On Thu, Jan 12, 2017 at 1:41 PM, Emese Revfy <re.emese@gmail.com> wrote:
>> On Tue, 10 Jan 2017 17:09:31 -0800
>> Kees Cook <keescook@chromium.org> wrote:
>>
>>> WARNING: vmlinux.o(.text+0x1087e7): Section mismatch in reference from
>>> the function rebind_subsystems() to the variable
>>> .init.rodata.str:__func__.4400
>>> The function rebind_subsystems() references
>>> the variable __initconst __func__.4400.
>>> This is often because rebind_subsystems lacks a __initconst
>>> annotation or the annotation of __func__.4400 is wrong.
>>
>> Thanks for the report, you can find the fix here:
>> https://github.com/ephox-gcc-plugins/initify/commit/25f34834e3373e067133=
bc5d39d42c50a3592d56
>
> Awesome! I can confirm, it builds without warnings now. Thanks!

Hm, actually, with an "allyesconfig" build, I'm still seeing warnings
(and possibly some nocapture verification failures).

Most look like this:

WARNING: drivers/clk/bcm/built-in.o(.text+0xec2): Section mismatch in
reference from the function clk_gate() to the variable
.init.rodata.str:__func__.29708
The function clk_gate() references
the variable __initconst __func__.29708.
This is often because clk_gate lacks a __initconst
annotation or the annotation of __func__.29708 is wrong.

And there's this (should KASAN be disabled for initify?)

mm/kasan/kasan.c: In function =E2=80=98memmove=E2=80=99:
mm/kasan/kasan.c:346:7: warning: =E2=80=98memmove=E2=80=99 captures its 2 (=
=E2=80=98src=E2=80=99)
parameter, please remove it from the nocapture attribute.
 void *memmove(void *dest, const void *src, size_t len)
       ^
mm/kasan/kasan.c: In function =E2=80=98memcpy=E2=80=99:
mm/kasan/kasan.c:355:7: warning: =E2=80=98memcpy=E2=80=99 captures its 2 (=
=E2=80=98src=E2=80=99)
parameter, please remove it from the nocapture attribute.
 void *memcpy(void *dest, const void *src, size_t len)
       ^

And ACPI:

drivers/acpi/acpica/utdebug.c: In function =E2=80=98acpi_debug_print=E2=80=
=99:
drivers/acpi/acpica/utdebug.c:158:1: warning: =E2=80=98acpi_debug_print=E2=
=80=99
captures its 3 (=E2=80=98function_name=E2=80=99) parameter, please remove i=
t from the
nocapture attribute.
 acpi_debug_print(u32 requested_debug_level,
 ^


I used my initify v5 development tree, with the following patch, with
"make allyesconfig":

http://git.kernel.org/cgit/linux/kernel/git/kees/linux.git/log/?h=3Dfor-nex=
t/gcc-plugin/initify

diff --git a/arch/Kconfig b/arch/Kconfig
index b6009a21ebea..5693ef5f22c8 100644
--- a/arch/Kconfig
+++ b/arch/Kconfig
@@ -359,7 +359,6 @@ config HAVE_GCC_PLUGINS
 menuconfig GCC_PLUGINS
        bool "GCC plugins"
        depends on HAVE_GCC_PLUGINS
-       depends on !COMPILE_TEST
        help
          GCC plugins are loadable modules that provide extra features to t=
he
          compiler. They are useful for runtime instrumentation and
static analysis.
@@ -429,6 +428,7 @@ config GCC_PLUGIN_INITIFY
 config GCC_PLUGIN_INITIFY_VERBOSE
        bool "Report initification"
        depends on GCC_PLUGIN_INITIFY
+       depends on !COMPILE_TEST
        help
          Print all initified strings and all functions which should be
          __init/__exit.


I'll see if acpi needs __noverified_nocapture ...

-Kees

--=20
Kees Cook
Nexus Security
