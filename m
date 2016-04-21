Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <B3357B98-5869-4E91-AE1D-20DFB8654E7F@zytor.com>
References: <1460757793-59020-1-git-send-email-thgarnie@google.com>
	<1460757793-59020-4-git-send-email-thgarnie@google.com>
	<5718D5F0.8010501@oracle.com>
	<9AF9DCC7-8FC4-4A93-B75A-C07B8CD9023A@zytor.com>
	<CAJcbSZHoP-B1VD9jkxH_Ma8sy+F9uYYQeormi47VeRSq3qhSOw@mail.gmail.com>
	<B3357B98-5869-4E91-AE1D-20DFB8654E7F@zytor.com>
Date: Thu, 21 Apr 2016 13:18:48 -0700
Message-ID: <CAJcbSZGagfC7GLvSczPmZDXfsUJVc+bv2CWT1Subh5uCBJF7+g@mail.gmail.com>
From: Thomas Garnier <thgarnie@google.com>
Content-Type: text/plain; charset=UTF-8
Subject: [kernel-hardening] Re: [RFC v1 3/4] x86, boot: Implement ASLR for kernel memory sections (x86_64)
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Boris Ostrovsky <boris.ostrovsky@oracle.com>, Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@suse.de>, Andy Lutomirski <luto@kernel.org>, Dmitry Vyukov <dvyukov@google.com>, Paolo Bonzini <pbonzini@redhat.com>, Dan Williams <dan.j.williams@intel.com>, Kees Cook <keescook@chromium.org>, Stephen Smalley <sds@tycho.nsa.gov>, Seth Jennings <sjennings@variantweb.net>, Kefeng Wang <wangkefeng.wang@huawei.com>, Jonathan Corbet <corbet@lwn.net>, Matt Fleming <matt@codeblueprint.co.uk>, Toshi Kani <toshi.kani@hpe.com>, Alexander Kuleshov <kuleshovmail@gmail.com>, Alexander Popov <alpopov@ptsecurity.com>, Joerg Roedel <jroedel@suse.de>, Dave Young <dyoung@redhat.com>, Baoquan He <bhe@redhat.com>, Dave Hansen <dave.hansen@linux.intel.com>, Mark Salter <msalter@redhat.com>, x86@kernel.org, LKML <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, Greg Thelen <gthelen@google.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Make sense, thanks for the details.

On Thu, Apr 21, 2016 at 1:15 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On April 21, 2016 8:52:01 AM PDT, Thomas Garnier <thgarnie@google.com> wrote:
>>On Thu, Apr 21, 2016 at 8:46 AM, H. Peter Anvin <hpa@zytor.com> wrote:
>>> On April 21, 2016 6:30:24 AM PDT, Boris Ostrovsky
>><boris.ostrovsky@oracle.com> wrote:
>>>>
>>>>
>>>>On 04/15/2016 06:03 PM, Thomas Garnier wrote:
>>>>> +void __init kernel_randomize_memory(void)
>>>>> +{
>>>>> +    size_t i;
>>>>> +    unsigned long addr = memory_rand_start;
>>>>> +    unsigned long padding, rand, mem_tb;
>>>>> +    struct rnd_state rnd_st;
>>>>> +    unsigned long remain_padding = memory_rand_end -
>>memory_rand_start;
>>>>> +
>>>>> +    if (!kaslr_enabled())
>>>>> +            return;
>>>>> +
>>>>> +    /* Take the additional space when Xen is not active. */
>>>>> +    if (!xen_domain())
>>>>> +            page_offset_base -= __XEN_SPACE;
>>>>
>>>>This should be !xen_pv_domain(). Xen HVM guests are no different from
>>>>bare metal as far as address ranges are concerned. (Technically it's
>>>>probably !xen_pv_domain() && !xen_pvh_domain() but we can ignore PVH
>>>>for
>>>>now since it is being replaced by an HVM-type guest)
>>>>
>>>>Having said that, I am not sure I understand why page_offset_base is
>>>>shifted. I thought 0xffff800000000000 - 0xffff87ffffffffff is not
>>>>supposed to be used by anyone, whether we are running under a
>>>>hypervisor
>>>>or not.
>>>>
>>>>-boris
>>>
>>> That range is reserved for the hypervisor use.
>>
>>I know, I thought I could use it if no hypervisor was used but might
>>introduce problems in the future so I will remove it for the next
>>iteration.
>>
>>> --
>>> Sent from my Android device with K-9 Mail. Please excuse brevity and
>>formatting.
>
> At least in theory the hypervisor can use it even though no PV architecture is advertised to the kernel.  One kind of would hope none would.
>
> I think this range is also used by the kernel pointer checking thing, as it *has* to live right next to the canonical boundary.
> --
> Sent from my Android device with K-9 Mail. Please excuse brevity and formatting.
