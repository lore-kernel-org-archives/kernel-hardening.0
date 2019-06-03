MIME-Version: 1.0
References: <20190529123812.43089-1-glider@google.com> <20190529123812.43089-3-glider@google.com>
 <20190531181832.e7c3888870ce9e50db9f69e6@linux-foundation.org>
In-Reply-To: <20190531181832.e7c3888870ce9e50db9f69e6@linux-foundation.org>
From: Alexander Potapenko <glider@google.com>
Date: Mon, 3 Jun 2019 11:24:49 +0200
Message-ID: <CAG_fn=XBq-ipvZng3hEiGwyQH2rRNFbN_Cj0r+5VoJqou0vovA@mail.gmail.com>
Subject: Re: [PATCH v5 2/3] mm: init: report memory auto-initialization
 features at boot time
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Andrew Morton <akpm@linux-foundation.org>, Kees Cook <keescook@chromium.org>
Cc: Christoph Lameter <cl@linux.com>, Dmitry Vyukov <dvyukov@google.com>, James Morris <jmorris@namei.org>, Jann Horn <jannh@google.com>, Kostya Serebryany <kcc@google.com>, Laura Abbott <labbott@redhat.com>, Mark Rutland <mark.rutland@arm.com>, Masahiro Yamada <yamada.masahiro@socionext.com>, Matthew Wilcox <willy@infradead.org>, Nick Desaulniers <ndesaulniers@google.com>, Randy Dunlap <rdunlap@infradead.org>, Sandeep Patil <sspatil@android.com>, "Serge E. Hallyn" <serge@hallyn.com>, Souptick Joarder <jrdr.linux@gmail.com>, Marco Elver <elver@google.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux Memory Management List <linux-mm@kvack.org>, linux-security-module <linux-security-module@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Jun 1, 2019 at 3:18 AM Andrew Morton <akpm@linux-foundation.org> wr=
ote:
>
> On Wed, 29 May 2019 14:38:11 +0200 Alexander Potapenko <glider@google.com=
> wrote:
>
> > Print the currently enabled stack and heap initialization modes.
> >
> > The possible options for stack are:
> >  - "all" for CONFIG_INIT_STACK_ALL;
> >  - "byref_all" for CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL;
> >  - "byref" for CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF;
> >  - "__user" for CONFIG_GCC_PLUGIN_STRUCTLEAK_USER;
> >  - "off" otherwise.
> >
> > Depending on the values of init_on_alloc and init_on_free boottime
> > options we also report "heap alloc" and "heap free" as "on"/"off".
>
> Why?
>
> Please fully describe the benefit to users so that others can judge the
> desirability of the patch.  And so they can review it effectively, etc.
I'm going to update the description with the following passage:

    Print the currently enabled stack and heap initialization modes.

    Stack initialization is enabled by a config flag, while heap
    initialization is configured at boot time with defaults being set
    in the config. It's more convenient for the user to have all informatio=
n
    about these hardening measures in one place.

Does this make sense?
> Always!
>
> > In the init_on_free mode initializing pages at boot time may take some
> > time, so print a notice about that as well.
>
> How much time?
I've seen pauses up to 1 second, not actually sure they're worth a
separate line in the log.
Kees, how long were the delays in your case?



--=20
Alexander Potapenko
Software Engineer

Google Germany GmbH
Erika-Mann-Stra=C3=9Fe, 33
80636 M=C3=BCnchen

Gesch=C3=A4ftsf=C3=BChrer: Paul Manicle, Halimah DeLaine Prado
Registergericht und -nummer: Hamburg, HRB 86891
Sitz der Gesellschaft: Hamburg
