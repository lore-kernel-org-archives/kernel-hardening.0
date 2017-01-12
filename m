Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <5876B436.1040308@iogearbox.net>
References: <CAHgaXdKW4=y-PviWudtMAThuB=GEW-73RejSHRMYNVzLyxP+iA@mail.gmail.com>
 <CAGXu5jLA+ri_RwWSOoZwAtv6a6pXL_EzUx6BZ0Mmc-n0+We9vg@mail.gmail.com>
 <CAHgaXdLPLCiggTrKGcFZzmGiBUmdmNGAt0_nO9BS5aGoP=bVmw@mail.gmail.com>
 <CAGXu5jJofXU-KsZ+1vxHHKHQFcVv5YSi1wtx3DR0sAZto-NvsQ@mail.gmail.com>
 <CAHgaXdJ_kTp7u1tEr4VTLyw7nVyz_L5P7WcuO2=WLtpE_CdeKw@mail.gmail.com>
 <CAGXu5jJEtLuvotLpBFS9yP2nt5rRtxsmFSJO31Jnc==-XFS1ig@mail.gmail.com>
 <CAHgaXdKrA4ZkK3rWA8eH4PzdvTHb2LeWfDX-PL159OapX1_WDA@mail.gmail.com>
 <578603BA.3000700@iogearbox.net> <CAHgaXd+WRWZ4gOzdjhGTG29gtsujUEoBQOKYwEc0fKus1AP4Zw@mail.gmail.com>
 <CAGXu5jKVUJg1QQqTodjg6HLMZdHEV7TqS5kodzS9E7VnWc3uWA@mail.gmail.com>
 <CAHgaXdLA-mNQh3Tb-m2=uKKL3JYsstAvDsK3dp+d1TifrinioA@mail.gmail.com> <5876B436.1040308@iogearbox.net>
From: Shubham Bansal <illusionist.neo@gmail.com>
Date: Thu, 12 Jan 2017 21:49:44 +0530
Message-ID: <CAHgaXd+LVkPi0vwugCM30Lq9i3ivnRza2=5Fs_MuSFCZ6hK0Lw@mail.gmail.com>
Content-Type: multipart/alternative; boundary=001a114541ded6099c0545e81569
Subject: Re: [kernel-hardening] Looking for something to WORK ON
To: Daniel Borkmann <daniel@iogearbox.net>
Cc: Kees Cook <keescook@chromium.org>, kernel-hardening@lists.openwall.com, "Reshetova, Elena" <elena.reshetova@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

--001a114541ded6099c0545e81569
Content-Type: text/plain; charset=UTF-8

Great. I just started working on it.

Best,
Shubham Bansal

On Thu, Jan 12, 2017 at 4:09 AM, Daniel Borkmann <daniel@iogearbox.net>
wrote:

> On 01/11/2017 11:12 PM, Shubham Bansal wrote:
>
>> Hi Kees,
>>
>> I would have already started working on it since we last talked but before
>> that I wanted to check if anybody else is also not working on the same
>> thing. Otherwise it would be waste of time.
>>
>> Anyways. I will start working on it. No point in postponing in.
>>
>
> Very sorry for the late reply, Shubham, seems I missed your earlier email.
> :/
> Afaik, nobody is working on that, so would be nice to tackle this.
>
>
> On Jan 12, 2017 2:59 AM, "Kees Cook" <keescook@chromium.org> wrote:
>>
>> On Wed, Jan 11, 2017 at 4:46 AM, Shubham Bansal
>>> <illusionist.neo@gmail.com> wrote:
>>>
>>>>
>>>> On Wed, Jul 13, 2016 at 2:32 PM, Daniel Borkmann <daniel@iogearbox.net>
>>>> wrote:
>>>>
>>>>> Feel free to check out slides etc that are mostly located here:
>>>>>
>>>>>    https://github.com/iovisor/bpf-docs
>>>>>
>>>>> Also, Documentation/networking/filter.txt in the kernel tree provides
>>>>>
>>>> some
>>>
>>>> info as a starting point, an example of eBPF JIT can be found here
>>>>> arch/x86/net/
>>>>> in kernel tree.
>>>>>
>>>>> To give you a basic overview what JITs are still classic BPF (cBPF)
>>>>>
>>>> ones:
>>>
>>>>
>>>>> $ git grep -n "select HAVE_CBPF_JIT"
>>>>> arch/arm/Kconfig:44:    select HAVE_CBPF_JIT
>>>>> arch/mips/Kconfig:18:   select HAVE_CBPF_JIT if !CPU_MICROMIPS
>>>>> arch/powerpc/Kconfig:131:       select HAVE_CBPF_JIT if CPU_BIG_ENDIAN
>>>>> arch/sparc/Kconfig:35:  select HAVE_CBPF_JIT
>>>>>
>>>>> ... and which are eBPF (ppc64 one should get merged next window I
>>>>> believe):
>>>>>
>>>>> $ git grep -n "select HAVE_EBPF_JIT"
>>>>> arch/arm64/Kconfig:64:  select HAVE_EBPF_JIT
>>>>> arch/s390/Kconfig:131:  select HAVE_EBPF_JIT if PACK_STACK &&
>>>>> HAVE_MARCH_Z196_FEATURES
>>>>> arch/x86/Kconfig:94:    select HAVE_EBPF_JIT                    if
>>>>>
>>>> X86_64
>>>
>>>>
>>>>> Cheers,
>>>>> Daniel
>>>>>
>>>>
>>>> Hi Daniel,
>>>>
>>>> I have read about the EBPF and BFP. I wanted to start contributing. Do
>>>>
>>> you
>>>
>>>> have any place for me to start with ?
>>>> I mailed you regarding the same few months ago but didn't get the reply.
>>>>
>>>
>>> Daniel may have more ideas, but I would say taking a CBPF jit and
>>> converting it to an EBPF jit would be the best thing to start with.
>>>
>>> Doing ARM first might be easiest to tackle?
>>>
>>> -Kees
>>>
>>> --
>>> Kees Cook
>>> Nexus Security
>>>
>>>
>>
>

--001a114541ded6099c0545e81569
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Great. I just started working on it.</div><div class=3D"gm=
ail_extra"><br clear=3D"all"><div><div class=3D"gmail_signature" data-smart=
mail=3D"gmail_signature"><div dir=3D"ltr"><div>Best,<br></div>Shubham Bansa=
l<br></div></div></div>
<br><div class=3D"gmail_quote">On Thu, Jan 12, 2017 at 4:09 AM, Daniel Bork=
mann <span dir=3D"ltr">&lt;<a href=3D"mailto:daniel@iogearbox.net" target=
=3D"_blank">daniel@iogearbox.net</a>&gt;</span> wrote:<br><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex"><span class=3D"">On 01/11/2017 11:12 PM, Shubham Bansal wrote=
:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
Hi Kees,<br>
<br>
I would have already started working on it since we last talked but before<=
br>
that I wanted to check if anybody else is also not working on the same<br>
thing. Otherwise it would be waste of time.<br>
<br>
Anyways. I will start working on it. No point in postponing in.<br>
</blockquote>
<br></span>
Very sorry for the late reply, Shubham, seems I missed your earlier email. =
:/<br>
Afaik, nobody is working on that, so would be nice to tackle this.<div clas=
s=3D"HOEnZb"><div class=3D"h5"><br>
<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
On Jan 12, 2017 2:59 AM, &quot;Kees Cook&quot; &lt;<a href=3D"mailto:keesco=
ok@chromium.org" target=3D"_blank">keescook@chromium.org</a>&gt; wrote:<br>
<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
On Wed, Jan 11, 2017 at 4:46 AM, Shubham Bansal<br>
&lt;<a href=3D"mailto:illusionist.neo@gmail.com" target=3D"_blank">illusion=
ist.neo@gmail.com</a>&gt; wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
<br>
On Wed, Jul 13, 2016 at 2:32 PM, Daniel Borkmann &lt;<a href=3D"mailto:dani=
el@iogearbox.net" target=3D"_blank">daniel@iogearbox.net</a>&gt;<br>
wrote:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
Feel free to check out slides etc that are mostly located here:<br>
<br>
=C2=A0 =C2=A0<a href=3D"https://github.com/iovisor/bpf-docs" rel=3D"norefer=
rer" target=3D"_blank">https://github.com/iovisor/bp<wbr>f-docs</a><br>
<br>
Also, Documentation/networking/filte<wbr>r.txt in the kernel tree provides<=
br>
</blockquote></blockquote>
some<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><blockquote class=3D"gmail_quote" style=3D"m=
argin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
info as a starting point, an example of eBPF JIT can be found here<br>
arch/x86/net/<br>
in kernel tree.<br>
<br>
To give you a basic overview what JITs are still classic BPF (cBPF)<br>
</blockquote></blockquote>
ones:<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><blockquote class=3D"gmail_quote" style=3D"m=
argin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<br>
$ git grep -n &quot;select HAVE_CBPF_JIT&quot;<br>
arch/arm/Kconfig:44:=C2=A0 =C2=A0 select HAVE_CBPF_JIT<br>
arch/mips/Kconfig:18:=C2=A0 =C2=A0select HAVE_CBPF_JIT if !CPU_MICROMIPS<br=
>
arch/powerpc/Kconfig:131:=C2=A0 =C2=A0 =C2=A0 =C2=A0select HAVE_CBPF_JIT if=
 CPU_BIG_ENDIAN<br>
arch/sparc/Kconfig:35:=C2=A0 select HAVE_CBPF_JIT<br>
<br>
... and which are eBPF (ppc64 one should get merged next window I<br>
believe):<br>
<br>
$ git grep -n &quot;select HAVE_EBPF_JIT&quot;<br>
arch/arm64/Kconfig:64:=C2=A0 select HAVE_EBPF_JIT<br>
arch/s390/Kconfig:131:=C2=A0 select HAVE_EBPF_JIT if PACK_STACK &amp;&amp;<=
br>
HAVE_MARCH_Z196_FEATURES<br>
arch/x86/Kconfig:94:=C2=A0 =C2=A0 select HAVE_EBPF_JIT=C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if<br>
</blockquote></blockquote>
X86_64<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><blockquote class=3D"gmail_quote" style=3D"m=
argin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<br>
Cheers,<br>
Daniel<br>
</blockquote>
<br>
Hi Daniel,<br>
<br>
I have read about the EBPF and BFP. I wanted to start contributing. Do<br>
</blockquote>
you<br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
have any place for me to start with ?<br>
I mailed you regarding the same few months ago but didn&#39;t get the reply=
.<br>
</blockquote>
<br>
Daniel may have more ideas, but I would say taking a CBPF jit and<br>
converting it to an EBPF jit would be the best thing to start with.<br>
<br>
Doing ARM first might be easiest to tackle?<br>
<br>
-Kees<br>
<br>
--<br>
Kees Cook<br>
Nexus Security<br>
<br>
</blockquote>
<br>
</blockquote>
<br>
</div></div></blockquote></div><br></div>

--001a114541ded6099c0545e81569--
