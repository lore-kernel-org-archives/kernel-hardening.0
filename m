Date: Tue, 23 Apr 2019 12:07:38 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: Re: [PATCH v2 56/79] docs: Documentation/*.txt: rename all ReST
 files to *.rst
Message-ID: <20190423120738.3be8337e@coco.lan>
In-Reply-To: <20190423132100.GB7132@redhat.com>
References: <cover.1555938375.git.mchehab+samsung@kernel.org>
	<cda57849a6462ccc72dcd360b30068ab6a1021c4.1555938376.git.mchehab+samsung@kernel.org>
	<20190423083135.GA11158@hirez.programming.kicks-ass.net>
	<20190423125519.GA7104@redhat.com>
	<20190423130132.GT4038@hirez.programming.kicks-ass.net>
	<20190423132100.GB7132@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Mike Snitzer <snitzer@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Linux Doc Mailing List <linux-doc@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>, Johannes Berg <johannes@sipsolutions.net>, Kurt Schwemmer <kurt.schwemmer@microsemi.com>, Logan Gunthorpe <logang@deltatee.com>, Bjorn Helgaas <bhelgaas@google.com>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Kishon Vijay Abraham I <kishon@ti.com>, Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <maxime.ripard@bootlin.com>, Sean Paul <sean@poorly.run>, Ning Sun <ning.sun@intel.com>, Ingo Molnar <mingo@redhat.com>, Will Deacon <will.deacon@arm.com>, Alan Stern <stern@rowland.harvard.edu>, Andrea Parri <andrea.parri@amarulasolutions.com>, Boqun Feng <boqun.feng@gmail.com>, Nicholas Piggin <npiggin@gmail.com>, David Howells <dhowells@redhat.com>, Jade Alglave <j.alglave@ucl.ac.uk>, Luc Maranget <luc.maranget@inria.fr>, "Paul E. McKenney" <paulmck@linux.ibm.com>, Akira Yokosawa <akiyks@gmail.com>, Daniel Lustig <dlustig@nvidia.com>, "David S. Miller" <davem@davemloft.net>, Andreas =?UTF-8?B?RsOkcmJlcg==?= <afaerber@suse.de>, Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, Cornelia Huck <cohuck@redhat.com>, Farhan Ali <alifm@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Harry Wei <harryxiyou@gmail.com>, Alex Shi <alex.shi@linux.alibaba.com>, Jerry Hoemann <jerry.hoemann@hpe.com>, Wim Van Sebroeck <wim@linux-watchdog.org>, Guenter Roeck <linux@roeck-us.net>, Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>, "H.
 Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Russell King <linux@armlinux.org.uk>, Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, Helge Deller <deller@gmx.de>, Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, Guan Xuetao <gxt@pku.edu.cn>, Jens Axboe <axboe@kernel.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, Corey Minyard <minyard@acm.org>, Sumit Semwal <sumit.semwal@linaro.org>, Linus Walleij <linus.walleij@linaro.org>, Bartosz Golaszewski <bgolaszewski@baylibre.com>, Darren Hart <dvhart@infradead.org>, Andy Shevchenko <andy@infradead.org>, Stuart Hayes <stuart.w.hayes@gmail.com>, Jaroslav Kysela <perex@perex.cz>, Alex Williamson <alex.williamson@redhat.com>, Kirti Wankhede <kwankhede@nvidia.com>, Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, Steffen Klassert <steffen.klassert@secunet.com>, Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>, James Morris <jmorris@namei.org>, "Serge
 E. Hallyn" <serge@hallyn.com>, linux-wireless@vger.kernel.org, linux-pci@vger.kernel.org, devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org, tboot-devel@lists.sourceforge.net, linux-arch@vger.kernel.org, netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org, kvm@vger.kernel.org, linux-watchdog@vger.kernel.org, linux-ia64@vger.kernel.org, linux-parisc@vger.kernel.org, linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, linux-block@vger.kernel.org, linux-crypto@vger.kernel.org, openipmi-developer@lists.sourceforge.net, linaro-mm-sig@lists.linaro.org, linux-gpio@vger.kernel.org, platform-driver-x86@vger.kernel.org, iommu@lists.linux-foundation.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Em Tue, 23 Apr 2019 09:21:00 -0400
Mike Snitzer <snitzer@redhat.com> escreveu:

> On Tue, Apr 23 2019 at  9:01am -0400,
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Tue, Apr 23, 2019 at 08:55:19AM -0400, Mike Snitzer wrote:  
> > > On Tue, Apr 23 2019 at  4:31am -0400,
> > > Peter Zijlstra <peterz@infradead.org> wrote:
> > >   
> > > > On Mon, Apr 22, 2019 at 10:27:45AM -0300, Mauro Carvalho Chehab wrote:
> > > >   
> > > > >  .../{atomic_bitops.txt => atomic_bitops.rst}  |  2 +  
> > > > 
> > > > What's happend to atomic_t.txt, also NAK, I still occationally touch
> > > > these files.  
> > > 
> > > Seems Mauro's point is in the future we need to touch these .rst files
> > > in terms of ReST compatible changes.
> > > 
> > > I'm dreading DM documentation changes in the future.. despite Mauro and
> > > Jon Corbet informing me that ReST is simple, etc.  

ReST is simple[1], and neither Jon or me wants to burden developers to
use complex documents all over the Kernel tree. ReST is just a way to 
make the documents with similar visual. The main advantage of ReST is
that documents can be better organized, as they will be inside some
index.rst file.

[1] Ok, as any document, you could write an easy or hard to read stuff.
The way we're using on most places is to be just a coding style with
benefits. I wrote a quick 101 guide to ReST at the end, with all you
probably need to know about it.

So, for example, in the specific case of atomic_bitops, all it takes for
it to be parsed by Sphinx is to rename it to .rst. With that, it can be
added into an index.rst file, like at Documentation/driver-api/index.rst.

The document, as is, will be displayed like this:

	https://www.infradead.org/~mchehab/rst_conversion/driver-api/atomic_bitops.html?highlight=atomic_t

And the original text file can also be seen from the output data:

	https://www.infradead.org/~mchehab/rst_conversion/_sources/driver-api/atomic_bitops.rst.txt

> > 
> > Well, it _can_ be simple, I've seen examples of rst that were not far
> > from generated HTML contents. And I must give Jon credit for not
> > accepting that atrocious crap.
> > 
> > But yes, I have 0 motivation to learn or abide by rst. It simply doesn't
> > give me anything in return. There is no upside, only worse text files :/  
> 
> Right, but these changes aren't meant for our benefit.  They are for
> users who get cleaner web accessible Linux kernel docs.  Seems the
> decision has been made that the users' benefit, and broader
> modernization of Linux docs, outweighs the inconvenience for engineers
> who maintain the content of said documentation.

> This kind of thing happens a lot these days: pile on engineers, they can
> take it :/

Yes, that's the main goal: ensure that more people will see the
documents and write less crappy code. So, overall, reducing the
time we spent with reviews of bad code.


----

=================================
My 101 ReST quick reference guide
=================================

Basically, a "quick" ReST guide for those that don't want to learn it
and like to have an easy to read text document would be

1) to format documents like:

	=========
	Doc Title
	=========

	foo chapter
	===========

	bar section
	-----------

	foobar sub-section
	^^^^^^^^^^^^^^^^^^

	foobarzeta sub-sub-section
	..........................

(the actual character used to mark the titles can be different,
provided that you use the same character for the same title
level - the above is just the way *I* use, as it makes easier for
me to remember the title level).

2) remember that ReST considers new lines with same indentation as
   belonging to the same paragraph. So,

	foo
	bar

is identical to:

	foo bar

while
	foo
	   bar

will make "foo" bold, and write bar on the next line. So, if you
want to have them on two separate lines on its output, it should
be either write it as:

	foo

	bar

or you could use a list:

	- foo
	- bar

Btw, *a lot* of Kernel documents already have the above format.

3) literal values should be either inside ``foo``, `foo` or on an
   indented line after a ::, like:

	example::

		# some_command_to_be_typed

If you follow those three simple rules, your document will be properly
parsed. The above covers 90% of what we normally use.

Tables are also easy to write there, as it recognizes two ways to write
ascii tables, with are already popular ways to write them.

So, those are valid tables:

Without a title:

	===   ===============
	foo   foo description
	bar   bar description
	===   ===============


	+-------+-----------------+
	| foo   | foo description |
	+-------+-----------------+
	| bar   | bar description |
	+-------+-----------------+

(both will produce exactly the same output)

With a title:

	===== ===============
	field description
	===== ===============
	foo   foo description
	bar   bar description
	===   ===============

	+-------+-----------------+
	| field | description     |
	+=======+=================+
	| foo   | foo description |
	+-------+-----------------+
	| bar   | bar description |
	+-------+-----------------+

(both will produce exactly the same output)

This is not too different on what we usually do on documents - except that
some documents sometimes use UTF8, or a different character set to mark the
table lines. So the "conversion" is simply to follow one of the above
styles.

Thanks,
Mauro
