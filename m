Date: Fri, 2 Feb 2018 12:39:20 -0600 (CST)
From: Christopher Lameter <cl@linux.com>
Subject: Re: [kernel-hardening] [PATCH 4/6] Protectable Memory
In-Reply-To: <20180126053542.GA30189@bombadil.infradead.org>
Message-ID: <alpine.DEB.2.20.1802021236510.31548@nuc-kabylake>
References: <20180124175631.22925-1-igor.stoppa@huawei.com> <20180124175631.22925-5-igor.stoppa@huawei.com> <CAG48ez0JRU8Nmn7jLBVoy6SMMrcj46R0_R30Lcyouc4R9igi-g@mail.gmail.com> <20180126053542.GA30189@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: Matthew Wilcox <willy@infradead.org>
Cc: Jann Horn <jannh@google.com>, Igor Stoppa <igor.stoppa@huawei.com>, jglisse@redhat.com, Kees Cook <keescook@chromium.org>, Michal Hocko <mhocko@kernel.org>, Laura Abbott <labbott@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-security-module@vger.kernel.org, linux-mm@kvack.org, kernel list <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 25 Jan 2018, Matthew Wilcox wrote:

> It's worth having a discussion about whether we want the pmalloc API
> or whether we want a slab-based API.  We can have a separate discussion
> about an API to remove pages from the physmap.

We could even do this in a more thorough way. Can we use a ring 1 / 2
distinction to create a hardened OS core that policies the rest of
the ever expanding kernel with all its modules and this and that feature?

I think that will long term be a better approach and allow more than the
current hardening approaches can get you. It seems that we are willing to
tolerate significant performance regressions now. So lets use the
protection mechanisms that the hardware offers.
