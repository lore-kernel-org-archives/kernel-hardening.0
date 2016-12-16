Reply-To: kernel-hardening@lists.openwall.com
Date: Fri, 16 Dec 2016 15:52:24 +0800
From: Baoquan He <bhe@redhat.com>
Message-ID: <20161216075224.GE9239@x1>
References: <1481818648-36201-1-git-send-email-thgarnie@google.com>
 <87bmwdytco.fsf@xmission.com>
 <CAJcbSZGvezhK3d4Gp+-j0iDFi3d2nBwR0hxxt9_0cYz-CvAcwA@mail.gmail.com>
 <CAJcbSZEK8KFCRjDiuudPPNn1ULtsmEm2ituabZdYqA4WchxkjA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJcbSZEK8KFCRjDiuudPPNn1ULtsmEm2ituabZdYqA4WchxkjA@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH] Revert "Revert "kdump, vmcoreinfo: report memory
 sections virtual addresses""
To: Thomas Garnier <thgarnie@google.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Kernel Hardening <kernel-hardening@lists.openwall.com>, kexec@lists.infradead.org, the arch/x86 maintainers <x86@kernel.org>, Xunlei Pang <xlpang@redhat.com>, LKML <linux-kernel@vger.kernel.org>, HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>
List-ID: <kernel-hardening.lists.openwall.com>

On 12/15/16 at 11:45am, Thomas Garnier wrote:
> >> as is the justification.
> >>
> >> These values are not in fact widely used by userspace (they are brand new).
> >>
> >
> > They were new and got through to the master tree before and on 4.9. I
> > didn't get any feedback on that when it went through.
> >
> >> This is a very fragile approach relying on kernel implementation
> >> details, so if we can do anything else that is more robust it
> >> is much more likely to pass the test of time.
> >>
> >> And yes a more robust implementation has been already discussed.
> >>
> >
> > There were discussed for the PAGE_OFFSET but not VMALLOC_START. What's
> > your approach for it?

Sorry, Thomas. I didn't realize these are also required other than
Makedumpfile. So just revert it after we use a new way to get
page_offset and translate VA to PA by page table in makedumpfile. For
the time being they are not needed any more by makedumpfile.

While from below discussion we can see Atsushi, maintainer of
Makedumpfile, still worry about the parsing PT_LOAD segment header way.
I personally think exporting them is easier and more understandable for
user space utility.

http://lists.infradead.org/pipermail/kexec/2016-December/017815.html

I can't think of other way for your tool, maybe page_offset you can
use the similar way makedumpfile is taking. As for VMALLOC_START and
VMEMMAP_START, it could be necessary. And if you are planning to
randomize the memory section order, thinking about them carefully
now is a good chance lest they need be adjusted again later. 

Sorry again for this.

> >
> 
> Also with improvement on KASLR memory randomization, I don't think we
> should assume memory sections by looking at PT_LOAD first entries. We
> will certainly try to randomize the order. That's why I thought
> clearly indicating which VA define which memory section was a good
> idea.
> 
> I also want to find a time proof approach where we can use it no
> matter the changes to KASLR.
> 
> >> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
> >>
> >>>
> >>> Signed-off-by: Thomas Garnier <thgarnie@google.com>
> >>> ---
> >>>  arch/x86/kernel/machine_kexec_64.c | 3 +++
> >>>  include/linux/kexec.h              | 6 ++++++
> >>>  2 files changed, 9 insertions(+)
> >>>
> >>> diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
> >>> index 2e3c34b..05f3367 100644
> >>> --- a/arch/x86/kernel/machine_kexec_64.c
> >>> +++ b/arch/x86/kernel/machine_kexec_64.c
> >>> @@ -339,6 +339,9 @@ void arch_crash_save_vmcoreinfo(void)
> >>>                             kaslr_offset());
> >>>       VMCOREINFO_NUMBER(KERNEL_IMAGE_SIZE);
> >>>       VMCOREINFO_PHYS_BASE(phys_base);
> >>> +     VMCOREINFO_PAGE_OFFSET(PAGE_OFFSET);
> >>> +     VMCOREINFO_VMALLOC_START(VMALLOC_START);
> >>> +     VMCOREINFO_VMEMMAP_START(VMEMMAP_START);
> >>>  }
> >>>
> >>>  /* arch-dependent functionality related to kexec file-based syscall */
> >>> diff --git a/include/linux/kexec.h b/include/linux/kexec.h
> >>> index e98e546..ff9c876 100644
> >>> --- a/include/linux/kexec.h
> >>> +++ b/include/linux/kexec.h
> >>> @@ -285,6 +285,12 @@ phys_addr_t paddr_vmcoreinfo_note(void);
> >>>       vmcoreinfo_append_str("CONFIG_%s=y\n", #name)
> >>>  #define VMCOREINFO_PHYS_BASE(value) \
> >>>       vmcoreinfo_append_str("PHYS_BASE=%lx\n", (unsigned long)value)
> >>> +#define VMCOREINFO_PAGE_OFFSET(value) \
> >>> +     vmcoreinfo_append_str("PAGE_OFFSET=%lx\n", (unsigned long)value)
> >>> +#define VMCOREINFO_VMALLOC_START(value) \
> >>> +     vmcoreinfo_append_str("VMALLOC_START=%lx\n", (unsigned long)value)
> >>> +#define VMCOREINFO_VMEMMAP_START(value) \
> >>> +     vmcoreinfo_append_str("VMEMMAP_START=%lx\n", (unsigned long)value)
> >>>
> >>>  extern struct kimage *kexec_image;
> >>>  extern struct kimage *kexec_crash_image;
> >
> >
> >
> > --
> > Thomas
> 
> 
> 
> -- 
> Thomas
> 
> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
