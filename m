Date: Wed, 31 Jan 2018 18:00:36 -0600 (CST)
From: Christopher Lameter <cl@linux.com>
Subject: Re: [PATCH 3/6] struct page: add field for vm_struct
In-Reply-To: <20180130151446.24698-4-igor.stoppa@huawei.com>
Message-ID: <alpine.DEB.2.20.1801311758340.21272@nuc-kabylake>
References: <20180130151446.24698-1-igor.stoppa@huawei.com> <20180130151446.24698-4-igor.stoppa@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: Igor Stoppa <igor.stoppa@huawei.com>
Cc: jglisse@redhat.com, keescook@chromium.org, mhocko@kernel.org, labbott@redhat.com, hch@infradead.org, willy@infradead.org, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 30 Jan 2018, Igor Stoppa wrote:

> @@ -1769,6 +1774,9 @@ void *__vmalloc_node_range(unsigned long size, unsigned long align,
>
>  	kmemleak_vmalloc(area, size, gfp_mask);
>
> +	for (page_counter = 0; page_counter < area->nr_pages; page_counter++)
> +		area->pages[page_counter]->area = area;
> +
>  	return addr;

Well this introduces significant overhead for large sized allocation. Does
this not matter because the areas are small?

Would it not be better to use compound page allocations here?
page_head(whatever) gets you the head page where you can store all sorts
of information about the chunk of memory.
