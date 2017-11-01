Date: Wed, 1 Nov 2017 13:43:32 +0100
From: Petr Mladek <pmladek@suse.com>
Message-ID: <20171101124332.GC20040@pathway.suse.cz>
References: <1509317956-28041-1-git-send-email-me@tobin.cc>
 <20171031153944.GA32091@pathway.suse.cz>
 <20171031235345.GE3585@eros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171031235345.GE3585@eros>
Subject: [kernel-hardening] Re: [PATCH V9] printk: hash addresses printed with %p
To: "Tobin C. Harding" <me@tobin.cc>
Cc: kernel-hardening@lists.openwall.com, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed 2017-11-01 10:53:45, Tobin C. Harding wrote:
> On Tue, Oct 31, 2017 at 04:39:44PM +0100, Petr Mladek wrote:
> > On Mon 2017-10-30 09:59:16, Tobin C. Harding wrote:
> > > Currently there are many places in the kernel where addresses are being
> > > printed using an unadorned %p. Kernel pointers should be printed using
> > > %pK allowing some control via the kptr_restrict sysctl. Exposing addresses
> > > gives attackers sensitive information about the kernel layout in memory.
> > > 
> > > We can reduce the attack surface by hashing all addresses printed with
> > > %p. This will of course break some users, forcing code printing needed
> > > addresses to be updated.
> > 
> > I am sorry for my ignorance but what is the right update, please?
> 
> Can I say first that I am in no way an expert, I am new to both this
> problem and kernel dev in general.

Sure. There are many experienced people in CC. I hope that they might
have some opinion on this.

My concern is that this patch breaks some functionality because it
is dangerous. This makes perfect sense. But people will want to fix
it a safe way. And the way is not clear to me.


> > I expect that there are several possibilities:
> > 
> >   + remove the pointer at all
> 
> This definitely stops the leak!

Sure. But this is not a solution for debugging tools, e.g. lockdep.
sysrq-related dumps. Of course, the pointers must not be visible
on production system to normal users but there should be a way
to see them for debugging purposes.

> >   + replace it with %pK so that it honors kptr_restrict setting
> 
> I think this is the option of choice, see concerns below however. I get
> the feeling that the hope with this patch is that a vast majority of
> users of %p won't care so stopping all those addresses is the real win
> for this patch.
> 
> The next hoped benefit is that the hashing will shed light on this topic
> and get developers to think about the issue before _wildly_ printing
> addresses. Having to work harder to print the address in future will aid
> this (assuming everyone doesn't just start using %x).



> >   + any other option?
> 
> Use %x or %X - really bad, this will create more pain in the future.

Yes, using %x or %X is dangerous. It would be used by users
that do not mind about security. Or is there any situation when
always using the original pointer as a string is needed
for a real functionality?

IMHO, string is needed only for human readable usage. Then it always
smells with information leak.


> > Is kptr_restrict considered a safe mechanism?
> > 
> > Also kptr_restrict seems to be primary for the messages that are available
> > via /proc and /sys. Is it good enough for the messages logged by
> > printk()?
> 
> There is some concern that kptr_restrict is not overly great. Linus is
> the main purveyor of this argument. I won't paraphrase here because I
> will not do the argument justice.
> 
> See this thread for the whole discussion
> 
> [kernel-hardening] [RFC V2 0/6] add more kernel pointer filter options

I saw the discussion but it was a bit hard to follow. I would
highlight the following three concerns related to kptr_restrict:

First, it did not help to improve the situation. IMHO, this is mainly
because it was opt-in and did not force people to fix the code. This
is being addressed by this patch that actively breaks all users.

Second, the user credentials are checked when the string is formatted.
They do not reflect the path how the string is passed to the user.
Therefore it might be cheated. This opens a question if kptr_restrict
would stay in kernel and whether the conversion from %p to %pK
is one of the proposed solutions.

Third, kptr_restrict can be modified too late. It means that
the pointers printed during the early boot will never or always
be readable. It means that you would need two different kernel
builds for production and debugging. Well, this is probably
the smallest issue.


All in all. I wonder if it would make sense to introduce
some compiler or command line option that would allow
to disable the hashing of pointers for debugging
purposes.

Best Regards,
Petr
