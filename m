MIME-Version: 1.0
References: <20180529221625.33541-1-thgarnie@google.com> <20180529221625.33541-19-thgarnie@google.com>
 <cfd5f012-4ce2-639b-9ff0-4ad627805fd4@oracle.com>
In-Reply-To: <cfd5f012-4ce2-639b-9ff0-4ad627805fd4@oracle.com>
From: Thomas Garnier <thgarnie@google.com>
Date: Fri, 1 Jun 2018 08:53:21 -0700
Message-ID: <CAJcbSZEAo2G_nAwdPVYWr5WxKUEb5HnfzUjewzQo+p1jpfPDMw@mail.gmail.com>
Subject: Re: [PATCH v4 18/27] xen: Adapt assembly for PIE support
Content-Type: text/plain; charset="UTF-8"
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, the arch/x86 maintainers <x86@kernel.org>, Juergen Gross <jgross@suse.com>, Greg KH <gregkh@linuxfoundation.org>, Kate Stewart <kstewart@linuxfoundation.org>, "H . J . Lu" <hjl.tools@gmail.com>, LKML <linux-kernel@vger.kernel.org>, xen-devel <xen-devel@lists.xenproject.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Jun 1, 2018 at 8:40 AM Boris Ostrovsky
<boris.ostrovsky@oracle.com> wrote:
>
> On 05/29/2018 06:15 PM, Thomas Garnier wrote:
> > diff --git a/arch/x86/xen/xen-pvh.S b/arch/x86/xen/xen-pvh.S
> > index ca2d3b2bf2af..82ba89ba8bb3 100644
> > --- a/arch/x86/xen/xen-pvh.S
> > +++ b/arch/x86/xen/xen-pvh.S
> > @@ -114,8 +114,8 @@ ENTRY(pvh_start_xen)
> >       call xen_prepare_pvh
> >
> >       /* startup_64 expects boot_params in %rsi. */
> > -     mov $_pa(pvh_bootparams), %rsi
> > -     mov $_pa(startup_64), %rax
> > +     movabs $_pa(pvh_bootparams), %rsi
> > +     movabs $_pa(startup_64), %rax
> >       jmp *%rax
> >
> >  #else /* CONFIG_X86_64 */
> > @@ -161,10 +161,15 @@ END(pvh_start_xen)
> >
> >       .section ".init.data","aw"
> >       .balign 8
> > +     /*
> > +      * Use a quad for _pa(gdt_start) because PIE does not understand a
> > +      * long is enough. The resulting value will still be in the lower long
> > +      * part.
> > +      */
> >  gdt:
> >       .word gdt_end - gdt_start
> > -     .long _pa(gdt_start)
> > -     .word 0
> > +     .quad _pa(gdt_start)
>
>
> With this becoming .quad 32-bit compilation fails:
>
> /data/root/linux/arch/x86/xen/xen-pvh.S: Assembler messages:
> /data/root/linux/arch/x86/xen/xen-pvh.S:147: Error: cannot represent
> relocation type BFD_RELOC_64

Thanks, I will look to fix this in the next patch set and run a full
32-bit build.

>
>
> -boris
>
>
> > +     .balign 8
> >  gdt_start:
> >       .quad 0x0000000000000000            /* NULL descriptor */
> >  #ifdef CONFIG_X86_64
>


-- 
Thomas
