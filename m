MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <20171007234453.vojizsbxec4gygku@thunk.org>
References: <1506816410-10230-1-git-send-email-me@tobin.cc>
 <CA+55aFxzD=+H_M+Sg_8YRf-JYV-+-yn1c=dFhJWFzSh5yWt9Gg@mail.gmail.com>
 <ArOl6I7GkZ912O0tP7uFPe5JRJTftclvQHVtSHw0hsmxk5IJXexp9M3zQPefcGCXcx27lzX7A1s74XFa9gXEA5yRA5hC1BaNqhD7QgN3JRo=@protonmail.ch>
 <CA+55aFzGsRFPtMFRv3G0FPNs6YAD3S2U94o58Lgg1MnmHwCxvA@mail.gmail.com>
 <476DC76E7D1DF2438D32BFADF679FC563EAF4F29@ORSMSX103.amr.corp.intel.com>
 <CA+55aFwEZCT6=BCdmaNn5LGeU8g-2qi4OnM9MTOep3NOZVXjMg@mail.gmail.com>
 <20171005021915.GK16685@eros> <CA+55aFwac2BzgZs-X1_VhekkuGfuLqNui2+2DbvLiDyptS-rXQ@mail.gmail.com>
 <476DC76E7D1DF2438D32BFADF679FC563F4AD0AF@ORSMSX115.amr.corp.intel.com>
 <CA+55aFxjsKRhuzpQjRff6b6emJBFHtefUwnDfv+zgrxmUDvqkw@mail.gmail.com> <20171007234453.vojizsbxec4gygku@thunk.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 7 Oct 2017 17:08:29 -0700
Message-ID: <CA+55aFy2CQ_AFahTQynumDL6ocZD5R23v=HXLYS6w_E1tpY-1Q@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] [RFC V2 0/6] add more kernel pointer filter options
To: Theodore Ts'o <tytso@mit.edu>
Cc: "Roberts, William C" <william.c.roberts@intel.com>, "Tobin C. Harding" <me@tobin.cc>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Oct 7, 2017 at 4:44 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>
> Maybe this is overkill, but what about *encrypting* the pointer using
> fixed, per-boot random key?  It would have to be a block crypto
> algorithm, like Tea/XXTea/XXTEA or Speck.  That has all of the
> benefits of hashing, plus if the key is available (only to privileged
> users, of course), then it would be possible to get the pointer for
> debugging purposes.

I doubt it's going to be used enough to be worth it.

So I'd rather just make it a hash that gives you that identity for
people who want it, and then people who actually need the address
would need to decide whether they _really_ need it in the first place,
or whether they would use %lx instead together with stricty security
rules.

I did test the patch I sent out (using jhash - so not a cryptographic
hash, and with a "random value" that was just a constant) just to see
that it doesn't break anything obvious. As expected, it did break
kernel profiling (which uses /proc/kallsyms), and it obviously made
the kernel pointers I'd already found in dmesg be just garbage, but it
didn't seem insurmountable. More like a "with a couple of fixup cases,
it might all work fine".

So I'd be willing to try it for the next merge window, and see if it
causes unexpected problems..

                Linus
