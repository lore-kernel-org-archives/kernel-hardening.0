MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <476DC76E7D1DF2438D32BFADF679FC563EAF4F29@ORSMSX103.amr.corp.intel.com>
References: <1506816410-10230-1-git-send-email-me@tobin.cc>
 <CA+55aFxzD=+H_M+Sg_8YRf-JYV-+-yn1c=dFhJWFzSh5yWt9Gg@mail.gmail.com>
 <ArOl6I7GkZ912O0tP7uFPe5JRJTftclvQHVtSHw0hsmxk5IJXexp9M3zQPefcGCXcx27lzX7A1s74XFa9gXEA5yRA5hC1BaNqhD7QgN3JRo=@protonmail.ch>
 <CA+55aFzGsRFPtMFRv3G0FPNs6YAD3S2U94o58Lgg1MnmHwCxvA@mail.gmail.com> <476DC76E7D1DF2438D32BFADF679FC563EAF4F29@ORSMSX103.amr.corp.intel.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 4 Oct 2017 16:52:58 -0700
Message-ID: <CA+55aFwEZCT6=BCdmaNn5LGeU8g-2qi4OnM9MTOep3NOZVXjMg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [RFC V2 0/6] add more kernel pointer filter options
To: "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>
Cc: Jordan Glover <Golden_Miller83@protonmail.ch>, "Tobin C. Harding" <me@tobin.cc>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 4, 2017 at 2:58 PM, Roberts, William C
<william.c.roberts@intel.com> wrote:
>
> I agree with you 100% kptr restrict is odd, and I don't think anyone should have had to opt in to be
> cleansed via kptr_restrict value via %pK. Opt-in never works. One nice thing now, is that checkpatch
> has checking of %p usages and warns.

Yeah, the checkpatch thing may help for future patches.

> As far as broken things, I can't comment on desktop systems where I think it's harder to make that claim.
> I see value in embedded systems where I am shipping the whole image, So I know when/what will
> break.
>
> If this was in-tree, Android would be setting this to 4 immediately FWIW.

Does android set it to 2 right now?

But even if it does, my point is that we've had this thing for 6+
years, and it really hasn't helped fix our code much at all.

In fact, I think the opposite is true. I think it *hurts*. It hurts
exactly because it's a hack, and it makes people not bother to fix the
real problems.

I think we'd be better off just fixing code.

One thing you can do today is just look through your 'dmesg' for what
looks like kernel addresses (if virtual addresses is what you're
interested in - obviously physical addresses will look different). On
x86-64, for example, something like this:

    dmesg | egrep 'ffff[0-9a-f]{12}'

might be interesting to look at. It shows (for me) that we show the
percpu address mapping, for example. That certainly sounds interesting
to a potential attacker, and I suspect Tejun isn't really interested
in that information any more. Added to Cc.

It also shows

    software IO TLB [mem PA-PB] (64MB) mapped at [VA-VB]

for example.  And THIS IS IMPORTANT! The physical address is shown
with "%#010llx".

See what I'm saying? The kptr_restrict games are just that: games and
security theater. If you actually care about things like physical
addresses, you don't say "let's hide %pa". Because that's not how the
real world works. I found one case that would entirely have missed
with the very first trivial grep I did.

So I'm claiming that anybody who says "it's too hard to fix it for
real, let's just paper over it in vsprintf.c" is fundamentally going
to miss things like this. I agree that it might be painful to try to
figure out where the problems are, but somebody like google probably
has a lot of dmesg output, and it should not be that hard to do the
above kinds of "let's just see what leaks, and FIX it".

                   Linus
