Return-Path: <SRS0=7oTy=H4=lists.openwall.com=kernel-hardening-return-20847-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 77431C433E0
	for <kernel-hardening@archiver.kernel.org>; Fri, 26 Feb 2021 15:10:23 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id EB94E64D9A
	for <kernel-hardening@archiver.kernel.org>; Fri, 26 Feb 2021 15:10:21 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org EB94E64D9A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20847-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 25742 invoked by uid 550); 26 Feb 2021 15:10:12 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 25691 invoked from network); 26 Feb 2021 15:10:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=srkt/FPsH3OiGFJtktFAUPTRgoTtQPRHr/QhjT3o/S0=;
        b=cjOLAK1Eoo1gzcmRQR60aP3UxSlJM3roQgFfK1tHNhQbyA/DfbPth4K/JCpskVu5qf
         bo5LoICpewNX5nEfy8I+wGzxPfgVtPm7yy/8VcnmlQO7/kqf/y/qj0XonhSu1I2Xe43S
         9SopWlbmkblOqWIGLAM0ukihTU+TmZd4DzAoSDEHRGBBxGqRdb9i/jQCw2e45Vx5bqvg
         6NIyUSo5OokdMOUed3QJrwBbwoy9QO6R6TJHcKHEvR/tV9tBKrBEhtgMIu0xq5we/rOD
         h1VkBoa7fPlJI78CEN3LdMmGGwQS9PErRauUttQZ8rhQ9XFszHTQXYE4Fulh6SfAzJtz
         Qtxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=srkt/FPsH3OiGFJtktFAUPTRgoTtQPRHr/QhjT3o/S0=;
        b=q+8b0DNkcJUBwuCNTwqUD9kgqd8un27SyEv+b4C2oIiFOBkKb11IqYFAaQuPZUK/gb
         RgO0ScJR/0EvZ54yUY+IIrkBSQU1narPgdyNWZNbTH0QKhFvd1ZHKNh9R8g/k5TD/MpD
         zd4dgMB/S7PR3JcQoTA/UgX7H3GvdQL2jpB2034SXvBdjAntCl8ntcC1+5NvJv4q5Xzl
         5M0Jyd9AuVyqHHkcgN9qfSAHSlNX1jMnztogrvKytiQYkF8dALBtFkKuW+j8rBZ4T33M
         Vfz5ahE+9epQ23Ep0nzHxC7FMOthdICvDaC7nTX5INhYVDhzVzeyikYivNoDKutyPqP8
         xOsw==
X-Gm-Message-State: AOAM5305g3zbPHEgI2T+1ZsCP/N1tXpXzCJcsHedJiuQzxEFVoFP0e3B
	//nqGZLiumHjqbJ10KQxDftc+zIPiDxxpsn1nPw=
X-Google-Smtp-Source: ABdhPJwrfIN/KbkCc0txTnEv61sTiLyPTUtdImDzL256ivkAQjkZmS4vSsEebZEMdY7Q947kyHX9b7IUdMOygmW7K7o=
X-Received: by 2002:a05:6830:1402:: with SMTP id v2mr2578977otp.161.1614352200053;
 Fri, 26 Feb 2021 07:10:00 -0800 (PST)
MIME-Version: 1.0
References: <20210222151231.22572-1-romain.perier@gmail.com>
 <20210222151231.22572-18-romain.perier@gmail.com> <a9f26339-c366-40c4-1cd6-c7ae1838e2b6@kernel.org>
In-Reply-To: <a9f26339-c366-40c4-1cd6-c7ae1838e2b6@kernel.org>
From: Romain Perier <romain.perier@gmail.com>
Date: Fri, 26 Feb 2021 16:09:48 +0100
Message-ID: <CABgxDoJK01n+MbfEJOOz6+QoHzLEamooR_mz91nfqH5i0ok8fw@mail.gmail.com>
Subject: Re: [PATCH 17/20] vt: Manual replacement of the deprecated strlcpy()
 with return values
To: Jiri Slaby <jirislaby@kernel.org>
Cc: Kees Cook <keescook@chromium.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/alternative; boundary="0000000000006d390e05bc3ea9d4"

--0000000000006d390e05bc3ea9d4
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le ven. 26 f=C3=A9vr. 2021 =C3=A0 10:49, Jiri Slaby <jirislaby@kernel.org> =
a =C3=A9crit :

> On 22. 02. 21, 16:12, Romain Perier wrote:
> > The strlcpy() reads the entire source buffer first, it is dangerous if
> > the source buffer lenght is unbounded or possibility non NULL-terminate=
d.
>
> "length" and it's NUL, not NULL in this case.
>
> > It can lead to linear read overflows, crashes, etc...
> >
> > As recommended in the deprecated interfaces [1], it should be replaced
> > by strscpy.
> >
> > This commit replaces all calls to strlcpy that handle the return values
>
> s/that/which/ ?
> "handles"
> "value"
>
> > by the corresponding strscpy calls with new handling of the return
> > values (as it is quite different between the two functions).
>
> Sorry, I have hard times understand the whole sentence. Could you
> rephrase a bit?
>
> > [1]
> https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy
> >
> > Signed-off-by: Romain Perier <romain.perier@gmail.com>
> > ---
> >   drivers/tty/vt/keyboard.c |    5 ++++-
> >   1 file changed, 4 insertions(+), 1 deletion(-)
> >
> > diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c
> > index 77638629c562..5e20c6c307e0 100644
> > --- a/drivers/tty/vt/keyboard.c
> > +++ b/drivers/tty/vt/keyboard.c
> > @@ -2067,9 +2067,12 @@ int vt_do_kdgkb_ioctl(int cmd, struct kbsentry
> __user *user_kdgkb, int perm)
> >                       return -ENOMEM;
> >
> >               spin_lock_irqsave(&func_buf_lock, flags);
> > -             len =3D strlcpy(kbs, func_table[kb_func] ? : "", len);
> > +             len =3D strscpy(kbs, func_table[kb_func] ? : "", len);
>
> func_table[kb_func] is NUL-terminated and kbs is of length len anyway,
> so this is only cosmetical.
>
> >               spin_unlock_irqrestore(&func_buf_lock, flags);
> >
> > +             if (len =3D=3D -E2BIG)
> > +                     return -E2BIG;
> > +
>
> This can never happen, right?
>
> >               ret =3D copy_to_user(user_kdgkb->kb_string, kbs, len + 1)=
 ?
> >                       -EFAULT : 0;
> >
> >
>
>
Hello,

Yeah I will reword the commit message, I have realized that it might be
confusing in some cases. No it is
not only cosmetic, see my new commit message below (does it help ?):

"

Nowadays, strings copies are common in the kernel and strlcpy() is
widely used for this purpose. While being a very helpful function, this
has several problems:

- strlcpy() reads the entire source buffer first (since the return value
is meant to match that of strlen()). This read may exceed the destination
size limit. This can lead to linear read overflows if a source string is
not NUL-terminated.

- This is inefficient as it does not check for unaligned accesses,
copies the source into the destination with a simple byte copy and reads
the source buffer twice (even if the cache helps).

- Even when the use of strlcpy() is correct and its source buffer is
NUL-terminated, it might be an attack vector: a possible future security
breach could give the opportunity to modify the source buffer.

strscpy() instead checks for alignment constraints and, when the
conditions are met, copies word by word the sources into the destination
(while checking that it does not exceed both buffers). Its use should be
reasonably performant on all platforms since it uses the
asm/world-at-a-time.h API ranther than simple byte copy.

This commit replaces all calls to strlcpy() which handles error codes by
the corresponding call to strscpy(), while adjusting the error handling
(as it is quite different between the two functions).

[1] https://www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy

"

Regards,
Romain

--0000000000006d390e05bc3ea9d4
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote">=
<div dir=3D"ltr" class=3D"gmail_attr">Le=C2=A0ven. 26 f=C3=A9vr. 2021 =C3=
=A0=C2=A010:49, Jiri Slaby &lt;<a href=3D"mailto:jirislaby@kernel.org">jiri=
slaby@kernel.org</a>&gt; a =C3=A9crit=C2=A0:<br></div><blockquote class=3D"=
gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(20=
4,204,204);padding-left:1ex">On 22. 02. 21, 16:12, Romain Perier wrote:<br>
&gt; The strlcpy() reads the entire source buffer first, it is dangerous if=
<br>
&gt; the source buffer lenght is unbounded or possibility non NULL-terminat=
ed.<br>
<br>
&quot;length&quot; and it&#39;s NUL, not NULL in this case.<br>
<br>
&gt; It can lead to linear read overflows, crashes, etc...<br>
&gt; <br>
&gt; As recommended in the deprecated interfaces [1], it should be replaced=
<br>
&gt; by strscpy.<br>
&gt; <br>
&gt; This commit replaces all calls to strlcpy that handle the return value=
s<br>
<br>
s/that/which/ ?<br>
&quot;handles&quot;<br>
&quot;value&quot;<br>
<br>
&gt; by the corresponding strscpy calls with new handling of the return<br>
&gt; values (as it is quite different between the two functions).<br>
<br>
Sorry, I have hard times understand the whole sentence. Could you <br>
rephrase a bit?<br>
<br>
&gt; [1] <a href=3D"https://www.kernel.org/doc/html/latest/process/deprecat=
ed.html#strlcpy" rel=3D"noreferrer" target=3D"_blank">https://www.kernel.or=
g/doc/html/latest/process/deprecated.html#strlcpy</a><br>
&gt; <br>
&gt; Signed-off-by: Romain Perier &lt;<a href=3D"mailto:romain.perier@gmail=
.com" target=3D"_blank">romain.perier@gmail.com</a>&gt;<br>
&gt; ---<br>
&gt;=C2=A0 =C2=A0drivers/tty/vt/keyboard.c |=C2=A0 =C2=A0 5 ++++-<br>
&gt;=C2=A0 =C2=A01 file changed, 4 insertions(+), 1 deletion(-)<br>
&gt; <br>
&gt; diff --git a/drivers/tty/vt/keyboard.c b/drivers/tty/vt/keyboard.c<br>
&gt; index 77638629c562..5e20c6c307e0 100644<br>
&gt; --- a/drivers/tty/vt/keyboard.c<br>
&gt; +++ b/drivers/tty/vt/keyboard.c<br>
&gt; @@ -2067,9 +2067,12 @@ int vt_do_kdgkb_ioctl(int cmd, struct kbsentry =
__user *user_kdgkb, int perm)<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0return -ENOMEM;<br>
&gt;=C2=A0 =C2=A0<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_lock_irqsav=
e(&amp;func_buf_lock, flags);<br>
&gt; -=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0len =3D strlcpy(kbs, =
func_table[kb_func] ? : &quot;&quot;, len);<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0len =3D strscpy(kbs, =
func_table[kb_func] ? : &quot;&quot;, len);<br>
<br>
func_table[kb_func] is NUL-terminated and kbs is of length len anyway, <br>
so this is only cosmetical.<br>
<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0spin_unlock_irqr=
estore(&amp;func_buf_lock, flags);<br>
&gt;=C2=A0 =C2=A0<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0if (len =3D=3D -E2BIG=
)<br>
&gt; +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0return -E2BIG;<br>
&gt; +<br>
<br>
This can never happen, right?<br>
<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ret =3D copy_to_=
user(user_kdgkb-&gt;kb_string, kbs, len + 1) ?<br>
&gt;=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0-EFAULT : 0;<br>
&gt;=C2=A0 =C2=A0<br>
&gt; <br>
<br></blockquote><div><br></div><div>
<div>Hello,</div><div><br></div><div>Yeah I will reword the commit message,=
 I have realized that it might be confusing in some cases. No it is</div><d=
iv>not only cosmetic, see my new commit message below (does it help ?):</di=
v><div><br></div><div>&quot;</div><div>
<pre class=3D"gmail-commit-description">Nowadays, strings copies are common=
 in the kernel and strlcpy() is
widely used for this purpose. While being a very helpful function, this
has several problems:

- strlcpy() reads the entire source buffer first (since the return value
is meant to match that of strlen()). This read may exceed the destination
size limit. This can lead to linear read overflows if a source string is
not NUL-terminated.

- This is inefficient as it does not check for unaligned accesses,
copies the source into the destination with a simple byte copy and reads
the source buffer twice (even if the cache helps).

- Even when the use of strlcpy() is correct and its source buffer is
NUL-terminated, it might be an attack vector: a possible future security
breach could give the opportunity to modify the source buffer.

strscpy() instead checks for alignment constraints and, when the
conditions are met, copies word by word the sources into the destination
(while checking that it does not exceed both buffers). Its use should be
reasonably performant on all platforms since it uses the
asm/world-at-a-time.h API ranther than simple byte copy.

This commit replaces all calls to strlcpy() which handles error codes by
the corresponding call to strscpy(), while adjusting the error handling
(as it is quite different between the two functions).

[1] <a href=3D"https://www.kernel.org/doc/html/latest/process/deprecated.ht=
ml#strlcpy" rel=3D"nofollow noreferrer noopener" target=3D"_blank">https://=
www.kernel.org/doc/html/latest/process/deprecated.html#strlcpy</a></pre>&qu=
ot;</div><div><br></div><div>Regards,</div><div>Romain<br></div>=C2=A0 <br>=
</div></div></div>

--0000000000006d390e05bc3ea9d4--
