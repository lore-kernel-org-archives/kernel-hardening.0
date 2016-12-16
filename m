Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 16 Dec 2016 15:10:45 +0100
From: Emese Revfy <re.emese@gmail.com>
Message-Id: <20161216151045.8b05123396aec5598825f4c3@gmail.com>
In-Reply-To: <20161216090033.2007806-1-arnd@arndb.de>
References: <20161216090033.2007806-1-arnd@arndb.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH] gcc-plugin: include memmodel.h and tree_vrp.h for gcc-7
To: Arnd Bergmann <arnd@arndb.de>
Cc: Kees Cook <keescook@chromium.org>, Kugan <kugan.vivekanandarajah@linaro.org>, stable@vger.kernel.org, Michal Marek <mmarek@suse.com>, kernel-hardening@lists.openwall.com, linux-kernel@vger.kernel.org, "pageexec@freemail.hu" <pageexec@freemail.hu>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, 16 Dec 2016 10:00:22 +0100
Arnd Bergmann <arnd@arndb.de> wrote:

> Cc: stable@vger.kernel.org
> Suggested-by: Kugan <kugan.vivekanandarajah@linaro.org>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  scripts/gcc-plugins/gcc-common.h | 6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/scripts/gcc-plugins/gcc-common.h b/scripts/gcc-plugins/gcc-common.h
> index 950fd2e64bb7..cb4a9518b58a 100644
> --- a/scripts/gcc-plugins/gcc-common.h
> +++ b/scripts/gcc-plugins/gcc-common.h
> @@ -18,6 +18,9 @@
>  
>  #include "tree-inline.h"
>  #include "version.h"
> +#if BUILDING_GCC_VERSION >= 7000
> +#include "memmodel.h"
> +#endif
>  #include "rtl.h"
>  #include "tm_p.h"
>  #include "flags.h"
> @@ -66,6 +69,9 @@
>  #include "tree-flow.h"
>  #else
>  #include "tree-cfgcleanup.h"
> +#if BUILDING_GCC_VERSION >= 7000
> +#include "tree-vrp.h"
> +#endif
>  #include "tree-ssa-operands.h"
>  #include "tree-into-ssa.h"
>  #endif
 
Hi,

Could you please use the upstream gcc-common.h? You can find it here:
https://www.grsecurity.net/~paxguy1/gcc-common.h

Thanks
-- 
Emese
