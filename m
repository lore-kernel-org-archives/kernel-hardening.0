Message-ID: <1494045760.31950.21.camel@perches.com>
From: Joe Perches <joe@perches.com>
Date: Fri, 05 May 2017 21:42:40 -0700
In-Reply-To: <20170506040747.GF32707@kroah.com>
References: <20170506040641.GA32707@kroah.com>
	 <20170506040747.GF32707@kroah.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC 5/6] lib: vsprintf: Add "%paP", "%padP" options
To: Greg KH <gregkh@linuxfoundation.org>, kernel-hardening@lists.openwall.com, Petr Mladek <pmladek@suse.com>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: linux-kernel@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, William Roberts <william.c.roberts@intel.com>, Chris Fries <cfries@google.com>, Dave Weinstein <olorin@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 2017-05-05 at 21:07 -0700, Greg KH wrote:
> From: Chris Fries <cfries@google.com>
> 
> Add %paP and %padP for physical address that need to always be shown
> regardless of kptr restrictions.

The commit message could be improved.

I had to look at the actual code to see if %papP was supported.

> diff --git a/Documentation/printk-formats.txt b/Documentation/printk-formats.txt
[]
> @@ -82,18 +82,20 @@ Struct Resources:
>  
>  Physical addresses types phys_addr_t:
>  
> -	%pa[p]	0x01234567 or 0x0123456789abcdef
> +	%pa[p][P] 0x01234567 or 0x0123456789abcdef

Well, that's good.

> diff --git a/lib/vsprintf.c b/lib/vsprintf.c
[]
> @@ -1394,23 +1394,29 @@ static noinline_for_stack
>  char *address_val(char *buf, char *end, const void *addr, const char *fmt)
>  {
>  	unsigned long long num;
> +	int cleanse = kptr_restrict_cleanse_addresses();

bool
