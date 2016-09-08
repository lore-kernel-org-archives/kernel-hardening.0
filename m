Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160907061710.GA11562@x1.nay.redhat.com>
References: <1471531632-23003-1-git-send-email-thgarnie@google.com>
 <20160829101137.GA29344@x1.redhat.com> <20160907060954.GF16712@linaro.org> <20160907061710.GA11562@x1.nay.redhat.com>
From: Thomas Garnier <thgarnie@google.com>
Date: Thu, 8 Sep 2016 08:32:25 -0700
Message-ID: <CAJcbSZH4tG_aorU55CDdJf=e+Nka9QbBVYFOPmyZk47T-DA7Ng@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v1] kdump, vmcoreinfo: report memory sections virtual addresses
To: Baoquan He <bhe@redhat.com>
Cc: AKASHI Takahiro <takahiro.akashi@linaro.org>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Eric Biederman <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Xunlei Pang <xlpang@redhat.com>, HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, Kees Cook <keescook@chromium.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>, Eugene Surovegin <surovegin@google.com>, the arch/x86 maintainers <x86@kernel.org>, kexec@lists.infradead.org, LKML <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Sep 6, 2016 at 11:17 PM, Baoquan He <bhe@redhat.com> wrote:
> On 09/07/16 at 03:09pm, AKASHI Takahiro wrote:
>> On Mon, Aug 29, 2016 at 06:11:37PM +0800, Baoquan He wrote:
>> > Hi Thomas,
>> >
>> > I used below code and it works. Since using VMCOREINFO_NUMBER can reuse
>> > the existing struct number_table to import the data. It makes change
>> > easier. But the place could be next to KERNEL_IMAGE_SIZE, or as your
>> > patch did, both is fine.
>>
>> I think we'd better avoid adding arch-specific code in generic code
>> if possible, especially in this case, since there is a dedicated interface,
>> arch_crash_save_vmcoreinfo().
>
> Yes, agree. Previously the reason I put KERNEL_IMAGE_SIZE in
> crash_save_vmcoreinfo_init is kernel text randomization could be a
> generic method for all ARCHes. Then it can be taken out from the #ifdef
> scope. Now seeing it again, it's better to be put in
> arch_crash_save_vmcoreinfo, at least for the time being.
>
> Hi Thomas,
>
> By the way, will you repost with the VMCOREINFO_NUMBER format? If not, I
> can repost after I test all kexec/makedumpfile changes.

I think you should repost it.

>
> Thanks
> Baoquan
>
>>
>> -Takahiro AKASHI
>>
>> > ---
>> >  kernel/kexec_core.c | 3 +++
>> >  1 file changed, 3 insertions(+)
>> >
>> > diff --git a/kernel/kexec_core.c b/kernel/kexec_core.c
>> > index 5616755..81bde86 100644
>> > --- a/kernel/kexec_core.c
>> > +++ b/kernel/kexec_core.c
>> > @@ -1469,6 +1469,9 @@ static int __init crash_save_vmcoreinfo_init(void)
>> >     VMCOREINFO_NUMBER(PAGE_BUDDY_MAPCOUNT_VALUE);
>> >  #ifdef CONFIG_X86
>> >     VMCOREINFO_NUMBER(KERNEL_IMAGE_SIZE);
>> > +   VMCOREINFO_NUMBER(PAGE_OFFSET);
>> > +   VMCOREINFO_NUMBER(VMALLOC_START);
>> > +   VMCOREINFO_NUMBER(VMEMMAP_START);
>> >  #endif
>> >  #ifdef CONFIG_HUGETLB_PAGE
>> >     VMCOREINFO_NUMBER(HUGETLB_PAGE_DTOR);
>> > --
>> > 2.5.5
>> >
>> > On 08/18/16 at 07:47am, Thomas Garnier wrote:
>> > > KASLR memory randomization can randomize the base of the physical memory
>> > > mapping (PAGE_OFFSET), vmalloc (VMALLOC_START) and vmemmap
>> > > (VMEMMAP_START). Adding these variables on VMCOREINFO so tools can
>> > > easily identify the base of each memory section.
>> > >
>> > > Signed-off-by: Thomas Garnier <thgarnie@google.com>
>> > > ---
>> > > Based on next-20160817
>> > > ---
>> > >  arch/x86/kernel/machine_kexec_64.c | 3 +++
>> > >  include/linux/kexec.h              | 6 ++++++
>> > >  2 files changed, 9 insertions(+)
>> > >
>> > > diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
>> > > index fc3389f..b1f15a2 100644
>> > > --- a/arch/x86/kernel/machine_kexec_64.c
>> > > +++ b/arch/x86/kernel/machine_kexec_64.c
>> > > @@ -338,6 +338,9 @@ void arch_crash_save_vmcoreinfo(void)
>> > >   vmcoreinfo_append_str("KERNELOFFSET=%lx\n",
>> > >                         kaslr_offset());
>> > >   VMCOREINFO_PHYS_BASE(phys_base);
>> > > + VMCOREINFO_PAGE_OFFSET(PAGE_OFFSET);
>> > > + VMCOREINFO_VMALLOC_START(VMALLOC_START);
>> > > + VMCOREINFO_VMEMMAP_START(VMEMMAP_START);
>> > >  }
>> > >
>> > >  /* arch-dependent functionality related to kexec file-based syscall */
>> > > diff --git a/include/linux/kexec.h b/include/linux/kexec.h
>> > > index d3ae429..cd3874c 100644
>> > > --- a/include/linux/kexec.h
>> > > +++ b/include/linux/kexec.h
>> > > @@ -261,6 +261,12 @@ phys_addr_t paddr_vmcoreinfo_note(void);
>> > >   vmcoreinfo_append_str("CONFIG_%s=y\n", #name)
>> > >  #define VMCOREINFO_PHYS_BASE(value) \
>> > >   vmcoreinfo_append_str("PHYS_BASE=%lx\n", (unsigned long)value)
>> > > +#define VMCOREINFO_PAGE_OFFSET(value) \
>> > > + vmcoreinfo_append_str("PAGE_OFFSET=%lx\n", (unsigned long)value)
>> > > +#define VMCOREINFO_VMALLOC_START(value) \
>> > > + vmcoreinfo_append_str("VMALLOC_START=%lx\n", (unsigned long)value)
>> > > +#define VMCOREINFO_VMEMMAP_START(value) \
>> > > + vmcoreinfo_append_str("VMEMMAP_START=%lx\n", (unsigned long)value)
>> > >
>> > >  extern struct kimage *kexec_image;
>> > >  extern struct kimage *kexec_crash_image;
>> > > --
>> > > 2.8.0.rc3.226.g39d4020
>> > >
>> > >
>> > > _______________________________________________
>> > > kexec mailing list
>> > > kexec@lists.infradead.org
>> > > http://lists.infradead.org/mailman/listinfo/kexec
