Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 3 Dec 2016 10:11:21 +0100
From: Greg KH <gregkh@linuxfoundation.org>
Message-ID: <20161203091121.GA8502@kroah.com>
References: <1480652545-4457-1-git-send-email-mpe@ellerman.id.au>
 <CAGXu5j+B=BTvLWzW7nYCgvdBeL682HibAGisEi=cJUPa0K1U2w@mail.gmail.com>
 <20161203091057.GA8468@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20161203091057.GA8468@kroah.com>
Subject: [kernel-hardening] Re: [PATCH v2] lkdtm: Add tests for LIST_POISON and ZERO_SIZE_PTR
To: Kees Cook <keescook@chromium.org>
Cc: Michael Ellerman <mpe@ellerman.id.au>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Dec 03, 2016 at 10:10:57AM +0100, Greg KH wrote:
> On Fri, Dec 02, 2016 at 01:32:24PM -0800, Kees Cook wrote:
> > On Thu, Dec 1, 2016 at 8:22 PM, Michael Ellerman <mpe@ellerman.id.au> wrote:
> > > This adds two tests, to check that a read or write to LIST_POISON1 and
> > > ZERO_SIZE_PTR are blocked.
> > >
> > > The default values for both (256 and 16) typically fall in the range
> > > of valid user space addresses. However in general mmap_min_addr is 64K,
> > > which prevents user space from mapping anything at those addresses.
> > >
> > > However it's feasible that an attacker will be able to find a way to
> > > cause an access at an offset from either value, and if that offset is
> > > greater than 64K then they can access user space again.
> > >
> > > To simulate that case, in the test we create a user mapping at
> > > approximately mmap_min_addr, and offset the pointer by that amount. This
> > > gives the test the greatest chance of failing (ie. an access
> > > succeeding). We don't actually use mmap_min_addr, because that would
> > > require exporting it to modules, instead we use the default value at
> > > compile time as a reasonable approximation.
> > >
> > > Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> > 
> > Thanks for this! I like it. :)
> > 
> > Acked-by: Kees Cook <keescook@chromium.org>
> > 
> > Greg, can you take this into your tree?
> 
> Sure, will do so on Monday.

Oops, no, I will not, kbuild reports build errors with it :(
