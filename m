MIME-Version: 1.0
References: <cover.1549927666.git.igor.stoppa@huawei.com>
In-Reply-To: <cover.1549927666.git.igor.stoppa@huawei.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 11 Feb 2019 16:09:10 -0800
Message-ID: <CAGXu5j+n3ky2dOe4F+VyneQsM4VJbGPUw+DO55NkxxPhKzKHag@mail.gmail.com>
Subject: Re: [RFC PATCH v4 00/12] hardening: statically allocated protected memory
Content-Type: text/plain; charset="UTF-8"
To: Igor Stoppa <igor.stoppa@gmail.com>
Cc: Igor Stoppa <igor.stoppa@huawei.com>, Ahmed Soliman <ahmedsoliman@mena.vt.edu>, linux-integrity <linux-integrity@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Linux-MM <linux-mm@kvack.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Feb 11, 2019 at 3:28 PM Igor Stoppa <igor.stoppa@gmail.com> wrote:
> at last I'm able to resume work on the memory protection patchset I've
> proposed some time ago. This version should address comments received so
> far and introduce support for arm64. Details below.

Cool!

> Patch-set implementing write-rare memory protection for statically
> allocated data.

It seems like this could be expanded in the future to cover dynamic
memory too (i.e. just a separate base range in the mm).

> Its purpose is to keep write protected the kernel data which is seldom
> modified, especially if altering it can be exploited during an attack.
>
> There is no read overhead, however writing requires special operations that
> are probably unsuitable for often-changing data.
> The use is opt-in, by applying the modifier __wr_after_init to a variable
> declaration.
>
> As the name implies, the write protection kicks in only after init() is
> completed; before that moment, the data is modifiable in the usual way.
>
> Current Limitations:
> * supports only data which is allocated statically, at build time.
> * supports only x86_64 and arm64;other architectures need to provide own
>   backend

It looked like only the memset() needed architecture support. Is there
a reason for not being able to implement memset() in terms of an
inefficient put_user() loop instead? That would eliminate the need for
per-arch support, yes?

> - I've added a simple example: the protection of ima_policy_flags

You'd also looked at SELinux too, yes? What other things could be
targeted for protection? (It seems we can't yet protect page tables
themselves with this...)

> - the x86_64 user space address range is double the size of the kernel
>   address space, so it's possible to randomize the beginning of the
>   mapping of the kernel address space, but on arm64 they have the same
>   size, so it's not possible to do the same

Only the wr_rare section needs mapping, though, yes?

> - I'm not sure if it's correct, since it doesn't seem to be that common in
>   kernel sources, but instead of using #defines for overriding default
>   function calls, I'm using "weak" for the default functions.

The tradition is to use #defines for easier readability, but "weak"
continues to be a thing. *shrug*

This will be a nice addition to protect more of the kernel's static
data from write-what-where attacks. :)

-- 
Kees Cook
