Reply-To: kernel-hardening@lists.openwall.com
From: "PaX Team" <pageexec@freemail.hu>
Date: Thu, 01 Sep 2016 16:10:25 +0200
MIME-Version: 1.0
Message-ID: <57C836D1.25222.4A0B007@pageexec.freemail.hu>
In-reply-to: <20160831164119.GA6633@leverpostej>
References: <alpine.DEB.2.10.1608272058090.3363@hadrien>, <CAGXu5jLUunTNw8LoNQdSoP2NU=SxzKDmXExEBeg-vSeOxk4iYA@mail.gmail.com>, <20160831164119.GA6633@leverpostej>
Content-type: text/plain; charset=US-ASCII
Content-transfer-encoding: 7BIT
Content-description: Mail message body
Subject: [kernel-hardening] Re: constification and cocci / kernel build test robot ?
To: Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>
Cc: Julia Lawall <julia.lawall@lip6.fr>, Joe Perches <joe@perches.com>, Fengguang Wu <fengguang.wu@intel.com>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Glenn Wurster <gwurster@blackberry.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 31 Aug 2016 at 17:41, Mark Rutland wrote:

> > The plugin marks them actually const, so the const_cast() is needed to
> > "forget" that marking and treat it as a normal variable. (And PaX Team
> > noted that this is the name used in C++ already.)
> 
> From having a look around, my understanding is that with C++ this is
> only valid if the underlying object is not const (i.e. it's only valid
> to remove constness from a pointer or reference which had itself added
> constness to a non-const object).
> 
> I see that GCC is happy to constant-fold function pointers in const
> objects it has visibility of; example below. Making the objects
> themselves const is bound to lead to fragility (e.g. static inline
> functions in a header behaving differently from related functions in
> another file).
> 
> Have I misunderstood something?

it's all correct but it's also not what PaX does for exactly this reason.
instead we only constify types where no global variable instances are accessed
directly. for directly accessed global variables we use __read_only and
pax_open/close_kernel calls. ideally, this should be done for all cases and
then const_cast would no longer be needed however that requires some non-trivial
work on the plugin side.
