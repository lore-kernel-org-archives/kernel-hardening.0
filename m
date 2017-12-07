Date: Thu, 7 Dec 2017 15:32:03 +1100
From: "Tobin C. Harding" <me@tobin.cc>
Message-ID: <20171207043203.GC3275@eros>
References: <1512455204.17323.20.camel@gmail.com>
 <20171206040437.GB11835@eros>
 <1512561090.17323.32.camel@gmail.com>
 <20171206230117.GI11835@eros>
 <1512616656.17323.50.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1512616656.17323.50.camel@gmail.com>
Subject: [kernel-hardening] Re: [PATCH v4] leaking_addresses: add support for x86 32-bit kernel
 addresses
To: kaiwan.billimoria@gmail.com
Cc: Alexander Kapshuk <alexander.kapshuk@gmail.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Dec 07, 2017 at 08:47:36AM +0530, kaiwan.billimoria@gmail.com wrote:
> Currently, leaking_addresses.pl only supports scanning 64 bit
> architectures. This is due to how the regular expressions are formed. We
> can do better than this. 32 architectures can be supported if we take
> into consideration the kernel virtual address split (via the PAGE_OFFSET
> kernel configurable).
> 
> Add support for ix86 32 bit architectures.
>  - Add command line option for page offset.
>  - Add command line option for kernel configuration file.
>  - Parse kernel config file for page offset (CONFIG_PAGE_OFFSET).
>  - Use page offset when checking for kernel virtual addresses.
> 
> 
> Signed-off-by: Kaiwan N Billimoria <kaiwan.billimoria@gmail.com>
> ---
> 
> Ok, this patch is the same as the previous v3, with suggestions from Tobin incorporated:
> - newline in sub is_false_positive_ix86_32
> - refactoring of code to remove the temp file in sub get_page_offset
> - git short desc delibrately modified to make it more appropriate.

Cool, this is all good. I'm not going to apply it because of our
previous discussion on doing a general 32 bit implementation. I've just
finished doing some work to lay the ground for that. Posting the patch
set now.

thanks,
Tobin.
