Date: Mon, 13 Nov 2017 15:35:11 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171113043511.GH11398@eros>
References: <1510050731-32446-1-git-send-email-me@tobin.cc>
 <20171111231007.iirqce3r7xqqnxd3@node.shutemov.name>
 <20171112230646.GM19752@eros>
 <20171113033728.wheztgb2hbc74lj2@node.shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20171113033728.wheztgb2hbc74lj2@node.shutemov.name>
Subject: [kernel-hardening] Re: [PATCH v4] scripts: add leaking_addresses.pl
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: kernel-hardening@lists.openwall.com, "Jason A. Donenfeld" <Jason@zx2c4.com>, Theodore Ts'o <tytso@mit.edu>, Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, "Roberts, William C" <william.c.roberts@intel.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <wilal.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, linux-kernel@vger.kernel.org, Network Development <netdev@vger.kernel.org>, David Miller <davem@davemloft.net>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Nov 13, 2017 at 06:37:28AM +0300, Kirill A. Shutemov wrote:
> On Mon, Nov 13, 2017 at 10:06:46AM +1100, Tobin C. Harding wrote:
> > On Sun, Nov 12, 2017 at 02:10:07AM +0300, Kirill A. Shutemov wrote:
> > > On Tue, Nov 07, 2017 at 09:32:11PM +1100, Tobin C. Harding wrote:
> > > > Currently we are leaking addresses from the kernel to user space. This
> > > > script is an attempt to find some of those leakages. Script parses
> > > > `dmesg` output and /proc and /sys files for hex strings that look like
> > > > kernel addresses.
> > > > 
> > > > Only works for 64 bit kernels, the reason being that kernel addresses
> > > > on 64 bit kernels have 'ffff' as the leading bit pattern making greping
> > > > possible. On 32 kernels we don't have this luxury.
> > > 
> > > Well, it's not going to work as well as intented on x86 machine with
> > > 5-level paging. Kernel address space there starts at 0xff10000000000000.
> > > It will still catch pointers to kernel/modules text, but the rest is
> > > outside of 0xffff... space. See Documentation/x86/x86_64/mm.txt.
> > 
> > Thanks for the link. So it looks like we need to refactor the kernel
> > address regular expression into a function that takes into account the
> > machine architecture and the number of page table levels. We will need
> > to add this to the false positive checks also.
> > 
> > > Not sure if we care. It won't work too for other 64-bit architectrues that
> > > have more than 256TB of virtual address space.
> > 
> > Is this because of the virtual memory map?
> 
> On x86 direct mapping is the nearest thing we have to userspace.
> 
> > Did you mean 512TB?
> 
> No, I mean 256TB.
> 
> You have all kernel memory in the range from 0xffff000000000000 to
> 0xffffffffffffffff if you have 256 TB of virtual address space. If you
> hvae more, some thing might be ouside the range.

Doesn't 4-level paging already limit a system to 64TB of memory? So any
system better equipped than this will use 5-level paging right? If I am
totally talking rubbish please ignore, I'm appreciative that you pointed
out the limitation already. Perhaps we can add a comment to the script

# Script may miss some addresses on machines with more than 256TB of
# memory.

thanks,
Tobin.
