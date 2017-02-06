MIME-Version: 1.0
In-Reply-To: <20170206151341.GA13383@kroah.com>
References: <CAEXv5_ivEPDJSaJwmx+oLiUYRZsAa9ZPWH6oWZy-Rkoa3ZHRZg@mail.gmail.com>
 <20170206151341.GA13383@kroah.com>
From: David Windsor <dwindsor@gmail.com>
Date: Mon, 6 Feb 2017 10:19:14 -0500
Message-ID: <CAEXv5_g4zLSJCrfPWUe85UdyOo1WDGdw2LLXOkcjbf5kf4VnTw@mail.gmail.com>
Content-Type: multipart/alternative; boundary=001a11425e448ceae50547de2717
Subject: [kernel-hardening] Re: HARDENED_ATOMIC documentation
To: Greg KH <gregkh@linuxfoundation.org>
Cc: kernel-hardening@lists.openwall.com, "Reshetova, Elena" <elena.reshetova@intel.com>, Kees Cook <keescook@chromium.org>, Hans Liljestrand <ishkamiel@gmail.com>, Peter Zijlstra <peterz@infradead.org>
List-ID: <kernel-hardening.lists.openwall.com>

--001a11425e448ceae50547de2717
Content-Type: text/plain; charset=UTF-8

On Mon, Feb 6, 2017 at 10:13 AM, Greg KH <gregkh@linuxfoundation.org> wrote:

> On Mon, Feb 06, 2017 at 09:55:41AM -0500, David Windsor wrote:
> > Hi,
> >
> > I've put together some preliminary documentation for HARDENED_ATOMIC.
> This
> > will be in addition to the in-tree documentation earlier submitted for
> review.
> > This documentation contains only an API definition and examples.
> Justification
> > and background info for HARDENED_ATOMIC are included in the in-tree
> > documentation, so I didn't recreate this info in the kernsec.org
> > documentation.  Thoughts about this?
> >
> > You can find this documentation at http://kernsec.org/wiki/index.php/
> > Kernel_Protections/HARDENED_ATOMIC.
> >
> > Please take a look and let me know your comments.
>
> Please just send it as a patch so that we can comment on it, as well as
> don't send html email because the mailing lists reject it!
>
>
Sorry, I might not have been clear: this is just a request to review the
documentation I posted on kernsec.org for the HARDENED_ATOMIC portion of
KSPP.  We're going to use kernsec.org as a place to host additional
documentation for KSPP and its related sub-projects.  There isn't an
in-tree portion of this, so I'm not sure what I could submit a patch
against.  I probably shouldn't have directly CC'ed you on this; my
apologies!


> thanks,
>
> greg k-h
>

--001a11425e448ceae50547de2717
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">On Mon, Feb 6, 2017 at 10:13 AM, Greg KH <span dir=3D"ltr"=
>&lt;<a href=3D"mailto:gregkh@linuxfoundation.org" target=3D"_blank">gregkh=
@linuxfoundation.org</a>&gt;</span> wrote:<br><div class=3D"gmail_extra"><d=
iv class=3D"gmail_quote"><blockquote class=3D"gmail_quote" style=3D"margin:=
0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding-left:1ex">=
<span class=3D"gmail-">On Mon, Feb 06, 2017 at 09:55:41AM -0500, David Wind=
sor wrote:<br>
&gt; Hi,<br>
&gt;<br>
&gt; I&#39;ve put together some preliminary documentation for HARDENED_ATOM=
IC.=C2=A0 This<br>
&gt; will be in addition to the in-tree documentation earlier submitted for=
 review.=C2=A0<br>
&gt; This documentation contains only an API definition and examples.=C2=A0=
 Justification<br>
&gt; and background info for HARDENED_ATOMIC are included in the in-tree<br=
>
&gt; documentation, so I didn&#39;t recreate this info in the <a href=3D"ht=
tp://kernsec.org" rel=3D"noreferrer" target=3D"_blank">kernsec.org</a><br>
&gt; documentation.=C2=A0 Thoughts about this?<br>
&gt;<br>
&gt; You can find this documentation at <a href=3D"http://kernsec.org/wiki/=
index.php/" rel=3D"noreferrer" target=3D"_blank">http://kernsec.org/wiki/in=
dex.<wbr>php/</a><br>
&gt; Kernel_Protections/HARDENED_<wbr>ATOMIC.=C2=A0<br>
&gt;<br>
&gt; Please take a look and let me know your comments.<br>
<br>
</span>Please just send it as a patch so that we can comment on it, as well=
 as<br>
don&#39;t send html email because the mailing lists reject it!<br>
<br></blockquote><div><br>Sorry, I might not have been clear: this is just =
a request to review the
 documentation I posted on <a href=3D"http://kernsec.org">kernsec.org</a> f=
or the HARDENED_ATOMIC portion=20
of KSPP.=C2=A0 We&#39;re going to use <a href=3D"http://kernsec.org">kernse=
c.org</a> as a place to host additional documentation for KSPP and its rela=
ted sub-projects.=C2=A0 There isn&#39;t an in-tree portion of this, so I&#3=
9;m not sure what I
 could submit a patch against.=C2=A0 I probably shouldn&#39;t have directly=
 CC&#39;ed
 you on this; my apologies!<br>=C2=A0</div><blockquote class=3D"gmail_quote=
" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);=
padding-left:1ex">
thanks,<br>
<br>
greg k-h<br>
</blockquote></div><br></div></div>

--001a11425e448ceae50547de2717--
