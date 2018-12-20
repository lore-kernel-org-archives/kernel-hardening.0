References: <20181219213338.26619-1-igor.stoppa@huawei.com> <20181219213338.26619-12-igor.stoppa@huawei.com>
From: Thiago Jung Bauermann <bauerman@linux.ibm.com>
Subject: Re: [PATCH 11/12] IMA: turn ima_policy_flags into __wr_after_init
In-reply-to: <20181219213338.26619-12-igor.stoppa@huawei.com>
Date: Thu, 20 Dec 2018 15:30:01 -0200
MIME-Version: 1.0
Content-Type: text/plain
Message-Id: <87pntwumw6.fsf@morokweng.localdomain>
To: Igor Stoppa <igor.stoppa@gmail.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Matthew Wilcox <willy@infradead.org>, Peter Zijlstra <peterz@infradead.org>, Dave Hansen <dave.hansen@linux.intel.com>, Mimi Zohar <zohar@linux.vnet.ibm.com>, igor.stoppa@huawei.com, Nadav Amit <nadav.amit@gmail.com>, Kees Cook <keescook@chromium.org>, linux-integrity@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>


Hello Igor,

Igor Stoppa <igor.stoppa@gmail.com> writes:

> diff --git a/security/integrity/ima/ima_init.c b/security/integrity/ima/ima_init.c
> index 59d834219cd6..5f4e13e671bf 100644
> --- a/security/integrity/ima/ima_init.c
> +++ b/security/integrity/ima/ima_init.c
> @@ -21,6 +21,7 @@
>  #include <linux/scatterlist.h>
>  #include <linux/slab.h>
>  #include <linux/err.h>
> +#include <linux/prmem.h>
>
>  #include "ima.h"
>
> @@ -98,9 +99,9 @@ void __init ima_load_x509(void)
>  {
>  	int unset_flags = ima_policy_flag & IMA_APPRAISE;
>
> -	ima_policy_flag &= ~unset_flags;
> +	wr_assign(ima_policy_flag, ima_policy_flag & ~unset_flags);
>  	integrity_load_x509(INTEGRITY_KEYRING_IMA, CONFIG_IMA_X509_PATH);
> -	ima_policy_flag |= unset_flags;
> +	wr_assign(ima_policy_flag, ima_policy_flag | unset_flags);
>  }
>  #endif

In the cover letter, you said:

> As the name implies, the write protection kicks in only after init()
> is completed; before that moment, the data is modifiable in the usual
> way.

Given that, is it still necessary or useful to use wr_assign() in a
function marked with __init?

--
Thiago Jung Bauermann
IBM Linux Technology Center
