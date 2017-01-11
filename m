Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAGXu5jKVUJg1QQqTodjg6HLMZdHEV7TqS5kodzS9E7VnWc3uWA@mail.gmail.com>
References: <CAHgaXdKW4=y-PviWudtMAThuB=GEW-73RejSHRMYNVzLyxP+iA@mail.gmail.com>
 <CAGXu5jLA+ri_RwWSOoZwAtv6a6pXL_EzUx6BZ0Mmc-n0+We9vg@mail.gmail.com>
 <CAHgaXdLPLCiggTrKGcFZzmGiBUmdmNGAt0_nO9BS5aGoP=bVmw@mail.gmail.com>
 <CAGXu5jJofXU-KsZ+1vxHHKHQFcVv5YSi1wtx3DR0sAZto-NvsQ@mail.gmail.com>
 <CAHgaXdJ_kTp7u1tEr4VTLyw7nVyz_L5P7WcuO2=WLtpE_CdeKw@mail.gmail.com>
 <CAGXu5jJEtLuvotLpBFS9yP2nt5rRtxsmFSJO31Jnc==-XFS1ig@mail.gmail.com>
 <CAHgaXdKrA4ZkK3rWA8eH4PzdvTHb2LeWfDX-PL159OapX1_WDA@mail.gmail.com>
 <578603BA.3000700@iogearbox.net> <CAHgaXd+WRWZ4gOzdjhGTG29gtsujUEoBQOKYwEc0fKus1AP4Zw@mail.gmail.com>
 <CAGXu5jKVUJg1QQqTodjg6HLMZdHEV7TqS5kodzS9E7VnWc3uWA@mail.gmail.com>
From: Shubham Bansal <illusionist.neo@gmail.com>
Date: Thu, 12 Jan 2017 03:42:52 +0530
Message-ID: <CAHgaXdLA-mNQh3Tb-m2=uKKL3JYsstAvDsK3dp+d1TifrinioA@mail.gmail.com>
Content-Type: multipart/alternative; boundary=001a114c70ecf065160545d8e6db
Subject: Re: [kernel-hardening] Looking for something to WORK ON
To: Kees Cook <keescook@chromium.org>
Cc: kernel-hardening@lists.openwall.com, "Reshetova, Elena" <elena.reshetova@intel.com>, Daniel Borkmann <daniel@iogearbox.net>
List-ID: <kernel-hardening.lists.openwall.com>

--001a114c70ecf065160545d8e6db
Content-Type: text/plain; charset=UTF-8

Hi Kees,

I would have already started working on it since we last talked but before
that I wanted to check if anybody else is also not working on the same
thing. Otherwise it would be waste of time.

Anyways. I will start working on it. No point in postponing in.

Thanks,
Shubham

On Jan 12, 2017 2:59 AM, "Kees Cook" <keescook@chromium.org> wrote:

> On Wed, Jan 11, 2017 at 4:46 AM, Shubham Bansal
> <illusionist.neo@gmail.com> wrote:
> >
> > On Wed, Jul 13, 2016 at 2:32 PM, Daniel Borkmann <daniel@iogearbox.net>
> > wrote:
> >> Feel free to check out slides etc that are mostly located here:
> >>
> >>   https://github.com/iovisor/bpf-docs
> >>
> >> Also, Documentation/networking/filter.txt in the kernel tree provides
> some
> >> info as a starting point, an example of eBPF JIT can be found here
> >> arch/x86/net/
> >> in kernel tree.
> >>
> >> To give you a basic overview what JITs are still classic BPF (cBPF)
> ones:
> >>
> >> $ git grep -n "select HAVE_CBPF_JIT"
> >> arch/arm/Kconfig:44:    select HAVE_CBPF_JIT
> >> arch/mips/Kconfig:18:   select HAVE_CBPF_JIT if !CPU_MICROMIPS
> >> arch/powerpc/Kconfig:131:       select HAVE_CBPF_JIT if CPU_BIG_ENDIAN
> >> arch/sparc/Kconfig:35:  select HAVE_CBPF_JIT
> >>
> >> ... and which are eBPF (ppc64 one should get merged next window I
> >> believe):
> >>
> >> $ git grep -n "select HAVE_EBPF_JIT"
> >> arch/arm64/Kconfig:64:  select HAVE_EBPF_JIT
> >> arch/s390/Kconfig:131:  select HAVE_EBPF_JIT if PACK_STACK &&
> >> HAVE_MARCH_Z196_FEATURES
> >> arch/x86/Kconfig:94:    select HAVE_EBPF_JIT                    if
> X86_64
> >>
> >> Cheers,
> >> Daniel
> >
> > Hi Daniel,
> >
> > I have read about the EBPF and BFP. I wanted to start contributing. Do
> you
> > have any place for me to start with ?
> > I mailed you regarding the same few months ago but didn't get the reply.
>
> Daniel may have more ideas, but I would say taking a CBPF jit and
> converting it to an EBPF jit would be the best thing to start with.
>
> Doing ARM first might be easiest to tackle?
>
> -Kees
>
> --
> Kees Cook
> Nexus Security
>

--001a114c70ecf065160545d8e6db
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto">Hi Kees,<div dir=3D"auto"><br></div><div dir=3D"auto">I w=
ould have already started working on it since we last talked but before tha=
t I wanted to check if anybody else is also not working on the same thing. =
Otherwise it would be waste of time.</div><div dir=3D"auto"><br></div><div =
dir=3D"auto">Anyways. I will start working on it. No point in postponing in=
.</div><div dir=3D"auto"><br></div><div dir=3D"auto">Thanks,</div><div dir=
=3D"auto">Shubham</div></div><div class=3D"gmail_extra"><br><div class=3D"g=
mail_quote">On Jan 12, 2017 2:59 AM, &quot;Kees Cook&quot; &lt;<a href=3D"m=
ailto:keescook@chromium.org">keescook@chromium.org</a>&gt; wrote:<br type=
=3D"attribution"><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8=
ex;border-left:1px #ccc solid;padding-left:1ex">On Wed, Jan 11, 2017 at 4:4=
6 AM, Shubham Bansal<br>
&lt;<a href=3D"mailto:illusionist.neo@gmail.com">illusionist.neo@gmail.com<=
/a>&gt; wrote:<br>
&gt;<br>
&gt; On Wed, Jul 13, 2016 at 2:32 PM, Daniel Borkmann &lt;<a href=3D"mailto=
:daniel@iogearbox.net">daniel@iogearbox.net</a>&gt;<br>
&gt; wrote:<br>
&gt;&gt; Feel free to check out slides etc that are mostly located here:<br=
>
&gt;&gt;<br>
&gt;&gt;=C2=A0 =C2=A0<a href=3D"https://github.com/iovisor/bpf-docs" rel=3D=
"noreferrer" target=3D"_blank">https://github.com/iovisor/<wbr>bpf-docs</a>=
<br>
&gt;&gt;<br>
&gt;&gt; Also, Documentation/networking/<wbr>filter.txt in the kernel tree =
provides some<br>
&gt;&gt; info as a starting point, an example of eBPF JIT can be found here=
<br>
&gt;&gt; arch/x86/net/<br>
&gt;&gt; in kernel tree.<br>
&gt;&gt;<br>
&gt;&gt; To give you a basic overview what JITs are still classic BPF (cBPF=
) ones:<br>
&gt;&gt;<br>
&gt;&gt; $ git grep -n &quot;select HAVE_CBPF_JIT&quot;<br>
&gt;&gt; arch/arm/Kconfig:44:=C2=A0 =C2=A0 select HAVE_CBPF_JIT<br>
&gt;&gt; arch/mips/Kconfig:18:=C2=A0 =C2=A0select HAVE_CBPF_JIT if !CPU_MIC=
ROMIPS<br>
&gt;&gt; arch/powerpc/Kconfig:131:=C2=A0 =C2=A0 =C2=A0 =C2=A0select HAVE_CB=
PF_JIT if CPU_BIG_ENDIAN<br>
&gt;&gt; arch/sparc/Kconfig:35:=C2=A0 select HAVE_CBPF_JIT<br>
&gt;&gt;<br>
&gt;&gt; ... and which are eBPF (ppc64 one should get merged next window I<=
br>
&gt;&gt; believe):<br>
&gt;&gt;<br>
&gt;&gt; $ git grep -n &quot;select HAVE_EBPF_JIT&quot;<br>
&gt;&gt; arch/arm64/Kconfig:64:=C2=A0 select HAVE_EBPF_JIT<br>
&gt;&gt; arch/s390/Kconfig:131:=C2=A0 select HAVE_EBPF_JIT if PACK_STACK &a=
mp;&amp;<br>
&gt;&gt; HAVE_MARCH_Z196_FEATURES<br>
&gt;&gt; arch/x86/Kconfig:94:=C2=A0 =C2=A0 select HAVE_EBPF_JIT=C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 if X86_64<br>
&gt;&gt;<br>
&gt;&gt; Cheers,<br>
&gt;&gt; Daniel<br>
&gt;<br>
&gt; Hi Daniel,<br>
&gt;<br>
&gt; I have read about the EBPF and BFP. I wanted to start contributing. Do=
 you<br>
&gt; have any place for me to start with ?<br>
&gt; I mailed you regarding the same few months ago but didn&#39;t get the =
reply.<br>
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
</blockquote></div></div>

--001a114c70ecf065160545d8e6db--
