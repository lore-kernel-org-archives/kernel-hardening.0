Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20170104200319.GA26503@kroah.com>
References: <20170103230720.GA115084@beast> <20170104091312.GA31129@kroah.com>
 <CAPeXnHvnVbr_2gCnGK0ibnm4bauMHoEvp3rROnDuSoYgz-aniw@mail.gmail.com>
 <20170104194214.GB25268@kroah.com> <CAPeXnHtyXVvDGpJeUHsLES2FVVD7r_EWmzPwC6pO=2+W3eo-Kw@mail.gmail.com>
 <20170104200319.GA26503@kroah.com>
From: Matthew Garrett <mjg59@coreos.com>
Date: Wed, 4 Jan 2017 14:06:35 -0600
Message-ID: <CAPeXnHuq9FUR4e4p1cMCuzhD5pE18FFjUbJvaaB2zh-209vH9Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] Allow userspace to request device probing even if
 defer_all_probes is true
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kees Cook <keescook@chromium.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 4, 2017 at 2:03 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Wed, Jan 04, 2017 at 01:53:45PM -0600, Matthew Garrett wrote:
>> If you have two loaded drivers that could bind to the device then the
>> order you attempt to bind them in will matter.
>
> If you have that, you are screwed no matter what.  The driver model
> never guarantees any order in which a driver and device is matched up,
> sorry, and if that's the goal of this patch somehow, then I'll strongly
> object to it.

It's not? The reason for implementing it this way is to avoid
duplicating functionality the kernel already has, especially when it's
impossible to precisely duplicate that behaviour in userspace.

>> If you plug in a device while defer_all_probes is true, it won't be
>> bound - that's the point. But if you have a USB keyboard and unplug it
>> and plug it, you'd then end up with no keyboard. So you want userspace
>> to be able to make an appropriate policy decision around which devices
>> should be bound, and you need a mechanism to allow userspace to
>> trigger that binding.
>
> Use the in-place mechanism for that, userspace gets notification that
> the device was plugged in, it can authorize it or not.  That's what
> systems have been doing for a while now, and is what that api was
> created for.

That doesn't work - the USB authorisation code doesn't give you enough
information to make that decision before driver binding occurs.

> I'm getting the impression that somehow these two different patches are
> a series and related to each other which is even more confusing...

Yes, this is only relevant with the other patch.
