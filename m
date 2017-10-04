MIME-Version: 1.0
In-Reply-To: <CA+55aFxzD=+H_M+Sg_8YRf-JYV-+-yn1c=dFhJWFzSh5yWt9Gg@mail.gmail.com>
References: <1506816410-10230-1-git-send-email-me@tobin.cc> <CA+55aFxzD=+H_M+Sg_8YRf-JYV-+-yn1c=dFhJWFzSh5yWt9Gg@mail.gmail.com>
From: Boris Lukashev <blukashev@sempervictus.com>
Date: Wed, 4 Oct 2017 12:22:47 -0400
Message-ID: <CAFUG7CcQoJZ9SyGnD61xjkc6nCQhbgnqBJ0k-PkQxE9iTo2+SA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [RFC V2 0/6] add more kernel pointer filter options
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Tobin C. Harding" <me@tobin.cc>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, William Roberts <william.c.roberts@intel.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 4, 2017 at 11:41 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> On Sat, Sep 30, 2017 at 5:06 PM, Tobin C. Harding <me@tobin.cc> wrote:
>>   lib: vsprintf: default kptr_restrict to the maximum value
>
> So I'm not convinced about this one.
>
> It removes kernel pointers even for root, which is annoying for things
> like perf.
>

The debugging and perf use cases seem well suited for using a
boot-time parameter to disable the restriction such as to allow
sysadmins to boot in a manner permitting them to see these values,
while running in production without the (potential) leaks.

> And the only physical pointers we should print out during boot etc are
> things we *need*.
>
> So kptr_restrict is wrong for that, bercause either we potentially
> need those values for debugging ("why does my kernel not boot"), or
> they shouldn't be printed at all.
>
> And I think _that_ is the real issue. If there are places that leak,
> we should look at those, rather than just say "kptr_restrict".

When adding modules from outside the mainline tree (zfs, aufs, scst,
etc), we would not be able to audit the source, and risk leaking
sensitive pointers from those components if we dont filter them out
this way or in a similar programmatic manner. There's also the issue
of containers' access to kernel output, making the "root concern"
somewhat more complicated. Large distributions are known to use code
which hasn't, and in some cases never can, pass through the
upstreaming process in your tree (ZFS being the primary case i'm
thinking of for licensing reasons), and it would be a shame to leave
their users with a reduced security posture for letting them utilize
things which can't get mainlined.

>
>                  Linus

Are there production-context requirements for exposing this
information, or is the thought that this really only screws up "trying
to fix or understand" the execution environment, with those being
debugging/tuning functions not usually performed on critical systems
in operation?
If its the latter, then for long running systems with relevant 0days
we're not yet privy to, restriction on the attackers ability to map
physmem can raise the bar for attack complexity significantly,
offering real-world benefit to defenders while mitigation is
implemented to correct the underlying concern.
We do a fair share of work in medical environments, where applying a
kernel update may involve FDA approval or other acrobatics through
flaming hoops (specifically for implanted med devices and their base
stations), so defensive measures providing blanket coverage for a
class of attacker activity (recon of memory layout in this case) are
very welcome to those consumers.

-- 
Boris Lukashev
Systems Architect
Semper Victus
