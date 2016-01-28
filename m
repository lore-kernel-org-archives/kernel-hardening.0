Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160128110622.GF17123@leverpostej>
References: <1453226922-16831-1-git-send-email-keescook@chromium.org>
	<1453226922-16831-4-git-send-email-keescook@chromium.org>
	<20160127211105.GA41450@davidb.org>
	<CAGXu5j+DLRoVE88a9++jVfEkN90HDiAaDAMnT2TrKqtMZ_yOww@mail.gmail.com>
	<20160128000906.GA42530@davidb.org>
	<20160128110622.GF17123@leverpostej>
Date: Thu, 28 Jan 2016 06:06:53 -0800
Message-ID: <CAGXu5jLy3cpLzU1MSQhS6q=5rMu2Mdp9pXncoFapPqUyQ1fO0A@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] arm64: make CONFIG_DEBUG_RODATA non-optional
To: Mark Rutland <mark.rutland@arm.com>
Cc: David Brown <david.brown@linaro.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Ingo Molnar <mingo@redhat.com>, Andy Lutomirski <luto@amacapital.net>, "H. Peter Anvin" <hpa@zytor.com>, Michael Ellerman <mpe@ellerman.id.au>, Mathias Krause <minipli@googlemail.com>, Thomas Gleixner <tglx@linutronix.de>, "x86@kernel.org" <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, PaX Team <pageexec@freemail.hu>, Emese Revfy <re.emese@gmail.com>, LKML <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Marc Zyngier <marc.zyngier@arm.com>, yalin wang <yalin.wang2010@gmail.com>, Zi Shen Lim <zlim.lnx@gmail.com>, Yang Shi <yang.shi@linaro.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Laura Abbott <lauraa@codeaurora.org>, "Suzuki K. Poulose" <suzuki.poulose@arm.com>, Steve Capper <steve.capper@linaro.org>, Jeremy Linton <jeremy.linton@arm.com>, Mark Salter <msalter@redhat.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Jan 28, 2016 at 3:06 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> One thing I would like to do is to avoid the need for fixup_executable
> entirely, by mapping the kernel text RO from the outset. However, that
> requires rework of the alternatives patching (to use a temporary RW
> alias), and I haven't had the time to look into that yet.

This makes perfect sense for the rodata section, but the (future)
postinit_rodata section we'll still want to mark RO after init
finishes. x86 and ARM cheat by marking both RO after init, and they
don't have to pad sections. parisc will need to solve this too.

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
