Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 17 Jan 2017 18:07:47 +0000
From: Dave P Martin <Dave.Martin@arm.com>
Message-ID: <20170117180746.GN18838@e103592.cambridge.arm.com>
References: <20170113220256.GA57663@beast>
 <587D1D70.26193.89AFE10@pageexec.freemail.hu>
 <20170117104239.GG18838@e103592.cambridge.arm.com>
 <587E4FDD.31940.D47F642@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <587E4FDD.31940.D47F642@pageexec.freemail.hu>
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [PATCH] gcc-plugins: Add structleak for more stack initialization
To: PaX Team <pageexec@freemail.hu>
Cc: Kees Cook <keescook@chromium.org>, Mark Rutland <mark.rutland@arm.com>, kernel-hardening@lists.openwall.com, Emese Revfy <re.emese@gmail.com>, "AKASHI, Takahiro" <takahiro.akashi@linaro.org>, park jinbum <jinb.park7@gmail.com>, Daniel Micay <danielmicay@gmail.com>, linux-kernel@vger.kernel.org, spender@grsecurity.net
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jan 17, 2017 at 06:09:49PM +0100, PaX Team wrote:
> On 17 Jan 2017 at 10:42, Dave P Martin wrote:
>
> > On Mon, Jan 16, 2017 at 08:22:24PM +0100, PaX Team wrote:
> > > the 'issue' is that before C11 the standard didn't make it clear that=
 in
> > > case of a partial initializer list the compiler has to initialize not=
 only
> > > the remaining fields but also padding as well.
> >
> > Which version of the C11 spec clarifies this?
> >
> > The one I'm looking at (n1570, Apr 12 2011) says:
> >
> > "6.7.9 21 If there are fewer initializers in a brace-enclosed list than
> > there are elements or members of an aggregate, or fewer characters in a
> > string literal used to initialize an array of known size than there are
> > elements in the array, the remainder of the aggregate shall be
> > initialized implicitly the same as objects that have static storage
> > duration."
> >
> > What is meant by "the remainder of the object" is unclear.
>
> it's less unclear if you also take into account the rest of the
> sentence that says "[initialized] the same as objects that have
> static storage duration" which in turn is described at 6.7.9p10
> where it says among others:
>
>   "if it is an aggregate, every member is initialized (recursively)
>    according to these rules, and any padding is initialized to zero bits"
>
> the "and any padding is initialized to zero bits" was the addition
> in C11 (which i'm not sure was meant as a new feature for C11 or
> just official enshrinement of what had always been meant).
>
> >  Is this just the tail of the object, or all unitialised members --
> > which may be sparse in the case of an initialiser with designators? And
> > is padding (and if so, which padding) considered to be part of (the
> > remainder of) the object for the purpose of this paragraph?
>
> to me the quote about 'any padding' is for all kinds of padding.
> uninitialized members are described in the same paragraph.
>
> > This can be read with the interpretation you suggest, but the wording
> > doesn't seem rock-solid.  For the kernel, I guess it's sufficient if
> > GCC commits to this interpretation though.
>
> note that i'm not a language lawyer, merely an interpreter, so take
> the above with a grain of salt.

Me neither, but actually I think this interpretation doesn't make sense.
The implication seems to be that padding initialisation of initialised
aggregates with automatic storage is guaranteed _only_ if the
initialiser is incomplete.


Paragraph 19 always applies, but that only asserts "all subobjects that
are not initialized explicitly shall be initialized implicitly the same
as objects that have static storage duration" -- no statement about
padding.

Paragraph 21 guarantees initialisation of padding bytes, but applies
_only_ if the initializer list is incomplete.


As a random test, a recent-ish gcc might actually apply this
interpretation...


tst.c
---8<---

struct foo {
        long x;
        char y;
        long z;
        int w;
};

void f(struct foo *);

void g(long *x, char *y, long *z, int *w)
{
        struct foo o =3D { .z =3D *z, .y =3D *y, .x =3D *x, .w =3D *w };

        f(&o);
}

void h(int *y, long *z)
{
        struct foo o =3D { .z =3D *z, .y =3D *y };

        f(&o);
}

--->8---


$ gcc (Debian 6.3.0-2) 6.3.0 20161229
$ gcc -Wall -Wextra -pedantic -O2 -std=3Dc11 -c tst.c
$ objdump -d tst.o

tst.o:     file format elf64-littleaarch64


Disassembly of section .text:

0000000000000000 <g>:
   0:   a9bd7bfd        stp     x29, x30, [sp, #-48]!
   4:   910003fd        mov     x29, sp
   8:   39400024        ldrb    w4, [x1]
   c:   f9400005        ldr     x5, [x0]
  10:   910043a0        add     x0, x29, #0x10
  14:   b9400061        ldr     w1, [x3]
  18:   f9400042        ldr     x2, [x2]
  1c:   390063a4        strb    w4, [x29, #24]
  20:   f9000ba5        str     x5, [x29, #16]
  24:   f90013a2        str     x2, [x29, #32]
  28:   b9002ba1        str     w1, [x29, #40]
  2c:   94000000        bl      0 <f>
  30:   a8c37bfd        ldp     x29, x30, [sp], #48
  34:   d65f03c0        ret

0000000000000038 <h>:
  38:   a9bd7bfd        stp     x29, x30, [sp, #-48]!
  3c:   910003fd        mov     x29, sp
  40:   b9400002        ldr     w2, [x0]
  44:   910043a0        add     x0, x29, #0x10
  48:   f9400021        ldr     x1, [x1]
  4c:   a9017fbf        stp     xzr, xzr, [x29, #16]
  50:   a9027fbf        stp     xzr, xzr, [x29, #32]
  54:   390063a2        strb    w2, [x29, #24]
  58:   f90013a1        str     x1, [x29, #32]
  5c:   94000000        bl      0 <f>
  60:   a8c37bfd        ldp     x29, x30, [sp], #48
  64:   d65f03c0        ret


In g(), where the initialiser is complete, the padding in o is
definitely not zeroed out.  In h(), the padding is all zeroed out,
including padding around the zeoed members -- whether gcc intentionally
guarantees this or it's just a coincidence, I don't know.

This may or may not be a bug, and may or may not have been fixed in a
more recent version.

>
> > A related, perhaps more interesting issue is that C11 still explicitly
> > states that padding is undefined after assignment:
>
> you probably meant 'unspecified'?

Indeed.  Sloppy of me...

> > "6.2.6.1 6 When a value is stored in an object of structure or union
> > type, including in a member object, the bytes of the object
> > representation that correspond to any padding bytes take unspecified
> > values.  51)"
> >
> > "51) Thus, for example, structure assignment need not copy any padding
> > bits."
> >
> > which means that in:
> >
> > {
> >         struct foo foo1 =3D FOO1_INTIALIZER;
> >         struct foo foo2;
> >
> >         foo2 =3D foo1;
> > }
> >
> > the contents of padding in foo2 is unspecified.
> >
> > Similarly, piecemeal initialisation of an object by assigning to every
> > member leaves the padding unspecified, e.g.:
> >
> > {
> >         struct timeval tv;
> >
> >         tv.tv_sec =3D secs;
> >         tv.tv_usec =3D usecs;
> > }
> >
> > (On most or all arches struct timeval contains no padding, but relying
> > implicitly on this is still a bit iffy.)
> >
> >
> > It's highly likely that the kernel passes objects resulting from one of
> > the above to put_user() and friends.  It would be good if we had a way
> > to catch at least some of these.
>
> both examples would be handled by the plugin if the types involved alread=
y
> have a __user annotated field (as neither foo2 nor tv are initialized, on=
ly
> assigned to), otherwise it'd need manual annotation and/or more static an=
alysis.

Do you see any false positives here?  I would expect a fair number of
structures that contain __user pointers but that are never copied
wholesale to userspace, but I've not reviewed in detail.

I would also expect false negatives to be common -- structures that lack
__user pointers but _are_ copied to userspace.  But again, if this
plugin is not designed to catch these in the first place, this may be
best addressed in a different way.

Cheers
---Dave
IMPORTANT NOTICE: The contents of this email and any attachments are confid=
ential and may also be privileged. If you are not the intended recipient, p=
lease notify the sender immediately and do not disclose the contents to any=
 other person, use it for any purpose, or store or copy the information in =
any medium. Thank you.
