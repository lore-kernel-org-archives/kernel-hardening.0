Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAGXu5j+7_cd4GgX46wSMv9LHpogwH7qrU8=K8OPEed4hCGr65g@mail.gmail.com>
References: <1475476886-26232-1-git-send-email-elena.reshetova@intel.com>
 <1475476886-26232-2-git-send-email-elena.reshetova@intel.com> <CAGXu5j+7_cd4GgX46wSMv9LHpogwH7qrU8=K8OPEed4hCGr65g@mail.gmail.com>
From: David Windsor <dwindsor@gmail.com>
Date: Mon, 3 Oct 2016 17:26:14 -0400
Message-ID: <CAEXv5_h55L8UyYpFy6qQUPBqGfxOOR+DEXywbNVkBb89a336UQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC PATCH 01/13] Add architecture independent hardened atomic base
To: Kees Cook <keescook@chromium.org>
Cc: Elena Reshetova <elena.reshetova@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Hans Liljestrand <ishkamiel@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Oct 3, 2016 at 5:10 PM, Kees Cook <keescook@chromium.org> wrote:

> > +}
> > +#endif
> > diff --git a/security/Kconfig b/security/Kconfig
> > index 118f454..dc39f7e 100644
> > --- a/security/Kconfig
> > +++ b/security/Kconfig
> > @@ -158,6 +158,21 @@ config HARDENED_USERCOPY_PAGESPAN
> >           been removed. This config is intended to be used only while
> >           trying to find such users.
> >
> > +config HAVE_ARCH_HARDENED_ATOMIC
> > +       bool
> > +       help
> > +         The architecture supports CONFIG_HARDENED_ATOMIC by
> > +         providing additional checks on counter overflows for atomic_t
> > +
> > +config HARDENED_ATOMIC
> > +       bool "Prevent reference counter overflow in atomic_t"
> > +       depends on HAVE_ARCH_HARDENED_ATOMIC
>
> Oh, this should select BUG too.
>
> > +       help
> > +         This option prevents reference counters in atomic_t from
> > +         overflow. This allows to avoid the
> > +         situation when counter overflow leads to an exploitable
> > +         use-after-free situation.
>
> I think the Kconfig help text could be clarified up a bit (and needs
> some minor formatting adjustments). Perhaps something like:
>
> config HAVE_ARCH_HARDENED_ATOMIC
> ...
>   The architecture supports CONFIG_HARDENED_ATOMIC by
>   providing trapping on atomic_t wraps, with a call to
>   hardened_atomic_overflow().
>
> config HARDENED_ATOMIC
> ...
>   This option catches counter wrapping in atomic_t, which
>   can turn refcounting over/underflow bugs into resource
>   consumption bugs instead of exploitable user-after-free flaws.
>

Sorry to be pedantic, but this feature doesn't actually protect
against underflowing atomic_t, and you actually meant "use-after-free"
flaws.

Do we want to mention something about the negligible performance
impact, as is done in the original PAX_REFCOUNT feature:
  Since this has a negligible performance impact, you should enable
this feature.

Not sure if we eventually envision this feature being on-by-default;
if not, it may be useful to include this text.

> > +
> >  source security/selinux/Kconfig
> >  source security/smack/Kconfig
> >  source security/tomoyo/Kconfig
> > --
> > 2.7.4
> >
>
> -Kees
>
> --
> Kees Cook
> Nexus Security
