Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Fri, 5 Apr 2013 10:04:18 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20130405080418.GG26889@gmail.com>
References: <1365106055-22939-1-git-send-email-keescook@chromium.org>
 <1365106055-22939-4-git-send-email-keescook@chromium.org>
 <515DE0C9.3030709@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515DE0C9.3030709@zytor.com>
Subject: [kernel-hardening] Re: [PATCH 3/3] x86: kernel base offset ASLR
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>


* H. Peter Anvin <hpa@zytor.com> wrote:

> I have to admit to being somewhat skeptical toward KASLR with only 8 
> bits of randomness.  There are at least two potential ways of 
> dramatically increasing the available randomness:
> 
> 1. actually compose the kernel of multiple independently relocatable
>    pieces (maybe chunk it on 2M boundaries or something.)
> 
> 2. compile the kernel as one of the memory models which can be executed
>    anywhere in the 64-bit address space.  The cost of this would have
>    to be quantified, of course.
> 
> The latter is particularly something that should be considered for the 
> LPF JIT, to defend against JIT spray attacks.

The cost of 64-bit RIPs is probably measurable both in cache footprint and 
in execution speed.

Doing that might make sense - but unless it's surprisingly cheap to do it, 
at least from a distro perspective, randomizing the kernel base using the 
existing compact address space would probably be the preferred option - 
even if a bigger build model was available.

Random runtime shuffling of the kernel image - is that possible with 
existing toolchains?

Thanks,

	Ingo
