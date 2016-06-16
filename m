Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <fdee1749f758de33fed9ab8227b6afaa56388b63.1466036668.git.luto@kernel.org>
References: <cover.1466036668.git.luto@kernel.org> <fdee1749f758de33fed9ab8227b6afaa56388b63.1466036668.git.luto@kernel.org>
From: Kees Cook <keescook@chromium.org>
Date: Thu, 16 Jun 2016 10:25:54 -0700
Message-ID: <CAGXu5jJoKZWm_KW6hyMLgaqkTr2oAiuFx2Sm5aCOhnC_GWmLzQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH 06/13] fork: Add generic vmalloced stack support
To: Andy Lutomirski <luto@kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "x86@kernel.org" <x86@kernel.org>, Borislav Petkov <bp@alien8.de>, Nadav Amit <nadav.amit@gmail.com>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Josh Poimboeuf <jpoimboe@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jun 15, 2016 at 5:28 PM, Andy Lutomirski <luto@kernel.org> wrote:
> If CONFIG_VMAP_STACK is selected, kernel stacks are allocated with
> vmalloc_node.
>
> Signed-off-by: Andy Lutomirski <luto@kernel.org>
> ---
>  arch/Kconfig  | 12 ++++++++++++
>  kernel/fork.c | 45 +++++++++++++++++++++++++++++++++++++--------
>  2 files changed, 49 insertions(+), 8 deletions(-)
>
> diff --git a/arch/Kconfig b/arch/Kconfig
> index d794384a0404..1acd262036b0 100644
> --- a/arch/Kconfig
> +++ b/arch/Kconfig
> @@ -658,4 +658,16 @@ config ARCH_NO_COHERENT_DMA_MMAP
>  config CPU_NO_EFFICIENT_FFS
>         def_bool n
>
> +config HAVE_ARCH_VMAP_STACK
> +       def_bool n

In the style of HAVE_ARCH_SECCOMP_FILTER, can you detail all the
things an architecture needs to do to correctly support a vmap stack?
This will help with arch porting.

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
