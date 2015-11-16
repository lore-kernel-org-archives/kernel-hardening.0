Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <56496D65.8030903@gmail.com>
References: <CAHfkTQF33M8eqAPUr3wTDe-yB4k_MLSfMtAfPWW=AhA9aQdtmQ@mail.gmail.com>
	<CAFLxGvxukmvg9jHWXO=-Bbn3eoNrqwFvWsS-v_R99McPU4n_sg@mail.gmail.com>
	<56496AB0.5070905@gmail.com>
	<56496D65.8030903@gmail.com>
Date: Mon, 16 Nov 2015 01:38:55 -0500
Message-ID: <CAEXv5_g-VJJweZKNuw5ozMfiVxMrfhw4biEkSu4A29-uuEmD6A@mail.gmail.com>
From: David Windsor <dave@0x4141.net>
Content-Type: multipart/alternative; boundary=001a1141c588ccb8450524a2a952
Subject: Re: [kernel-hardening]
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

--001a1141c588ccb8450524a2a952
Content-Type: text/plain; charset=UTF-8

I'm currently in the process of preparing my earlier PAX_REFCOUNT patch set
for resubmission, and I tend to agree with you - I'm not very hopeful of
Linus, et al accepting them.  But, we will try again.

With respect to the issue of having a refcount_t type, PAX_REFCOUNT adds
overflow protection to the already existing atomic_t type, and creates a
new type, atomic_unchecked_t, for non-reference-counter types (i.e.
statistical counters).

On Mon, Nov 16, 2015 at 12:45 AM, Daniel Micay <danielmicay@gmail.com>
wrote:

> > I really can't see Linus and others being okay with any GCC
> > plugins with alterations to the semantics of C rather than just codegen
> > like the KERNEXEC plugin.
>
> Oh and REFCOUNT is basically the same situation. I can't see any
> possibility of that landing without switching to having a refcount_t
> type and having separate functions for working with it, with a
> configuration option like DEBUG_REFCOUNT to flip on overflow checks.
> It's a whole bunch of busy-work and since it will touch so much code it
> will run into the same problems that the previous attempts to upstream
> constification did.
>
>

--001a1141c588ccb8450524a2a952
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I&#39;m currently in the process of preparing my earlier P=
AX_REFCOUNT patch set for resubmission, and I tend to agree with you - I&#3=
9;m not very hopeful of Linus, et al accepting them.=C2=A0 But, we will try=
 again.<div><br></div><div>With respect to the issue of having a refcount_t=
 type, PAX_REFCOUNT adds overflow protection to the already existing atomic=
_t type, and creates a new type, atomic_unchecked_t, for non-reference-coun=
ter types (i.e. statistical counters). =C2=A0</div></div><div class=3D"gmai=
l_extra"><br><div class=3D"gmail_quote">On Mon, Nov 16, 2015 at 12:45 AM, D=
aniel Micay <span dir=3D"ltr">&lt;<a href=3D"mailto:danielmicay@gmail.com" =
target=3D"_blank">danielmicay@gmail.com</a>&gt;</span> wrote:<br><blockquot=
e class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc sol=
id;padding-left:1ex"><span class=3D"">&gt; I really can&#39;t see Linus and=
 others being okay with any GCC<br>
&gt; plugins with alterations to the semantics of C rather than just codege=
n<br>
&gt; like the KERNEXEC plugin.<br>
<br>
</span>Oh and REFCOUNT is basically the same situation. I can&#39;t see any=
<br>
possibility of that landing without switching to having a refcount_t<br>
type and having separate functions for working with it, with a<br>
configuration option like DEBUG_REFCOUNT to flip on overflow checks.<br>
It&#39;s a whole bunch of busy-work and since it will touch so much code it=
<br>
will run into the same problems that the previous attempts to upstream<br>
constification did.<br>
<br>
</blockquote></div><br></div>

--001a1141c588ccb8450524a2a952--
