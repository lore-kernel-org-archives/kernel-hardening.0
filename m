MIME-Version: 1.0
In-Reply-To: <1536874298-23492-1-git-send-email-rick.p.edgecombe@intel.com>
References: <1536874298-23492-1-git-send-email-rick.p.edgecombe@intel.com>
From: Kees Cook <keescook@chromium.org>
Date: Fri, 21 Sep 2018 12:05:55 -0700
Message-ID: <CAGXu5jKpwGHRJ92q7yCc+y8esdG6orFVOiZGoGMCi1XiY0JBoQ@mail.gmail.com>
Subject: Re: [PATCH v6 0/4] KASLR feature to randomize each loadable module
Content-Type: text/plain; charset="UTF-8"
To: Rick Edgecombe <rick.p.edgecombe@intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>, X86 ML <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Daniel Borkmann <daniel@iogearbox.net>, Jann Horn <jannh@google.com>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, Kristen Carlson Accardi <kristen@linux.intel.com>, Dave Hansen <dave.hansen@intel.com>, Arjan van de Ven <arjan@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Sep 13, 2018 at 2:31 PM, Rick Edgecombe
<rick.p.edgecombe@intel.com> wrote:
> This is V6 of the "KASLR feature to randomize each loadable module" patchset.
> The purpose is to increase the randomization and also to make the modules
> randomized in relation to each other instead of just the base, so that if one
> module leaks the location of the others can't be inferred.

I'm excited for this! :)

> Rick Edgecombe (4):
>   vmalloc: Add __vmalloc_node_try_addr function
>   x86/modules: Increase randomization for modules
>   vmalloc: Add debugfs modfraginfo
>   Kselftest for module text allocation benchmarking

Yay for self-tests! This is much appreciated.

-Kees

-- 
Kees Cook
Pixel Security
