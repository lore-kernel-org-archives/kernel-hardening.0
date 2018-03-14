From: Jani Nikula <jani.nikula@linux.intel.com>
Subject: Re: [PATCH] drm/i915: drop various VLAs in i915_debugfs.c
In-Reply-To: <1520970688-19683-1-git-send-email-s.mesoraca16@gmail.com>
References: <1520970688-19683-1-git-send-email-s.mesoraca16@gmail.com>
Date: Wed, 14 Mar 2018 14:17:07 +0200
Message-ID: <87fu52n96k.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
To: Salvatore Mesoraca <s.mesoraca16@gmail.com>, linux-kernel@vger.kernel.org
Cc: dri-devel@lists.freedesktop.org, intel-gfx@lists.freedesktop.org, kernel-hardening@lists.openwall.com, David Airlie <airlied@linux.ie>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Kees Cook <keescook@chromium.org>, Rodrigo Vivi <rodrigo.vivi@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, 13 Mar 2018, Salvatore Mesoraca <s.mesoraca16@gmail.com> wrote:
> Avoid 3 VLAs[1] by using real constant expressions instead of variables.
> The compiler should be able to optimize the original code and avoid using
> any actual VLAs. Anyway this change is useful because it will avoid a false
> positives with -Wvla, it might also help the compiler generating better
> code.

Thanks for your patch. However, Chris beat you to it with:

7aa0b14ede64 ("drm/i915: Remove variable length arrays from sseu debugfs
printers")

as well as adding -Wvla to our subdir-ccflags-y to prevent more from
cropping up:

c5c2b11894f4 ("drm/i915: Warn against variable length arrays")


BR,
Jani.


-- 
Jani Nikula, Intel Open Source Technology Center
