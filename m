Reply-To: kernel-hardening@lists.openwall.com
From: Kees Cook <keescook@chromium.org>
Date: Fri,  3 Jun 2016 11:40:22 -0700
Message-Id: <1464979224-2085-1-git-send-email-keescook@chromium.org>
Subject: [kernel-hardening] [PATCH 0/2] expand use of __ro_after_init
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org, x86@kernel.org, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Mathias Krause <minipli@googlemail.com>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

After v4.6 released, a number of people complained that Linux's use of
__ro_after_init was extremely limited, but they did not send patches. In
the interest of showing how to make progress in this area, this is a
set of two patches for x86 and arm, extracted from the grsecurity/PaX
patchset in about an hour. I invite others to continue this work, as it
is relatively easy to accomplish.

Since __ro_after_init doesn't yet support modules (assistence here is
welcome too), markings can only be used on variables that are built
in. And since PaX mixes variables that are read-only after init with
those that are protected with pax_open_kernel() and pax_close_kernel(),
it does take a bit of analysis to make sure the variables aren't used
in those cases.

Thanks,

-Kees
