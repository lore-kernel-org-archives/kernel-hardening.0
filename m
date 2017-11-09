Date: Wed, 8 Nov 2017 22:35:55 -0500
From: Steven Rostedt <rostedt@goodmis.org>
Message-ID: <20171108223555.52c01531@vmware.local.home>
In-Reply-To: <1510192229-20038-1-git-send-email-me@tobin.cc>
References: <1510192229-20038-1-git-send-email-me@tobin.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] kallsyms: don't leak address when printing symbol
To: "Tobin C. Harding" <me@tobin.cc>
Cc: kernel-hardening@lists.openwall.com, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts,
 William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wil.deacon@arm.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, Peter Zijlstra <peterz@infradead.org>, David Miller <davem@davemloft.net>, Network Development <netdev@vger.kernel.org>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu,  9 Nov 2017 12:50:29 +1100
"Tobin C. Harding" <me@tobin.cc> wrote:

> Currently if a pointer is printed using %p[ssB] and the symbol is not
> found (kallsyms_lookup() fails) then we print the actual address. This
> leaks kernel addresses. We should instead print something _safe_.
> 
> Print "<no-symbol>" instead of kernel address.

Ug, ftrace requires this to work as is, as it uses it to print some
addresses that may or may not be a symbol.

If anything, can this return a success or failure if it were to find a
symbol or not, and then something like ftrace could decide to use %x if
it does not.

And yes, ftrace leaks kernel addresses all over the place, that's just
the nature of tracing the kernel.

-- Steve


> 
> Signed-off-by: Tobin C. Harding <me@tobin.cc>
> ---
>  kernel/kallsyms.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/kernel/kallsyms.c b/kernel/kallsyms.c
> index 127e7cfafa55..182e7592be9c 100644
> --- a/kernel/kallsyms.c
> +++ b/kernel/kallsyms.c
> @@ -390,7 +390,7 @@ static int __sprint_symbol(char *buffer, unsigned long address,
>  	address += symbol_offset;
>  	name = kallsyms_lookup(address, &size, &offset, &modname, buffer);
>  	if (!name)
> -		return sprintf(buffer, "0x%lx", address - symbol_offset);
> +		return sprintf(buffer, "<no-symbol>");
>  
>  	if (name != buffer)
>  		strcpy(buffer, name);
