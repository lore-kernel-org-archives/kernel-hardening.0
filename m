Return-Path: <SRS0=WX/I=IA=lists.openwall.com=kernel-hardening-return-20868-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FDCBC433E0
	for <kernel-hardening@archiver.kernel.org>; Tue,  2 Mar 2021 06:44:24 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 8BBEE614A7
	for <kernel-hardening@archiver.kernel.org>; Tue,  2 Mar 2021 06:44:23 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 8BBEE614A7
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20868-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 11356 invoked by uid 550); 2 Mar 2021 06:44:15 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 11323 invoked from network); 2 Mar 2021 06:44:14 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cmeTIn09m7mqrLGSbdNHfGvloq8Bhn86c2Jyv595+T8=;
        b=Usr2z52DL1azLMw7Tx4l5o7o0oj2Rw8+wqi/l7N20T4V0nVGj/1rJ67DxK042FGWEE
         5MyjNK+o7qcuK9BxBS/2e5UY7qlG2nVkfZ3hpYpkjPg51mNyHKiH3/WZuC2F2mpf6WGF
         Zqn1g3bj6uwkSEpz6jp17cf6W4U5SQjfJSkeZel2ca51+GPix1dK+hV7T3kDFmoUcFOS
         fwYBq+tzUwkgiS+52dzqNATiWA03/HBimsjT8R9/TODyO4RV8uXa/mD+qflfcGYkzqGq
         +Hy+bwhOBqV4ovolarw+OTf5zMjRu1GrpLuv3PPBWG9NxDXoB4wpsEFzXIfFog2YBIXj
         DvtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cmeTIn09m7mqrLGSbdNHfGvloq8Bhn86c2Jyv595+T8=;
        b=XY0hFSQsu0cNraPkCFsW6aLBCosWwWNE84u1z+fYjbGWRX0niE9Lr/MhdSLj39TJWo
         +cHnkLYk3lvs7JJMBWyBe/xbdLGnzds7jdZ17SCR6XN63xCG+HRyHNsaChkdzfNFcMkA
         3F3N2aVIETcJKPtZUlP5sb7ms+WFL5qmrSKtNALsbhh7iKzGUmhNFdqbvA/CYioHxPOd
         qP6FMS9H7ymGU0a6DldHkFxW7E4dezuRM9nYhUcgLKqQ3ZEel2ILJwLsXrTw7wDYHGUF
         b3sFDWNBO8ozAdIWA1sViwOhidTFXz6UYkW+CiwEgqhJJb3+E7frUeKGYhdntubrv/mE
         Wb6Q==
X-Gm-Message-State: AOAM533ACJkSUFiOLOoYXS+She3ztcI3+hXze4M6uiKDTY73FoPqRAPe
	tduHvtIL9AzOHbfaVx+Z0OC+i3xkPrG9Poj0zy4=
X-Google-Smtp-Source: ABdhPJztyfsUekc1YCSZw4pEL1IXO4aLXbN0fe7zS45+vR8lO19AbKAH9Md9nHZPxtL1EpNtbcqF88v8vX/o/OuFjqg=
X-Received: by 2002:a4a:d994:: with SMTP id k20mr15583036oou.70.1614667442624;
 Mon, 01 Mar 2021 22:44:02 -0800 (PST)
MIME-Version: 1.0
References: <20210222151231.22572-1-romain.perier@gmail.com>
 <20210222151231.22572-8-romain.perier@gmail.com> <34ECB5D0-6E9F-4FF0-A41D-C4DD4505EB5C@oracle.com>
In-Reply-To: <34ECB5D0-6E9F-4FF0-A41D-C4DD4505EB5C@oracle.com>
From: Romain Perier <romain.perier@gmail.com>
Date: Tue, 2 Mar 2021 07:43:51 +0100
Message-ID: <CABgxDoLv5SJb+NFaTgHkZceyRWWdj2gw+KrwQN=bNyY1iuwdKA@mail.gmail.com>
Subject: Re: [PATCH 07/20] SUNRPC: Manual replacement of the deprecated
 strlcpy() with return values
To: Chuck Lever <chuck.lever@oracle.com>
Cc: Kees Cook <keescook@chromium.org>, 
	"kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Bruce Fields <bfields@fieldses.org>, 
	Linux NFS Mailing List <linux-nfs@vger.kernel.org>, 
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: multipart/alternative; boundary="000000000000591d6305bc880fbb"

--000000000000591d6305bc880fbb
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hey,

Yeah, but I think it can wait for v2, I am preparing a v2 series with a
better explanation in the commit message
and few improvements.

Thanks,
Romain

Le lun. 1 mars 2021 =C3=A0 19:25, Chuck Lever <chuck.lever@oracle.com> a =
=C3=A9crit :

>
>
> > On Feb 22, 2021, at 10:12 AM, Romain Perier <romain.perier@gmail.com>
> wrote:
> >
> > The strlcpy() reads the entire source buffer first, it is dangerous if
> > the source buffer lenght is unbounded or possibility non NULL-terminate=
d.
> > It can lead to linear read overflows, crashes, etc...
> >
> > As recommended in the deprecated interfaces [1], it should be replaced
> > by strscpy.
> >
> > This commit replaces all calls to strlcpy that handle the return values
> > by the corresponding strscpy calls with new handling of the return
> > values (as it is quite different between the two functions).
> >
> > [1]
> https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
> >
> > Signed-off-by: Romain Perier <romain.perier@gmail.com>
>
> Hi Romain-
>
> I assume you are waiting for a maintainer's Ack? IMHO Trond or Anna
> should provide it for changes to this particular source file.
>
>
> > ---
> > net/sunrpc/clnt.c |    6 +++++-
> > 1 file changed, 5 insertions(+), 1 deletion(-)
> >
> > diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c
> > index 612f0a641f4c..3c5c4ad8a808 100644
> > --- a/net/sunrpc/clnt.c
> > +++ b/net/sunrpc/clnt.c
> > @@ -282,7 +282,7 @@ static struct rpc_xprt
> *rpc_clnt_set_transport(struct rpc_clnt *clnt,
> >
> > static void rpc_clnt_set_nodename(struct rpc_clnt *clnt, const char
> *nodename)
> > {
> > -     clnt->cl_nodelen =3D strlcpy(clnt->cl_nodename,
> > +     clnt->cl_nodelen =3D strscpy(clnt->cl_nodename,
> >                       nodename, sizeof(clnt->cl_nodename));
> > }
> >
> > @@ -422,6 +422,10 @@ static struct rpc_clnt * rpc_new_client(const
> struct rpc_create_args *args,
> >               nodename =3D utsname()->nodename;
> >       /* save the nodename */
> >       rpc_clnt_set_nodename(clnt, nodename);
> > +     if (clnt->cl_nodelen =3D=3D -E2BIG) {
> > +             err =3D -ENOMEM;
> > +             goto out_no_path;
> > +     }
> >
> >       err =3D rpc_client_register(clnt, args->authflavor,
> args->client_name);
> >       if (err)
> >
>
> --
> Chuck Lever
>
>
>
>

--000000000000591d6305bc880fbb
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hey,</div><div><br></div><div>Yeah, but I think it ca=
n wait for v2, I am preparing a v2 series with a better explanation in the =
commit message</div><div>and few improvements.</div><div><br></div><div>Tha=
nks,</div><div>Romain<br></div></div><br><div class=3D"gmail_quote"><div di=
r=3D"ltr" class=3D"gmail_attr">Le=C2=A0lun. 1 mars 2021 =C3=A0=C2=A019:25, =
Chuck Lever &lt;<a href=3D"mailto:chuck.lever@oracle.com">chuck.lever@oracl=
e.com</a>&gt; a =C3=A9crit=C2=A0:<br></div><blockquote class=3D"gmail_quote=
" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,204);=
padding-left:1ex"><br>
<br>
&gt; On Feb 22, 2021, at 10:12 AM, Romain Perier &lt;<a href=3D"mailto:roma=
in.perier@gmail.com" target=3D"_blank">romain.perier@gmail.com</a>&gt; wrot=
e:<br>
&gt; <br>
&gt; The strlcpy() reads the entire source buffer first, it is dangerous if=
<br>
&gt; the source buffer lenght is unbounded or possibility non NULL-terminat=
ed.<br>
&gt; It can lead to linear read overflows, crashes, etc...<br>
&gt; <br>
&gt; As recommended in the deprecated interfaces [1], it should be replaced=
<br>
&gt; by strscpy.<br>
&gt; <br>
&gt; This commit replaces all calls to strlcpy that handle the return value=
s<br>
&gt; by the corresponding strscpy calls with new handling of the return<br>
&gt; values (as it is quite different between the two functions).<br>
&gt; <br>
&gt; [1] <a href=3D"https://www.kernel.org/doc/html/latest/process/deprecat=
ed.html#strlcpy" rel=3D"noreferrer" target=3D"_blank">https://www.kernel.or=
g/doc/html/latest/process/deprecated.html#strlcpy</a><br>
&gt; <br>
&gt; Signed-off-by: Romain Perier &lt;<a href=3D"mailto:romain.perier@gmail=
.com" target=3D"_blank">romain.perier@gmail.com</a>&gt;<br>
<br>
Hi Romain-<br>
<br>
I assume you are waiting for a maintainer&#39;s Ack? IMHO Trond or Anna<br>
should provide it for changes to this particular source file.<br>
<br>
<br>
&gt; ---<br>
&gt; net/sunrpc/clnt.c |=C2=A0 =C2=A0 6 +++++-<br>
&gt; 1 file changed, 5 insertions(+), 1 deletion(-)<br>
&gt; <br>
&gt; diff --git a/net/sunrpc/clnt.c b/net/sunrpc/clnt.c<br>
&gt; index 612f0a641f4c..3c5c4ad8a808 100644<br>
&gt; --- a/net/sunrpc/clnt.c<br>
&gt; +++ b/net/sunrpc/clnt.c<br>
&gt; @@ -282,7 +282,7 @@ static struct rpc_xprt *rpc_clnt_set_transport(str=
uct rpc_clnt *clnt,<br>
&gt; <br>
&gt; static void rpc_clnt_set_nodename(struct rpc_clnt *clnt, const char *n=
odename)<br>
&gt; {<br>
&gt; -=C2=A0 =C2=A0 =C2=A0clnt-&gt;cl_nodelen =3D strlcpy(clnt-&gt;cl_noden=
ame,<br>
&gt; +=C2=A0 =C2=A0 =C2=A0clnt-&gt;cl_nodelen =3D strscpy(clnt-&gt;cl_noden=
ame,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0nodename, sizeof(clnt-&gt;cl_nodename));<br>
&gt; }<br>
&gt; <br>
&gt; @@ -422,6 +422,10 @@ static struct rpc_clnt * rpc_new_client(const str=
uct rpc_create_args *args,<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0nodename =3D uts=
name()-&gt;nodename;<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0/* save the nodename */<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0rpc_clnt_set_nodename(clnt, nodename);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (clnt-&gt;cl_nodelen =3D=3D -E2BIG) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D -ENOMEM;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0goto out_no_path;<br>
&gt; +=C2=A0 =C2=A0 =C2=A0}<br>
&gt; <br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0err =3D rpc_client_register(clnt, args-&gt;a=
uthflavor, args-&gt;client_name);<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0if (err)<br>
&gt; <br>
<br>
--<br>
Chuck Lever<br>
<br>
<br>
<br>
</blockquote></div>

--000000000000591d6305bc880fbb--
