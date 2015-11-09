Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <5640E0DD.6040107@labbott.name>
References: <20151106235545.97d0e86a5f1f80c98e0e9de6@gmail.com>
	<CAGXu5jK2boq=rSwrdyqyq=B_kZJR2pUQe99+tPBwK+pKEx0X+w@mail.gmail.com>
	<563F4A78.21151.23C6852D@pageexec.freemail.hu>
	<5640E0DD.6040107@labbott.name>
Date: Mon, 9 Nov 2015 13:32:14 -0500
Message-ID: <CAGagf4diKzZ6WFemwsXYcdMt+LZMCnzA_QgjcAcL3Gu_0_Gttg@mail.gmail.com>
From: Theodore Tso <tytso@google.com>
Content-Type: multipart/alternative; boundary=001a114295d0f27b0205241fcff6
Subject: Re: [kernel-hardening] Re: Proposal for kernel self protection features
To: Laura Abbott <laura@labbott.name>
Cc: kernel-hardening@lists.openwall.com, Emese Revfy <re.emese@gmail.com>, Kees Cook <keescook@chromium.org>, PaX Team <pageexec@freemail.hu>, Brad Spengler <spender@grsecurity.net>, Greg KH <gregkh@linuxfoundation.org>, Josh Triplett <josh@joshtriplett.org>
List-ID: <kernel-hardening.lists.openwall.com>

--001a114295d0f27b0205241fcff6
Content-Type: text/plain; charset=UTF-8

On Mon, Nov 9, 2015 at 1:07 PM, Laura Abbott <laura@labbott.name> wrote:
>
>
> I took a look at something closely related sometime ago[1] for
> ARM DT based targets. The stack canary was always the same because
> it was early enough no entropy was being added and there's no standard
> RNG. This series proposed allowing entropy to be read out of the DT.
> This still relied on reliable entropy being added to the DT somehow.
> Ultimately, I never followed up and this still seems to be an issue.
>

Yeah this is something that has been bothering me for at least a year or
two.
I've brought it up with Grant Likely, hoping that maybe this was something
Linaro could perhaps focus on, but both he and I have just not had the time
to follow up.

We really really need a standard way to pass entropy from the bootloader
into the random driver, for each architecture, and then each boot loader
needs to fetch whatever entropy it can, which may be SoC or architecture
specific.   Or someone needs to beat up on the ARM consortium to guarantee
HWRNG with a standard interface.

It could be via the device tree, or via a fixed memory segment, such as how
the
boot command line is passed from the bootloader to the kernel.   I can help
provide a design and consultation/advice.   But I have zero time to do the
implementation, especially on the ARM architecture (where I lack expertise
and
sample hardware).

-- Ted

--001a114295d0f27b0205241fcff6
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><br><div class=3D"gmail_quote">=
On Mon, Nov 9, 2015 at 1:07 PM, Laura Abbott <span dir=3D"ltr">&lt;<a href=
=3D"mailto:laura@labbott.name" target=3D"_blank" class=3D"cremed">laura@lab=
bott.name</a>&gt;</span> wrote:<blockquote class=3D"gmail_quote" style=3D"m=
argin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">
<br>
I took a look at something closely related sometime ago[1] for<br>
ARM DT based targets. The stack canary was always the same because<br>
it was early enough no entropy was being added and there&#39;s no standard<=
br>
RNG. This series proposed allowing entropy to be read out of the DT.<br>
This still relied on reliable entropy being added to the DT somehow.<br>
Ultimately, I never followed up and this still seems to be an issue.<br></b=
lockquote><div><br></div><div>Yeah this is something that has been botherin=
g me for at least a year or two.</div><div>I&#39;ve brought it up with Gran=
t Likely, hoping that maybe this was something</div><div>Linaro could perha=
ps focus on, but both he and I have just not had the time</div><div>to foll=
ow up.</div><div><br></div><div>We really really need a standard way to pas=
s entropy from the bootloader</div><div>into the random driver, for each ar=
chitecture, and then each boot loader</div><div>needs to fetch whatever ent=
ropy it can, which may be SoC or architecture</div><div>specific. =C2=A0 Or=
 someone needs to beat up on the ARM consortium to guarantee</div><div>HWRN=
G with a standard interface.</div><div><br></div><div>It could be via the d=
evice tree, or via a fixed memory segment, such as how the</div><div>boot c=
ommand line is passed from the bootloader to the kernel. =C2=A0 I can help<=
/div><div>provide a design and consultation/advice. =C2=A0 But I have zero =
time to do the</div><div>implementation, especially on the ARM architecture=
 (where I lack expertise and</div><div>sample hardware).</div><div><br></di=
v><div>-- Ted</div><div><br></div></div></div></div>

--001a114295d0f27b0205241fcff6--
