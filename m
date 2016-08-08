Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 8 Aug 2016 15:40:01 +0200
From: Borislav Petkov <bp@suse.de>
Message-ID: <20160808134001.GC29757@nazgul.tnic>
References: <2206547.eDj3RJQyE5@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2206547.eDj3RJQyE5@vostro.rjw.lan>
Subject: [kernel-hardening] Re: [Resend][PATCH] x86/power/64: Always create temporary identity
 mapping correctly
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linux PM list <linux-pm@vger.kernel.org>, Thomas Garnier <thgarnie@google.com>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Pavel Machek <pavel@ucw.cz>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Borislav Petkov <bpetkov@suse.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 08, 2016 at 03:31:31PM +0200, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> 
> The low-level resume-from-hibernation code on x86-64 uses
> kernel_ident_mapping_init() to create the temoprary identity mapping,
> but that function assumes that the offset between kernel virtual
> addresses and physical addresses is aligned on the PGD level.
> 
> However, with a randomized identity mapping base, it may be aligned
> on the PUD level and if that happens, the temporary identity mapping
> created by set_up_temporary_mappings() will not reflect the actual
> kernel identity mapping and the image restoration will fail as a
> result (leading to a kernel panic most of the time).
> 
> To fix this problem, rework kernel_ident_mapping_init() to support
> unaligned offsets between KVA and PA up to the PMD level and make
> set_up_temporary_mappings() use it as approprtiate.
> 
> Reported-by: Thomas Garnier <thgarnie@google.com>

Reported-by: Borislav Petkov <bp@suse.de>

> Suggested-by: Yinghai Lu <yinghai@kernel.org>
> Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Acked-by: Yinghai Lu <yinghai@kernel.org>
> ---
> 
> This is sort of urgent, because hibernation doesn't work with KASLR on x86-64
> in 4.8-rc1 AFAICS and this should make them work together again.
> 
> Unless anyone sees any problems with it, I'll queue it up for 4.8-rc2.
> 
> Thomas, would it be possible to test it with KASLR enabled, please?

Is that the only patch which needs to be tested? Ontop of which tree?

CONFIG_RANDOMIZE_MEMORY blew up s2d on my laptop here so I'll run it
once I have the required info from you :)

Thanks.

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.

SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton, HRB 21284 (AG Nürnberg)
--
