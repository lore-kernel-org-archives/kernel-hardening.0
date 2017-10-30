Date: Tue, 31 Oct 2017 08:24:28 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171030212428.GR12341@eros>
References: <1508798008-1692-1-git-send-email-me@tobin.cc>
 <CAHmME9qRroNJ1i9URtmhFmx_BDJRVdXvyRKdSZ=fAmDpOYnv8A@mail.gmail.com>
 <20171024003158.GB1429@eros>
 <CAHmME9ry-=Ve29eRfdMHLa0PgPqGtB=P2YuctgnVSoQN+DvN8w@mail.gmail.com>
 <20171025034934.GD15832@eros>
 <20171030162244.4f55e623@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171030162244.4f55e623@gandalf.local.home>
Subject: [kernel-hardening] Re: [PATCH v7] printk: hash addresses printed with %p
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Jason A. Donenfeld" <Jason@zx2c4.com>, kernel-hardening@lists.openwall.com, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Oct 30, 2017 at 04:22:44PM -0400, Steven Rostedt wrote:
> On Wed, 25 Oct 2017 14:49:34 +1100
> "Tobin C. Harding" <me@tobin.cc> wrote:
> > 
> > First, the static_key stuff.
> > 
> > DEFINE_STATIC_KEY_TRUE(no_ptr_secret) : Doesn't sleep, just a
> > declaration. 
> > 
> > if (static_branch_unlikely(&no_ptr_secret)) {} : Doesn't sleep, just
> > some assembler to jump to returning true or false.
> > 
> > static_branch_disable(&no_ptr_secret) : Doesn't sleep, just atomic read
> > and set and maybe a WARN_ONCE.
> 
> How quickly do you need static_branch_disable() executed? You could
> always pass the work off to a worker thread (that can schedule).
> 
> random_ready_callback -> initiates worker thread -> enables the static branch
> 
> -- Steve

thanks Steve, v8 and onward does away with the static branch and uses a
global boolean instead.

thanks,
Tobin.
