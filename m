Message-ID: <1509415728.26592.40.camel@perches.com>
From: Joe Perches <joe@perches.com>
Date: Mon, 30 Oct 2017 19:08:48 -0700
In-Reply-To: <20171030223346.GX12341@eros>
References: <1508986436-31966-1-git-send-email-me@tobin.cc>
	 <CAGXu5jJvBKd2i-P4LVW_mHY9e3j4JEpaR4=a7dt3CcOvimcuTQ@mail.gmail.com>
	 <20171030223346.GX12341@eros>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH V8 0/2] printk: hash addresses printed with %p
To: "Tobin C. Harding" <me@tobin.cc>, Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 2017-10-31 at 09:33 +1100, Tobin C. Harding wrote:
> On Mon, Oct 30, 2017 at 03:03:21PM -0700, Kees Cook wrote:
> > On Wed, Oct 25, 2017 at 7:53 PM, Tobin C. Harding <me@tobin.cc> wrote:
> > > Here is the behaviour that this set implements.
> > > 
> > > For kpt_restrict==0
> > > 
> > > Randomness not ready:
> > >   printed with %p:              (pointer)          # NOTE: with padding
> > > Valid pointer:
> > >   printed with %pK:             deadbeefdeadbeef
> > >   printed with %p:              0xdeadbeef
> > >   malformed specifier (eg %i):  0xdeadbeef
> > 
> > I really think we can't include SPECIAL unless _every_ callsite of %p
> > is actually doing "0x%p", and then we're replacing all of those. We're
> > not doing that, though...
> > 
> > $ git grep '%p\b' | wc -l
> > 12766
> > $ git grep '0x%p\b' | wc -l
> > 18370x
> > 
> > If we need some kind of special marking that this is a hashed
> > variable, that should be something other than "0x". If we're using the
> > existing "(null)" and new "(pointer)" text, maybe "(hash:xxxxxx)"
> > should be used instead? Then the (rare) callers with 0x become
> > "0x(hash:xxxx)" and naked callers produce "(hash:xxxx)".
> > 
> > I think the first step for this is to just leave SPECIAL out.
> 
> Thanks Kees. V9 leaves SPECIAL out. Also V9 prints the whole 64 bit
> address with the first 32 bits masked to zero. The intent being to _not_
> change the output format from what it currently is. So it will look like
> this; 
> 
> 	00000000c09e81d0
> 
> What do you think?
> 
> Amusingly I think this whole conversation is going to come up again
> when we do %pa, in inverse, since %pa currently does us SPECIAL.

I once sent a patch set to remove SPECIAL from %pa
and add 0x where necessary.

https://patchwork.kernel.org/patch/3875471/

After that didn't happen, I removed the duplicated
0x%pa with a sed.

https://patchwork.kernel.org/patch/8509421/

Sending a treewide sed patch would be fine with me.
