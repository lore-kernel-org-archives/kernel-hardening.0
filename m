Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
From: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
In-Reply-To: <1520970688-19683-1-git-send-email-s.mesoraca16@gmail.com>
References: <1520970688-19683-1-git-send-email-s.mesoraca16@gmail.com>
Message-ID: <152103045697.8738.16803220270496592360@jlahtine-desk.ger.corp.intel.com>
Subject: Re: [PATCH] drm/i915: drop various VLAs in i915_debugfs.c
Date: Wed, 14 Mar 2018 14:27:37 +0200
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>, linux-kernel@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, kernel-hardening@lists.openwall.com, David Airlie <airlied@linux.ie>, Jani Nikula <jani.nikula@linux.intel.com>, Kees Cook <keescook@chromium.org>, Rodrigo Vivi <rodrigo.vivi@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

Quoting Salvatore Mesoraca (2018-03-13 21:51:28)
> Avoid 3 VLAs[1] by using real constant expressions instead of variables.
> The compiler should be able to optimize the original code and avoid using
> any actual VLAs. Anyway this change is useful because it will avoid a fal=
se
> positives with -Wvla, it might also help the compiler generating better
> code.
> =

> [1] https://lkml.org/lkml/2018/3/7/621
> =

> Signed-off-by: Salvatore Mesoraca <s.mesoraca16@gmail.com>
> ---
>  drivers/gpu/drm/i915/i915_debugfs.c | 26 ++++++++++++++++----------
>  1 file changed, 16 insertions(+), 10 deletions(-)
> =

> diff --git a/drivers/gpu/drm/i915/i915_debugfs.c b/drivers/gpu/drm/i915/i=
915_debugfs.c
> index e968aea..bf0a8e3 100644
> --- a/drivers/gpu/drm/i915/i915_debugfs.c
> +++ b/drivers/gpu/drm/i915/i915_debugfs.c
> @@ -4259,19 +4259,20 @@ static ssize_t cur_wm_latency_write(struct file *=
file, const char __user *ubuf,
>                         i915_cache_sharing_get, i915_cache_sharing_set,
>                         "%llu\n");
>  =

> +#define CHERRYVIEW_SS_MAX 2

CHV_SS_MAX should be good enough. Make these function scoped (so #define
at the beginning and #undef at the end of function).

Do use ARRAY_SIZE() instead of repeating.

Regards, Joonas
