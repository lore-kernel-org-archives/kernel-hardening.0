Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <CAGXu5jKy91CVe7KeeVedEHteZRv8h7o_gF7GEVCz7D=RCj+9qg@mail.gmail.com>
References: <1450364270-12687-1-git-send-email-dave@progbits.org>
	<CAGXu5jJJ13z206L6R99MYmiUA7hVYUJC5UVS8h5Mg0sUDr60GQ@mail.gmail.com>
	<CAGXu5jLsxwhrgyRfvYV79WJrrFr9tkXMe=7-qWBz6VWEsEA_5g@mail.gmail.com>
	<CAEXv5_iutxAv4HoWS5fbE+M7Di-6rhuAYTAD=Z-nJ2JAtxeS4A@mail.gmail.com>
	<CAEXv5_juGN8QxJ6jB7-1WGB7BN1-G0bUxKyD-zeCjsK4d29uzw@mail.gmail.com>
	<CAGXu5jKfe8=wmL6VFqFB8jR2pzS9EWp7Mwrt4XAEYbWcjLdjnQ@mail.gmail.com>
	<CAGXu5jKy91CVe7KeeVedEHteZRv8h7o_gF7GEVCz7D=RCj+9qg@mail.gmail.com>
Date: Thu, 28 Apr 2016 08:16:19 -0400
Message-ID: <CAEXv5_hxnuDt3nV3VEbX2u7ZMaxyqq1vaofPixb0otsUx6rQKw@mail.gmail.com>
From: David Windsor <dave@progbits.org>
Content-Type: multipart/alternative; boundary=f46d04426cce6416b605318a7ee9
Subject: Re: [kernel-hardening][RFC PATCH 0/5] Add PAX_REFCOUNT overflow protection
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

--f46d04426cce6416b605318a7ee9
Content-Type: text/plain; charset=UTF-8

Hi,

Unfortunately, I've had much less time to work on this than originally
anticipated and have gotten basically nothing done towards v3.  I still
plan on working on it, just can't give you an ETA I can realistically
commit to.

Thanks,
David


On Thursday, April 21, 2016, Kees Cook <keescook@chromium.org> wrote:

> Hi David,
>
> On Thu, Feb 4, 2016 at 10:19 AM, Kees Cook <keescook@chromium.org
> <javascript:;>> wrote:
> > On Tue, Feb 2, 2016 at 3:33 AM, David Windsor <dave@progbits.org
> <javascript:;>> wrote:
> >> FYI, I now have time to work on this again.
> >>
> >> Currently, I'm rebasing v2 atop linux-next.  I've already incorporated
> >> the following changes suggested during the on-list review of v2:
> >>
> >> * s/PAX_REFCOUNT/STRICT_REFCOUNT
> >> * Reordering the patchset in a more sane manner (per Greg KH)
> >> * Creation of the "Kernel Hardening" menu in Kconfig
> >> * Creation of per-architecture Kconfig option for opting in to
> STRICT_REFCOUNT
> >> * Whitespace fixes
> >>
> >> v3 is forthcoming and will be posted here as soon as I have the
> >> patchset rebased to linux-next.
> >
> > Thanks for the update!
> >
> > It may be helpful to mention in the changelog the two recent refcount
> > overflow bugs that would have been stopped by this mitigiation:
> >
> > CVE-2014-2851 https://cyseclabs.com/page?n=02012016
> > CVE-2016-0728
> http://perception-point.io/2016/01/14/analysis-and-exploitation-of-a-linux-kernel-vulnerability-cve-2016-0728/
>
> Any news on a v3 series? I'd love to see what you've got so far.
>
> Thanks!
>
> -Kees
>
> --
> Kees Cook
> Chrome OS & Brillo Security
>

--f46d04426cce6416b605318a7ee9
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

Hi,<div><br></div><div>Unfortunately, I&#39;ve had much less time to work o=
n this than originally anticipated and have gotten basically nothing done t=
owards v3.=C2=A0 I still plan on working on it, just can&#39;t give you an =
ETA I can realistically commit to.</div><div><br></div><div>Thanks,</div><d=
iv>David</div><div><br><div><br>On Thursday, April 21, 2016, Kees Cook &lt;=
<a href=3D"mailto:keescook@chromium.org">keescook@chromium.org</a>&gt; wrot=
e:<br><blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-l=
eft:1px #ccc solid;padding-left:1ex">Hi David,<br>
<br>
On Thu, Feb 4, 2016 at 10:19 AM, Kees Cook &lt;<a href=3D"javascript:;" onc=
lick=3D"_e(event, &#39;cvml&#39;, &#39;keescook@chromium.org&#39;)">keescoo=
k@chromium.org</a>&gt; wrote:<br>
&gt; On Tue, Feb 2, 2016 at 3:33 AM, David Windsor &lt;<a href=3D"javascrip=
t:;" onclick=3D"_e(event, &#39;cvml&#39;, &#39;dave@progbits.org&#39;)">dav=
e@progbits.org</a>&gt; wrote:<br>
&gt;&gt; FYI, I now have time to work on this again.<br>
&gt;&gt;<br>
&gt;&gt; Currently, I&#39;m rebasing v2 atop linux-next.=C2=A0 I&#39;ve alr=
eady incorporated<br>
&gt;&gt; the following changes suggested during the on-list review of v2:<b=
r>
&gt;&gt;<br>
&gt;&gt; * s/PAX_REFCOUNT/STRICT_REFCOUNT<br>
&gt;&gt; * Reordering the patchset in a more sane manner (per Greg KH)<br>
&gt;&gt; * Creation of the &quot;Kernel Hardening&quot; menu in Kconfig<br>
&gt;&gt; * Creation of per-architecture Kconfig option for opting in to STR=
ICT_REFCOUNT<br>
&gt;&gt; * Whitespace fixes<br>
&gt;&gt;<br>
&gt;&gt; v3 is forthcoming and will be posted here as soon as I have the<br=
>
&gt;&gt; patchset rebased to linux-next.<br>
&gt;<br>
&gt; Thanks for the update!<br>
&gt;<br>
&gt; It may be helpful to mention in the changelog the two recent refcount<=
br>
&gt; overflow bugs that would have been stopped by this mitigiation:<br>
&gt;<br>
&gt; CVE-2014-2851 <a href=3D"https://cyseclabs.com/page?n=3D02012016" targ=
et=3D"_blank">https://cyseclabs.com/page?n=3D02012016</a><br>
&gt; CVE-2016-0728 <a href=3D"http://perception-point.io/2016/01/14/analysi=
s-and-exploitation-of-a-linux-kernel-vulnerability-cve-2016-0728/" target=
=3D"_blank">http://perception-point.io/2016/01/14/analysis-and-exploitation=
-of-a-linux-kernel-vulnerability-cve-2016-0728/</a><br>
<br>
Any news on a v3 series? I&#39;d love to see what you&#39;ve got so far.<br=
>
<br>
Thanks!<br>
<br>
-Kees<br>
<br>
--<br>
Kees Cook<br>
Chrome OS &amp; Brillo Security<br>
</blockquote></div></div>

--f46d04426cce6416b605318a7ee9--
