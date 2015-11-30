Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20151126075130.GB18742@gmail.com>
References: <1448494286-16029-1-git-send-email-keescook@chromium.org>
	<1448494286-16029-2-git-send-email-keescook@chromium.org>
	<20151126075130.GB18742@gmail.com>
Date: Mon, 30 Nov 2015 13:52:10 -0800
Message-ID: <CAGXu5j+Mom2oYbsSE65BMCAgio68J6ST4wODUf8-qHdxOe0jOQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2 1/4] init: create cmdline param to disable readonly
To: Ingo Molnar <mingo@kernel.org>, Heiko Carstens <heiko.carstens@de.ibm.com>, Michael Ellerman <mpe@ellerman.id.au>, "James E.J. Bottomley" <jejb@parisc-linux.org>, Catalin Marinas <catalin.marinas@arm.com>, Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>, Mathias Krause <minipli@googlemail.com>, Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linux-arch <linux-arch@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Nov 25, 2015 at 11:51 PM, Ingo Molnar <mingo@kernel.org> wrote:
> * Kees Cook <keescook@chromium.org> wrote:
>> +#ifdef CONFIG_DEBUG_RODATA
>
> Btw., could you please remove the Kconfig option altogether in an additional patch
> and make read-only sections an always-on feature? It has been default-y for years
> and all distros have it enabled.

Yeah, this is something I've wanted to do for a while, but I would
point out that only a few architectures have actually implemented it,
and for arm and arm64 it was very recent:

$ git grep 'config DEBUG_RODATA'
arch/arm/mm/Kconfig:config DEBUG_RODATA
arch/arm64/Kconfig.debug:config DEBUG_RODATA
arch/parisc/Kconfig.debug:config DEBUG_RODATA
arch/x86/Kconfig.debug:config DEBUG_RODATA

I think s390 already has strict kernel memory permissions, but they
set it up ahead of time. And now, I see in reading the parisc tree,
they do too, and mark_rodata_ro() is effectively a no-op. How does
powerpc handle permissions for kernel rodata?

For parisc (and maybe powerpc and s390) we'll need additional changes
to support __ro_after_init, since they may be making the ro section ro
_before_ init runs. But, that's okay since this series only uses
__ro_after_init on x86 for the moment. ;)

> The 'debug rodata' naming is purely historic: this started out as a simple
> debugging feature, but meanwhile it has spread and has become an essential kernel
> robustness feature.

I agree completely. I suspect I would turn this into
ARCH_HAS_STRICT_KERNMEM or something.

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
