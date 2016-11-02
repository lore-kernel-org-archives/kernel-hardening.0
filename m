Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 2 Nov 2016 20:44:54 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20161102204453.GA18842@remoulade>
References: <1478106169-25770-1-git-send-email-vaishali.thakkar@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1478106169-25770-1-git-send-email-vaishali.thakkar@oracle.com>
Subject: Re: [kernel-hardening] [RFC PATCH] lib: Harden
 csum_partial_copy_from_user
To: kernel-hardening@lists.openwall.com
Cc: Vaishali Thakkar <vaishali.thakkar@oracle.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

On Wed, Nov 02, 2016 at 10:32:49PM +0530, Vaishali Thakkar wrote:
> The routine csum_partial_copy_from_user is same as csum_partial_copy
> but it copies from user space for the checksumming. In other respects
> it is identical, and can be used to copy an arbitrarily large buffer
> from userspace into the kernel. Conceptually this exposes a similar
> attack surface like copy_from_user. So, to validate the given address
> we should call check_object_size here.

Thanks for looking at this! I agree that we should be trying lock down these
homebrew/specialised copy_{to,from}_user routines.

However...

> @@ -158,6 +159,7 @@ csum_partial_copy_from_user(const void __user *src, void *dst, int len,
>  {
>  	int missing;
>  
> +	check_object_size(dst, len, false);
>  	missing = __copy_from_user(dst, src, len);

... here we're just calling into the architecture-specific __copy_from_user(),
and I know that both arm64 and x86 have a check_object_size() call in their
__copy_from_user() implementations.

Is that missing on some architectures?

I think we need to figure out where check_object_size() and other checks (e.g.
kasan_check_size) are expected to live in the hierarchy of uaccess copy
primitives (and/or if they should also live in {get,put)_user()).

I had a plan to try to refactor the generic uaccess code so that we could put
those checks in one place, but I put that on hold as Al Viro was doing some
overlapping refactoring of all the uaccess primitives (and I got busy with some
other work).

Thanks,
Mark.
