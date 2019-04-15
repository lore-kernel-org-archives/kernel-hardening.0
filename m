Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.8\))
Subject: Re: [PATCH 1/2] include: linux: Regularise the use of FIELD_SIZEOF
 macro
From: William Kucharski <william.kucharski@oracle.com>
In-Reply-To: <20190414091452.22275-1-shyam.saini@amarulasolutions.com>
Date: Mon, 15 Apr 2019 04:12:16 -0600
Content-Transfer-Encoding: quoted-printable
Message-Id: <C398B8C9-6A54-4590-AA88-58D514BAEB71@oracle.com>
References: <20190414091452.22275-1-shyam.saini@amarulasolutions.com>
To: Shyam Saini <shyam.saini@amarulasolutions.com>
Cc: Kernel Hardening <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, keescook@chromium.org, linux-arm-kernel@lists.infradead.org, linux-mips@vger.kernel.org, intel-gvt-dev@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org, netdev@vger.kernel.org, linux-ext4@vger.kernel.org, devel@lists.orangefs.org, linux-mm@kvack.org, linux-sctp@vger.kernel.org, bpf@vger.kernel.org, kvm@vger.kernel.org, mayhs11saini@gmail.com
List-ID: <kernel-hardening.lists.openwall.com>



> On Apr 14, 2019, at 3:14 AM, Shyam Saini =
<shyam.saini@amarulasolutions.com> wrote:
>=20
> Currently, there are 3 different macros, namely sizeof_field, =
SIZEOF_FIELD
> and FIELD_SIZEOF which are used to calculate the size of a member of
> structure, so to bring uniformity in entire kernel source tree lets =
use
> FIELD_SIZEOF and replace all occurrences of other two macros with =
this.
>=20
> For this purpose, redefine FIELD_SIZEOF in include/linux/stddef.h and
> tools/testing/selftests/bpf/bpf_util.h and remove its defination from
> include/linux/kernel.h


> --- a/include/linux/stddef.h
> +++ b/include/linux/stddef.h
> @@ -20,6 +20,15 @@ enum {
> #endif
>=20
> /**
> + * FIELD_SIZEOF - get the size of a struct's field
> + * @t: the target struct
> + * @f: the target struct's field
> + * Return: the size of @f in the struct definition without having a
> + * declared instance of @t.
> + */
> +#define FIELD_SIZEOF(t, f) (sizeof(((t *)0)->f))
> +
> +/**
>  * sizeof_field(TYPE, MEMBER)
>  *
>  * @TYPE: The structure containing the field of interest
> @@ -34,6 +43,6 @@ enum {
>  * @MEMBER: The member within the structure to get the end offset of
>  */
> #define offsetofend(TYPE, MEMBER) \
> -	(offsetof(TYPE, MEMBER)	+ sizeof_field(TYPE, MEMBER))
> +	(offsetof(TYPE, MEMBER)	+ FIELD_SIZEOF(TYPE, MEMBER))

If you're doing this, why are you leaving the definition of =
sizeof_field() in
stddef.h untouched?

Given the way this has worked historically, if you are leaving it in =
place for
source compatibility reasons, shouldn't it be redefined in terms of
FIELD_SIZEOF(), e.g.:

#define sizeof_field(TYPE, MEMBER) FIELD_SIZEOF(TYPE, MEMBER)
