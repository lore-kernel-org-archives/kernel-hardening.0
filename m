Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <CALCETrWnw0WjionuGAT1F8r5y_t5CbYh+TmDL4s2d=ZbiinspA@mail.gmail.com>
References: <cover.1466974736.git.luto@kernel.org>
	<aeea9c1c41e889065b2c9ecd6d0694e4dfb529c8.1466974736.git.luto@kernel.org>
	<20160711100808.GB31221@leverpostej>
	<CALCETrWnw0WjionuGAT1F8r5y_t5CbYh+TmDL4s2d=ZbiinspA@mail.gmail.com>
Date: Mon, 11 Jul 2016 09:06:58 -0700
Message-ID: <CA+55aFy2Sno+bS0A2k0cMWpEJy-bpXufSAw3+ufrfQYbp9rcMQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: multipart/alternative; boundary=001a11407a6488d3ba05375e571b
Subject: Re: [kernel-hardening] [PATCH v4 26/29] sched: Allow putting
 thread_info into task_struct
To: Andy Lutomirski <luto@amacapital.net>
Cc: linux-arch@vger.kernel.org, Nadav Amit <nadav.amit@gmail.com>, Mark Rutland <mark.rutland@arm.com>, Kees Cook <keescook@chromium.org>, Borislav Petkov <bp@alien8.de>, Josh Poimboeuf <jpoimboe@redhat.com>, X86 ML <x86@kernel.org>, Jann Horn <jann@thejh.net>, Heiko Carstens <heiko.carstens@de.ibm.com>, Brian Gerst <brgerst@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

--001a11407a6488d3ba05375e571b
Content-Type: text/plain; charset=UTF-8

On Jul 11, 2016 7:55 AM, "Andy Lutomirski" <luto@amacapital.net> wrote:
>
> How do you intend to find 'current' to get to the preempt count
> without first disabling preemption?

Actually, that is the classic case of "not a problem".

The thing is, it doesn't matter if you schedule away while looking up
current or the preempt count - because both values are idempotent wet
scheduling.

So until you do the wire that actually disables preemption you can schedule
away as much as you want, and after that write you no longer will.

This is different wrt a per-cpu area - which is clearly not idempotent wrt
scheduling.

The reason per-cpu works on x86 is that we have an atomic rmw operation
that is *also* atomic wrt the CPU lookup (thanks to the segment base)

     Linus

--001a11407a6488d3ba05375e571b
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<p dir=3D"ltr"><br>
On Jul 11, 2016 7:55 AM, &quot;Andy Lutomirski&quot; &lt;<a href=3D"mailto:=
luto@amacapital.net">luto@amacapital.net</a>&gt; wrote:<br>
&gt;<br>
&gt; How do you intend to find &#39;current&#39; to get to the preempt coun=
t<br>
&gt; without first disabling preemption?</p>
<p dir=3D"ltr">Actually, that is the classic case of &quot;not a problem&qu=
ot;.</p>
<p dir=3D"ltr">The thing is, it doesn&#39;t matter if you schedule away whi=
le looking up current or the preempt count - because both values are idempo=
tent wet scheduling. </p>
<p dir=3D"ltr">So until you do the wire that actually disables preemption y=
ou can schedule away as much as you want, and after that write you no longe=
r will.</p>
<p dir=3D"ltr">This is different wrt a per-cpu area - which is clearly not =
idempotent wrt scheduling.</p>
<p dir=3D"ltr">The reason per-cpu works on x86 is that we have an atomic rm=
w operation that is *also* atomic wrt the CPU lookup (thanks to the segment=
 base)</p>
<p dir=3D"ltr">=C2=A0=C2=A0=C2=A0=C2=A0 Linus</p>

--001a11407a6488d3ba05375e571b--
