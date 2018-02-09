Subject: Re: [PATCH 1/6] genalloc: track beginning of allocations
References: <20180204164732.28241-1-igor.stoppa@huawei.com>
 <20180204164732.28241-2-igor.stoppa@huawei.com>
 <60e66c5a-c1de-246f-4be8-b02cb0275da6@infradead.org>
 <20180205034531.GA18559@bombadil.infradead.org>
From: Igor Stoppa <igor.stoppa@huawei.com>
Message-ID: <ca8891c9-c916-abf1-7370-5e4f37beaac9@huawei.com>
Date: Fri, 9 Feb 2018 16:28:06 +0200
MIME-Version: 1.0
In-Reply-To: <20180205034531.GA18559@bombadil.infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>, Randy Dunlap <rdunlap@infradead.org>
Cc: jglisse@redhat.com, keescook@chromium.org, mhocko@kernel.org, labbott@redhat.com, hch@infradead.org, cl@linux.com, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>



On 05/02/18 05:45, Matthew Wilcox wrote:
> On Sun, Feb 04, 2018 at 02:34:08PM -0800, Randy Dunlap wrote:
>>> +/**
>>> + * cleart_bits_ll - according to the mask, clears the bits specified by
>>
>>       clear_bits_ll
> 
> 'make W=1' should catch this ... yes?
> 
> (hint: building with 'make C=1 W=1' finds all kinds of interesting issues
> in your code.  W=12 or W=123 finds too many false positives for my tastes)

ok, thank you, I will start using it

--
igor
