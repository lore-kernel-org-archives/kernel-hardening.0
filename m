Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Wed, 29 Jun 2011 22:37:28 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110629183728.GA8163@albatros>
References: <20110626183321.GA3867@albatros>
 <20110629182505.GC14873@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110629182505.GC14873@openwall.com>
Subject: Re: [kernel-hardening] overview of PaX features
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

On Wed, Jun 29, 2011 at 22:25 +0400, Solar Designer wrote:
> On Sun, Jun 26, 2011 at 10:33:21PM +0400, Vasiliy Kulikov wrote:
> > PaXTeam said there is almost nothing I can do with userspace NX.
> > Currently it is implemented as a "stack can be X unless GNU_STACK is
> > enabled" instead of secure by default policy.  It's impossible to fix it
> > not breaking the compatibility with old apps.  So, I'm skipping NOEXEC
> > options.
> 
> Please do break compatibility with a handful of old apps

That's not only about old apps, but also a default relaxed policy for
the toolchain:

http://www.gentoo.org/proj/en/hardened/gnu-stack.xml

> - but as a
> non-default option (which we're likely to make the default on Owl, just
> like we had non-executable stack by default with 2.4.x-ow kernels).
> 
> With OpenVZ, it needs to be configurable per-container.

For upstream linux the default policy is if no GNU_STACK present, the
stack flags is defined by a constant.  I think it makes sense for
the upsteam to change it to per pid namespace, with the same default.

A good idea!

Thanks,

-- 
Vasiliy
