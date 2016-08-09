Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 9 Aug 2016 11:23:07 +0200 (CEST)
From: Jiri Kosina <jikos@kernel.org>
In-Reply-To: <2206547.eDj3RJQyE5@vostro.rjw.lan>
Message-ID: <alpine.LRH.2.00.1608091121120.19185@gjva.wvxbf.pm>
References: <2206547.eDj3RJQyE5@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: [kernel-hardening] Re: [Resend][PATCH] x86/power/64: Always create temporary identity
 mapping correctly
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Linux PM list <linux-pm@vger.kernel.org>, Thomas Garnier <thgarnie@google.com>, the arch/x86 maintainers <x86@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Yinghai Lu <yinghai@kernel.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Kees Cook <keescook@chromium.org>, Pavel Machek <pavel@ucw.cz>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Borislav Petkov <bpetkov@suse.de>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, 8 Aug 2016, Rafael J. Wysocki wrote:

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

Unfortunately this applied on top of -rc1 still doesn't solve the reboot 
after reading hibernation image (I'd guess due to triple fault) with 
CONFIG_RANDOMIZE_MEMORY=y on my system.

With CONFIG_RANDOMIZE_MEMORY=n, the system resumes correctly.

-- 
Jiri Kosina
SUSE Labs
