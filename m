Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160926125212.GA19661@dhcp-128-65.nay.redhat.com>
References: <1471452462-42560-1-git-send-email-thgarnie@google.com>
 <20160922084111.GA18585@dhcp-128-65.nay.redhat.com> <CAJcbSZFXDXt1uhG-e8BdNyKXaSnsFeB4gsoMsx8_HxcNgjFaMw@mail.gmail.com>
 <20160926125212.GA19661@dhcp-128-65.nay.redhat.com>
From: Thomas Garnier <thgarnie@google.com>
Date: Mon, 26 Sep 2016 09:53:32 -0700
Message-ID: <CAJcbSZEUx9ee6q-ao8RSCKcOT=r1wpH7mee2F0J-X9WcfbtXxg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v1] kexec/arch/i386: Add support for KASLR memory randomization
To: Dave Young <dyoung@redhat.com>
Cc: kexec@lists.infradead.org, Simon Horman <horms@verge.net.au>, Kees Cook <keescook@chromium.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Sep 26, 2016 at 5:52 AM, Dave Young <dyoung@redhat.com> wrote:
> On 09/23/16 at 09:33am, Thomas Garnier wrote:
>> On Thu, Sep 22, 2016 at 1:41 AM, Dave Young <dyoung@redhat.com> wrote:
>> > Hi, Thomas
>> >
>> > On 08/17/16 at 09:47am, Thomas Garnier wrote:
>> >> Multiple changes were made on KASLR (right now in linux-next). One of
>> >> them is randomizing the virtual address of the physical mapping, vmalloc
>> >> and vmemmap memory sections. It breaks kdump ability to read physical
>> >> memory.
>> >
>> > What is the user visible behavior without this patch? Could you add more
>> > in the patch log?
>> >
>> > During my testing seems with or without this patch kdump kernel boot
>> > both fine.
>>
>> Without this patch, you can't access memory on the generated crash dumps.
>
> Ok, makedumpfile saving /proc/vmcore works fine without this patch, but
> gdb will give error when accessing the old memory.
>

Yes, that's correct.

>>
>> >
>> > My kernel config options is like below, is it enough to test this patch?
>> > CONFIG_RANDOMIZE_BASE=y
>> > CONFIG_X86_NEED_RELOCS=y
>> > CONFIG_PHYSICAL_ALIGN=0x1000000
>> > CONFIG_RANDOMIZE_MEMORY=y
>> > CONFIG_RANDOMIZE_MEMORY_PHYSICAL_PADDING=0x0
>> >
>>
>> Should be good enough.
>>
>> >>
>> >> This change identifies if KASLR memories randomization is used by
>> >> checking if the page_offset_base variable exists. It search for the
>> >> correct PAGE_OFFSET value by looking at the loaded memory section and
>> >> find the lowest aligned on PUD (the randomization level).
>> >>
>> >> Related commits on linux-next:
>> >>  - 0483e1fa6e09d4948272680f691dccb1edb9677f: Base for randomization
>> >>  - 021182e52fe01c1f7b126f97fd6ba048dc4234fd: Enable for PAGE_OFFSET
>> >>
>> >> Signed-off-by: Thomas Garnier <thgarnie@google.com>
>> >> ---
>> >>  kexec/arch/i386/crashdump-x86.c | 29 ++++++++++++++++++++++-------
>> >>  1 file changed, 22 insertions(+), 7 deletions(-)
>> >>
>> >> diff --git a/kexec/arch/i386/crashdump-x86.c b/kexec/arch/i386/crashdump-x86.c
>> >> index bbc0f35..ab833d4 100644
>> >> --- a/kexec/arch/i386/crashdump-x86.c
>> >> +++ b/kexec/arch/i386/crashdump-x86.c
>> >> @@ -102,11 +102,10 @@ static int get_kernel_paddr(struct kexec_info *UNUSED(info),
>> >>       return -1;
>> >>  }
>> >>
>> >> -/* Retrieve kernel _stext symbol virtual address from /proc/kallsyms */
>> >> -static unsigned long long get_kernel_stext_sym(void)
>> >> +/* Retrieve kernel symbol virtual address from /proc/kallsyms */
>> >> +static unsigned long long get_kernel_sym(const char *symbol)
>> >
>> > It sounds better to split this to another patch.
>> >
>>
>> Why not, that's a very small change though.
>>
>> >>  {
>> >>       const char *kallsyms = "/proc/kallsyms";
>> >> -     const char *stext = "_stext";
>> >>       char sym[128];
>> >>       char line[128];
>> >>       FILE *fp;
>> >> @@ -122,13 +121,13 @@ static unsigned long long get_kernel_stext_sym(void)
>> >>       while(fgets(line, sizeof(line), fp) != NULL) {
>> >>               if (sscanf(line, "%Lx %c %s", &vaddr, &type, sym) != 3)
>> >>                       continue;
>> >> -             if (strcmp(sym, stext) == 0) {
>> >> -                     dbgprintf("kernel symbol %s vaddr = %16llx\n", stext, vaddr);
>> >> +             if (strcmp(sym, symbol) == 0) {
>> >> +                     dbgprintf("kernel symbol %s vaddr = %16llx\n", symbol, vaddr);
>> >>                       return vaddr;
>> >>               }
>> >>       }
>> >>
>> >> -     fprintf(stderr, "Cannot get kernel %s symbol address\n", stext);
>> >> +     fprintf(stderr, "Cannot get kernel %s symbol address\n", symbol);
>
> For page_offset_base it should only print the error message when
> the kernel supports it.
>

I agree that would be better. How do we know if the kernel supports it though?

I can't think of a reliable way to detect if KASLR is enabled. I think
Kees told me there was no official way on purpose.

>
>> >>       return 0;
>> >>  }
>> >>
>> >> @@ -151,6 +150,8 @@ static int get_kernel_vaddr_and_size(struct kexec_info *UNUSED(info),
>> >>       off_t size;
>> >>       uint32_t elf_flags = 0;
>> >>       uint64_t stext_sym;
>> >> +     const unsigned long long pud_mask = ~((1 << 30) - 1);
>> >> +     unsigned long long vaddr, lowest_vaddr = 0;
>> >>
>> >>       if (elf_info->machine != EM_X86_64)
>> >>               return 0;
>> >> @@ -180,9 +181,23 @@ static int get_kernel_vaddr_and_size(struct kexec_info *UNUSED(info),
>> >>
>> >>       end_phdr = &ehdr.e_phdr[ehdr.e_phnum];
>> >>
>> >> +     /* Search for the real PAGE_OFFSET when KASLR memory randomization
>> >> +      * is enabled */
>> >> +     if (get_kernel_sym("page_offset_base") != 0) {
>> >> +             for(phdr = ehdr.e_phdr; phdr != end_phdr; phdr++) {
>> >> +                     if (phdr->p_type == PT_LOAD) {
>> >> +                             vaddr = phdr->p_vaddr & pud_mask;
>> >> +                             if (lowest_vaddr == 0 || lowest_vaddr > vaddr)
>> >> +                                     lowest_vaddr = vaddr;
>> >> +                     }
>> >> +             }
>> >> +             if (lowest_vaddr != 0)
>> >> +                     elf_info->page_offset = lowest_vaddr;
>> >> +     }
>> >> +
>> >>       /* Traverse through the Elf headers and find the region where
>> >>        * _stext symbol is located in. That's where kernel is mapped */
>> >> -     stext_sym = get_kernel_stext_sym();
>> >> +     stext_sym = get_kernel_sym("_stext");
>> >>       for(phdr = ehdr.e_phdr; stext_sym && phdr != end_phdr; phdr++) {
>> >>               if (phdr->p_type == PT_LOAD) {
>> >>                       unsigned long long saddr = phdr->p_vaddr;
>> >> --
>
> Thanks
> Dave
