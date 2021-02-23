Return-Path: <SRS0=ofQf=HZ=lists.openwall.com=kernel-hardening-return-20815-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5BF33C433DB
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Feb 2021 17:49:44 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 6FB8A6146D
	for <kernel-hardening@archiver.kernel.org>; Tue, 23 Feb 2021 17:49:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 6FB8A6146D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-20815-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 9475 invoked by uid 550); 23 Feb 2021 17:49:36 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 9439 invoked from network); 23 Feb 2021 17:49:35 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=s4LS5XCNRp5oX+FKr8Qy3XQXn0REfCMITuWxGTNshFM=;
        b=tbVMHFu3xeXOKHe8qLnVi7H1oIGCQBSrauKmdjVAs7E2Pv6LFNeUQPPtqtzm5Dzuyp
         YoJJbXpLa5bJ7s7YFms6Fy/HbHcmaWUXQFBOIuZMk2dWOvalQdmC4B24+mMYktFpUdGj
         vkHYBab5W7b47GOCy0QlIt/Fsl/W+l3b4f9mjrPHd/sUvJdk5H3GCDRfmSlO1Nb+x7Is
         UNQMwUaHe8zjFm0Ix0xNU175N3AOVD1rXMn3i1pWURwa2ZjnQmZ9ZNoq2Q0JeqafU+Yz
         6mK9pQg+tTSpwOZWbHM1GRtvgJsb59rdWtNF+Z31RaiPorhlaQ1dScX7scP/ZiLecm3m
         uK9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=s4LS5XCNRp5oX+FKr8Qy3XQXn0REfCMITuWxGTNshFM=;
        b=tc6LDYhRul6FYWTxXYIhXxfb9w0p/bxJdTE12tCE0iCYQcTXg+mS14CgSsTH56v1gy
         w/Bl6gFc1tSLlQS1nqoFAsENg4VVfpOkxCxgfSjGspdyCdSv+qvXiH63vekG+eWAoqLw
         yX7TdL+CB20nO/e7tgjnTC23G8d7mIVTGz3qXaXiLSVwb/YyaDOXGGwgn0KmR+iKcSFW
         Zd7oj9G9tEpQZ3aK/gK4uQPsCzHRnytHHimwJJaIlxvuCqGlIFJ2Lwt41eIsHD7WYsYQ
         MgQW1aCdt5ti4a+cAxEHWTLsI58XsDUFHKTx6BD3IwvaldGB0Lpng/0Tj35UIWYICenc
         5QOQ==
X-Gm-Message-State: AOAM531AdEC0uLwjKc/8TN6LdX0SEqJefx8fSqYaPjrMss84dg/MatQ8
	dsInUrULugG6LJoFvAMk20kIvy48WMB8L52CfzA=
X-Google-Smtp-Source: ABdhPJz47y9VUyCvVkLPLEKlacdAyF9zCmy3+Yu8mKEcNJlI6KFePZTyY6w6vjgYE1Jpb97+tcSwWBcdfcqiazpgLXg=
X-Received: by 2002:a05:6808:9b5:: with SMTP id e21mr14986363oig.68.1614102563671;
 Tue, 23 Feb 2021 09:49:23 -0800 (PST)
MIME-Version: 1.0
References: <20210222151231.22572-1-romain.perier@gmail.com>
 <20210222151231.22572-2-romain.perier@gmail.com> <YDUpqn+cRWg1ZYYT@blackbook>
In-Reply-To: <YDUpqn+cRWg1ZYYT@blackbook>
From: Romain Perier <romain.perier@gmail.com>
Date: Tue, 23 Feb 2021 18:49:12 +0100
Message-ID: <CABgxDo+W3--A9Gy5jUjbYuPSJMcTz5Wn8A8GWd3v+V9zO9gLYw@mail.gmail.com>
Subject: Re: [PATCH 01/20] cgroup: Manual replacement of the deprecated
 strlcpy() with return values
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: Kees Cook <keescook@chromium.org>, 
	Kernel Hardening <kernel-hardening@lists.openwall.com>, Tejun Heo <tj@kernel.org>, 
	Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, cgroups@vger.kernel.org, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: multipart/alternative; boundary="000000000000f0515e05bc048913"

--000000000000f0515e05bc048913
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Le mar. 23 f=C3=A9vr. 2021 =C3=A0 17:13, Michal Koutn=C3=BD <mkoutny@suse.c=
om> a =C3=A9crit :

> Hello.
>
> On Mon, Feb 22, 2021 at 04:12:12PM +0100, Romain Perier <
> romain.perier@gmail.com> wrote:
> > --- a/kernel/cgroup/cgroup.c
> > +++ b/kernel/cgroup/cgroup.c
> > @@ -2265,7 +2265,7 @@ int task_cgroup_path(struct task_struct *task,
> char *buf, size_t buflen)
> Actually, this function isn't used at all. So I'd instead propose the
> patch below.
>


+1 if it is dead code.

Thanks,
Romain

--000000000000f0515e05bc048913
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr">Le=C2=A0mar. 23 f=C3=A9vr. 2021 =C3=A0=C2=
=A017:13, Michal Koutn=C3=BD &lt;<a href=3D"mailto:mkoutny@suse.com">mkoutn=
y@suse.com</a>&gt; a =C3=A9crit=C2=A0:<br></div><div class=3D"gmail_quote">=
<blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-=
left:1px solid rgb(204,204,204);padding-left:1ex">Hello.<br>
<br>
On Mon, Feb 22, 2021 at 04:12:12PM +0100, Romain Perier &lt;<a href=3D"mail=
to:romain.perier@gmail.com" target=3D"_blank">romain.perier@gmail.com</a>&g=
t; wrote:<br>
&gt; --- a/kernel/cgroup/cgroup.c<br>
&gt; +++ b/kernel/cgroup/cgroup.c<br>
&gt; @@ -2265,7 +2265,7 @@ int task_cgroup_path(struct task_struct *task, c=
har *buf, size_t buflen)<br>
Actually, this function isn&#39;t used at all. So I&#39;d instead propose t=
he<br>
patch below.<br></blockquote><div><br></div><div><br></div><div>+1 if it is=
 dead code.</div><div><br></div><div>Thanks,<br></div><div>Romain<br></div>=
<div>=C2=A0</div></div></div>

--000000000000f0515e05bc048913--
