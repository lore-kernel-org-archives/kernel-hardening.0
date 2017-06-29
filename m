References: <1498717781-29151-1-git-send-email-mpe@ellerman.id.au>
From: Laura Abbott <labbott@redhat.com>
Message-ID: <0ebcc89e-8230-defa-8c15-0d673505db29@redhat.com>
Date: Thu, 29 Jun 2017 09:45:16 -0700
MIME-Version: 1.0
In-Reply-To: <1498717781-29151-1-git-send-email-mpe@ellerman.id.au>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [RFC PATCH 1/4] Provide linux/set_memory.h
To: Michael Ellerman <mpe@ellerman.id.au>, kernel-hardening@lists.openwall.com
Cc: keescook@chromium.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On 06/28/2017 11:29 PM, Michael Ellerman wrote:
> Currently code that wants to use set_memory_ro() etc, needs to include
> asm/set_memory.h, which doesn't exist on all arches. Some code knows
> it only builds on arches which have the header, other code guards the
> inclusion with an #ifdef, neither is ideal.
> 
> So create linux/set_memory.h. This always exists, so users don't need
> an #ifdef just to include the header.
> 
> When CONFIG_ARCH_HAS_SET_MEMORY=y it includes asm/set_memory.h,
> otherwise it provides empty non-failing implementations.
> 
> Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
> ---
>  include/linux/set_memory.h | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
>  create mode 100644 include/linux/set_memory.h
> 
> 
> Does this look OK to people? If so it would be great if someone, Kees?,
> Andrew?, could pick up patch 1 (it's a nop by itself) and then we can send the
> conversions separately later in the merge window?
> 

Acked-by: Laura Abbott <labbott@redhat.com>

> cheers
> 
> diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
> new file mode 100644
> index 000000000000..e5140648f638
> --- /dev/null
> +++ b/include/linux/set_memory.h
> @@ -0,0 +1,20 @@
> +/*
> + * Copyright 2017, Michael Ellerman, IBM Corporation.
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License version
> + * 2 as published by the Free Software Foundation;
> + */
> +#ifndef _LINUX_SET_MEMORY_H_
> +#define _LINUX_SET_MEMORY_H_
> +
> +#ifdef CONFIG_ARCH_HAS_SET_MEMORY
> +#include <asm/set_memory.h>
> +#else
> +static inline int set_memory_ro(unsigned long addr, int numpages) { return 0; }
> +static inline int set_memory_rw(unsigned long addr, int numpages) { return 0; }
> +static inline int set_memory_x(unsigned long addr,  int numpages) { return 0; }
> +static inline int set_memory_nx(unsigned long addr, int numpages) { return 0; }
> +#endif
> +
> +#endif /* _LINUX_SET_MEMORY_H_ */
> 
