MIME-Version: 1.0
In-Reply-To: <87fu52n96k.fsf@intel.com>
References: <1520970688-19683-1-git-send-email-s.mesoraca16@gmail.com> <87fu52n96k.fsf@intel.com>
From: Salvatore Mesoraca <s.mesoraca16@gmail.com>
Date: Wed, 14 Mar 2018 13:41:59 +0100
Message-ID: <CAJHCu1+OSs2h77sYFVGH=PRGpSxYY70nXcna1hDT6eUYzTkrEw@mail.gmail.com>
Subject: Re: [PATCH] drm/i915: drop various VLAs in i915_debugfs.c
Content-Type: text/plain; charset="UTF-8"
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, Kernel Hardening <kernel-hardening@lists.openwall.com>, David Airlie <airlied@linux.ie>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Kees Cook <keescook@chromium.org>, Rodrigo Vivi <rodrigo.vivi@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

2018-03-14 13:17 GMT+01:00 Jani Nikula <jani.nikula@linux.intel.com>:
> Thanks for your patch. However, Chris beat you to it with:
>
> 7aa0b14ede64 ("drm/i915: Remove variable length arrays from sseu debugfs
> printers")

I didn't notice it :)

> as well as adding -Wvla to our subdir-ccflags-y to prevent more from
> cropping up:
>
> c5c2b11894f4 ("drm/i915: Warn against variable length arrays")

Great!
Best regards,

Salvatore
