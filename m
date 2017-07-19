Date: Wed, 19 Jul 2017 18:01:29 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
Message-ID: <20170719230129.w52tkcmv5ys7zqsk@treble>
References: <1500422614-94821-1-git-send-email-keescook@chromium.org>
 <1500422614-94821-3-git-send-email-keescook@chromium.org>
 <20170719193718.bvkkde5apbboudrk@treble>
 <CAGXu5jKqqRJ3H0fwwc5W14U14p-QzTe1=UWJggA2yxLuj23ZTA@mail.gmail.com>
 <20170719195249.akr6m2x65mhtsyvf@treble>
 <CAGXu5j+zeCU083g6fDEcXM-CYEHYfbkd1cbWoUTJP_0WtyYRpA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAGXu5j+zeCU083g6fDEcXM-CYEHYfbkd1cbWoUTJP_0WtyYRpA@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v6 2/2] x86/refcount: Implement fast refcount overflow
 protection
To: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Christoph Hellwig <hch@infradead.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, Eric Biggers <ebiggers3@gmail.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, Greg KH <gregkh@linuxfoundation.org>, Alexey Dobriyan <adobriyan@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, arozansk@redhat.com, Davidlohr Bueso <dave@stgolabs.net>, Manfred Spraul <manfred@colorfullife.com>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, "x86@kernel.org" <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jul 19, 2017 at 03:50:14PM -0700, Kees Cook wrote:
> >> >  })
> >> > +
> >> > +#define ASM_UNREACHABLE                                                        \
> >> > +       "999: .pushsection .discard.unreachable\n\t"                    \
> >> > +       ".long 999b - .\n\t"                                            \
> >> > +       ".popsection\n\t"
> >>
> >> Just so I understand, we'll get a single byte added for each exception
> >> case, but it'll get discarded during final link?
> >
> > I think it's four bytes actually, but yeah, the section gets stripped at
> > vmlinux link time.
> 
> Right, yes.
> 
> BTW, I think this needs compiler.h coverage instead of the #else in
> compiler-gcc.h (since it's different from how annotate_unreachable is
> used only in compiler-gcc.h. I'll adjust.

Ah, right.  Sounds good.

> Also, in looking at CONFIG_STACK_VALIDATION, do you want it to just
> warn and skip, or do you want to error out the build if validation
> isn't available but it's in the .config?

I think the current warn and skip behavior is fine.  It's usually not a
life-or-death matter, and if it is, you'll be checking the warnings
anyway.

-- 
Josh
