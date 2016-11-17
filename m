Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 17 Nov 2016 12:32:25 +0100 (CET)
From: Julia Lawall <julia.lawall@lip6.fr>
In-Reply-To: <20161117111909.GB12273@leverpostej>
Message-ID: <alpine.DEB.2.10.1611171230000.2913@hadrien>
References: <CAGXu5j+_wdv_vn=Us-i=bvCwCGk5Ks_gpoK9bHja4dDNUZi9eQ@mail.gmail.com> <20161111201704.GQ3117@twins.programming.kicks-ass.net> <CAGXu5jJG0LUxLPtqr79PG=RmWgV96sy2j7dQKr9yvjadzrc3Ag@mail.gmail.com> <1479228602.4622.64.camel@redhat.com>
 <CAGXu5j+eA9wPMpM18iiD0RVX7UZVoLRn8JBKG2d8b3FF5+vwKw@mail.gmail.com> <1479316156.21171.30.camel@redhat.com> <2236FBA76BA1254E88B949DDB74E612B41C1196C@IRSMSX102.ger.corp.intel.com> <20161117083718.GA3142@twins.programming.kicks-ass.net>
 <alpine.DEB.2.10.1611171035480.2913@hadrien> <20161117101642.GG3142@twins.programming.kicks-ass.net> <20161117111909.GB12273@leverpostej>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Subject: Re: [kernel-hardening] Re: [RFC v4 PATCH 00/13] HARDENED_ATOMIC
To: Mark Rutland <mark.rutland@arm.com>
Cc: kernel-hardening@lists.openwall.com, "Reshetova, Elena" <elena.reshetova@intel.com>, Rik van Riel <riel@redhat.com>, Will Deacon <will.deacon@arm.com>, Greg KH <gregkh@linuxfoundation.org>, David Windsor <dave@progbits.org>, Arnd Bergmann <arnd@arndb.de>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "Anvin, H Peter" <h.peter.anvin@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>



On Thu, 17 Nov 2016, Mark Rutland wrote:

> On Thu, Nov 17, 2016 at 11:16:42AM +0100, Peter Zijlstra wrote:
> > On Thu, Nov 17, 2016 at 10:36:47AM +0100, Julia Lawall wrote:
> > > On Thu, 17 Nov 2016, Peter Zijlstra wrote:
>
> > > > Also, we should really have a "make spatch" target so that we can run
> > > > the thing concurrently with -j80 or somesuch, because as is coccinelle
> > > > is unbearably slow.
> > >
> > > In the kernel, there is already the make coccicheck infrastructure.  It
> > > suffices to add the semantic patch to a subdirectory of
> > > scripts/coccinelle.
> >
> > Shiny.. however:
> >
> > $ make coccicheck COCCI=kref.cocci MODE=patch V=1
> > /bin/bash ./scripts/coccicheck
> >
> > Please check for false positives in the output before submitting a patch.
> > When using "patch" mode, carefully review the patch before submitting it.
> >
> > Processing kref.cocci
> > with option(s) ""
> >
> > Message example to submit a patch:
> >  The semantic patch that makes this change is available
> >  in kref.cocci.
> >
> >  More information about semantic patching is available at
> >  http://coccinelle.lip6.fr/
> >
> > Running (8 in parallel): /usr/bin/spatch -D patch --very-quiet --cocci-file kref.cocci --dir . -I ./arch/x86/include -I ./arch/x86/include/generated/uapi -I ./arch/x86/include/generated -I ./include -I ./arch/x86/include/uapi -I ./include/uapi -I ./include/generated/uapi --include ./include/linux/kconfig.h --jobs 8 --chunksize 1
> > coccicheck failed
>
> How odd. I took your patch, added a "virtual patch" line, and ran:

The virtual patch line solves the coccicheck failed problem.

> $ make coccicheck COCCI=/home/mark/kref.cocci MODE=patch > kref.patch
>
> ... and after ~30 seconds I had a valid looking patch on stdout.

You're not doing the --recursive-includes with all the include paths
available.  I've been doing some experiments to see whether there are some
options that will give reasonble results in a reasonable amount of time.
Unfortunately on the one hand refcount is a common field name and on the
ther hand --recursive-includes requires procssing a huge amount of code
for each file.

julia

> [mark@leverpostej:~/src/linux]% spatch --version
> spatch version 1.0.0-rc19 with Python support and with PCRE support
>
> I'm using a v4.9-rc4 tree.
>
> Thanks,
> Mark.
>
