Date: Fri, 3 Nov 2017 01:04:09 +0900
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Message-ID: <20171102160409.GE7195@tigerII.localdomain>
References: <1508986436-31966-1-git-send-email-me@tobin.cc>
 <20171027133301.GA612@tigerII.localdomain>
 <20171031233533.GD3585@eros>
 <20171102082344.GC655@jagdpanzerIV>
 <20171102101449.GG7499@eros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171102101449.GG7499@eros>
Subject: [kernel-hardening] Re: [PATCH V8 0/2] printk: hash addresses printed with %p
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, kernel-hardening@lists.openwall.com, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On (11/02/17 21:14), Tobin C. Harding wrote:
[..]
> I can put my email address if there is not a better option.

sounds good.


> > hm... just a huge pile of if's
> > 
> > 	if (is_vmalloc_addr(addr))
> > 		do_hashing(addr);
> > 	else if (__module_address(addr))
> > 		do_hashing(addr);
> > 	else if (is_kernel(addr) || is_kernel_inittext(addr))
> > 	...
> > 
> > but that's going to be really messy and "iffy".
> 
> This is the only suggestion we have so far.
> 

well... one more: check if we can safely dereference it. if so
it's a pointer, probably :)

	if (!probe_kernel_address(addr, p))
		do_hashing(addr);


just an idea.

	-ss
