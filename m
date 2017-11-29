Date: Wed, 29 Nov 2017 15:21:07 -0800
From: Andrew Morton <akpm@linux-foundation.org>
Message-Id: <20171129152107.a5c4dd2e20295f817d94f8d9@linux-foundation.org>
In-Reply-To: <1511921105-3647-4-git-send-email-me@tobin.cc>
References: <1511921105-3647-1-git-send-email-me@tobin.cc>
	<1511921105-3647-4-git-send-email-me@tobin.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH V11 3/5] printk: hash addresses printed with %p
To: "Tobin C. Harding" <me@tobin.cc>
Cc: kernel-hardening@lists.openwall.com, Linus Torvalds <torvalds@linux-foundation.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@tycho.ws>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, Radim =?UTF-8?Q?Kr=C4=8Dm=C3=A1=C5=99?= <rkrcmar@redhat.com>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, Stephen Rothwell <sfr@canb.auug.org.au>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 29 Nov 2017 13:05:03 +1100 "Tobin C. Harding" <me@tobin.cc> wrote:

> Currently there exist approximately 14 000 places in the kernel where
> addresses are being printed using an unadorned %p. This potentially
> leaks sensitive information regarding the Kernel layout in memory. Many
> of these calls are stale, instead of fixing every call lets hash the
> address by default before printing. This will of course break some
> users, forcing code printing needed addresses to be updated.
> 
> Code that _really_ needs the address will soon be able to use the new
> printk specifier %px to print the address.
> 
> For what it's worth, usage of unadorned %p can be broken down as
> follows (thanks to Joe Perches).
> 
> $ git grep -E '%p[^A-Za-z0-9]' | cut -f1 -d"/" | sort | uniq -c
>    1084 arch
>      20 block
>      10 crypto
>      32 Documentation
>    8121 drivers
>    1221 fs
>     143 include
>     101 kernel
>      69 lib
>     100 mm
>    1510 net
>      40 samples
>       7 scripts
>      11 security
>     166 sound
>     152 tools
>       2 virt
> 
> Add function ptr_to_id() to map an address to a 32 bit unique
> identifier. Hash any unadorned usage of specifier %p and any malformed
> specifiers.
> 
> ...
>
> @@ -1644,6 +1646,73 @@ char *device_node_string(char *buf, char *end, struct device_node *dn,
>  	return widen_string(buf, buf - buf_start, end, spec);
>  }
>  
> +static bool have_filled_random_ptr_key __read_mostly;
> +static siphash_key_t ptr_key __read_mostly;
> +
> +static void fill_random_ptr_key(struct random_ready_callback *unused)
> +{
> +	get_random_bytes(&ptr_key, sizeof(ptr_key));
> +	/*
> +	 * have_filled_random_ptr_key==true is dependent on get_random_bytes().
> +	 * ptr_to_id() needs to see have_filled_random_ptr_key==true
> +	 * after get_random_bytes() returns.
> +	 */
> +	smp_mb();
> +	WRITE_ONCE(have_filled_random_ptr_key, true);
> +}

I don't think I'm seeing anything which prevents two CPUs from
initializing ptr_key at the same time.  Probably doesn't matter much...
