Return-Path: <kernel-hardening-return-21674-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id A7BE2EE49A3
	for <kernel-hardening@archiver.kernel.org>; Tue, 22 Aug 2023 12:51:30 +0000 (UTC)
Received: (qmail 13468 invoked by uid 550); 22 Aug 2023 12:51:19 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 13424 invoked from network); 22 Aug 2023 12:51:18 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sempervictus-com.20221208.gappssmtp.com; s=20221208; t=1692708666; x=1693313466;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GDOe2zxW+b1AXKTieznvWUdQPHV5rGAt9v6T0ETuJ4c=;
        b=2Uxmt1Tb5oHbnUc+w05nziqLxPTx5+oLHGupP+qWeURuNELImgapeeadimpGOjadxF
         FN5kbAkhb6v3WZoSGzpZ2xThOX5WrX1iIe7yFydlLBJEOmQtZwyn1Bsfb5SkqZ1Qe3wI
         urBZIj/0k44SUhMQTNFNJPoLDAMb+5mD4YjOkZ95gge/NLzbwDhohLRrP62VEcZ3cPI0
         EfGNERFWSZiXuGWrTvkULCnDmnn874aYwSzoBwvrCi4k0pu4ZTOrN3nyVXRT0eajenLx
         z62y312h8/EdCIwmDx3LtHj7Ex+Pd7GqXXML19UA1nZjWgUS8qBcp9EzHJmkP+9SAWSN
         gDTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692708666; x=1693313466;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:to:from:date:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=GDOe2zxW+b1AXKTieznvWUdQPHV5rGAt9v6T0ETuJ4c=;
        b=JrnS/a9jJ/DdhuwM9rs42i91zf2IabwdTfvZvxpzEVi+jO5gfS2T/6bNnD5EKWTzvE
         +Z+zjdwSEzErgsMAuhBEoa9GpJPJJEHQZGr81jMQJwQtruUguOjZ8A2GW5XblVhvBx/g
         5xwnY435rqN28LQJz607YCsmPT6lxZBtfEdlxFQ68MEMq7Jiytsd98GFGj97yzFWOCRT
         5ngzNHXZBjwLbHKAP1SkN53Fp3LtaHH+VfJ+A+hSv6mrm2xkRRqmO8V3iczCtlfDfxUs
         d5bGTUmQOwq9wj7Y2/mynw6XhutXMefokCYPDJPPbHAWsRFGkMDBzwU1iEODHNkmvXF+
         z5Hg==
X-Gm-Message-State: AOJu0YwPXzsLRSsMeLDY4z0UbP/+ohi1DqupIV2ZB2rKcKZ/UmFg7kDg
	3OypwZr/B5bm9MUCQ6IbSuJgCzCtv6eFhPHAvgw=
X-Google-Smtp-Source: AGHT+IHei7uoJNBUPhSYMYLihla1U7L7v3yrfhaK6piSbaHEQum4/qRuDtULeftaFlmAmtkz0OBhZQ==
X-Received: by 2002:a0c:e04e:0:b0:64c:2f8c:2a2d with SMTP id y14-20020a0ce04e000000b0064c2f8c2a2dmr10237190qvk.1.1692708666419;
        Tue, 22 Aug 2023 05:51:06 -0700 (PDT)
Date: Tue, 22 Aug 2023 08:51:03 -0400
From: Boris Lukashev <blukashev@sempervictus.com>
To: kernel-hardening@lists.openwall.com
Subject: Re: [PATCH] Restrict access to TIOCLINUX
User-Agent: K-9 Mail for Android
In-Reply-To: <2023082203-slackness-sworn-2c80@gregkh>
References: <20230402160815.74760f87.hanno@hboeck.de> <2023040232-untainted-duration-daf6@gregkh> <20230402191652.747b6acc.hanno@hboeck.de> <2023040207-pretender-legislate-2e8b@gregkh> <ZN+X6o3cDWcLoviq@google.com> <2023082203-slackness-sworn-2c80@gregkh>
Message-ID: <9B3A6B9B-B8F7-437A-B80B-6FB9746A6F6B@sempervictus.com>
MIME-Version: 1.0
Content-Type: multipart/alternative;
 boundary=----5PNCZFFEPQMIRD5N2KT026YEPJY308
Content-Transfer-Encoding: 7bit

------5PNCZFFEPQMIRD5N2KT026YEPJY308
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

See this asked a lot, and as someone who works mostly in languages with rob=
ust test facilities, I gotta ask: why isn't kernel code mandated to be subm=
itted with tests?

The maple tree thing was kind of a mess and was a much bigger change than =
the stuff people push in these security machinations=2E With the pushback u=
pstream gives on this stuff its no wonder that actual progress on kernsec i=
s made by an out of tree third party=2E Upstream does not make it easy to i=
mprove boundaries and controls or establish coherent awareness=2E

Introducing tests and a public, expandable, well-defined threat model agai=
nst which defensive measures are built would permit smaller/piecemeal effor=
ts to cobble together a stronger overall posture (and automate regression t=
esting for new features which are not necessarily seen as being in the secu=
rity domain)=2E

-Boris

On August 22, 2023 8:07:24 AM EDT, Greg KH <gregkh@linuxfoundation=2Eorg> =
wrote:
>On Fri, Aug 18, 2023 at 06:10:18PM +0200, G=C3=BCnther Noack wrote:
>> Hello!
>>=20
>> +CC the people involved in TIOCSTI
>>=20
>> This patch seems sensible to me --
>> and I would like to kindly ask you to reconsider it=2E
>>=20
>> On Sun, Apr 02, 2023 at 07:23:44PM +0200, Greg KH wrote:
>> > On Sun, Apr 02, 2023 at 07:16:52PM +0200, Hanno B=C3=B6ck wrote:
>> > > On Sun, 2 Apr 2023 16:55:01 +0200
>> > > Greg KH <gregkh@linuxfoundation=2Eorg> wrote:
>> > >=20
>> > > > You just now broke any normal user programs that required this (o=
r the
>> > > > other ioctls), and so you are going to have to force them to be r=
un
>> > > > with CAP_SYS_ADMIN permissions?=20
>> > >=20
>> > > Are you aware of such normal user programs?
>> > > It was my impression that this is a relatively obscure feature and =
gpm
>> > > is pretty much the only tool using it=2E
>> >=20
>> > "Pretty much" does not mean "none" :(
>>=20
>> This patch only affects TIOCLINUX subcodes which are responsible for te=
xt
>> cut-and-paste, TIOCL_SETSEL, TIOCL_PASTESEL and TIOCL_SELLOADLUT=2E
>>=20
>> The only program that I am aware of which uses cut&paste on the console=
 is gpm=2E
>> My web searches for these subcode names have only surfaced Linux header=
 files
>> and discussions about their security problems=2E
>
>Is gpm running with the needed permissions already?
>
>> > > > And you didn't change anything for programs like gpm that already=
 had
>> > > > root permission (and shouldn't that permission be dropped anyway?=
)
>> > >=20
>> > > Well, you could restrict all that to a specific capability=2E Howev=
er, it
>> > > is my understanding that the existing capability system is limited =
in
>> > > the number of capabilities and new ones should only be introduced i=
n
>> > > rare cases=2E It does not seem a feature probably few people use an=
yway
>> > > deserves a new capability=2E
>> >=20
>> > I did not suggest that a new capability be created for this, that wou=
ld
>> > be an abust of the capability levels for sure=2E
>> >=20
>> > > Do you have other proposals how to fix this issue? One could introd=
uce
>> > > an option like for TIOCSTI that allows disabling selection features=
 by
>> > > default=2E
>> >=20
>> > What exact issue are you trying to fix here?
>>=20
>> It's the same problem as with TIOCSTI, which got (optionally) disabled =
for
>> non-CAP_SYS_ADMIN in commit 83efeeeb3d04 ("tty: Allow TIOCSTI to be dis=
abled")
>> and commit 690c8b804ad2 ("TIOCSTI: always enable for CAP_SYS_ADMIN")=2E
>>=20
>> The number of exploits which have used TIOCSTI in the past is long[1] a=
nd has
>> affected multiple sandboxing and sudo-like tools=2E  If the user is usi=
ng the
>> console, TIOCLINUX's cut&paste functionality can replace TIOCSTI in the=
se
>> exploits=2E
>>=20
>> We have this problem with the Landlock LSM as well, with both TIOCSTI a=
nd these
>> TIOCLINUX subcodes=2E
>>=20
>> Here is an example scenario:
>>=20
>> * User runs a vulnerable version of the "ping" command from the console=
=2E
>
>Don't do that :)
>
>> * The "ping" command is a hardened version which puts itself into a Lan=
dlock
>>   sandbox, but it still has the TTY FD through stdout=2E
>>=20
>> * Ping gets buffer-overflow-exploited by an attacker through ping respo=
nses=2E
>
>You allowed a root-permissioned program to accept unsolicted network
>code, why is it the kernel's issue here?
>
>> * The attacker can't directly access the file system, but the attacker =
can
>>   escape the sandbox by controlling the surrounding (non-sandboxed) she=
ll on its
>>   terminal through TIOCLINUX=2E
>>=20
>> The ping example is not completely made up -- FreeBSD had such a vulner=
ability
>> in its ping utility in 2022[2]=2E  The impact of the vulnerability was =
mitigated
>> by FreeBSD's Capsicum sandboxing=2E
>>=20
>> The correct solution for the problem on Linux is to my knowledge to cre=
ate a
>> pty/tty pair, but that is somewhat impractical for small utilities like=
 ping, in
>> order to restrict themselves (they would need to create a sidecar proce=
ss to
>> shovel the data back and forth)=2E  Workarounds include setsid() and se=
ccomp-bpf,
>> but they also have their limits and are not a clean solution=2E  We've =
previously
>> discussed it in [3]=2E
>>=20
>> I do believe that requiring CAP_SYS_ADMIN for TIOCLINUX's TIOCL_PASTESE=
L subcode
>> would be a better approach than so many sudo-style and sandboxing tools=
 having
>> to learn this lesson the hard way=2E  Can we please reconsider this pat=
ch?
>
>Have you verified that nothing will break with this?
>
>If so, it needs to be submitted in a form that could be accepted (this
>one was not, so I couldn't take it even if I wanted to), and please add
>a tested-by from you and we will be glad to reconsider it=2E
>
>thanks,
>
>greg k-h

------5PNCZFFEPQMIRD5N2KT026YEPJY308
Content-Type: text/html;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

<html><head></head><body><div dir=3D"auto">See this asked a lot, and as som=
eone who works mostly in languages with robust test facilities, I gotta ask=
: why isn't kernel code mandated to be submitted with tests?<br><br>The map=
le tree thing was kind of a mess and was a much bigger change than the stuf=
f people push in these security machinations=2E With the pushback upstream =
gives on this stuff its no wonder that actual progress on kernsec is made b=
y an out of tree third party=2E Upstream does not make it easy to improve b=
oundaries and controls or establish coherent awareness=2E<br><br>Introducin=
g tests and a public, expandable, well-defined threat model against which d=
efensive measures are built would permit smaller/piecemeal efforts to cobbl=
e together a stronger overall posture (and automate regression testing for =
new features which are not necessarily seen as being in the security domain=
)=2E<br><br>-Boris</div><br><br><div class=3D"gmail_quote"><div dir=3D"auto=
">On August 22, 2023 8:07:24 AM EDT, Greg KH &lt;gregkh@linuxfoundation=2Eo=
rg&gt; wrote:</div><blockquote class=3D"gmail_quote" style=3D"margin: 0pt 0=
pt 0pt 0=2E8ex; border-left: 1px solid rgb(204, 204, 204); padding-left: 1e=
x;">
<pre class=3D"k9mail"><div dir=3D"auto">On Fri, Aug 18, 2023 at 06:10:18PM=
 +0200, G=C3=BCnther Noack wrote:<br></div><blockquote class=3D"gmail_quote=
" style=3D"margin: 0pt 0pt 1ex 0=2E8ex; border-left: 1px solid #729fcf; pad=
ding-left: 1ex;"><div dir=3D"auto">Hello!<br><br>+CC the people involved in=
 TIOCSTI<br><br>This patch seems sensible to me --<br>and I would like to k=
indly ask you to reconsider it=2E<br><br>On Sun, Apr 02, 2023 at 07:23:44PM=
 +0200, Greg KH wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"=
margin: 0pt 0pt 1ex 0=2E8ex; border-left: 1px solid #ad7fa8; padding-left: =
1ex;"><div dir=3D"auto">On Sun, Apr 02, 2023 at 07:16:52PM +0200, Hanno B=
=C3=B6ck wrote:<br></div><blockquote class=3D"gmail_quote" style=3D"margin:=
 0pt 0pt 1ex 0=2E8ex; border-left: 1px solid #8ae234; padding-left: 1ex;"><=
div dir=3D"auto">On Sun, 2 Apr 2023 16:55:01 +0200<br>Greg KH &lt;gregkh@li=
nuxfoundation=2Eorg&gt; wrote:<br><br></div><blockquote class=3D"gmail_quot=
e" style=3D"margin: 0pt 0pt 1ex 0=2E8ex; border-left: 1px solid #fcaf3e; pa=
dding-left: 1ex;"><div dir=3D"auto">You just now broke any normal user prog=
rams that required this (or the<br>other ioctls), and so you are going to h=
ave to force them to be run<br>with CAP_SYS_ADMIN permissions? <br></div></=
blockquote><div dir=3D"auto"><br>Are you aware of such normal user programs=
?<br>It was my impression that this is a relatively obscure feature and gpm=
<br>is pretty much the only tool using it=2E<br></div></blockquote><div dir=
=3D"auto"><br>"Pretty much" does not mean "none" :(<br></div></blockquote><=
div dir=3D"auto"><br>This patch only affects TIOCLINUX subcodes which are r=
esponsible for text<br>cut-and-paste, TIOCL_SETSEL, TIOCL_PASTESEL and TIOC=
L_SELLOADLUT=2E<br><br>The only program that I am aware of which uses cut&a=
mp;paste on the console is gpm=2E<br>My web searches for these subcode name=
s have only surfaced Linux header files<br>and discussions about their secu=
rity problems=2E<br></div></blockquote><div dir=3D"auto"><br>Is gpm running=
 with the needed permissions already?<br><br></div><blockquote class=3D"gma=
il_quote" style=3D"margin: 0pt 0pt 1ex 0=2E8ex; border-left: 1px solid #729=
fcf; padding-left: 1ex;"><blockquote class=3D"gmail_quote" style=3D"margin:=
 0pt 0pt 1ex 0=2E8ex; border-left: 1px solid #ad7fa8; padding-left: 1ex;"><=
blockquote class=3D"gmail_quote" style=3D"margin: 0pt 0pt 1ex 0=2E8ex; bord=
er-left: 1px solid #8ae234; padding-left: 1ex;"><blockquote class=3D"gmail_=
quote" style=3D"margin: 0pt 0pt 1ex 0=2E8ex; border-left: 1px solid #fcaf3e=
; padding-left: 1ex;"><div dir=3D"auto">And you didn't change anything for =
programs like gpm that already had<br>root permission (and shouldn't that p=
ermission be dropped anyway?)<br></div></blockquote><div dir=3D"auto"><br>W=
ell, you could restrict all that to a specific capability=2E However, it<br=
>is my understanding that the existing capability system is limited in<br>t=
he number of capabilities and new ones should only be introduced in<br>rare=
 cases=2E It does not seem a feature probably few people use anyway<br>dese=
rves a new capability=2E<br></div></blockquote><div dir=3D"auto"><br>I did =
not suggest that a new capability be created for this, that would<br>be an =
abust of the capability levels for sure=2E<br><br></div><blockquote class=
=3D"gmail_quote" style=3D"margin: 0pt 0pt 1ex 0=2E8ex; border-left: 1px sol=
id #8ae234; padding-left: 1ex;"><div dir=3D"auto">Do you have other proposa=
ls how to fix this issue? One could introduce<br>an option like for TIOCSTI=
 that allows disabling selection features by<br>default=2E<br></div></block=
quote><div dir=3D"auto"><br>What exact issue are you trying to fix here?<br=
></div></blockquote><div dir=3D"auto"><br>It's the same problem as with TIO=
CSTI, which got (optionally) disabled for<br>non-CAP_SYS_ADMIN in commit 83=
efeeeb3d04 ("tty: Allow TIOCSTI to be disabled")<br>and commit 690c8b804ad2=
 ("TIOCSTI: always enable for CAP_SYS_ADMIN")=2E<br><br>The number of explo=
its which have used TIOCSTI in the past is long[1] and has<br>affected mult=
iple sandboxing and sudo-like tools=2E  If the user is using the<br>console=
, TIOCLINUX's cut&amp;paste functionality can replace TIOCSTI in these<br>e=
xploits=2E<br><br>We have this problem with the Landlock LSM as well, with =
both TIOCSTI and these<br>TIOCLINUX subcodes=2E<br><br>Here is an example s=
cenario:<br><br>* User runs a vulnerable version of the "ping" command from=
 the console=2E<br></div></blockquote><div dir=3D"auto"><br>Don't do that :=
)<br><br></div><blockquote class=3D"gmail_quote" style=3D"margin: 0pt 0pt 1=
ex 0=2E8ex; border-left: 1px solid #729fcf; padding-left: 1ex;"><div dir=3D=
"auto">* The "ping" command is a hardened version which puts itself into a =
Landlock<br>  sandbox, but it still has the TTY FD through stdout=2E<br><br=
>* Ping gets buffer-overflow-exploited by an attacker through ping response=
s=2E<br></div></blockquote><div dir=3D"auto"><br>You allowed a root-permiss=
ioned program to accept unsolicted network<br>code, why is it the kernel's =
issue here?<br><br></div><blockquote class=3D"gmail_quote" style=3D"margin:=
 0pt 0pt 1ex 0=2E8ex; border-left: 1px solid #729fcf; padding-left: 1ex;"><=
div dir=3D"auto">* The attacker can't directly access the file system, but =
the attacker can<br>  escape the sandbox by controlling the surrounding (no=
n-sandboxed) shell on its<br>  terminal through TIOCLINUX=2E<br><br>The pin=
g example is not completely made up -- FreeBSD had such a vulnerability<br>=
in its ping utility in 2022[2]=2E  The impact of the vulnerability was miti=
gated<br>by FreeBSD's Capsicum sandboxing=2E<br><br>The correct solution fo=
r the problem on Linux is to my knowledge to create a<br>pty/tty pair, but =
that is somewhat impractical for small utilities like ping, in<br>order to =
restrict themselves (they would need to create a sidecar process to<br>shov=
el the data back and forth)=2E  Workarounds include setsid() and seccomp-bp=
f,<br>but they also have their limits and are not a clean solution=2E  We'v=
e previously<br>discussed it in [3]=2E<br><br>I do believe that requiring C=
AP_SYS_ADMIN for TIOCLINUX's TIOCL_PASTESEL subcode<br>would be a better ap=
proach than so many sudo-style and sandboxing tools having<br>to learn this=
 lesson the hard way=2E  Can we please reconsider this patch?<br></div></bl=
ockquote><div dir=3D"auto"><br>Have you verified that nothing will break wi=
th this?<br><br>If so, it needs to be submitted in a form that could be acc=
epted (this<br>one was not, so I couldn't take it even if I wanted to), and=
 please add<br>a tested-by from you and we will be glad to reconsider it=2E=
<br><br>thanks,<br><br>greg k-h<br></div></pre></blockquote></div></body></=
html>
------5PNCZFFEPQMIRD5N2KT026YEPJY308--
