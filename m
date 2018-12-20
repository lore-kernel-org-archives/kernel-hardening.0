Subject: Re: [PATCH 04/12] __wr_after_init: x86_64: __wr_op
References: <20181219213338.26619-1-igor.stoppa@huawei.com>
 <20181219213338.26619-5-igor.stoppa@huawei.com>
 <20181220184917.GY10600@bombadil.infradead.org>
From: Igor Stoppa <igor.stoppa@gmail.com>
Message-ID: <d5e8523a-3afd-d992-1af3-b329985c5ed5@gmail.com>
Date: Thu, 20 Dec 2018 21:19:15 +0200
MIME-Version: 1.0
In-Reply-To: <20181220184917.GY10600@bombadil.infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: Andy Lutomirski <luto@amacapital.net>, Peter Zijlstra <peterz@infradead.org>, Dave Hansen <dave.hansen@linux.intel.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, igor.stoppa@huawei.com, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, linux-integrity@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>



On 20/12/2018 20:49, Matthew Wilcox wrote:

> I think you're causing yourself more headaches by implementing this "op"
> function.  

I probably misinterpreted the initial criticism on my first patchset, 
about duplication. Somehow, I'm still thinking to the endgame of having 
higher-level functions, like list management.

> Here's some generic code:

thank you, I have one question, below

> void *wr_memcpy(void *dst, void *src, unsigned int len)
> {
> 	wr_state_t wr_state;
> 	void *wr_poking_addr = __wr_addr(dst);
> 
> 	local_irq_disable();
> 	wr_enable(&wr_state);
> 	__wr_memcpy(wr_poking_addr, src, len);

Is __wraddr() invoked inside wm_memcpy() instead of being invoked 
privately within __wr_memcpy() because the code is generic, or is there 
some other reason?

> 	wr_disable(&wr_state);
> 	local_irq_enable();
> 
> 	return dst;
> }
> 
> Now, x86 can define appropriate macros and functions to use the temporary_mm
> functionality, and other architectures can do what makes sense to them.
> 

--
igor
