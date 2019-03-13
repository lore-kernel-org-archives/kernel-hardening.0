MIME-Version: 1.0
References: <20190212180441.15340-1-keescook@chromium.org> <20190212180441.15340-2-keescook@chromium.org>
 <fe87367b-f196-e8b0-6028-6378b65e5240@linux.com>
In-Reply-To: <fe87367b-f196-e8b0-6028-6378b65e5240@linux.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 13 Mar 2019 12:01:38 -0700
Message-ID: <CAGXu5jLFWv867UAL+eHoomcHFQNR3erWUChdFWSWPbehzqOzVg@mail.gmail.com>
Subject: Re: [PATCH 1/2] gcc-plugins: structleak: Generalize to all variable types
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
To: Alexander Popov <alex.popov@linux.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Emese Revfy <re.emese@gmail.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Laura Abbott <labbott@redhat.com>, Jann Horn <jannh@google.com>, Alexander Potapenko <glider@google.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Arnd Bergmann <arnd@arndb.de>, Geert Uytterhoeven <geert@linux-m68k.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Mar 11, 2019 at 4:05 PM Alexander Popov <alex.popov@linux.com> wrot=
e:
> Hello Kees, hello everyone,
>
> On 12.02.2019 21:04, Kees Cook wrote:
> > Building with CONFIG_GCC_PLUGIN_STRUCTLEAK_BYREF_ALL should give the
> > kernel complete initialization coverage of all stack variables passed
> > by reference, including padding (see lib/test_stackinit.c).
>
> I would like to note that new STRUCTLEAK_BYREF_ALL initializes *less* sta=
ck
> variables than STACKINIT, that was introduced earlier:
> https://www.openwall.com/lists/kernel-hardening/2019/01/23/3
>
> Citing the patches:
> - the STACKINIT plugin "attempts to perform unconditional initialization =
of all
> stack variables";
> - the STRUCTLEAK_BYREF_ALL feature "gives the kernel complete initializat=
ion
> coverage of all stack variables passed by reference".

That's true, yes. STACKINIT was a port of Florian's patch to gcc which
looked only for missing initialization. However, this collides with
warnings about missing initialization. :)

So, given the case that the kernel builds with -Wuninitialized and
-Wmaybe-uninitialized, the preferred method of dealing with
non-by-reference missed initializations is to fix the code itself.
(i.e. kernel builds are expected to build without warnings.) It's only
the byref cases that there is no warning (and most authors refuse to
initialize such cases). Have there been security flaws where gcc
failed to warn a missed initialization that wasn't a byref case?

> I.e. stack variables not passed by reference are not initialized by
> STRUCTLEAK_BYREF_ALL.

Correct.

> Kees, what do you think about adding such cases to your lib/test_stackini=
t.c?
> This simple example demonstrates the idea:
>
>
> diff --git a/lib/test_stackinit.c b/lib/test_stackinit.c
> index 13115b6..f9ef313 100644
> --- a/lib/test_stackinit.c
> +++ b/lib/test_stackinit.c
> @@ -320,9 +320,18 @@ static noinline __init int leaf_switch_2_none(unsign=
ed long sp, bool fill,
>  DEFINE_TEST_DRIVER(switch_1_none, uint64_t, SCALAR);
>  DEFINE_TEST_DRIVER(switch_2_none, uint64_t, SCALAR);
>
> +struct x {
> +       int x1;
> +       int x2;
> +       int x3;
> +};
> +
>  static int __init test_stackinit_init(void)
>  {
>         unsigned int failures =3D 0;
> +       struct x _x;
> +
> +       printk("uninitialized struct fields sum: %d\n", _x.x1 + _x.x2 + _=
x.x3);

This would trip the build warnings:

In file included from ./include/linux/kernel.h:15:0,
                 from lib/test_stackinit.c:9:
lib/test_stackinit.c: In function =E2=80=98test_stackinit_init=E2=80=99:
./include/linux/printk.h:309:2: warning: =E2=80=98__x.x1=E2=80=99 is used
uninitialized in this function [-Wuninitialized]
  printk(KERN_INFO pr_fmt(fmt), ##__VA_ARGS__)
  ^~~~~~

but those could be silenced for this object specifically if we really
wanted to add it. I think it'd be fine to add this to the test, but
it's a known state, though, so I hadn't bothered with it.

--=20
Kees Cook
