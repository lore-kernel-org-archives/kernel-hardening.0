Date: Sat, 7 Oct 2017 19:44:53 -0400
From: Theodore Ts'o <tytso@mit.edu>
Message-ID: <20171007234453.vojizsbxec4gygku@thunk.org>
References: <1506816410-10230-1-git-send-email-me@tobin.cc>
 <CA+55aFxzD=+H_M+Sg_8YRf-JYV-+-yn1c=dFhJWFzSh5yWt9Gg@mail.gmail.com>
 <ArOl6I7GkZ912O0tP7uFPe5JRJTftclvQHVtSHw0hsmxk5IJXexp9M3zQPefcGCXcx27lzX7A1s74XFa9gXEA5yRA5hC1BaNqhD7QgN3JRo=@protonmail.ch>
 <CA+55aFzGsRFPtMFRv3G0FPNs6YAD3S2U94o58Lgg1MnmHwCxvA@mail.gmail.com>
 <476DC76E7D1DF2438D32BFADF679FC563EAF4F29@ORSMSX103.amr.corp.intel.com>
 <CA+55aFwEZCT6=BCdmaNn5LGeU8g-2qi4OnM9MTOep3NOZVXjMg@mail.gmail.com>
 <20171005021915.GK16685@eros>
 <CA+55aFwac2BzgZs-X1_VhekkuGfuLqNui2+2DbvLiDyptS-rXQ@mail.gmail.com>
 <476DC76E7D1DF2438D32BFADF679FC563F4AD0AF@ORSMSX115.amr.corp.intel.com>
 <CA+55aFxjsKRhuzpQjRff6b6emJBFHtefUwnDfv+zgrxmUDvqkw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFxjsKRhuzpQjRff6b6emJBFHtefUwnDfv+zgrxmUDvqkw@mail.gmail.com>
Subject: Re: [kernel-hardening] [RFC V2 0/6] add more kernel pointer filter
 options
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Roberts, William C" <william.c.roberts@intel.com>, "Tobin C. Harding" <me@tobin.cc>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Oct 05, 2017 at 09:19:17AM -0700, Linus Torvalds wrote:
>  - meaningful hardware addresses (ie the pointer is some mmio pointer).
> 
> At least the first case could possibly continue to use a '%p' that
> simply hashes the actual pointer value with some hash or something
> like that. It's not the pointer itself that is important, it's just
> the "identity" of the socket or device or whatever.
> 
> Of course, "just hash it" isn't good enough if we're just hiding the
> (very limited) kernel address space randomization, but mixing in a
> per-boot random value might be sufficient.

Maybe this is overkill, but what about *encrypting* the pointer using
fixed, per-boot random key?  It would have to be a block crypto
algorithm, like Tea/XXTea/XXTEA or Speck.  That has all of the
benefits of hashing, plus if the key is available (only to privileged
users, of course), then it would be possible to get the pointer for
debugging purposes.

						- Ted
