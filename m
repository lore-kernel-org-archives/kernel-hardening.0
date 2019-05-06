Date: Mon, 6 May 2019 16:50:59 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: Re: [PATCH v2 56/79] docs: Documentation/*.txt: rename all ReST
 files to *.rst
Message-ID: <20190506165059.51eb2959@coco.lan>
In-Reply-To: <20190424065209.GC4038@hirez.programming.kicks-ass.net>
References: <cover.1555938375.git.mchehab+samsung@kernel.org>
	<cda57849a6462ccc72dcd360b30068ab6a1021c4.1555938376.git.mchehab+samsung@kernel.org>
	<20190423083135.GA11158@hirez.programming.kicks-ass.net>
	<20190423125519.GA7104@redhat.com>
	<20190423130132.GT4038@hirez.programming.kicks-ass.net>
	<20190423103053.07cf2149@lwn.net>
	<20190423171158.GG12232@hirez.programming.kicks-ass.net>
	<20190423172006.GD16353@zn.tnic>
	<20190423170409.7b1370ac@coco.lan>
	<20190423213816.GE16353@zn.tnic>
	<20190424065209.GC4038@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Borislav Petkov <bp@alien8.de>, Jonathan Corbet <corbet@lwn.net>, Mike Snitzer <snitzer@redhat.com>, Mauro Carvalho Chehab <mchehab@infradead.org>, linux-kernel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>, Kurt Schwemmer <kurt.schwemmer@microsemi.com>, Logan Gunthorpe <logang@deltatee.com>, Bjorn Helgaas <bhelgaas@google.com>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Kishon Vijay Abraham I <kishon@ti.com>, Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <maxime.ripard@bootlin.com>, Sean Paul <sean@poorly.run>, Ning Sun <ning.sun@intel.com>, Ingo Molnar <mingo@redhat.com>, Will Deacon <will.deacon@arm.com>, Alan Stern <stern@rowland.harvard.edu>, Andrea Parri <andrea.parri@amarulasolutions.com>, Boqun Feng <boqun.feng@gmail.com>, Nicholas Piggin <npiggin@gmail.com>, David Howells <dhowells@redhat.com>, Jade Alglave <j.alglave@ucl.ac.uk>, Luc Maranget <luc.maranget@inria.fr>, "Paul E. McKenney" <paulmck@linux.ibm.com>, Akira Yokosawa <akiyks@gmail.com>, Daniel Lustig <dlustig@nvidia.com>, "David S. Miller" <davem@davemloft.net>, Andreas =?UTF-8?B?RsOkcmJlcg==?= <afaerber@suse.de>, Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, Cornelia Huck <cohuck@redhat.com>, Farhan Ali <alifm@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Harry Wei <harryxiyou@gmail.com>, Alex Shi <alex.shi@linux.alibaba.com>, Jerry Hoemann <jerry.hoemann@hpe.com>, Wim Van Sebroeck <wim@linux-watchdog.org>, Guenter Roeck <linux@roeck-us.net>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Russell King <linux@armlinux.org.uk>, Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, Helge Deller <deller@gmx.de>, Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, Guan Xuetao <gxt@pku.edu.cn>, Jens Axboe <axboe@kernel.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael
 J. Wysocki" <rafael@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, Corey Minyard <minyard@acm.org>, Sumit Semwal <sumit.semwal@linaro.org>, Linus Walleij <linus.walleij@linaro.org>, Bartosz Golaszewski <bgolaszewski@baylibre.com>, Darren Hart <dvhart@infradead.org>, Andy Shevchenko <andy@infradead.org>, Stuart Hayes <stuart.w.hayes@gmail.com>, Jaroslav Kysela <perex@perex.cz>, Alex Williamson <alex.williamson@redhat.com>, Kirti Wankhede <kwankhede@nvidia.com>, Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, Steffen Klassert <steffen.klassert@secunet.com>, Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>, James Morris <jmorris@namei.org>, "Serge
 E. Hallyn" <serge@hallyn.com>, linux-wireless@vger.kernel.org, linux-pci@vger.kernel.org, devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org, tboot-devel@lists.sourceforge.net, linux-arch@vger.kernel.org, netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org, kvm@vger.kernel.org, linux-watchdog@vger.kernel.org, linux-ia64@vger.kernel.org, linux-parisc@vger.kernel.org, linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, linux-block@vger.kernel.org, linux-crypto@vger.kernel.org, openipmi-developer@lists.sourceforge.net, linaro-mm-sig@lists.linaro.org, linux-gpio@vger.kernel.org, platform-driver-x86@vger.kernel.org, iommu@lists.linux-foundation.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, Changbin Du <changbin.du@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Em Wed, 24 Apr 2019 08:52:09 +0200
Peter Zijlstra <peterz@infradead.org> escreveu:

> On Tue, Apr 23, 2019 at 11:38:16PM +0200, Borislav Petkov wrote:
> > If that is all the changes it would need, then I guess that's ok. Btw,
> > those rst-conversion patches don't really show what got changed. Dunno
> > if git can even show that properly. I diffed the two files by hand to
> > see what got changed, see end of mail.  
> 
> That is not a happy diff; that table has gotten waay worse to read due
> to all that extra table crap.

Not that I'm proposing such change, but, as a reference, I just discovered 
today that there's a way to make it even lighter than it is while still
showing it as a table:

=================  ======== ==   ================  ===== ==  ===========================================================
    Start addr        Offset        End addr         Size    VM area description
-----------------  -----------   ----------------  --------  -----------------------------------------------------------
 0000000000000000      0         00007fffffffffff    128 TB   user-space virtual memory, different per mm

 0000800000000000   +128    TB   ffff7fffffffffff   ~16M TB   ... huge, almost 64 bits wide hole of non-canonical
                                                                  virtual memory addresses up to the -128 TB
                                                                  starting offset of kernel mappings.

-----------------  -------- --   ----------------  ----- --  -----------------------------------------------------------
-                                                            Kernel-space virtual memory, shared between all processes:
-----------------  -----------   ----------------  --------  -----------------------------------------------------------

 ffff800000000000   -128    TB   ffff87ffffffffff      8 TB   ... guard hole, also reserved for hypervisor
 ffff880000000000   -120    TB   ffff887fffffffff    0.5 TB   LDT remap for PTI
 ffff888000000000   -119.5  TB   ffffc87fffffffff     64 TB   direct mapping of all physical memory (page_offset_base)
 ffffc88000000000    -55.5  TB   ffffc8ffffffffff    0.5 TB   ... unused hole
 ffffc90000000000    -55    TB   ffffe8ffffffffff     32 TB   vmalloc/ioremap space (vmalloc_base)
 ffffe90000000000    -23    TB   ffffe9ffffffffff      1 TB   ... unused hole
 ffffea0000000000    -22    TB   ffffeaffffffffff      1 TB   virtual memory map (vmemmap_base)
 ffffeb0000000000    -21    TB   ffffebffffffffff      1 TB   ... unused hole
 ffffec0000000000    -20    TB   fffffbffffffffff     16 TB   KASAN shadow memory
-----------------  -------- --   ----------------  ----- --  -----------------------------------------------------------
-                                                            Identical layout to the 56-bit one from here on:
-----------------  -----------   ----------------  --------  -----------------------------------------------------------

 fffffc0000000000     -4    TB   fffffdffffffffff      2 TB   ... unused hole
                                                              vaddr_end for KASLR
 fffffe0000000000     -2    TB   fffffe7fffffffff    0.5 TB   cpu_entry_area mapping
 fffffe8000000000     -1.5  TB   fffffeffffffffff    0.5 TB   ... unused hole
 ffffff0000000000     -1    TB   ffffff7fffffffff    0.5 TB   %esp fixup stacks
 ffffff8000000000   -512    GB   ffffffeeffffffff    444 GB   ... unused hole
 ffffffef00000000    -68    GB   fffffffeffffffff     64 GB   EFI region mapping space
 ffffffff00000000     -4    GB   ffffffff7fffffff      2 GB   ... unused hole
 ffffffff80000000     -2    GB   ffffffff9fffffff    512 MB   kernel text mapping, mapped to physical address 0
 ffffffff80000000  -2048    MB
 ffffffffa0000000  -1536    MB   fffffffffeffffff   1520 MB   module mapping space
 ffffffffff000000    -16    MB
    FIXADDR_START   ~-11    MB   ffffffffff5fffff   ~0.5 MB   kernel-internal fixmap range, variable size and offset
 ffffffffff600000    -10    MB   ffffffffff600fff      4 kB   legacy vsyscall ABI
 ffffffffffe00000     -2    MB   ffffffffffffffff      2 MB   ... unused hole
=================  ======== ==   ================  ===== ==  ===========================================================

If one wants the table headers as such, an extra line is required:


=================  ======== ==   ================  ===== ==  ===========================================================
    Start addr        Offset        End addr         Size    VM area description
-----------------  -----------   ----------------  --------  -----------------------------------------------------------
=================  ======== ==   ================  ===== ==  ===========================================================

<snip/>

=================  ======== ==   ================  ===== ==  ===========================================================


The output using this approach and a markup to use mono-spaced cells
e. g. either using ..raw or using .. cssclass as commented before in
this thread is at:

	https://www.infradead.org/~mchehab/rst_conversion/x86/x86_64/mm_alternative.html

Just converted the first table, keeping the other as a literal block.

Thanks,
Mauro
