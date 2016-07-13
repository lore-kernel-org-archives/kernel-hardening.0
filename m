Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <578603BA.3000700@iogearbox.net>
Date: Wed, 13 Jul 2016 11:02:50 +0200
From: Daniel Borkmann <daniel@iogearbox.net>
MIME-Version: 1.0
References: <CAHgaXdKW4=y-PviWudtMAThuB=GEW-73RejSHRMYNVzLyxP+iA@mail.gmail.com> <CAGXu5jLA+ri_RwWSOoZwAtv6a6pXL_EzUx6BZ0Mmc-n0+We9vg@mail.gmail.com> <CAHgaXdLPLCiggTrKGcFZzmGiBUmdmNGAt0_nO9BS5aGoP=bVmw@mail.gmail.com> <CAGXu5jJofXU-KsZ+1vxHHKHQFcVv5YSi1wtx3DR0sAZto-NvsQ@mail.gmail.com> <CAHgaXdJ_kTp7u1tEr4VTLyw7nVyz_L5P7WcuO2=WLtpE_CdeKw@mail.gmail.com> <CAGXu5jJEtLuvotLpBFS9yP2nt5rRtxsmFSJO31Jnc==-XFS1ig@mail.gmail.com> <CAHgaXdKrA4ZkK3rWA8eH4PzdvTHb2LeWfDX-PL159OapX1_WDA@mail.gmail.com>
In-Reply-To: <CAHgaXdKrA4ZkK3rWA8eH4PzdvTHb2LeWfDX-PL159OapX1_WDA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: Re: [kernel-hardening] Looking for something to WORK ON
To: Shubham Bansal <illusionist.neo@gmail.com>, Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Reshetova, Elena" <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

Hi Shubham,

On 07/13/2016 09:37 AM, Shubham Bansal wrote:
> Hi,
>
>> So overall I have 3 options :
>>>
>>> PaX's UDEREF feature - I want to work on this if its needed
>>
>> This is a large project.
>>
> I am happy to do it. Do you have anything where I can start ? I might need
> someone who could guide me through it. It would be great if you could.
>
>>
>>> PAN emulation on ARMv8.0 - My second preference would be this.
>>
>> This sounds like it requires more research?
>>
>>> Convert remaining BPF JITs to eBPF JIT (with blinding) - Happy to do it
>> if
>>> need
>>
>> I think this has value and there are folks that can help direct you
>> through this. Since you're new to kernel development, maybe start here
>> to get a sense of the amount of work needed, and then go from there?
>>
> Okay. I will start here. I will keep the PAX's UDREF feature in the
> background and start working on this. I will reach out to Daniel Borkmann
> and Elena Reshetova for the starting pointers.

Feel free to check out slides etc that are mostly located here:

   https://github.com/iovisor/bpf-docs

Also, Documentation/networking/filter.txt in the kernel tree provides some
info as a starting point, an example of eBPF JIT can be found here arch/x86/net/
in kernel tree.

To give you a basic overview what JITs are still classic BPF (cBPF) ones:

$ git grep -n "select HAVE_CBPF_JIT"
arch/arm/Kconfig:44:    select HAVE_CBPF_JIT
arch/mips/Kconfig:18:   select HAVE_CBPF_JIT if !CPU_MICROMIPS
arch/powerpc/Kconfig:131:       select HAVE_CBPF_JIT if CPU_BIG_ENDIAN
arch/sparc/Kconfig:35:  select HAVE_CBPF_JIT

... and which are eBPF (ppc64 one should get merged next window I believe):

$ git grep -n "select HAVE_EBPF_JIT"
arch/arm64/Kconfig:64:  select HAVE_EBPF_JIT
arch/s390/Kconfig:131:  select HAVE_EBPF_JIT if PACK_STACK && HAVE_MARCH_Z196_FEATURES
arch/x86/Kconfig:94:    select HAVE_EBPF_JIT                    if X86_64

Cheers,
Daniel
