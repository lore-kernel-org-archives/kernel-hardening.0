References: <20180124175631.22925-1-igor.stoppa@huawei.com>
 <20180124175631.22925-5-igor.stoppa@huawei.com>
From: Igor Stoppa <igor.stoppa@huawei.com>
Message-ID: <c5ae2b4f-4a60-1526-0512-51f1c9a5e4a8@huawei.com>
Date: Fri, 26 Jan 2018 21:41:35 +0200
MIME-Version: 1.0
In-Reply-To: <20180124175631.22925-5-igor.stoppa@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH 4/6] Protectable Memory
To: jglisse@redhat.com, keescook@chromium.org, mhocko@kernel.org, labbott@redhat.com, hch@infradead.org, willy@infradead.org
Cc: cl@linux.com, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 24/01/18 19:56, Igor Stoppa wrote:

[...]

> +bool pmalloc_prealloc(struct gen_pool *pool, size_t size)
> +{

[...]

> +abort:
> +	vfree(chunk);

this should be vfree_atomic()

[...]

> +void *pmalloc(struct gen_pool *pool, size_t size, gfp_t gfp)
> +{

[...]

> +free:
> +	vfree(chunk);

and this one too

I will fix them in the next iteration.
I am waiting to see if any more comments arrive.
Otherwise, I'll send it out probably next Tuesday.

--
igor
