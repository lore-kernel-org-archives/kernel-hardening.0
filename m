References: <20170306220348.79702-1-thgarnie@google.com>
 <20170306220348.79702-2-thgarnie@google.com>
 <CALCETrVXHc-EAhBtdhL9FXSW1G2VbohRY4UJuOtpRG1K0Q-Ogg@mail.gmail.com>
 <17ffcc5b-1c9a-51b6-272a-5eaecf1bc0c4@citrix.com>
 <CALCETrWv-u7OdjWDY+5eF7p-ngPun-yYf0QegMzYc6MGVQd-4w@mail.gmail.com>
 <CAJcbSZExVWA0jvAoxLLc+58Ag9cHchifrHP=fFfzU_onHo2PyA@mail.gmail.com>
 <5cf31779-45c5-d37f-86bc-d5afb3fb7ab6@oracle.com>
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <51c23e92-d1f0-427f-e069-c92fc4ed6226@oracle.com>
Date: Thu, 9 Mar 2017 17:13:40 -0500
MIME-Version: 1.0
In-Reply-To: <5cf31779-45c5-d37f-86bc-d5afb3fb7ab6@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Subject: [kernel-hardening] Re: [Xen-devel] [PATCH v5 2/3] x86: Remap GDT tables in the Fixmap
 section
To: Thomas Garnier <thgarnie@google.com>, Andy Lutomirski <luto@amacapital.net>
Cc: Andrew Cooper <andrew.cooper3@citrix.com>, Michal Hocko <mhocko@suse.com>, Stanislaw Gruszka <sgruszka@redhat.com>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, kvm list <kvm@vger.kernel.org>, Fenghua Yu <fenghua.yu@intel.com>, Matt Fleming <matt@codeblueprint.co.uk>, Frederic Weisbecker <fweisbec@gmail.com>, X86 ML <x86@kernel.org>, Chris Wilson <chris@chris-wilson.co.uk>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Paul Gortmaker <paul.gortmaker@windriver.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Alexander Potapenko <glider@google.com>, Pavel Machek <pavel@ucw.cz>, "H . Peter Anvin" <hpa@zytor.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Jiri Olsa <jolsa@redhat.com>, zijun_hu <zijun_hu@htc.com>, Dave Hansen <dave.hansen@intel.com>, Andi Kleen <ak@linux.intel.com>, "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>, Jonathan Corbet <corbet@lwn.net>, Michael Ellerman <mpe@ellerman.id.au>, Joerg Roedel <joro@8bytes.org>, Prarit Bhargava <prarit@redhat.com>, kasan-dev <kasan-dev@googlegroups.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Ingo Molnar <mingo@redhat.com>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Borislav Petkov <bp@suse.de>, Len Brown <len.brown@intel.com>, Rusty Russell <rusty@rustcorp.com.au>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, He Chen <he.chen@linux.intel.com>, Brian Gerst <brgerst@gmail.com>, Jiri Kosina <jikos@kernel.org>, lguest@lists.ozlabs.org, Andy Lutomirski <luto@kernel.org>, Josh Poimboeuf <jpoimboe@redhat.com>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Dmitry Vyukov <dvyukov@google.com>, Juergen Gross <jgross@suse.com>, Peter Zijlstra <peterz@infradead.org>, Lorenzo Stoakes <lstoakes@gmail.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Luis R . Rodriguez" <mcgrof@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, Tim Chen <tim.c.chen@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>


>> I don't have any experience with Xen so it would be great if virtme can test it.
>
> I am pretty sure I tested this series at some point but I'll test it again.
>


Fails 32-bit build:


/home/build/linux-boris/arch/x86/kvm/vmx.c: In function ‘segment_base’:
/home/build/linux-boris/arch/x86/kvm/vmx.c:2054: error: ‘host_gdt’
undeclared (first use in this function)
/home/build/linux-boris/arch/x86/kvm/vmx.c:2054: error: (Each undeclared
identifier is reported only once
/home/build/linux-boris/arch/x86/kvm/vmx.c:2054: error: for each
function it appears in.)
/home/build/linux-boris/arch/x86/kvm/vmx.c:2054: error: type defaults to
‘int’ in declaration of ‘type name’
/home/build/linux-boris/arch/x86/kvm/vmx.c:2054: error: type defaults to
‘int’ in declaration of ‘type name’
/home/build/linux-boris/arch/x86/kvm/vmx.c:2054: warning: initialization
from incompatible pointer type
/home/build/linux-boris/arch/x86/kvm/vmx.c:2054: warning: unused
variable ‘gdt’


-boris
