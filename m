Date: Wed, 19 Jul 2017 14:52:49 -0500
From: Josh Poimboeuf <jpoimboe@redhat.com>
Message-ID: <20170719195249.akr6m2x65mhtsyvf@treble>
References: <1500422614-94821-1-git-send-email-keescook@chromium.org>
 <1500422614-94821-3-git-send-email-keescook@chromium.org>
 <20170719193718.bvkkde5apbboudrk@treble>
 <CAGXu5jKqqRJ3H0fwwc5W14U14p-QzTe1=UWJggA2yxLuj23ZTA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAGXu5jKqqRJ3H0fwwc5W14U14p-QzTe1=UWJggA2yxLuj23ZTA@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH v6 2/2] x86/refcount: Implement fast refcount overflow
 protection
To: Kees Cook <keescook@chromium.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <peterz@infradead.org>, Christoph Hellwig <hch@infradead.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, Eric Biggers <ebiggers3@gmail.com>, Elena Reshetova <elena.reshetova@intel.com>, Hans Liljestrand <ishkamiel@gmail.com>, Greg KH <gregkh@linuxfoundation.org>, Alexey Dobriyan <adobriyan@gmail.com>, "Serge E. Hallyn" <serge@hallyn.com>, arozansk@redhat.com, Davidlohr Bueso <dave@stgolabs.net>, Manfred Spraul <manfred@colorfullife.com>, "axboe@kernel.dk" <axboe@kernel.dk>, James Bottomley <James.Bottomley@hansenpartnership.com>, "x86@kernel.org" <x86@kernel.org>, Arnd Bergmann <arnd@arndb.de>, "David S. Miller" <davem@davemloft.net>, Rik van Riel <riel@redhat.com>, LKML <linux-kernel@vger.kernel.org>, linux-arch <linux-arch@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jul 19, 2017 at 12:45:19PM -0700, Kees Cook wrote:
> > diff --git a/arch/x86/include/asm/refcount.h b/arch/x86/include/asm/refcount.h
> > index 13b91e850a02..e7587db3487c 100644
> > --- a/arch/x86/include/asm/refcount.h
> > +++ b/arch/x86/include/asm/refcount.h
> > @@ -15,6 +15,7 @@
> >         ".pushsection .text.unlikely\n"                 \
> >         "111:\tlea %[counter], %%" _ASM_CX "\n"         \
> >         "112:\t" ASM_UD0 "\n"                           \
> > +       ASM_UNREACHABLE                                 \
> >         ".popsection\n"                                 \
> >         "113:\n"                                        \
> >         _ASM_EXTABLE_REFCOUNT(112b, 113b)
> > diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
> > index cd4bbe8242bd..85e0b8f42ca0 100644
> > --- a/include/linux/compiler-gcc.h
> > +++ b/include/linux/compiler-gcc.h
> > @@ -202,15 +202,25 @@
> >  #endif
> >
> >  #ifdef CONFIG_STACK_VALIDATION
> > +
> >  #define annotate_unreachable() ({                                      \
> >         asm("%c0:\t\n"                                                  \
> > -           ".pushsection .discard.unreachable\t\n"                     \
> > -           ".long %c0b - .\t\n"                                        \
> > -           ".popsection\t\n" : : "i" (__LINE__));                      \
> > +           ".pushsection .discard.unreachable\n\t"                     \
> > +           ".long %c0b - .\n\t"                                        \
> > +           ".popsection\n\t" : : "i" (__LINE__));                      \
> 
> Is this just an indentation change?

This was sneaking in a fix to put the tab after the newline instead of
before it.  I figured it's not worth its own commit.

> >  })
> > +
> > +#define ASM_UNREACHABLE                                                        \
> > +       "999: .pushsection .discard.unreachable\n\t"                    \
> > +       ".long 999b - .\n\t"                                            \
> > +       ".popsection\n\t"
> 
> Just so I understand, we'll get a single byte added for each exception
> case, but it'll get discarded during final link?

I think it's four bytes actually, but yeah, the section gets stripped at
vmlinux link time.

-- 
Josh
