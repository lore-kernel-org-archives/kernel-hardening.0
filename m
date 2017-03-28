References: <1485894263-91051-1-git-send-email-keescook@chromium.org>
 <1485894263-91051-2-git-send-email-keescook@chromium.org>
 <851a0c99-db08-c3a8-f5c6-2e567971e2eb@au1.ibm.com>
From: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Date: Tue, 28 Mar 2017 14:03:24 +1100
MIME-Version: 1.0
In-Reply-To: <851a0c99-db08-c3a8-f5c6-2e567971e2eb@au1.ibm.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Message-Id: <1a252726-5b0f-1cd9-708e-71844df82386@au1.ibm.com>
Subject: Re: [kernel-hardening] [PATCH v5 1/4] gcc-plugins: Add the initify
 gcc plugin
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Josh Triplett <josh@joshtriplett.org>, pageexec@freemail.hu, yamada.masahiro@socionext.com, minipli@ld-linux.so, linux@armlinux.org.uk, catalin.marinas@arm.com, linux@rasmusvillemoes.dk, david.brown@linaro.org, benh@kernel.crashing.org, tglx@linutronix.de, akpm@linux-foundation.org, jlayton@poochiereds.net, sam@ravnborg.org, kernel-hardening@lists.openwall.com, linuxppc-dev <linuxppc-dev@lists.ozlabs.org>, Michael Ellerman <mpe@ellerman.id.au>
List-ID: <kernel-hardening.lists.openwall.com>

On 27/03/17 18:38, Andrew Donnellan wrote:
> On 01/02/17 07:24, Kees Cook wrote:
>> From: Emese Revfy <re.emese@gmail.com>
>>
>> The kernel already has a mechanism to free up code and data memory that
>> is only used during kernel or module initialization.  This plugin will
>> teach the compiler to find more such code and data that can be freed
>> after initialization.
>
> Currently checking whether we can wire this up for powerpc without too
> many problems...

Added "select HAVE_GCC_PLUGIN_INITIFY_INIT_EXIT if GCC_PLUGINS" to 
arch/powerpc/Kconfig and have successfully compiled and booted a modular 
and non-modular powernv_defconfig, it looks like we handle the .exit 
sections correctly.

Could this be folded in for further testing when you get around to v6, Kees?

-- 
Andrew Donnellan              OzLabs, ADL Canberra
andrew.donnellan@au1.ibm.com  IBM Australia Limited
