Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAKv+Gu9hWvAjckVjEHwNqTeRQgA-5YUatgAZXM-TtTVi6t4yng@mail.gmail.com>
References: <CAKv+Gu_7AdRk7O-Mt8oS=t6prJY56=nS5CS1stgfqHzJ--YD9Q@mail.gmail.com>
 <CAGXu5j+FjPie_mfVhyPa77BrOf+XkAfkZgc+T3RNjecTLH6w2Q@mail.gmail.com> <CAKv+Gu9hWvAjckVjEHwNqTeRQgA-5YUatgAZXM-TtTVi6t4yng@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Mon, 10 Oct 2016 15:17:30 -0700
Message-ID: <CAGXu5jJaAsED5=YX7RWtkHc8b219MEZ_7doohLUDics5nZY3ag@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] initcall randomization
To: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
Cc: Laura Abbott <labbott@fedoraproject.org>, Mark Rutland <mark.rutland@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 5, 2016 at 2:45 PM, Ard Biesheuvel
<ard.biesheuvel@linaro.org> wrote:
> On 5 October 2016 at 13:30, Kees Cook <keescook@chromium.org> wrote:
>> On Wed, Oct 5, 2016 at 10:09 AM, Ard Biesheuvel
>> <ard.biesheuvel@linaro.org> wrote:
>>> Did anyone ever look into whether there is anything to gain in terms
>>> of hardening from randomizing the order initcalls are issued at each
>>> level? I know entropy is hard to come by at this stage, but on recent
>>> UEFI systems, this is something we could potentially solve
>>> generically. (It may uncover some breakage as well, but only hidden
>>> breakage that could already surface at any time due to linker changes,
>>> so I think this could serve as a diagnostic option as well)
>>
>> It could be a nice addition to CONFIG_RANDOMIZE_MEMORY which already
>> tries to address the "predictable memory locations at every boot"
>> problem by randomizing the offset of the kernel memory mappings on
>> x86_64. Could this be done on arm64 too?
>>
>
> The arm64 implementation of KASLR randomizes the placement of
> installed memory inside the linear mapping. If this is the same thing,
> it seems this should be configurable under CONFIG_RANDOMIZE_MEMORY
> instead?
>
> But indeed, as Mark points out, this would primarily affect the
> vmalloc space, and would be defeated by dependency based init (if that
> ever materialises), and so it might make more sense to target __init
> stage vmalloc/ioremap invocations specifically.

I've almost got my HiKey running a modern kernel so I can answer with
some level of certainty, but looking at an older kernel's memory
layout, it seemed like arm64 has two primary memory areas, "kernel"
and "everything else". Did I understand that correctly, and/or is it
still true?

Is the vmalloc area offset from the kernel text, or does it have its
own static location in kernel virtual memory?

-Kees

-- 
Kees Cook
Nexus Security
