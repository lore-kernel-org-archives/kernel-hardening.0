Date: Sun, 20 Aug 2017 09:59:46 -0700
From: Greg KH <greg@kroah.com>
Message-ID: <20170820165946.GA18709@kroah.com>
References: <CAJ2oMhLanOniQHJ79LkwGB8ctaJKKc73+iGmnvo5RX4x1PHpsA@mail.gmail.com>
 <CAGXu5j+_AwCDAqbNsH-nEZM3NhSq8jU1BbRZQJ041aab9nrF+g@mail.gmail.com>
 <CAJ2oMh+XPRDu_+VxZ1+thNnSpz9S1GXjNvng8+mWDH3GxZfu1Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJ2oMh+XPRDu_+VxZ1+thNnSpz9S1GXjNvng8+mWDH3GxZfu1Q@mail.gmail.com>
Subject: Re: [kernel-hardening] hardening mmc driver
To: Ran Shalit <ranshalit@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Aug 20, 2017 at 09:53:00AM +0300, Ran Shalit wrote:
> On Fri, Aug 18, 2017 at 11:44 PM, Kees Cook <keescook@chromium.org> wrote:
> > On Thu, Aug 17, 2017 at 10:57 PM, Ran Shalit <ranshalit@gmail.com> wrote:
> >> Hello,
> >
> > Hi!
> >
> >> What action should be taken to make mmc driver secured ?
> >>
> >> If there any wiki or document, which can help to understand better
> >> when a driver (like mmc)  is considered secured ?
> >
> > I don't have any specific pointers at the moment, but I think the main
> > focus for drivers (or really any software) is being extremely careful
> > with data processing and the validation of command arguments. Never
> > assume the commands you're getting will follow an expected protocol:
> > pretend the device at the other end of the bus (or the bus itself!) is
> > trying to attack the driver. Same for any commands coming from
> > userspace.
> >
> > Are there particular things you're concerned about for MMC security?
> >
> 
> Hello Kees,
> 
> Thank you very much for your feedback.
> I've found an interesing article by Intel, which tried to define and
> strandarize hardening of device driver.
> https://software.intel.com/sites/default/files/m/d/4/1/d/8/matassa.pdf
> I have no special concern now for the driver, except trying to grasp
> better how to make a driver "secured".
> I will follow the article guidelines and your comment at the moment.

Please note the date of that article, 2002, so some things in there
might not be valid anymore, and some are flat out wrong (hint, never use
'volatile' in the kernel, or anywhere really...).  But overall, it's a
good place to start.

good luck!

greg k-h
