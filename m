Subject: Re: [RFC PATCH v5 03/12] __wr_after_init: Core and default arch
References: <cover.1550097697.git.igor.stoppa@huawei.com>
 <b99f0de701e299b9d25ce8cfffa3387b9687f5fc.1550097697.git.igor.stoppa@huawei.com>
 <20190214112849.GM32494@hirez.programming.kicks-ass.net>
From: Igor Stoppa <igor.stoppa@gmail.com>
Message-ID: <6e9ec71c-ee75-9b1e-9ff8-a3210030e85d@gmail.com>
Date: Fri, 15 Feb 2019 01:10:33 +0200
MIME-Version: 1.0
In-Reply-To: <20190214112849.GM32494@hirez.programming.kicks-ass.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <peterz@infradead.org>
Cc: Igor Stoppa <igor.stoppa@huawei.com>, Andy Lutomirski <luto@amacapital.net>, Nadav Amit <nadav.amit@gmail.com>, Matthew Wilcox <willy@infradead.org>, Kees Cook <keescook@chromium.org>, Dave Hansen <dave.hansen@linux.intel.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Thiago Jung Bauermann <bauerman@linux.ibm.com>, Ahmed Soliman <ahmedsoliman@mena.vt.edu>, linux-integrity@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>



On 14/02/2019 13:28, Peter Zijlstra wrote:
> On Thu, Feb 14, 2019 at 12:41:32AM +0200, Igor Stoppa wrote:

[...]

>> +#define wr_rcu_assign_pointer(p, v) ({	\
>> +	smp_mb();			\
>> +	wr_assign(p, v);		\
>> +	p;				\
>> +})
> 
> This requires that wr_memcpy() (through wr_assign) is single-copy-atomic
> for native types. There is not a comment in sight that states this.

Right, I kinda expected native-aligned <-> atomic, but it's not 
necessarily true. It should be confirmed when enabling write rare on a 
new architecture. I'll add the comment.

> Also, is this true of x86/arm64 memcpy ?


For x86_64:
https://elixir.bootlin.com/linux/v5.0-rc6/source/arch/x86/include/asm/uaccess.h#L462 
  the mov"itype"  part should deal with atomic copy of native, aligned 
types.


For arm64:
https://elixir.bootlin.com/linux/v5.0-rc6/source/arch/arm64/lib/copy_template.S#L110 
.Ltiny15 deals with copying less than 16 bytes, which includes pointers. 
When the data is aligned, the copy of a pointer should be atomic.


--
igor
