Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <a0e27065-afec-d82f-c478-1c311adaea3d@marcan.st>
References: <a0e27065-afec-d82f-c478-1c311adaea3d@marcan.st>
From: Kees Cook <keescook@chromium.org>
Date: Sun, 29 May 2016 19:16:54 -0700
Message-ID: <CAGXu5jKqCJB7L+T_ghv=qixt4J_eq4L6+o5MwueTZ8_GVfeDTQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v1 1/3] Add the latent_entropy gcc plugin
To: Hector Martin <marcan@marcan.st>
Cc: Emese Revfy <re.emese@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, May 29, 2016 at 10:59 AM, Hector Martin <marcan@marcan.st> wrote:
> On Mon, May 23, 2016 at 3:15 PM, Emese Revfy <re.emese@gmail.com> wrote:
>> +/*
>> + * Copyright 2012-2016 by the PaX Team <pageexec@freemail.hu>
>> + * Copyright 2016 by Emese Revfy <re.emese@gmail.com>
>> + * Licensed under the GPL v2
>> + *
>> + * Note: the choice of the license means that the compilation process is
>> + *       NOT 'eligible' as defined by gcc's library exception to the GPL v3,
>> + *       but for the kernel it doesn't matter since it doesn't link against
>> + *       any of the gcc libraries
>> + *
>> + * gcc plugin to help generate a little bit of entropy from program state,
>> + * used throughout the uptime of the kernel
>
> The "Note" seems misleading. Since this is a GCC plugin, and directly
> uses GCC's internal interfaces, doesn't that make it a derived work of
> GCC, and thus, require that it be licensed under GPLv3 instead of GPLv2
> (which is incompatible)?
>
> AFAIK this is how the GPLv3 works in this context, and the GCC exception
> doesn't change that because it only applies to libgcc and friends (and
> does not weaken the default effects of the GPL over the rest of GCC). My
> understanding is that the whole "eligible compilation" licensing hack
> was designed to hinder non-linking proprietary compilation passes that
> operate over data files containing an internal GCC representation, but
> plain old loaded plugins still need to be GPLv3 regardless of whether
> you link the end result to libgcc or not.
>
> (Also, don't some arches link against libgcc, further complicating this?
> Trying to use this compiler plugin with those arches would wind up with
> non-redistributable kernels, this time due to the exception.)

IANAL. My interpretation is that plugins can be whatever license they
want to be, and if they declare that they're GPL-compatible (which
GPLv2 is), then the produced output can be under whatever license it
wants. Regardless, things are clearly following the intended purposes:
the plugin is free software, used to help gcc compile free software,
so no weird proprietary source, steps, or outputs, which is what the
gcc folks were trying to make sure continued to happen.

-Kees

-- 
Kees Cook
Chrome OS & Brillo Security
