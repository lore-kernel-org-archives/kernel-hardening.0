Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <1463685359.16149.35.camel@redhat.com>
From: Rik van Riel <riel@redhat.com>
Date: Thu, 19 May 2016 15:15:59 -0400
In-Reply-To: <1463674452-13956-1-git-send-email-casey.schaufler@intel.com>
References: <1463674452-13956-1-git-send-email-casey.schaufler@intel.com>
Content-Type: multipart/signed; micalg="pgp-sha1"; protocol="application/pgp-signature";
	boundary="=-zVXZFiSa+AvoG8MnTZdC"
Mime-Version: 1.0
Subject: Re: [kernel-hardening] [PATCH] Subject: [RFC PATCH] mm: Hardened
 usercopy
To: kernel-hardening@lists.openwall.com
Cc: Casey Schaufler <casey.schaufler@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>


--=-zVXZFiSa+AvoG8MnTZdC
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 2016-05-19 at 09:14 -0700, casey.schaufler@intel.com wrote:

I have a bunch of nitpicks for this patch, mostly
to do with code readability and documentation.

> +++ b/arch/x86/include/asm/uaccess_32.h
> @@ -43,6 +43,9 @@ unsigned long __must_check
> __copy_from_user_ll_nocache_nozero
> =C2=A0static __always_inline unsigned long __must_check
> =C2=A0__copy_to_user_inatomic(void __user *to, const void *from, unsigned
> long n)
> =C2=A0{
> +#ifdef CONFIG_HARDUSERCOPY
> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0check_object_size(from, n, tru=
e);
> +#endif
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (__builtin_constant_p(=
n)) {
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0unsigned long ret;

Would it be possible to leave out those ifdefs,
and move all the ifdeffery to the include file?

+++ b/include/linux/something.h
#ifdef CONFIG_HARDUSERCOPY
... what you have now
#else
static inline void check_object_size(const void *ptr, unsigned long n,
bool to_user) { }
#endif


> +++ b/fs/exec.c
> @@ -1749,3 +1749,128 @@ COMPAT_SYSCALL_DEFINE5(execveat, int, fd,
> =C2=A0				=C2=A0=C2=A0argv, envp, flags);
> =C2=A0}
> =C2=A0#endif
> +
> +#ifdef CONFIG_HARDUSERCOPY
> +/*

Maybe add "Check whether an object is inside the stack" ?

> + *	0: not at all,
> + *	1: fully,
> + *	2: fully inside frame,
> + *	-1: partially (implies an error)
> + */
> +static noinline int check_stack_object(const void *obj, unsigned
> long len)
> +{
> +	const void * const stack =3D task_stack_page(current);
> +	const void * const stackend =3D stack + THREAD_SIZE;
> +
> +#if defined(CONFIG_FRAME_POINTER) && defined(CONFIG_X86)
> +	const void *frame =3D NULL;
> +	const void *oldframe;
> +#endif
> +
> +	if (obj + len < obj)
> +		return -1;
> +
> +	if (obj + len <=3D stack || stackend <=3D obj)
> +		return 0;
> +
> +	if (obj < stack || stackend < obj + len)
> +		return -1;
> +
> +#if defined(CONFIG_FRAME_POINTER) && defined(CONFIG_X86)
> +	oldframe =3D __builtin_frame_address(1);
> +	if (oldframe)
> +		frame =3D __builtin_frame_address(2);
> +	/*
> +	=C2=A0=C2=A0low ----------------------------------------------> high
> +	=C2=A0=C2=A0[saved bp][saved ip][args][local vars][saved bp][saved ip]
> +			=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0^----------------^
> +			=C2=A0=C2=A0allow copies only within here
> +	*/
> +	while (stack <=3D frame && frame < stackend) {
> +		/* if obj + len extends past the last frame, this
> +		=C2=A0=C2=A0=C2=A0check won't pass and the next frame will be 0,
> +		=C2=A0=C2=A0=C2=A0causing us to bail out and correctly report
> +		=C2=A0=C2=A0=C2=A0the copy as invalid
> +		*/
> +		if (obj + len <=3D frame)
> +			return obj >=3D oldframe + 2 * sizeof(void *)
> ? 2 : -1;
> +		oldframe =3D frame;
> +		frame =3D *(const void * const *)frame;
> +	}
> +	return -1;
> +#else
> +	return 1;
> +#endif
> +}



> +static inline bool check_kernel_text_object(unsigned long low,
> +						unsigned long high)
> +{
> +	unsigned long textlow =3D (unsigned long)_stext;
> +	unsigned long texthigh =3D (unsigned long)_etext;
> +
> +#ifdef CONFIG_X86_64
> +	/* check against linear mapping as well */
> +	if (high > (unsigned long)__va(__pa(textlow)) &&
> +	=C2=A0=C2=A0=C2=A0=C2=A0low < (unsigned long)__va(__pa(texthigh)))
> +		return true;
> +#endif
> +
> +	if (high <=3D textlow || low >=3D texthigh)
> +		return false;
> +	else
> +		return true;

Could this be simplified to the following?

	/* Object overlaps with kernel text */
	return (high > textlow && low < texthigh);


The following function could use a bunch of documentation,
too.

=C2=A0 =C2=A0/* Is ptr a valid location for copy_from_user of size n? */

> +void __check_object_size(const void *ptr, unsigned long n, bool
> to_user,
> +				bool const_size)
> +{
> +	const char *type;
> +
> +#if !defined(CONFIG_STACK_GROWSUP) && !defined(CONFIG_X86_64)
> +	unsigned long stackstart =3D (unsigned
> long)task_stack_page(current);
> +	unsigned long currentsp =3D (unsigned long)&stackstart;
> +	if (unlikely((currentsp < stackstart + 512 ||
> +		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0currentsp >=3D stackstart + THREAD_SIZE)=
 &&
> !in_interrupt()))
> +		BUG();
> +#endif
> +
> +	if (!n)
> +		return;
> +
> +	type =3D check_heap_object(ptr, n);

Maybe rename "type" to "err", to indicate that if
check_heap_object returned non-zero, there already
is an error detected, and it makes no sense to check
the rest?

The following seems a little convoluted. This appears
to be for good reasons, but could use some comments.

> +	if (!type) {
> +		int ret =3D check_stack_object(ptr, n);
> +		if (ret =3D=3D 1 || ret =3D=3D 2)
> +			return;
> +		if (ret =3D=3D 0) {
			/*
			=C2=A0* Object is not on the stack. Make sure
			=C2=A0* it is not inside the kernel text.
			=C2=A0*/
> +			if (check_kernel_text_object((unsigned
> long)ptr,
> +						(unsigned long)ptr +
> n))

Why does check_kernel_text_object() not take "ptr, n" as
its arguments, like all the other functions here?

Some consistency may make it easier for people to see
what is going on.

> +				type =3D "<kernel text>";
> +			else
				/* Valid copy_from_user object */
> +				return;
> +		} else
> +			type =3D "<process stack>";
> +	}
> +
> +	report_hardusercopy(ptr, n, to_user, type);
> +
> +}

>=C2=A0
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index b7b9501..048eea8 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -757,6 +757,9 @@ struct signal_struct {
> =C2=A0#ifdef CONFIG_TASKSTATS
> =C2=A0	struct taskstats *stats;
> =C2=A0#endif
> +#ifdef CONFIG_HARDUSERCOPY
> +	u32 curr_ip;
> +#endif

This is not big enough to hold an instruction
pointer on a 64 bit architecture.

However, it also appears to be unused in your
patch, so you may be able to just get rid of it,
and the code that checks for it in report_hardusercopy()

> +++ b/include/linux/thread_info.h
> @@ -145,6 +145,17 @@ static inline bool
> test_and_clear_restore_sigmask(void)
> =C2=A0#error "no set_restore_sigmask() provided and default one won't
> work"
> =C2=A0#endif
> =C2=A0
> +#ifdef CONFIG_HARDUSERCOPY
> +extern void __check_object_size(const void *ptr, unsigned long n,
> +					bool to_user, bool
> const_size);
> +
> +static inline void check_object_size(const void *ptr, unsigned long
> n,
> +					bool to_user)
> +{
> +	__check_object_size(ptr, n, to_user,
> __builtin_constant_p(n));
> +}
=C2=A0 #else
=C2=A0 static inline void check_object_size(const void *ptr, unsigned long
n,
					bool to_user) {}
> +#endif /* CONFIG_HARDUSERCOPY */
> +
> =C2=A0#endif	/* __KERNEL__ */
> =C2=A0
> =C2=A0#endif /* _LINUX_THREAD_INFO_H */

Here is another function that could use some documentation.

I wrote up a comment documenting what it does, but I am not
sure why copy_from_user is not allowed to vmalloced kernel
objects. =C2=A0Is there a policy reason for this, or is it just a
happy coincidence that it does not break anything currently?

> +#ifdef CONFIG_HARDUSERCOPY
=C2=A0 /*
=C2=A0 =C2=A0* Ensure that ptr is a valid copy_to_user destination.
=C2=A0 =C2=A0* Disallow copies to slab caches without SLAB_USERCOPY
=C2=A0 =C2=A0* set, that overflow slab objects, or to vmalloc areas.
=C2=A0 =C2=A0* There are additional checks in __check_object_size for
=C2=A0 =C2=A0* errors not detected here.
=C2=A0 =C2=A0*/
> +const char *check_heap_object(const void *ptr, unsigned long n)
> +{
> +	struct page *page;
> +	struct kmem_cache *cachep;
> +	unsigned int objnr;
> +	unsigned long offset;
> +
> +	if (ZERO_OR_NULL_PTR(ptr))
> +		return "<null>";
> +
> +	if (!virt_addr_valid(ptr))
> +		return NULL;
> +
> +	page =3D virt_to_head_page(ptr);
> +
> +	if (!PageSlab(page))
> +		return NULL;
> +
> +	cachep =3D page->slab_cache;
> +	if (!(cachep->flags & SLAB_USERCOPY))
> +		return cachep->name;
> +
> +	objnr =3D obj_to_index(cachep, page, ptr);
> +	BUG_ON(objnr >=3D cachep->num);
> +	offset =3D ptr - index_to_obj(cachep, page, objnr) -
> obj_offset(cachep);
> +	if (offset <=3D cachep->object_size && n <=3D cachep-
> >object_size - offset)
> +		return NULL;
> +
> +	return cachep->name;
> +}
> +#endif /* CONFIG_HARDUSERCOPY */
> +
> =C2=A0/**
> =C2=A0 * ksize - get the actual amount of memory allocated for a given
> object
> =C2=A0 * @objp: Pointer to the object


> diff --git a/mm/slab_common.c b/mm/slab_common.c
> index 5ce4fae..655cc17d 100644
> --- a/mm/slab_common.c
> +++ b/mm/slab_common.c
> @@ -43,7 +43,11 @@ struct kmem_cache *kmem_cache;
> =C2=A0 * Merge control. If this is set then no merging of slab caches wil=
l
> occur.
> =C2=A0 * (Could be removed. This was introduced to pacify the merge
> skeptics.)
> =C2=A0 */
> +#ifdef CONFIG_HARDUSERCOPY_SLABS
> +static int slab_nomerge =3D 1;
> +#else
> =C2=A0static int slab_nomerge;
> +#endif

This disables merging of all slabs just because there
may be a few slabs with SLAB_USERCOPY set. This seems
like overkill.

Simply adding SLAB_USERCOPY to "SLAB_MERGE_SAME" should
prevent the merging of slabs with SLAB_USERCOPY set with
slab caches that do not have that flag set, and should
result in the same security benefits without losing
functionality.


The following could use a comment:

> @@ -805,6 +814,11 @@ struct kmem_cache *kmalloc_slab(size_t size,
> gfp_t flags)
> =C2=A0		return kmalloc_dma_caches[index];
> =C2=A0
> =C2=A0#endif
> +#ifdef CONFIG_HARDUSERCOPY_SLABS
=C2=A0 =C2=A0 =C2=A0 =C2=A0 /* Separate slab caches for copy_from_user */
> +	if (unlikely((flags & GFP_USERCOPY)))
> +		return kmalloc_usercopy_caches[index];
> +#endif /* CONFIG_HARDUSERCOPY_SLABS */
> +
> =C2=A0	return kmalloc_caches[index];
> =C2=A0}

The code added to slub.c and slob.c could use similar
commenting to the slab.c comments above.

> +++ b/mm/slub.c
> @@ -3475,6 +3475,36 @@ void *__kmalloc_node(size_t size, gfp_t flags,
> int node)
> =C2=A0EXPORT_SYMBOL(__kmalloc_node);
> =C2=A0#endif
> =C2=A0
> +#ifdef CONFIG_HARDUSERCOPY
> +const char *check_heap_object(const void *ptr, unsigned long n)
> +{
> +	struct page *page;
> +	struct kmem_cache *s;
> +	unsigned long offset;
> +
> +	if (ZERO_OR_NULL_PTR(ptr))
> +		return "<null>";
> +
> +	if (!virt_addr_valid(ptr))
> +		return NULL;
> +
> +	page =3D virt_to_head_page(ptr);

Wait a moment. =C2=A0Everything above the
if (!PageSlab(page)) code is identical between
slab, slob, and slub.

Would it make sense to move that common code into
__check_object_size, and have a check_slab_object
check that is called if (PageSlab(page)) ?

That way slab.c, slob.c, and slub.c only have their
own unique code, and not this replication between them.

Having the common code in __check_object_size is likely
to end up more readable, too.

> +	if (!PageSlab(page))
> +		return NULL;
> +
> +	s =3D page->slab_cache;

Additionally, having the SLAB_USERCOPY flag set on any
slab caches at all is a function of=C2=A0CONFIG_HARDUSERCOPY_SLABS.

By not having the check below under an ifdef, does the code
always disallow copy_from_user to slab caches when that
config option is not set?

In other words, does disabling CONFIG_HARDUSERCOPY_SLABS
result in stricter controls (and possibly a brokne system)?

> +	if (!(s->flags & SLAB_USERCOPY))
> +		return s->name;
> +
> +	offset =3D (ptr - page_address(page)) % s->size;
> +	if (offset <=3D s->object_size && n <=3D s->object_size -
> offset)
> +		return NULL;
> +
> +	return s->name;
> +}
> +#endif /* CONFIG_HARDUSERCOPY */
> +
> =C2=A0static size_t __ksize(const void *object)
> =C2=A0{
> =C2=A0	struct page *page;

--=20
All rights reversed

--=-zVXZFiSa+AvoG8MnTZdC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1

iQEcBAABAgAGBQJXPhDxAAoJEM553pKExN6Dw5UH/2PdRFxXpfYA/Xq02rmu9YcB
eL+j79s+80QsmKm93NLF/6xt2lpN29PDOypGfnkXZ5wM0/xswq+E5/AihiCf75qq
Dti+osBlCF10iNLnzNh96jyZPZZXPTzIGeZcPt5j5AqJCapuHCGGPpQEDdoXnQjL
nrZlcf1URQH2DewoCM50Is2q3k1DRlPsm6zCPF0ZlAIiUQUe1f6lyeC9FIyLb38O
RaN3gyLoVijEtfrl25Jxu87A8DcrE2KVYF6PT3/S1QVGqHVRBNOlk03+VoXXAGoY
aQtSYGi436z+V53wgt8/pEMTR6GblyWkgYH27ujXnw2nAr2yyk1uIAi2+htCH48=
=5Fuf
-----END PGP SIGNATURE-----

--=-zVXZFiSa+AvoG8MnTZdC--
