Date: Mon, 11 Feb 2019 18:39:52 -0800
From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [RFC PATCH v4 01/12] __wr_after_init: Core and default arch
Message-ID: <20190212023952.GK12668@bombadil.infradead.org>
References: <cover.1549927666.git.igor.stoppa@huawei.com>
 <9d03ef9d09446da2dd92c357aa39af6cd071d7c4.1549927666.git.igor.stoppa@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d03ef9d09446da2dd92c357aa39af6cd071d7c4.1549927666.git.igor.stoppa@huawei.com>
To: Igor Stoppa <igor.stoppa@gmail.com>
Cc: Igor Stoppa <igor.stoppa@huawei.com>, Andy Lutomirski <luto@amacapital.net>, Nadav Amit <nadav.amit@gmail.com>, Peter Zijlstra <peterz@infradead.org>, Kees Cook <keescook@chromium.org>, Dave Hansen <dave.hansen@linux.intel.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, Thiago Jung Bauermann <bauerman@linux.ibm.com>, Ahmed Soliman <ahmedsoliman@mena.vt.edu>, linux-integrity@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 12, 2019 at 01:27:38AM +0200, Igor Stoppa wrote:
> +#ifndef CONFIG_PRMEM
[...]
> +#else
> +
> +#include <linux/mm.h>

It's a mistake to do conditional includes like this.  That way you see
include loops with some configs and not others.  Our headers are already
so messy, better to just include mm.h unconditionally.
