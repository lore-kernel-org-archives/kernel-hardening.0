From: "Roberts, William C" <william.c.roberts@intel.com>
Date: Tue, 17 Oct 2017 17:27:15 +0000
Message-ID: <476DC76E7D1DF2438D32BFADF679FC563F4B0FB8@ORSMSX115.amr.corp.intel.com>
References: <1508215972-7769-1-git-send-email-me@tobin.cc>
In-Reply-To: <1508215972-7769-1-git-send-email-me@tobin.cc>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: [kernel-hardening] RE: [PATCH v2] printk: hash addresses printed with %p
To: "Tobin C. Harding" <me@tobin.cc>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Kees Cook <keescook@chromium.org>, Paolo Bonzini <pbonzini@redhat.com>, Tycho Andersen <tycho@docker.com>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr
 Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>, Dave
 Weinstein <olorin@google.com>, Daniel Micay <danielmicay@gmail.com>, Djalal Harouni <tixxdz@gmail.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>



> -----Original Message-----
> From: Tobin C. Harding [mailto:me@tobin.cc]
> Sent: Monday, October 16, 2017 9:53 PM
> To: kernel-hardening@lists.openwall.com
> Cc: Tobin C. Harding <me@tobin.cc>; Linus Torvalds <torvalds@linux-
> foundation.org>; Kees Cook <keescook@chromium.org>; Paolo Bonzini
> <pbonzini@redhat.com>; Tycho Andersen <tycho@docker.com>; Roberts,
> William C <william.c.roberts@intel.com>; Tejun Heo <tj@kernel.org>; Jorda=
n
> Glover <Golden_Miller83@protonmail.ch>; Greg KH
> <gregkh@linuxfoundation.org>; Petr Mladek <pmladek@suse.com>; Joe
> Perches <joe@perches.com>; Ian Campbell <ijc@hellion.org.uk>; Sergey
> Senozhatsky <sergey.senozhatsky@gmail.com>; Catalin Marinas
> <catalin.marinas@arm.com>; Will Deacon <will.deacon@arm.com>; Steven
> Rostedt <rostedt@goodmis.org>; Chris Fries <cfries@google.com>; Dave
> Weinstein <olorin@google.com>; Daniel Micay <danielmicay@gmail.com>; Djal=
al
> Harouni <tixxdz@gmail.com>; linux-kernel@vger.kernel.org
> Subject: [PATCH v2] printk: hash addresses printed with %p
>=20
> Currently there are many places in the kernel where addresses are being p=
rinted
> using an unadorned %p. Kernel pointers should be printed using %pK allowi=
ng
> some control via the kptr_restrict sysctl. Exposing addresses gives attac=
kers
> sensitive information about the kernel layout in memory.
>=20
> We can reduce the attack surface by hashing all addresses printed with %p=
. This
> will of course break some users, forcing code printing needed addresses t=
o be
> updated.
>=20
> For what it's worth, usage of unadorned %p can be broken down as follows
>=20
>     git grep '%p[^KFfSsBRrbMmIiEUVKNhdDgCGO]' | wc -l
>=20
> arch: 2512
> block: 20
> crypto: 12
> fs: 1221
> include: 147
> kernel: 109
> lib: 77
> mm: 120
> net: 1516
> security: 11
> sound: 168
> virt: 2
> drivers: 8420
>=20
> Add helper function siphash_1ulong(). Add function ptr_to_id() to map an
> address to a 32 bit unique identifier.
>=20
> Signed-off-by: Tobin C. Harding <me@tobin.cc>
> ---
>=20
> V2:
>  - Use SipHash to do the hashing
>=20
> The discussion related to this patch has been fragmented. There are three=
 other
> threads associated with this patch. Email threads by
> subject:
>=20
> [PATCH] printk: hash addresses printed with %p [PATCH 0/3] add %pX specif=
ier
> [kernel-hardening] [RFC V2 0/6] add more kernel pointer filter options
>=20
>  include/linux/siphash.h |  2 ++
>  lib/siphash.c           | 13 +++++++++++++
>  lib/vsprintf.c          | 32 +++++++++++++++++++++++++++++---
>  3 files changed, 44 insertions(+), 3 deletions(-)
>=20
> diff --git a/include/linux/siphash.h b/include/linux/siphash.h index
> fa7a6b9cedbf..a9392568c8b8 100644
> --- a/include/linux/siphash.h
> +++ b/include/linux/siphash.h
> @@ -26,6 +26,8 @@ u64 __siphash_aligned(const void *data, size_t len, con=
st
> siphash_key_t *key);
>  u64 __siphash_unaligned(const void *data, size_t len, const siphash_key_=
t
> *key);  #endif
>=20
> +unsigned long siphash_1ulong(const unsigned long a, const siphash_key_t
> +*key);
> +
>  u64 siphash_1u64(const u64 a, const siphash_key_t *key);
>  u64 siphash_2u64(const u64 a, const u64 b, const siphash_key_t *key);
>  u64 siphash_3u64(const u64 a, const u64 b, const u64 c, diff --git a/lib=
/siphash.c
> b/lib/siphash.c index 3ae58b4edad6..63f4ff57c9ce 100644
> --- a/lib/siphash.c
> +++ b/lib/siphash.c
> @@ -116,6 +116,19 @@ EXPORT_SYMBOL(__siphash_unaligned);
>  #endif
>=20
>  /**
> + * siphash_1ulong - computes siphash PRF value
> + * @first: value to hash
> + * @key: the siphash key
> + */
> +unsigned long siphash_1ulong(const unsigned long first, const
> +siphash_key_t *key) { #ifdef CONFIG_64BIT
> +	return (unsigned long)siphash_1u64((u64)first, key); #endif
> +	return (unsigned long)siphash_1u32((u32)first, key); }
> +
> +/**
>   * siphash_1u64 - compute 64-bit siphash PRF value of a u64
>   * @first: first u64
>   * @key: the siphash key
> diff --git a/lib/vsprintf.c b/lib/vsprintf.c index 86c3385b9eb3..afd1c835=
b0f6 100644
> --- a/lib/vsprintf.c
> +++ b/lib/vsprintf.c
> @@ -33,6 +33,7 @@
>  #include <linux/uuid.h>
>  #include <linux/of.h>
>  #include <net/addrconf.h>
> +#include <linux/siphash.h>
>  #ifdef CONFIG_BLOCK
>  #include <linux/blkdev.h>
>  #endif
> @@ -503,6 +504,7 @@ char *number(char *buf, char *end, unsigned long long
> num,
>  			*buf =3D '0';
>  		++buf;
>  	}
> +

Unneeded whitespace change?

>  	/* actual digits of result */
>  	while (--i >=3D 0) {
>  		if (buf < end)
> @@ -1591,6 +1593,28 @@ char *device_node_string(char *buf, char *end, str=
uct
> device_node *dn,
>  	return widen_string(buf, buf - buf_start, end, spec);  }
>=20
> +/* Maps a pointer to a 32 bit unique identifier. */ static char
> +*ptr_to_id(char *buf, char *end, void *ptr, struct printf_spec spec) {
> +	static siphash_key_t ptr_secret __read_mostly;
> +	static bool have_key =3D false;
> +	unsigned long hashval;
> +
> +	/* Kernel doesn't boot if we use get_random_once() */
> +	if (!have_key) {
> +		get_random_bytes(&ptr_secret, sizeof(ptr_secret));
> +		have_key =3D true;

Wouldn't one want to use an atomic test and swap for this
block?

> +	}
> +
> +	hashval =3D siphash_1ulong((unsigned long)ptr, &ptr_secret);
> +
> +	spec.field_width =3D 2 + 2 * sizeof(unsigned int); /* 0x + hex */
> +	spec.flags =3D SPECIAL | SMALL | ZEROPAD;
> +	spec.base =3D 16;
> +
> +	return number(buf, end, (u32)hashval, spec); }
> +
>  int kptr_restrict __read_mostly;
>=20
>  /*
> @@ -1703,6 +1727,9 @@ int kptr_restrict __read_mostly;
>   * Note: The difference between 'S' and 'F' is that on ia64 and ppc64
>   * function pointers are really function descriptors, which contain a
>   * pointer to the real address.
> + *
> + * Default behaviour (unadorned %p) is to hash the address, rendering
> + it useful
> + * as a unique identifier.
>   */
>  static noinline_for_stack
>  char *pointer(const char *fmt, char *buf, char *end, void *ptr, @@ -1858=
,14
> +1885,13 @@ char *pointer(const char *fmt, char *buf, char *end, void *pt=
r,
>  			return device_node_string(buf, end, ptr, spec, fmt + 1);
>  		}
>  	}
> -	spec.flags |=3D SMALL;
> +
>  	if (spec.field_width =3D=3D -1) {
>  		spec.field_width =3D default_width;
>  		spec.flags |=3D ZEROPAD;
>  	}
> -	spec.base =3D 16;
>=20
> -	return number(buf, end, (unsigned long) ptr, spec);
> +	return ptr_to_id(buf, end, ptr, spec);
>  }
>=20
>  /*
> --
> 2.7.4
