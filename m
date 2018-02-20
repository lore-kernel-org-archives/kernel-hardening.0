Date: Tue, 20 Feb 2018 12:54:42 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH 3/6] struct page: add field for vm_struct
Message-ID: <20180220205442.GA15973@bombadil.infradead.org>
References: <20180211031920.3424-1-igor.stoppa@huawei.com>
 <20180211031920.3424-4-igor.stoppa@huawei.com>
 <20180211211646.GC4680@bombadil.infradead.org>
 <cef01110-dc23-4442-f277-88d1d3662e00@huawei.com>
 <b59546a4-5a5b-ca48-3b51-09440b6a5493@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b59546a4-5a5b-ca48-3b51-09440b6a5493@huawei.com>
To: Igor Stoppa <igor.stoppa@huawei.com>
Cc: rdunlap@infradead.org, corbet@lwn.net, keescook@chromium.org, mhocko@kernel.org, labbott@redhat.com, jglisse@redhat.com, hch@infradead.org, cl@linux.com, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 20, 2018 at 09:53:30PM +0200, Igor Stoppa wrote:
> The patch relies on the function vmalloc_to_page ... which will return
> NULL when applied to huge mappings, while the original implementation
> will still work.

Huh?  vmalloc_to_page() should work for huge mappings...

> It was found while testing on a configuration with framebuffer.

... ah.  You tried to use vmalloc_to_page() on something which wasn't
backed by a struct page.  That's *supposed* to return NULL, but my
guess is that after this patch it returned garbage.
