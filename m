Date: Fri, 20 Oct 2017 07:22:12 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171019202212.GB29874@eros>
References: <1508394884-13869-1-git-send-email-me@tobin.cc>
 <20171019084431.223c69f4@vmware.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171019084431.223c69f4@vmware.local.home>
Subject: [kernel-hardening] Re: [RFC] scripts: add leaking_addresses.pl
To: Steven Rostedt <rostedt@goodmis.org>
Cc: kernel-hardening@lists.openwall.com, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Oct 19, 2017 at 08:44:31AM -0400, Steven Rostedt wrote:
> On Thu, 19 Oct 2017 17:34:44 +1100
> "Tobin C. Harding" <me@tobin.cc> wrote:
> 
> > 
> > My usual disclaimer; I am a long way from being a Perl monger, any tips,
> 
> I'm a semi Perl monger.
> 
> > however trivial, most welcome.
> > 
> > Parses dmesg output first then;
> > 
> > Algorithm walks the directory tree of /proc and /sys, opens each file
> > for reading and parses file line by line. We therefore need to skip
> > certain files;
> > 
> >  - binary files.
> >  - relay large files of fixed format that _definitely_ won't leak.
> 
> "relay large files"? What do the files relay with? ;-)

:) All bugs are shallow to enough eyes eh.

Good tips, thank you. V2 to come.

thanks,
Tobin.
