Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 24 Nov 2015 17:33:08 -0500
From: Rich Felker <dalias@libc.org>
Message-ID: <20151124223308.GM3818@brightrain.aerifal.cx>
References: <564EF64F.1060903@redhat.com>
 <CAGXu5jLK61OFfSXtEzisMkdt9CnVaa5Eiw6sUB0=w2DjzPjJ5A@mail.gmail.com>
 <5654CE83.3000503@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5654CE83.3000503@redhat.com>
Sender: Rich Felker <dalias@aerifal.cx>
Subject: Re: [kernel-hardening] System call interface changes
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 24, 2015 at 09:54:27PM +0100, Florian Weimer wrote:
> On 11/24/2015 09:10 PM, Kees Cook wrote:
> 
> > Ah, are you looking at this as an anti-ROP idea? What's the bug class
> > or exploitation method you're looking at addressing?
> 
> The idea, as it has been presented to me, is to remove the ability to
> invoke execve (and a few other system calls) completely, to push
> attackers *towards* ROP as the only means for injecting code into a
> process (not all processes, obviously, but a large class of processes as
> feasible).
> 
> As far as I know, this is intended as a post-exploitation mitigation
> (before policy-based mechanisms or containers kick in).  I don't know
> enough about real-world attack scenarios to tell if these changes would
> make a difference.

If the intent is only to block a single syscall, why would you break
the existing user-kernel interface boundary and require a new
alternate one rather than just doing something like
seccomp/pledge/prctl to disable exec* syscalls and whatever else needs
to be blocked?

I'm also a bit confused how you would take advantage of this without
static linking since libc.so will contain all the syscalls and
syscall().

Rich
