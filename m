Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20160626173643.c05fd4d559ee9214ad1253c6@gmail.com>
References: <20160626173643.c05fd4d559ee9214ad1253c6@gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 6 Jul 2016 14:55:47 -0400
Message-ID: <CAGXu5jLGEo-5WbOwbxSTubU6zq==adVcwVt1_g8CrRkrUHw4jw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] Automate make rule generation for gcc plugin objects
To: Emese Revfy <re.emese@gmail.com>
Cc: Michal Marek <mmarek@suse.com>, linux-kbuild <linux-kbuild@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, PaX Team <pageexec@freemail.hu>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jun 26, 2016 at 11:36 AM, Emese Revfy <re.emese@gmail.com> wrote:
>
> Reported-by: PaX Team <pageexec@freemail.hu>
> Signed-off-by: Emese Revfy <re.emese@gmail.com>

I've added a commit message body and applied this to my tree.

-Kees

> ---
>  scripts/gcc-plugins/Makefile | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/scripts/gcc-plugins/Makefile b/scripts/gcc-plugins/Makefile
> index a3f8ca4a..898449d 100644
> --- a/scripts/gcc-plugins/Makefile
> +++ b/scripts/gcc-plugins/Makefile
> @@ -20,9 +20,6 @@ endif
>
>  $(HOSTLIBS)-y := $(GCC_PLUGIN)
>  always := $($(HOSTLIBS)-y)
> -
> -cyc_complexity_plugin-objs := cyc_complexity_plugin.o
> -sancov_plugin-objs := sancov_plugin.o
> -latent_entropy_plugin-objs := latent_entropy_plugin.o
> +$(foreach p,$($(HOSTLIBS)-y:%.so=%),$(eval $(p)-objs := $(p).o))
>
>  clean-files += *.so
> --
> 2.8.1



-- 
Kees Cook
Chrome OS & Brillo Security
