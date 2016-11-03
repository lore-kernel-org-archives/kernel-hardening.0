Reply-To: kernel-hardening@lists.openwall.com
Date: Thu, 3 Nov 2016 18:05:37 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20161103180524.GA27785@remoulade>
References: <1478106169-25770-1-git-send-email-vaishali.thakkar@oracle.com>
 <20161102204453.GA18842@remoulade>
 <CAGXu5j+go+Fr2OeF-R4BtVHRcBRrC0TaU477J4RwEAe4zDRZ9A@mail.gmail.com>
 <581A9D8B.5040200@oracle.com>
 <20161103042301.GA24968@remoulade>
 <581AC389.10507@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <581AC389.10507@oracle.com>
Subject: Re: [kernel-hardening] [RFC PATCH] lib: Harden
 csum_partial_copy_from_user
To: Vaishali Thakkar <vaishali.thakkar@oracle.com>
Cc: Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Al Viro <viro@zeniv.linux.org.uk>, David Windsor <dwindsor@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Nov 03, 2016 at 10:26:41AM +0530, Vaishali Thakkar wrote:
> On Thursday 03 November 2016 09:53 AM, Mark Rutland wrote:
> > On Thu, Nov 03, 2016 at 07:44:35AM +0530, Vaishali Thakkar wrote:
> >> On Thursday 03 November 2016 03:29 AM, Kees Cook wrote:
> >>> On Wed, Nov 2, 2016 at 2:44 PM, Mark Rutland <mark.rutland@arm.com> wrote:
> >>>> I know that both arm64 and x86 have a check_object_size() call in their
> >>>> __copy_from_user() implementations.
> > 
> >>>> Is that missing on some architectures?

> > Looking again, a grep shows many (even those with MMUs) don't do anything at
> > all in v4.9-rc2:
> > 
> > [mark@remoulade:~/src/linux]% for ARCH in arch/*; do
> > printf "%d %s\n" $(git grep check_object_size -- "${ARCH}" | wc -l) ${ARCH};
> > done | sort -n

> Hmm, should we go for sending patches for them? [atleast for the ones with MMUs
> and then may be maintainers/developers can check the change]

If Al's uaccess unification work is arriving shortly, sending patches for those
in parallel is just going to make matters more painful.

So it really depends on when that's likely to appear.

> Also, I think same goes for the the kasan_check. We have only arm64 and x86  
> with these checks.

Yes. I'd hoped to collect all of those behind a common helper, something like:

static inline void check_uaccess_read(void *kaddr, const void __user *uaddr, unsigned long n)
{
	kasan_check_write(kaddr, n);
	check_object_size(kaddr, n, false);
	any_uaddr_sanity_check(uaddr, n);
}

Thanks,
Mark.
