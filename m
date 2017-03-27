From: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
References: <1485894263-91051-1-git-send-email-keescook@chromium.org>
 <1485894263-91051-2-git-send-email-keescook@chromium.org>
Date: Mon, 27 Mar 2017 18:38:20 +1100
MIME-Version: 1.0
In-Reply-To: <1485894263-91051-2-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Message-Id: <851a0c99-db08-c3a8-f5c6-2e567971e2eb@au1.ibm.com>
Subject: Re: [kernel-hardening] [PATCH v5 1/4] gcc-plugins: Add the initify
 gcc plugin
To: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org
Cc: Emese Revfy <re.emese@gmail.com>, Arnd Bergmann <arnd@arndb.de>, Josh Triplett <josh@joshtriplett.org>, pageexec@freemail.hu, yamada.masahiro@socionext.com, minipli@ld-linux.so, linux@armlinux.org.uk, catalin.marinas@arm.com, linux@rasmusvillemoes.dk, david.brown@linaro.org, benh@kernel.crashing.org, tglx@linutronix.de, akpm@linux-foundation.org, jlayton@poochiereds.net, sam@ravnborg.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 01/02/17 07:24, Kees Cook wrote:
> From: Emese Revfy <re.emese@gmail.com>
>
> The kernel already has a mechanism to free up code and data memory that
> is only used during kernel or module initialization.  This plugin will
> teach the compiler to find more such code and data that can be freed
> after initialization.

Currently checking whether we can wire this up for powerpc without too 
many problems...

> diff --git a/arch/x86/lib/Makefile b/arch/x86/lib/Makefile
> index 34a74131a12c..b98b8fdb7aaf 100644
> --- a/arch/x86/lib/Makefile
> +++ b/arch/x86/lib/Makefile
> @@ -29,6 +29,10 @@ lib-$(CONFIG_RANDOMIZE_BASE) += kaslr.o
>  obj-y += msr.o msr-reg.o msr-reg-export.o hweight.o
>
>  ifeq ($(CONFIG_X86_32),y)
> +        CFLAGS_strstr_32.o += $(INITIFY_DISABLE_VERIFIY_NOCAPTURE_FUNCTIONS)
> +        CFLAGS_string_32.o += $(INITIFY_DISABLE_VERIFIY_NOCAPTURE_FUNCTIONS)
> +        CFLAGS_memcpy_32.o += $(INITIFY_DISABLE_VERIFIY_NOCAPTURE_FUNCTIONS)

s/VERIFIY/VERIFY/g here + Makefile.gcc-plugins?


-- 
Andrew Donnellan              OzLabs, ADL Canberra
andrew.donnellan@au1.ibm.com  IBM Australia Limited
