Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAGXu5j+FjPie_mfVhyPa77BrOf+XkAfkZgc+T3RNjecTLH6w2Q@mail.gmail.com>
References: <CAKv+Gu_7AdRk7O-Mt8oS=t6prJY56=nS5CS1stgfqHzJ--YD9Q@mail.gmail.com>
 <CAGXu5j+FjPie_mfVhyPa77BrOf+XkAfkZgc+T3RNjecTLH6w2Q@mail.gmail.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Wed, 5 Oct 2016 14:45:04 -0700
Message-ID: <CAKv+Gu9hWvAjckVjEHwNqTeRQgA-5YUatgAZXM-TtTVi6t4yng@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] initcall randomization
To: kernel-hardening@lists.openwall.com
Cc: Laura Abbott <labbott@fedoraproject.org>, Mark Rutland <mark.rutland@arm.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 5 October 2016 at 13:30, Kees Cook <keescook@chromium.org> wrote:
> On Wed, Oct 5, 2016 at 10:09 AM, Ard Biesheuvel
> <ard.biesheuvel@linaro.org> wrote:
>> Did anyone ever look into whether there is anything to gain in terms
>> of hardening from randomizing the order initcalls are issued at each
>> level? I know entropy is hard to come by at this stage, but on recent
>> UEFI systems, this is something we could potentially solve
>> generically. (It may uncover some breakage as well, but only hidden
>> breakage that could already surface at any time due to linker changes,
>> so I think this could serve as a diagnostic option as well)
>
> It could be a nice addition to CONFIG_RANDOMIZE_MEMORY which already
> tries to address the "predictable memory locations at every boot"
> problem by randomizing the offset of the kernel memory mappings on
> x86_64. Could this be done on arm64 too?
>

The arm64 implementation of KASLR randomizes the placement of
installed memory inside the linear mapping. If this is the same thing,
it seems this should be configurable under CONFIG_RANDOMIZE_MEMORY
instead?

But indeed, as Mark points out, this would primarily affect the
vmalloc space, and would be defeated by dependency based init (if that
ever materialises), and so it might make more sense to target __init
stage vmalloc/ioremap invocations specifically.

>> Since boot time mappings are often performed in initcalls, this could
>> potentially reduce the predictability of the layout of the virtual
>> kernel space. But before I start experimenting with this, I thought
>> I'd ask if anyone has ever looked into this.
>
> As Greg mentioned, I bet there are some implicit ordering (and
> explicit) that would need solving.
>

I guess we should expect some things to break if initcalls within the
same levels are reordered. The question is if we should treat those as
defects. I understand that we can currently rely on GNU ld not to
reorder section contents, even with the multiple levels of partial
linking that we do in the kernel, but this is not documented afaik,
and not guaranteed. Things like LTO may break some assumptions here,
if anyone ever attempts that.

But given the feedback, it seems to make more sense to randomise
boottime vmalloc/ioremap calls directly, so I will experiment with
that first.

-- 
Ard.
