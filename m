Date: Wed, 8 Nov 2017 14:06:01 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171108030601.GA18478@eros>
References: <1509945567-11801-1-git-send-email-me@tobin.cc>
 <CA+55aFzPeCuvjscBNj6ANzfRUDsjT6Ntn9Grr915CrSpOfNSnA@mail.gmail.com>
 <CAGXu5j+o6cf0PrnxD+W+09F7UY6JL+h7Bn5_4T2C0Z_fTZAx-w@mail.gmail.com>
 <CA+55aFw-GgR7DmXsD1dmYWbxuVhg+u0oKwuwNEM4RnuVyA0NDw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFw-GgR7DmXsD1dmYWbxuVhg+u0oKwuwNEM4RnuVyA0NDw@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v3] scripts: add leaking_addresses.pl
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, Andy Lutomirski <luto@kernel.org>, Joe Perches <joe@perches.com>, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 07, 2017 at 01:44:01PM -0800, Linus Torvalds wrote:
> On Tue, Nov 7, 2017 at 1:22 PM, Kees Cook <keescook@chromium.org> wrote:
> >
> > Linus, what do you have in mind for the root-only "yes we really need
> > the actual address output" exceptions?
> 
> I am convinced that absolutely none of them should use '%pK'.
> 
> So far we have actually never seen a valid case wher %pK was really
> the right thing to do.
> 
> > For example, right now /sys/kernel/debug/kernel_page_tables
> > (CONFIG_X86_PTDUMP=y) needs actual address and currently uses %x.
> 
> So I think it could continue to use %x, and just make sure the whole
> file is root-only.
> 
> And that is why %pK is so wrong. It's almost never really about root.
> 
> Look at /proc/kallsyms, for example. There it's mainly about kernel
> profiles (although there certainly have been other uses historically,
> and maybe some of them remain) - which we have another flag for
> entirely that is very much specifically about kernel profiles.
> 
> > Looking other places that stand out, it seems like
> > /proc/lockdep_chains and /proc/lockdep (CONFIG_LOCKDEP=y) has a ton of
> > %p usage. It's unclear to me if a hash is sufficient for meaningful
> > debugging there?
> 
> Maybe not, but that is also _so_ esoteric that I suspect the right fix
> is to just make it root-only readable.
> 
> I've never used it, we should check with people who have. I get the
> feeling that this is purely for PeterZ debugging.
> 
> The very first commit that introduced that code actually has a
> 
>     (FIXME: should go into debugfs)
> 
> so I suspect it never should have been user-readable to begin with. I
> guess it makes some things easier, but it really is *very* different
> from things like profiling.
> 
> Profiling you often *cannot* do as root - some things you profile
> really shouldn't be run as root, and might even refuse to do so. So
> requiring you to be root just to get a kernel profile is very bad.
> 
> But looking at lockdep stats? Yeah, 'sudo' isn't so big of a deal.
> 
> And I really suspect that's true of a _lot_ of these %p things that
> really want a pointer. It's not that they really want %pK, it's that
> they shouldn't have been visible to regular users in the first place.
> 
> Things that *do* want a pointer and should be visible to regular users
> are things like oops messages etc, but even there we obviously
> generally want to use %pS/%pF when possible (but generally %x when not
> - things like register contents etc that *may* contain pointers).

This is opt-in, it means asking developers to do the right thing every time
they think they need a pointer. If we hash %p as soon as someone has
been bitten by it they will start using %x and sooner or later they will
use %x exclusively (suggesting using %x for _really_ necessary addresses
will only hasten the process).

If the only real benefit of hashing %p is to clean up kruft why don't we
add %pX and do tree wide substitution of all %p to %pX. People that get
broken will change it back to %p and we will have half a chance of
finding new abusers of %p down the track.

If there is not a 'one size fits all' solution, as we have seen with
kptr_restrict, then should we not be trying to make it easier for people
to do the right thing _and_ easier for us to catch it when we do the
wrong thing?

There is already almost 30 000 users of %{x,X}, surely we don't want to
promote more kernel address printing to be mixed in with all of that?

> And if they really are visible to users - because you want to
> cross-correlate them for things like netstat - I think the hashing is
> the right thing to do both for root and for regular users.
> 
> > Seems like these three from dmesg could be removed?
> >
> > [    0.000000] Base memory trampoline at [ffffa3fc40099000] 99000 size 24576
> > arch/x86/realmode/init.c
> >
> > [    0.000000] percpu: Embedded 38 pages/cpu @ffffa4007fc00000 s116944
> > r8192 d30512 u524288
> > mm/percpu.c
> >
> > [    0.456395] software IO TLB [mem 0xbbfdf000-0xbffdf000] (64MB)
> > mapped at [ffffa3fcfbfdf000-ffffa3fcfffdefff]
> > lib/swiotlb.c
> 
> Yes, I think the solution for a lot of the random device discovery
> messages etc is to just remove them. They were likely useful when the
> code was new and untested, and just stayed around afterwards.

Is anyone actually going to do this? If the hashing gets done then these
messages are not a risk, are _real_ kernel developers going to bother
cleaning this up? Surely newbies are not going to get much love either
if they submit patches that '[PATCH] remove unnecessary printk message'.

thanks,
Tobin.
