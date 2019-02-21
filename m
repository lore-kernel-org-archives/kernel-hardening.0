Date: Thu, 21 Feb 2019 14:48:19 +0000
From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH 3/7] powerpc/mm: Add a framework for Kernel Userspace
 Access Protection
Message-ID: <20190221144818.GI33673@lakrids.cambridge.arm.com>
References: <20190221093601.27920-1-ruscur@russell.cc>
 <20190221093601.27920-4-ruscur@russell.cc>
 <adb2b7c9-3472-2b9c-37e1-6150697d0940@c-s.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <adb2b7c9-3472-2b9c-37e1-6150697d0940@c-s.fr>
To: Christophe Leroy <christophe.leroy@c-s.fr>
Cc: Russell Currey <ruscur@russell.cc>, linuxppc-dev@lists.ozlabs.org, mpe@ellerman.id.au, npiggin@gmail.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 21, 2019 at 11:46:06AM +0100, Christophe Leroy wrote:
> 
> 
> Le 21/02/2019 à 10:35, Russell Currey a écrit :
> > From: Christophe Leroy <christophe.leroy@c-s.fr>
> > 
> > This patch implements a framework for Kernel Userspace Access
> > Protection.
> > 
> > Then subarches will have to possibility to provide their own
> > implementation by providing setup_kuap() and lock/unlock_user_access()
> > 
> > Some platform will need to know the area accessed and whether it is
> > accessed from read, write or both. Therefore source, destination and
> > size and handed over to the two functions.
> 
> Should we also consider adding user_access_begin() and the 3 other
> associated macros ?
> 
> See x86 for details.

As a heads-up, there are some potential issues with
user_access_{begin,end}() that may affect PPC. There's a long thread
starting at:

https://lkml.kernel.org/r/1547560709-56207-4-git-send-email-julien.thierry@arm.com/

Thanks,
Mark.
