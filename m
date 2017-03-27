MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <851a0c99-db08-c3a8-f5c6-2e567971e2eb@au1.ibm.com>
References: <1485894263-91051-1-git-send-email-keescook@chromium.org>
 <1485894263-91051-2-git-send-email-keescook@chromium.org> <851a0c99-db08-c3a8-f5c6-2e567971e2eb@au1.ibm.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 27 Mar 2017 09:14:36 -0700
Message-ID: <CAGXu5j+cd8iXAVko_fOFkPLD2Q=1=S0jvCYGAhKjnTunJ=86Zg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] [PATCH v5 1/4] gcc-plugins: Add the initify
 gcc plugin
To: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Emese Revfy <re.emese@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Josh Triplett <josh@joshtriplett.org>, PaX Team <pageexec@freemail.hu>, Masahiro Yamada <yamada.masahiro@socionext.com>, minipli@ld-linux.so, Russell King <linux@armlinux.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, David Brown <david.brown@linaro.org>, "benh@kernel.crashing.org" <benh@kernel.crashing.org>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Jeff Layton <jlayton@poochiereds.net>, Sam Ravnborg <sam@ravnborg.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Mar 27, 2017 at 12:38 AM, Andrew Donnellan
<andrew.donnellan@au1.ibm.com> wrote:
> On 01/02/17 07:24, Kees Cook wrote:
>>
>> From: Emese Revfy <re.emese@gmail.com>
>>
>> The kernel already has a mechanism to free up code and data memory that
>> is only used during kernel or module initialization.  This plugin will
>> teach the compiler to find more such code and data that can be freed
>> after initialization.
>
>
> Currently checking whether we can wire this up for powerpc without too many
> problems...

Cool, thanks. FWIW, note that this plugin is a bit back-burnered at
the moment. I've got this in my -next tree still, but it needs some
rather large changes to how it does its annotations before Linus will
accept it.

>> diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
>> index 34a74131a12c..b98b8fdb7aaf 100644
>> --- a/arch/x86/lib/Makefile
>> +++ b/arch/x86/lib/Makefile
>> @@ -29,6 +29,10 @@ lib-$(CONFIG_RANDOMIZE_BASE) += kaslr.o
>>  obj-y += msr.o msr-reg.o msr-reg-export.o hweight.o
>>
>>  ifeq ($(CONFIG_X86_32),y)
>> +        CFLAGS_strstr_32.o +=
>> $(INITIFY_DISABLE_VERIFIY_NOCAPTURE_FUNCTIONS)
>> +        CFLAGS_string_32.o +=
>> $(INITIFY_DISABLE_VERIFIY_NOCAPTURE_FUNCTIONS)
>> +        CFLAGS_memcpy_32.o +=
>> $(INITIFY_DISABLE_VERIFIY_NOCAPTURE_FUNCTIONS)
>
>
> s/VERIFIY/VERIFY/g here + Makefile.gcc-plugins?

Ah, thanks for catching that! I'll get that fixed.

-Kees

-- 
Kees Cook
Pixel Security
