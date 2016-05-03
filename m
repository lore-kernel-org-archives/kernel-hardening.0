Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <5727CD69.7040901@linux.intel.com>
References: <1462225276-106993-1-git-send-email-thgarnie@google.com>
	<1462225276-106993-3-git-send-email-thgarnie@google.com>
	<5727CD69.7040901@linux.intel.com>
Date: Tue, 3 May 2016 08:46:27 -0700
Message-ID: <CAJcbSZGDzTMQYrzFKN86t3=MzSfFzs7+6UYOZufQEqZ2ie+hEA@mail.gmail.com>
From: Thomas Garnier <thgarnie@google.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2 2/4] x86, boot: PUD VA support for physical mapping (x86_64)
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Kees Cook <keescook@chromium.org>, Stephen Smalley <sds@tycho.nsa.gov>, Kefeng Wang <wangkefeng.wang@huawei.com>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, Toshi Kani <toshi.kani@hpe.com>, Alexander Kuleshov <kuleshovmail@gmail.com>, Alexander Popov <alpopov@ptsecurity.com>, Joerg Roedel <jroedel@suse.de>, Dave Young <dyoung@redhat.com>, Baoquan He <bhe@redhat.com>, Mark Salter <msalter@redhat.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, x86@kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, Greg Thelen <gthelen@google.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, May 2, 2016 at 2:58 PM, Dave Hansen <dave.hansen@linux.intel.com> wrote:
> On 05/02/2016 02:41 PM, Thomas Garnier wrote:
>> Minor change that allows early boot physical mapping of PUD level virtual
>> addresses. This change prepares usage of different virtual addresses for
>> KASLR memory randomization. It has no impact on default usage.
> ...
>> diff --git a/arch/x86/mm/init_64.c b/arch/x86/mm/init_64.c
>> index 89d9747..6adfbce 100644
>> --- a/arch/x86/mm/init_64.c
>> +++ b/arch/x86/mm/init_64.c
>> @@ -526,10 +526,10 @@ phys_pud_init(pud_t *pud_page, unsigned long addr, unsigned long end,
>>  {
>>       unsigned long pages = 0, next;
>>       unsigned long last_map_addr = end;
>> -     int i = pud_index(addr);
>> +     int i = pud_index((unsigned long)__va(addr));
>>
>>       for (; i < PTRS_PER_PUD; i++, addr = next) {
>> -             pud_t *pud = pud_page + pud_index(addr);
>> +             pud_t *pud = pud_page + pud_index((unsigned long)__va(addr));
>>               pmd_t *pmd;
>>               pgprot_t prot = PAGE_KERNEL;
>
> pud_index() is supposed to take a virtual address.  We were passing a
> physical address in here, and it all just worked because PAGE_OFFSET is
> PUD-aligned.  Now that you are moving PAGE_OFFSET around a bit and not
> PUD-aligning it, this breaks.  Right?
>
> Could you spell this out a bit more the changelog?

Sure, will do on next iteration.

Thanks,
Thomas
