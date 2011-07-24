Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sun, 24 Jul 2011 12:51:42 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110724084200.GB3659@albatros>
References: <20110723162251.GA11485@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110723162251.GA11485@openwall.com>
Subject: Re: [kernel-hardening] base address for shared libs
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

On Sat, Jul 23, 2011 at 20:22 +0400, Solar Designer wrote:
> At least on rhel5/openvz kernels, 32-bit processes get their shared libs
> loaded at different kinds of addresses on i686 vs. x86_64 kernels.
[...]
> Can you please look into this and likely fix it for mainline, as well as
> for rhel6/openvz when we're ready to move to those kernels?  A fix for
> rhel5/openvz would also be welcome if it's easy to do.

I'll look into it.  However, I don't know whether upstream is OK with
force zeroing high order byte of libs address and artificially limiting
effective task's vm size.  If not, it's probably should be made
configurable via kernel.randomize_va_space sysctl.

Thanks,

-- 
Vasiliy
