MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <20156f2a-6171-6a90-d4bc-f384f9c9247a@embeddedor.com>
References: <b1ddb305-bffd-0bbe-e38d-8213bbb1f9ee@embeddedor.com>
 <CAJcbSZEWZm3umjDF8wvnbih-nkwoBH4hQkFmnbAhHbREnBPYew@mail.gmail.com>
 <992b014d-3421-c9f8-33bf-334e06a58ca2@embeddedor.com> <CAGXu5jJfwmqifHkyminEKNOcmeC8_5x0dVajD+bSgQmUSG3WyA@mail.gmail.com>
 <20156f2a-6171-6a90-d4bc-f384f9c9247a@embeddedor.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 7 Aug 2017 17:01:14 -0700
Message-ID: <CAGXu5jK7Cz0P3wNPypR+ejfWG+FtQbCdBm2zx_DCXwJzmVx8aQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: Re: [kernel-hardening] I want to help out
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: Thomas Garnier <thgarnie@google.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 7, 2017 at 4:35 PM, Gustavo A. R. Silva
<gustavo@embeddedor.com> wrote:
> Yeah, this has to do with the use __ro_after_init for the case of .ctors
> (.init_array) ELF section.
>
> The case of .dtors or .fini_array ELF section is similar. A heap overflow
> could overwrite a .fini_array function pointer. But I guess this could be
> detected by guard pages.

Oh, hm, I would have expected all of those to be entirely read-only
already. How does the kernel use those dynamically?


> So, I guess the idea would be to follow this same approach:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=e37e43a497d5a8b7c0cc1736d56986f432c394c9
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=13d4ea097d18b419ad2a2b696063d44bf59acec0
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=c65eacbe290b8141554c71b2c94489e73ade8c8d
>
> right?

As far as I know, yes.

> What would be a good strategy to start tackling those tasks?

I suspect the arm64 folks here may have suggestions about how to do
either on arm. I would expect moving addr_limit off the stack to
mainly be moving the structure and dealing with the header fallout and
syscall entry/exit assembly. For VMAP_STACK, I think there is a lot of
other work to handle faults correctly.

-Kees

-- 
Kees Cook
Pixel Security
