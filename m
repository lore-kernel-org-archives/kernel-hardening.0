Subject: Re: [RFC PATCH v5 03/12] __wr_after_init: Core and default arch
References: <cover.1550097697.git.igor.stoppa@huawei.com>
 <b99f0de701e299b9d25ce8cfffa3387b9687f5fc.1550097697.git.igor.stoppa@huawei.com>
 <20190214112849.GM32494@hirez.programming.kicks-ass.net>
 <6e9ec71c-ee75-9b1e-9ff8-a3210030e85d@gmail.com>
 <20190215085736.GO32494@hirez.programming.kicks-ass.net>
From: Igor Stoppa <igor.stoppa@gmail.com>
Message-ID: <7cfb5d06-96a6-41a0-9f57-d9df1204f45e@gmail.com>
Date: Sat, 16 Feb 2019 17:15:38 +0200
MIME-Version: 1.0
In-Reply-To: <20190215085736.GO32494@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Igor Stoppa <igor.stoppa@huawei.com>, Andy Lutomirski <luto@amacapital.net>, Nadav Amit <nadav.amit@gmail.com>, Matthew Wilcox <willy@infradead.org>, Kees Cook <keescook@chromium.org>, Dave Hansen <dave.hansen@linux.intel.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Thiago Jung Bauermann <bauerman@linux.ibm.com>, Ahmed Soliman <ahmedsoliman@mena.vt.edu>, linux-integrity@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>



On 15/02/2019 10:57, Peter Zijlstra wrote:

> Where are the comments and Changelog notes ? How is an arch maintainer
> to be aware of this requirement when adding support for his/her arch?

Yes, it will be fixed in the next revision. I've added comment to the 
core wr_assign function and also to the changelogs for the patches 
enabling it on x86_64 and arm64, respectively.

Should I add mention of it also in the documentation?

--
igor
