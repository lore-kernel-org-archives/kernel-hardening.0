Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <5179A7CE.2050605@zytor.com>
Date: Thu, 25 Apr 2013 15:01:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
References: <1366926860-26776-1-git-send-email-keescook@chromium.org>
In-Reply-To: <1366926860-26776-1-git-send-email-keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v3 0/6] kernel ASLR
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 04/25/2013 02:54 PM, Kees Cook wrote:
> This continues to build on the tip/kaslr patches for KASLR. This series
> converts the logic to C, and moves both relocation and address selection
> into the decompress_kernel path. Several areas were refactored to allow
> for some code reuse (e.g. CPU flags, kernel command line).
> 
> This does not yet attempt to rework the page tables to handle an arbitrary
> physical memory location on x86_64. I would love some suggestions on
> how to do this. :)
> 

We *should* already support arbitrary physical memory locations at least
in the kernel proper (the decompressor might need some work.)

We may want to do in the decompressor what we already do in the kernel,
and set up a #PF handler which creates page tables on demand.  That way
you can simply treat the entire memory space as a single linear space.

	-hpa
