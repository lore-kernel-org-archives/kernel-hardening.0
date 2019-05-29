MIME-Version: 1.0
References: <20190520231948.49693-1-thgarnie@chromium.org> <20190520231948.49693-2-thgarnie@chromium.org>
 <20190521040634.GA32379@sol.localdomain> <CAJcbSZGekB9Uc8PUoSCND+ZaAN9V60uyVv1bBeBGDQ_pHxzVnw@mail.gmail.com>
 <20190522205524.GA183718@gmail.com>
In-Reply-To: <20190522205524.GA183718@gmail.com>
From: Thomas Garnier <thgarnie@chromium.org>
Date: Wed, 29 May 2019 08:48:08 -0700
Message-ID: <CAJcbSZFnHk1uh3kz4+mcyExwjR+p445p4FSnZbskFKKhgy0qVw@mail.gmail.com>
Subject: Re: [PATCH v7 01/12] x86/crypto: Adapt assembly for PIE support
Content-Type: text/plain; charset="UTF-8"
To: Eric Biggers <ebiggers@kernel.org>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Kristen Carlson Accardi <kristen@linux.intel.com>, Herbert Xu <herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, "H. Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, Linux Crypto Mailing List <linux-crypto@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, May 22, 2019 at 1:55 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Wed, May 22, 2019 at 01:47:07PM -0700, Thomas Garnier wrote:
> > On Mon, May 20, 2019 at 9:06 PM Eric Biggers <ebiggers@kernel.org> wrote:
> > >
> > > On Mon, May 20, 2019 at 04:19:26PM -0700, Thomas Garnier wrote:
> > > > diff --git a/arch/x86/crypto/sha256-avx2-asm.S b/arch/x86/crypto/sha256-avx2-asm.S
> > > > index 1420db15dcdd..2ced4b2f6c76 100644
> > > > --- a/arch/x86/crypto/sha256-avx2-asm.S
> > > > +++ b/arch/x86/crypto/sha256-avx2-asm.S
> > > > @@ -588,37 +588,42 @@ last_block_enter:
> > > >       mov     INP, _INP(%rsp)
> > > >
> > > >       ## schedule 48 input dwords, by doing 3 rounds of 12 each
> > > > -     xor     SRND, SRND
> > > > +     leaq    K256(%rip), SRND
> > > > +     ## loop1 upper bound
> > > > +     leaq    K256+3*4*32(%rip), INP
> > > >
> > > >  .align 16
> > > >  loop1:
> > > > -     vpaddd  K256+0*32(SRND), X0, XFER
> > > > +     vpaddd  0*32(SRND), X0, XFER
> > > >       vmovdqa XFER, 0*32+_XFER(%rsp, SRND)
> > > >       FOUR_ROUNDS_AND_SCHED   _XFER + 0*32
> > > >
> > > > -     vpaddd  K256+1*32(SRND), X0, XFER
> > > > +     vpaddd  1*32(SRND), X0, XFER
> > > >       vmovdqa XFER, 1*32+_XFER(%rsp, SRND)
> > > >       FOUR_ROUNDS_AND_SCHED   _XFER + 1*32
> > > >
> > > > -     vpaddd  K256+2*32(SRND), X0, XFER
> > > > +     vpaddd  2*32(SRND), X0, XFER
> > > >       vmovdqa XFER, 2*32+_XFER(%rsp, SRND)
> > > >       FOUR_ROUNDS_AND_SCHED   _XFER + 2*32
> > > >
> > > > -     vpaddd  K256+3*32(SRND), X0, XFER
> > > > +     vpaddd  3*32(SRND), X0, XFER
> > > >       vmovdqa XFER, 3*32+_XFER(%rsp, SRND)
> > > >       FOUR_ROUNDS_AND_SCHED   _XFER + 3*32
> > > >
> > > >       add     $4*32, SRND
> > > > -     cmp     $3*4*32, SRND
> > > > +     cmp     INP, SRND
> > > >       jb      loop1
> > > >
> > > > +     ## loop2 upper bound
> > > > +     leaq    K256+4*4*32(%rip), INP
> > > > +
> > > >  loop2:
> > > >       ## Do last 16 rounds with no scheduling
> > > > -     vpaddd  K256+0*32(SRND), X0, XFER
> > > > +     vpaddd  0*32(SRND), X0, XFER
> > > >       vmovdqa XFER, 0*32+_XFER(%rsp, SRND)
> > > >       DO_4ROUNDS      _XFER + 0*32
> > > >
> > > > -     vpaddd  K256+1*32(SRND), X1, XFER
> > > > +     vpaddd  1*32(SRND), X1, XFER
> > > >       vmovdqa XFER, 1*32+_XFER(%rsp, SRND)
> > > >       DO_4ROUNDS      _XFER + 1*32
> > > >       add     $2*32, SRND
> > > > @@ -626,7 +631,7 @@ loop2:
> > > >       vmovdqa X2, X0
> > > >       vmovdqa X3, X1
> > > >
> > > > -     cmp     $4*4*32, SRND
> > > > +     cmp     INP, SRND
> > > >       jb      loop2
> > > >
> > > >       mov     _CTX(%rsp), CTX
> > >
> > > There is a crash in sha256-avx2-asm.S with this patch applied.  Looks like the
> > > %rsi register is being used for two different things at the same time: 'INP' and
> > > 'y3'?  You should be able to reproduce by booting a kernel configured with:
> > >
> > >         CONFIG_CRYPTO_SHA256_SSSE3=y
> > >         # CONFIG_CRYPTO_MANAGER_DISABLE_TESTS is not set
> >
> > Thanks for testing the patch. I couldn't reproduce this crash, can you
> > share the whole .config or share any other specifics of your testing
> > setup?
> >
>
> I attached the .config I used.  It reproduces on v5.2-rc1 with just this patch
> applied.  The machine you're using does have AVX2 support, right?  If you're
> using QEMU, did you make sure to pass '-cpu host'?

Thanks for your help offline on this Eric. I was able to repro the
issue and fix it, it will be part of the next iteration. You were
right that esi was used later on, I simplified the code in this
context and ran more testing on all CONFIG_CRYPTO_* options.

>
> - Eric
