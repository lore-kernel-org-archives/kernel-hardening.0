Date: Tue, 23 Apr 2019 17:05:02 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: Re: [PATCH v2 56/79] docs: Documentation/*.txt: rename all ReST
 files to *.rst
Message-ID: <20190423170409.7b1370ac@coco.lan>
In-Reply-To: <20190423172006.GD16353@zn.tnic>
References: <cover.1555938375.git.mchehab+samsung@kernel.org>
	<cda57849a6462ccc72dcd360b30068ab6a1021c4.1555938376.git.mchehab+samsung@kernel.org>
	<20190423083135.GA11158@hirez.programming.kicks-ass.net>
	<20190423125519.GA7104@redhat.com>
	<20190423130132.GT4038@hirez.programming.kicks-ass.net>
	<20190423103053.07cf2149@lwn.net>
	<20190423171158.GG12232@hirez.programming.kicks-ass.net>
	<20190423172006.GD16353@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Borislav Petkov <bp@alien8.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Jonathan Corbet <corbet@lwn.net>, Mike Snitzer <snitzer@redhat.com>, Linux Doc Mailing List <linux-doc@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, linux-kernel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>, Kurt Schwemmer <kurt.schwemmer@microsemi.com>, Logan Gunthorpe <logang@deltatee.com>, Bjorn Helgaas <bhelgaas@google.com>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Kishon Vijay Abraham I <kishon@ti.com>, Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <maxime.ripard@bootlin.com>, Sean Paul <sean@poorly.run>, Ning Sun <ning.sun@intel.com>, Ingo Molnar <mingo@redhat.com>, Will Deacon <will.deacon@arm.com>, Alan Stern <stern@rowland.harvard.edu>, Andrea Parri <andrea.parri@amarulasolutions.com>, Boqun Feng <boqun.feng@gmail.com>, Nicholas Piggin <npiggin@gmail.com>, David Howells <dhowells@redhat.com>, Jade Alglave <j.alglave@ucl.ac.uk>, Luc Maranget <luc.maranget@inria.fr>, "Paul E. McKenney" <paulmck@linux.ibm.com>, Akira Yokosawa <akiyks@gmail.com>, Daniel Lustig <dlustig@nvidia.com>, "David S. Miller" <davem@davemloft.net>, Andreas =?UTF-8?B?RsOkcmJlcg==?= <afaerber@suse.de>, Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, Cornelia Huck <cohuck@redhat.com>, Farhan Ali <alifm@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Harry Wei <harryxiyou@gmail.com>, Alex Shi <alex.shi@linux.alibaba.com>, Jerry Hoemann <jerry.hoemann@hpe.com>, Wim Van Sebroeck <wim@linux-watchdog.org>, Guenter Roeck <linux@roeck-us.net>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Russell King <linux@armlinux.org.uk>, Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, Helge Deller <deller@gmx.de>, Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, Guan Xuetao <gxt@pku.edu.cn>, Jens Axboe <axboe@kernel.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael
 J. Wysocki" <rafael@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, Corey Minyard <minyard@acm.org>, Sumit Semwal <sumit.semwal@linaro.org>, Linus Walleij <linus.walleij@linaro.org>, Bartosz Golaszewski <bgolaszewski@baylibre.com>, Darren Hart <dvhart@infradead.org>, Andy Shevchenko <andy@infradead.org>, Stuart Hayes <stuart.w.hayes@gmail.com>, Jaroslav Kysela <perex@perex.cz>, Alex Williamson <alex.williamson@redhat.com>, Kirti Wankhede <kwankhede@nvidia.com>, Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, Steffen Klassert <steffen.klassert@secunet.com>, Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>, James Morris <jmorris@namei.org>, "Serge
 E. Hallyn" <serge@hallyn.com>, linux-wireless@vger.kernel.org, linux-pci@vger.kernel.org, devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org, tboot-devel@lists.sourceforge.net, linux-arch@vger.kernel.org, netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org, kvm@vger.kernel.org, linux-watchdog@vger.kernel.org, linux-ia64@vger.kernel.org, linux-parisc@vger.kernel.org, linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, linux-block@vger.kernel.org, linux-crypto@vger.kernel.org, openipmi-developer@lists.sourceforge.net, linaro-mm-sig@lists.linaro.org, linux-gpio@vger.kernel.org, platform-driver-x86@vger.kernel.org, iommu@lists.linux-foundation.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, Changbin Du <changbin.du@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Em Tue, 23 Apr 2019 19:20:06 +0200
Borislav Petkov <bp@alien8.de> escreveu:

> On Tue, Apr 23, 2019 at 07:11:58PM +0200, Peter Zijlstra wrote:
> > I know I'm an odd duck; but no. They're _less_ accessible for me, as
> > both a reader and author. They look 'funny' when read as a text file
> > (the only way it makes sense to read them; I spend 99% of my time on a
> > computer looking at monospace text interfaces; mutt, vim and console, in
> > that approximate order).  
> 
> +1
> 
> It is probably fine to stare at them here
> https://www.kernel.org/doc/html/latest/ and the end result is good
> for showing them in browsers but after this conversion, it is
> getting more and more painful to work with those files. For example,
> Documentation/x86/x86_64/mm.txt we use a lot. I'd hate it if I had to go
> sort out rest muck first just so that I can read it.

That's my view about how that specific file would be after
converted to ReST:

	https://git.linuxtv.org/mchehab/experimental.git/tree/Documentation/x86/x86_64/mm.rst?h=convert_rst_renames

I don't have any troubles reading/understanding it as a plain text
file, and its html output is also nice (although Sphinx 1.7.8 seems to
have some issues when parsing some cells - probably due to some bug):

	https://www.infradead.org/~mchehab/rst_conversion/x86/x86_64/mm.html

> 
> I think we can simply leave some text files be text files and be done
> with it.

Changbin's approach was somewhat close to what you want. He simply
prepended the tables with ::, in order to show them as plain old
ascii:

	https://lore.kernel.org/lkml/20190423162932.21428-60-changbin.du@gmail.com/

Both equally works, from ReST conversion PoV. I'm fine ether way.

I prefer my approach, as, IMHO, it is visually nicer on both text and
html versions, but his approach is likely easier to maintain, as doing
ascii artwork by hand is sometimes painful.

Thanks,
Mauro
