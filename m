Subject: Re: [PATCH 10/17] prmem: documentation
References: <20181023213504.28905-1-igor.stoppa@huawei.com>
 <20181023213504.28905-11-igor.stoppa@huawei.com>
 <20181026092609.GB3159@worktop.c.hoisthospitality.com>
 <20181026102009.GP25444@bombadil.infradead.org>
From: Igor Stoppa <igor.stoppa@gmail.com>
Message-ID: <6f554454-ab8c-92be-a2b5-543e609dc351@gmail.com>
Date: Mon, 29 Oct 2018 21:28:12 +0200
MIME-Version: 1.0
In-Reply-To: <20181026102009.GP25444@bombadil.infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>, Peter Zijlstra <peterz@infradead.org>
Cc: Mimi Zohar <zohar@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, kernel-hardening@lists.openwall.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, igor.stoppa@huawei.com, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Mike Rapoport <rppt@linux.vnet.ibm.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>



On 26/10/2018 11:20, Matthew Wilcox wrote:
> On Fri, Oct 26, 2018 at 11:26:09AM +0200, Peter Zijlstra wrote:
>> Jon,
>>
>> So the below document is a prime example for why I think RST sucks. As a
>> text document readability is greatly diminished by all the markup
>> nonsense.
>>
>> This stuff should not become write-only content like html and other
>> gunk. The actual text file is still the primary means of reading this.
> 
> I think Igor neglected to read doc-guide/sphinx.rst:

Guilty as charged :-/

> Specific guidelines for the kernel documentation
> ------------------------------------------------
> 
> Here are some specific guidelines for the kernel documentation:
> 
> * Please don't go overboard with reStructuredText markup. Keep it
>    simple. For the most part the documentation should be plain text with
>    just enough consistency in formatting that it can be converted to
>    other formats.

> I agree that it's overly marked up.

I'll fix it

--
igor
