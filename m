Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
References: <20160119112812.GA10818@mwanda> <20160119124917.6058019b@pc1> <20160120121958.4a392837@pc1>
In-Reply-To: <20160120121958.4a392837@pc1>
From: Wade Mealing <wmealing@gmail.com>
Date: Wed, 20 Jan 2016 14:15:14 +0000
Message-ID: <CAO4UgPQxZg7QT0QiE9G4VBenBG55KVNomNCWOZ5_CEdbmEUSTA@mail.gmail.com>
Content-Type: multipart/alternative; boundary=001a11413546fdf1120529c49dae
Subject: Re: [kernel-hardening] 2015 kernel CVEs
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

--001a11413546fdf1120529c49dae
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 20, 2016 at 9:19 PM Hanno B=C3=B6ck <hanno@hboeck.de> wrote:

> On Tue, 19 Jan 2016 12:49:17 +0100
> Hanno B=C3=B6ck <hanno@hboeck.de> wrote:
>
> > > There was only one that might have come from a USB fuzzer.
> > > We probably should be testing those things better.
> >
> > This is surprising to me. There was a talk at black hat amsterdam in
> > 2014 about a project trying to do exactly this. They sounded like they
> > have dozends of crashers that just need to be sorted and reported
> > upstream. Here's the code [2] and the talk [3].
>
>
> https://packetstormsecurity.com/files/133892/RedHat-Enterprise-Linux-7.1-=
Denial-Of-Service.html
>
> It seems they have started reporting issues and got limited replies.
>
>
Disclaimer: I work for Red Hat Product Security group in the kernel sub
group with Vladis.

So from what I can see:

- The CVE has been assigned.
- A kernel has been built with a patch
- Communicated with upstream about accepting the patch.
- The issue is awaiting testing on the reporter since 24th of November last
year.
- This is not the only bugs that has been reported and worked between Ralf
and Vladis ( https://goo.gl/5G1cnw )

I'm all about improving process, I imagine I would have done the same
steps.   What changes to the responses would need to be made to be less
limited ?  Understand that i'm not taking this personally and consider this
an opportunity for Red Hat Security to improve as a group.

If you want to take this off list, I'm cool with that.

Thanks,

Wade Mealing
--=20
Thanks,

Wade Mealing

--001a11413546fdf1120529c49dae
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>On Wed, Jan 20, 2016 at 9:19 PM Hanno B=C3=B6ck &lt;<=
a href=3D"mailto:hanno@hboeck.de" target=3D"_blank">hanno@hboeck.de</a>&gt;=
 wrote:<br></div><div class=3D"gmail_quote"><blockquote class=3D"gmail_quot=
e" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">=
On Tue, 19 Jan 2016 12:49:17 +0100<br>
Hanno B=C3=B6ck &lt;<a href=3D"mailto:hanno@hboeck.de" target=3D"_blank">ha=
nno@hboeck.de</a>&gt; wrote:<br>
<br>
&gt; &gt; There was only one that might have come from a USB fuzzer.<br>
&gt; &gt; We probably should be testing those things better.<br>
&gt;<br>
&gt; This is surprising to me. There was a talk at black hat amsterdam in<b=
r>
&gt; 2014 about a project trying to do exactly this. They sounded like they=
<br>
&gt; have dozends of crashers that just need to be sorted and reported<br>
&gt; upstream. Here&#39;s the code [2] and the talk [3].<br>
<br>
<a href=3D"https://packetstormsecurity.com/files/133892/RedHat-Enterprise-L=
inux-7.1-Denial-Of-Service.html" rel=3D"noreferrer" target=3D"_blank">https=
://packetstormsecurity.com/files/133892/RedHat-Enterprise-Linux-7.1-Denial-=
Of-Service.html</a><br>
<br>
It seems they have started reporting issues and got limited replies.<br><br=
></blockquote><div><br></div>Disclaimer: I work for Red Hat Product Securit=
y group in the kernel sub group with Vladis.<div><br></div><div>So from wha=
t I can see:<br><br></div><div><div>- The CVE has been assigned.</div><div>=
- A kernel has been built with a patch</div></div><div>- Communicated with =
upstream about accepting the patch.</div><div>- The issue is awaiting testi=
ng on the reporter since 24th of November last year.</div><div>- This is no=
t the only bugs that has been reported and worked between Ralf and Vladis (=
=C2=A0<a href=3D"https://goo.gl/5G1cnw">https://goo.gl/5G1cnw</a>=C2=A0)</d=
iv><div><br></div><div>I&#39;m all about improving process, I imagine I wou=
ld have done the same steps. =C2=A0 What changes to the responses would nee=
d to be made to be less limited ?=C2=A0 Understand that i&#39;m not taking =
this personally and consider this an opportunity for Red Hat Security to im=
prove as a group. =C2=A0</div><div><br></div><div>If you want to take this =
off list, I&#39;m cool with that.</div><div><br></div><div>Thanks,</div><di=
v><br></div><div>Wade Mealing</div></div></div><div dir=3D"ltr">-- <br></di=
v><div dir=3D"ltr">Thanks,<div><br></div><div>Wade Mealing</div></div>

--001a11413546fdf1120529c49dae--
