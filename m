Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20170118095155.5e3bf976@kaiwan-T460>
References: <20170118095155.5e3bf976@kaiwan-T460>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 18 Jan 2017 16:54:24 -0800
Message-ID: <CAGXu5jJD4q5rZosBrVGtgFDMeTm5uSWpSPHkkTPA3wVGZ4tkQg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [kernel-hardening] Merge in PAX_MEMORY_SANITIZE work from grsec
 to linux-next
To: Kaiwan N Billimoria <kaiwan@kaiwantech.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jan 17, 2017 at 8:21 PM, Kaiwan N Billimoria
<kaiwan@kaiwantech.com> wrote:
> So, following up on the previous discussion,

Thanks for working on this!

>>I'd like to see the mentioned excluded slab caches also done in the
>>kernel, along with similar kernel command line options. Additionally,
>>getting all the upstream stuff behind a single CONFIG (similar to
>>CONFIG_PAX_MEMORY_SANITIZE) would be great, instead of having to set 3
>>CONFIGs and 2 kernel parameters. :)
>
> Basically what I've done so far is:
> - pulled in the linux-next tree, and setup my own branch
>
> - taken the grsecurity patch (for 4.8.17) and merged those portions of
> the code encompassing the  CONFIG_PAX_MEMORY_SANITIZE directive

This is likely good for reference, but it's not going to work for
upstreaming. (And most of what I'll say below echoes Laura's email.)

> - There were some compile issues, which seem to be there mostly because o=
f other
> grsec infra that hasn't been merged in (yet).
> For now, I've just done small fixups where required:
> (see code in ptach below):
>
> [1. fs/dcache.c
>   kmem_cache_create_usercopy() unavailable (for now at least).
> Probably part of other grsec infrastructure..
>  So am just adding the SLAB_NO_SANITIZE flag to the usual
> kmem_cache_create() call.

These SLAB_NO_SANITIZE uses are one of the things I want to see added
to upstream. This flag would be used to mark the performance-sensitive
(and low security risk) slabs, and then they could be excluded from
the upstream poisoning (rather than using the PaX sanitization).

> 2. mm/slab_common.c
> Compile failure:
> enum pax_sanitize_mode pax_sanitize_slab __read_only =3D PAX_SANITIZE_SLA=
B_FAST;
>
> ?? -above orig statement from the grsec-4.8.17 patch fails compile with:
> mm/slab_common.c:34:37: error: expected =E2=80=98=3D=E2=80=99, =E2=80=98,=
=E2=80=99, =E2=80=98;=E2=80=99, =E2=80=98asm=E2=80=99 or
> =E2=80=98__attribute__=E2=80=99 before =E2=80=98__read_only=E2=80=99
>
> So I've just removed the "__read_only" attribute for now.
> What's the actual approach?

Right, this is a marking for a separate PaX feature.

> 3. mm/slub.c
> Compile failure:
> #ifdef CONFIG_PAX_MEMORY_SANITIZE
>  &sanitize_attr.attr,
>  * ?? -above statement from the grsec-4.8.17 patch fails compile with:
>  mm/slub.c:5337:3: error: =E2=80=98sanitize_attr=E2=80=99 undeclared here=
 (not in a function)
>   &sanitize_attr.attr,
>
> Just commented this out for now.
> ]

As Laura mentioned, the path for upstream sanitization is to use the
existing upstream poisoning code instead of adding new sanitization.

> =3D=3D=3D
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 28484b3..b524eda 100644
> --- a/fs/buffer.c
> +++ b/fs/buffer.c
> @@ -3511,7 +3511,7 @@ void __init buffer_init(void)
>         bh_cachep =3D kmem_cache_create("buffer_head",
>                         sizeof(struct buffer_head), 0,
>                                 (SLAB_RECLAIM_ACCOUNT|SLAB_PANIC|
> -                               SLAB_MEM_SPREAD),
> +                               SLAB_MEM_SPREAD|SLAB_NO_SANITIZE),
>                                 NULL);

Another part of this is to better understand why these slabs were
chosen to have their sanitization disabled. That needs to be expressed
to help others guide any future application of the SLAB_NO_SANITIZE
flag.

> diff --git a/mm/slab.h b/mm/slab.h
> index de6579d..2965ebe 100644
> --- a/mm/slab.h
> +++ b/mm/slab.h
> @@ -71,6 +71,36 @@ extern struct list_head slab_caches;
>  /* The slab cache that manages slab cache information */
>  extern struct kmem_cache *kmem_cache;
>
> +#ifdef CONFIG_PAX_MEMORY_SANITIZE
> +#ifdef CONFIG_X86_64
> +#define PAX_MEMORY_SANITIZE_VALUE      '\xfe'
> +#else
> +#define PAX_MEMORY_SANITIZE_VALUE      '\xff'
> +#endif

This is another element of the sanitization I'd like to bring to
upstream: changing the poison value. IIUC, these values were chosen so
that on 64-bit, if a pointer were referenced it would land at address
0xfefefe.... which is in the non-canonical memory space. For 32-bit,
the it would be at 0xffffffff so it would be at the top of memory.
This would frustrate attempts to use the existing poison value as an
actual address.

(The new upstream CONFIG would include switching this poison value...)

> +enum pax_sanitize_mode {
> +       PAX_SANITIZE_SLAB_OFF =3D 0,
> +       PAX_SANITIZE_SLAB_FAST,
> +       PAX_SANITIZE_SLAB_FULL,
> +};
> +
> +extern enum pax_sanitize_mode pax_sanitize_slab;
> +
> +static inline unsigned long pax_sanitize_slab_flags(unsigned long flags)
> +{
> +       if (pax_sanitize_slab =3D=3D PAX_SANITIZE_SLAB_OFF ||
> +           (flags & SLAB_DESTROY_BY_RCU))
> +               flags |=3D SLAB_NO_SANITIZE;
> +       else if (pax_sanitize_slab =3D=3D PAX_SANITIZE_SLAB_FULL)
> +               flags &=3D ~SLAB_NO_SANITIZE;
> +       return flags;
> +}
> +#else
> +static inline unsigned long pax_sanitize_slab_flags(unsigned long flags)
> +{
> +       return flags;
> +}
> +#endif

This contains an interesting effect: RCU slabs aren't sanitized. It's
unclear to me if that's due to the PaX sanitization implementation or
if upstream poisoning also must avoid RCU slabs.

> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 1dfc209..0a0851f 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -30,6 +30,37 @@ LIST_HEAD(slab_caches);
>  DEFINE_MUTEX(slab_mutex);
>  struct kmem_cache *kmem_cache;
>
> +#ifdef CONFIG_PAX_MEMORY_SANITIZE
> +/**
> + * enum pax_sanitize_mode pax_sanitize_slab __read_only =3D PAX_SANITIZE=
_SLAB_FAST;
> + *
> + * ?? -above orig statement from the grsec-4.8.17 patch fails compile wi=
th:
> + * mm/slab_common.c:34:37: error: expected =E2=80=98=3D=E2=80=99, =E2=80=
=98,=E2=80=99, =E2=80=98;=E2=80=99, =E2=80=98asm=E2=80=99 or =E2=80=98__att=
ribute__=E2=80=99 before =E2=80=98__read_only=E2=80=99
> + *  pax_sanitize_mode pax_sanitize_slab __read_only =3D PAX_SANITIZE_SLA=
B_FAST;
> + */
> +enum pax_sanitize_mode pax_sanitize_slab =3D PAX_SANITIZE_SLAB_FAST;
> +static int __init pax_sanitize_slab_setup(char *str)
> +{
> +       if (!str)
> +               return 0;
> +
> +       if (!strcmp(str, "0") || !strcmp(str, "off")) {
> +               pr_info("PaX slab sanitization: %s\n", "disabled");
> +               pax_sanitize_slab =3D PAX_SANITIZE_SLAB_OFF;
> +       } else if (!strcmp(str, "1") || !strcmp(str, "fast")) {
> +               pr_info("PaX slab sanitization: %s\n", "fast");
> +               pax_sanitize_slab =3D PAX_SANITIZE_SLAB_FAST;
> +       } else if (!strcmp(str, "full")) {
> +               pr_info("PaX slab sanitization: %s\n", "full");
> +               pax_sanitize_slab =3D PAX_SANITIZE_SLAB_FULL;
> +       } else
> +               pr_err("PaX slab sanitization: unsupported option '%s'\n"=
, str);
> +
> +       return 0;
> +}
> +early_param("pax_sanitize_slab", pax_sanitize_slab_setup);
> +#endif

Getting the naming right matter too. Some kind of common language for
the new CONFIG and the resulting kernel cmdline option would be nice.
I like "sanitize", though everything else in upstream currently uses
"poison". Due to the behavioral changes (poison values changing and
optional poisoning), perhaps it shouldn't be called "poison". I'm open
to ideas! :)

> diff --git a/security/Kconfig b/security/Kconfig
> index 118f454..3ad5110 100644
> --- a/security/Kconfig
> +++ b/security/Kconfig
> @@ -4,6 +4,46 @@
>
>  menu "Security options"
>
> +menu "Miscellaneous hardening features"
> +
> +config PAX_MEMORY_SANITIZE
> +       bool "Sanitize all freed memory"
> +       default y if (GRKERNSEC_CONFIG_AUTO && GRKERNSEC_CONFIG_PRIORITY_=
SECURITY)
> +       help
> +         By saying Y here the kernel will erase memory pages and slab ob=
jects
> +         as soon as they are freed.  This in turn reduces the lifetime o=
f data
> +         stored in them, making it less likely that sensitive informatio=
n such
> +         as passwords, cryptographic secrets, etc stay in memory for too=
 long.
> +
> +         This is especially useful for programs whose runtime is short, =
long
> +         lived processes and the kernel itself benefit from this as long=
 as
> +         they ensure timely freeing of memory that may hold sensitive
> +         information.
> +
> +         A nice side effect of the sanitization of slab objects is the
> +         reduction of possible info leaks caused by padding bytes within=
 the
> +         leaky structures.  Use-after-free bugs for structures containin=
g
> +         pointers can also be detected as dereferencing the sanitized po=
inter
> +         will generate an access violation.

It may be worth noting that new kernel stacks may be filled with the
poison value (since they were at some time freed and reallocated as a
kernel stack), though this needs some further examination, especially
since stacks have moved to vmap.

> +         The tradeoff is performance impact, on a single CPU system kern=
el
> +         compilation sees a 3% slowdown, other systems and workloads may=
 vary
> +         and you are advised to test this feature on your expected workl=
oad
> +         before deploying it.

I'd like to see benchmarks against upstream's implementation (I linked
to my earlier efforts at this before).

> +         The slab sanitization feature excludes a few slab caches per de=
fault
> +         for performance reasons.  To extend the feature to cover those =
as
> +         well, pass "pax_sanitize_slab=3Dfull" as kernel command line pa=
rameter.
> +
> +         To reduce the performance penalty by sanitizing pages only, alb=
eit
> +         limiting the effectiveness of this feature at the same time, sl=
ab
> +         sanitization can be disabled with the kernel command line param=
eter
> +         "pax_sanitize_slab=3Doff".
> +
> +         Note that this feature does not protect data stored in live pag=
es,
> +         e.g., process memory swapped to disk may stay there for a long =
time.
> +endmenu
> +
>  source security/keys/Kconfig
>
>  config SECURITY_DMESG_RESTRICT

This likely needs to live near the other POISON configs, and, as Laura
mentioned, needs to select the various parts from upstream needed to
enable poisoning. Also, the kernel command line options needed for
upstream poisoning to be enabled need to check against the new CONFIG.

For testing, you can try out the LKDTM tests that cover poisoning,
namely READ_AFTER_FREE and READ_BUDDY_AFTER_FREE.

-Kees

--=20
Kees Cook
Nexus Security
