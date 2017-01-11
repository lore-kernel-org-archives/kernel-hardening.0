Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAHgaXd+WRWZ4gOzdjhGTG29gtsujUEoBQOKYwEc0fKus1AP4Zw@mail.gmail.com>
References: <CAHgaXdKW4=y-PviWudtMAThuB=GEW-73RejSHRMYNVzLyxP+iA@mail.gmail.com>
 <CAGXu5jLA+ri_RwWSOoZwAtv6a6pXL_EzUx6BZ0Mmc-n0+We9vg@mail.gmail.com>
 <CAHgaXdLPLCiggTrKGcFZzmGiBUmdmNGAt0_nO9BS5aGoP=bVmw@mail.gmail.com>
 <CAGXu5jJofXU-KsZ+1vxHHKHQFcVv5YSi1wtx3DR0sAZto-NvsQ@mail.gmail.com>
 <CAHgaXdJ_kTp7u1tEr4VTLyw7nVyz_L5P7WcuO2=WLtpE_CdeKw@mail.gmail.com>
 <CAGXu5jJEtLuvotLpBFS9yP2nt5rRtxsmFSJO31Jnc==-XFS1ig@mail.gmail.com>
 <CAHgaXdKrA4ZkK3rWA8eH4PzdvTHb2LeWfDX-PL159OapX1_WDA@mail.gmail.com>
 <578603BA.3000700@iogearbox.net> <CAHgaXd+WRWZ4gOzdjhGTG29gtsujUEoBQOKYwEc0fKus1AP4Zw@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 11 Jan 2017 13:29:34 -0800
Message-ID: <CAGXu5jKVUJg1QQqTodjg6HLMZdHEV7TqS5kodzS9E7VnWc3uWA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Subject: Re: [kernel-hardening] Looking for something to WORK ON
To: Shubham Bansal <illusionist.neo@gmail.com>
Cc: Daniel Borkmann <daniel@iogearbox.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Reshetova, Elena" <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Jan 11, 2017 at 4:46 AM, Shubham Bansal
<illusionist.neo@gmail.com> wrote:
>
> On Wed, Jul 13, 2016 at 2:32 PM, Daniel Borkmann <daniel@iogearbox.net>
> wrote:
>> Feel free to check out slides etc that are mostly located here:
>>
>>   https://github.com/iovisor/bpf-docs
>>
>> Also, Documentation/networking/filter.txt in the kernel tree provides some
>> info as a starting point, an example of eBPF JIT can be found here
>> arch/x86/net/
>> in kernel tree.
>>
>> To give you a basic overview what JITs are still classic BPF (cBPF) ones:
>>
>> $ git grep -n "select HAVE_CBPF_JIT"
>> arch/arm/Kconfig:44:    select HAVE_CBPF_JIT
>> arch/mips/Kconfig:18:   select HAVE_CBPF_JIT if !CPU_MICROMIPS
>> arch/powerpc/Kconfig:131:       select HAVE_CBPF_JIT if CPU_BIG_ENDIAN
>> arch/sparc/Kconfig:35:  select HAVE_CBPF_JIT
>>
>> ... and which are eBPF (ppc64 one should get merged next window I
>> believe):
>>
>> $ git grep -n "select HAVE_EBPF_JIT"
>> arch/arm64/Kconfig:64:  select HAVE_EBPF_JIT
>> arch/s390/Kconfig:131:  select HAVE_EBPF_JIT if PACK_STACK &&
>> HAVE_MARCH_Z196_FEATURES
>> arch/x86/Kconfig:94:    select HAVE_EBPF_JIT                    if X86_64
>>
>> Cheers,
>> Daniel
>
> Hi Daniel,
>
> I have read about the EBPF and BFP. I wanted to start contributing. Do you
> have any place for me to start with ?
> I mailed you regarding the same few months ago but didn't get the reply.

Daniel may have more ideas, but I would say taking a CBPF jit and
converting it to an EBPF jit would be the best thing to start with.

Doing ARM first might be easiest to tackle?

-Kees

-- 
Kees Cook
Nexus Security
