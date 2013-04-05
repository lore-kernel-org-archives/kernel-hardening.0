Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 5 Apr 2013 16:49:54 +0200
From: Borislav Petkov <bp@alien8.de>
Message-ID: <20130405144954.GC29290@pd.tnic>
References: <1365106055-22939-1-git-send-email-keescook@chromium.org>
 <1365106055-22939-4-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1365106055-22939-4-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] Re: [PATCH 3/3] x86: kernel base offset ASLR
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Apr 04, 2013 at 01:07:35PM -0700, Kees Cook wrote:
> This creates CONFIG_RANDOMIZE_BASE, so that the base offset of the kernel
> can be randomized at boot.

Right,

if I'm reading this whole deal correctly, I have an issue with this
in the sense that if this thing is enabled by default and people are
running stripped kernels, an oops which is being reported is worth sh*t
since all the addresses there are random and one simply can't map them
back to which functions the callstack frames are pointing to. Which will
majorly hinder debuggability, IMHO...

[ … ]

> When built into the kernel, the "noaslr" kernel command line option
> will disable the feature.

... so the saner thing to do, IMHO, would be to flip the meaning of
this option to "kaslr" or whatever and let people and distros enable
randomization on kernels which are bug free and don't oops (good luck
finding those :-)). Generally make the thing opt-in instead of opt-out.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
