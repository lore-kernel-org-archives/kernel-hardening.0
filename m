Reply-To: kernel-hardening@lists.openwall.com
References: <a0e27065-afec-d82f-c478-1c311adaea3d@marcan.st>
 <CAGXu5jKqCJB7L+T_ghv=qixt4J_eq4L6+o5MwueTZ8_GVfeDTQ@mail.gmail.com>
 <727dd7b4-e33f-e53d-f4f9-a6f9c57e2b63@marcan.st>
 <CAGXu5jLv8J0+nizD8zjWScpF_SJmuBg+-z9hpE7HiP0sD2B+Vg@mail.gmail.com>
From: "Hector Martin \"marcan\"" <marcan@marcan.st>
Message-ID: <4eae2961-e625-e249-868c-7ccd3ad1f8d0@marcan.st>
Date: Tue, 31 May 2016 05:24:57 +0900
MIME-Version: 1.0
In-Reply-To: <CAGXu5jLv8J0+nizD8zjWScpF_SJmuBg+-z9hpE7HiP0sD2B+Vg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] Re: [PATCH v1 1/3] Add the latent_entropy gcc plugin
To: Kees Cook <keescook@chromium.org>
Cc: Emese Revfy <re.emese@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, LKML <linux-kernel@vger.kernel.org>, Brad Spengler <spender@grsecurity.net>, PaX Team <pageexec@freemail.hu>
List-ID: <kernel-hardening.lists.openwall.com>

On 2016-05-31 00:40, Kees Cook wrote:
> On Sun, May 29, 2016 at 8:46 PM, Hector Martin "marcan"
> <marcan@marcan.st> wrote:
>> On 2016-05-30 11:16, Kees Cook wrote:
>>> On Sun, May 29, 2016 at 10:59 AM, Hector Martin <marcan@marcan.st> wrote:
>>>> On Mon, May 23, 2016 at 3:15 PM, Emese Revfy <re.emese@gmail.com> wrote:
>>>>> +/*
>>>>> + * Copyright 2012-2016 by the PaX Team <pageexec@freemail.hu>
>>>>> + * Copyright 2016 by Emese Revfy <re.emese@gmail.com>
>>>>> + * Licensed under the GPL v2
>>>>> + *
>>>>> + * Note: the choice of the license means that the compilation process is
>>>>> + *       NOT 'eligible' as defined by gcc's library exception to the GPL v3,
>>>>> + *       but for the kernel it doesn't matter since it doesn't link against
>>>>> + *       any of the gcc libraries
>>>>> + *
>>>>> + * gcc plugin to help generate a little bit of entropy from program state,
>>>>> + * used throughout the uptime of the kernel
>>>>
>>>> The "Note" seems misleading. Since this is a GCC plugin, and directly
>>>> uses GCC's internal interfaces, doesn't that make it a derived work of
>>>> GCC, and thus, require that it be licensed under GPLv3 instead of GPLv2
>>>> (which is incompatible)?
>>>>
>>>> AFAIK this is how the GPLv3 works in this context, and the GCC exception
>>>> doesn't change that because it only applies to libgcc and friends (and
>>>> does not weaken the default effects of the GPL over the rest of GCC). My
>>>> understanding is that the whole "eligible compilation" licensing hack
>>>> was designed to hinder non-linking proprietary compilation passes that
>>>> operate over data files containing an internal GCC representation, but
>>>> plain old loaded plugins still need to be GPLv3 regardless of whether
>>>> you link the end result to libgcc or not.
>>>>
>>>> (Also, don't some arches link against libgcc, further complicating this?
>>>> Trying to use this compiler plugin with those arches would wind up with
>>>> non-redistributable kernels, this time due to the exception.)
>>>
>>> IANAL. My interpretation is that plugins can be whatever license they
>>> want to be, and if they declare that they're GPL-compatible (which
>>> GPLv2 is), then the produced output can be under whatever license it
>>> wants. Regardless, things are clearly following the intended purposes:
>>> the plugin is free software, used to help gcc compile free software,
>>> so no weird proprietary source, steps, or outputs, which is what the
>>> gcc folks were trying to make sure continued to happen.
>>
>> The first problem isn't the output, it's the plugin itself. The FSF is
>> clear on their interpretation that plugins need to be licensed under a
>> compatible license under this kind of scenario:
>>
>> http://www.gnu.org/licenses/gpl-faq.en.html#GPLAndPlugins
>>
>> Since the FSF is the copyright owner for GCC, I'd say that makes a
>> pretty clear case that the plugin needs to be GPLv3 (they don't specify
>> v2 vs. v3 in that FAQ, but since the licenses are incompatible, GPLv2 is
>> as good as proprietary in the eyes of GPLv3).
> 
> "If the program dynamically links plug-ins, and they make function
> calls to each other and share data structures, we believe they form a
> single program, which must be treated as an extension of both the main
> program and the plug-ins. This means you must license the plug-in
> under the GPL or a GPL-compatible free software license and distribute
> it with source code in a GPL-compliant way."
> 
> I would point out "we believe" followed up with "GPL-compatible" (not
> GPLv3-compatible, and the FAQ does distinguish between them in other
> places). And in
> http://www.gnu.org/licenses/gpl-faq.html#WhatDoesCompatMean they
> appear to be all-inclusive about GPL versions.

That GPLv2 and GPLv3 are not compatible is pretty well established:
http://www.gnu.org/licenses/gpl-faq.en.html#v2v3Compatibility

Ultimately, though, the license is what matters. And the GPLv3 license
is pretty clear:

> For example, Corresponding Source includes interface definition files
> associated with source files for the work

Thus, GCC internal interfaces are covered by the GPLv3.

> To “modify” a work means to copy from or adapt all or part of the work
> in a fashion requiring copyright permission, other than the making of an
> exact copy. The resulting work is called a “modified version” of the
> earlier work or a work “based on” the earlier work.

As the plugin uses those interfaces, it is "based on" GCC.

> You may convey a work based on the Program, or the modifications to
> produce it from the Program, in the form of source code under the terms
> of section 4, provided that you also meet all of these conditions:

> b) The work must carry prominent notices stating that it is released
> under this License and any conditions added under section 7. 

And, thus, it has to be released under GPLv3.

> Dynamic linking license requirements are a legal unknown. See
> "Derivative work: yes or no?" in https://lwn.net/Articles/548216/

The only thing subject to interpretation here is whether plug-ins
sharing internal data structures really count as derivative works; the
FAQ that I linked above makes it clear that the FSF thinks they do. Now,
some people may think otherwise; that would be something that would have
to be tested in court, but either way, not complying with that would be
going against the FSF's wishes.

Keep in mind that usage of the GCC plugin interface is one of the
strongest cases for being a derivative work; it's not a mere import of a
dynamic library without sharing symbols, it's not a standardized
interface. In fact it hooks quite deeply into GCC internals, and deals
pretty exclusively in concepts that are fundamental to the design and
implementation of GCC. This goes beyond "by linking you create a
derivative work" - there's a strong argument that the source code for
the plugin, itself, is a derivative work already. The FSF has been quite
protective about this and vocal about not wanting license-incompatible
plugins (and various workarounds for such).

> In the cases of these unclear interpretations, I always fall back to
> the spirit or intent of the licensing: GPL wants things to be
> copyleft. Are these plugins copyleft? Yes, done.

If only the GPL were that simple :-)

>> As for the output, unfortunately, GPLv2 is not "GPL-compatible". This is
>> defined here:
>>
>> http://www.gnu.org/licenses/gcc-exception-3.1.en.html
>>
>>> "GPL-compatible Software" is software whose conditions of propagation,
>>> modification and use would permit combination with GCC in accord with
>>> the license of GCC.
>>
>> It's one of those unfortunate cases where a term defined in the legalese
>> doesn't match the obvious interpretation, but in this context,
>> "GPL-compatioble" means "GPLv3-compatible", and GPLv2 isn't - so the
>> plugin combined with GCC does not for an "Eligible Compilation Process",
>> and that means that if it is used to compile software that links with
>> libgcc, that software has to be GPLv3-compatible - which the kernel
>> isn't. AFAICT, that makes any kernels built for arches which link libgcc
>> and which use this plugin non-redistributable.
> 
> If this interpretation is true, then you can take it up with the tile
> arch maintainers once they add the plugin support. :) (This appears to
> be the only arch that uses libgcc.)

AFAICT all of
arch/{arc,cris,hexagon,m32r,nios2,openrisc,parisc,tile,xtensa}/Makefile
link against libgcc.

FWIW I don't think there's really anything left to interpretation; that
license exception wording is pretty damn explicit.

>> There is no issue with
>> the source code form, as the kernel does not explicitly invoke libgcc
>> interfaces, but the binary would contain a mix of GPLv2-only and
>> GPLv3-only-exception-does-not-apply code.
>>
>> IANAL, but regardless of whether this is all free software anyway,
>> license compliance is important. If all free software were to be treated
>> equally, we wouldn't have choices like GPLv2 vs GPLv3 vs BSD vs MIT to
>> begin with.
> 
> I don't think we'll convince each other of our respective opinions,
> but as I said, when there are unknowns or confusions, the best thing
> to do is to look at the intent. The licensing on gcc plugins appears
> to me to be about preserving copyleft integrity of the entire stack,
> which, while "only" GPLv2, is true for this situation.

That's a simple way to look at it, but think about it this way: if GPLv2
were already the ultimate copyleft license (in the FSF's view), there
would be no GPLv3. By writing GPLv3 and switching GCC to it, the FSF is
clearly making a decision that they would like people to abide by the
terms of the GPLv3. Releasing a plugin, which is arguably a derivative
work, under the GPLv2 "rolls back" the FSF's decision to switch to
GPLv3. Sure, it's all free software, but the details matter.

Then there is the other side: is there are reason not to just make the
plugin v2v3? That would certainly remove all doubt and potential issues,
and complies with both GCC's license and the kernel's.

-- 
Hector Martin "marcan" (marcan@marcan.st)
Public Key: http://www.marcansoft.com/marcan.asc
