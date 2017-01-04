Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 4 Jan 2017 20:46:00 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <20170104194600.GC25268@kroah.com>
References: <20170103225831.GA113525@beast>
 <20170104093236.GB31677@kroah.com>
 <CAPeXnHudW-YDmoK8NrFzQgAq4WuRDgFNC5-0GaG0+jVkq+3meQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPeXnHudW-YDmoK8NrFzQgAq4WuRDgFNC5-0GaG0+jVkq+3meQ@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH] Allow userspace control of runtime disabling/enabling of
 driver probing
To: Matthew Garrett <mjg59@coreos.com>
Cc: Kees Cook <keescook@chromium.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "Rafael J. Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Ulf Hansson <ulf.hansson@linaro.org>, Mauro Carvalho Chehab <mchehab@kernel.org>, Tomeu Vizoso <tomeu.vizoso@collabora.com>, Lukas Wunner <lukas@wunner.de>, Madalin Bucur <madalin.bucur@nxp.com>, Sudip Mukherjee <sudipm.mukherjee@gmail.com>, Rasmus Villemoes <linux@rasmusvillemoes.dk>, Arnd Bergmann <arnd@arndb.de>, Andrew Morton <akpm@linux-foundation.org>, Russell King <rmk+kernel@arm.linux.org.uk>, Petr Tesarik <ptesarik@suse.com>, linux-pm@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 04, 2017 at 12:10:04PM -0600, Matthew Garrett wrote:
> On Wed, Jan 4, 2017 at 3:32 AM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > Ick, hiding this in the power management code?  That's messy, and
> > complex, as Rafael pointed out.
> 
> It's in code that's used in the power management layer, not in power
> management code. This is all in the driver core.

Yes, but it's in the power management layer, not the "main" portion of
the driver bind/unbind logic.  It's kind of hidden, don't you think?

> > Turning on and off at random times "new devices can not be bound, wait,
> > now they can!" is ripe for loads of issues and is going to be a pain to
> > properly maintain over time.
> 
> What kind of issues?

How are you going to test this to ensure it continues to work properly?

> > What's wrong with the facility that the USB layer provides today to
> > allow only "authenticated" devices to be enabled?  That has been used
> > for a few years now to prevent these "don't allow random devices that
> > are plugged into the computer to be enabled" type attacks.  Doing much
> > the same thing, in a different manner, is ripe for problems (how do the
> > two interact now?)
> 
> The USB authentication feature was intended for handling wireless USB
> devices - it can be reused for this, but the code isn't generic enough
> to apply to other bus types. The two interact in exactly the way you'd
> expect, ie they don't. If you use both, then you need to handle both.

The feature was originally created for wireless USB devices, but it will
work for any USB device, and has been successfully used for this type of
thing (i.e. protecting kiosk-systems) for a while now.

> > If you are worried about PCI devices, why not just implement what USB
> > did for PCI?  Or better yet, move the USB functionality into the driver
> > core, adding that type of authentication ability to any bus that wishes
> > to have it (and not break existing working systems that are using the
> > USB solution today.)
> 
> The USB approach requires userspace to keep track of which devices
> were added while the session was locked, whereas the kernel already
> has the logic to do all of this. All the complexity already exists and
> is used every time anybody suspends and resumes, so why add additional
> complexity?

The kernel knows nothing about a "session", you know that.  Userspace
can disable enabling any new USB device when a session is "locked" today
quite easily, why not do that?

> I'm not clear on how this patch breaks anybody using the existing USB
> solution?

You now have two different ways to enable access to a USB device, please
let's keep to only one type of path.

thanks,

greg k-h
