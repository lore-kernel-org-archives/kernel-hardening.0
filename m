Date: Thu, 26 Oct 2017 09:00:03 +0200
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20171026070003.GA25583@kroah.com>
References: <CAHmME9rZE0oSOq6KecY1pTMsJa4dK2sCyuMRZbFjnamZkHXViA@mail.gmail.com>
 <20171025222727.GB12341@eros>
 <CAHmME9rdfLNZD1bhvA4Xh=kdEN-7-FSV8aU0y_ky3Ts2zoPd4Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHmME9rdfLNZD1bhvA4Xh=kdEN-7-FSV8aU0y_ky3Ts2zoPd4Q@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v7] printk: hash addresses printed with %p
To: "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc: "Tobin C. Harding" <me@tobin.cc>, kernel-hardening@lists.openwall.com, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Oct 26, 2017 at 12:59:08AM +0200, Jason A. Donenfeld wrote:
> On Thu, Oct 26, 2017 at 12:27 AM, Tobin C. Harding <me@tobin.cc> wrote:
> > How good is unlikely()?
> 
> It places that branch way at the bottom of the function so that it's
> less likely to pollute the icache.

But always measure it.  Lots of times (old numbers were 90% or so), we
get the marking wrong, so please, always benchmark the thing to verify
it actually is doing what you think it should be doing, otherwise it
could make the code worse.

thanks,

greg k-h
