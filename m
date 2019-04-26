MIME-Version: 1.0
References: <20190418154208.131118-1-glider@google.com> <20190418154208.131118-2-glider@google.com>
 <alpine.DEB.2.21.1904260911570.8340@nuc-kabylake> <0100016a5a3f6121-e7ed483e-bc29-4d75-bd0a-8e3b973529f5-000000@email.amazonses.com>
In-Reply-To: <0100016a5a3f6121-e7ed483e-bc29-4d75-bd0a-8e3b973529f5-000000@email.amazonses.com>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 26 Apr 2019 17:48:10 +0200
Message-ID: <CAG_fn=Uj226XJqh_wErBLW6dLvp_eP_KaEJDuqxBhvag1Q=Jwg@mail.gmail.com>
Subject: Re: [PATCH 1/3] mm: security: introduce the init_allocations=1 boot option
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Christopher Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Dmitriy Vyukov <dvyukov@google.com>, Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, Linux Memory Management List <linux-mm@kvack.org>, linux-security-module <linux-security-module@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Apr 26, 2019 at 5:24 PM Christopher Lameter <cl@linux.com> wrote:
>
> Hmmmm.... Maybe its better to zero on free? That way you dont need to
> initialize the allocations. You could even check if someone mucked with
> the object during allocation.
As mentioned somewhere in the neighboring threads, Kees requested the
options to initialize on both allocation and free, because we'll need
this functionality for memory tagging someday.
> This is a replication of some of the
> inherent debugging facilities in the allocator though.
I'm curious, how often do people use SL[AU]B poisoning and redzones these d=
ays?
Guess those should be superseded by KASAN already?
I agree it makes sense to reuse the existing debugging code, but on
the other hand we probably want to keep the initialization fast enough
to be used in production.
>
Re: poison_fn, it wasn't a good idea, so I'll be dropping it.

--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
