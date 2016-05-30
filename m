Reply-To: kernel-hardening@lists.openwall.com
References: <a0e27065-afec-d82f-c478-1c311adaea3d@marcan.st>
 <CAGXu5jKqCJB7L+T_ghv=qixt4J_eq4L6+o5MwueTZ8_GVfeDTQ@mail.gmail.com>
From: "Hector Martin \"marcan\"" <marcan@marcan.st>
Message-ID: <727dd7b4-e33f-e53d-f4f9-a6f9c57e2b63@marcan.st>
Date: Mon, 30 May 2016 12:46:04 +0900
MIME-Version: 1.0
In-Reply-To: <CAGXu5jKqCJB7L+T_ghv=qixt4J_eq4L6+o5MwueTZ8_GVfeDTQ@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] Re: [PATCH v1 1/3] Add the latent_entropy gcc plugin
To: Kees Cook <keescook@chromium.org>
Cc: Emese Revfy <re.emese@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>
List-ID: <kernel-hardening.lists.openwall.com>

On 2016-05-30 11:16, Kees Cook wrote:
> On Sun, May 29, 2016 at 10:59 AM, Hector Martin <marcan@marcan.st> wrote:
>> On Mon, May 23, 2016 at 3:15 PM, Emese Revfy <re.emese@gmail.com> wrote:
>>> +/*
>>> + * Copyright 2012-2016 by the PaX Team <pageexec@freemail.hu>
>>> + * Copyright 2016 by Emese Revfy <re.emese@gmail.com>
>>> + * Licensed under the GPL v2
>>> + *
>>> + * Note: the choice of the license means that the compilation process is
>>> + *       NOT 'eligible' as defined by gcc's library exception to the GPL v3,
>>> + *       but for the kernel it doesn't matter since it doesn't link against
>>> + *       any of the gcc libraries
>>> + *
>>> + * gcc plugin to help generate a little bit of entropy from program state,
>>> + * used throughout the uptime of the kernel
>>
>> The "Note" seems misleading. Since this is a GCC plugin, and directly
>> uses GCC's internal interfaces, doesn't that make it a derived work of
>> GCC, and thus, require that it be licensed under GPLv3 instead of GPLv2
>> (which is incompatible)?
>>
>> AFAIK this is how the GPLv3 works in this context, and the GCC exception
>> doesn't change that because it only applies to libgcc and friends (and
>> does not weaken the default effects of the GPL over the rest of GCC). My
>> understanding is that the whole "eligible compilation" licensing hack
>> was designed to hinder non-linking proprietary compilation passes that
>> operate over data files containing an internal GCC representation, but
>> plain old loaded plugins still need to be GPLv3 regardless of whether
>> you link the end result to libgcc or not.
>>
>> (Also, don't some arches link against libgcc, further complicating this?
>> Trying to use this compiler plugin with those arches would wind up with
>> non-redistributable kernels, this time due to the exception.)
> 
> IANAL. My interpretation is that plugins can be whatever license they
> want to be, and if they declare that they're GPL-compatible (which
> GPLv2 is), then the produced output can be under whatever license it
> wants. Regardless, things are clearly following the intended purposes:
> the plugin is free software, used to help gcc compile free software,
> so no weird proprietary source, steps, or outputs, which is what the
> gcc folks were trying to make sure continued to happen.

The first problem isn't the output, it's the plugin itself. The FSF is
clear on their interpretation that plugins need to be licensed under a
compatible license under this kind of scenario:

http://www.gnu.org/licenses/gpl-faq.en.html#GPLAndPlugins

Since the FSF is the copyright owner for GCC, I'd say that makes a
pretty clear case that the plugin needs to be GPLv3 (they don't specify
v2 vs. v3 in that FAQ, but since the licenses are incompatible, GPLv2 is
as good as proprietary in the eyes of GPLv3).

As for the output, unfortunately, GPLv2 is not "GPL-compatible". This is
defined here:

http://www.gnu.org/licenses/gcc-exception-3.1.en.html

> "GPL-compatible Software" is software whose conditions of propagation,
> modification and use would permit combination with GCC in accord with
> the license of GCC.

It's one of those unfortunate cases where a term defined in the legalese
doesn't match the obvious interpretation, but in this context,
"GPL-compatioble" means "GPLv3-compatible", and GPLv2 isn't - so the
plugin combined with GCC does not for an "Eligible Compilation Process",
and that means that if it is used to compile software that links with
libgcc, that software has to be GPLv3-compatible - which the kernel
isn't. AFAICT, that makes any kernels built for arches which link libgcc
and which use this plugin non-redistributable. There is no issue with
the source code form, as the kernel does not explicitly invoke libgcc
interfaces, but the binary would contain a mix of GPLv2-only and
GPLv3-only-exception-does-not-apply code.

IANAL, but regardless of whether this is all free software anyway,
license compliance is important. If all free software were to be treated
equally, we wouldn't have choices like GPLv2 vs GPLv3 vs BSD vs MIT to
begin with.

-- 
Hector Martin "marcan" (marcan@marcan.st)
Public Key: http://www.marcansoft.com/marcan.asc
