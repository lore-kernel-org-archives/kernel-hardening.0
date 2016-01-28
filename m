Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 28 Jan 2016 14:59:01 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20160128145900.GN17123@leverpostej>
References: <1453226922-16831-1-git-send-email-keescook@chromium.org>
 <1453226922-16831-4-git-send-email-keescook@chromium.org>
 <20160127211105.GA41450@davidb.org>
 <CAGXu5j+DLRoVE88a9++jVfEkN90HDiAaDAMnT2TrKqtMZ_yOww@mail.gmail.com>
 <20160128000906.GA42530@davidb.org>
 <20160128110622.GF17123@leverpostej>
 <CAGXu5jLy3cpLzU1MSQhS6q=5rMu2Mdp9pXncoFapPqUyQ1fO0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jLy3cpLzU1MSQhS6q=5rMu2Mdp9pXncoFapPqUyQ1fO0A@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH] arm64: make CONFIG_DEBUG_RODATA non-optional
To: Kees Cook <keescook@chromium.org>
Cc: David Brown <david.brown@linaro.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>, Michael Ellerman <mpe@ellerman.id.au>, Mathias Krause <minipli@googlemail.com>, Thomas Gleixner <tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, LKML <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, yalin wang <yalin.wang2010@gmail.com>, Zi Shen Lim <zlim.lnx@gmail.com>, Yang Shi <yang.shi@linaro.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Laura Abbott <lauraa@codeaurora.org>, "Suzuki K. Poulose" <suzuki.poulose@arm.com>, Steve Capper <steve.capper@linaro.org>, Jeremy Linton <jeremy.linton@arm.com>, Mark Salter <msalter@redhat.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 28, 2016 at 06:06:53AM -0800, Kees Cook wrote:
> On Thu, Jan 28, 2016 at 3:06 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> > One thing I would like to do is to avoid the need for fixup_executable
> > entirely, by mapping the kernel text RO from the outset. However, that
> > requires rework of the alternatives patching (to use a temporary RW
> > alias), and I haven't had the time to look into that yet.
> 
> This makes perfect sense for the rodata section, but the (future)
> postinit_rodata section we'll still want to mark RO after init
> finishes. x86 and ARM cheat by marking both RO after init, and they
> don't have to pad sections. parisc will need to solve this too.

Depending on how many postinit_rodata variables there are, we might be
able to drop those in .rodata, have them RO always, and initialise them
via a temporary RW alias (e.g. something in the vmalloc area).

The only requirement for that is that we use a helper to initialise any
__postinit_ro variables via a temporary RW alias, e.g.

#define SET_POST_INIT_RO(ptr, v) ({ 		\\
	typeof(ptr) __ptr_rw = (ptr)		\\
	BUG_ON(initcalls_done);			\\
	__ptr_rw = create_rw_alias(__ptr);	\\
	__ptr_rw = v;				\\
	destroy_rw_alias(__ptr_rw);		\\
})

...

__postinit_ro void *thing;

void __init some_init_func(void) {
	void *__thing = some_ranodomized_allocator();
	SET_POSTINIT_RO(thing, thing);
}


Mark.
