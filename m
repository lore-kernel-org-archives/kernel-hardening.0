Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Thu, 30 Jun 2011 20:03:45 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110630160345.GA15258@albatros>
References: <20110626183321.GA3867@albatros>
 <20110629182505.GC14873@openwall.com>
 <20110629183728.GA8163@albatros>
 <20110629194339.GA15379@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110629194339.GA15379@openwall.com>
Subject: Re: [kernel-hardening] overview of PaX features
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

On Wed, Jun 29, 2011 at 23:43 +0400, Solar Designer wrote:
> On Wed, Jun 29, 2011 at 10:37:28PM +0400, Vasiliy Kulikov wrote:
> > That's not only about old apps, but also a default relaxed policy for
> > the toolchain:
> > 
> > http://www.gentoo.org/proj/en/hardened/gnu-stack.xml
> 
> Of course.  In my experience, most programs that currently get
> executable stack actually don't need it.
> 
> And for gcc trampolines we can include the emulation code in the kernel.

I've looked over -ow and PaX' implementations of trampolines emulation.
Two notes:

1) Are trampolines the only widespread user of executable stack?
(widespread among executable stack needings ;)

2) In -ow patch the trampolines emulation is very tolerant: it supports
up to 8 movs and then one of 2 jmps.  PaX' version distinguishes only 2
specific trampolines implementations and alerts if the code doesn't fit
into these strict patterns.  Taking into consideration how long PaX
patch exists, I suppose the restricted version cover all (or almost all)
realworld trampolines implementations.   The -ow variant would relax the
stack too much.


Btw, there is a tool to change executable stack settings per binary,
written by Jakub Jelinek (Red Hat):

http://linux.die.net/man/8/execstack


Thanks,

-- 
Vasiliy
