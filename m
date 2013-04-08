Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <1365106055-22939-1-git-send-email-keescook@chromium.org>
References: <1365106055-22939-1-git-send-email-keescook@chromium.org>
Date: Mon, 8 Apr 2013 08:34:42 +0300
Message-ID: <CAH6MLeMwHahSubCGc3DWdk7TRREzKWd=ecs_zhE38Wz6WvfEiw@mail.gmail.com>
From: Hasinoliva MIARIMANJATO <hasinoliva@gmail.com>
Content-Type: multipart/alternative; boundary=089e013c63c230712404d9d2cb35
Subject: Re: [kernel-hardening] [PATCH 0/3] kernel ASLR
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

--089e013c63c230712404d9d2cb35
Content-Type: text/plain; charset=ISO-8859-1

Hi i want to get so more information about pohmelfs ; i want to get
pohmelfs server and pohmelfs client that i don't find it in the internet ,
please help me

thank you.


2013/4/4 Kees Cook <keescook@chromium.org>

> Hello,
>
> This patch series implements per-boot kernel base offset ASLR. It is based
> on work by Dan Rosenberg, Neill Clift, Michael Davidson, and myself. Since
> Dan's original thread[1], this code has been improved to work on 64-bit,
> among other things.
>
> This is presently in use at Google, and is being ported to Chrome
> OS. It has several limitations currently, but I wanted to get the ball
> rolling again on upstreaming this. More details are in the individual
> patches. They are split into three pieces: the offset selection logic,
> the 64-bit relocation logic, and finally putting the offset to use at
> boot time.
>
> Thanks,
>
> -Kees
>
> [1] http://lkml.indiana.edu/hypermail/linux/kernel/1105.3/index.html#00520
>
>

--089e013c63c230712404d9d2cb35
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div>Hi i want to get so more information about pohmelfs ;=
 i want to get
 pohmelfs server and pohmelfs client that i don&#39;t find it in the=20
internet , please help me <br>
<br>
</div>thank you.</div><div class=3D"gmail_extra"><br><br><div class=3D"gmai=
l_quote">2013/4/4 Kees Cook <span dir=3D"ltr">&lt;<a href=3D"mailto:keescoo=
k@chromium.org" target=3D"_blank">keescook@chromium.org</a>&gt;</span><br><=
blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px=
 #ccc solid;padding-left:1ex">
Hello,<br>
<br>
This patch series implements per-boot kernel base offset ASLR. It is based<=
br>
on work by Dan Rosenberg, Neill Clift, Michael Davidson, and myself. Since<=
br>
Dan&#39;s original thread[1], this code has been improved to work on 64-bit=
,<br>
among other things.<br>
<br>
This is presently in use at Google, and is being ported to Chrome<br>
OS. It has several limitations currently, but I wanted to get the ball<br>
rolling again on upstreaming this. More details are in the individual<br>
patches. They are split into three pieces: the offset selection logic,<br>
the 64-bit relocation logic, and finally putting the offset to use at<br>
boot time.<br>
<br>
Thanks,<br>
<br>
-Kees<br>
<br>
[1] <a href=3D"http://lkml.indiana.edu/hypermail/linux/kernel/1105.3/index.=
html#00520" target=3D"_blank">http://lkml.indiana.edu/hypermail/linux/kerne=
l/1105.3/index.html#00520</a><br>
<br>
</blockquote></div><br></div>

--089e013c63c230712404d9d2cb35--
