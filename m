Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <57090CDE.6080509@gmail.com>
References: <1460138602-85386-1-git-send-email-thgarnie@google.com>
	<57090CDE.6080509@gmail.com>
Date: Sat, 9 Apr 2016 07:24:24 -0700
Message-ID: <CAJcbSZGo25eo4-ukF39vNvvpdzpmnQY6RVBcxc41Z-goS5F1LA@mail.gmail.com>
From: Thomas Garnier <thgarnie@google.com>
Content-Type: multipart/alternative; boundary=001a1134be0a77000b05300e115e
Subject: Re: [kernel-hardening] [RFC v2] mm: SLAB freelist randomization
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

--001a1134be0a77000b05300e115e
Content-Type: text/plain; charset=UTF-8

Yes and no. With slabinfo not being available if not root you are not sure
when you start a new SLAB. You also can't quantify the risk of another
allocation happening on a real machine under load.

It decreases the odds on a successful overflow that just requires two
allocations to follow one another. It doesn't mitigate heap overflows.

Thanks,
Thomas

On Apr 9, 2016 7:08 AM, "lazytyped" <lazytyped@gmail.com> wrote:
>
>
>
> On 4/8/16 11:03 AM, Thomas Garnier wrote:
> > For example this attack against SLUB (also applicable against SLAB)
> > would be affected:
> >
https://jon.oberheide.org/blog/2010/09/10/linux-kernel-can-slub-overflow/
>
> would it?
>
> - allocate a ton of shmid_kernel until you get a fresh page
> - free one of such objects (here is where your randomization comes into
> play)
> - allocate the "vulnerable" object
> - trigger the overflow
> - start "freeing" the others - one will work
>
> This doesn't work only in the case in which you are the last object in
> the SLUB. So what you are achieving is a 1/(pagesize/sizeof_objects)
> chance of making the attack less reliable. But I can free yet another
> object and retry, if the previous overflow didn't kill me (simplest way
> to guarantee that is to not completely fill the newly allocated SLUB
page).
>
>
>        -   twiz

--001a1134be0a77000b05300e115e
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<p dir=3D"ltr">Yes and no. With slabinfo not being available if not root yo=
u are not sure when you start a new SLAB. You also can&#39;t quantify the r=
isk of another allocation happening on a real machine under load.</p>
<p dir=3D"ltr">It decreases the odds on a successful overflow that just req=
uires two allocations to follow one another. It doesn&#39;t mitigate heap o=
verflows.</p>
<p dir=3D"ltr">Thanks,<br>
Thomas </p>
<p dir=3D"ltr">On Apr 9, 2016 7:08 AM, &quot;lazytyped&quot; &lt;<a href=3D=
"mailto:lazytyped@gmail.com">lazytyped@gmail.com</a>&gt; wrote:<br>
&gt;<br>
&gt;<br>
&gt;<br>
&gt; On 4/8/16 11:03 AM, Thomas Garnier wrote:<br>
&gt; &gt; For example this attack against SLUB (also applicable against SLA=
B)<br>
&gt; &gt; would be affected:<br>
&gt; &gt; <a href=3D"https://jon.oberheide.org/blog/2010/09/10/linux-kernel=
-can-slub-overflow/">https://jon.oberheide.org/blog/2010/09/10/linux-kernel=
-can-slub-overflow/</a><br>
&gt;<br>
&gt; would it?<br>
&gt;<br>
&gt; - allocate a ton of shmid_kernel until you get a fresh page<br>
&gt; - free one of such objects (here is where your randomization comes int=
o<br>
&gt; play)<br>
&gt; - allocate the &quot;vulnerable&quot; object<br>
&gt; - trigger the overflow<br>
&gt; - start &quot;freeing&quot; the others - one will work<br>
&gt;<br>
&gt; This doesn&#39;t work only in the case in which you are the last objec=
t in<br>
&gt; the SLUB. So what you are achieving is a 1/(pagesize/sizeof_objects)<b=
r>
&gt; chance of making the attack less reliable. But I can free yet another<=
br>
&gt; object and retry, if the previous overflow didn&#39;t kill me (simples=
t way<br>
&gt; to guarantee that is to not completely fill the newly allocated SLUB p=
age).<br>
&gt;<br>
&gt;<br>
&gt; =C2=A0 =C2=A0 =C2=A0 =C2=A0-=C2=A0 =C2=A0twiz<br>
</p>

--001a1134be0a77000b05300e115e--
