Message-ID: <3ee891ded467e1fd473c9b075658b959e091e8f6.camel@russell.cc>
Subject: Re: [PATCH 3/7] powerpc/mm: Add a framework for Kernel Userspace
 Access Protection
From: Russell Currey <ruscur@russell.cc>
Date: Fri, 22 Feb 2019 11:11:49 +1100
In-Reply-To: <20190221144818.GI33673@lakrids.cambridge.arm.com>
References: <20190221093601.27920-1-ruscur@russell.cc>
	 <20190221093601.27920-4-ruscur@russell.cc>
	 <adb2b7c9-3472-2b9c-37e1-6150697d0940@c-s.fr>
	 <20190221144818.GI33673@lakrids.cambridge.arm.com>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
To: Mark Rutland <mark.rutland@arm.com>, Christophe Leroy <christophe.leroy@c-s.fr>
Cc: linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au, npiggin@gmail.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 2019-02-21 at 14:48 +0000, Mark Rutland wrote:
> On Thu, Feb 21, 2019 at 11:46:06AM +0100, Christophe Leroy wrote:
> > 
> > Le 21/02/2019 à 10:35, Russell Currey a écrit :
> > > From: Christophe Leroy <christophe.leroy@c-s.fr>
> > > 
> > > This patch implements a framework for Kernel Userspace Access
> > > Protection.
> > > 
> > > Then subarches will have to possibility to provide their own
> > > implementation by providing setup_kuap() and
> > > lock/unlock_user_access()
> > > 
> > > Some platform will need to know the area accessed and whether it
> > > is
> > > accessed from read, write or both. Therefore source, destination
> > > and
> > > size and handed over to the two functions.
> > 
> > Should we also consider adding user_access_begin() and the 3 other
> > associated macros ?
> > 
> > See x86 for details.
> 
> As a heads-up, there are some potential issues with
> user_access_{begin,end}() that may affect PPC. There's a long thread
> starting at:
> 
> https://lkml.kernel.org/r/1547560709-56207-4-git-send-email-julien.thierry@arm.com/

I'd say we should look at adding those macros, but as follow-up work
after this series (and after we know what's going on with those issues)

- Russell

> 
> Thanks,
> Mark.
