Date: Mon, 5 Feb 2018 09:40:04 -0600 (CST)
From: Christopher Lameter <cl@linux.com>
Subject: Re: [kernel-hardening] [PATCH 4/6] Protectable Memory
In-Reply-To: <f2ddaed0-313e-8664-8a26-9d10b66ed0c5@huawei.com>
Message-ID: <alpine.DEB.2.20.1802050935300.10705@nuc-kabylake>
References: <20180124175631.22925-1-igor.stoppa@huawei.com> <20180124175631.22925-5-igor.stoppa@huawei.com> <CAG48ez0JRU8Nmn7jLBVoy6SMMrcj46R0_R30Lcyouc4R9igi-g@mail.gmail.com> <20180126053542.GA30189@bombadil.infradead.org> <alpine.DEB.2.20.1802021236510.31548@nuc-kabylake>
 <f2ddaed0-313e-8664-8a26-9d10b66ed0c5@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: Igor Stoppa <igor.stoppa@huawei.com>
Cc: Matthew Wilcox <willy@infradead.org>, Boris Lukashev <blukashev@sempervictus.com>, Jann Horn <jannh@google.com>, jglisse@redhat.com, Kees Cook <keescook@chromium.org>, Michal Hocko <mhocko@kernel.org>, Laura Abbott <labbott@redhat.com>, Christoph Hellwig <hch@infradead.org>, linux-security-module@vger.kernel.org, linux-mm@kvack.org, kernel list <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, 3 Feb 2018, Igor Stoppa wrote:

> > We could even do this in a more thorough way. Can we use a ring 1 / 2
> > distinction to create a hardened OS core that policies the rest of
> > the ever expanding kernel with all its modules and this and that feature?
>
> What would be the differentiating criteria? Furthermore, what are the
> chances
> of invalidating the entire concept, because there is already an
> hypervisor using
> the higher level features?
> That is what you are proposing, if I understand correctly.

Were there not 4 rings as well as methods by the processor vendors to
virtualize them as well?

> > I think that will long term be a better approach and allow more than the
> > current hardening approaches can get you. It seems that we are willing to
> > tolerate significant performance regressions now. So lets use the
> > protection mechanisms that the hardware offers.
>
> I would rather *not* propose significant performance regression :-P

But we already have implemented significant kernel hardening which causes
performance regressions. Using hardware capabilities allows the processor
vendor to further optimize these mechanisms whereas the software
preventative measures are eating up more and more performance as the pile
them on. Plus these are methods that can be worked around. Restrictions
implemented in a higher ring can be enforced and are much better than
just "hardening" (which is making life difficult for the hackers and
throwing away performannce for the average user).
