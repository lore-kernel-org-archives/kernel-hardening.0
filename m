References: <20170920004434.35308-1-ebiggers3@gmail.com>
 <20170920004434.35308-3-ebiggers3@gmail.com>
From: Dave Hansen <dave.hansen@linux.intel.com>
Message-ID: <f5387b72-0c2d-0603-b630-2aca25d16ccb@linux.intel.com>
Date: Wed, 20 Sep 2017 08:54:33 -0700
MIME-Version: 1.0
In-Reply-To: <20170920004434.35308-3-ebiggers3@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2 2/3] x86/fpu: tighten validation of user-supplied
 xstate_header
To: Eric Biggers <ebiggers3@gmail.com>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andy Lutomirski <luto@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, Fenghua Yu <fenghua.yu@intel.com>, Ingo Molnar <mingo@kernel.org>, Kevin Hao <haokexin@gmail.com>, Oleg Nesterov <oleg@redhat.com>, Wanpeng Li <wanpeng.li@hotmail.com>, Yu-cheng Yu <yu-cheng.yu@intel.com>, Michael Halcrow <mhalcrow@google.com>, Eric Biggers <ebiggers@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 09/19/2017 05:44 PM, Eric Biggers wrote:
> +static inline int validate_xstate_header(const struct xstate_header *hdr)
> +{
> +	/* No unknown or supervisor features may be set */
> +	if (hdr->xfeatures & (~xfeatures_mask | XFEATURE_MASK_SUPERVISOR))
> +		return -EINVAL;
> +
> +	/* Userspace must use the uncompacted format */
> +	if (hdr->xcomp_bv)
> +		return -EINVAL;
> +
> +	/* No reserved bits may be set */
> +	if (memchr_inv(hdr->reserved, 0, sizeof(hdr->reserved)))
> +		return -EINVAL;
> +
> +	return 0;
> +}

BTW, the whole series looks pretty sane to me.  Tou're definitely
leaving the code better than you found it.  Feel free to add my acked-by
on all 3 patches.

One nit about this validate function, though.  Let's say we go and
change 'struct xstate_header' and shrink ->reserved because we add a new
field.  This validator will silently break.

Could we add a

	BUILD_BUG_ON(sizeof(hdr->reserved) != 48);

That way, the next hapless kernel developer can't miss updating this.
