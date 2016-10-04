Reply-To: kernel-hardening@lists.openwall.com
From: "Reshetova, Elena" <elena.reshetova@intel.com>
Date: Tue, 4 Oct 2016 07:15:56 +0000
Message-ID: <2236FBA76BA1254E88B949DDB74E612B41BDAC5B@IRSMSX102.ger.corp.intel.com>
References: <1475476886-26232-1-git-send-email-elena.reshetova@intel.com>
 <1475476886-26232-13-git-send-email-elena.reshetova@intel.com>
 <20161003094752.GN14666@pc.thejh.net>
In-Reply-To: <20161003094752.GN14666@pc.thejh.net>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: RE: [kernel-hardening] [RFC PATCH 12/13] x86: x86 implementation
 for HARDENED_ATOMIC
To: Jann Horn <jann@thejh.net>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "keescook@chromium.org" <keescook@chromium.org>, Hans Liljestrand <ishkamiel@gmail.com>, David
 Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>


On Mon, Oct 03, 2016 at 09:41:25AM +0300, Elena Reshetova wrote:
> This adds x86-specific code in order to support HARDENED_ATOMIC=20
> feature. When overflow is detected in atomic_t or atomic_long_t types,=20
> the counter is decremented back by one (to keep it at INT_MAX or
> LONG_MAX) and issue is reported using BUG().
> The side effect is that in both legitimate and non-legitimate cases a=20
> counter cannot wrap.
>=20
> Signed-off-by: Elena Reshetova <elena.reshetova@intel.com>
> Signed-off-by: Hans Liljestrand <ishkamiel@gmail.com>
> Signed-off-by: David Windsor <dwindsor@gmail.com>
> ---
[...]
>  static __always_inline void atomic_add(int i, atomic_t *v)  {
> -	asm volatile(LOCK_PREFIX "addl %1,%0"
> +	asm volatile(LOCK_PREFIX "addl %1,%0\n"
> +
> +#ifdef CONFIG_HARDENED_ATOMIC
> +		     "jno 0f\n"
> +		     LOCK_PREFIX "subl %1,%0\n"
> +		     "int $4\n0:\n"
> +		     _ASM_EXTABLE(0b, 0b)
> +#endif
> +
> +		     : "+m" (v->counter)
> +		     : "ir" (i));
> +}

>It might make sense to point out in the Kconfig entry that on X86, this ca=
n only be relied on if
>kernel.panic_on_oops=3D=3D1 because otherwise, you can (depending on the b=
ug, in a worst-case scenario) get past 0x7fffffff within seconds using mult=
iple racing processes.
>(See https://bugs.chromium.org/p/project-zero/issues/detail?id=3D856 .)

I will reference this discussion if we stick with the current approach. May=
be after performance measurements we can stick to the atomic_add_unless ver=
sion and then eliminate the issue.=20

>An additional idea for future development:

>One way to work around that would be to interpret the stored value 2^30 as=
 zero, and interpret other values accordingly. Like this:

>#define SIGNED_ATOMIC_BASE 0x40000000U

>static __always_inline int atomic_read(const atomic_t *v) {
  return READ_ONCE((v)->counter) - SIGNED_ATOMIC_BASE; }

>static __always_inline void atomic_set(atomic_t *v, int i) {
  WRITE_ONCE(v->counter, i + SIGNED_ATOMIC_BASE); }

>static __always_inline int atomic_add_return(int i, atomic_t *v) {
  return i + xadd_check_overflow(&v->counter, i) - SIGNED_ATOMIC_BASE; }

>With this change, atomic_t could still be used as a signed integer with ha=
lf the range of an int, but its stored value would only become negative on =
overflow. Then, the "jno" instruction in the hardening code could be replac=
ed with "jns" to reliably block overflows.

>The downsides of this approach would be:
> - One extra increment or decrement every time an atomic_t is read
   or written. This should be relatively cheap - it should be
   operating on a register -, but it's still not ideal. atomic_t
   users could perhaps opt out with something like
   atomic_unsigned_t.
 - Implicit atomic_t initialization to zero by zeroing memory
   would stop working. This would probably be the biggest issue
   with this approach.

I am not sure the BIAS is a good idea at all. Makes things much more compli=
cated, potentially impacts performance...
