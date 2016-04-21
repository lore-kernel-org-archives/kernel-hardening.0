Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <5718D5F0.8010501@oracle.com>
References: <1460757793-59020-1-git-send-email-thgarnie@google.com>
	<1460757793-59020-4-git-send-email-thgarnie@google.com>
	<5718D5F0.8010501@oracle.com>
Date: Thu, 21 Apr 2016 08:11:32 -0700
Message-ID: <CAJcbSZFiz+QjRUuj6_aVusQFOdkm85_8VF_wqe6GqTJbMZ82Xg@mail.gmail.com>
From: Thomas Garnier <thgarnie@google.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC v1 3/4] x86, boot: Implement ASLR for kernel memory sections (x86_64)
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: "H . Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Kees Cook <keescook@chromium.org>, Stephen Smalley <sds@tycho.nsa.gov>, Seth Jennings <sjennings@variantweb.net>, Kefeng Wang <wangkefeng.wang@huawei.com>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, Toshi Kani <toshi.kani@hpe.com>, Alexander Kuleshov <kuleshovmail@gmail.com>, Alexander Popov <alpopov@ptsecurity.com>, Joerg Roedel <jroedel@suse.de>, Dave Young <dyoung@redhat.com>, Baoquan He <bhe@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mark Salter <msalter@redhat.com>, x86@kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, Greg Thelen <gthelen@google.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Apr 21, 2016 at 6:30 AM, Boris Ostrovsky
<boris.ostrovsky@oracle.com> wrote:
>
>
> On 04/15/2016 06:03 PM, Thomas Garnier wrote:
>>
>> +void __init kernel_randomize_memory(void)
>> +{
>> +       size_t i;
>> +       unsigned long addr = memory_rand_start;
>> +       unsigned long padding, rand, mem_tb;
>> +       struct rnd_state rnd_st;
>> +       unsigned long remain_padding = memory_rand_end -
>> memory_rand_start;
>> +
>> +       if (!kaslr_enabled())
>> +               return;
>> +
>> +       /* Take the additional space when Xen is not active. */
>> +       if (!xen_domain())
>> +               page_offset_base -= __XEN_SPACE;
>
>
> This should be !xen_pv_domain(). Xen HVM guests are no different from bare
> metal as far as address ranges are concerned. (Technically it's probably
> !xen_pv_domain() && !xen_pvh_domain() but we can ignore PVH for now since it
> is being replaced by an HVM-type guest)
>

In my test KASLR was disabled on Xen so I should just remove this
check. I kept it in case it might change in the future.

> Having said that, I am not sure I understand why page_offset_base is
> shifted. I thought 0xffff800000000000 - 0xffff87ffffffffff is not supposed
> to be used by anyone, whether we are running under a hypervisor or not.
>

It is shifted to get the most space possible, it increases the entropy
available. Do you know why we should not use 0xffff800000000000 -
0xffff87ffffffffff?

> -boris
>
>
