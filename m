Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAGXu5jJEtLuvotLpBFS9yP2nt5rRtxsmFSJO31Jnc==-XFS1ig@mail.gmail.com>
References: <CAHgaXdKW4=y-PviWudtMAThuB=GEW-73RejSHRMYNVzLyxP+iA@mail.gmail.com>
 <CAGXu5jLA+ri_RwWSOoZwAtv6a6pXL_EzUx6BZ0Mmc-n0+We9vg@mail.gmail.com>
 <CAHgaXdLPLCiggTrKGcFZzmGiBUmdmNGAt0_nO9BS5aGoP=bVmw@mail.gmail.com>
 <CAGXu5jJofXU-KsZ+1vxHHKHQFcVv5YSi1wtx3DR0sAZto-NvsQ@mail.gmail.com>
 <CAHgaXdJ_kTp7u1tEr4VTLyw7nVyz_L5P7WcuO2=WLtpE_CdeKw@mail.gmail.com> <CAGXu5jJEtLuvotLpBFS9yP2nt5rRtxsmFSJO31Jnc==-XFS1ig@mail.gmail.com>
From: Shubham Bansal <illusionist.neo@gmail.com>
Date: Wed, 13 Jul 2016 13:07:07 +0530
Message-ID: <CAHgaXdKrA4ZkK3rWA8eH4PzdvTHb2LeWfDX-PL159OapX1_WDA@mail.gmail.com>
Content-Type: multipart/alternative; boundary=001a113e161ce39e1305377f7337
Subject: Re: [kernel-hardening] Looking for something to WORK ON
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Reshetova, Elena" <elena.reshetova@intel.com>, Daniel Borkmann <daniel@iogearbox.net>
List-ID: <kernel-hardening.lists.openwall.com>

--001a113e161ce39e1305377f7337
Content-Type: text/plain; charset=UTF-8

Hi,

> So overall I have 3 options :
> >
> > PaX's UDEREF feature - I want to work on this if its needed
>
> This is a large project.
>
I am happy to do it. Do you have anything where I can start ? I might need
someone who could guide me through it. It would be great if you could.

>
> > PAN emulation on ARMv8.0 - My second preference would be this.
>
> This sounds like it requires more research?
>
> > Convert remaining BPF JITs to eBPF JIT (with blinding) - Happy to do it
> if
> > need
>
> I think this has value and there are folks that can help direct you
> through this. Since you're new to kernel development, maybe start here
> to get a sense of the amount of work needed, and then go from there?
>
Okay. I will start here. I will keep the PAX's UDREF feature in the
background and start working on this. I will reach out to Daniel Borkmann
and Elena Reshetova for the starting pointers.

Daniel , Elena : Any update/help from your side is highly appreciated. If
you want I can start another thread with "Converting BPF JITs to eBPF JIT"
Subject, where we can discuss it.

Best,
Shubham Bansal

--001a113e161ce39e1305377f7337
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Hi,<div class=3D"gmail_extra"><div class=3D"gmail_quote"><=
span class=3D""></span><br><span class=3D""></span><blockquote class=3D"gma=
il_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,2=
04,204);padding-left:1ex"><span class=3D"">
&gt; So overall I have 3 options :<br>
&gt;<br>
&gt; PaX&#39;s UDEREF feature - I want to work on this if its needed<br>
<br>
</span>This is a large project.<br></blockquote><div>I am happy to do it. D=
o you have anything where I can start ? I might need someone who could guid=
e me through it. It would be great if you could.<br></div><blockquote class=
=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rg=
b(204,204,204);padding-left:1ex">
<span class=3D""><br>
&gt; PAN emulation on ARMv8.0 - My second preference would be this.<br>
<br>
</span>This sounds like it requires more research?<br>
<span class=3D""><br>
&gt; Convert remaining BPF JITs to eBPF JIT (with blinding) - Happy to do i=
t if<br>
&gt; need<br>
<br>
</span>I think this has value and there are folks that can help direct you<=
br>
through this. Since you&#39;re new to kernel development, maybe start here<=
br>
to get a sense of the amount of work needed, and then go from there?<br></b=
lockquote><div>Okay. I will start here. I will keep the PAX&#39;s UDREF fea=
ture in the background and start working on this. I will reach out to Danie=
l Borkmann and Elena Reshetova for the starting pointers.<br><br></div><div=
>Daniel , Elena : Any update/help from your side is highly appreciated. If =
you want I can start another thread with &quot;Converting BPF JITs to eBPF =
JIT&quot; Subject, where we can discuss it.<br></div><div><br></div><div>Be=
st,<br></div><div>Shubham Bansal<br></div></div><br></div></div>

--001a113e161ce39e1305377f7337--
