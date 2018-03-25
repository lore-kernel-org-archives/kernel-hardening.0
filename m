Subject: Re: [PATCH 6/8] Pmalloc selftest
References: <20180313214554.28521-1-igor.stoppa@huawei.com>
 <20180313214554.28521-7-igor.stoppa@huawei.com>
 <20180314122512.GF29631@bombadil.infradead.org>
From: Igor Stoppa <igor.stoppa@huawei.com>
Message-ID: <ce6e34a4-592d-624c-2353-20e50e321298@huawei.com>
Date: Sun, 25 Mar 2018 04:32:57 +0300
MIME-Version: 1.0
In-Reply-To: <20180314122512.GF29631@bombadil.infradead.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: david@fromorbit.com, rppt@linux.vnet.ibm.com, keescook@chromium.org, mhocko@kernel.org, labbott@redhat.com, linux-security-module@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>



On 14/03/18 14:25, Matthew Wilcox wrote:
> On Tue, Mar 13, 2018 at 11:45:52PM +0200, Igor Stoppa wrote:
>> Add basic self-test functionality for pmalloc.
> 
> Here're some additional tests for your test-suite:
> 
> 	for (i = 1; i; i *= 2)
> 		pzalloc(pool, i - 1, GFP_KERNEL);
> 

Ok, I have almost finished the rewrite.
I still have to address this comment.

When I run the test, eventually the system runs out of memory, it keeps
getting allocation errors from vmalloc, until i finally overflows and
becomes 0.

Am I supposed to do something about it?
If pmalloc receives a request that the vmalloc backend cannot satisfy, I
would prefer that vmalloc itself produces the warning and pmalloc
returns NULL.

This doesn't look like a test case that one can leave always enabled in
a build, but maybe I'm missing the point.

--
igor
