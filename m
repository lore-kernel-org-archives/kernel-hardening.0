MIME-Version: 1.0
References: <1548076208-6442-1-git-send-email-jsteckli@amazon.de>
 <20190121183618.GP6118@tassilo.jf.intel.com> <20190121191541.GB4026@kroah.com>
In-Reply-To: <20190121191541.GB4026@kroah.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 22 Jan 2019 09:42:13 +1300
Message-ID: <CAGXu5j+h9RKAND8+SJR6P6CQY_YO3ezjsnfuzLGsQbY=O4XCuw@mail.gmail.com>
Subject: Re: [RFC] x86/speculation: add L1 Terminal Fault / Foreshadow demo
Content-Type: text/plain; charset="UTF-8"
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Andi Kleen <ak@linux.intel.com>, Julian Stecklina <jsteckli@amazon.de>, LKML <linux-kernel@vger.kernel.org>, David Woodhouse <dwmw2@infradead.org>, Liran Alon <liran.alon@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Linus Torvalds <torvalds@linux-foundation.org>, X86 ML <x86@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jan 22, 2019 at 8:15 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Mon, Jan 21, 2019 at 10:36:18AM -0800, Andi Kleen wrote:
> > > +   /* Check the start address: needs to be page-aligned.. */
> > > +-  if (start & ~PAGE_MASK)
> > > ++  if (start & ~PAGE_MASK) {
> > > ++
> > > ++          /*
> > > ++           * XXX Hack
> > > ++           *
> > > ++           * We re-use this error case to show case a cache load gadget:
> > > ++           * There is a mispredicted branch, which leads to prefetching
> > > ++           * the cache with attacker controlled data.
> > > ++           */
> > > ++          asm volatile (
> >
> > Obviously that can never be added to a standard kernel.
>
> No, that's why it is a patch, right?  People want to test things, it's
> nice to have a way to easily do this.

What about adding something like it to drivers/misc/lkdtm/ instead?

It's not a "production" module, but it regularly get built for selftest builds.

-- 
Kees Cook
