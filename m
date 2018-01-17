Date: Wed, 17 Jan 2018 10:01:03 -0500
From: Steven Rostedt <rostedt@goodmis.org>
Message-ID: <20180117100103.5d91803a@gandalf.local.home>
In-Reply-To: <CA+DvKQJM8N30PXUTVJQTWfkhGu7-3F+sy9bwK-gJhc8anmwG9g@mail.gmail.com>
References: <20180113213441.52047-1-dan@kernelim.com>
	<20180113213441.52047-6-dan@kernelim.com>
	<20180114014801.GC1701@tigerII.localdomain>
	<20180114080108.GA69022@gmail.com>
	<20180115075231.0d435fec@gandalf.local.home>
	<CA+DvKQJM8N30PXUTVJQTWfkhGu7-3F+sy9bwK-gJhc8anmwG9g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Re: [PATCHv2 5/7] printk: allow kmsg to be
 encrypted using public key encryption
To: Daniel Micay <danielmicay@gmail.com>
Cc: Dan Aloni <dan@kernelim.com>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, linux-kernel@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, Petr Mladek <pmladek@suse.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 16 Jan 2018 18:44:45 -0500
Daniel Micay <danielmicay@gmail.com> wrote:

> > Do you have any backing from makers of such devices? I'd like to hear
> > from Google's Android team or whoever that would turn this feature on.  
> 
> (I'm not a Google employee, but I work on Android security and
> contribute some of that to AOSP.)
> 
> Android restricts [ delete what Android does ]

That doesn't answer the question if Android would enable this feature
or not. With what you show, it sounds like they wouldn't, as they are
already covered.

-- Steve
