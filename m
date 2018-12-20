Subject: Re: [PATCH 04/12] __wr_after_init: x86_64: __wr_op
From: Igor Stoppa <igor.stoppa@gmail.com>
References: <20181219213338.26619-1-igor.stoppa@huawei.com>
 <20181219213338.26619-5-igor.stoppa@huawei.com>
Message-ID: <f800ee0f-9ac5-f91c-c1a6-3e094721c91d@gmail.com>
Date: Thu, 20 Dec 2018 18:53:25 +0200
MIME-Version: 1.0
In-Reply-To: <20181219213338.26619-5-igor.stoppa@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: Andy Lutomirski <luto@amacapital.net>, Matthew Wilcox <willy@infradead.org>, Peter Zijlstra <peterz@infradead.org>, Dave Hansen <dave.hansen@linux.intel.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>
Cc: igor.stoppa@huawei.com, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, linux-integrity@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 19/12/2018 23:33, Igor Stoppa wrote:

> +	if (WARN_ONCE(op >= WR_OPS_NUMBER, "Invalid WR operation.") ||
> +	    WARN_ONCE(!is_wr_after_init(dst, len), "Invalid WR range."))
> +		return (void *)dst;
> +
> +	offset = dst - (unsigned long)&__start_wr_after_init;

I forgot to remove the offset.
If the whole kernel memory is remapped, it is shifted by wr_poking_base.
I'll fix it in the next iteration.

> +	wr_poking_addr = wr_poking_base + offset;

	wr_poking_addr = wr_poking_base + dst;

--
igor
