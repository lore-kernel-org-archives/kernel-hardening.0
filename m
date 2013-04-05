Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Fri, 5 Apr 2013 09:34:50 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20130405073449.GE26889@gmail.com>
References: <1365106055-22939-1-git-send-email-keescook@chromium.org>
 <1365106055-22939-4-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1365106055-22939-4-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] Re: [PATCH 3/3] x86: kernel base offset ASLR
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>


* Kees Cook <keescook@chromium.org> wrote:

> +config RANDOMIZE_BASE_MAX_OFFSET
> +	hex "Maximum ASLR offset allowed"
> +	depends on RANDOMIZE_BASE
> +	default "0x10000000"
> +	range 0x0 0x10000000
> +	---help---
> +	 Determines the maximal offset in bytes that will be applied to the
> +	 kernel when Address Space Layout Randomization (ASLR) is active.
> +	 Physical memory layout and kernel size may limit this further.
> +	 This must be a power of two.

I'm not sure this configuration option should be exposed. Is there any 
reason that if the feature is enabled, to not set this to the highest 
possible value?

Furthermore, when randomization is enabled, I'd suggest to default 
kptr_restrict to 1 [if the user does not override it] - currently the 
bootup default is 0.

I.e. make it easy to enable effective KASLR with a single configuration 
step, without "forgot about kptr_restrict" gotchas.

I'd also suggest to rename RANDOMIZE_BASE to something like 
RANDOMIZE_KBASE. The 'kbase' makes it really clear that this is about some 
kernel base address randomization.

'Randomize base' sounds too generic, and could be misunderstood to mean 
something about our random pool for example.

Thanks,

	Ingo
