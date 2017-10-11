Date: Wed, 11 Oct 2017 13:48:58 -0400
From: Theodore Ts'o <tytso@mit.edu>
Message-ID: <20171011174858.bga4okxq5plxzxze@thunk.org>
References: <1507693696-3777-1-git-send-email-me@tobin.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1507693696-3777-1-git-send-email-me@tobin.cc>
Subject: Re: [kernel-hardening] [PATCH] printk: hash addresses printed with %p
To: "Tobin C. Harding" <me@tobin.cc>
Cc: kernel-hardening@lists.openwall.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 11, 2017 at 02:48:16PM +1100, Tobin C. Harding wrote:
> +/*
> + * Obfuscates pointer (algorithm taken from kptr_obfuscate(). See kernel/kcmp.c)
> + * v is the pointer value, randval is some random value, oddval is some random
> + * odd value.
> + *
> + * The obfuscation is done in two steps. First we xor the kernel pointer with
> + * a random value, which puts pointer into a new position in a reordered space.
> + * Secondly we multiply the xor production with a large odd random number to
> + * permute its bits even more (the odd multiplier guarantees that the product
> + * is unique ever after the high bits are truncated, since any odd number is
> + * relative prime to 2^n).
> + */

Why not just expose kptr_obfusecate() and use it, instead of copying
code?

Also, I'm nervous about the obfuscation.  If the attacker can get a
handful of known "real kernel pointer" and "obfuscated kernel pointer"
values, it wouldn't be that hard for them to be able to reverse
engineer the two secret values.

Perhaps the argument is "if the attacker can get a _single_ real
kernel address, it's all over anyway", which is probably true for
KASLR, but which might not be true for all attacks.

Anyway, if you use kptr_obfuscate in kernel/kcmp.c, then if we later
decide that we should change the obfuscation algorithm to something
stronger, we only need to do it in one place.

					- Ted
