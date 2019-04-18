MIME-Version: 1.0
References: <20190418154208.131118-1-glider@google.com> <20190418154208.131118-2-glider@google.com>
 <981d439a-1107-2730-f27e-17635ee4a125@intel.com>
In-Reply-To: <981d439a-1107-2730-f27e-17635ee4a125@intel.com>
From: Alexander Potapenko <glider@google.com>
Date: Thu, 18 Apr 2019 18:43:27 +0200
Message-ID: <CAG_fn=URD0WL+RE90ZE2FZM4=p2zE9V+YA2RW-LrWnuqYTwvKQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] mm: security: introduce the init_allocations=1 boot option
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Dave Hansen <dave.hansen@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Christoph Lameter <cl@linux.com>, Dmitriy Vyukov <dvyukov@google.com>, Kees Cook <keescook@chromium.org>, Laura Abbott <labbott@redhat.com>, Linux Memory Management List <linux-mm@kvack.org>, linux-security-module <linux-security-module@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Apr 18, 2019 at 6:35 PM Dave Hansen <dave.hansen@intel.com> wrote:
>
> On 4/18/19 8:42 AM, Alexander Potapenko wrote:
> > This option adds the possibility to initialize newly allocated pages an=
d
> > heap objects with zeroes. This is needed to prevent possible informatio=
n
> > leaks and make the control-flow bugs that depend on uninitialized value=
s
> > more deterministic.
>
> Isn't it better to do this at free time rather than allocation time?  If
> doing it at free, you can't even have information leaks for pages that
> are in the allocator.
I should have mentioned this in the patch description, as this
question is being asked every time I send a patch :)
If we want to avoid double initialization and take advantage of
__GFP_NOINIT (see the second and third patches in the series) we need
to do initialize the memory at allocation time, because free() and
free_pages() don't accept GFP flags.



--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
