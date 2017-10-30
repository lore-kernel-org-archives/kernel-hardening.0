Date: Tue, 31 Oct 2017 09:41:02 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171030224102.GY12341@eros>
References: <1508986436-31966-1-git-send-email-me@tobin.cc>
 <1508986436-31966-3-git-send-email-me@tobin.cc>
 <20171026025838.GG12341@eros>
 <20171030173322.6ebed7db@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171030173322.6ebed7db@gandalf.local.home>
Subject: [kernel-hardening] Re: [PATCH V8 2/2] printk: hash addresses printed with %p
To: Steven Rostedt <rostedt@goodmis.org>
Cc: kernel-hardening@lists.openwall.com, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Oct 30, 2017 at 05:33:22PM -0400, Steven Rostedt wrote:
> On Thu, 26 Oct 2017 13:58:38 +1100
> "Tobin C. Harding" <me@tobin.cc> wrote:
> 
> > > +static bool have_filled_random_ptr_key;
> > > +static siphash_key_t ptr_key __read_mostly;
> > > +
> > > +static void fill_random_ptr_key(struct random_ready_callback *unused)
> > > +{
> > > +	get_random_bytes(&ptr_key, sizeof(ptr_key));
> > > +	WRITE_ONCE(have_filled_random_ptr_key, true);  
> > 
> > This usage of WRITE_ONCE was suggested by Jason A. Donenfeld. I read
> > include/linux/compiler.h but was not able to grok it. Is this enough to
> > stop the compiler re-ordering these two statements? 
> > 
> > Or do I need to read Documentation/memory-barriers.txt [again]?
> 
> No, the WRITE_ONCE does not stop the compiler from reordering those
> statements. If you need that, then you need to do:
> 
> 	get_random_bytes(&ptr_key, sizeof(ptr_key));
> 	barrier();
> 	WRITE_ONCE(have_filled_random_ptr_key, true);
> 
> and that only works against interrupts. If you need synchronization
> across CPUs, then you need smp_mb().

Cool. So I think we need

 	get_random_bytes(&ptr_key, sizeof(ptr_key));
	smp_mb();
 	WRITE_ONCE(have_filled_random_ptr_key, true);

V10 to include this unless I have it wrong.

thanks,
Tobin.
