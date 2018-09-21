MIME-Version: 1.0
In-Reply-To: <1536874298-23492-2-git-send-email-rick.p.edgecombe@intel.com>
References: <1536874298-23492-1-git-send-email-rick.p.edgecombe@intel.com> <1536874298-23492-2-git-send-email-rick.p.edgecombe@intel.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 21 Sep 2018 11:46:39 -0700
Message-ID: <CAGXu5jKTiPioDjC7rrjN+fG=ZK8mdQ542GwEJW6Fa7GUA8x2uQ@mail.gmail.com>
Subject: Re: [PATCH v6 1/4] vmalloc: Add __vmalloc_node_try_addr function
Content-Type: text/plain; charset="UTF-8"
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Daniel Borkmann <daniel@iogearbox.net>, Jann Horn <jannh@google.com>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, Kristen Carlson Accardi <kristen@linux.intel.com>, Dave Hansen <dave.hansen@intel.com>, Arjan van de Ven <arjan@linux.intel.com>, Matthew Wilcox <willy@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Sep 13, 2018 at 2:31 PM, Rick Edgecombe
<rick.p.edgecombe@intel.com> wrote:
> Create __vmalloc_node_try_addr function that tries to allocate at a specific
> address and supports caller specified behavior for whether any lazy purging
> happens if there is a collision.
>
> This new function draws from the __vmalloc_node_range implementation. Attempts
> to merge the two into a single allocator resulted in logic that was difficult
> to follow, so they are left separate.
>
> Signed-off-by: Rick Edgecombe <rick.p.edgecombe@intel.com>

Reviewed-by: Kees Cook <keescook@chromium.org>

I'd love to get some more mm folks to look this over too.

-Kees

-- 
Kees Cook
Pixel Security
