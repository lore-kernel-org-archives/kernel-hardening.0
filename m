Date: Tue, 17 Oct 2017 20:35:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
Message-ID: <20171017203516.3746395e@vmware.local.home>
In-Reply-To: <20171017231559.GD8001@eros>
References: <1508215972-7769-1-git-send-email-me@tobin.cc>
	<20171017093119.6dd98919@gandalf.local.home>
	<20171017231559.GD8001@eros>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2] printk: hash addresses printed with %p
To: "Tobin C. Harding" <me@tobin.cc>
Cc: kernel-hardening@lists.openwall.com, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts,
 William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 18 Oct 2017 10:15:59 +1100
"Tobin C. Harding" <me@tobin.cc> wrote:

> > Does %p[FfSs] leak addresses? Well, I guess it does if they are not
> > found in kallsyms, but otherwise you have:
> > 
> >   function+0x<offset>  
> 
> You are correct %pF and %pS print an offset. Does this provide an attack vector,
> I didn't think so but I'm no security expert. If they do then we need to amend
> those calls also.

Hopefully not. We changed stack dumps to use them only instead of
showing addresses because of the location leak.

-- Steve
