Subject: Re: [RFC PATCH v4 01/12] __wr_after_init: Core and default arch
References: <cover.1549927666.git.igor.stoppa@huawei.com>
 <9d03ef9d09446da2dd92c357aa39af6cd071d7c4.1549927666.git.igor.stoppa@huawei.com>
 <20190212023952.GK12668@bombadil.infradead.org>
From: Igor Stoppa <igor.stoppa@gmail.com>
Message-ID: <9ebd237c-c059-9219-8d11-7a708a1f80da@gmail.com>
Date: Tue, 12 Feb 2019 09:20:34 +0200
MIME-Version: 1.0
In-Reply-To: <20190212023952.GK12668@bombadil.infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Matthew Wilcox <willy@infradead.org>
Cc: Igor Stoppa <igor.stoppa@huawei.com>, Andy Lutomirski <luto@amacapital.net>, Nadav Amit <nadav.amit@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Kees Cook <keescook@chromium.org>, Dave Hansen <dave.hansen@linux.intel.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Thiago Jung Bauermann <bauerman@linux.ibm.com>, Ahmed Soliman <ahmedsoliman@mena.vt.edu>, linux-integrity@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>



On 12/02/2019 04:39, Matthew Wilcox wrote:
> On Tue, Feb 12, 2019 at 01:27:38AM +0200, Igor Stoppa wrote:
>> +#ifndef CONFIG_PRMEM
> [...]
>> +#else
>> +
>> +#include <linux/mm.h>
> 
> It's a mistake to do conditional includes like this.  That way you see
> include loops with some configs and not others.  Our headers are already
> so messy, better to just include mm.h unconditionally.
> 

ok

Can I still do the following, in prmem.c ?

#ifdef CONFIG_ARCH_HAS_PRMEM_HEADER
+#include <asm/prmem.h>
+#else
+
+struct wr_state {
+       struct mm_struct *prev;
+};
+
+#endif


It's still a conditional include, but it's in a C file, it shouldn't 
cause any chance of loops.

The alternative is that each arch supporting prmem must have a 
(probably) empty asm/prmem.h header.

I did some reasearch about telling the compiler to include a header only 
if it exists, but it doesn't seem to be a gcc feature.

--
igor
