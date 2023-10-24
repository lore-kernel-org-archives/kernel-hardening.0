Return-Path: <kernel-hardening-return-21705-kernel-hardening=archiver.kernel.org@lists.openwall.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from second.openwall.net (second.openwall.net [193.110.157.125])
	by smtp.lore.kernel.org (Postfix) with SMTP id AB719C00A8F
	for <kernel-hardening@archiver.kernel.org>; Tue, 24 Oct 2023 14:05:56 +0000 (UTC)
Received: (qmail 3857 invoked by uid 550); 24 Oct 2023 14:05:45 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 3818 invoked from network); 24 Oct 2023 14:05:44 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sempervictus-com.20230601.gappssmtp.com; s=20230601; t=1698156332; x=1698761132; darn=lists.openwall.com;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=a9dw5fzq1NNegziPMixGu0n16dUJLX1y4/9aRnIYdsM=;
        b=DtReQl+9JjBRuUuIcio6Cn+uhN055Zfa13AMXhGSzBhjMoTovl4F8J3LW0/y4mS3vb
         RKMwn3cvyCa2rH1DrHJtgHQTUTkMXkjI7cJq5IMJCufH57zNsGPdLkAR8szFmjhAYROS
         zDSAwAdcs871ttiEKl1Dk4GB6z2A70qSA1y3k+Ow38ALsVlGw8Yoawb5Av5O8tqaN9vf
         XF/kOhu2nCBnsfXsBK0H3jrDNgMEek7lY2Y7HTUo0W563LWOXfhceHzuqRYgU7BnM/aM
         Mf1jV4JcEmcIwvj1Anta9UURn0obZcyRXOILzyFL9WLtzAfLU9+pjvRDi0FSVWwE7Abs
         ar/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698156332; x=1698761132;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a9dw5fzq1NNegziPMixGu0n16dUJLX1y4/9aRnIYdsM=;
        b=FXBnaX+UqhFVLfsTwrWWo2Of/7vMu5lXqA23sF7kr8rWR3/e3y4/pIF9pjIFpBnKgS
         l+JG0Wp/AoQjGjPIPsURDq4TWJh3Vde3Om66PtphlaJnZPqPZGrVdCX2Bh7ZHPzqF39c
         fwTTkYUMEO7Sd+UmIHOHibQreemkPYSBGxeSyUoZf2Ly0ven/hNr+rglJJmLsrT7o/FM
         wXfYqlZtT8N/NiVfzP0sCTxgyaXXIHShfpQgTpeFG4EfHI5lsybSF1W4wlibAmYrEgCY
         ir0cOCRmSaZOGsgHqiNNxSSoATFxz5teEShDtJYFuT1s4r4ZGs9pfAlFaBwJQWqrUL0y
         bApg==
X-Gm-Message-State: AOJu0Yz/pPOEbtl2nwrWe9cRkgdCR68r7Zm/2qocAG2ODOeqIliEDGnI
	scyFEU5LDBJ/MXkoeOca7Mb1B6PpjWRHhE9DK8KZRA==
X-Google-Smtp-Source: AGHT+IG9xpFqHaP6ccEIeFOnud4esJDPbMjR+FRNX+otbtIZhqJiS3/NWqmKfcP8BLe0PdtvjOdyUQ==
X-Received: by 2002:a05:620a:471e:b0:76c:da86:3169 with SMTP id bs30-20020a05620a471e00b0076cda863169mr14460236qkb.40.1698156331774;
        Tue, 24 Oct 2023 07:05:31 -0700 (PDT)
Date: Tue, 24 Oct 2023 10:05:29 -0400
From: Boris Lukashev <blukashev@sempervictus.com>
To: kernel-hardening@lists.openwall.com, "Serge E. Hallyn" <serge@hallyn.com>,
 Stefan Bavendiek <stefan.bavendiek@mailbox.org>
CC: linux-hardening@vger.kernel.org
Subject: Re: Isolating abstract sockets
User-Agent: K-9 Mail for Android
In-Reply-To: <20231024134608.GC320399@mail.hallyn.com>
References: <Y59qBh9rRDgsIHaj@mailbox.org> <20231024134608.GC320399@mail.hallyn.com>
Message-ID: <BE62D2CD-63CD-435A-A290-4608CF1A46D4@sempervictus.com>
MIME-Version: 1.0
Content-Type: multipart/alternative;
 boundary=----BW8PHN90GN6YAT9YRD5JZXNJQUUF87
Content-Transfer-Encoding: 7bit

------BW8PHN90GN6YAT9YRD5JZXNJQUUF87
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

Namespacing at OSI4 seems a bit fraught as the underlying route, mac, and p=
hysdev fall outside the callers control=2E Multiple NS' sharing an IP stack=
 would exhaust ephemeral ranges faster (likely asymmetrically too) and have=
 bound socket collisions opaque to each other requiring handling outside th=
e NS/containers purview=2E We looked at this sort of thing during the r&d p=
hase of our assured comms work (namespaces were young) and found a bunch of=
 overhead and collision concerns=2E Not saying it can't be done, but gettin=
g consumers to play nice enough with such an approach may be a heavy lift=
=2E

Thanks,
-Boris


On October 24, 2023 9:46:08 AM EDT, "Serge E=2E Hallyn" <serge@hallyn=2Eco=
m> wrote:
>On Sun, Dec 18, 2022 at 08:29:10PM +0100, Stefan Bavendiek wrote:
>> When building userspace application sandboxes, one issue that does not =
seem trivial to solve is the isolation of abstract sockets=2E
>
>Veeery late reply=2E  Have you had any productive discussions about this =
in
>other threads or venues?
>
>> While most IPC mechanism can be isolated by mechanisms like mount names=
paces, abstract sockets are part of the network namespace=2E
>> It is possible to isolate abstract sockets by using a new network names=
pace, however, unprivileged processes can only create a new empty network n=
amespace, which removes network access as well and makes this useless for n=
etwork clients=2E
>>=20
>> Same linux sandbox projects try to solve this by bridging the existing =
network interfaces into the new namespace or use something like slirp4netns=
 to archive this, but this does not look like an ideal solution to this pro=
blem, especially since sandboxing should reduce the kernel attack surface w=
ithout introducing more complexity=2E
>>=20
>> Aside from containers using namespaces, sandbox implementations based o=
n seccomp and landlock would also run into the same problem, since landlock=
 only provides file system isolation and seccomp cannot filter the path arg=
ument and therefore it can only be used to block new unix domain socket con=
nections completely=2E
>>=20
>> Currently there does not seem to be any way to disable network namespac=
es in the kernel without also disabling unix domain sockets=2E
>>=20
>> The question is how to solve the issue of abstract socket isolation in =
a clean and efficient way, possibly even without namespaces=2E
>> What would be the ideal way to implement a mechanism to disable abstrac=
t sockets either globally or even better, in the context of a process=2E
>> And would such a patch have a realistic chance to make it into the kern=
el?
>
>Disabling them altogether would break lots of things depending on them,
>like X :)  (@/tmp/=2EX11-unix/X0)=2E  The other path is to reconsider net=
work
>namespaces=2E  There are several directions this could lead=2E  For one, =
as
>Dinesh Subhraveti often points out, the current "network" namespace is
>really a network device namespace=2E  If we instead namespace at the
>bind/connect/etc calls, we end up with much different abilities=2E  You
>can implement something like this today using seccomp-filter=2E
>
>-serge

------BW8PHN90GN6YAT9YRD5JZXNJQUUF87
Content-Type: text/html;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

<html><head></head><body><div dir=3D"auto">Namespacing at OSI4 seems a bit =
fraught as the underlying route, mac, and physdev fall outside the callers =
control=2E Multiple NS' sharing an IP stack would exhaust ephemeral ranges =
faster (likely asymmetrically too) and have bound socket collisions opaque =
to each other requiring handling outside the NS/containers purview=2E We lo=
oked at this sort of thing during the r&amp;d phase of our assured comms wo=
rk (namespaces were young) and found a bunch of overhead and collision conc=
erns=2E Not saying it can't be done, but getting consumers to play nice eno=
ugh with such an approach may be a heavy lift=2E<br><br>Thanks,<br>-Boris<b=
r></div><br><br><div class=3D"gmail_quote"><div dir=3D"auto">On October 24,=
 2023 9:46:08 AM EDT, "Serge E=2E Hallyn" &lt;serge@hallyn=2Ecom&gt; wrote:=
</div><blockquote class=3D"gmail_quote" style=3D"margin: 0pt 0pt 0pt 0=2E8e=
x; border-left: 1px solid rgb(204, 204, 204); padding-left: 1ex;">
<pre class=3D"k9mail"><div dir=3D"auto">On Sun, Dec 18, 2022 at 08:29:10PM=
 +0100, Stefan Bavendiek wrote:<br></div><blockquote class=3D"gmail_quote" =
style=3D"margin: 0pt 0pt 1ex 0=2E8ex; border-left: 1px solid #729fcf; paddi=
ng-left: 1ex;"><div dir=3D"auto">When building userspace application sandbo=
xes, one issue that does not seem trivial to solve is the isolation of abst=
ract sockets=2E<br></div></blockquote><div dir=3D"auto"><br>Veeery late rep=
ly=2E  Have you had any productive discussions about this in<br>other threa=
ds or venues?<br><br></div><blockquote class=3D"gmail_quote" style=3D"margi=
n: 0pt 0pt 1ex 0=2E8ex; border-left: 1px solid #729fcf; padding-left: 1ex;"=
><div dir=3D"auto">While most IPC mechanism can be isolated by mechanisms l=
ike mount namespaces, abstract sockets are part of the network namespace=2E=
<br>It is possible to isolate abstract sockets by using a new network names=
pace, however, unprivileged processes can only create a new empty network n=
amespace, which removes network access as well and makes this useless for n=
etwork clients=2E<br><br>Same linux sandbox projects try to solve this by b=
ridging the existing network interfaces into the new namespace or use somet=
hing like slirp4netns to archive this, but this does not look like an ideal=
 solution to this problem, especially since sandboxing should reduce the ke=
rnel attack surface without introducing more complexity=2E<br><br>Aside fro=
m containers using namespaces, sandbox implementations based on seccomp and=
 landlock would also run into the same problem, since landlock only provide=
s file system isolation and seccomp cannot filter the path argument and the=
refore it can only be used to block new unix domain socket connections comp=
letely=2E<br><br>Currently there does not seem to be any way to disable net=
work namespaces in the kernel without also disabling unix domain sockets=2E=
<br><br>The question is how to solve the issue of abstract socket isolation=
 in a clean and efficient way, possibly even without namespaces=2E<br>What =
would be the ideal way to implement a mechanism to disable abstract sockets=
 either globally or even better, in the context of a process=2E<br>And woul=
d such a patch have a realistic chance to make it into the kernel?<br></div=
></blockquote><div dir=3D"auto"><br>Disabling them altogether would break l=
ots of things depending on them,<br>like X :)  (@/tmp/=2EX11-unix/X0)=2E  T=
he other path is to reconsider network<br>namespaces=2E  There are several =
directions this could lead=2E  For one, as<br>Dinesh Subhraveti often point=
s out, the current "network" namespace is<br>really a network device namesp=
ace=2E  If we instead namespace at the<br>bind/connect/etc calls, we end up=
 with much different abilities=2E  You<br>can implement something like this=
 today using seccomp-filter=2E<br><br>-serge<br></div></pre></blockquote></=
div></body></html>
------BW8PHN90GN6YAT9YRD5JZXNJQUUF87--
