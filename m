Date: Mon, 30 Oct 2017 20:00:46 -0400
From: Steven Rostedt <rostedt@goodmis.org>
Message-ID: <20171030200046.1f40a9dc@gandalf.local.home>
In-Reply-To: <20171030224102.GY12341@eros>
References: <1508986436-31966-1-git-send-email-me@tobin.cc>
	<1508986436-31966-3-git-send-email-me@tobin.cc>
	<20171026025838.GG12341@eros>
	<20171030173322.6ebed7db@gandalf.local.home>
	<20171030224102.GY12341@eros>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH V8 2/2] printk: hash addresses printed with %p
To: "Tobin C. Harding" <me@tobin.cc>
Cc: kernel-hardening@lists.openwall.com, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts,
 William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 31 Oct 2017 09:41:02 +1100
"Tobin C. Harding" <me@tobin.cc> wrote:


> Cool. So I think we need
> 
>  	get_random_bytes(&ptr_key, sizeof(ptr_key));

You'll need to add a comment here to describe what ordering the memory
barrier is used against. That is, somewhere else there's something that
needs to see the "true" after the "get_random_bytes" update. Describe
it here.

-- Steve


> 	smp_mb();
>  	WRITE_ONCE(have_filled_random_ptr_key, true);
> 
> V10 to include this unless I have it wrong.
> 
> thanks,
> Tobin.
