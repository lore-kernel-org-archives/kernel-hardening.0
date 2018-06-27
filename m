MIME-Version: 1.0
In-Reply-To: <ab0541ca-a036-34ca-ed1b-937c470cc9da@redhat.com>
References: <20180626165455.22636-1-ard.biesheuvel@linaro.org>
 <06b7ea07-53e2-690a-b670-d1fc41d133c3@redhat.com> <CAKv+Gu9uiqerCd54upWHxPBKcX1ga1oTwpYctEqbhhQGZOq6XA@mail.gmail.com>
 <76b00e4f-e6fd-f0e9-379c-e31e85d5258d@redhat.com> <ab0541ca-a036-34ca-ed1b-937c470cc9da@redhat.com>
From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date: Thu, 28 Jun 2018 01:29:42 +0200
Message-ID: <CAKv+Gu8TnraRGj_b=pcb6xTKMLX7GLZeJGmJ4R3vU6ygnr2kTA@mail.gmail.com>
Subject: Re: [RFC PATCH] arm64/mm: unmap the linear alias of module allocations
Content-Type: text/plain; charset="UTF-8"
To: Laura Abbott <labbott@redhat.com>
Cc: linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, Will Deacon <will.deacon@arm.com>, Catalin Marinas <catalin.marinas@arm.com>, James Morse <james.morse@arm.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, YaoJun <yaojun8558363@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 28 June 2018 at 01:28, Laura Abbott <labbott@redhat.com> wrote:
> On 06/26/2018 06:15 PM, Laura Abbott wrote:
>>
>> +static void remap_linear_module_alias(void *module_region, int enable)
>> +{
>> +       struct vm_struct *vm = find_vm_area(module_region);
>> +       struct page **p;
>> +       unsigned long size;
>> +
>> +       WARN_ON(!vm || !vm->pages);
>> +
>> +       for (p = vm->pages, size = vm->size; size > 0; size -= PAGE_SIZE)
>> +               set_memory_valid((u64)page_address(*p++), 1, enable);
>> +}
>
>
> So I think the weirdness is caused by using vm->size here. The size of
> the array is actually tracked by vm->nr_pages since vm->size may vary
> depending on the guard page. I think this ended being an off by one
> error with setting a non-existent page valid, hence the oddness in
> the entry. If I switch to using vm->nr_pages, I don't see the entry
> anymore.
>

OK, thanks for tracking that down!
