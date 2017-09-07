Date: Thu, 7 Sep 2017 12:50:02 -0600
From: Tycho Andersen <tycho@docker.com>
Message-ID: <20170907185002.g5r5oaeyghtx2fgl@docker>
References: <20170907173609.22696-1-tycho@docker.com>
 <20170907173609.22696-4-tycho@docker.com>
 <c08ca2d4ac7f4b9a8987f282e697d30c@HQMAIL105.nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c08ca2d4ac7f4b9a8987f282e697d30c@HQMAIL105.nvidia.com>
Subject: [kernel-hardening] Re: [PATCH v6 03/11] mm, x86: Add support for eXclusive Page Frame
 Ownership (XPFO)
To: Ralph Campbell <rcampbell@nvidia.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-mm@kvack.org" <linux-mm@kvack.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Marco Benatto <marco.antonio.780@gmail.com>, Juerg Haefliger <juerg.haefliger@canonical.com>, "x86@kernel.org" <x86@kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Sep 07, 2017 at 06:33:09PM +0000, Ralph Campbell wrote:
> > --- a/Documentation/admin-guide/kernel-parameters.txt
> > +++ b/Documentation/admin-guide/kernel-parameters.txt
> > @@ -2736,6 +2736,8 @@
> > 
> >  	nox2apic	[X86-64,APIC] Do not enable x2APIC mode.
> > 
> > +	noxpfo		[X86-64] Disable XPFO when CONFIG_XPFO is on.
> > +
> >  	cpu0_hotplug	[X86] Turn on CPU0 hotplug feature when
> >  			CONFIG_BOOTPARAM_HOTPLUG_CPU0 is off.
> >  			Some features depend on CPU0. Known dependencies
> <... snip>
> 
> A bit more description for system administrators would be very useful.
> Perhaps something like:
> 
> noxpfo		[XPFO,X86-64] Disable eXclusive Page Frame Ownership (XPFO)
>                              Physical pages mapped into user applications will also be mapped
>                              in the kernel's address space as if CONFIG_XPFO was not enabled.
> 
> Patch 05 should also update kernel-parameters.txt and add "ARM64" to the config option list for noxpfo.

Nice catch, thanks. I'll fix both.

Cheers,

Tycho
