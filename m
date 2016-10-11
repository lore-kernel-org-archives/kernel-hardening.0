Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAGXu5jJaAsED5=YX7RWtkHc8b219MEZ_7doohLUDics5nZY3ag@mail.gmail.com>
References: <CAKv+Gu_7AdRk7O-Mt8oS=t6prJY56=nS5CS1stgfqHzJ--YD9Q@mail.gmail.com>
 <CAGXu5j+FjPie_mfVhyPa77BrOf+XkAfkZgc+T3RNjecTLH6w2Q@mail.gmail.com>
 <CAKv+Gu9hWvAjckVjEHwNqTeRQgA-5YUatgAZXM-TtTVi6t4yng@mail.gmail.com> <CAGXu5jJaAsED5=YX7RWtkHc8b219MEZ_7doohLUDics5nZY3ag@mail.gmail.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Tue, 11 Oct 2016 19:28:46 +0100
Message-ID: <CAKv+Gu-LUZOCAYLi+DvNmuVjMC_0OMjZKkCu8+XfH_Z7RQbifQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] initcall randomization
To: kernel-hardening@lists.openwall.com
Cc: Laura Abbott <labbott@fedoraproject.org>, Mark Rutland <mark.rutland@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 10 October 2016 at 23:17, Kees Cook <keescook@chromium.org> wrote:
> On Wed, Oct 5, 2016 at 2:45 PM, Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
>> On 5 October 2016 at 13:30, Kees Cook <keescook@chromium.org> wrote:
>>> On Wed, Oct 5, 2016 at 10:09 AM, Ard Biesheuvel
>>> <ard.biesheuvel@linaro.org> wrote:
>>>> Did anyone ever look into whether there is anything to gain in terms
>>>> of hardening from randomizing the order initcalls are issued at each
>>>> level? I know entropy is hard to come by at this stage, but on recent
>>>> UEFI systems, this is something we could potentially solve
>>>> generically. (It may uncover some breakage as well, but only hidden
>>>> breakage that could already surface at any time due to linker changes,
>>>> so I think this could serve as a diagnostic option as well)
>>>
>>> It could be a nice addition to CONFIG_RANDOMIZE_MEMORY which already
>>> tries to address the "predictable memory locations at every boot"
>>> problem by randomizing the offset of the kernel memory mappings on
>>> x86_64. Could this be done on arm64 too?
>>>
>>
>> The arm64 implementation of KASLR randomizes the placement of
>> installed memory inside the linear mapping. If this is the same thing,
>> it seems this should be configurable under CONFIG_RANDOMIZE_MEMORY
>> instead?
>>
>> But indeed, as Mark points out, this would primarily affect the
>> vmalloc space, and would be defeated by dependency based init (if that
>> ever materialises), and so it might make more sense to target __init
>> stage vmalloc/ioremap invocations specifically.
>
> I've almost got my HiKey running a modern kernel so I can answer with
> some level of certainty, but looking at an older kernel's memory
> layout, it seemed like arm64 has two primary memory areas, "kernel"
> and "everything else". Did I understand that correctly, and/or is it
> still true?
>
> Is the vmalloc area offset from the kernel text, or does it have its
> own static location in kernel virtual memory?
>

It typically looks like

    modules : 0xffff000000000000 - 0xffff000008000000   (   128 MB)
    vmalloc : 0xffff000008000000 - 0xffff7dffbfff0000   (129022 GB)
      .text : 0xffff0d61922a0000 - 0xffff0d6192a80000   (  8064 KB)
    .rodata : 0xffff0d6192a80000 - 0xffff0d6192dd0000   (  3392 KB)
      .init : 0xffff0d6192dd0000 - 0xffff0d6193020000   (  2368 KB)
      .data : 0xffff0d6193020000 - 0xffff0d61930d3200   (   717 KB)
       .bss : 0xffff0d61930d3200 - 0xffff0d6193116d2c   (   271 KB)
    fixed   : 0xffff7dfffe7fd000 - 0xffff7dfffec00000   (  4108 KB)
    PCI I/O : 0xffff7dfffee00000 - 0xffff7dffffe00000   (    16 MB)
    vmemmap : 0xffff7e0000000000 - 0xffff800000000000   (  2048 GB maximum)
              0xffff7ebfb4000000 - 0xffff7ebfb7ff0000   (    63 MB actual)
    memory  : 0xffffafed00000000 - 0xffffafedffc00000   (  4092 MB)

So the kernel virtual mapping is covered by the vmalloc area (and will
be randomized to somewhere in the first half of that range when kaslr
is in effect). The module area is listed separately, but that range is
only used when kaslr is off. If kaslr is on, the 128 MB module region
will be placed randomly in the first half of the vmalloc region as
well, and depending on CONFIG_RANDOMIZE_MODULE_REGION_FULL, it will
intersect the kernel mapping (to allow relative branches without PLT
entries), or be randomized completely independently.

vmalloc and ioremap calls will simply be served bottom up, which is
why the beginning of the vmalloc area mostly looks the same between
boots, i.e., all non-kaslr boots look identical, and all kaslr boots
look identical with little variation.

I am aware that random vmalloc is a bad idea, hence my suggestion to
perhaps randomize during the __init phase. I must admit that this is
simply me holding the randomization hammer and looking for things that
vaguely resemble nails, hence my request for discussion rather than
proposing patches.
