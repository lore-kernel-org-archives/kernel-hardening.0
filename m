Subject: Re: [PATCH 3/6] struct page: add field for vm_struct
References: <20180130151446.24698-1-igor.stoppa@huawei.com>
 <20180130151446.24698-4-igor.stoppa@huawei.com>
 <alpine.DEB.2.20.1801311758340.21272@nuc-kabylake>
 <48fde114-d063-cfbf-e1b6-262411fcd963@huawei.com>
 <alpine.DEB.2.20.1802021240370.31548@nuc-kabylake>
 <a12afe9b-79cf-d5c1-3795-89fbf61c6c9d@huawei.com>
 <alpine.DEB.2.20.1802050931190.10647@nuc-kabylake>
From: Igor Stoppa <igor.stoppa@huawei.com>
Message-ID: <47f64329-32e2-44ba-c878-ee3cccdebfea@huawei.com>
Date: Fri, 9 Feb 2018 13:34:05 +0200
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.20.1802050931190.10647@nuc-kabylake>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: Christopher Lameter <cl@linux.com>
Cc: jglisse@redhat.com, keescook@chromium.org, mhocko@kernel.org, labbott@redhat.com, hch@infradead.org, willy@infradead.org, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>



On 05/02/18 17:33, Christopher Lameter wrote:
> On Sat, 3 Feb 2018, Igor Stoppa wrote:
> 
>> - the property of the compound page will affect the property of all the
>> pages in the compound, so when one is write protected, it can generate a
>> lot of wasted memory, if there is too much slack (because of the order)
>> With vmalloc, I can allocate any number of pages, minimizing the waste.
> 
> I thought the intend here is to create a pool where the whole pool becomes
> RO?

Yes, but why would I force the number of pages in the pool to be a power
of 2, when it can be any number?

If a need, say, 17 pages, I would have to allocate 32.
But it can be worse than that.
Since the size of the overall allocated memory is not known upfront, I
wold have a problem to decide how many pages to allocate, every time
there is need to grow the pool.

Or push the problem to the user of the API, who might be equally unaware.

Notice that there is already a function (prealloc) available to the user
of the API, if the size is known upfront.

So I do not really see how using compound pages would make memory
utilization better or even not worse.

--
igor
