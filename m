Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 4 Jan 2017 21:03:19 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <20170104200319.GA26503@kroah.com>
References: <20170103230720.GA115084@beast>
 <20170104091312.GA31129@kroah.com>
 <CAPeXnHvnVbr_2gCnGK0ibnm4bauMHoEvp3rROnDuSoYgz-aniw@mail.gmail.com>
 <20170104194214.GB25268@kroah.com>
 <CAPeXnHtyXVvDGpJeUHsLES2FVVD7r_EWmzPwC6pO=2+W3eo-Kw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPeXnHtyXVvDGpJeUHsLES2FVVD7r_EWmzPwC6pO=2+W3eo-Kw@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH] Allow userspace to request device probing even if
 defer_all_probes is true
To: Matthew Garrett <mjg59@coreos.com>
Cc: Kees Cook <keescook@chromium.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 04, 2017 at 01:53:45PM -0600, Matthew Garrett wrote:
> On Wed, Jan 4, 2017 at 1:42 PM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> > On Wed, Jan 04, 2017 at 12:11:49PM -0600, Matthew Garrett wrote:
> >> Userspace doesn't know the order that the kernel will use when
> >> attempting to bind drivers, so punting binding out to userspace may
> >> result in different behaviour.
> >
> > How can the order in which drivers are bound result in different
> > behavior?
> 
> If you have two loaded drivers that could bind to the device then the
> order you attempt to bind them in will matter.

If you have that, you are screwed no matter what.  The driver model
never guarantees any order in which a driver and device is matched up,
sorry, and if that's the goal of this patch somehow, then I'll strongly
object to it.

What in-kernel drivers do we have that bind to the same device?  We
shouldn't have that, because of this very issue.

> >> The kernel already has the code to do this, so we should just reuse
> >> it.
> >
> > That's fine, but I don't understand the problem you are trying to solve,
> > please explain better.  What am I missing here?
> 
> If you plug in a device while defer_all_probes is true, it won't be
> bound - that's the point. But if you have a USB keyboard and unplug it
> and plug it, you'd then end up with no keyboard. So you want userspace
> to be able to make an appropriate policy decision around which devices
> should be bound, and you need a mechanism to allow userspace to
> trigger that binding.

Use the in-place mechanism for that, userspace gets notification that
the device was plugged in, it can authorize it or not.  That's what
systems have been doing for a while now, and is what that api was
created for.

I'm getting the impression that somehow these two different patches are
a series and related to each other which is even more confusing...

thanks,

greg k-h
