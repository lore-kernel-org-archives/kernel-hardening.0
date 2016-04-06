Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <1459947782-5071-1-git-send-email-ed@abdsec.com>
References: <1459947782-5071-1-git-send-email-ed@abdsec.com>
Date: Wed, 6 Apr 2016 11:03:17 -0700
Message-ID: <CAGXu5jLD44hpxYLCfAkg8SkS9v2euoVY1o-qp9XLVkz95hfGWg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] KERNEL: resource: Fix bug on leakage in /proc/iomem file
To: Emrah Demir <ed@abdsec.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Dan Rosenberg <dan.j.rosenberg@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Dave Jones <davej@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Apr 6, 2016 at 6:03 AM, Emrah Demir <ed@abdsec.com> wrote:
> From: Emrah Demir <ed@abdsec.com>

Hi!

Thanks for sending this patch; I'm always glad to see new faces
helping. :) I have a few comments inline and a larger suggestion at
the end.

> Even though KASLR is aiming to mitigate remote attacks, with a simple LFI vulnerability through a web application, local leaks become as important as remote ones.

Be sure to 80-char wrap your commit logs (and code), as it makes
reading it easier. Running your patch through scripts/checkpatch.pl
would remind you:

WARNING: Possible unwrapped commit description (prefer a maximum 75
chars per line)
#5:
Even though KASLR is aiming to mitigate remote attacks, with a simple
LFI vulnerability through a web application, local leaks become as
important as remote ones.

> On the KASLR enabled systems in order to achieve expected protection, some files are needed to edited/modified to prevent leaks.
>
> /proc/iomem file leaks offset of text section. By adding 0x80000000, Attackers can get _text base address. KASLR will be bypassed.

Luckily, this will become less of a problem once the x86 virtual
memory randomization code lands, but I think there's enough in this
file that it should be protected.

>
> $ cat /proc/iomem | grep 'Kernel code'
> 38600000-38b7fe92 : Kernel code
> $ python -c 'print hex(0x38600000 + 0x80000000)'
> 0xb8600000
> # cat /proc/kallsyms | grep 'T _text'
> ffffffffb8600000 T _text
>
> By this patch after insertion resources, start and end address are zeroed. /proc/iomem and /proc/ioports sources, which use request_resource and insert_resource now shown as 0 value.
>
> Signed-off-by: Emrah Demir <ed@abdsec.com>
> ---
>  kernel/resource.c | 4 ++++
>  1 file changed, 4 insertions(+)
>
> diff --git a/kernel/resource.c b/kernel/resource.c
> index 2e78ead..5b9937e 100644
> --- a/kernel/resource.c
> +++ b/kernel/resource.c
> @@ -321,6 +321,8 @@ int request_resource(struct resource *root, struct resource *new)
>         struct resource *conflict;
>
>         conflict = request_resource_conflict(root, new);
> +       new->start = 0;
> +       new->end = 0;
>         return conflict ? -EBUSY : 0;
>  }
>
> @@ -864,6 +866,8 @@ int insert_resource(struct resource *parent, struct resource *new)
>         struct resource *conflict;
>
>         conflict = insert_resource_conflict(parent, new);
> +       new->start = 0;
> +       new->end = 0;
>         return conflict ? -EBUSY : 0;
>  }
>  EXPORT_SYMBOL_GPL(insert_resource);

This entirely eliminates the reporting, which I don't think is a good
idea as developers and debuggers would like to be able to see this
information. I would prefer that either /proc/iomem be unreadable to
non-root users or that the values be reported using %pK to let the
kptr_restrict control the output.

diff --git a/kernel/resource.c b/kernel/resource.c
index 2e78ead30934..8d5dd1dc9489 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -162,8 +162,8 @@ static const struct file_operations
proc_iomem_operations = {

 static int __init ioresources_init(void)
 {
-       proc_create("ioports", 0, NULL, &proc_ioports_operations);
-       proc_create("iomem", 0, NULL, &proc_iomem_operations);
+       proc_create("ioports", S_IRUSR, NULL, &proc_ioports_operations);
+       proc_create("iomem", S_IRUSR, NULL, &proc_iomem_operations);
        return 0;
 }
 __initcall(ioresources_init);

And if this breaks things, make the S_IRUSR conditional on the
CONFIG_RANDOMIZE_BASE?

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
