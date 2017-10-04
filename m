MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <ArOl6I7GkZ912O0tP7uFPe5JRJTftclvQHVtSHw0hsmxk5IJXexp9M3zQPefcGCXcx27lzX7A1s74XFa9gXEA5yRA5hC1BaNqhD7QgN3JRo=@protonmail.ch>
References: <1506816410-10230-1-git-send-email-me@tobin.cc>
 <CA+55aFxzD=+H_M+Sg_8YRf-JYV-+-yn1c=dFhJWFzSh5yWt9Gg@mail.gmail.com> <ArOl6I7GkZ912O0tP7uFPe5JRJTftclvQHVtSHw0hsmxk5IJXexp9M3zQPefcGCXcx27lzX7A1s74XFa9gXEA5yRA5hC1BaNqhD7QgN3JRo=@protonmail.ch>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 4 Oct 2017 12:19:14 -0700
Message-ID: <CA+55aFzGsRFPtMFRv3G0FPNs6YAD3S2U94o58Lgg1MnmHwCxvA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [RFC V2 0/6] add more kernel pointer filter options
To: Jordan Glover <Golden_Miller83@protonmail.ch>
Cc: "Tobin C. Harding" <me@tobin.cc>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, William Roberts <william.c.roberts@intel.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 4, 2017 at 11:58 AM, Jordan Glover
<Golden_Miller83@protonmail.ch> wrote:
> If we knew where those leaks are hiding they will be fixed already. The only
> thing we knew is that bugs/leaks are there. It's always better to just fix
> all the code but it isn't realistic.

Honestly, what's the difference between setting kptr_restrict to 4 and
just using a sed-script (or maybe some coccinelle) to remove all
existing plain %p users?

One just hides the issue and will make people work around it (likely
on a global level by just undoing it).

The other would *also* make people work around it for when they notice
breakage, but would actually force people to do it on a case-by-case
basis (and thus hopefully _properly_) rather than just setting
kptr_restrict back to 0.

Btw, this is *not* a theoretical argument.

WE HAVE BEEN HERE, DONE THIS!

kptr_restrict goes back to 6+ years ago, and was actually initially
set to a restrictive value. It got undone, exactly because it caused
problems. It's too big of a hammer, and it's too *broken* of a hammer.

And exactly because kptr_restrict was pretty much an "all or nothing"
thing, absolutely *NOTHING* has improved in the 6+ years since it was
introduced.

We have had improvements in our pointer printing that were _not_
related to kptr_restrict, though, See for example commit bb5e5ce545f2
("x86/dumpstack: Remove kernel text addresses from stack dump").

Those have actually been _real_ fixes for leaking things, unlike kptr_restrict.

This is why I maintain that kptr_restrict is bad. It's a badly thought
out interface. It's wrong.

We know it is crap, exactly because we've already been there. The
whole notion of a global switch is seriously mis-designed.

So I really do think that it would be better to just write a script to
get rid of all raw %p users, and then put the ones that are needed
(hopefully very few) back.

It wouldn't require odd new magic sequences to override "I actually
_do_ want %p".

              Linus
