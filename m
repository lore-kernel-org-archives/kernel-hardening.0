Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <87bmwdytco.fsf@xmission.com>
References: <1481818648-36201-1-git-send-email-thgarnie@google.com> <87bmwdytco.fsf@xmission.com>
From: Thomas Garnier <thgarnie@google.com>
Date: Thu, 15 Dec 2016 10:16:38 -0800
Message-ID: <CAJcbSZGvezhK3d4Gp+-j0iDFi3d2nBwR0hxxt9_0cYz-CvAcwA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH] Revert "Revert "kdump, vmcoreinfo: report memory sections
 virtual addresses""
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrew Morton <akpm@linux-foundation.org>, Baoquan He <bhe@redhat.com>, Xunlei Pang <xlpang@redhat.com>, HATAYAMA Daisuke <d.hatayama@jp.fujitsu.com>, the arch/x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, kexec@lists.infradead.org, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Dec 15, 2016 at 9:50 AM, Eric W. Biederman
<ebiederm@xmission.com> wrote:
> Thomas Garnier <thgarnie@google.com> writes:
>
>> This reverts commit 49fd897573c97b0eaf10f47d850027d78c456cd7.
>>
>> Reverting back to commit 0549a3c because the values are used by crash
>> and other tools already. I expected this commit would not go through given
>> the unresolved comments. I want it to be easy to resolve major memory
>> section positions when KASLR memory randomization is enabled.
>
> This patch is broken.  The commit referenced is wrong,

Yes, I based them on linux-next. I can update them to linux main tree.
Sorry about that.

> as is the justification.
>
> These values are not in fact widely used by userspace (they are brand new).
>

They were new and got through to the master tree before and on 4.9. I
didn't get any feedback on that when it went through.

> This is a very fragile approach relying on kernel implementation
> details, so if we can do anything else that is more robust it
> is much more likely to pass the test of time.
>
> And yes a more robust implementation has been already discussed.
>

There were discussed for the PAGE_OFFSET but not VMALLOC_START. What's
your approach for it?

> Nacked-by: "Eric W. Biederman" <ebiederm@xmission.com>
>
>>
>> Signed-off-by: Thomas Garnier <thgarnie@google.com>
>> ---
>>  arch/x86/kernel/machine_kexec_64.c | 3 +++
>>  include/linux/kexec.h              | 6 ++++++
>>  2 files changed, 9 insertions(+)
>>
>> diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
>> index 2e3c34b..05f3367 100644
>> --- a/arch/x86/kernel/machine_kexec_64.c
>> +++ b/arch/x86/kernel/machine_kexec_64.c
>> @@ -339,6 +339,9 @@ void arch_crash_save_vmcoreinfo(void)
>>                             kaslr_offset());
>>       VMCOREINFO_NUMBER(KERNEL_IMAGE_SIZE);
>>       VMCOREINFO_PHYS_BASE(phys_base);
>> +     VMCOREINFO_PAGE_OFFSET(PAGE_OFFSET);
>> +     VMCOREINFO_VMALLOC_START(VMALLOC_START);
>> +     VMCOREINFO_VMEMMAP_START(VMEMMAP_START);
>>  }
>>
>>  /* arch-dependent functionality related to kexec file-based syscall */
>> diff --git a/include/linux/kexec.h b/include/linux/kexec.h
>> index e98e546..ff9c876 100644
>> --- a/include/linux/kexec.h
>> +++ b/include/linux/kexec.h
>> @@ -285,6 +285,12 @@ phys_addr_t paddr_vmcoreinfo_note(void);
>>       vmcoreinfo_append_str("CONFIG_%s=y\n", #name)
>>  #define VMCOREINFO_PHYS_BASE(value) \
>>       vmcoreinfo_append_str("PHYS_BASE=%lx\n", (unsigned long)value)
>> +#define VMCOREINFO_PAGE_OFFSET(value) \
>> +     vmcoreinfo_append_str("PAGE_OFFSET=%lx\n", (unsigned long)value)
>> +#define VMCOREINFO_VMALLOC_START(value) \
>> +     vmcoreinfo_append_str("VMALLOC_START=%lx\n", (unsigned long)value)
>> +#define VMCOREINFO_VMEMMAP_START(value) \
>> +     vmcoreinfo_append_str("VMEMMAP_START=%lx\n", (unsigned long)value)
>>
>>  extern struct kimage *kexec_image;
>>  extern struct kimage *kexec_crash_image;



-- 
Thomas
