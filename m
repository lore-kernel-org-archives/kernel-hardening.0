Date: Mon, 2 Oct 2017 20:58:50 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <20171002185850.GB30634@kroah.com>
References: <20171002180140.142854-1-ebiggers3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171002180140.142854-1-ebiggers3@gmail.com>
Subject: [kernel-hardening] Re: [PATCH] x86/fpu: Don't let userspace set bogus xcomp_bv
To: Eric Biggers <ebiggers3@gmail.com>
Cc: stable@vger.kernel.org, Eric Biggers <ebiggers@google.com>, Andrew Morton <akpm@linux-foundation.org>, Andy Lutomirski <luto@amacapital.net>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>, Fenghua Yu <fenghua.yu@intel.com>, Kevin Hao <haokexin@gmail.com>, Linus Torvalds <torvalds@linux-foundation.org>, Michael Halcrow <mhalcrow@google.com>, Oleg Nesterov <oleg@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Thomas Gleixner <tglx@linutronix.de>, Wanpeng Li <wanpeng.li@hotmail.com>, Yu-cheng Yu <yu-cheng.yu@intel.com>, kernel-hardening@lists.openwall.com, Ingo Molnar <mingo@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Oct 02, 2017 at 11:01:40AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> commit 814fb7bb7db5433757d76f4c4502c96fc53b0b5e upstream.  Please apply
> to 4.13-stable and 4.9-stable.

Thanks for all of these backports, now queued up.

greg k-h
