Date: Fri, 13 Oct 2017 18:48:56 -0400
From: Theodore Ts'o <tytso@mit.edu>
Message-ID: <20171013224856.sbdf3vflnh27haxk@thunk.org>
References: <CA+55aFwac2BzgZs-X1_VhekkuGfuLqNui2+2DbvLiDyptS-rXQ@mail.gmail.com>
 <476DC76E7D1DF2438D32BFADF679FC563F4AD0AF@ORSMSX115.amr.corp.intel.com>
 <CA+55aFxjsKRhuzpQjRff6b6emJBFHtefUwnDfv+zgrxmUDvqkw@mail.gmail.com>
 <20171007234453.vojizsbxec4gygku@thunk.org>
 <CA+55aFy2CQ_AFahTQynumDL6ocZD5R23v=HXLYS6w_E1tpY-1Q@mail.gmail.com>
 <476DC76E7D1DF2438D32BFADF679FC563F4AF1B4@ORSMSX115.amr.corp.intel.com>
 <CA+55aFy58SHOCbJWtzB94PuT0d9UmdJ8QUZt+MjDYL9qbdfxbw@mail.gmail.com>
 <CAGXu5jJns_OogyXTwZ7crasCuOSAZMkiLN6c0=y8bGpsP1YNTg@mail.gmail.com>
 <CA+55aFxZo5kZEiZFYj5mns3Tsgb0JLC_rae2ThObeM5xrC8Mug@mail.gmail.com>
 <CAGXu5jLKRP-XPT2JEoN0bGsZjX98XhNNQBTYYSFz2NnLvE=EYg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jLKRP-XPT2JEoN0bGsZjX98XhNNQBTYYSFz2NnLvE=EYg@mail.gmail.com>
Subject: Re: [kernel-hardening] [RFC V2 0/6] add more kernel pointer filter
 options
To: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, "Roberts, William C" <william.c.roberts@intel.com>, "Tobin C. Harding" <me@tobin.cc>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Oct 13, 2017 at 01:47:07PM -0700, Kees Cook wrote:
> Can we do something more about %x?

Can we have sparse or some other static checking tool complain when a
pointer is cast to an integer type in a printf/sprintf context?

	   	      	      	   - Ted
