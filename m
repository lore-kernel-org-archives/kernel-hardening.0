MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1500480092-28480-2-git-send-email-mark.rutland@arm.com>
References: <1500480092-28480-1-git-send-email-mark.rutland@arm.com> <1500480092-28480-2-git-send-email-mark.rutland@arm.com>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 3 Aug 2017 10:57:08 -0700
Message-ID: <CAGXu5jJnhy5F698QFmXrMb3szmtXnfzqc+=QsukG4+p2k9xEdg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH 01/11] arm64: docs: describe ELF hwcaps
To: Mark Rutland <mark.rutland@arm.com>
Cc: "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, Arnd Bergmann <arnd@arndb.de>, Catalin Marinas <catalin.marinas@arm.com>, Christoffer Dall <christoffer.dall@linaro.org>, Dave Martin <Dave.Martin@arm.com>, jiong.wang@arm.com, kvmarm@lists.cs.columbia.edu, linux-arch <linux-arch@vger.kernel.org>, Marc Zyngier <marc.zyngier@arm.com>, "Suzuki K. Poulose" <suzuki.poulose@arm.com>, Will Deacon <will.deacon@arm.com>, yao.qi@arm.com, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jul 19, 2017 at 9:01 AM, Mark Rutland <mark.rutland@arm.com> wrote:
> We don't document our ELF hwcaps, leaving developers to interpret them
> according to hearsay, guesswork, or (in exceptional cases) inspection of
> the current kernel code.
>
> This is less than optimal, and it would be far better if we had some
> definitive description of each of the ELF hwcaps that developers could
> refer to.
>
> This patch adds a document describing the (native) arm64 ELF hwcaps.
>
> Signed-off-by: Mark Rutland <mark.rutland@arm.com>
> Cc: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Dave Martin <Dave.Martin@arm.com>
> Cc: Suzuki K Poulose <suzuki.poulose@arm.com>
> Cc: Will Deacon <will.deacon@arm.com>
> ---
>  Documentation/arm64/elf_hwcaps.txt | 133 +++++++++++++++++++++++++++++++++++++

With the kernel docs moving to ReST markup[1], perhaps reformat this
to a .rst file and link to it from somewhere sensible in the ReST
tree, perhaps the userspace API section in
Documentation/userspace-api/index.rst?

-Kees

[1] https://www.kernel.org/doc/html/latest/doc-guide/sphinx.html

-- 
Kees Cook
Pixel Security
