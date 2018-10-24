Subject: Re: [PATCH 10/17] prmem: documentation
References: <20181023213504.28905-1-igor.stoppa@huawei.com>
 <20181023213504.28905-11-igor.stoppa@huawei.com>
 <b09b3feb-8e3d-5fab-4e2b-35e8c252b27c@infradead.org>
From: Igor Stoppa <igor.stoppa@gmail.com>
Message-ID: <42e65f5f-2753-54a7-08a4-b51e56dfedbe@gmail.com>
Date: Wed, 24 Oct 2018 17:30:52 +0300
MIME-Version: 1.0
In-Reply-To: <b09b3feb-8e3d-5fab-4e2b-35e8c252b27c@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Randy Dunlap <rdunlap@infradead.org>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Kees Cook <keescook@chromium.org>, Matthew Wilcox <willy@infradead.org>, Dave Chinner <david@fromorbit.com>, James Morris <jmorris@namei.org>, Michal Hocko <mhocko@kernel.org>, kernel-hardening@lists.openwall.com, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org
Cc: igor.stoppa@huawei.com, Dave Hansen <dave.hansen@linux.intel.com>, Jonathan Corbet <corbet@lwn.net>, Laura Abbott <labbott@redhat.com>, Mike Rapoport <rppt@linux.vnet.ibm.com>, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

On 24/10/18 06:48, Randy Dunlap wrote:
> Hi,
> 
> On 10/23/18 2:34 PM, Igor Stoppa wrote:

[...]

>> +- The present document doesn't address such transient.
> 
>                                                 transience.

ok

[...]

>> +   are attempted after the write protection is in place, will cause
> 
> no comma.

ok

[...]

>> +        - Its usefulness depends on the specific use case at hand
> 
> end above sentence with a period, please, like all of the others above it.

ok


>> +    - The "START_WR" mode is the only one which provides immediate protection, at the cost of speed.
> 
> Please try to keep the line above and a few below to < 80 characters in length.
> (because some of us read rst files as text files, with a text editor, and line
> wrap is ugly)

ok, I still have to master .rst :-(

[...]

>> +- The users of rare write must take care of ensuring the atomicity of the
> 
> s/rare write/write rare/ ?

thanks

>> +  action, respect to the way they use the data being altered; for example,
> 
>    This ..   "respect to the way" is awkward, but I don't know what to
> change it to.
> 
>> +  take a lock before making a copy of the value to modify (if it's
>> +  relevant), then alter it, issue the call to rare write and finally
>> +  release the lock. Some special scenario might be exempt from the need
>> +  for locking, but in general rare-write must be treated as an operation
> 
> It seemed to me that "write-rare" (or write rare) was the going name, but now
> it's being called "rare write" (or rare-write).  Just be consistent, please.


write-rare it is, because it can be shortened as wr_xxx

rare_write becomes rw_xxx

which wrongly hints at read/write, which it definitely is not

>> +  tlb entries. It still does a better job of it, compared to invoking
> 
>       TLB

ok

>> +  vmalloc for each allocation, but it is undeniably less optimized wrt to
> 
> s/wrt/with respect to/

yes

> Thanks for the documentation.

thanks for the review :-)

--
igor
