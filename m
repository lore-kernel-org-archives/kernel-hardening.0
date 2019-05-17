MIME-Version: 1.0
References: <20190514143537.10435-1-glider@google.com> <20190514143537.10435-3-glider@google.com>
 <201905151752.2BD430A@keescook>
In-Reply-To: <201905151752.2BD430A@keescook>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 17 May 2019 17:51:17 +0200
Message-ID: <CAG_fn=VVZ1FBygbAeTbdo2U2d2Zga6Z7wVitkqZB0YffCKYzag@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] lib: introduce test_meminit module
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Kees Cook <keescook@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Nick Desaulniers <ndesaulniers@google.com>, Kostya Serebryany <kcc@google.com>, Dmitry Vyukov <dvyukov@google.com>, Sandeep Patil <sspatil@android.com>, Laura Abbott <labbott@redhat.com>, Jann Horn <jannh@google.com>, Linux Memory Management List <linux-mm@kvack.org>, linux-security-module <linux-security-module@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, May 16, 2019 at 3:02 AM Kees Cook <keescook@chromium.org> wrote:
>
> On Tue, May 14, 2019 at 04:35:35PM +0200, Alexander Potapenko wrote:
> > Add tests for heap and pagealloc initialization.
> > These can be used to check init_on_alloc and init_on_free implementatio=
ns
> > as well as other approaches to initialization.
>
> This is nice! Easy way to test the results. It might be helpful to show
> here what to expect when loading this module:
Do you want me to add the expected output to the patch description?
> with either init_on_alloc=3D1 or init_on_free=3D1, I happily see:
>
>         test_meminit: all 10 tests in test_pages passed
>         test_meminit: all 40 tests in test_kvmalloc passed
>         test_meminit: all 20 tests in test_kmemcache passed
>         test_meminit: all 70 tests passed!
>
> and without:
>
>         test_meminit: test_pages failed 10 out of 10 times
>         test_meminit: test_kvmalloc failed 40 out of 40 times
>         test_meminit: test_kmemcache failed 10 out of 20 times
>         test_meminit: failures: 60 out of 70
>
>
> >
> > Signed-off-by: Alexander Potapenko <glider@google.com>
>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Tested-by: Kees Cook <keescook@chromium.org>
>
> note below...
>
> > [...]
> > diff --git a/lib/test_meminit.c b/lib/test_meminit.c
> > new file mode 100644
> > index 000000000000..67d759498030
> > --- /dev/null
> > +++ b/lib/test_meminit.c
> > @@ -0,0 +1,205 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > [...]
> > +module_init(test_meminit_init);
>
> I get a warning at build about missing the license:
>
> WARNING: modpost: missing MODULE_LICENSE() in lib/test_meminit.o
>
> So, following the SPDX line, just add:
>
> MODULE_LICENSE("GPL");
Will do, thanks!
> --
> Kees Cook



--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
