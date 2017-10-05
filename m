MIME-Version: 1.0
In-Reply-To: <CA+55aFxjsKRhuzpQjRff6b6emJBFHtefUwnDfv+zgrxmUDvqkw@mail.gmail.com>
References: <1506816410-10230-1-git-send-email-me@tobin.cc>
 <CA+55aFxzD=+H_M+Sg_8YRf-JYV-+-yn1c=dFhJWFzSh5yWt9Gg@mail.gmail.com>
 <ArOl6I7GkZ912O0tP7uFPe5JRJTftclvQHVtSHw0hsmxk5IJXexp9M3zQPefcGCXcx27lzX7A1s74XFa9gXEA5yRA5hC1BaNqhD7QgN3JRo=@protonmail.ch>
 <CA+55aFzGsRFPtMFRv3G0FPNs6YAD3S2U94o58Lgg1MnmHwCxvA@mail.gmail.com>
 <476DC76E7D1DF2438D32BFADF679FC563EAF4F29@ORSMSX103.amr.corp.intel.com>
 <CA+55aFwEZCT6=BCdmaNn5LGeU8g-2qi4OnM9MTOep3NOZVXjMg@mail.gmail.com>
 <20171005021915.GK16685@eros> <CA+55aFwac2BzgZs-X1_VhekkuGfuLqNui2+2DbvLiDyptS-rXQ@mail.gmail.com>
 <476DC76E7D1DF2438D32BFADF679FC563F4AD0AF@ORSMSX115.amr.corp.intel.com> <CA+55aFxjsKRhuzpQjRff6b6emJBFHtefUwnDfv+zgrxmUDvqkw@mail.gmail.com>
From: Dave Weinstein <olorin@google.com>
Date: Thu, 5 Oct 2017 10:10:43 -0700
Message-ID: <CACy=wMngd4vUwZCLQZPrN7fBFrJDZuNa_n=Qkc9Y3-_vqX_jqQ@mail.gmail.com>
Content-Type: multipart/alternative; boundary="f403045db38c5d836d055acfd03b"
Subject: Re: [kernel-hardening] [RFC V2 0/6] add more kernel pointer filter options
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Roberts, William C" <william.c.roberts@intel.com>, "Tobin C. Harding" <me@tobin.cc>, Tejun Heo <tj@kernel.org>, Jordan Glover <Golden_Miller83@protonmail.ch>, Greg KH <gregkh@linuxfoundation.org>, Petr Mladek <pmladek@suse.com>, Joe Perches <joe@perches.com>, Ian Campbell <ijc@hellion.org.uk>, Sergey Senozhatsky <sergey.senozhatsky@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will.deacon@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Chris Fries <cfries@google.com>
List-ID: <kernel-hardening.lists.openwall.com>

--f403045db38c5d836d055acfd03b
Content-Type: text/plain; charset="UTF-8"

> Does android set it to 2 right now?

Yes. And as of Android 8.0, it will attempt to set it to 4, and step back
to 2 if the higher restriction values are not supported (
https://android.googlesource.com/platform/system/core/+/44f7e4f42190fdb5309b818d5acc0ff6b0f87249%5E%21/#F0
)

>     We already don't get great bug reports. If we now start getting

>bug reports and tell users "recreate this with 'kptr_enabled' on the

>kernel command line" because some debug message didn't give proper

>data, that will just result in us getting even less bug reports.

This is why the original Android patch set whitelists the stack traces --
it was a deliberate choice to make sure that kernel bug reports were
generally meaningful by default.

>Honestly, what's the difference between setting kptr_restrict to 4 and

>just using a sed-script (or maybe some coccinelle) to remove all

>existing plain %p users?

The primary benefit from my perspective is that the userland component can
establish a general expectation of the level of information disclosure that
depends on a single feature being implemented, rather than an arbitrarily
large number of point fixes across multiple kernel versions.

--Dave

-- 
Dave Weinstein
Android SDL

--f403045db38c5d836d055acfd03b
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div class=3D"gmail_extra"><span id=3D"gmail-docs-internal=
-guid-0a31d62a-ed81-3a67-2410-5affafabc4c1"><p dir=3D"ltr" style=3D"line-he=
ight:1.38;margin-top:0pt;margin-bottom:0pt"><span style=3D"font-size:9.5pt;=
font-family:Arial;vertical-align:baseline;white-space:pre-wrap">&gt; Does a=
ndroid set it to 2 right now?</span></p><br><p dir=3D"ltr" style=3D"line-he=
ight:1.38;margin-top:0pt;margin-bottom:0pt"><span style=3D"font-size:9.5pt;=
font-family:Arial;vertical-align:baseline;white-space:pre-wrap">Yes. And as=
 of Android 8.0, it will attempt to set it to 4, and step back to 2 if the =
higher restriction values are not supported (</span><a href=3D"https://andr=
oid.googlesource.com/platform/system/core/+/44f7e4f42190fdb5309b818d5acc0ff=
6b0f87249%5E%21/#F0" style=3D"text-decoration-line:none"><span style=3D"fon=
t-size:9.5pt;font-family:Arial;text-decoration-line:underline;vertical-alig=
n:baseline;white-space:pre-wrap">https://android.googlesource.com/platform/=
system/core/+/44f7e4f42190fdb5309b818d5acc0ff6b0f87249%5E%21/#F0</span></a>=
<span style=3D"font-size:9.5pt;font-family:Arial;vertical-align:baseline;wh=
ite-space:pre-wrap">)</span></p><br><p dir=3D"ltr" style=3D"line-height:1.3=
8;margin-top:0pt;margin-bottom:0pt"><span style=3D"font-size:9.5pt;font-fam=
ily:Arial;vertical-align:baseline;white-space:pre-wrap">&gt; =C2=A0=C2=A0=
=C2=A0=C2=A0We already don&#39;t get great bug reports. If we now start get=
ting</span></p><p dir=3D"ltr" style=3D"line-height:1.38;margin-top:0pt;marg=
in-bottom:0pt"><span style=3D"font-size:9.5pt;font-family:Arial;vertical-al=
ign:baseline;white-space:pre-wrap">&gt;bug reports and tell users &quot;rec=
reate this with &#39;kptr_enabled&#39; on the</span></p><p dir=3D"ltr" styl=
e=3D"line-height:1.38;margin-top:0pt;margin-bottom:0pt"><span style=3D"font=
-size:9.5pt;font-family:Arial;vertical-align:baseline;white-space:pre-wrap"=
>&gt;kernel command line&quot; because some debug message didn&#39;t give p=
roper</span></p><p dir=3D"ltr" style=3D"line-height:1.38;margin-top:0pt;mar=
gin-bottom:0pt"><span style=3D"font-size:9.5pt;font-family:Arial;vertical-a=
lign:baseline;white-space:pre-wrap">&gt;data, that will just result in us g=
etting even less bug reports.</span></p><br><p dir=3D"ltr" style=3D"line-he=
ight:1.38;margin-top:0pt;margin-bottom:0pt"><span style=3D"font-size:9.5pt;=
font-family:Arial;vertical-align:baseline;white-space:pre-wrap">This is why=
 the original Android patch set whitelists the stack traces -- it was a del=
iberate choice to make sure that kernel bug reports were generally meaningf=
ul by default.</span></p><br><p dir=3D"ltr" style=3D"line-height:1.38;margi=
n-top:0pt;margin-bottom:0pt"><span style=3D"font-size:9.5pt;font-family:Ari=
al;vertical-align:baseline;white-space:pre-wrap">&gt;Honestly, what&#39;s t=
he difference between setting kptr_restrict to 4 and</span></p><p dir=3D"lt=
r" style=3D"line-height:1.38;margin-top:0pt;margin-bottom:0pt"><span style=
=3D"font-size:9.5pt;font-family:Arial;vertical-align:baseline;white-space:p=
re-wrap">&gt;just using a sed-script (or maybe some coccinelle) to remove a=
ll</span></p><p dir=3D"ltr" style=3D"line-height:1.38;margin-top:0pt;margin=
-bottom:0pt"><span style=3D"font-size:9.5pt;font-family:Arial;vertical-alig=
n:baseline;white-space:pre-wrap">&gt;existing plain %p users?</span></p><br=
><p dir=3D"ltr" style=3D"line-height:1.38;margin-top:0pt;margin-bottom:0pt"=
><span style=3D"font-size:9.5pt;font-family:Arial;vertical-align:baseline;w=
hite-space:pre-wrap">The primary benefit from my perspective is that the us=
erland component can establish a general expectation of the level of inform=
ation disclosure that depends on a single feature being implemented, rather=
 than an arbitrarily large number of point fixes across multiple kernel ver=
sions. </span></p><div><span style=3D"font-size:9.5pt;font-family:Arial;ver=
tical-align:baseline;white-space:pre-wrap"><br></span></div><div><span styl=
e=3D"font-size:9.5pt;font-family:Arial;vertical-align:baseline;white-space:=
pre-wrap">--Dave</span></div></span><div><br></div>-- <br><div class=3D"gma=
il_signature"><div dir=3D"ltr"><div><div dir=3D"ltr"><div><div dir=3D"ltr">=
<div><div dir=3D"ltr"><span style=3D"font-size:12.8px">Dave Weinstein</span=
><br></div><div dir=3D"ltr"><div>Android SDL</div><div><br></div></div></di=
v></div></div></div></div></div></div>
</div></div>

--f403045db38c5d836d055acfd03b--
