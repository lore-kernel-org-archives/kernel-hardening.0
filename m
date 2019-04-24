Date: Wed, 24 Apr 2019 07:40:07 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: Re: [PATCH v2 56/79] docs: Documentation/*.txt: rename all ReST
 files to *.rst
Message-ID: <20190423232325.679c100b@coco.lan>
In-Reply-To: <20190423213816.GE16353@zn.tnic>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Borislav Petkov <bp@alien8.de>
Cc: Peter Zijlstra <peterz@infradead.org>, Jonathan Corbet <corbet@lwn.net>, Mike Snitzer <snitzer@redhat.com>, Linux Doc Mailing List <linux-doc@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, linux-kernel@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>, Kurt Schwemmer <kurt.schwemmer@microsemi.com>, Logan Gunthorpe <logang@deltatee.com>, Bjorn Helgaas <bhelgaas@google.com>, Alasdair Kergon <agk@redhat.com>, dm-devel@redhat.com, Kishon Vijay Abraham I <kishon@ti.com>, Rob Herring <robh+dt@kernel.org>, Mark Rutland <mark.rutland@arm.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, David Airlie <airlied@linux.ie>, Daniel Vetter <daniel@ffwll.ch>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <maxime.ripard@bootlin.com>, Sean Paul <sean@poorly.run>, Ning Sun <ning.sun@intel.com>, Ingo Molnar <mingo@redhat.com>, Will Deacon <will.deacon@arm.com>, Alan Stern <stern@rowland.harvard.edu>, Andrea Parri <andrea.parri@amarulasolutions.com>, Boqun Feng <boqun.feng@gmail.com>, Nicholas Piggin <npiggin@gmail.com>, David Howells <dhowells@redhat.com>, Jade Alglave <j.alglave@ucl.ac.uk>, Luc Maranget <luc.maranget@inria.fr>, "Paul E. McKenney" <paulmck@linux.ibm.com>, Akira Yokosawa <akiyks@gmail.com>, Daniel Lustig <dlustig@nvidia.com>, "David S. Miller" <davem@davemloft.net>, Andreas =?UTF-8?B?RsOkcmJlcg==?= <afaerber@suse.de>, Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, Cornelia Huck <cohuck@redhat.com>, Farhan Ali <alifm@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>, Martin Schwidefsky <schwidefsky@de.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Harry Wei <harryxiyou@gmail.com>, Alex Shi <alex.shi@linux.alibaba.com>, Jerry Hoemann <jerry.hoemann@hpe.com>, Wim Van Sebroeck <wim@linux-watchdog.org>, Guenter Roeck <linux@roeck-us.net>, Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org, Russell King <linux@armlinux.org.uk>, Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, Helge Deller <deller@gmx.de>, Yoshinori Sato <ysato@users.sourceforge.jp>, Rich Felker <dalias@libc.org>, Guan Xuetao <gxt@pku.edu.cn>, Jens Axboe <axboe@kernel.dk>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael
 J. Wysocki" <rafael@kernel.org>, Arnd Bergmann <arnd@arndb.de>, Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>, Corey Minyard <minyard@acm.org>, Sumit Semwal <sumit.semwal@linaro.org>, Linus Walleij <linus.walleij@linaro.org>, Bartosz Golaszewski <bgolaszewski@baylibre.com>, Darren Hart <dvhart@infradead.org>, Andy Shevchenko <andy@infradead.org>, Stuart Hayes <stuart.w.hayes@gmail.com>, Jaroslav Kysela <perex@perex.cz>, Alex Williamson <alex.williamson@redhat.com>, Kirti Wankhede <kwankhede@nvidia.com>, Christoph Hellwig <hch@lst.de>, Marek Szyprowski <m.szyprowski@samsung.com>, Robin Murphy <robin.murphy@arm.com>, Steffen Klassert <steffen.klassert@secunet.com>, Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>, James Morris <jmorris@namei.org>, "Serge
 E. Hallyn" <serge@hallyn.com>, linux-wireless@vger.kernel.org, linux-pci@vger.kernel.org, devicetree@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org, tboot-devel@lists.sourceforge.net, linux-arch@vger.kernel.org, netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org, kvm@vger.kernel.org, linux-watchdog@vger.kernel.org, linux-ia64@vger.kernel.org, linux-parisc@vger.kernel.org, linux-sh@vger.kernel.org, sparclinux@vger.kernel.org, linux-block@vger.kernel.org, linux-crypto@vger.kernel.org, openipmi-developer@lists.sourceforge.net, linaro-mm-sig@lists.linaro.org, linux-gpio@vger.kernel.org, platform-driver-x86@vger.kernel.org, iommu@lists.linux-foundation.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, Changbin Du <changbin.du@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

Em Tue, 23 Apr 2019 23:38:16 +0200
Borislav Petkov <bp@alien8.de> escreveu:

> On Tue, Apr 23, 2019 at 05:05:02PM -0300, Mauro Carvalho Chehab wrote:
> > That's my view about how that specific file would be after
> > converted to ReST:
> > 
> > 	https://git.linuxtv.org/mchehab/experimental.git/tree/Documentation/x86/x86_64/mm.rst?h=convert_rst_renames
> > 
> > I don't have any troubles reading/understanding it as a plain text
> > file,  
> 
> If that is all the changes it would need, then I guess that's ok. Btw,
> those rst-conversion patches don't really show what got changed. Dunno
> if git can even show that properly. I diffed the two files by hand to
> see what got changed, see end of mail.

Well, you can use git show -M01 and it will likely show what
changed. The thing is that plain diff is not very good showing
diffs on text files. I suspect that using some tool like wdiff
would give a better view of such changes.

> So I guess if table in rst means, one needs to draw rows and columns, I
> guess that's ok. It's not like I have to do it every day.

Yes, for complex tables, one needs to draw rows/columns. For simple
tables, all you need to do is something like:

  ====== ========   ====    ========    ===
  -      CONT PTE    PMD    CONT PMD    PUD
  ====== ========   ====    ========    ===
  4K:         64K     2M         32M     1G
  16K:         2M    32M          1G
  64K:         2M   512M         16G
  ====== ========   ====    ========    ===

in order to teach Sphinx where each column starts/stops, and
(optionally) show the table titles in bold.

(that's from Documentation/arm64/hugetlbpage.rst conversion)

> But exactly this - *having* to do rst formatting would mean a lot of
> getting used to and people writing something which is not necessarily
> correct rst and someone else fixing up after them.

Yeah, one has to take the conversion effort, but once done, it should be
easy to keep it updated.

> > and its html output is also nice (although Sphinx 1.7.8 seems to
> > have some issues when parsing some cells - probably due to some bug):
> > 
> > 	https://www.infradead.org/~mchehab/rst_conversion/x86/x86_64/mm.html  
> 
> I don't know how that looks in your browser but in mine those addresses
> are not in monospaced font and there's no properly reading them.
> 
> And yap, the cells parsing fun I see too.

Font selection is one of the things would require some markup, as a
plain text file doesn't have font changes.

There are several ways to make it use a monospaced font.

The straight forward way would be to place everything that it is
monospaced inside ``double quotes``, with is the ReST way to mark
a literal block inside a text. IMHO, that would add too much
"noise" at the tables.

Another possibility would be to do:

	.. raw:: html

	       <head><style>td { font-family: monospace, monospace; }</style></head>

(the double monospace here is not a mistake - it is due to a known
bug^H^H^Hfeature on some browsers[1])

[1] https://stackoverflow.com/questions/38781089/font-family-monospace-monospace

IMO, the best alternative would be to add a new class to the css file,
and use it whenever we need a table with monospaced font, e. g.:

diff --git a/Documentation/sphinx-static/theme_overrides.css b/Documentation/sphinx-static/theme_overrides.css
index e21e36cd6761..0948de6651f8 100644
--- a/Documentation/sphinx-static/theme_overrides.css
+++ b/Documentation/sphinx-static/theme_overrides.css
@@ -125,3 +125,7 @@ div[class^="highlight"] pre {
         color: inherit;
     }
 }
+
+table.monospaced {
+	font-family: monospace, monospace;
+}
diff --git a/Documentation/x86/x86_64/mm.rst b/Documentation/x86/x86_64/mm.rst
index e8a92fa0f9b2..704bad5c5130 100644
--- a/Documentation/x86/x86_64/mm.rst
+++ b/Documentation/x86/x86_64/mm.rst
@@ -18,6 +18,8 @@ Notes:
    notation than "16 EB", which few will recognize at first sight as 16 exabytes.
    It also shows it nicely how incredibly large 64-bit address space is.
 
+.. cssclass:: monospaced
+
 +-----------------+------------+------------------+---------+-----------------------------------------------------------+
 |   Start addr    |   Offset   |     End addr     |  Size   | VM area description                                       |
 +=================+============+==================+=========+===========================================================+

(patch on the top of this tree
https://git.linuxtv.org/mchehab/experimental.git/tree/Documentation/x86/x86_64/mm.rst?h=convert_rst_renames)

The ..cssclass:: markup on the above example will be applied just to
the table below it. So, with that, it is possible to have normal and
monospaced tables mixed (if you apply the above patch, you'll see
that just the first table will use monospaced fonts).

- 

Personally, I don't care much with monospaced fonts on this table. After
all, if I want to see it monospaced, I can simply click at the
"View page source" at the browser, and it will display the file as a
plain old monospaced text file.

Thanks,
Mauro
