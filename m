Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <20160809160305.GF30880@suse.de>
References: <1470681607-36883-1-git-send-email-thgarnie@google.com>
 <CAJcbSZFOMJkXNJX-eMCgyesp71+j+MZTteuS9gBUjpHL=u_sZA@mail.gmail.com> <20160809160305.GF30880@suse.de>
From: Thomas Garnier <thgarnie@google.com>
Date: Tue, 9 Aug 2016 09:30:41 -0700
Message-ID: <CAJcbSZFM6gqUFL2o74AEQqf=jrATgP0cYhgVNVLC0iw+L4YOMQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v1 1/2] x86/KASLR: Fix physical memory calculation on
 KASLR memory randomization
To: Joerg Roedel <jroedel@suse.de>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@suse.de>, Dave Young <dyoung@redhat.com>, "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>, Lv Zheng <lv.zheng@intel.com>, Baoquan He <bhe@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mark Salter <msalter@redhat.com>, Aleksey Makarov <aleksey.makarov@linaro.org>, Kees Cook <keescook@chromium.org>, Andrew Morton <akpm@linux-foundation.org>, Christian Borntraeger <borntraeger@de.ibm.com>, Fabian Frederick <fabf@skynet.be>, Toshi Kani <toshi.kani@hp.com>, Dan Williams <dan.j.williams@intel.com>, the arch/x86 maintainers <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Aug 9, 2016 at 9:03 AM, Joerg Roedel <jroedel@suse.de> wrote:
> On Tue, Aug 09, 2016 at 09:00:04AM -0700, Thomas Garnier wrote:
>> On Mon, Aug 8, 2016 at 11:40 AM, Thomas Garnier <thgarnie@google.com> wrote:
>> > Initialize KASLR memory randomization after max_pfn is initialized. Also
>> > ensure the size is rounded up. Could have create problems on machines
>> > with more than 1Tb of memory on certain random addresses.
>> >
>> > Signed-off-by: Thomas Garnier <thgarnie@google.com>
>>
>> I will send a new version of this PATCH soon. The test bot found
>> places where virtual addresses were computed before PAGE_OFFSET was
>> set. I will investigate that.
>
> When you do that, please also add 'Fixes:' tags to your patches.
>

Will do.

> Thanks,
>
>         Joerg
>
