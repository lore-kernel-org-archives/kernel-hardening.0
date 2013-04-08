Reply-To: kernel-hardening@lists.openwall.com
Sender: Ingo Molnar <mingo.kernel.org@gmail.com>
Date: Mon, 8 Apr 2013 13:58:23 +0200
From: Ingo Molnar <mingo@kernel.org>
Message-ID: <20130408115823.GC7513@gmail.com>
References: <1365106055-22939-1-git-send-email-keescook@chromium.org>
 <1365106055-22939-4-git-send-email-keescook@chromium.org>
 <515DE0C9.3030709@zytor.com>
 <20130405080418.GG26889@gmail.com>
 <515EEE25.1030402@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <515EEE25.1030402@zytor.com>
Subject: [kernel-hardening] Re: [PATCH 3/3] x86: kernel base offset ASLR
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, x86@kernel.org, Jarkko Sakkinen <jarkko.sakkinen@intel.com>, Matthew Garrett <mjg@redhat.com>, Matt Fleming <matt.fleming@intel.com>, Eric Northup <digitaleric@google.com>, Dan Rosenberg <drosenberg@vsecurity.com>, Julien Tinnes <jln@google.com>, Will Drewry <wad@chromium.org>, Linus Torvalds <torvalds@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>


* H. Peter Anvin <hpa@zytor.com> wrote:

> On 04/05/2013 01:04 AM, Ingo Molnar wrote:
> > 
> > Random runtime shuffling of the kernel image - is that possible with 
> > existing toolchains?
> > 
> 
> Yes... the question is how much work we'd be willing to go through to make it 
> happen.
> 
> One approach: the kernel already contains a linker -- used for modules -- and 
> the bulk of the kernel could actually be composed to a "pile of modules" that 
> gets linked on boot.  This would provide very large amounts of randomness.

Is there no code generation / micro-performance disadvantage to that?

Thanks,

	Ingo
