Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Fri, 5 Apr 2013 09:36:21 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20130405073621.GA27843@gmail.com>
References: <1365106055-22939-1-git-send-email-keescook@chromium.org>
 <1365106055-22939-2-git-send-email-keescook@chromium.org>
 <20130405072405.GD26889@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130405072405.GD26889@gmail.com>
Subject: [kernel-hardening] Re: [PATCH 1/3] x86: routines to choose random kernel base offset
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>


* Ingo Molnar <mingo@kernel.org> wrote:

> 
> * Kees Cook <keescook@chromium.org> wrote:
> 
> > This provides routines for selecting a randomized kernel base offset, 
> > bounded by e820 details. It tries to use RDRAND and falls back to RDTSC. 
> > If "noaslr" is on the kernel command line, no offset will be used.
> 
> Would it make sense to also add three other sources of entropy:

In any case, would it be possible to also mix these bootup sources of 
entropy into our regular random pool?

That would improve random pool entropy on all Linux systems, not just 
those that choose to enable kernel-base-address randomization.

Thanks,

	Ingo
