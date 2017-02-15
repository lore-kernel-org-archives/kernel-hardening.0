MIME-Version: 1.0
In-Reply-To: <CALCETrXDQaWyo02b2q7JN3W1frR0QAOy1Wj_ft5YpPbEbZEfPw@mail.gmail.com>
References: <20170214194259.75960-1-thgarnie@google.com> <20170214194259.75960-4-thgarnie@google.com>
 <CALCETrXDQaWyo02b2q7JN3W1frR0QAOy1Wj_ft5YpPbEbZEfPw@mail.gmail.com>
From: Thomas Garnier <thgarnie@google.com>
Date: Wed, 15 Feb 2017 07:44:04 -0800
Message-ID: <CAJcbSZGiff-ciLtaVf6m7=m+6LT+ef+-zqPGO6iVPBpQEnd56Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v3 4/4] KVM: VMX: Simplify segment_base
To: Andy Lutomirski <luto@amacapital.net>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, Kees Cook <keescook@chromium.org>, Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@suse.de>, Paul Gortmaker <paul.gortmaker@windriver.com>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>, Jiri Kosina <jikos@kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, Juergen Gross <jgross@suse.com>, Rusty Russell <rusty@rustcorp.com.au>, Peter Zijlstra <peterz@infradead.org>, Christian Borntraeger <borntraeger@de.ibm.com>, "Luis R . Rodriguez" <mcgrof@kernel.org>, He Chen <he.chen@linux.intel.com>, Brian Gerst <brgerst@gmail.com>, Stanislaw Gruszka <sgruszka@redhat.com>, Arnd Bergmann <arnd@arndb.de>, Adam Buchbinder <adam.buchbinder@gmail.com>, Dave Hansen <dave.hansen@intel.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Tim Chen <tim.c.chen@linux.intel.com>, Rik van Riel <riel@redhat.com>, Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>, Michael Ellerman <mpe@ellerman.id.au>, Joerg Roedel <joro@8bytes.org>, Paolo Bonzini <pbonzini@redhat.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, X86 ML <x86@kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, kasan-dev <kasan-dev@googlegroups.com>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>, lguest@lists.ozlabs.org, kvm list <kvm@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Feb 14, 2017 at 7:57 PM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Tue, Feb 14, 2017 at 11:42 AM, Thomas Garnier <thgarnie@google.com> wrote:
>> The KVM segment_base function is confusing. This patch replaces integers
>> with appropriate flags, simplify constructs and add comments.
>
> It could pay to put this first in the series, but last is probably fine, too.
>

:)

>>
>> Signed-off-by: Thomas Garnier <thgarnie@google.com>
>> ---
>> Based on next-20170213
>> ---
>>  arch/x86/kvm/vmx.c | 26 ++++++++++++++++++--------
>>  1 file changed, 18 insertions(+), 8 deletions(-)
>>
>> diff --git a/arch/x86/kvm/vmx.c b/arch/x86/kvm/vmx.c
>> index 99167f20bc34..edb8326108dd 100644
>> --- a/arch/x86/kvm/vmx.c
>> +++ b/arch/x86/kvm/vmx.c
>> @@ -2062,25 +2062,35 @@ static unsigned long segment_base(u16 selector)
>>         struct desc_struct *d;
>>         unsigned long table_base;
>
> This should go away IMO.  It should be struct desc_struct *table;
>
>> +               table_base = get_current_gdt_rw_vaddr();
>
> Then this can go away, too, and you can stop having the silly
> get_current_gdt_rw_vaddr() function at all.
>
>> +       d = (struct desc_struct *)table_base + (selector >> 3);
>
> And this cast goes away too.

No problem.

-- 
Thomas
