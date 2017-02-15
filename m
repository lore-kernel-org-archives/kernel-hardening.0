Date: Tue, 14 Feb 2017 22:56:26 -0700
From: Eddie Kovsky <ewk@edkovsky.org>
Message-ID: <20170215055626.GC32572@athena>
References: <20170212233140.10606-1-ewk@edkovsky.org>
 <20170212233140.10606-2-ewk@edkovsky.org>
 <CAGXu5jLt3W9_KFeb7VSz4z-XAqWFDMM2i=3YGRFKmAfu0RGvng@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jLt3W9_KFeb7VSz4z-XAqWFDMM2i=3YGRFKmAfu0RGvng@mail.gmail.com>
Subject: [kernel-hardening] Re: [RFC] [PATCH 1/2] module: verify address is read-only
To: Kees Cook <keescook@chromium.org>
Cc: Jessica Yu <jeyu@redhat.com>, Rusty Russell <rusty@rustcorp.com.au>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 02/13/17, Kees Cook wrote:
> On Sun, Feb 12, 2017 at 3:31 PM, Eddie Kovsky <ewk@edkovsky.org> wrote:
> > Implement a mechanism to check if a module's address is in
> > the rodata or ro_after_init sections. It mimics the exsiting functions
> > that test if an address is inside a module's text section.
> >
> > Signed-off-by: Eddie Kovsky <ewk@edkovsky.org>
> > ---
> >  include/linux/module.h |  2 ++
> >  kernel/module.c        | 44 ++++++++++++++++++++++++++++++++++++++++++++
> >  2 files changed, 46 insertions(+)
> >
> > diff --git a/include/linux/module.h b/include/linux/module.h
> > index 0297c5cd7cdf..2848416f7715 100644
> > --- a/include/linux/module.h
> > +++ b/include/linux/module.h
> > @@ -492,7 +492,9 @@ static inline int module_is_live(struct module *mod)
> >
> >  struct module *__module_text_address(unsigned long addr);
> >  struct module *__module_address(unsigned long addr);
> > +struct module *__module_ro_address(unsigned long addr);
> >  bool is_module_address(unsigned long addr);
> > +bool is_module_ro_address(unsigned long addr);
> >  bool is_module_percpu_address(unsigned long addr);
> >  bool is_module_text_address(unsigned long addr);
>
> This will need the !CONFIG_MODULES stubs added as well (see
> __module_address()). e.g.:
>
> ...
> #else /* !CONFIG_MODULES... */
> ...
> static incline struct module *__module_ro_address(unsigned long addr)
> {
>        return NULL;
> }
> ...
> #endif
>
> >
> > diff --git a/kernel/module.c b/kernel/module.c
> > index 8168eb738f4d..e7eb329c585d 100644
> > --- a/kernel/module.c
> > +++ b/kernel/module.c
> > @@ -4270,6 +4270,50 @@ struct module *__module_text_address(unsigned long addr)
> >  }
> >  EXPORT_SYMBOL_GPL(__module_text_address);
> >
> > +/**
> > + * is_module_text_ro_address - is this address inside read-only module code?
> > + * @addr: the address to check.
> > + *
> > + */
> > +bool is_module_ro_address(unsigned long addr)
> > +{
> > +       bool ret;
> > +
> > +       preempt_disable();
> > +       ret = __module_ro_address(addr) != NULL;
> > +       preempt_enable();
> > +
> > +       return ret;
> > +}
> > +
> > +/*
> > + * __module_ro_address - get the module whose code contains a read-only address.
> > + * @addr: the address.
> > + *
> > + * Must be called with preempt disabled or module mutex held so that
> > + * module doesn't get freed during this.
> > + */
> > +struct module *__module_ro_address(unsigned long addr)
> > +{
> > +       struct module *mod = __module_address(addr);
> > +
> > +       if (mod) {
> > +               /* Make sure it's within the read-only section. */
> > +               if (!within(addr, mod->init_layout.base,
> > +                           mod->init_layout.ro_size)
> > +                   && !within(addr, mod->core_layout.base,
> > +                              mod->core_layout.ro_size))
> > +                       mod = NULL;
> > +               if (!within(addr, mod->init_layout.base,
> > +                           mod->init_layout.ro_after_init_size)
> > +                   && !within(addr, mod->core_layout.base,
> > +                              mod->core_layout.ro_after_init_size))
> > +                       mod = NULL;
> > +       }
> > +       return mod;
> > +}
> > +EXPORT_SYMBOL_GPL(__module_ro_address);
>
> This follows what is_module_address() does, so that seems sensible to
> me. I defer to Jessica and Rusty, though. :)
>
> -Kees
>
> --
> Kees Cook
> Pixel Security

I'll fix this up and add the vmbus_register() patch for the next series.

Thanks

Eddie
