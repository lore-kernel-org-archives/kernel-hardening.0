Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAH6MLeM5bdDPCY04DDZXhxGWmn2kPO=7PtF4YE6_cXZaP9-0Gg@mail.gmail.com>
References: <1365106055-22939-1-git-send-email-keescook@chromium.org>
	<1365106055-22939-2-git-send-email-keescook@chromium.org>
	<20130405072405.GD26889@gmail.com>
	<20130405073621.GA27843@gmail.com>
	<515F14B6.9090603@zytor.com>
	<CAH6MLeM5bdDPCY04DDZXhxGWmn2kPO=7PtF4YE6_cXZaP9-0Gg@mail.gmail.com>
Date: Mon, 8 Apr 2013 08:35:21 +0300
Message-ID: <CAH6MLeP0iZXespwyawuhwvWFCkgeTEmUSe4o3tRq0Tk3ySQGcA@mail.gmail.com>
From: Hasinoliva MIARIMANJATO <hasinoliva@gmail.com>
Content-Type: multipart/alternative; boundary=f46d043bdf2a85b76a04d9d2cd2f
Subject: Re: [kernel-hardening] Re: [PATCH 1/3] x86: routines to choose random
 kernel base offset
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

--f46d043bdf2a85b76a04d9d2cd2f
Content-Type: text/plain; charset=ISO-8859-1

Hi i want to get so more information about pohmelfs ; i want to get
pohmelfs server and pohmelfs client that i don't find it in the internet ,
please help me

 thank you.


2013/4/8 Hasinoliva MIARIMANJATO <hasinoliva@gmail.com>

> Hi i want to get so more information about pohmelfs ; i want to get
> pohmelfs server and pohmelfs client that i don't find it in the internet ,
> please help me
>
>  thank you.
>
>
> 2013/4/5 H. Peter Anvin <hpa@zytor.com>
>
> On 04/05/2013 12:36 AM, Ingo Molnar wrote:
>> >
>> > * Ingo Molnar <mingo@kernel.org> wrote:
>> >
>> >>
>> >> * Kees Cook <keescook@chromium.org> wrote:
>> >>
>> >>> This provides routines for selecting a randomized kernel base offset,
>> >>> bounded by e820 details. It tries to use RDRAND and falls back to
>> RDTSC.
>> >>> If "noaslr" is on the kernel command line, no offset will be used.
>> >>
>> >> Would it make sense to also add three other sources of entropy:
>> >
>> > In any case, would it be possible to also mix these bootup sources of
>> > entropy into our regular random pool?
>> >
>> > That would improve random pool entropy on all Linux systems, not just
>> > those that choose to enable kernel-base-address randomization.
>> >
>>
>> I think we already do at least some of these, but at this point, for any
>> non-RDRAND-capable hardware we could almost certainly do better for any
>> definition of anything at all.
>>
>> RDRAND is obviously the ultimate solution here.
>>
>>         -hpa
>>
>>
>>
>

--f46d043bdf2a85b76a04d9d2cd2f
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi i want to get so more information about pohmelfs ;=
 i want to get
 pohmelfs server and pohmelfs client that i don&#39;t find it in the=20
internet , please help me <br>
<br>
</div>
thank you.</div><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quot=
e">2013/4/8 Hasinoliva MIARIMANJATO <span dir=3D"ltr">&lt;<a href=3D"mailto=
:hasinoliva@gmail.com" target=3D"_blank">hasinoliva@gmail.com</a>&gt;</span=
><br>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex"><div dir=3D"ltr"><div>Hi i want to get so mo=
re information about pohmelfs ; i want to get
 pohmelfs server and pohmelfs client that i don&#39;t find it in the=20
internet , please help me <br>
<br>
</div>
thank you.</div><div class=3D"gmail_extra"><br><br><div class=3D"gmail_quot=
e">2013/4/5 H. Peter Anvin <span dir=3D"ltr">&lt;<a href=3D"mailto:hpa@zyto=
r.com" target=3D"_blank">hpa@zytor.com</a>&gt;</span><div><div class=3D"h5"=
><br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-le=
ft:1px #ccc solid;padding-left:1ex">

<div><div>On 04/05/2013 12:36 AM, Ingo Molnar wrote:<br>
&gt;<br>
&gt; * Ingo Molnar &lt;<a href=3D"mailto:mingo@kernel.org" target=3D"_blank=
">mingo@kernel.org</a>&gt; wrote:<br>
&gt;<br>
&gt;&gt;<br>
&gt;&gt; * Kees Cook &lt;<a href=3D"mailto:keescook@chromium.org" target=3D=
"_blank">keescook@chromium.org</a>&gt; wrote:<br>
&gt;&gt;<br>
&gt;&gt;&gt; This provides routines for selecting a randomized kernel base =
offset,<br>
&gt;&gt;&gt; bounded by e820 details. It tries to use RDRAND and falls back=
 to RDTSC.<br>
&gt;&gt;&gt; If &quot;noaslr&quot; is on the kernel command line, no offset=
 will be used.<br>
&gt;&gt;<br>
&gt;&gt; Would it make sense to also add three other sources of entropy:<br=
>
&gt;<br>
&gt; In any case, would it be possible to also mix these bootup sources of<=
br>
&gt; entropy into our regular random pool?<br>
&gt;<br>
&gt; That would improve random pool entropy on all Linux systems, not just<=
br>
&gt; those that choose to enable kernel-base-address randomization.<br>
&gt;<br>
<br>
</div></div>I think we already do at least some of these, but at this point=
, for any<br>
non-RDRAND-capable hardware we could almost certainly do better for any<br>
definition of anything at all.<br>
<br>
RDRAND is obviously the ultimate solution here.<br>
<span><font color=3D"#888888"><br>
=A0 =A0 =A0 =A0 -hpa<br>
<br>
<br>
</font></span></blockquote></div></div></div><br></div>
</blockquote></div><br></div>

--f46d043bdf2a85b76a04d9d2cd2f--
