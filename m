Date: Mon, 11 Sep 2017 08:03:42 -0700
From: Tycho Andersen <tycho@docker.com>
Message-ID: <20170911150342.kf6n5ce4aldqy27a@docker>
References: <20170907173609.22696-1-tycho@docker.com>
 <20170907173609.22696-4-tycho@docker.com>
 <d4935027-aca6-f7a2-d15b-50b94484ecaf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d4935027-aca6-f7a2-d15b-50b94484ecaf@redhat.com>
Subject: [kernel-hardening] Re: [PATCH v6 03/11] mm, x86: Add support for eXclusive Page Frame
 Ownership (XPFO)
To: Laura Abbott <labbott@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com, Marco Benatto <marco.antonio.780@gmail.com>, Juerg Haefliger <juerg.haefliger@canonical.com>, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Sep 09, 2017 at 08:35:17AM -0700, Laura Abbott wrote:
> On 09/07/2017 10:36 AM, Tycho Andersen wrote:
> > +static inline struct xpfo *lookup_xpfo(struct page *page)
> > +{
> > +	struct page_ext *page_ext = lookup_page_ext(page);
> > +
> > +	if (unlikely(!page_ext)) {
> > +		WARN(1, "xpfo: failed to get page ext");
> > +		return NULL;
> > +	}
> > +
> > +	return (void *)page_ext + page_xpfo_ops.offset;
> > +}
> > +
> 
> Just drop the WARN. On my arm64 UEFI machine this spews warnings
> under most normal operation. This should be normal for some
> situations but I haven't had the time to dig into why this
> is so pronounced on arm64.

Will do, thanks! If you figure out under what conditions it's normal,
I'd be curious :)

Tycho
