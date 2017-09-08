Date: Fri, 8 Sep 2017 00:55:19 -0700
From: Christoph Hellwig <hch@infradead.org>
Message-ID: <20170908075519.GD4957@infradead.org>
References: <20170907173609.22696-1-tycho@docker.com>
 <20170907173609.22696-11-tycho@docker.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170907173609.22696-11-tycho@docker.com>
Subject: [kernel-hardening] Re: [PATCH v6 10/11] mm: add a user_virt_to_phys symbol
To: Tycho Andersen <tycho@docker.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, kernel-hardening@lists.openwall.com, Marco Benatto <marco.antonio.780@gmail.com>, Juerg Haefliger <juerg.haefliger@canonical.com>, linux-arm-kernel@lists.infradead.org, x86@kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Sep 07, 2017 at 11:36:08AM -0600, Tycho Andersen wrote:
> We need someting like this for testing XPFO. Since it's architecture
> specific, putting it in the test code is slightly awkward, so let's make it
> an arch-specific symbol and export it for use in LKDTM.

We really should not add an export for this.

I think you'll want to just open code it in your test module.
