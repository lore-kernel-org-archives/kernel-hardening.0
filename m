MIME-Version: 1.0
References: <20190221093601.27920-1-ruscur@russell.cc>
In-Reply-To: <20190221093601.27920-1-ruscur@russell.cc>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 21 Feb 2019 08:07:54 -0800
Message-ID: <CAGXu5j+P1wh0uf1kfMywSTo4NYtwFPSnKXg6wbfyBRqwVRZVYA@mail.gmail.com>
Subject: Re: [PATCH 0/7] Kernel Userspace Protection for radix
Content-Type: text/plain; charset="UTF-8"
To: Russell Currey <ruscur@russell.cc>
Cc: PowerPC <linuxppc-dev@lists.ozlabs.org>, Michael Ellerman <mpe@ellerman.id.au>, Nick Piggin <npiggin@gmail.com>, Christophe Leroy <christophe.leroy@c-s.fr>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Feb 21, 2019 at 1:36 AM Russell Currey <ruscur@russell.cc> wrote:
> The first three patches of these series are from Christophe's work and are
> the bare minimum framework needed to implement the support for radix.
>
> In patch 3, I have removed from Christophe's patch my implementation of
> the 64-bit exception handling code, since we don't have an answer for
> making nested exceptions work yet.  This is mentioned in the final KUAP
> patch.  Regardless, this is still a significant security improvement
> and greatly narrows the attack surface.

Nice! Am I understanding correctly that with this series powerpc9 and
later, using radix, will pass the lkdtm tests for KUAP and KUEP (i.e.
EXEC_USERSPACE and ACCESS_USERSPACE)?

-- 
Kees Cook
