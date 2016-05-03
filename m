Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <5727CE13.6090308@linux.intel.com>
References: <1462225276-106993-1-git-send-email-thgarnie@google.com>
	<1462225276-106993-4-git-send-email-thgarnie@google.com>
	<5727CE13.6090308@linux.intel.com>
Date: Tue, 3 May 2016 12:16:39 -0700
Message-ID: <CAJcbSZFcTuBq4TAzt12Qd1crhZhjQdbhd5_BOi3BijxZ0jo6Pg@mail.gmail.com>
From: Thomas Garnier <thgarnie@google.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [PATCH v2 3/4] x86, boot: Implement ASLR for kernel memory
 sections (x86_64)
To: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Kees Cook <keescook@chromium.org>, Stephen Smalley <sds@tycho.nsa.gov>, Kefeng Wang <wangkefeng.wang@huawei.com>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, Toshi Kani <toshi.kani@hpe.com>, Alexander Kuleshov <kuleshovmail@gmail.com>, Alexander Popov <alpopov@ptsecurity.com>, Joerg Roedel <jroedel@suse.de>, Dave Young <dyoung@redhat.com>, Baoquan He <bhe@redhat.com>, Mark Salter <msalter@redhat.com>, Boris Ostrovsky <boris.ostrovsky@oracle.com>, x86@kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, Greg Thelen <gthelen@google.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

I don't see much difference. I will update the commits on next
iteration with the following:

Kernbench shows almost no difference (-+ less than 1%):

Before:

Average Optimal load -j 12 Run (std deviation):
Elapsed Time 102.63 (1.2695)
User Time 1034.89 (1.18115)
System Time 87.056 (0.456416)
Percent CPU 1092.9 (13.892)
Context Switches 199805 (3455.33)
Sleeps 97907.8 (900.636)

After:

Average Optimal load -j 12 Run (std deviation):
Elapsed Time 102.489 (1.10636)
User Time 1034.86 (1.36053)
System Time 87.764 (0.49345)
Percent CPU 1095 (12.7715)
Context Switches 199036 (4298.1)
Sleeps 97681.6 (1031.11)

Hackbench shows 0% difference on average (hackbench 90 repeated 10 times)

attemp,before,after
1,0.076,0.069
2,0.072,0.069
3,0.066,0.066
4,0.066,0.068
5,0.066,0.067
6,0.066,0.069
7,0.067,0.066
8,0.063,0.067
9,0.067,0.065
10,0.068,0.071
average,0.0677,0.0677

Thanks,
Thomas

On Mon, May 2, 2016 at 3:00 PM, Dave Hansen <dave.hansen@linux.intel.com> wrote:
> On 05/02/2016 02:41 PM, Thomas Garnier wrote:
>> -#define __PAGE_OFFSET           _AC(0xffff880000000000, UL)
>> +#define __PAGE_OFFSET_BASE      _AC(0xffff880000000000, UL)
>> +#ifdef CONFIG_RANDOMIZE_MEMORY
>> +#define __PAGE_OFFSET           page_offset_base
>> +#else
>> +#define __PAGE_OFFSET           __PAGE_OFFSET_BASE
>> +#endif /* CONFIG_RANDOMIZE_MEMORY */
>
> Do you have any data about the performance impact of this change?  It's
> not necessary to have it to merge something like this, I'm just curious
> how bad it is.
