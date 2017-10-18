Date: Wed, 18 Oct 2017 13:28:05 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171018022805.GB30848@eros>
References: <1508215972-7769-1-git-send-email-me@tobin.cc>
 <20171017093119.6dd98919@gandalf.local.home>
 <20171017231559.GD8001@eros>
 <CAGXu5jJ3g8rP4L=Ptk0HYB_JDr-Oe+cGzMmpoQDB71SAG+qxaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJ3g8rP4L=Ptk0HYB_JDr-Oe+cGzMmpoQDB71SAG+qxaw@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v2] printk: hash addresses printed with %p
To: Kees Cook <keescook@chromium.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Oct 17, 2017 at 05:13:10PM -0700, Kees Cook wrote:
> On Tue, Oct 17, 2017 at 4:15 PM, Tobin C. Harding <me@tobin.cc> wrote:
> > On Tue, Oct 17, 2017 at 09:31:19AM -0400, Steven Rostedt wrote:
> >> On Tue, 17 Oct 2017 15:52:51 +1100
> >> "Tobin C. Harding" <me@tobin.cc> wrote:
> >>
> >> > Currently there are many places in the kernel where addresses are being
> >> > printed using an unadorned %p. Kernel pointers should be printed using
> >> > %pK allowing some control via the kptr_restrict sysctl. Exposing addresses
> >> > gives attackers sensitive information about the kernel layout in memory.
> >> >
> >> > We can reduce the attack surface by hashing all addresses printed with
> >> > %p. This will of course break some users, forcing code printing needed
> >> > addresses to be updated.
> >> >
> >> > For what it's worth, usage of unadorned %p can be broken down as follows
> >> >
> >> >     git grep '%p[^KFfSsBRrbMmIiEUVKNhdDgCGO]' | wc -l
> >>
> >> Does %p[FfSs] leak addresses? Well, I guess it does if they are not
> >> found in kallsyms, but otherwise you have:
> >>
> >>   function+0x<offset>
> >
> > You are correct %pF and %pS print an offset. Does this provide an attack vector,
> > I didn't think so but I'm no security expert. If they do then we need to amend
> > those calls also.
> 
> They haven't traditionally been a big deal. If they turn out to be
> problematic, we can deal with it then, IMO.

Thanks Kees,
Tobin.
