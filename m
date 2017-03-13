MIME-Version: 1.0
In-Reply-To: <f2230734-a13f-6c0d-8a01-15fd4408e799@oracle.com>
References: <20170306220348.79702-1-thgarnie@google.com> <20170306220348.79702-2-thgarnie@google.com>
 <CALCETrVXHc-EAhBtdhL9FXSW1G2VbohRY4UJuOtpRG1K0Q-Ogg@mail.gmail.com>
 <17ffcc5b-1c9a-51b6-272a-5eaecf1bc0c4@citrix.com> <CALCETrWv-u7OdjWDY+5eF7p-ngPun-yYf0QegMzYc6MGVQd-4w@mail.gmail.com>
 <CAJcbSZExVWA0jvAoxLLc+58Ag9cHchifrHP=fFfzU_onHo2PyA@mail.gmail.com>
 <5cf31779-45c5-d37f-86bc-d5afb3fb7ab6@oracle.com> <51c23e92-d1f0-427f-e069-c92fc4ed6226@oracle.com>
 <CAJcbSZEnUBfLHjf+bHqY0JQhQXD9urX45BXrQjx=1=A5gPpp_w@mail.gmail.com>
 <36579cc4-05e7-a448-767c-b9ad940362fc@oracle.com> <f2230734-a13f-6c0d-8a01-15fd4408e799@oracle.com>
From: Thomas Garnier <thgarnie@google.com>
Date: Mon, 13 Mar 2017 12:24:21 -0700
Message-ID: <CAJcbSZG75_cHxWp2eJ+XPiKZMbf2NNGwoS+8qkmXQ=rH2FURCQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [Xen-devel] [PATCH v5 2/3] x86: Remap GDT tables in the Fixmap section
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: Michal Hocko <mhocko@suse.com>, Stanislaw Gruszka <sgruszka@redhat.com>, kvm list <kvm@vger.kernel.org>, "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>, Matt Fleming <matt@codeblueprint.co.uk>, Frederic Weisbecker <fweisbec@gmail.com>, Josh Poimboeuf <jpoimboe@redhat.com>, Chris Wilson <chris@chris-wilson.co.uk>, "linux-mm@kvack.org" <linux-mm@kvack.org>, Dave Hansen <dave.hansen@intel.com>, =?UTF-8?B?UmFkaW0gS3LEjW3DocWZ?= <rkrcmar@redhat.com>, "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>, Alexander Potapenko <glider@google.com>, Pavel Machek <pavel@ucw.cz>, "H . Peter Anvin" <hpa@zytor.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Jiri Olsa <jolsa@redhat.com>, zijun_hu <zijun_hu@htc.com>, Prarit Bhargava <prarit@redhat.com>, Andi Kleen <ak@linux.intel.com>, Len Brown <len.brown@intel.com>, Jonathan Corbet <corbet@lwn.net>, Michael Ellerman <mpe@ellerman.id.au>, Joerg Roedel <joro@8bytes.org>, X86 ML <x86@kernel.org>, "Luis R . Rodriguez" <mcgrof@kernel.org>, kasan-dev <kasan-dev@googlegroups.com>, Christian Borntraeger <borntraeger@de.ibm.com>, Ingo Molnar <mingo@redhat.com>, "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>, Borislav Petkov <bp@suse.de>, Fenghua Yu <fenghua.yu@intel.com>, Jiri Kosina <jikos@kernel.org>, Kees Cook <keescook@chromium.org>, Arnd Bergmann <arnd@arndb.de>, He Chen <he.chen@linux.intel.com>, Brian Gerst <brgerst@gmail.com>, Rusty Russell <rusty@rustcorp.com.au>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, lguest@lists.ozlabs.org, Andy Lutomirski <luto@kernel.org>, Andrey Ryabinin <aryabinin@virtuozzo.com>, Thomas Gleixner <tglx@linutronix.de>, Andrew Morton <akpm@linux-foundation.org>, Dmitry Vyukov <dvyukov@google.com>, Juergen Gross <jgross@suse.com>, Lorenzo Stoakes <lstoakes@gmail.com>, Paul Gortmaker <paul.gortmaker@windriver.com>, Andrew Cooper <andrew.cooper3@citrix.com>, "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, "Rafael J . Wysocki" <rjw@rjwysocki.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Andy Lutomirski <luto@amacapital.net>, Peter Zijlstra <peterz@infradead.org>, Paolo Bonzini <pbonzini@redhat.com>, Vitaly Kuznetsov <vkuznets@redhat.com>, Tim Chen <tim.c.chen@linux.intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Mar 13, 2017 at 11:32 AM, Boris Ostrovsky
<boris.ostrovsky@oracle.com> wrote:
> There are a couple of problems for Xen PV guests that need to be addressed:
> 1. Xen's set_fixmap op needs non-default handling for
> FIX_GDT_REMAP_BEGIN range
> 2. GDT remapping for PV guests needs to be RO for both 64 and 32-bit guests.
>
> I don't know how you prefer to deal with (2), patch below is one
> suggestion. With it all my boot tests (Xen and bare-metal) passed.
>

Good suggestion, I think I will use most of it. Thanks!

> One problem with applying it directly is that kernel becomes
> not-bisectable (Xen-wise) between patches 2 and 3 so perhaps you might
> pull some of the changes from patch 3 to patch 2.
>

Yes that make sense, I will have to add the global variable on patch 2
and rebase 3 correctly.

-- 
Thomas
