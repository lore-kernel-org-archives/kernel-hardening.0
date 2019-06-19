Date: Wed, 19 Jun 2019 07:22:18 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: Re: [PATCH v1 12/22] docs: driver-api: add .rst files from the main
 dir
Message-ID: <20190619072218.4437f891@coco.lan>
In-Reply-To: <CAKMK7uGM1aZz9yg1kYM8w2gw_cS6Eaynmar-uVurXjK5t6WouQ@mail.gmail.com>
References: <cover.1560890771.git.mchehab+samsung@kernel.org>
	<b0d24e805d5368719cc64e8104d64ee9b5b89dd0.1560890772.git.mchehab+samsung@kernel.org>
	<CAKMK7uGM1aZz9yg1kYM8w2gw_cS6Eaynmar-uVurXjK5t6WouQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Daniel Vetter <daniel@ffwll.ch>
Cc: Linux Doc Mailing List <linux-doc@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Jonathan Corbet <corbet@lwn.net>, Johannes Berg <johannes@sipsolutions.net>, Kurt Schwemmer <kurt.schwemmer@microsemi.com>, Logan Gunthorpe <logang@deltatee.com>, Bjorn Helgaas <bhelgaas@google.com>, Alan Stern <stern@rowland.harvard.edu>, Andrea Parri <andrea.parri@amarulasolutions.com>, Will Deacon <will.deacon@arm.com>, Peter Zijlstra <peterz@infradead.org>, Boqun Feng <boqun.feng@gmail.com>, Nicholas Piggin <npiggin@gmail.com>, David Howells <dhowells@redhat.com>, Jade Alglave <j.alglave@ucl.ac.uk>, Luc Maranget <luc.maranget@inria.fr>, "Paul E. McKenney" <paulmck@linux.ibm.com>, Akira Yokosawa <akiyks@gmail.com>, Daniel Lustig <dlustig@nvidia.com>, Stuart Hayes <stuart.w.hayes@gmail.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Darren Hart <dvhart@infradead.org>, Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>, Ohad Ben-Cohen <ohad@wizery.com>, Bjorn Andersson <bjorn.andersson@linaro.org>, Corey Minyard <minyard@acm.org>, Marc Zyngier <marc.zyngier@arm.com>, William Breathitt Gray <vilhelm.gray@gmail.com>, Jaroslav Kysela <perex@perex.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>, Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>, "David S. Miller" <davem@davemloft.net>, Masami Hiramatsu <mhiramat@kernel.org>, Johannes Thumshirn <morbidrsa@gmail.com>, Steffen Klassert <steffen.klassert@secunet.com>, Sudip Mukherjee <sudipm.mukherjee@gmail.com>, Andreas =?UTF-8?B?RsOkcmJlcg==?= <afaerber@suse.de>, Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, Rodolfo Giometti <giometti@enneenne.com>, Richard Cochran <richardcochran@gmail.com>, Thierry Reding <thierry.reding@gmail.com>, Sumit Semwal <sumit.semwal@linaro.org>, Gustavo Padovan <gustavo@padovan.org>, Jens Wiklander <jens.wiklander@linaro.org>, Kirti Wankhede <kwankhede@nvidia.com>, Alex Williamson <alex.williamson@redhat.com>, Cornelia Huck <cohuck@redhat.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, David Airlie <airlied@linux.ie>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <maxime.ripard@bootlin.com>, Sean Paul <sean@poorly.run>, Farhan Ali <alifm@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Harry Wei <harryxiyou@gmail.com>, Alex Shi <alex.shi@linux.alibaba.com>, Evgeniy Polyakov <zbr@ioremap.net>, Jerry Hoemann <jerry.hoemann@hpe.com>, Wim Van Sebroeck <wim@linux-watchdog.org>, Guenter Roeck <linux@roeck-us.net>, Guan Xuetao <gxt@pku.edu.cn>, Arnd Bergmann <arnd@arndb.de>, Linus Walleij <linus.walleij@linaro.org>, Bartosz Golaszewski <bgolaszewski@baylibre.com>, Andy Shevchenko <andy@infradead.org>, Jiri Slaby <jslaby@suse.com>, linux-wireless@vger.kernel.org, Linux PCI <linux-pci@vger.kernel.org>, "open list:GENERIC INCLUDE/A..." <linux-arch@vger.kernel.org>, platform-driver-x86@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-remoteproc@vger.kernel.org, openipmi-developer@lists.sourceforge.net, linux-crypto@vger.kernel.org, Linux ARM <linux-arm-kernel@lists.infradead.org>, netdev <netdev@vger.kernel.org>, linux-pwm <linux-pwm@vger.kernel.org>, dri-devel <dri-devel@lists.freedesktop.org>, kvm@vger.kernel.org, Linux Fbdev development list <linux-fbdev@vger.kernel.org>, linux-s390@vger.kernel.org, linux-watchdog@vger.kernel.org, "moderated list:DMA BUFFER SHARING
 FRAMEWORK" <linaro-mm-sig@lists.linaro.org>, linux-gpio <linux-gpio@vger.kernel.org>, Linux MM <linux-mm@kvack.org>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Daniel,

Em Wed, 19 Jun 2019 11:05:57 +0200
Daniel Vetter <daniel@ffwll.ch> escreveu:

> On Tue, Jun 18, 2019 at 10:55 PM Mauro Carvalho Chehab
> <mchehab+samsung@kernel.org> wrote:
> > diff --git a/Documentation/gpu/drm-mm.rst b/Documentation/gpu/drm-mm.rst
> > index fa30dfcfc3c8..b0f948d8733b 100644
> > --- a/Documentation/gpu/drm-mm.rst
> > +++ b/Documentation/gpu/drm-mm.rst
> > @@ -320,7 +320,7 @@ struct :c:type:`struct file_operations <file_operations>` get_unmapped_area
> >  field with a pointer on :c:func:`drm_gem_cma_get_unmapped_area`.
> >
> >  More detailed information about get_unmapped_area can be found in
> > -Documentation/nommu-mmap.rst
> > +Documentation/driver-api/nommu-mmap.rst  
> 
> Random drive-by comment: Could we convert these into hyperlinks within
> sphinx somehow, without making them less useful as raw file references
> (with vim I can just type 'gf' and it works, emacs probably the same).
> -Daniel

Short answer: I don't know how vim/emacs would recognize Sphinx tags.

There are two ways of doing hyperlinks to local files. The first one is to 
add a label at the other file and use a reference to such label, e. g. at
nommu-mmap.rst, you would add a label like:

	.. _drm_nommu-mmap:

at the beginning of the file.

Then, at drm-mm.rst, you would use :ref:`drm_nommu-mmap` (there are a
few other alternative tags that would work the same way).

The advantage is that you could move/rename documents anytime, without
needing to take care of it.

Perhaps it could be possible a tool like cscope to parse those in
order to provide such automation for Sphinx. I dunno.

-

The other way is to use:

	:doc:`nommu-mmap.rst` (if both files are at the same dir)

The :doc: path is the current directory. So, if a file at, let's say,
Documentation/gpu wants to refer another file at driver-api, it would
need to write it as:

	:doc:`../driver-api/nommu-mmap.rst`

I'm not sure if vim/emacs recognizes this syntax, though.

Perhaps this tag could be used as:

	:doc:`Documentation/driver-api/nommu-mmap.rst <../driver-api/nommu-map.rst`

But that looks too ugly to my taste.

-

On this conversion, I opted to not touch this. We may consider trying
to replace those 


Thanks,
Mauro
