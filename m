Date: Fri, 27 Oct 2017 22:33:01 +0900
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Message-ID: <20171027133301.GA612@tigerII.localdomain>
References: <1508986436-31966-1-git-send-email-me@tobin.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1508986436-31966-1-git-send-email-me@tobin.cc>
Subject: [kernel-hardening] Re: [PATCH V8 0/2] printk: hash addresses printed with %p
To: "Tobin C. Harding" <me@tobin.cc>
Cc: kernel-hardening@lists.openwall.com, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On (10/26/17 13:53), Tobin C. Harding wrote:
> Currently there are many places in the kernel where addresses are being
> printed using an unadorned %p. Kernel pointers should be printed using
> %pK allowing some control via the kptr_restrict sysctl. Exposing
> addresses gives attackers sensitive information about the kernel layout
> in memory.
> 
> We can reduce the attack surface by hashing all addresses printed with
> %p. This will of course break some users, forcing code printing needed
> addresses to be updated.
> 
> With this version we include hashing of malformed specifiers also.
> Malformed specifiers include incomplete (e.g %pi) and also non-existent
> specifiers. checkpatch should warn for non-existent specifiers but
> AFAICT won't warn for incomplete specifiers.
> 
> Here is the behaviour that this set implements.
> 
> For kpt_restrict==0
> 
> Randomness not ready:
>   printed with %p: 		(pointer)          # NOTE: with padding
> Valid pointer:
>   printed with %pK: 		deadbeefdeadbeef
>   printed with %p: 		0xdeadbeef
>   malformed specifier (eg %i):  0xdeadbeef
> NULL pointer:
>   printed with %pK: 		0000000000000000
>   printed with %p: 		(null)               # NOTE: no padding
>   malformed specifier (eg %i):  (null)

a quick question:
 do we care about cases when kernel pointers are printed with %x/%X and
 not with %p?

	-ss
