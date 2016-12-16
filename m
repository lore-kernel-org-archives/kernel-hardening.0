Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <58544A55.7080301@iogearbox.net>
Date: Fri, 16 Dec 2016 21:11:01 +0100
From: Daniel Borkmann <daniel@iogearbox.net>
MIME-Version: 1.0
References: <CAGXu5jKW+fo38ZqNt8u8oW4igY6uRpyfLvU_wD9Aq2zzP0ZVig@mail.gmail.com> <585444eb.5d29c80a.fff37.d341@mx.google.com> <CAGXu5jJ=SzfLsLm=CS8FniYqRAntj+_1MH4g1=isHQ1t3rcb4Q@mail.gmail.com>
In-Reply-To: <CAGXu5jJ=SzfLsLm=CS8FniYqRAntj+_1MH4g1=isHQ1t3rcb4Q@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Working on lib/test_bpf.c tests for eBPF constant
 blinding
To: Kees Cook <keescook@chromium.org>, Sandra Escandor-O'Keefe <rvonflugel@gmail.com>
Cc: "Reshetova, Elena" <elena.reshetova@intel.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, alexei.starovoitov@gmail.com
List-ID: <kernel-hardening.lists.openwall.com>

On 12/16/2016 09:02 PM, Kees Cook wrote:
> On Fri, Dec 16, 2016 at 11:47 AM, Sandra Escandor-O'Keefe
> <rvonflugel@gmail.com> wrote:
>> Excellent! Thanks for pointing to that write-up. So, what I can do is get to the point where I can manually perform the test to check inserted constants in
>> eBPF instructions to verify that they are gone in the resulting eBPF JIT kernel code - this looks like I will first need to run the PoC attack that Elena created. From there, I'll have a better understanding of what to test.
>>
>> Would you approach it this way, or would you do something different?
>
> That sounds like how I'd start, yes. IIUC, you'll need to modify the
> kernel so you can see the JIT in some way (this is, I think, what's
> needed in test_ebpf.c), but I haven't looked at it very closely.
> Daniel may have suggestions.

If you're interested, you could ideally write a test suite for it under
existing tools/testing/selftests/bpf/. If you enable JIT in the mode
net.core.bpf_jit_enable=2, then you'll get the debug output dump in klog
and under tools/net/ you have bpf_jit_disasm tool that you could use to
examine it. This could likely be automated in a tool for various test
inputs, but probably needs to have some arch specific code to make sense
out of it. There's also lib/test_bpf.c, if it's not too much complexity,
something could also be placed there for checking the image directly.

>> Sandra
>>
>> Original Message
>> From: keescook@chromium.org
>> Sent: December 16, 2016 3:28 PM
>> To: rvonflugel@gmail.com
>> Cc: kernel-hardening@lists.openwall.com; elena.reshetova@intel.com; daniel@iogearbox.net
>> Subject: Re: [kernel-hardening] Working on lib/test_bpf.c tests for eBPF constant blinding
>
> As a side-note on email conventions, I'd recommend in-line replies and
> quoting, which makes technical discussion much easier to follow (i.e.
> don't top-post, etc).
>
> -Kees
>
>> On Fri, Dec 16, 2016 at 9:13 AM, Sandra Escandor-O'Keefe
>> <rvonflugel@gmail.com> wrote:
>>> I'm interested in starting on a bit of linux kernel development, and also
>>> contributing to something security related for the kernel. I was looking at
>>> the projects listed in the TODO of
>>> https://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project and "Write
>>> lib/test_bpf.c tests for eBPF constant blinding" caught my eye. Is this
>>> something that still needs to be done? If so, is there someone specific that
>>> I can reach out to in order to get some guidance on where to start?
>>
>> Hi! Welcome to the fun. :)
>>
>> I've added Elena and Daniel to CC, who both worked on the blinding.
>> The goal would be to add some kind of test that inserted constants in
>> eBPF instructions and then verified they were gone in the resulting
>> eBPF JIT kernel code. Until now, it's only been done manually, and
>> it'd be nice to have a test that could show if there were regressions
>> or if an architecture didn't support the blinding in its JIT.
>>
>> For some background on the blinding, I wrote a short description of it here:
>> https://outflux.net/blog/archives/2016/10/03/security-things-in-linux-v4-7/
>>
>> Let me know if that helps get you to a starting point! :)
>>
>> -Kees
>>
>> --
>> Kees Cook
>> Nexus Security
>
>
>
