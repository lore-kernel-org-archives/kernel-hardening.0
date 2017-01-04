Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 4 Jan 2017 20:42:14 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <20170104194214.GB25268@kroah.com>
References: <20170103230720.GA115084@beast>
 <20170104091312.GA31129@kroah.com>
 <CAPeXnHvnVbr_2gCnGK0ibnm4bauMHoEvp3rROnDuSoYgz-aniw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPeXnHvnVbr_2gCnGK0ibnm4bauMHoEvp3rROnDuSoYgz-aniw@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH] Allow userspace to request device probing even if
 defer_all_probes is true
To: Matthew Garrett <mjg59@coreos.com>
Cc: Kees Cook <keescook@chromium.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 04, 2017 at 12:11:49PM -0600, Matthew Garrett wrote:
> On Wed, Jan 4, 2017 at 3:13 AM, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >> Add a force_probe sysfs node to each device, which if written will
> >> trigger a probe even if defer_all_probes is currently true.
> >
> > Why not just manually trigger the bind of the device?  I don't
> > understand the problem here that is being addressed, nor do I understand
> > how this would be used.  More explaination please.
> 
> Userspace doesn't know the order that the kernel will use when
> attempting to bind drivers, so punting binding out to userspace may
> result in different behaviour.

How can the order in which drivers are bound result in different
behavior?

> The kernel already has the code to do this, so we should just reuse
> it.

That's fine, but I don't understand the problem you are trying to solve,
please explain better.  What am I missing here?

thanks,

greg k-h
