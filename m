Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 29 Jun 2011 23:43:39 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110629194339.GA15379@openwall.com>
References: <20110626183321.GA3867@albatros> <20110629182505.GC14873@openwall.com> <20110629183728.GA8163@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110629183728.GA8163@albatros>
Subject: Re: [kernel-hardening] overview of PaX features
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy,

On Wed, Jun 29, 2011 at 10:37:28PM +0400, Vasiliy Kulikov wrote:
> That's not only about old apps, but also a default relaxed policy for
> the toolchain:
> 
> http://www.gentoo.org/proj/en/hardened/gnu-stack.xml

Of course.  In my experience, most programs that currently get
executable stack actually don't need it.

And for gcc trampolines we can include the emulation code in the kernel.

> For upstream linux the default policy is if no GNU_STACK present, the
> stack flags is defined by a constant.  I think it makes sense for
> the upsteam to change it to per pid namespace, with the same default.

Sounds good.  Then we'll have less code to maintain in our patch.

Thanks,

Alexander
