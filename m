Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 4 Jan 2017 10:13:12 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-ID: <20170104091312.GA31129@kroah.com>
References: <20170103230720.GA115084@beast>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170103230720.GA115084@beast>
Subject: [kernel-hardening] Re: [PATCH] Allow userspace to request device probing even if
 defer_all_probes is true
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg59@coreos.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jan 03, 2017 at 03:07:20PM -0800, Kees Cook wrote:
> From: Matthew Garrett <mjg59@coreos.com>
> 
> Userspace may wish to make a policy decision to allow certain devices
> to be attached, such as keyboards.

I don't understand what that sentance means.  Why wouldn't keyboards be
attached?

> Add a force_probe sysfs node to each device, which if written will
> trigger a probe even if defer_all_probes is currently true.

Why not just manually trigger the bind of the device?  I don't
understand the problem here that is being addressed, nor do I understand
how this would be used.  More explaination please.

thanks,

greg k-h
