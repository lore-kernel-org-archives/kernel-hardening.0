Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 8 Jan 2016 08:07:44 -0600 (CST)
From: Christoph Lameter <cl@linux.com>
In-Reply-To: <568F0F75.4090101@labbott.name>
Message-ID: <alpine.DEB.2.20.1601080806020.4128@east.gentwo.org>
References: <1450755641-7856-1-git-send-email-laura@labbott.name> <alpine.DEB.2.20.1512220952350.2114@east.gentwo.org> <5679ACE9.70701@labbott.name> <CAGXu5jJQKaA1qgLEV9vXEVH4QBC__Vg141BX22ZsZzW6p9yk4Q@mail.gmail.com> <568C8741.4040709@labbott.name>
 <alpine.DEB.2.20.1601071020570.28979@east.gentwo.org> <568F0F75.4090101@labbott.name>
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [RFC][PATCH 0/7] Sanitization of slabs based on grsecurity/PaX
To: Laura Abbott <laura@labbott.name>
Cc: Kees Cook <keescook@chromium.org>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 7 Jan 2016, Laura Abbott wrote:

> The slub_debug=P not only poisons it enables other consistency checks on the
> slab as well, assuming my understanding of what check_object does is correct.
> My hope was to have the poison part only and none of the consistency checks in
> an attempt to mitigate performance issues. I misunderstood when the checks
> actually run and how SLUB_DEBUG was used.

Ok I see that there pointer check is done without checking the
corresponding debug flag. Patch attached thar fixes it.

> Another option would be to have a flag like SLAB_NO_SANITY_CHECK.
> sanitization enablement would just be that and SLAB_POISON
> in the debug options. The disadvantage to this approach would be losing
> the sanitization for ->ctor caches (the grsecurity version works around this
> by re-initializing with ->ctor, I haven't heard any feedback if this actually
> acceptable) and not having some of the fast paths enabled
> (assuming I'm understanding the code path correctly.) which would also
> be a performance penalty

I think we simply need to fix the missing check there. There is already a
flag SLAB_DEBUG_FREE for the pointer checks.



Subject: slub: Only perform pointer checks in check_object when SLAB_DEBUG_FREE is set

Seems that check_object() always checks for pointer issues currently.

Signed-off-by: Christoph Lameter <cl@linux.com>

Index: linux/mm/slub.c
===================================================================
--- linux.orig/mm/slub.c
+++ linux/mm/slub.c
@@ -848,6 +848,9 @@ static int check_object(struct kmem_cach
 		 */
 		return 1;

+	if (!(s->flags & SLAB_DEBUG_FREE))
+		return 1;
+
 	/* Check free pointer validity */
 	if (!check_valid_pointer(s, page, get_freepointer(s, p))) {
 		object_err(s, page, p, "Freepointer corrupt");
