Date: Mon, 30 Oct 2017 17:33:22 -0400
From: Steven Rostedt <rostedt@goodmis.org>
Message-ID: <20171030173322.6ebed7db@gandalf.local.home>
In-Reply-To: <20171026025838.GG12341@eros>
References: <1508986436-31966-1-git-send-email-me@tobin.cc>
	<1508986436-31966-3-git-send-email-me@tobin.cc>
	<20171026025838.GG12341@eros>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH V8 2/2] printk: hash addresses printed with %p
To: "Tobin C. Harding" <me@tobin.cc>
Cc: kernel-hardening@lists.openwall.com, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts,
 William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 26 Oct 2017 13:58:38 +1100
"Tobin C. Harding" <me@tobin.cc> wrote:

> > +static bool have_filled_random_ptr_key;
> > +static siphash_key_t ptr_key __read_mostly;
> > +
> > +static void fill_random_ptr_key(struct random_ready_callback *unused)
> > +{
> > +	get_random_bytes(&ptr_key, sizeof(ptr_key));
> > +	WRITE_ONCE(have_filled_random_ptr_key, true);  
> 
> This usage of WRITE_ONCE was suggested by Jason A. Donenfeld. I read
> include/linux/compiler.h but was not able to grok it. Is this enough to
> stop the compiler re-ordering these two statements? 
> 
> Or do I need to read Documentation/memory-barriers.txt [again]?

No, the WRITE_ONCE does not stop the compiler from reordering those
statements. If you need that, then you need to do:

	get_random_bytes(&ptr_key, sizeof(ptr_key));
	barrier();
	WRITE_ONCE(have_filled_random_ptr_key, true);

and that only works against interrupts. If you need synchronization
across CPUs, then you need smp_mb().

-- Steve
