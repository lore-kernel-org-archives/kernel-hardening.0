MIME-Version: 1.0
Sender: linus971@gmail.com
In-Reply-To: <87wp1sa55h.fsf@concordia.ellerman.id.au>
References: <20171201200819.GA25519@linux.vnet.ibm.com> <1512158945-27269-2-git-send-email-paulmck@linux.vnet.ibm.com>
 <bc07683158334e8f90573bbd77e037a3@AcuMS.aculab.com> <20171204134203.GR7829@linux.vnet.ibm.com>
 <f51c8864617a45d3aabef7106ae7a9f1@AcuMS.aculab.com> <20171204161100.GT7829@linux.vnet.ibm.com>
 <CAHp75VcJKYnW2grD6jViNFU3z6+fJoTmqs+ZP3Xm6YB3C8ZH1Q@mail.gmail.com>
 <CA+55aFwQEd_d40g4mUCSsVRZzrFPUJt74vc6PPpb675hYNXcKw@mail.gmail.com> <87wp1sa55h.fsf@concordia.ellerman.id.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 11 Dec 2017 22:21:09 -0800
Message-ID: <CA+55aFxHdAX_ztDMUyXihhUv_eftntHecGUUaV3qAtGj_ZbKCg@mail.gmail.com>
Content-Type: multipart/alternative; boundary="001a1141fb1c2c065005601ea8bf"
Subject: [kernel-hardening] Re: Long live %pK (was Re: [PATCH tip/core/rcu 02/20] torture:
 Prepare scripting for shift from %p to %pK)
To: Michael Ellerman <mpe@ellerman.id.au>
Cc: Andy Shevchenko <andy.shevchenko@gmail.com>, Kees Cook <keescook@chromium.org>, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>, David Laight <David.Laight@aculab.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "mingo@kernel.org" <mingo@kernel.org>, "jiangshanlai@gmail.com" <jiangshanlai@gmail.com>, "dipankar@in.ibm.com" <dipankar@in.ibm.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "mathieu.desnoyers@efficios.com" <mathieu.desnoyers@efficios.com>, "josh@joshtriplett.org" <josh@joshtriplett.org>, "tglx@linutronix.de" <tglx@linutronix.de>, "peterz@infradead.org" <peterz@infradead.org>, "rostedt@goodmis.org" <rostedt@goodmis.org>, "dhowells@redhat.com" <dhowells@redhat.com>, "edumazet@google.com" <edumazet@google.com>, "fweisbec@gmail.com" <fweisbec@gmail.com>, "oleg@redhat.com" <oleg@redhat.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, "Tobin C. Harding" <me@tobin.cc>
List-ID: <kernel-hardening.lists.openwall.com>

--001a1141fb1c2c065005601ea8bf
Content-Type: text/plain; charset="UTF-8"

This is a perfect example of just %pK being complete shit.

%pK doesn't actually do any file permissions right. It looks like it does
it, but it's just a hot mess of garbage.

And %pK doesn't even work the way you claim it does. Not in the general
case, and only with a particular value.

On Dec 11, 2017 21:26, "Michael Ellerman" <mpe@ellerman.id.au> wrote: I


I understand that the CAP_SYSLOG checking that %pK does is kind of
gross, but it does work in at least some useful cases like this.

What am I missing?


Just do the damn thing right, like /proc/kallsyms does these days.

With the proper open time cred check, not the wrong one at io time.

Which has the added advantage that it actually does the right thing even
when you don't have kptr_restrict set, or when you have patches to make it
print zero even for people with capabilities.

Don't depend on some random flag that has nothing to do with your actual
example and that has random values for security.

Just say no to kptr_restrict "logic". Your example basically depends
entirely on one particular setting, when (a) real distributions have a
different value and expose those pointers that your claim shouldn't be
exposed and (b) other people are pushing for values that will hide the
values that you claim area needed.

     Linus

--001a1141fb1c2c065005601ea8bf
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"auto">This is a perfect example of just %pK being complete shit=
.<div dir=3D"auto"><br></div><div dir=3D"auto">%pK doesn&#39;t actually do =
any file permissions right. It looks like it does it, but it&#39;s just a h=
ot mess of garbage.</div><div dir=3D"auto"><br></div><div dir=3D"auto">And =
%pK doesn&#39;t even work the way you claim it does. Not in the general cas=
e, and only with a particular value.</div><div class=3D"gmail_extra" dir=3D=
"auto"><br><div class=3D"gmail_quote">On Dec 11, 2017 21:26, &quot;Michael =
Ellerman&quot; &lt;<a href=3D"mailto:mpe@ellerman.id.au">mpe@ellerman.id.au=
</a>&gt; wrote: I<blockquote class=3D"quote" style=3D"margin:0 0 0 .8ex;bor=
der-left:1px #ccc solid;padding-left:1ex">
<br>
I understand that the CAP_SYSLOG checking that %pK does is kind of<br>
gross, but it does work in at least some useful cases like this.<br>
<br>
What am I missing?<br></blockquote></div></div><div dir=3D"auto"><br></div>=
<div dir=3D"auto">Just do the damn thing right, like /proc/kallsyms does th=
ese days.</div><div dir=3D"auto"><br></div><div dir=3D"auto">With the prope=
r open time cred check, not the wrong one at io time.</div><div dir=3D"auto=
"><br></div><div dir=3D"auto">Which has the added advantage that it actuall=
y does the right thing even when you don&#39;t have kptr_restrict set, or w=
hen you have patches to make it print zero even for people with capabilitie=
s.=C2=A0</div><div dir=3D"auto"><br></div><div dir=3D"auto">Don&#39;t depen=
d on some random flag that has nothing to do with your actual example and t=
hat has random values for security.</div><div dir=3D"auto"><br></div><div d=
ir=3D"auto">Just say no to kptr_restrict &quot;logic&quot;. Your example ba=
sically depends entirely on one particular setting, when (a) real distribut=
ions have a different value and expose those pointers that your claim shoul=
dn&#39;t be exposed and (b) other people are pushing for values that will h=
ide the values that you claim area needed.</div><div dir=3D"auto"><br></div=
><div dir=3D"auto">=C2=A0 =C2=A0 =C2=A0Linus</div><div class=3D"gmail_extra=
" dir=3D"auto"><div class=3D"gmail_quote"><blockquote class=3D"quote" style=
=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"></blockq=
uote></div></div></div>

--001a1141fb1c2c065005601ea8bf--
