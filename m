Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <578603BA.3000700@iogearbox.net>
References: <CAHgaXdKW4=y-PviWudtMAThuB=GEW-73RejSHRMYNVzLyxP+iA@mail.gmail.com>
 <CAGXu5jLA+ri_RwWSOoZwAtv6a6pXL_EzUx6BZ0Mmc-n0+We9vg@mail.gmail.com>
 <CAHgaXdLPLCiggTrKGcFZzmGiBUmdmNGAt0_nO9BS5aGoP=bVmw@mail.gmail.com>
 <CAGXu5jJofXU-KsZ+1vxHHKHQFcVv5YSi1wtx3DR0sAZto-NvsQ@mail.gmail.com>
 <CAHgaXdJ_kTp7u1tEr4VTLyw7nVyz_L5P7WcuO2=WLtpE_CdeKw@mail.gmail.com>
 <CAGXu5jJEtLuvotLpBFS9yP2nt5rRtxsmFSJO31Jnc==-XFS1ig@mail.gmail.com>
 <CAHgaXdKrA4ZkK3rWA8eH4PzdvTHb2LeWfDX-PL159OapX1_WDA@mail.gmail.com> <578603BA.3000700@iogearbox.net>
From: Shubham Bansal <illusionist.neo@gmail.com>
Date: Wed, 11 Jan 2017 18:16:00 +0530
Message-ID: <CAHgaXd+WRWZ4gOzdjhGTG29gtsujUEoBQOKYwEc0fKus1AP4Zw@mail.gmail.com>
Content-Type: multipart/alternative; boundary=001a114116f29d9dca0545d0fb06
Subject: Re: [kernel-hardening] Looking for something to WORK ON
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: Kees Cook <keescook@chromium.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Reshetova, Elena" <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

--001a114116f29d9dca0545d0fb06
Content-Type: text/plain; charset=UTF-8

Hi Daniel,

I have read about the EBPF and BFP. I wanted to start contributing. Do you
have any place for me to start with ?
I mailed you regarding the same few months ago but didn't get the reply.

Best,
Shubham Bansal

On Wed, Jul 13, 2016 at 2:32 PM, Daniel Borkmann <daniel@iogearbox.net>
wrote:

> Hi Shubham,
>
> On 07/13/2016 09:37 AM, Shubham Bansal wrote:
>
>> Hi,
>>
>> So overall I have 3 options :
>>>
>>>>
>>>> PaX's UDEREF feature - I want to work on this if its needed
>>>>
>>>
>>> This is a large project.
>>>
>>> I am happy to do it. Do you have anything where I can start ? I might
>> need
>> someone who could guide me through it. It would be great if you could.
>>
>>
>>> PAN emulation on ARMv8.0 - My second preference would be this.
>>>>
>>>
>>> This sounds like it requires more research?
>>>
>>> Convert remaining BPF JITs to eBPF JIT (with blinding) - Happy to do it
>>>>
>>> if
>>>
>>>> need
>>>>
>>>
>>> I think this has value and there are folks that can help direct you
>>> through this. Since you're new to kernel development, maybe start here
>>> to get a sense of the amount of work needed, and then go from there?
>>>
>>> Okay. I will start here. I will keep the PAX's UDREF feature in the
>> background and start working on this. I will reach out to Daniel Borkmann
>> and Elena Reshetova for the starting pointers.
>>
>
> Feel free to check out slides etc that are mostly located here:
>
>   https://github.com/iovisor/bpf-docs
>
> Also, Documentation/networking/filter.txt in the kernel tree provides some
> info as a starting point, an example of eBPF JIT can be found here
> arch/x86/net/
> in kernel tree.
>
> To give you a basic overview what JITs are still classic BPF (cBPF) ones:
>
> $ git grep -n "select HAVE_CBPF_JIT"
> arch/arm/Kconfig:44:    select HAVE_CBPF_JIT
> arch/mips/Kconfig:18:   select HAVE_CBPF_JIT if !CPU_MICROMIPS
> arch/powerpc/Kconfig:131:       select HAVE_CBPF_JIT if CPU_BIG_ENDIAN
> arch/sparc/Kconfig:35:  select HAVE_CBPF_JIT
>
> ... and which are eBPF (ppc64 one should get merged next window I believe):
>
> $ git grep -n "select HAVE_EBPF_JIT"
> arch/arm64/Kconfig:64:  select HAVE_EBPF_JIT
> arch/s390/Kconfig:131:  select HAVE_EBPF_JIT if PACK_STACK &&
> HAVE_MARCH_Z196_FEATURES
> arch/x86/Kconfig:94:    select HAVE_EBPF_JIT                    if X86_64
>
> Cheers,
> Daniel
>

--001a114116f29d9dca0545d0fb06
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi Daniel,<div><br></div><div>I have read about the EBPF a=
nd BFP. I wanted to start contributing. Do you have any place for me to sta=
rt with ?</div><div>I mailed you regarding the same few months ago but didn=
&#39;t get the reply.</div><div class=3D"gmail_extra"><br clear=3D"all"><di=
v><div class=3D"gmail_signature" data-smartmail=3D"gmail_signature"><div di=
r=3D"ltr"><div>Best,<br></div>Shubham Bansal<br></div></div></div>
<br><div class=3D"gmail_quote">On Wed, Jul 13, 2016 at 2:32 PM, Daniel Bork=
mann <span dir=3D"ltr">&lt;<a href=3D"mailto:daniel@iogearbox.net" target=
=3D"_blank">daniel@iogearbox.net</a>&gt;</span> wrote:<br><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex">Hi Shubham,<span class=3D""><br>
<br>
On 07/13/2016 09:37 AM, Shubham Bansal wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
Hi,<br>
<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
So overall I have 3 options :<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
<br>
PaX&#39;s UDEREF feature - I want to work on this if its needed<br>
</blockquote>
<br>
This is a large project.<br>
<br>
</blockquote>
I am happy to do it. Do you have anything where I can start ? I might need<=
br>
someone who could guide me through it. It would be great if you could.<br>
<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
PAN emulation on ARMv8.0 - My second preference would be this.<br>
</blockquote>
<br>
This sounds like it requires more research?<br>
<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
Convert remaining BPF JITs to eBPF JIT (with blinding) - Happy to do it<br>
</blockquote>
if<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
need<br>
</blockquote>
<br>
I think this has value and there are folks that can help direct you<br>
through this. Since you&#39;re new to kernel development, maybe start here<=
br>
to get a sense of the amount of work needed, and then go from there?<br>
<br>
</blockquote>
Okay. I will start here. I will keep the PAX&#39;s UDREF feature in the<br>
background and start working on this. I will reach out to Daniel Borkmann<b=
r>
and Elena Reshetova for the starting pointers.<br>
</blockquote>
<br></span>
Feel free to check out slides etc that are mostly located here:<br>
<br>
=C2=A0 <a href=3D"https://github.com/iovisor/bpf-docs" rel=3D"noreferrer" t=
arget=3D"_blank">https://github.com/iovisor/bpf<wbr>-docs</a><br>
<br>
Also, Documentation/networking/filte<wbr>r.txt in the kernel tree provides =
some<br>
info as a starting point, an example of eBPF JIT can be found here arch/x86=
/net/<br>
in kernel tree.<br>
<br>
To give you a basic overview what JITs are still classic BPF (cBPF) ones:<b=
r>
<br>
$ git grep -n &quot;select HAVE_CBPF_JIT&quot;<br>
arch/arm/Kconfig:44:=C2=A0 =C2=A0 select HAVE_CBPF_JIT<br>
arch/mips/Kconfig:18:=C2=A0 =C2=A0select HAVE_CBPF_JIT if !CPU_MICROMIPS<br=
>
arch/powerpc/Kconfig:131:=C2=A0 =C2=A0 =C2=A0 =C2=A0select HAVE_CBPF_JIT if=
 CPU_BIG_ENDIAN<br>
arch/sparc/Kconfig:35:=C2=A0 select HAVE_CBPF_JIT<br>
<br>
... and which are eBPF (ppc64 one should get merged next window I believe):=
<br>
<br>
$ git grep -n &quot;select HAVE_EBPF_JIT&quot;<br>
arch/arm64/Kconfig:64:=C2=A0 select HAVE_EBPF_JIT<br>
arch/s390/Kconfig:131:=C2=A0 select HAVE_EBPF_JIT if PACK_STACK &amp;&amp; =
HAVE_MARCH_Z196_FEATURES<br>
arch/x86/Kconfig:94:=C2=A0 =C2=A0 select HAVE_EBPF_JIT=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if X86_64<br>
<br>
Cheers,<br>
Daniel<br>
</blockquote></div><br></div></div>

--001a114116f29d9dca0545d0fb06--
