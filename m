Date: Thu, 8 Mar 2018 23:11:52 -0700
From: Tycho Andersen <tycho@tycho.ws>
Subject: Re: [PATCH 4/4] video: Remove stack VLA usage
Message-ID: <20180309061152.r3yumh6agasyhtvo@cisco>
References: <1520574625-4225-1-git-send-email-me@tobin.cc>
 <1520575267.11634.25.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1520575267.11634.25.camel@perches.com>
To: Joe Perches <joe@perches.com>
Cc: "Tobin C. Harding" <me@tobin.cc>, Florian Tobias Schandinat <FlorianSchandinat@gmx.de>, Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, driverdev-devel@linuxdriverproject.org, Kees Cook <keescook@chromium.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 08, 2018 at 10:01:07PM -0800, Joe Perches wrote:
> On Fri, 2018-03-09 at 16:50 +1100, Tobin C. Harding wrote:
> > The kernel would like to have all stack VLA usage removed[1].  The
> > arrays are fixed here (declared with a const variable) but they appear
> > like VLAs to the compiler.  We can use a pre-processor define to fix the
> > warning.  
> []
> > diff --git a/drivers/video/fbdev/via/via_aux_sii164.c b/drivers/video/fbdev/via/via_aux_sii164.c
> []
> > @@ -27,6 +27,9 @@
> >  
> >  static const char *name = "SiI 164 PanelLink Transmitter";
> >  
> > +/* check vendor id and device id */
> > +const u8 id[] = {0x01, 0x00, 0x06, 0x00};
> 
> It seems id is now global in multiple places.
> Perhaps these should be static.

Does it even need to be global? Why not just get rid of the indirection and use
ARRAY_SIZE where we mean it? This seems to work for me,

diff --git a/drivers/video/fbdev/via/via_aux_sii164.c b/drivers/video/fbdev/via/via_aux_sii164.c
index ca1b35f033b1..87db6c98d680 100644
--- a/drivers/video/fbdev/via/via_aux_sii164.c
+++ b/drivers/video/fbdev/via/via_aux_sii164.c
@@ -35,10 +35,10 @@ static void probe(struct via_aux_bus *bus, u8 addr)
                .addr   =       addr,
                .name   =       name};
        /* check vendor id and device id */
-       const u8 id[] = {0x01, 0x00, 0x06, 0x00}, len = ARRAY_SIZE(id);
-       u8 tmp[len];
+       const u8 id[] = {0x01, 0x00, 0x06, 0x00};
+       u8 tmp[ARRAY_SIZE(id)];
 
-       if (!via_aux_read(&drv, 0x00, tmp, len) || memcmp(id, tmp, len))
+       if (!via_aux_read(&drv, 0x00, tmp, sizeof(tmp)) || memcmp(id, tmp, sizeof(tmp)))
                return;
 
        printk(KERN_INFO "viafb: Found %s at address 0x%x\n", name, addr);

Cheers,

Tycho
