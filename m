Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20170104091312.GA31129@kroah.com>
References: <20170103230720.GA115084@beast> <20170104091312.GA31129@kroah.com>
From: Matthew Garrett <mjg59@coreos.com>
Date: Wed, 4 Jan 2017 12:11:49 -0600
Message-ID: <CAPeXnHvnVbr_2gCnGK0ibnm4bauMHoEvp3rROnDuSoYgz-aniw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] Allow userspace to request device probing even if
 defer_all_probes is true
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Kees Cook <keescook@chromium.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 4, 2017 at 3:13 AM, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>> Add a force_probe sysfs node to each device, which if written will
>> trigger a probe even if defer_all_probes is currently true.
>
> Why not just manually trigger the bind of the device?  I don't
> understand the problem here that is being addressed, nor do I understand
> how this would be used.  More explaination please.

Userspace doesn't know the order that the kernel will use when
attempting to bind drivers, so punting binding out to userspace may
result in different behaviour. The kernel already has the code to do
this, so we should just reuse it.
