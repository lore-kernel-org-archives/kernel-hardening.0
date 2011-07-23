Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 23 Jul 2011 20:05:53 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110723160553.GA11320@openwall.com>
References: <20110723114038.GA3281@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110723114038.GA3281@albatros>
Subject: Re: [kernel-hardening] securelevel'ish restrictions in Linux
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy, all -

On Sat, Jul 23, 2011 at 03:40:38PM +0400, Vasiliy Kulikov wrote:
> Before starting to think about porting grsecurity features restricting
> root, I'd want to discuss the global problem here.

I am not very interested in these.  Besides the general issues with
securelevel'ish restrictions (BTW, I did use securelevel on 2.0 kernels
in late 1990s), we sort of have similar restrictions (and more) when we
use OpenVZ containers anyway (and presumably when we use LXC later). :-)

Of course, in practice we need to consider vulnerabilities that make it
possible for in-container root to escape the container, but my
expectation is that most of such vulnerabilities would be kernel bugs,
at least on systems that we manage. ;-)  And most (or at least many) of
such kernel bugs would allow for arbitrary code execution in the kernel
anyway.

So these restrictions might not really add a layer of security for
typical systems that we set up and manage these days (with nothing
non-essential to system administration running outside of containers).

Oh, of course there's an important detail: ease of reliable introduction
of a backdoor.  Yes, module loading, if allowed, may be easier and more
reliable than having to hack the running kernel more directly.  However,
I think there's already a way to disable module loading, and your
proposal is specifically about things such as /dev/*mem, which are
perhaps not much easier to use than patching the memory via an arbitrary
code execution vulnerability in the kernel is.

OK, if we consider a script kiddie who has a root exploit via a kernel
bug and a kernel rootkit to install as two separate pieces of software -
and lacks skills or time or motivation to combine the two into one -
then, yes, restricting /dev/*mem could help.

So this does make some sense, after all, but:

I'd rather spend my/our time discussing other things first, and revisit
this topic later.  For example, I find the ability to set a container
(pid namespace?) to 32-bit only or 64-bit only (restricting the
available syscalls accordingly) far more desirable and more relevant to
systems we run.

That said, I don't mind you working on this and submitting such patches
to LKML when you would otherwise be idle (waiting for feedback on
something else).

I'd appreciate comments on the above, including other opinions.

Thanks,

Alexander
