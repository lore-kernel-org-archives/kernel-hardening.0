Subject: Re: [PATCH 1/6] genalloc: track beginning of allocations
References: <20180204164732.28241-1-igor.stoppa@huawei.com>
 <20180204164732.28241-2-igor.stoppa@huawei.com>
 <60e66c5a-c1de-246f-4be8-b02cb0275da6@infradead.org>
 <947ea9c3-b045-17d3-51e5-df80b4fb27e6@huawei.com>
From: Randy Dunlap <rdunlap@infradead.org>
Message-ID: <8b02744c-d527-f000-78c0-90142052b4ae@infradead.org>
Date: Fri, 9 Feb 2018 09:15:00 -0800
MIME-Version: 1.0
In-Reply-To: <947ea9c3-b045-17d3-51e5-df80b4fb27e6@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
To: Igor Stoppa <igor.stoppa@huawei.com>, jglisse@redhat.com, keescook@chromium.org, mhocko@kernel.org, labbott@redhat.com, hch@infradead.org, willy@infradead.org
Cc: cl@linux.com, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 02/09/2018 08:18 AM, Igor Stoppa wrote:
> 
> 
> On 05/02/18 00:34, Randy Dunlap wrote:
>> On 02/04/2018 08:47 AM, Igor Stoppa wrote:
> 
> [...]
> 
>> It would be good for a lot of this to be in a source file or the
>> pmalloc.rst documentation file instead of living only in the git repository.
> 
> This is actually about genalloc. The genalloc documentation is high
> level and mostly about the API, while this talks about the guts of the
> library. The part modified by the patch. This text doesn't seem to
> belong to the generic genalloc documentation.
> I will move it to the .c file, but isn't it too much text in a source file?

No, that will be fine.

thanks,
-- 
~Randy
