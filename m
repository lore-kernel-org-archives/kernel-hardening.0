Message-ID: <1507692434.3552.41.camel@perches.com>
From: Joe Perches <joe@perches.com>
Date: Tue, 10 Oct 2017 20:27:14 -0700
In-Reply-To: <20171010233209.GB2049@eros>
References: <1507676974-1298-1-git-send-email-me@tobin.cc>
	 <CA+55aFx56_4ERvNfdvQUk4yFF5UXWPkwg5g=QwS820nxAK0Bcg@mail.gmail.com>
	 <20171010233209.GB2049@eros>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 0/3] add %pX specifier
To: "Tobin C. Harding" <me@tobin.cc>, Linus Torvalds <torvalds@linux-foundation.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, KVM list <kvm@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 2017-10-11 at 10:32 +1100, Tobin C. Harding wrote:
> On Tue, Oct 10, 2017 at 04:15:01PM -0700, Linus Torvalds wrote:
> > On Tue, Oct 10, 2017 at 4:09 PM, Tobin C. Harding <me@tobin.cc> wrote:
> > > 
> > > I did not understand the code (specifically why the right shift of 16 twice?)
> > 
> > It's a traditional trick to get the upper 32 bits.
> > 
> > So it basically splits the (possibly 64-bit) pointer into the lower 32
> > bits and the upper 32 bits for a hash such as "jhash()" that takes
> > data that is "unsigned int".
> > 
> > (NOTE! Using jhash here is not acceptable, since it's not
> > cryptographically safe, but think of it as an example of a hash that
> > takes 32-bit input).
> > 
> > Doing ">> 32" is undefined on 32-bit architectures, and wouldn't work.
> > 
> > But doing >> 16 >> 16 is a fine way to say "shift right by 32 on a
> > 64-bit architecture" while also being well-defined on a 32-bit one.
> > 
> >                Linus
> 
> Awesome, thanks.

Another way is using the upper_32_bits() macro.
It's perhaps a bit more readable.
