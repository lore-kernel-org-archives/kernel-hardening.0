MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1a252726-5b0f-1cd9-708e-71844df82386@au1.ibm.com>
References: <1485894263-91051-1-git-send-email-keescook@chromium.org>
 <1485894263-91051-2-git-send-email-keescook@chromium.org> <851a0c99-db08-c3a8-f5c6-2e567971e2eb@au1.ibm.com>
 <1a252726-5b0f-1cd9-708e-71844df82386@au1.ibm.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 28 Mar 2017 12:00:12 -0700
Message-ID: <CAGXu5j+2UQ43MdaaEhFfgEPUdJZGeEMB+BaMzwTVjOfLPFEbLQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [PATCH v5 1/4] gcc-plugins: Add the initify
 gcc plugin
To: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Emese Revfy <re.emese@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Josh Triplett <josh@joshtriplett.org>, PaX Team <pageexec@freemail.hu>, Masahiro Yamada <yamada.masahiro@socionext.com>, minipli@ld-linux.so, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, David Brown <david.brown@linaro.org>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Jeff Layton <jlayton@poochiereds.net>, Sam Ravnborg <sam@ravnborg.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Michael Ellerman <mpe@ellerman.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Mar 27, 2017 at 8:03 PM, Andrew Donnellan
<andrew.donnellan@au1.ibm.com> wrote:
> On 27/03/17 18:38, Andrew Donnellan wrote:
>>
>> On 01/02/17 07:24, Kees Cook wrote:
>>>
>>> From: Emese Revfy <re.emese@gmail.com>
>>>
>>> The kernel already has a mechanism to free up code and data memory that
>>> is only used during kernel or module initialization.  This plugin will
>>> teach the compiler to find more such code and data that can be freed
>>> after initialization.
>>
>>
>> Currently checking whether we can wire this up for powerpc without too
>> many problems...
>
>
> Added "select HAVE_GCC_PLUGIN_INITIFY_INIT_EXIT if GCC_PLUGINS" to
> arch/powerpc/Kconfig and have successfully compiled and booted a modular and
> non-modular powernv_defconfig, it looks like we handle the .exit sections
> correctly.
>
> Could this be folded in for further testing when you get around to v6, Kees?

Awesome, thanks for testing! I'll get it queued for a v6...

-Kees

-- 
Kees Cook
Pixel Security
