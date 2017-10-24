Date: Wed, 25 Oct 2017 07:45:52 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171024204552.GI1429@eros>
References: <1508798008-1692-1-git-send-email-me@tobin.cc>
 <CAHmME9qRroNJ1i9URtmhFmx_BDJRVdXvyRKdSZ=fAmDpOYnv8A@mail.gmail.com>
 <20171024003158.GB1429@eros>
 <CAHmME9ry-=Ve29eRfdMHLa0PgPqGtB=P2YuctgnVSoQN+DvN8w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9ry-=Ve29eRfdMHLa0PgPqGtB=P2YuctgnVSoQN+DvN8w@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v7] printk: hash addresses printed with %p
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: kernel-hardening@lists.openwall.com, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Oct 24, 2017 at 01:25:52PM +0200, Jason A. Donenfeld wrote:
> On Tue, Oct 24, 2017 at 2:31 AM, Tobin C. Harding <me@tobin.cc> wrote:
> > On Tue, Oct 24, 2017 at 01:00:03AM +0200, Jason A. Donenfeld wrote:
> >> Provided you've tested this and the static_key guard stuff actually
> >> works as intended,
> >
> > I tested by inserting a simple module that calls printf() with a bunch of
> > different specifiers. So it's tested but not stress tested. Some stress testing
> > might be nice, no ideas how to go about that though.
> 
> By the way, it occurred to me one thing you might want to verify
> closely is whether or not that callback block executes from process
> context and whether or not the static_key stuff sleeps. If both,
> there's a problem.

Ok, will do.

thanks,
Tobin.
