MIME-Version: 1.0
References: <20190412124501.132678-1-glider@google.com> <0100016a26c711be-b99971ca-49f5-482c-9028-962ee471f733-000000@email.amazonses.com>
 <CAG_fn=U6aWfBXdkcWs0_1pqggAC16Yg8Q6rxLiVeiO83q1hOCw@mail.gmail.com> <0100016a26fc7605-a9c76ac4-387c-47a3-8c53-a8d208eb0925-000000@email.amazonses.com>
In-Reply-To: <0100016a26fc7605-a9c76ac4-387c-47a3-8c53-a8d208eb0925-000000@email.amazonses.com>
From: Alexander Potapenko <glider@google.com>
Date: Wed, 17 Apr 2019 13:03:47 +0200
Message-ID: <CAG_fn=XW=-=SiAjToBNGDBdr1iZFA-9Ri_a4tF40448yPTbU4w@mail.gmail.com>
Subject: Re: [PATCH] mm: security: introduce CONFIG_INIT_HEAP_ALL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Christopher Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-security-module <linux-security-module@vger.kernel.org>, Linux Memory Management List <linux-mm@kvack.org>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitriy Vyukov <dvyukov@google.com>, Kees Cook <keescook@chromium.org>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Apr 16, 2019 at 6:30 PM Christopher Lameter <cl@linux.com> wrote:
>
> On Tue, 16 Apr 2019, Alexander Potapenko wrote:
>
> > > Hmmm... But we already have debugging options that poison objects and
> > > pages?
> > Laura Abbott mentioned in one of the previous threads
> > (https://marc.info/?l=3Dkernel-hardening&m=3D155474181528491&w=3D2) tha=
t:
> >
> > """
> > I've looked at doing something similar in the past (failing to find
> > the thread this morning...) and while this will work, it has pretty
> > serious performance issues. It's not actually the poisoning which
> > is expensive but that turning on debugging removes the cpu slab
> > which has significant performance penalties.
>
> Ok you could rework that logic to be able to keep the per cpu slabs?
I'll look into that. There's a lot going on with checking those
poisoned bytes, although we don't need that for hardening.

What do you think about the proposed approach to page initialization?
We could separate that part from slab poisoning.

> Also if you do the zeroing then you need to do it in the hotpath. And thi=
s
> patch introduces new instructions to that hotpath for checking and
> executing the zeroing.
Right now the patch doesn't slow down the default case when
CONFIG_INIT_HEAP_ALL=3Dn, as GFP_INIT_ALWAYS_ON is 0.
In the case heap initialization is enabled we could probably omit the
gfp_flags check, as it'll be always zero in the case there's a
constructor or RCU flag is set.
So we'll have two branches instead of one in the case CONFIG_INIT_HEAP_ALL=
=3Dy.



--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
