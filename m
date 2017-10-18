Date: Wed, 18 Oct 2017 11:28:58 -0400
From: Theodore Ts'o <tytso@mit.edu>
Message-ID: <20171018152858.fe6svcxycvzzadpy@thunk.org>
References: <1508215972-7769-1-git-send-email-me@tobin.cc>
 <20171017093119.6dd98919@gandalf.local.home>
 <20171017231559.GD8001@eros>
 <CAGXu5jJ3g8rP4L=Ptk0HYB_JDr-Oe+cGzMmpoQDB71SAG+qxaw@mail.gmail.com>
 <20171018022805.GB30848@eros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171018022805.GB30848@eros>
Subject: Re: [kernel-hardening] Re: [PATCH v2] printk: hash addresses printed
 with %p
To: "Tobin C. Harding" <me@tobin.cc>
Cc: Kees Cook <keescook@chromium.org>, Steven Rostedt <rostedt@goodmis.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 18, 2017 at 01:28:05PM +1100, Tobin C. Harding wrote:
> > >> Does %p[FfSs] leak addresses? Well, I guess it does if they are not
> > >> found in kallsyms, but otherwise you have:
> > >>
> > >>   function+0x<offset>
> > >
> > 
> > They haven't traditionally been a big deal. If they turn out to be
> > problematic, we can deal with it then, IMO.

If it's not in kallsyms, the raw address is probably not going to be
terribly useful --- so even if it's not traditionally been a big deal,
why not just hash them if it's not going to be printed as "function+0x<offset>"?

If nothing else, it will help correlate the random address with other
places where it was printed via %p.

					- Ted
