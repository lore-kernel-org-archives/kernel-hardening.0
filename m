Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <570914BA.8020308@gmail.com>
References: <1460138602-85386-1-git-send-email-thgarnie@google.com>
	<57090CDE.6080509@gmail.com>
	<CAJcbSZGo25eo4-ukF39vNvvpdzpmnQY6RVBcxc41Z-goS5F1LA@mail.gmail.com>
	<570914BA.8020308@gmail.com>
Date: Sat, 9 Apr 2016 08:31:50 -0700
Message-ID: <CAJcbSZGvhRfoqnMF6Ec1c9hPEp-vOiyeN4xYPsNseu0mzW4Uog@mail.gmail.com>
From: Thomas Garnier <thgarnie@google.com>
Content-Type: multipart/alternative; boundary=001a113cd1c0a1ef1205300f0297
Subject: Re: [kernel-hardening] [RFC v2] mm: SLAB freelist randomization
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

--001a113cd1c0a1ef1205300f0297
Content-Type: text/plain; charset=UTF-8

I understand. There is correlation but no silver bullet against heap
overflows especially without significant performance impact.

The SLAB freelist was recently moved at the end of the set of pages. That
will create interesting attacks to transform an overflow to a use after
free. The freelist randomization can help on that.

Thomas
On Apr 9, 2016 7:42 AM, "lazytyped" <lazytyped@gmail.com> wrote:

>
>
> On 4/9/16 7:24 AM, Thomas Garnier wrote:
> >
> > Yes and no. With slabinfo not being available if not root you are not
> > sure when you start a new SLAB. You also can't quantify the risk of
> > another allocation happening on a real machine under load.
> >
> > It decreases the odds on a successful overflow that just requires two
> > allocations to follow one another. It doesn't mitigate heap overflows.
> >
>
> Both things you mention above are somehow unrelated to the freelist
> randomization. But that's fine. This has no performance impact, so there
> is no problem in having it (not that I would or would want to have a say
> :-) ).
>
> I was just arguing that hinting at that specific exploit as one that
> would have had 'decreased' odds of exploitation didn't seem like the
> best choice.
>
>
>         -  twiz
>

--001a113cd1c0a1ef1205300f0297
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<p dir=3D"ltr">I understand. There is correlation but no silver bullet agai=
nst heap overflows especially without significant performance impact. </p>
<p dir=3D"ltr">The SLAB freelist was recently moved at the end of the set o=
f pages. That will create interesting attacks to transform an overflow to a=
 use after free. The freelist randomization can help on that. </p>
<p dir=3D"ltr">Thomas </p>
<div class=3D"gmail_quote">On Apr 9, 2016 7:42 AM, &quot;lazytyped&quot; &l=
t;<a href=3D"mailto:lazytyped@gmail.com">lazytyped@gmail.com</a>&gt; wrote:=
<br type=3D"attribution"><blockquote class=3D"gmail_quote" style=3D"margin:=
0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex"><br>
<br>
On 4/9/16 7:24 AM, Thomas Garnier wrote:<br>
&gt;<br>
&gt; Yes and no. With slabinfo not being available if not root you are not<=
br>
&gt; sure when you start a new SLAB. You also can&#39;t quantify the risk o=
f<br>
&gt; another allocation happening on a real machine under load.<br>
&gt;<br>
&gt; It decreases the odds on a successful overflow that just requires two<=
br>
&gt; allocations to follow one another. It doesn&#39;t mitigate heap overfl=
ows.<br>
&gt;<br>
<br>
Both things you mention above are somehow unrelated to the freelist<br>
randomization. But that&#39;s fine. This has no performance impact, so ther=
e<br>
is no problem in having it (not that I would or would want to have a say<br=
>
:-) ).<br>
<br>
I was just arguing that hinting at that specific exploit as one that<br>
would have had &#39;decreased&#39; odds of exploitation didn&#39;t seem lik=
e the<br>
best choice.<br>
<br>
<br>
=C2=A0 =C2=A0 =C2=A0 =C2=A0 -=C2=A0 twiz<br>
</blockquote></div>

--001a113cd1c0a1ef1205300f0297--
