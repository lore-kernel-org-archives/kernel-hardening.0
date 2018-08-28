MIME-Version: 1.0
References: <20180827185631.163506-1-jannh@google.com> <20180827185631.163506-7-jannh@google.com>
In-Reply-To: <20180827185631.163506-7-jannh@google.com>
From: Jann Horn <jannh@google.com>
Date: Tue, 28 Aug 2018 02:51:10 +0200
Message-ID: <CAG48ez2ScPzTM-0JOmops7ae6zotF=sYbP5hDZHJ=0=EuzQk8w@mail.gmail.com>
Subject: Re: [PATCH v2 6/7] x86: BUG() when uaccess helpers fault on kernel addresses
Content-Type: text/plain; charset="UTF-8"
To: Kees Cook <keescook@chromium.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, the arch/x86 maintainers <x86@kernel.org>, Andy Lutomirski <luto@kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, tony.luck@intel.com, Borislav Petkov <bp@alien8.de>
Cc: kernel list <linux-kernel@vger.kernel.org>, Dmitry Vyukov <dvyukov@google.com>, linux-edac@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Aug 27, 2018 at 8:58 PM Jann Horn <jannh@google.com> wrote:
>
> There have been multiple kernel vulnerabilities that permitted userspace to
> pass completely unchecked pointers through to userspace accessors:
>
>  - the waitid() bug - commit 96ca579a1ecc ("waitid(): Add missing
>    access_ok() checks")
>  - the sg/bsg read/write APIs
>  - the infiniband read/write APIs
>
> These don't happen all that often, but when they do happen, it is hard to
> test for them properly; and it is probably also hard to discover them with
> fuzzing. Even when an unmapped kernel address is supplied to such buggy
> code, it just returns -EFAULT instead of doing a proper BUG() or at least
> WARN().
>
> This patch attempts to make such misbehaving code a bit more visible by
> refusing to do a fixup in the pagefault handler code when a userspace
> accessor causes #PF on a kernel address and the current context isn't
> whitelisted.

Kees noticed that when you have vmapped stacks on (I was testing with
KASAN, so I couldn't enable vmapped stacks), exact_copy_from_user() in
copy_mount_options() is incompatible with this patch when used on
kernel pointers. do_mount_root() and devtmpfsd() call kys_mount() with
kernel pointers. So I'll have to either add that to the whitelist
and/or refactor the mount options copy logic first (so that it uses
strncpy_from_user() as long as the data argument isn't binary data).

I've wanted to fiddle with that code anyway - silent truncation at
0xfff bytes isn't very robust, especially when suid binaries call
sys_mount() with a partly user-controlled options string...
