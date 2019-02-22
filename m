Date: Fri, 22 Feb 2019 15:14:39 +1000
From: Nicholas Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 7/7] powerpc/64s: Implement KUAP for Radix MMU
References: <20190221093601.27920-1-ruscur@russell.cc>
	<20190221093601.27920-8-ruscur@russell.cc>
In-Reply-To: <20190221093601.27920-8-ruscur@russell.cc>
MIME-Version: 1.0
Message-Id: <1550811470.v0q5r976xq.astroid@bobo.none>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
To: linuxppc-dev@lists.ozlabs.org, Russell Currey <ruscur@russell.cc>
Cc: christophe.leroy@c-s.fr, kernel-hardening@lists.openwall.com, mpe@ellerman.id.au
List-ID: <kernel-hardening.lists.openwall.com>

Russell Currey's on February 21, 2019 7:36 pm:
> Kernel Userspace Access Prevention utilises a feature of the Radix MMU
> which disallows read and write access to userspace addresses. By
> utilising this, the kernel is prevented from accessing user data from
> outside of trusted paths that perform proper safety checks, such as
> copy_{to/from}_user() and friends.
>=20
> Userspace access is disabled from early boot and is only enabled when
> performing an operation like copy_{to/from}_user().  The register that
> controls this (AMR) does not prevent userspace from accessing other
> userspace, so there is no need to save and restore when entering and
> exiting userspace.
>=20
> This feature has a slight performance impact which I roughly measured
> to be 3% slower in the worst case (performing 1GB of 1 byte
> read()/write() syscalls), and is gated behind the CONFIG_PPC_KUAP
> option for performance-critical builds.
>=20
> This feature can be tested by using the lkdtm driver (CONFIG_LKDTM=3Dy)
> and performing the following:
>=20
>   # (echo ACCESS_USERSPACE) > [debugfs]/provoke-crash/DIRECT
>=20
> If enabled, this should send SIGSEGV to the thread.
>=20
> A big limitation of the current implementation is that user access
> is left unlocked if an exception is taken while user access is unlocked
> (i.e. if an interrupt is taken during copy_to_user()). This should be
> resolved in future, and is why the state is tracked in the PACA even
> though nothing currently uses it.

Did you have an implementation for this in an earlier series?
What's happened to that? If the idea is to add things incrementally
that's fine.

> Signed-off-by: Russell Currey <ruscur@russell.cc>
> ---
>  .../powerpc/include/asm/book3s/64/kup-radix.h | 36 +++++++++++++++++++
>  arch/powerpc/include/asm/kup.h                |  4 +++
>  arch/powerpc/include/asm/mmu.h                |  9 ++++-
>  arch/powerpc/include/asm/reg.h                |  1 +
>  arch/powerpc/mm/pgtable-radix.c               | 16 +++++++++
>  arch/powerpc/mm/pkeys.c                       |  7 ++--
>  arch/powerpc/platforms/Kconfig.cputype        |  1 +
>  7 files changed, 71 insertions(+), 3 deletions(-)
>  create mode 100644 arch/powerpc/include/asm/book3s/64/kup-radix.h
>=20
> diff --git a/arch/powerpc/include/asm/book3s/64/kup-radix.h b/arch/powerp=
c/include/asm/book3s/64/kup-radix.h
> new file mode 100644
> index 000000000000..5cfdea954418
> --- /dev/null
> +++ b/arch/powerpc/include/asm/book3s/64/kup-radix.h
> @@ -0,0 +1,36 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +#ifndef _ASM_POWERPC_KUP_RADIX_H
> +#define _ASM_POWERPC_KUP_RADIX_H
> +
> +#ifndef __ASSEMBLY__
> +#ifdef CONFIG_PPC_KUAP
> +#include <asm/reg.h>
> +/*
> + * We do have the ability to individually lock/unlock reads and writes r=
ather
> + * than both at once, however it's a significant performance hit due to =
needing
> + * to do a read-modify-write, which adds a mfspr, which is slow.  As a r=
esult,
> + * locking/unlocking both at once is preferred.
> + */
> +static inline void unlock_user_access(void __user *to, const void __user=
 *from,
> +				      unsigned long size)
> +{
> +	if (!mmu_has_feature(MMU_FTR_RADIX_KUAP))
> +		return;
> +
> +	mtspr(SPRN_AMR, 0);
> +	isync();
> +	get_paca()->user_access_allowed =3D 1;

I think this is going to get corrupted when you context switch isn't
it? I would have thought a per thread flag would be easier, but maybe=20
that's difficult in your exception code... If you've got more code to=20
deal with it in a later patch, might be worth just moving all the
user_access_allowed stuff there.

Possibly you could add some debug warnings to catch double lock or=20
unpaired unlock? That could be removed or put under a CONFIG option=20
after it gets more testing.

> +}
> +
> +static inline void lock_user_access(void __user *to, const void __user *=
from,
> +				    unsigned long size)
> +{
> +	if (!mmu_has_feature(MMU_FTR_RADIX_KUAP))
> +		return;
> +
> +	mtspr(SPRN_AMR, RADIX_AMR_LOCKED);
> +	get_paca()->user_access_allowed =3D 0;

Without the isync here gives you some small window to execute user=20
accesses without faulting I think. If that's for performance I won't=20
complain, but a comment would be good.

Looks good though, no real complaints about the series.

Thanks,
Nick

=
