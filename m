MIME-Version: 1.0
In-Reply-To: <51c23e92-d1f0-427f-e069-c92fc4ed6226@oracle.com>
References: <20170306220348.79702-1-thgarnie@google.com> <20170306220348.79702-2-thgarnie@google.com>
 <CALCETrVXHc-EAhBtdhL9FXSW1G2VbohRY4UJuOtpRG1K0Q-Ogg@mail.gmail.com>
 <17ffcc5b-1c9a-51b6-272a-5eaecf1bc0c4@citrix.com> <CALCETrWv-u7OdjWDY+5eF7p-ngPun-yYf0QegMzYc6MGVQd-4w@mail.gmail.com>
 <CAJcbSZExVWA0jvAoxLLc+58Ag9cHchifrHP=fFfzU_onHo2PyA@mail.gmail.com>
 <5cf31779-45c5-d37f-86bc-d5afb3fb7ab6@oracle.com> <51c23e92-d1f0-427f-e069-c92fc4ed6226@oracle.com>
From: Thomas Garnier <thgarnie@google.com>
Date: Thu, 9 Mar 2017 14:31:49 -0800
Message-ID: <CAJcbSZEnUBfLHjf+bHqY0JQhQXD9urX45BXrQjx=1=A5gPpp_w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: [Xen-devel] [PATCH v5 2/3] x86: Remap GDT tables in the Fixmap section
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Andy Lutomirski <luto@amacapital.net>, Andrew Cooper <andrew.cooper3@citrix.com>, Michal Hocko <mhocko@suse.com>, Stanislaw Gruszka <sgruszka@redhat.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, kvm list <kvm@vger.kernel.org>, Fenghua Yu <fenghua.yu@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>, Chris Wilson <chris@chris-wilson.co.uk>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Paul Gortmaker <paul.gortmaker@windriver.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Alexander Potapenko <glider@google.com>, Pavel Machek <pavel@ucw.cz>, "H . Peter Anvin" <hpa@zytor.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Jiri Olsa <jolsa@redhat.com>, zijun_hu <zijun_hu@htc.com>, Dave Hansen <dave.hansen@intel.com>, Andi Kleen <ak@linux.intel.com>, "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>, Jonathan Corbet <corbet@lwn.net>, Michael Ellerman <mpe@ellerman.id.au>, Joerg Roedel <joro@8bytes.org>, Prarit Bhargava <prarit@redhat.com>, kasan-dev <kasan-dev@googlegroups.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Ingo Molnar <mingo@redhat.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Borislav Petkov <bp@suse.de>, Len Brown <len.brown@intel.com>, Rusty Russell <rusty@rustcorp.com.au>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, He Chen <he.chen@linux.intel.com>, Brian Gerst <brgerst@gmail.com>, Jiri Kosina <jikos@kernel.org>, lguest@lists.ozlabs.org, Andy Lutomirski <luto@kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Dmitry Vyukov <dvyukov@google.com>, Juergen Gross <jgross@suse.com>, Peter Zijlstra <peterz@infradead.org>, Lorenzo Stoakes <lstoakes@gmail.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Tim Chen <tim.c.chen@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Mar 9, 2017 at 2:13 PM, Boris Ostrovsky
<boris.ostrovsky@oracle.com> wrote:
>
>>> I don't have any experience with Xen so it would be great if virtme can=
 test it.
>>
>> I am pretty sure I tested this series at some point but I'll test it aga=
in.
>>
>
>
> Fails 32-bit build:
>
>
> /home/build/linux-boris/arch/x86/kvm/vmx.c: In function =E2=80=98segment_=
base=E2=80=99:
> /home/build/linux-boris/arch/x86/kvm/vmx.c:2054: error: =E2=80=98host_gdt=
=E2=80=99
> undeclared (first use in this function)
> /home/build/linux-boris/arch/x86/kvm/vmx.c:2054: error: (Each undeclared
> identifier is reported only once
> /home/build/linux-boris/arch/x86/kvm/vmx.c:2054: error: for each
> function it appears in.)
> /home/build/linux-boris/arch/x86/kvm/vmx.c:2054: error: type defaults to
> =E2=80=98int=E2=80=99 in declaration of =E2=80=98type name=E2=80=99
> /home/build/linux-boris/arch/x86/kvm/vmx.c:2054: error: type defaults to
> =E2=80=98int=E2=80=99 in declaration of =E2=80=98type name=E2=80=99
> /home/build/linux-boris/arch/x86/kvm/vmx.c:2054: warning: initialization
> from incompatible pointer type
> /home/build/linux-boris/arch/x86/kvm/vmx.c:2054: warning: unused
> variable =E2=80=98gdt=E2=80=99
>
>
> -boris

It seems that I forgot to remove line 2054 on the rebase. My 32-bit
build comes clean but I assume it is not good enough compare to the
full version I build for 64-bit KVM testing.

Remove just this line and it should build fine, I will fix this on the
next iteration.

Thanks for testing,

--=20
Thomas
