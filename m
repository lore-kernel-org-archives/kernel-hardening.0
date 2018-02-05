Date: Sun, 4 Feb 2018 19:45:31 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 1/6] genalloc: track beginning of allocations
Message-ID: <20180205034531.GA18559@bombadil.infradead.org>
References: <20180204164732.28241-1-igor.stoppa@huawei.com>
 <20180204164732.28241-2-igor.stoppa@huawei.com>
 <60e66c5a-c1de-246f-4be8-b02cb0275da6@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <60e66c5a-c1de-246f-4be8-b02cb0275da6@infradead.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: Igor Stoppa <igor.stoppa@huawei.com>, jglisse@redhat.com, keescook@chromium.org, mhocko@kernel.org, labbott@redhat.com, hch@infradead.org, cl@linux.com, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Feb 04, 2018 at 02:34:08PM -0800, Randy Dunlap wrote:
> > +/**
> > + * cleart_bits_ll - according to the mask, clears the bits specified by
> 
>       clear_bits_ll

'make W=1' should catch this ... yes?

(hint: building with 'make C=1 W=1' finds all kinds of interesting issues
in your code.  W=12 or W=123 finds too many false positives for my tastes)
