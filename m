Message-ID: <1502946611.3986.48.camel@gmail.com>
From: Daniel Micay <danielmicay@gmail.com>
Date: Thu, 17 Aug 2017 01:10:11 -0400
In-Reply-To: <CAGXu5jLyegoCA4cBDyOWvcsV3_wE8BBFRnuhkbORdFHTswGpoA@mail.gmail.com>
References: <20170816224650.1089-1-labbott@redhat.com>
	 <20170816224650.1089-3-labbott@redhat.com>
	 <CAFJ0LnHdAwAHJipwqOHzdLktCL+Ttdywuogk0ORHqn7eauRLkA@mail.gmail.com>
	 <CAGXu5jLyegoCA4cBDyOWvcsV3_wE8BBFRnuhkbORdFHTswGpoA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] [PATCHv2 2/2] extract early boot entropy
 from the passed cmdline
To: Kees Cook <keescook@chromium.org>, Nick Kralevich <nnk@google.com>
Cc: Laura Abbott <labbott@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, lkml <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, 2017-08-16 at 21:58 -0700, Kees Cook wrote:
> On Wed, Aug 16, 2017 at 9:56 PM, Nick Kralevich <nnk@google.com>
> wrote:
> > On Wed, Aug 16, 2017 at 3:46 PM, Laura Abbott <labbott@redhat.com>
> > wrote:
> > > From: Daniel Micay <danielmicay@gmail.com>
> > > 
> > > Existing Android bootloaders usually pass data useful as early
> > > entropy
> > > on the kernel command-line. It may also be the case on other
> > > embedded
> > > systems. Sample command-line from a Google Pixel running
> > > CopperheadOS:
> > > 
> > 
> > Why is it better to put this into the kernel, rather than just rely
> > on
> > the existing userspace functionality which does exactly the same
> > thing? This is what Android already does today:
> > https://android-review.googlesource.com/198113
> 
> That's too late for setting up the kernel stack canary, among other
> things. The kernel will also be generating some early secrets for slab
> cache canaries, etc. That all needs to happen well before init is
> started.
> 
> -Kees
> 

It's also unfortunately the kernel's global stack canary for the entire
boot since unlike x86 there aren't per-task canaries. GCC / Clang access
it via a segment register on x86 vs. a global on other architectures.

In theory it could be task-local elsewhere but doing it efficiently
would imply reserving a register to store the random value. I think that
may actually end up helping performance more than it hurts by not
needing to read the global stack canary value from cache repeatedly. If
stack canaries were augmented into something more (XOR in the retaddr
and offer the option of more coverage than STRONG) it would be more
important.
