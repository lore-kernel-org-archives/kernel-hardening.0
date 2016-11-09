Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20161102065241.985-1-andrew.donnellan@au1.ibm.com>
References: <20161102065241.985-1-andrew.donnellan@au1.ibm.com>
From: Kees Cook <keescook@chromium.org>
Date: Tue, 8 Nov 2016 16:16:51 -0800
Message-ID: <CAGXu5jJK37NEW0nR_JTs77pXdUbszuKo+mG+DyTCKftiZEKBTA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] MAINTAINERS: add GCC plugins Makefile
To: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, linux-kbuild <linux-kbuild@vger.kernel.org>, Emese Revfy <re.emese@gmail.com>, Michal Marek <mmarek@suse.com>, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Nov 1, 2016 at 11:52 PM, Andrew Donnellan
<andrew.donnellan@au1.ibm.com> wrote:
> Signed-off-by: Andrew Donnellan <andrew.donnellan@au1.ibm.com>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 4012c2f..76049e0 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -5202,6 +5202,7 @@ L:        kernel-hardening@lists.openwall.com
>  S:     Maintained
>  F:     scripts/gcc-plugins/
>  F:     scripts/gcc-plugin.sh
> +F:     scripts/Makefile.gcc-plugins
>  F:     Documentation/gcc-plugins.txt
>
>  GCOV BASED KERNEL PROFILING

Ah, good call. I've added this for -next now. Thanks!

-Kees

-- 
Kees Cook
Nexus Security
