MIME-Version: 1.0
In-Reply-To: <CALMp9eT_G_Mhsk1k7Xc8L+bnpFwTUoC=ae4LhB1ppqKynKEQ9g@mail.gmail.com>
References: <20170214194259.75960-1-thgarnie@google.com> <20170214194259.75960-4-thgarnie@google.com>
 <CALMp9eT_G_Mhsk1k7Xc8L+bnpFwTUoC=ae4LhB1ppqKynKEQ9g@mail.gmail.com>
From: Thomas Garnier <thgarnie@google.com>
Date: Fri, 17 Feb 2017 12:11:00 -0800
Message-ID: <CAJcbSZESdSQncHeKNVzHO90W7UJUKxKGy-h+rM82OhBc-Nh=cg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3 4/4] KVM: VMX: Simplify segment_base
To: Jim Mattson <jmattson@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Paul Gortmaker <paul.gortmaker@windriver.com>, Andy Lutomirski <luto@amacapital.net>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Jiri Kosina <jikos@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Rusty Russell <rusty@rustcorp.com.au>, Peter Zijlstra <peterz@infradead.org>, Christian Borntraeger <borntraeger@de.ibm.com>, "Luis R . Rodriguez" <mcgrof@kernel.org>, He Chen <he.chen@linux.intel.com>, Brian Gerst <brgerst@gmail.com>, Stanislaw Gruszka <sgruszka@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Adam Buchbinder <adam.buchbinder@gmail.com>, Dave Hansen <dave.hansen@intel.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Tim Chen <tim.c.chen@linux.intel.com>, Rik van Riel <riel@redhat.com>, Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Michael Ellerman <mpe@ellerman.id.au>, Joerg Roedel <joro@8bytes.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, the arch/x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, kasan-dev <kasan-dev@googlegroups.com>, Linux PM list <linux-pm@vger.kernel.org>, linux-efi@vger.kernel.org, xen-devel@lists.xenproject.org, lguest@lists.ozlabs.org, kvm list <kvm@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 17, 2017 at 9:49 AM, Jim Mattson <jmattson@google.com> wrote:
>
> Can we use the read-only GDT here? When expanding the virtual address
> for 64-bit system descriptors, isn't it sufficient to check (d->s == 0
> && d->type != 0)?

We can use the readonly GDT but I think doesn't matter one or the
other here. We have to check specific types for LDT or TSS, other
values describe other entries (cf Intel volume 3, 3.5) (for example 14
& 15 on 64-bits are for trap & interrupt gates).

>
>
> On Tue, Feb 14, 2017 at 11:42 AM, Thomas Garnier <thgarnie@google.com> wrote:
> > The KVM segment_base function is confusing. This patch replaces integers
> > with appropriate flags, simplify constructs and add comments.
> >
> > Signed-off-by: Thomas Garnier <thgarnie@google.com>
> > ---
> > Based on next-20170213
> > ---
> >  arch/x86/kvm/vmx.c | 26 ++++++++++++++++++--------
> >  1 file changed, 18 insertions(+), 8 deletions(-)
> >
> > diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
> > index 99167f20bc34..edb8326108dd 100644
> > --- a/arch/x86/kvm/vmx.c
> > +++ b/arch/x86/kvm/vmx.c
> > @@ -2062,25 +2062,35 @@ static unsigned long segment_base(u16 selector)
> >         struct desc_struct *d;
> >         unsigned long table_base;
> >         unsigned long v;
> > +       u32 high32;
> >
> > -       if (!(selector & ~3))
> > +       if (!(selector & ~SEGMENT_RPL_MASK))
> >                 return 0;
> >
> > -       table_base = get_current_gdt_rw_vaddr();
> > -
> > -       if (selector & 4) {           /* from ldt */
> > +       /* LDT selector */
> > +       if ((selector & SEGMENT_TI_MASK) == SEGMENT_LDT) {
> >                 u16 ldt_selector = kvm_read_ldt();
> >
> > -               if (!(ldt_selector & ~3))
> > +               if (!(ldt_selector & ~SEGMENT_RPL_MASK))
> >                         return 0;
> >
> >                 table_base = segment_base(ldt_selector);
> > +       } else {
> > +               table_base = get_current_gdt_rw_vaddr();
> >         }
> > -       d = (struct desc_struct *)(table_base + (selector & ~7));
> > +
> > +       d = (struct desc_struct *)table_base + (selector >> 3);
> >         v = get_desc_base(d);
> >  #ifdef CONFIG_X86_64
> > -       if (d->s == 0 && (d->type == 2 || d->type == 9 || d->type == 11))
> > -               v |= ((unsigned long)((struct ldttss_desc64 *)d)->base3) << 32;
> > +       /*
> > +        * Extend the virtual address if we have a system descriptor entry for
> > +        * LDT or TSS (available or busy).
> > +        */
> > +       if (d->s == 0 && (d->type == DESC_LDT || d->type == DESC_TSS ||
> > +                         d->type == 11/*Busy TSS */)) {
> > +               high32 = ((struct ldttss_desc64 *)d)->base3;
> > +               v |= (u64)high32 << 32;
> > +       }
> >  #endif
> >         return v;
> >  }
> > --
> > 2.11.0.483.g087da7b7c-goog
> >




-- 
Thomas
