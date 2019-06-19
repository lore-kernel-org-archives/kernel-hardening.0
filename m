Date: Wed, 19 Jun 2019 10:07:55 -0300
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
Subject: Re: [PATCH v1 12/22] docs: driver-api: add .rst files from the main
 dir
Message-ID: <20190619075843.3c2464ac@coco.lan>
In-Reply-To: <20190619104239.GM3419@hirez.programming.kicks-ass.net>
References: <cover.1560890771.git.mchehab+samsung@kernel.org>
	<b0d24e805d5368719cc64e8104d64ee9b5b89dd0.1560890772.git.mchehab+samsung@kernel.org>
	<CAKMK7uGM1aZz9yg1kYM8w2gw_cS6Eaynmar-uVurXjK5t6WouQ@mail.gmail.com>
	<20190619072218.4437f891@coco.lan>
	<20190619104239.GM3419@hirez.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>, Jonathan Corbet <corbet@lwn.net>
Cc: Daniel Vetter <daniel@ffwll.ch>, Linux Doc Mailing List <linux-doc@vger.kernel.org>, Mauro Carvalho Chehab <mchehab@infradead.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, William Breathitt Gray <vilhelm.gray@gmail.com>, Jaroslav Kysela <perex@perex.cz>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Rafael J. Wysocki" <rafael@kernel.org>, "Naveen N. Rao" <naveen.n.rao@linux.ibm.com>, Anil S Keshavamurthy <anil.s.keshavamurthy@intel.com>, "David S. Miller" <davem@davemloft.net>, Masami Hiramatsu <mhiramat@kernel.org>, Johannes Thumshirn <morbidrsa@gmail.com>, Steffen Klassert <steffen.klassert@secunet.com>, Sudip Mukherjee <sudipm.mukherjee@gmail.com>, Andreas =?UTF-8?B?RsOkcmJl?= =?UTF-8?B?cg==?= <afaerber@suse.de>, Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, Rodolfo Giometti <giometti@enneenne.com>, Richard Cochran <richardcochran@gmail.com>, Thierry Reding <thierry.reding@gmail.com>, Sumit Semwal <sumit.semwal@linaro.org>, Gustavo Padovan <gustavo@padovan.org>, Jens Wiklander <jens.wiklander@linaro.org>, Kirti Wankhede <kwankhede@nvidia.com>, Alex Williamson <alex.williamson@redhat.com>, Cornelia Huck <cohuck@redhat.com>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, David Airlie <airlied@linux.ie>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <maxime.ripard@bootlin.com>, Sean Paul <sean@poorly.run>, Farhan Ali <alifm@linux.ibm.com>, Eric Farman <farman@linux.ibm.com>, Halil Pasic <pasic@linux.ibm.com>, Heiko Carstens <heiko.carstens@de.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Harry Wei <harryxiyou@gmail.com>, Alex Shi <alex.shi@linux.alibaba.com>, Evgeniy Polyakov <zbr@ioremap.net>, Jerry Hoemann <jerry.hoemann@hpe.com>, Wim Van Sebroeck <wim@linux-watchdog.org>, Guenter Roeck <linux@roeck-us.net>, Guan Xuetao <gxt@pku.edu.cn>, Arnd Bergmann <arnd@arndb.de>, Linus Walleij <linus.walleij@linaro.org>, Bartosz Golaszewski <bgolaszewski@baylibre.com>, Andy Shevchenko <andy@infradead.org>, Jiri Slaby <jslaby@suse.com>, linux-wireless@vger.kernel.org, Linux PCI <linux-pci@vger.kernel.org>, "open list:GENERIC INCLUDE/A..." <linux-arch@vger.kernel.org>, platform-driver-x86@vger.kernel.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, linux-remoteproc@vger.kernel.org, openipmi-developer@lists.sourceforge.net, linux-crypto@vger.kernel.org, Linux ARM <linux-arm-kernel@lists.infradead.org>, netdev <netdev@vger.kernel.org>, linux-pwm <linux-pwm@vger.kernel.org>, dri-devel <dri-devel@lists.freedesktop.org>, kvm@vger.kernel.org, Linux Fbdev development list <linux-fbdev@vger.kernel.org>, linux-s390@vger.kernel.org, linux-watchdog@vger.kernel.org, "moderated list:DMA BUFFER SHARING
 FRAMEWORK" <linaro-mm-sig@lists.linaro.org>, linux-gpio <linux-gpio@vger.kernel.org>, Linux MM <linux-mm@kvack.org>
List-ID: <kernel-hardening.lists.openwall.com>

Em Wed, 19 Jun 2019 12:42:39 +0200
Peter Zijlstra <peterz@infradead.org> escreveu:

> On Wed, Jun 19, 2019 at 07:22:18AM -0300, Mauro Carvalho Chehab wrote:
> > Hi Daniel,
> > 
> > Em Wed, 19 Jun 2019 11:05:57 +0200
> > Daniel Vetter <daniel@ffwll.ch> escreveu:
> >   
> > > On Tue, Jun 18, 2019 at 10:55 PM Mauro Carvalho Chehab
> > > <mchehab+samsung@kernel.org> wrote:  
> > > > diff --git a/Documentation/gpu/drm-mm.rst b/Documentation/gpu/drm-mm.rst
> > > > index fa30dfcfc3c8..b0f948d8733b 100644
> > > > --- a/Documentation/gpu/drm-mm.rst
> > > > +++ b/Documentation/gpu/drm-mm.rst
> > > > @@ -320,7 +320,7 @@ struct :c:type:`struct file_operations <file_operations>` get_unmapped_area
> > > >  field with a pointer on :c:func:`drm_gem_cma_get_unmapped_area`.
> > > >
> > > >  More detailed information about get_unmapped_area can be found in
> > > > -Documentation/nommu-mmap.rst
> > > > +Documentation/driver-api/nommu-mmap.rst    
> > > 
> > > Random drive-by comment: Could we convert these into hyperlinks within
> > > sphinx somehow, without making them less useful as raw file references
> > > (with vim I can just type 'gf' and it works, emacs probably the same).
> > > -Daniel  
> > 
> > Short answer: I don't know how vim/emacs would recognize Sphinx tags.  
> 
> No, the other way around, Sphinx can recognize local files and treat
> them special. That way we keep the text readable.
> 
> Same with that :c:func:'foo' crap, that needs to die, and Sphinx needs
> to be taught about foo().

Just did a test today at Jon's extension (with is currently on a
separate branch). At least the version that it is there at his automarkup
branch still needs some work, as it currently breaks titles and tables:

	6.4 :c:func:`resync_start()`, :c:func:`resync_finish()`
	-----------------------------------
	/devel/v4l/docs/Documentation/driver-api/md/md-cluster.rst:323: WARNING: Title underline too short.


	/devel/v4l/docs/Documentation/driver-api/serial/tty.rst:74: WARNING: Malformed table.
	Text in column margin in table line 34.

	======================= =======================================================
	:c:func:`open()`                        Called when the line discipline is attached to

-

That's said, once it gets fixed to address those complex cases, a
regex like:

	\bDocumentation/([\w\d\-\_\/]+)\.rst\b

could be converted to :doc: tag. It should be smart enough to convert
the relative paths, as we refer to the files from the git root directory
(with makes a lot sense to me), while Sphinx :doc: use relative patches
from the location where the parsed file is.

Something like the enclosed patch.

Thanks,
Mauro

[PATCH] automarkup.py: convert Documentation/* to hyperlinks

Auto-create hyperlinks when it finds a Documentation/.. occurrence.

Signed-off-by: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>

diff --git a/Documentation/sphinx/automarkup.py b/Documentation/sphinx/automarkup.py
index 39c8f4d5af82..9d6926b61241 100644
--- a/Documentation/sphinx/automarkup.py
+++ b/Documentation/sphinx/automarkup.py
@@ -9,6 +9,7 @@
 from __future__ import print_function
 import re
 import sphinx
+#import sys		# Just for debug
 
 #
 # Regex nastiness.  Of course.
@@ -31,10 +32,26 @@ RE_literal = re.compile(r'^(\s*)(.*::\s*|\.\.\s+code-block::.*)$')
 #
 RE_whitesp = re.compile(r'^(\s*)')
 
+#
+# Get a documentation reference
+#
+RE_doc_links = re.compile(r'\bDocumentation/([\w\d\-\_\/]+)\.rst\b')
+
+#
+# Doc link false-positives
+#
+RE_false_doc_links = re.compile(r':ref:`\s*Documentation/[\w\d\-\_\/]+\.rst')
+
 def MangleFile(app, docname, text):
     ret = [ ]
     previous = ''
     literal = False
+
+    rel_dir = ''
+
+    for depth in range(0, docname.count('/')):
+        rel_dir += "../"
+
     for line in text[0].split('\n'):
         #
         # See if we might be ending a literal block, as denoted by
@@ -63,7 +80,17 @@ def MangleFile(app, docname, text):
         # Normal line - perform substitutions.
         #
         else:
-            ret.append(RE_function.sub(r'\1:c:func:`\2`\3', line))
+            new_line = RE_function.sub(r'\1:c:func:`\2`\3', line)
+
+            if not RE_false_doc_links.search(new_line):
+                new_line = RE_doc_links.sub(r':doc:`' + rel_dir + r'\1`', new_line)
+
+ #           # Just for debug - should be removed on production
+ #           if new_line != line:
+ #               print ("===>" + new_line, file=sys.stderr)
+
+            ret.append(new_line)
+
         #
         # Might we be starting a literal block?  If so make note of
         # the fact.
