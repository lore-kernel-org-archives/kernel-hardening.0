Date: Fri, 12 May 2017 01:07:41 -0700
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20170512080741.GA32228@infradead.org>
References: <20170428153213.137279-1-thgarnie@google.com>
 <CAJcbSZGQsRVg3QZ9QfLn2HBC+RP-7fUTab0bYDJ455d8y8GyNw@mail.gmail.com>
 <20170508073352.caqe3fqf7nuxypgi@gmail.com>
 <20170508124621.GA20705@kroah.com>
 <20170509064522.anusoikaalvlux3w@gmail.com>
 <20170509085659.GA32555@infradead.org>
 <CALCETrUh8NO2scaqEM48K70Fo2+V3=Cpyk4JurCDiCYp4nm_+g@mail.gmail.com>
 <20170512070012.7dysuhbkcas7ibaj@gmail.com>
 <20170512071549.GP390@ZenIV.linux.org.uk>
 <20170512073521.GA7091@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170512073521.GA7091@infradead.org>
Subject: Re: [kernel-hardening] Re: [PATCH v9 1/4] syscalls: Verify address
 limit before returning to user-mode
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Ingo Molnar <mingo@kernel.org>, Andy Lutomirski <luto@kernel.org>, Christoph Hellwig <hch@infradead.org>, Greg KH <greg@kroah.com>, Thomas Garnier <thgarnie@google.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Dave Hansen <dave.hansen@intel.com>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, David Howells <dhowells@redhat.com>, =?iso-8859-1?Q?Ren=E9?= Nyffenegger <mail@renenyffenegger.ch>, Andrew Morton <akpm@linux-foundation.org>, "Paul E . McKenney" <paulmck@linux.vnet.ibm.com>, "Eric W . Biederman" <ebiederm@xmission.com>, Oleg Nesterov <oleg@redhat.com>, Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Paolo Bonzini <pbonzini@redhat.com>, Rik van Riel <riel@redhat.com>, Kees Cook <keescook@chromium.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Borislav Petkov <bp@alien8.de>, Brian Gerst <brgerst@gmail.com>, "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Russell King <linux@armlinux.org.uk>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, Mark Rutland <mark.rutland@arm.com>, James Morse <james.morse@arm.com>, linux-s390 <linux-s390@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux API <linux-api@vger.kernel.org>, the arch/x86 maintainers <x86@kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Mauro Carvalho Chehab <mchehab@kernel.org>, Palash Bandyopadhyay <palash.bandyopadhyay@conexant.com>, Eric Van Hensbergen <ericvh@gmail.com>, Richard Weinberger <richard@nod.at>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, May 12, 2017 at 12:35:21AM -0700, Christoph Hellwig wrote:
> On Fri, May 12, 2017 at 08:15:49AM +0100, Al Viro wrote:
> > And converting everything to ->read_iter()/->write_iter() means an insane
> > amount of code churn, not to mention coping with random bogosities in
> > semantics.  ->read() and ->write() are going to stay around, pretty
> > much indefinitely.
> 
> But I don't think kernel users of them have to.  I've been digging
> through the calllers and will send an analysis to the list in a bit.

Ok, here is the cleaned up list.  The targets for in-kernel I/O
are basically regular files on normal fs, block devices, pipes
and sockets, with a few narrow exceptions and a few unclear cases.

I've added a few maintainers to Cc to clarify, and the list is below:

When looking at kernel_read/kernel_readv/kernel_write/__kernel_write
instances, or vfs_read/vfs_readv/vfs_write/vfs_writev inststances with
set_fs tricks most of them simply require a regular file on a "real"
fs or a block device, pipe, socket:

 - various binary loaders: need to be regular files (+ on a "real" fs)
 - nandsim: expect a regular file or maybe a block device
 - code: expects a regular file
 - ecryptfs: expects a regular file
 - splice: can be a regular file or device file
 - security/keys: regular file
 - cachefiles: needs to be a regular file
 - coredump: usually a regular file, but possibly a pipe
 - acct: regular file
 - target: regular file
 - nfsd: regular file
 - lustre: regular file
 - f_mass_storage: regular file, or maybe block device
 - autofs: pipe
 - btrfs: regular file / pipe / socket
 - ima: regular file on specific file systems

Then there are a few interesting ones with specific targets:

 - sysctl: regular file on procfs
 - mconsole: procfs as far as I can tell.  Might be able to further
   narrow it down?
 - ashmem: regular file on shmem

The nommu mmap code needs to read everything that wants to support
a MAP_PRIVATE mmap, but as far as a I can tell: do a) address limits
not matter for nommu, and b) I have no f***cking idea why it doesn't
use readpage(s) to start with like the MMU code.

And a few that I can't figure:

 - cx25821: no idea what this opens, need to confirm with the maintainers
   (on Cc)
 - 9p: not clear.  looks like it might be sockets/pipes
 
 Last but not least we have a driver that's a complete mess:

 - series2002: /dev/tty* (drivers is in staging and needs to be rewritten
   using the proper in-kernel APIs anyway)
 
