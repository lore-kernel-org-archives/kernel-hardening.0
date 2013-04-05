Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <515F1541.40509@zytor.com>
Date: Fri, 05 Apr 2013 11:17:37 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
MIME-Version: 1.0
References: <1365106055-22939-1-git-send-email-keescook@chromium.org> <1365106055-22939-4-git-send-email-keescook@chromium.org> <515DE0C9.3030709@zytor.com> <20130405080418.GG26889@gmail.com>
In-Reply-To: <20130405080418.GG26889@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 3/3] x86: kernel base offset ASLR
To: Ingo Molnar <mingo@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 04/05/2013 01:04 AM, Ingo Molnar wrote:
> 
> The cost of 64-bit RIPs is probably measurable both in cache footprint and 
> in execution speed.
> 

Well, "probably" usually translates to "worth measuring" to me.

> Random runtime shuffling of the kernel image - is that possible with 
> existing toolchains?

I wanted to point out... yes this is hard, but it has the ability to be
*much* stronger than any other form of KASLR simply because it means
that a single infoleak doesn't give everything else away.

	-hpa
