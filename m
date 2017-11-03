Date: Fri, 3 Nov 2017 10:43:35 +0530
From: Vinod Koul <vinod.koul@intel.com>
Message-ID: <20171103051335.GJ3187@localhost>
References: <1508986436-31966-1-git-send-email-me@tobin.cc>
 <CAGXu5jJvBKd2i-P4LVW_mHY9e3j4JEpaR4=a7dt3CcOvimcuTQ@mail.gmail.com>
 <20171030223346.GX12341@eros>
 <1509415728.26592.40.camel@perches.com>
 <20171031231619.GB3585@eros>
 <1509492793.31043.12.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1509492793.31043.12.camel@perches.com>
Subject: [kernel-hardening] Re: [PATCH V8 0/2] printk: hash addresses printed with %p
To: Joe Perches <joe@perches.com>
Cc: "Tobin C. Harding" <me@tobin.cc>, Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, LKML <linux-kernel@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Oct 31, 2017 at 04:33:13PM -0700, Joe Perches wrote:
> On Wed, 2017-11-01 at 10:16 +1100, Tobin C. Harding wrote:

> > Cool, thanks Joe I'll keep this in mind for when we get to %pa.
> 
> fyi:  There are more of these misuses of 0x%pa now:
> 
> $ git grep -E -n "0[xX]%pa[dp]?\b"
> drivers/dma/at_hdmac_regs.h:388:                 "  desc: s%pad d%pad ctrl0x%x:0x%x l0x%pad\n",
> drivers/dma/coh901318.c:1322:           dev_vdbg(COHC_2_DEV(cohc), "i %d, lli %p, ctrl 0x%x, src 0x%pad"
> drivers/dma/coh901318.c:1323:                    ", dst 0x%pad, link 0x%pad virt_link_addr 0x%p\n",
> drivers/dma/coh901318.c:2234:            "[%s] channel %d src 0x%pad dest 0x%pad size %zu\n",

Fixed and sent patches for these two.

-- 
~Vinod
