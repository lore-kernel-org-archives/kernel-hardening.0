Message-ID: <1508371176.6806.29.camel@perches.com>
From: Joe Perches <joe@perches.com>
Date: Wed, 18 Oct 2017 16:59:36 -0700
In-Reply-To: <20171018234512.GE31318@eros>
References: <1508362242-12857-1-git-send-email-me@tobin.cc>
	 <CAGXu5jK_uybeGXT3AzKGYA7k4pV4YZ02S+EEybDyD5_uiJn4hw@mail.gmail.com>
	 <20171018234512.GE31318@eros>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] Re: [PATCH v5] printk: hash addresses printed with %p
To: "Tobin C. Harding" <me@tobin.cc>, Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 2017-10-19 at 10:45 +1100, Tobin C. Harding wrote:
> On Wed, Oct 18, 2017 at 03:31:16PM -0700, Kees Cook wrote:
> > On Wed, Oct 18, 2017 at 2:30 PM, Tobin C. Harding <me@tobin.cc> wrote:
> > > Currently there are many places in the kernel where addresses are being
> > > printed using an unadorned %p. Kernel pointers should be printed using
> > > %pK allowing some control via the kptr_restrict sysctl. Exposing addresses
> > > gives attackers sensitive information about the kernel layout in memory.
> > 
> > Is it intended for %pK to be covered by the hash as well? (When a
> > disallowed user is looking at %pK output, like kallsyms, the same hash
> > is seen for all values, rather than just zero -- I assume since the
> > value hashed is zero.)
> 
> Good catch, thanks. Have fixed for v6, will wait 24 hours before submitting.
> 
> > > +       spec.field_width = 2 + 2 * sizeof(unsigned int); /* 0x + hex */
> > > +       spec.flags = SPECIAL | SMALL | ZEROPAD;
> > 
> > I don't think this should have SPECIAL. We end up changing things like
> > kallsyms (which didn't have 0x before) and printing with double 0x's:

> While on the topic, have you an opinion on whether SMALL is good here. My first thought was that
> capitals _kind_of_ showed that it was an ID not an address, later contemplation made me think this
> may only have meaning to myself from working on the patch so better to leave it SMALL like original.

Perhaps using start/stop indicators could highlight this hashing.

Perhaps output using #hash_ptr#

by adding something like
#define HASHED	128		/* Output hashed ptr with # prefix and postfix */
after #define SPECIAL

but also perhaps adding to the column width would break
hex parsers of seq_ output

> Any thoughts appreciated.

2¢
