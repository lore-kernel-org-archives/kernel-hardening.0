Return-Path: <kernel-hardening-return-21710-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id 68629C07545
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Oct 2023 15:56:19 +0000 (UTC)
Received: (qmail 11689 invoked by uid 550); 24 Oct 2023 15:56:08 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11639 invoked from network); 24 Oct 2023 15:56:06 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sempervictus-com.20230601.gappssmtp.com; s=20230601; t=1698162955; x=1698767755; darn=lists.openwall.com;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=E94RLmyMd1HiweNv7aByojK3JqrvIFEoVQvzRulxw0o=;
        b=nmdmWsQkzlJGxjFL43Pjcyh2y4tB/NkSTfefZ6BGpMaY/Ml46EI8/Pbttf9NooBPd8
         phlOSdZw2WYsgLrCauitX9GxGtWps/jiPoRH1LlZpUFciVLSgrG8QqnMUO0R3id+9utI
         4X/e9IwN4Hx/52ji55VobOqhW6uyk0Pg4cdftbWzcsiXJ2uGU7+EhZps5/5XCrGKy+H6
         n/uD9Zxq/16ZJHt1DwXJqpv8BGOBhUKmF3W3SLP6E5spVQfz/o3DfPdOmEFLTsTdvzfK
         1Hvcr1AgZeboFu38SknfudwnWbdeaEVgAR822lw4kkWQPxPMdZRVNXq3i9xkiIp97unI
         4O1g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698162955; x=1698767755;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E94RLmyMd1HiweNv7aByojK3JqrvIFEoVQvzRulxw0o=;
        b=CUD1WVEBYvuRuogTWkLvKJrB+L+USXSafRXGn7UW7Xt1wn51C4ytmIEOhqrTpXKdE1
         BlDJVFb32d9XiswEOhhkXCNXyjmHfLYFVLxchHQPVlaN2qFNDAhZsMMnFDYbWLtT61Aj
         0IHyoy90uJzTS+ca6xZtqoWfJBmr47jAsfgENzSLRlc8mKixDhOkrAQCx2sOrwkjPbKr
         G9WW8ogmgzvT35Ox5EXb7U3OhqCNTQ94yj83O8L6X0J6mwE40JUdSeLVbKB0pC4aq1X8
         hdbQd8cMlvH9eXrDfs3X/fQQfFp4Gg/P9Vm8Mva0KXamc9L4YeacSos9dkzqZ6JhPQQK
         fHdQ==
X-Gm-Message-State: AOJu0Yzyu54ezIk0T5IUd65PzhViXSgiYX3cw0LFsXgXXCTsO9WxJbtb
	4auEMuq9/ux4DOI0EEWjQp9aXGzsrWu+cBfZHMqvHQ==
X-Google-Smtp-Source: AGHT+IF0tmf8XNk/2f4CcL+8SuwkOoHkvNg7YiK34SZRP0YXoEriNpE1GN52TzGlhrzjr3vtL5EBfTK7s8sFKcKPZz8=
X-Received: by 2002:a17:90a:fb48:b0:27d:4259:b7ef with SMTP id
 iq8-20020a17090afb4800b0027d4259b7efmr13729067pjb.23.1698162954818; Tue, 24
 Oct 2023 08:55:54 -0700 (PDT)
MIME-Version: 1.0
References: <Y59qBh9rRDgsIHaj@mailbox.org> <20231024134608.GC320399@mail.hallyn.com>
 <BE62D2CD-63CD-435A-A290-4608CF1A46D4@sempervictus.com> <20231024141512.GA321218@mail.hallyn.com>
In-Reply-To: <20231024141512.GA321218@mail.hallyn.com>
From: Boris Lukashev <blukashev@sempervictus.com>
Date: Tue, 24 Oct 2023 11:55:43 -0400
Message-ID: <CAFUG7Cfzg7LaQhhN_Vk+doOzXQ_3n4aY--mK2mORsd36MWWJjQ@mail.gmail.com>
Subject: Re: Isolating abstract sockets
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: kernel-hardening@lists.openwall.com, 
	Stefan Bavendiek <stefan.bavendiek@mailbox.org>, linux-hardening@vger.kernel.org
Content-Type: multipart/alternative; boundary="000000000000b16f210608785f10"

--000000000000b16f210608785f10
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Good point: from the "resources granted to a user" perspective, that does
help bound their consumption. The nomenclature distinction seems like a
good one to have, but if "network namespaces" *change the meaning of the
term *and the original definition becomes "network device namespaces," then
there would be a period where older and newer kernels have very different
functions mapped to the same conceptual name. Might this make a bit more
sense as "network namespaces" meaning what they do now - "network device
namespaces," effectively; while the new concept would be "socket
namespaces" to account for the various socket style interfaces provided?

Thanks
-Boris

On Tue, Oct 24, 2023 at 10:15=E2=80=AFAM Serge E. Hallyn <serge@hallyn.com>=
 wrote:

> Thanks for the reply.  Do you have any papers which came out of this r&d
> phase?  Sounds very interesting.
>
> > Multiple NS' sharing an IP stack would exhaust ephemeral ranges faster
>
> Yes, but that could be a feature.  I think of it as:  I'm unprivileged
> user serge, and I want to fire off firefox in a whatzit-namespace so
> that I can redirect or forbid some connections.  In this case, the
> admins have not agreed to let me double my resource usage, so the fact
> that the new namespace is sharing mine is a feature.  And this lets
> me use network-namespace-like features completely unprivileged, without
> having to use a setuid-root helper to hook up a bridge.
>
> But, I didn't send this reply to advocate this approach.  My main point
> was to mention that "network namespaces are network device namespaces"
> and hope that others would bring other suggestions for alternatives.
>
> -serge
>
> On Tue, Oct 24, 2023 at 10:05:29AM -0400, Boris Lukashev wrote:
> > Namespacing at OSI4 seems a bit fraught as the underlying route, mac,
> and physdev fall outside the callers control. Multiple NS' sharing an IP
> stack would exhaust ephemeral ranges faster (likely asymmetrically too) a=
nd
> have bound socket collisions opaque to each other requiring handling
> outside the NS/containers purview. We looked at this sort of thing during
> the r&d phase of our assured comms work (namespaces were young) and found=
 a
> bunch of overhead and collision concerns. Not saying it can't be done, bu=
t
> getting consumers to play nice enough with such an approach may be a heav=
y
> lift.
> >
> > Thanks,
> > -Boris
> >
> >
> > On October 24, 2023 9:46:08 AM EDT, "Serge E. Hallyn" <serge@hallyn.com=
>
> wrote:
> > >On Sun, Dec 18, 2022 at 08:29:10PM +0100, Stefan Bavendiek wrote:
> > >> When building userspace application sandboxes, one issue that does
> not seem trivial to solve is the isolation of abstract sockets.
> > >
> > >Veeery late reply.  Have you had any productive discussions about this
> in
> > >other threads or venues?
> > >
> > >> While most IPC mechanism can be isolated by mechanisms like mount
> namespaces, abstract sockets are part of the network namespace.
> > >> It is possible to isolate abstract sockets by using a new network
> namespace, however, unprivileged processes can only create a new empty
> network namespace, which removes network access as well and makes this
> useless for network clients.
> > >>
> > >> Same linux sandbox projects try to solve this by bridging the
> existing network interfaces into the new namespace or use something like
> slirp4netns to archive this, but this does not look like an ideal solutio=
n
> to this problem, especially since sandboxing should reduce the kernel
> attack surface without introducing more complexity.
> > >>
> > >> Aside from containers using namespaces, sandbox implementations base=
d
> on seccomp and landlock would also run into the same problem, since
> landlock only provides file system isolation and seccomp cannot filter th=
e
> path argument and therefore it can only be used to block new unix domain
> socket connections completely.
> > >>
> > >> Currently there does not seem to be any way to disable network
> namespaces in the kernel without also disabling unix domain sockets.
> > >>
> > >> The question is how to solve the issue of abstract socket isolation
> in a clean and efficient way, possibly even without namespaces.
> > >> What would be the ideal way to implement a mechanism to disable
> abstract sockets either globally or even better, in the context of a
> process.
> > >> And would such a patch have a realistic chance to make it into the
> kernel?
> > >
> > >Disabling them altogether would break lots of things depending on them=
,
> > >like X :)  (@/tmp/.X11-unix/X0).  The other path is to reconsider
> network
> > >namespaces.  There are several directions this could lead.  For one, a=
s
> > >Dinesh Subhraveti often points out, the current "network" namespace is
> > >really a network device namespace.  If we instead namespace at the
> > >bind/connect/etc calls, we end up with much different abilities.  You
> > >can implement something like this today using seccomp-filter.
> > >
> > >-serge
>


--=20
Boris Lukashev
Systems Architect
Semper Victus <https://www.sempervictus.com>

--000000000000b16f210608785f10
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Good point: from the &quot;resources granted to a use=
r&quot; perspective, that does help bound their consumption. The nomenclatu=
re distinction seems like a good one to have, but if &quot;network namespac=
es&quot; <i>change the meaning of the term </i>and the original definition =
becomes &quot;network device namespaces,&quot; then there would be a period=
 where older and newer kernels have very different functions mapped to the =
same conceptual name. Might this make a bit more sense as &quot;network nam=
espaces&quot; meaning what they do now - &quot;network device namespaces,&q=
uot; effectively; while the new concept would be &quot;socket namespaces&qu=
ot; to account for the various socket style interfaces provided?</div><div>=
<br></div><div>Thanks</div><div>-Boris<br></div></div><br><div class=3D"gma=
il_quote"><div dir=3D"ltr" class=3D"gmail_attr">On Tue, Oct 24, 2023 at 10:=
15=E2=80=AFAM Serge E. Hallyn &lt;<a href=3D"mailto:serge@hallyn.com">serge=
@hallyn.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_quote" style=
=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);padding=
-left:1ex">Thanks for the reply.=C2=A0 Do you have any papers which came ou=
t of this r&amp;d<br>
phase?=C2=A0 Sounds very interesting.<br>
<br>
&gt; Multiple NS&#39; sharing an IP stack would exhaust ephemeral ranges fa=
ster<br>
<br>
Yes, but that could be a feature.=C2=A0 I think of it as:=C2=A0 I&#39;m unp=
rivileged<br>
user serge, and I want to fire off firefox in a whatzit-namespace so<br>
that I can redirect or forbid some connections.=C2=A0 In this case, the<br>
admins have not agreed to let me double my resource usage, so the fact<br>
that the new namespace is sharing mine is a feature.=C2=A0 And this lets<br=
>
me use network-namespace-like features completely unprivileged, without<br>
having to use a setuid-root helper to hook up a bridge.<br>
<br>
But, I didn&#39;t send this reply to advocate this approach.=C2=A0 My main =
point<br>
was to mention that &quot;network namespaces are network device namespaces&=
quot;<br>
and hope that others would bring other suggestions for alternatives.<br>
<br>
-serge<br>
<br>
On Tue, Oct 24, 2023 at 10:05:29AM -0400, Boris Lukashev wrote:<br>
&gt; Namespacing at OSI4 seems a bit fraught as the underlying route, mac, =
and physdev fall outside the callers control. Multiple NS&#39; sharing an I=
P stack would exhaust ephemeral ranges faster (likely asymmetrically too) a=
nd have bound socket collisions opaque to each other requiring handling out=
side the NS/containers purview. We looked at this sort of thing during the =
r&amp;d phase of our assured comms work (namespaces were young) and found a=
 bunch of overhead and collision concerns. Not saying it can&#39;t be done,=
 but getting consumers to play nice enough with such an approach may be a h=
eavy lift.<br>
&gt; <br>
&gt; Thanks,<br>
&gt; -Boris<br>
&gt; <br>
&gt; <br>
&gt; On October 24, 2023 9:46:08 AM EDT, &quot;Serge E. Hallyn&quot; &lt;<a=
 href=3D"mailto:serge@hallyn.com" target=3D"_blank">serge@hallyn.com</a>&gt=
; wrote:<br>
&gt; &gt;On Sun, Dec 18, 2022 at 08:29:10PM +0100, Stefan Bavendiek wrote:<=
br>
&gt; &gt;&gt; When building userspace application sandboxes, one issue that=
 does not seem trivial to solve is the isolation of abstract sockets.<br>
&gt; &gt;<br>
&gt; &gt;Veeery late reply.=C2=A0 Have you had any productive discussions a=
bout this in<br>
&gt; &gt;other threads or venues?<br>
&gt; &gt;<br>
&gt; &gt;&gt; While most IPC mechanism can be isolated by mechanisms like m=
ount namespaces, abstract sockets are part of the network namespace.<br>
&gt; &gt;&gt; It is possible to isolate abstract sockets by using a new net=
work namespace, however, unprivileged processes can only create a new empty=
 network namespace, which removes network access as well and makes this use=
less for network clients.<br>
&gt; &gt;&gt; <br>
&gt; &gt;&gt; Same linux sandbox projects try to solve this by bridging the=
 existing network interfaces into the new namespace or use something like s=
lirp4netns to archive this, but this does not look like an ideal solution t=
o this problem, especially since sandboxing should reduce the kernel attack=
 surface without introducing more complexity.<br>
&gt; &gt;&gt; <br>
&gt; &gt;&gt; Aside from containers using namespaces, sandbox implementatio=
ns based on seccomp and landlock would also run into the same problem, sinc=
e landlock only provides file system isolation and seccomp cannot filter th=
e path argument and therefore it can only be used to block new unix domain =
socket connections completely.<br>
&gt; &gt;&gt; <br>
&gt; &gt;&gt; Currently there does not seem to be any way to disable networ=
k namespaces in the kernel without also disabling unix domain sockets.<br>
&gt; &gt;&gt; <br>
&gt; &gt;&gt; The question is how to solve the issue of abstract socket iso=
lation in a clean and efficient way, possibly even without namespaces.<br>
&gt; &gt;&gt; What would be the ideal way to implement a mechanism to disab=
le abstract sockets either globally or even better, in the context of a pro=
cess.<br>
&gt; &gt;&gt; And would such a patch have a realistic chance to make it int=
o the kernel?<br>
&gt; &gt;<br>
&gt; &gt;Disabling them altogether would break lots of things depending on =
them,<br>
&gt; &gt;like X :)=C2=A0 (@/tmp/.X11-unix/X0).=C2=A0 The other path is to r=
econsider network<br>
&gt; &gt;namespaces.=C2=A0 There are several directions this could lead.=C2=
=A0 For one, as<br>
&gt; &gt;Dinesh Subhraveti often points out, the current &quot;network&quot=
; namespace is<br>
&gt; &gt;really a network device namespace.=C2=A0 If we instead namespace a=
t the<br>
&gt; &gt;bind/connect/etc calls, we end up with much different abilities.=
=C2=A0 You<br>
&gt; &gt;can implement something like this today using seccomp-filter.<br>
&gt; &gt;<br>
&gt; &gt;-serge<br>
</blockquote></div><br clear=3D"all"><br><span class=3D"gmail_signature_pre=
fix">-- </span><br><div dir=3D"ltr" class=3D"gmail_signature"><div dir=3D"l=
tr"><div><div dir=3D"ltr"><div><div dir=3D"ltr">Boris Lukashev<br>Systems A=
rchitect<br><a href=3D"https://www.sempervictus.com" target=3D"_blank">Semp=
er Victus</a><br></div></div></div></div></div></div>

--000000000000b16f210608785f10--
