Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Date: Thu, 16 Feb 2012 09:02:13 -0500
Message-ID: <CAEXv5_gkTsPHDFh+wQqD3P3D-Z+uCN-_1bVyHfHV=u7bS-tgeA@mail.gmail.com>
From: David Windsor <dwindsor@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Add overflow protection to kref
To: gregkh@suse.de, ubuntu-hardened@lists.ubuntu.com, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

We are attempting to add various grsecurity/PAX features to upstream
Ubuntu kernels.

The PAX folks added refcount overflow protection by inserting
architecture-specific code in the increment paths of atomic_t.  For
instance:

static inline void atomic_inc(atomic_t *v)
 {
	asm volatile(LOCK_PREFIX "incl %0\n"

#ifdef CONFIG_PAX_REFCOUNT
		     "jno 0f\n"
		     LOCK_PREFIX "decl %0\n"
		     "int $4\n0:\n"
		     _ASM_EXTABLE(0b, 0b)
#endif

		     : "+m" (v->counter));
}

There are two distinct classes of users we need to consider here:
those who use atomic_t for reference counters and those who use
atomic_t for keeping track of statistics, like performance counters,
etc.; it makes little sense to overflow a performance counter, so we
shouldn't subject those users to the same protections as imposed on
actual reference counters.  The solution implemented by PAX is to
create a family of *_unchecked() functions and to patch
statistics-based users of atomic_t to use this interface.

PAX refcount overflow protection was developed before kref was
created.  I'd like to move overflow protection out of atomic_t and
into kref and gradually migrate atomic_t users to kref, leaving
atomic_t for those users who don't need overflow protection (e.g.
statistics-based counters).

I realize that there are many users of atomic_t needing overflow
protection, but the move to kref seems like the right thing to do in
this case.

Leaving the semantics of overflow detection aside for the moment, what
are everyone's thoughts on adding overflow protection to kref rather
than to atomic_t?

Also, I cherrypicked the refcount protection feature directly from the
PAX patch, with the original atomic_t protections in place, before
considering kref.  If anyone is interested, I can post that patch.

Thanks,
David Windsor

--=20
PGP: 6141 5FFD 11AE 9844 153E =A0F268 7C98 7268 6B19 6CC9
