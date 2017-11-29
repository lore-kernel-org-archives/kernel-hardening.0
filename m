Date: Wed, 29 Nov 2017 15:20:58 -0800
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20171129152058.389361d3576e784f47326cac@linux-foundation.org>
In-Reply-To: <1511921105-3647-5-git-send-email-me@tobin.cc>
References: <1511921105-3647-1-git-send-email-me@tobin.cc>
	<1511921105-3647-5-git-send-email-me@tobin.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH V11 4/5] vsprintf: add printk specifier %px
To: "Tobin C. Harding" <me@tobin.cc>
Cc: kernel-hardening@lists.openwall.com, Linus Torvalds <torvalds@linux-foundation.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@tycho.ws>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, Radim =?UTF-8?Q?Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 29 Nov 2017 13:05:04 +1100 "Tobin C. Harding" <me@tobin.cc> wrote:

> printk specifier %p now hashes all addresses before printing. Sometimes
> we need to see the actual unmodified address. This can be achieved using
> %lx but then we face the risk that if in future we want to change the
> way the Kernel handles printing of pointers we will have to grep through
> the already existent 50 000 %lx call sites. Let's add specifier %px as a
> clear, opt-in, way to print a pointer and maintain some level of
> isolation from all the other hex integer output within the Kernel.
> 
> Add printk specifier %px to print the actual unmodified address.
> 
> ...
>
> +Unmodified Addresses
> +====================
> +
> +::
> +
> +	%px	01234567 or 0123456789abcdef
> +
> +For printing pointers when you _really_ want to print the address. Please
> +consider whether or not you are leaking sensitive information about the
> +Kernel layout in memory before printing pointers with %px. %px is
> +functionally equivalent to %lx. %px is preferred to %lx because it is more
> +uniquely grep'able. If, in the future, we need to modify the way the Kernel
> +handles printing pointers it will be nice to be able to find the call
> +sites.
> +

You might want to add a checkpatch rule which emits a stern
do-you-really-want-to-do-this warning when someone uses %px.
