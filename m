Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 4 Jan 2017 21:47:04 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <20170104204704.GA17642@kroah.com>
References: <20170103225831.GA113525@beast>
 <20170104093236.GB31677@kroah.com>
 <CAPeXnHudW-YDmoK8NrFzQgAq4WuRDgFNC5-0GaG0+jVkq+3meQ@mail.gmail.com>
 <CAPeXnHue8hKFiMsddMTN7Hb5RWBGXWUgy2-kpXNLwBfOdf0QVA@mail.gmail.com>
 <20170104194707.GD25268@kroah.com>
 <CAPeXnHs1=jCGtSgOO859bp2chMWBX1L6VaKn65RKoLaTbVq_0A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPeXnHs1=jCGtSgOO859bp2chMWBX1L6VaKn65RKoLaTbVq_0A@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH] Allow userspace control of runtime disabling/enabling of
 driver probing
To: Matthew Garrett <mjg59@coreos.com>
Cc: Kees Cook <keescook@chromium.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Ulf Hansson <ulf.hansson@linaro.org>, Mauro Carvalho Chehab <mchehab@kernel.org>, Tomeu Vizoso <tomeu.vizoso@collabora.com>, Lukas Wunner <lukas@wunner.de>, Madalin Bucur <madalin.bucur@nxp.com>, Sudip Mukherjee <sudipm.mukherjee@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, Russell King <rmk+kernel@arm.linux.org.uk>, Petr Tesarik <ptesarik@suse.com>, linux-pm@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 04, 2017 at 02:01:00PM -0600, Matthew Garrett wrote:
> On Wed, Jan 4, 2017 at 1:47 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > You know the device type and vendor/product id before you authorize it,
> > you should be able to do this type of detection otherwise it seems
> > pretty pointless :)
> 
> You know the vendor and product ID, which doesn't tell you whether one
> of the endpoints is a network device or a keyboard. You need to know
> that.

Are you sure you don't have the configuration information as well?  That
should tell you...

And for network devices, they are almost all just vendor/product ids,
not many use the class protocol.

thanks,

greg k-h
