MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <119189.1517763703@turing-police.cc.vt.edu>
References: <119189.1517763703@turing-police.cc.vt.edu>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 6 Feb 2018 11:54:22 +1100
Message-ID: <CAGXu5jLs5D_py8GgcoVefahrSMF_a=Zky3qSbirYHKMRtDRNpQ@mail.gmail.com>
Subject: Re: [PATCH 1/2] GCC release 8 support for gcc-plugins
Content-Type: text/plain; charset="UTF-8"
To: Valdis Kletnieks <valdis.kletnieks@vt.edu>
Cc: kernel-hardening@lists.openwall.com, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Feb 5, 2018 at 4:01 AM,  <valdis.kletnieks@vt.edu> wrote:
> GCC requires another #include to get the gcc-plugins to build cleanly.
>
> Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>
>
> diff --git a/scripts/gcc-plugins/gcc-common.h b/scripts/gcc-plugins/gcc-common.h
> index ffd1dfaa1cc1..f46750053377 100644
> --- a/scripts/gcc-plugins/gcc-common.h
> +++ b/scripts/gcc-plugins/gcc-common.h
> @@ -97,6 +97,10 @@
>  #include "predict.h"
>  #include "ipa-utils.h"
>
> +#if BUILDING_GCC_VERSION >= 8000
> +#include "stringpool.h"
> +#endif
> +
>  #if BUILDING_GCC_VERSION >= 4009
>  #include "attribs.h"
>  #include "varasm.h"

Thanks! I can confirm this works for me. I'll get it applied.

-Kees

-- 
Kees Cook
Pixel Security
