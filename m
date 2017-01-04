Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20170104194214.GB25268@kroah.com>
References: <20170103230720.GA115084@beast> <20170104091312.GA31129@kroah.com>
 <CAPeXnHvnVbr_2gCnGK0ibnm4bauMHoEvp3rROnDuSoYgz-aniw@mail.gmail.com> <20170104194214.GB25268@kroah.com>
From: Matthew Garrett <mjg59@coreos.com>
Date: Wed, 4 Jan 2017 13:53:45 -0600
Message-ID: <CAPeXnHtyXVvDGpJeUHsLES2FVVD7r_EWmzPwC6pO=2+W3eo-Kw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] Allow userspace to request device probing even if
 defer_all_probes is true
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kees Cook <keescook@chromium.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 4, 2017 at 1:42 PM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
> On Wed, Jan 04, 2017 at 12:11:49PM -0600, Matthew Garrett wrote:
>> Userspace doesn't know the order that the kernel will use when
>> attempting to bind drivers, so punting binding out to userspace may
>> result in different behaviour.
>
> How can the order in which drivers are bound result in different
> behavior?

If you have two loaded drivers that could bind to the device then the
order you attempt to bind them in will matter.

>> The kernel already has the code to do this, so we should just reuse
>> it.
>
> That's fine, but I don't understand the problem you are trying to solve,
> please explain better.  What am I missing here?

If you plug in a device while defer_all_probes is true, it won't be
bound - that's the point. But if you have a USB keyboard and unplug it
and plug it, you'd then end up with no keyboard. So you want userspace
to be able to make an appropriate policy decision around which devices
should be bound, and you need a mechanism to allow userspace to
trigger that binding.
