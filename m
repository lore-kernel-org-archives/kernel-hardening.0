Date: Wed, 14 Feb 2018 12:14:00 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 2/2] mm: Add kvmalloc_ab_c and kvzalloc_struct
Message-ID: <20180214201400.GD20627@bombadil.infradead.org>
References: <20180214182618.14627-1-willy@infradead.org>
 <20180214182618.14627-3-willy@infradead.org>
 <alpine.DEB.2.20.1802141354530.28235@nuc-kabylake>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1802141354530.28235@nuc-kabylake>
To: Christopher Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Matthew Wilcox <mawilcox@microsoft.com>, linux-mm@kvack.org, Kees Cook <keescook@chromium.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Feb 14, 2018 at 01:55:59PM -0600, Christopher Lameter wrote:
> On Wed, 14 Feb 2018, Matthew Wilcox wrote:
> 
> > +#define kvzalloc_struct(p, member, n, gfp)				\
> > +	(typeof(p))kvzalloc_ab_c(n,					\
> > +		sizeof(*(p)->member) + __must_be_array((p)->member),	\
> > +		offsetof(typeof(*(p)), member), gfp)
> > +
> 
> Uppercase like the similar KMEM_CACHE related macros in
> include/linux/slab.h?>

Do you think that would look better in the users?  Compare:

@@ -1284,7 +1284,7 @@ static long vhost_set_memory(struct vhost_dev *d, struct vhost_memory __user *m)
                return -EOPNOTSUPP;
        if (mem.nregions > max_mem_regions)
                return -E2BIG;
-       newmem = kvzalloc(size + mem.nregions * sizeof(*m->regions), GFP_KERNEL);
+       newmem = kvzalloc_struct(newmem, regions, mem.nregions, GFP_KERNEL);
        if (!newmem)
                return -ENOMEM;

@@ -1284,7 +1284,7 @@ static long vhost_set_memory(struct vhost_dev *d, struct vhost_memory __user *m)
                return -EOPNOTSUPP;
        if (mem.nregions > max_mem_regions)
                return -E2BIG;
-       newmem = kvzalloc(size + mem.nregions * sizeof(*m->regions), GFP_KERNEL);
+       newmem = KVZALLOC_STRUCT(newmem, regions, mem.nregions, GFP_KERNEL);
        if (!newmem)
                return -ENOMEM;

Making it look like a function is more pleasing to my eye, but I'll
change it if that's the only thing keeping it from being merged.
