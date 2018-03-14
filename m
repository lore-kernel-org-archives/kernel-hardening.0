MIME-Version: 1.0
In-Reply-To: <152103045697.8738.16803220270496592360@jlahtine-desk.ger.corp.intel.com>
References: <1520970688-19683-1-git-send-email-s.mesoraca16@gmail.com> <152103045697.8738.16803220270496592360@jlahtine-desk.ger.corp.intel.com>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Wed, 14 Mar 2018 13:43:52 +0100
Message-ID: <CAJHCu1LburVFrSX3uUhpRwSnYp-=Hm+KW-Vg_NOZG_Z5y4KmqA@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: drop various VLAs in i915_debugfs.c
Content-Type: text/plain; charset="UTF-8"
To: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, David Airlie <airlied@linux.ie>, Jani Nikula <jani.nikula@linux.intel.com>, Kees Cook <keescook@chromium.org>, Rodrigo Vivi <rodrigo.vivi@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

2018-03-14 13:27 GMT+01:00 Joonas Lahtinen <joonas.lahtinen@linux.intel.com>:
> CHV_SS_MAX should be good enough. Make these function scoped (so #define
> at the beginning and #undef at the end of function).
>
> Do use ARRAY_SIZE() instead of repeating.

Thank you very much for your suggestions.
Unfortunately, it seems that someone else already fixed this issue, so
I'll just drop this patch.
Best regards,

Salvatore
