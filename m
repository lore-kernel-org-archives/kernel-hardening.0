Date: Tue, 16 Jan 2018 11:09:43 +0900
From: Sergey Senozhatsky <sergey.senozhatsky.work@gmail.com>
Message-ID: <20180116020943.GC6607@jagdpanzerIV>
References: <20180113213441.52047-1-dan@kernelim.com>
 <20180113213441.52047-6-dan@kernelim.com>
 <20180114014801.GC1701@tigerII.localdomain>
 <20180114080108.GA69022@gmail.com>
 <20180115075231.0d435fec@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180115075231.0d435fec@gandalf.local.home>
Subject: [kernel-hardening] Re: [PATCHv2 5/7] printk: allow kmsg to be encrypted using public
 key encryption
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Dan Aloni <dan@kernelim.com>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Petr Mladek <pmladek@suse.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On (01/15/18 07:52), Steven Rostedt wrote:
[..]
> I'm very skeptical that such an approach has much benefit. From the
> email referenced above:

agreed. dmesg can be SECURITY_DMESG_RESTRICT.
so the patch is *probably* aiming the systems in which anyone can read
dmesg, but we kinda don't want that to happen. may be I'm missing the
point.

> > I am not sure that desktop and power users would like to have their
> > kernel message encrypted, but there are scenarios such as in mobile
> > devices, where only the developers, makers of devices, may actually
> > benefit from access to kernel prints messages, and the users may be
> > more protected from exploits.
> 
> Do you have any backing from makers of such devices? I'd like to hear
> from Google's Android team or whoever that would turn this feature on.
> 
> I would be hard pressed to add such a feature if it's never used.

right.

	-ss
