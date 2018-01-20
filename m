Date: Fri, 19 Jan 2018 19:58:38 -0600 (CST)
From: Christopher Lameter <cl@linux.com>
In-Reply-To: <20180117193114.GB25862@bombadil.infradead.org>
Message-ID: <alpine.DEB.2.20.1801191957160.14056@nuc-kabylake>
References: <alpine.DEB.2.20.1801101219390.7926@nuc-kabylake> <20180114230719.GB32027@bombadil.infradead.org> <alpine.DEB.2.20.1801160913260.3908@nuc-kabylake> <20180116160525.GF30073@bombadil.infradead.org> <alpine.DEB.2.20.1801161049320.5162@nuc-kabylake>
 <20180116174315.GA10461@bombadil.infradead.org> <alpine.DEB.2.20.1801161205590.1771@nuc-kabylake> <alpine.DEB.2.20.1801161215500.2945@nuc-kabylake> <20180116210313.GA7791@bombadil.infradead.org> <alpine.DEB.2.20.1801171141430.23209@nuc-kabylake>
 <20180117193114.GB25862@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: kmem_cache_attr (was Re: [PATCH 04/36] usercopy: Prepare for
 usercopy whitelisting)
To: Matthew Wilcox <willy@infradead.org>
Cc: Kees Cook <keescook@chromium.org>, linux-mm@kvack.org, Rik van Riel <riel@redhat.com>, Matthew Garrett <mjg59@google.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>



On Wed, 17 Jan 2018, Matthew Wilcox wrote:

> We could put a char * in the kmem_cache which (if not NULL) overrides
> the attr->name?  Probably want a helper to replace the endearingly short
> 's->name'.  Something like:
>
> #define slab_name(s)	s->name ?: s->attr->name


Well I was planning on replacing references to const objects in
kmem_cache_attr throughout the allocators with s->a->xx where a is the
pointer to the attributes in struct kmem_cache. That is also a security
feature if the kmem_cache_attr structures can be placed in readonly
segmenets.
