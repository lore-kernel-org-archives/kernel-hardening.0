Return-Path: <SRS0=iJUj=H3=lists.openwall.com=kernel-hardening-return-20829-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=0.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F5D5C433E0
	for <kernel-hardening@archiver.kernel.org>; Thu, 25 Feb 2021 08:39:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id E9B0864E20
	for <kernel-hardening@archiver.kernel.org>; Thu, 25 Feb 2021 08:39:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org E9B0864E20
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20829-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 3865 invoked by uid 550); 25 Feb 2021 08:39:13 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3844 invoked from network); 25 Feb 2021 08:39:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aGub8j3mcBFEspbVGjAffkFlNTryL5ZvYPFMwGi0YLk=;
        b=PLb1PKE7ig18Lazwu1wpkB/OirBqhhzt93MoUxb+NNdS+k6i0KGNmteNz2kBBagVVI
         pF+VrnGce/ftawB8Zn8VTB2XSqmbt8hlqO2pKAR+fO2pzEIteZjJSVzs7lza3d0dQW7J
         ZL/QaL87TkxoYTcHCZPxXjcboItXDF4ri89aSSUxt5UmWKJtI+bB1jf8JM/T1rLp65P4
         5hq2NlczVYLdbQ3YJAKPj62iLcoQ/2czL2XAKWgGSjK+sO+78EI1yxOzzofpZwGiarzR
         cdfX3lMqV0DXSRVMBnHv7GhCUEgNaTWyl+0MzM4RY471CPuDxeaxZK/0zhcjp+Nwhvxi
         SIAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aGub8j3mcBFEspbVGjAffkFlNTryL5ZvYPFMwGi0YLk=;
        b=TNNu8b5OTNuOAUdW5LOVkBploCXF2mKIGkjkqZgo6OsjDjONmmKhAUaUp1aZL2JJav
         Hz/0ZGlDecJEZu/yeL4TlBLa7E0AkDoL0WN45XQgBUlnz6v5GyH/wCWKo8FHsDh84kSV
         SrEQit6x+GNfcpob+hym7EfyWrdExb6uAqDpfN/lLcAK7fWzlR9Np9hkzRF58Mle9PH3
         T9zJsZOj3REkFf0Sdmh+QJPQW6CiW2wBz5IPrHrNG73bOqE+/zfQNozk6cRNuXQaZD7L
         PGfbRqKbH6D/YokHaKi/zk9hSVDU4UXzgobRLyXXLFHM1eL1P608ARiagPYGNKYVKi3j
         mu3g==
X-Gm-Message-State: AOAM530MvtdYGECZ5MJkjryavFiLhRqIjENpg6e6zC2jFL6f+rBxGTOB
	h9Z9TBFnGeXLTuE8+Rl6ANUVF6DJT7AVNQFCyGY=
X-Google-Smtp-Source: ABdhPJzU0RgRGY4lum9vzal+oC7Yz2Sazso+8eYxNgS4jciVeAVJfQQQv3bDbUEWQUVkcBvqjXYaYiFexiYf+PFQvJw=
X-Received: by 2002:a9d:6a45:: with SMTP id h5mr1413414otn.161.1614242340419;
 Thu, 25 Feb 2021 00:39:00 -0800 (PST)
MIME-Version: 1.0
References: <20210222151231.22572-1-romain.perier@gmail.com>
 <20210222151231.22572-17-romain.perier@gmail.com> <20210222124936.03103585@gandalf.local.home>
In-Reply-To: <20210222124936.03103585@gandalf.local.home>
From: Romain Perier <romain.perier@gmail.com>
Date: Thu, 25 Feb 2021 09:38:48 +0100
Message-ID: <CABgxDo+P4WqdzUz_OY1cVvcScnzZA3b7+Opz53aTf=A-9ZZBtw@mail.gmail.com>
Subject: Re: [PATCH 16/20] tracing/probe: Manual replacement of the deprecated
 strlcpy() with return values
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Kees Cook <keescook@chromium.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Ingo Molnar <mingo@redhat.com>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/alternative; boundary="000000000000483b7a05bc251507"

--000000000000483b7a05bc251507
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le lun. 22 f=C3=A9vr. 2021 =C3=A0 18:49, Steven Rostedt <rostedt@goodmis.or=
g> a
=C3=A9crit :

> > -     if (unlikely(!maxlen))
> > -             return -ENOMEM;
>
> Don't remove the above. You just broke the else side.
>
> > -
> > -     if (addr =3D=3D FETCH_TOKEN_COMM)
> > -             ret =3D strlcpy(dst, current->comm, maxlen);
> > -     else
> > +     if (addr =3D=3D FETCH_TOKEN_COMM) {
> > +             ret =3D strscpy(dst, current->comm, maxlen);
> > +             if (ret =3D=3D -E2BIG)
> > +                     return -ENOMEM;
>
> I'm not sure the above is what we want. current->comm is always nul
> terminated, and not only that, it will never be bigger than TASK_COMM_LEN=
.
> If the "dst" location is smaller than comm (maxlen < TASK_COMM_LEN), it i=
s
> still OK to copy a partial string. It should not return -ENOMEM which loo=
ks
> to be what happens with this patch.
>
> In other words, it looks like this patch breaks the current code in more
> ways than one.
>
> -- Steve
>

Hello,

Mhhh, *I think* that I had an issue during rebase, I don't remember to have
removed the "  if (unlikely(!maxlen))"  (sorry for that).
Well, strscpy always returns a truncated string even in case of possible
overflow, the function copies what it can in "dst", it will just return
-E2BIG when
it does not fit or when "count" has a bad value (zero or > INT_MAX). We
have just to make a difference between "-E2BIG, data has been copied to dst
and it is truncated" and "-E2BIG, possible wrong size passed as argument".

I agree that it needs at least to work like before, and I think we can
preserve the old behaviour even with strscpy (we just need to adapt the
error handling accordingly).
I will fix this in v2.

Thanks,
Romain

--000000000000483b7a05bc251507
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote">=
<div dir=3D"ltr" class=3D"gmail_attr">Le=C2=A0lun. 22 f=C3=A9vr. 2021 =C3=
=A0=C2=A018:49, Steven Rostedt &lt;<a href=3D"mailto:rostedt@goodmis.org">r=
ostedt@goodmis.org</a>&gt; a =C3=A9crit=C2=A0:<br></div><blockquote class=
=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rg=
b(204,204,204);padding-left:1ex">
&gt; -=C2=A0 =C2=A0 =C2=A0if (unlikely(!maxlen))<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return -ENOMEM;<br>
<br>
Don&#39;t remove the above. You just broke the else side.<br>
<br>
&gt; -<br>
&gt; -=C2=A0 =C2=A0 =C2=A0if (addr =3D=3D FETCH_TOKEN_COMM)<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D strlcpy(dst, =
current-&gt;comm, maxlen);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0else<br>
&gt; +=C2=A0 =C2=A0 =C2=A0if (addr =3D=3D FETCH_TOKEN_COMM) {<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D strscpy(dst, =
current-&gt;comm, maxlen);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (ret =3D=3D -E2BIG=
)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0return -ENOMEM;<br>
<br>
I&#39;m not sure the above is what we want. current-&gt;comm is always nul<=
br>
terminated, and not only that, it will never be bigger than TASK_COMM_LEN.<=
br>
If the &quot;dst&quot; location is smaller than comm (maxlen &lt; TASK_COMM=
_LEN), it is<br>
still OK to copy a partial string. It should not return -ENOMEM which looks=
<br>
to be what happens with this patch.<br>
<br>
In other words, it looks like this patch breaks the current code in more<br=
>
ways than one.<br>
<br>
-- Steve<br></blockquote><div><br></div><div>Hello,</div><div><br></div><di=
v>Mhhh, *I think* that I had an issue during rebase, I don&#39;t remember t=
o have removed the &quot;=C2=A0 if (unlikely(!maxlen))&quot;=C2=A0 (sorry f=
or that).</div><div>Well, strscpy always returns a truncated string even in=
 case of possible overflow, the function copies what it can in &quot;dst&qu=
ot;, it will just return -E2BIG when</div><div>it does not fit or when &quo=
t;count&quot; has a bad value (zero or &gt; INT_MAX). We have just to make =
a difference between &quot;-E2BIG, data has been copied to dst and it is tr=
uncated&quot; and &quot;-E2BIG, possible wrong size passed as argument&quot=
;. <br></div><div><br></div><div>I agree that it needs at least to work lik=
e before, and I think we can preserve the old behaviour even with strscpy (=
we just need to adapt the error handling accordingly).</div><div>I will fix=
 this in v2.<br></div><div><br></div><div>Thanks,</div><div>Romain<br></div=
><div>=C2=A0</div></div></div>

--000000000000483b7a05bc251507--
