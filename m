Reply-To: kernel-hardening@lists.openwall.com
From: Valdis.Kletnieks@vt.edu
In-Reply-To: <CAGXu5jKcLHy3t0C7RyX8xXYowhYuh0rO+WPxWQFKuSn9LN6sjA@mail.gmail.com>
References: <1465420302-23754-1-git-send-email-keescook@chromium.org> <9020.1466040627@turing-police.cc.vt.edu>
 <CAGXu5jKcLHy3t0C7RyX8xXYowhYuh0rO+WPxWQFKuSn9LN6sjA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="==_Exmh_1466120212_4845P";
	 micalg=pgp-sha1; protocol="application/pgp-signature"
Content-Transfer-Encoding: 7bit
Date: Thu, 16 Jun 2016 19:36:52 -0400
Message-ID: <16741.1466120212@turing-police.cc.vt.edu>
Subject: Re: [kernel-hardening] [RFC][PATCH v2 0/4] mm: Hardened usercopy
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>, Casey Schaufler <casey.schaufler@intel.com>, Rik van Riel <riel@redhat.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

--==_Exmh_1466120212_4845P
Content-Type: multipart/mixed ;
	boundary="==_Exmh_1466118284_48450"

This is a multipart MIME message.

--==_Exmh_1466118284_48450
Content-Type: text/plain; charset=us-ascii

On Wed, 15 Jun 2016 18:38:31 -0700, Kees Cook said:
> On Wed, Jun 15, 2016 at 6:30 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> > So I guess you can stick a:
> >
> > Tested-By: Valdis Kletnieks <valdis.kletnieks@vt.edu>
> >
> > on that patch set. :)
>
> Awesome, thanks! It's good to know the system operated normally up
> until that point. I'm glad to have lots of people testing.

Following up - I did a BFI patch against the NVidia driver that basically
tagged all its memory allocations as USERCOPY, and the resulting kernel
has gotten up to multiuser and XOrg.  Been up for a half hour doing my usual
stuff on the laptop, and no usercopy whines.

Workload: email, pidgin IM, Google Chrome with some 30 tabs, some streaming
audio. Plenty of room for corner cases still lurking, but all the basic
stuff is working.  I may whomp on it with trinity for a while, see if
anything falls out...

Today's surprise: VirtualBox 5.0.22 was released - and it was able to boot
a Windows 7 image to the desktop without complaint.  Something still wonky
there, as it gets unstable at some point, but given the lack of dmesg entries,
I suspect it's a linux-next regression rather than a usercopy issue.  Will
debug more later tonight.

NVidia patch attached as guidance to what's needed for anybody else who's facing
patching an out-of-tree module.


--==_Exmh_1466118284_48450
Content-Type: text/plain ; name="nvidia-367.24-usercopy-BFI.patch"; charset=us-ascii
Content-Description: patch4
Content-Disposition: attachment; filename="nvidia-367.24-usercopy-BFI.patch"

--- nvidia-uvm/uvm_linux.h.dist	2016-06-16 04:54:42.573247324 -0400
+++ nvidia-uvm/uvm_linux.h	2016-06-16 17:23:29.863108182 -0400
@@ -185,7 +185,11 @@
 #define __GFP_NORETRY 0
 #endif

-#define NV_UVM_GFP_FLAGS (GFP_KERNEL | __GFP_NORETRY)
+#if !defined(__GFP_USERCOPY)
+#define __GFP_USERCOPY 0
+#endif
+
+#define NV_UVM_GFP_FLAGS (GFP_KERNEL | __GFP_NORETRY | __GFP_USERCOPY)

 #if defined(NV_VM_INSERT_PAGE_PRESENT)
 #define NV_VM_INSERT_PAGE(vma, addr, page) \
--- nvidia/nv-vm.c.dist	2016-06-09 20:37:13.000000000 -0400
+++ nvidia/nv-vm.c	2016-06-16 17:32:51.357212907 -0400
@@ -265,6 +265,9 @@
     if (at->flags & NV_ALLOC_TYPE_ZEROED)
         gfp_mask |= __GFP_ZERO;
 #endif
+#if defined(__GPF_USERCOPY)
+    gfp_mask |= __GFP_USERCOPY;
+#endif

     return gfp_mask;
 }
--- common/inc/nv-linux.h.dist	2016-06-16 04:49:57.775133204 -0400
+++ common/inc/nv-linux.h	2016-06-16 18:36:13.760153738 -0400
@@ -412,12 +412,16 @@
 #define __GFP_COMP 0
 #endif

+#if !defined(GFP_USERCOPY)
+#define GPF_USERCOPY 0
+#endif
+
 #if !defined(DEBUG) && defined(__GFP_NOWARN)
-#define NV_GFP_KERNEL (GFP_KERNEL | __GFP_NOWARN)
-#define NV_GFP_ATOMIC (GFP_ATOMIC | __GFP_NOWARN)
+#define NV_GFP_KERNEL (GFP_KERNEL | __GFP_NOWARN | GFP_USERCOPY)
+#define NV_GFP_ATOMIC (GFP_ATOMIC | __GFP_NOWARN | GFP_USERCOPY)
 #else
-#define NV_GFP_KERNEL (GFP_KERNEL)
-#define NV_GFP_ATOMIC (GFP_ATOMIC)
+#define NV_GFP_KERNEL (GFP_KERNEL | GFP_USERCOPY)
+#define NV_GFP_ATOMIC (GFP_ATOMIC | GFP_USERCOPY)
 #endif

 #if defined(GFP_DMA32)
@@ -427,9 +431,9 @@
  * such as Linux/x86-64; the alternative is to use an IOMMU such
  * as the one implemented with the K8 GART, if available.
  */
-#define NV_GFP_DMA32 (NV_GFP_KERNEL | GFP_DMA32)
+#define NV_GFP_DMA32 (NV_GFP_KERNEL | GFP_DMA32 | GFP_USERCOPY)
 #else
-#define NV_GFP_DMA32 (NV_GFP_KERNEL)
+#define NV_GFP_DMA32 (NV_GFP_KERNEL | GFP_USERCOPY)
 #endif

 #if defined(NVCPU_X86) || defined(NVCPU_X86_64)
@@ -1307,8 +1311,12 @@
     kmem_cache_create(name, size, align, flags, ctor, NULL)
 #endif

+#if !defined(SLAB_USERCOPY)
+#define SLAB_USERCOPY 0
+#endif
+
 #define NV_KMEM_CACHE_CREATE(name, type)    \
-    NV_KMEM_CACHE_CREATE_FULL(name, sizeof(type), 0, 0, NULL)
+    NV_KMEM_CACHE_CREATE_FULL(name, sizeof(type), 0, SLAB_USERCOPY, NULL)

 #define NV_KMEM_CACHE_DESTROY(kmem_cache)   \
     kmem_cache_destroy(kmem_cache)

--==_Exmh_1466118284_48450--


--==_Exmh_1466120212_4845P
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1
Comment: Exmh version 2.5 07/13/2001

iQIVAwUBV2M4EwdmEQWDXROgAQIXLxAAio5/ZY3NnYzaS49gH5kEiPng0/Qq5XTo
YIhutiai8XuOIp6Y//fOJ0yKzjeOwbO4LlqqWtqsiNy+WRPlmwRSgclT5dKbQ32N
/QsyuGVSuF3HXPbKequz8C5obyutYCLxWD3W5XzzLCt+pESyC/erVipzsGg5L3Yj
4gDt/IG74Rjlg8XlZNVg5rJVZ08ZWawI9PrcpZDKbeeVvTubJDn0B/VOnzAAaVpx
KPjqU7GfJDGL5WNWWxupZxsI49LW9EFa3qBnsotwaWEohUljzMdZznsJrubQj3BG
Kn9SZ4zZbEEu3Jpc9NT4pbrb7VLd7PDIKB2Pv9PPj4HbtGzGJgQ5tZMZG96Vv7B9
9J3mVEKswH8aXeSV0e0U/OGjQqBRkbp0e6uZkRledeVpVdmQAG3h2r3csdZnmdqw
3ZdhXDIDplqjri5nZou/uJr0G01URI5uTGxHxlxL4EKjeFj5l1J9cH+oHmKzUKYx
cIC1y56tjUubktBVpxHxp4TE5Uo5WU4VXRqAkqcY9FovszFMzO6btm2dD7oOvIy4
nGYjX/mVHsZUC2eeRfEBrej3EP4Du3yJGYCN5TcTLF+PV5WIneCSZuf5U6kRbe5M
7WftxT7uzE4+wJkNmpNLbv3TRYKnPsCybk0r7vlkV5/hIj7fiKI5SBFriMyFQ9Gx
hUVSYSKbIQA=
=ma/9
-----END PGP SIGNATURE-----

--==_Exmh_1466120212_4845P--
