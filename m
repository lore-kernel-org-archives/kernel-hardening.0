Return-Path: <SRS0=W1VM=6Y=lists.openwall.com=kernel-hardening-return-18744-kernel-hardening=archiver.kernel.org@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HTML_MESSAGE,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 75607C54E49
	for <kernel-hardening@archiver.kernel.org>; Sun, 10 May 2020 11:10:31 +0000 (UTC)
Received: from mother.openwall.net (mother.openwall.net [195.42.179.200])
	by mail.kernel.org (Postfix) with SMTP id 7485620737
	for <kernel-hardening@archiver.kernel.org>; Sun, 10 May 2020 11:10:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pAtgrC29"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7485620737
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=pass smtp.mailfrom=kernel-hardening-return-18744-kernel-hardening=archiver.kernel.org@lists.openwall.com
Received: (qmail 17409 invoked by uid 550); 10 May 2020 11:10:21 -0000
Mailing-List: contact kernel-hardening-help@lists.openwall.com; run by ezmlm
Precedence: bulk
List-Post: <mailto:kernel-hardening@lists.openwall.com>
List-Help: <mailto:kernel-hardening-help@lists.openwall.com>
List-Unsubscribe: <mailto:kernel-hardening-unsubscribe@lists.openwall.com>
List-Subscribe: <mailto:kernel-hardening-subscribe@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>
Received: (qmail 21561 invoked from network); 10 May 2020 02:16:49 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=TtTB5TO3fTW6HQB1mIqgLNDGofoYahTz9Ca6Q7MMAis=;
        b=pAtgrC290GXhBPMZ58rEzWSARfYR323SlcjCDpwiLbJHkdzF8FxD2BFLZr/MvTTnap
         7vcP0jDP/C9VSzhojKIGW+SIuQiZ6jafl6bBXkhAxishOnu9k4RHWLpysPbqrAzoDGnj
         hGS/v/5idftFUEj33jVxVaW+g/DAt3O5vB6jGoRQ7DYvPXsV+j+1EtIRxqfMBIGukLbT
         9v5Y2GNSfwGaRA/O+Al/h1e3juxmK0WCdOl9Cr+UHg0pYXuBpzEVE1FmFmmVJfTQ4EPJ
         b8VJbeKhNbMXtXByKiOHsuQqAXEKvTeMkPSIVptCSz8+oCqEZEJETO7oItQLg3a1TsDG
         wcXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=TtTB5TO3fTW6HQB1mIqgLNDGofoYahTz9Ca6Q7MMAis=;
        b=XhSkksRHwNpHWiKUbnv1YVlC1lvX8gV4ZYNjlpJAZkDMbBH9NhfueBO6dFqEZ3C/0A
         eLrnB81YCdN7PsE7X+DiJMJlyinQhPggBTLU9mLUHY4ZKcXMlax249vuYeflZmc0/SXl
         zVfNXa/RHt1lu4m7H5AnAURpCVMRodSyJAObXVafp6LImZDiCRheR2cOZZgVBbpIxVQB
         13oLwckWk+pnDJSYgPtQy26tRmwugJQw0wqxjMOtGEFwCna+70nVmYPz1g4eSTtcDvNj
         +tcd9Yv3eYgXQEfTQoMbZLNmkkubR4b6LJtqeXVNkMlyd979dIk8r0cJyL46hrd10ely
         HSqQ==
X-Gm-Message-State: AOAM53234gw8IhspTfQOpfiVkphmxHVFawhsCzowyhULqbbEetC3iFkw
	CtVJWK0LTqCrPbhQOa4YFJx1zdBdcqxvWp/YVFGG3+gA
X-Google-Smtp-Source: ABdhPJwcG63rYO/6QJ3W546CzVGrm6bJZseIOGmDArSdrhD9Y99ZAHQWcd0i3PBeFpZY9stcBmHaurXkpJppGaX7vS8=
X-Received: by 2002:ac5:c5b8:: with SMTP id f24mr2944828vkl.50.1589076996839;
 Sat, 09 May 2020 19:16:36 -0700 (PDT)
MIME-Version: 1.0
From: wzt wzt <wzt.wzt@gmail.com>
Date: Sun, 10 May 2020 10:16:25 +0800
Message-ID: <CAEQi4beJgmNfZ0NsWSHCok9-5H_qLze_sFJ_G=1j8CBz9qi2rQ@mail.gmail.com>
Subject: Open source a new kernel harden project
To: kernel-hardening@lists.openwall.com
Content-Type: multipart/alternative; boundary="000000000000eadc2905a541d1ca"

--000000000000eadc2905a541d1ca
Content-Type: text/plain; charset="UTF-8"

hi:
    This is a new kernel harden project called hksp(huawei kernel self
protection),  hope some of the mitigation ideas may help you, thanks.
    patch: https://github.com/cloudsec/hksp

=============================
Huawei kernel self protection
=============================

Cred guard
----------
- random cred's magic.
  most kernel exploit try to find some offsets in struct cred,
  but it depends on CONFIG_DEBUG_CREDENTIALS, then need to compute
  the right offset by that kernel config, so mostly the exploit code
  is something like that:
  if (tmp0 == 0x43736564 || tmp0 == 0x44656144)
        i += 4;
- detect shellcode like:
  commit_creds(prepare_kernel_cred(0));
  the common kernel code is never write like that.

Namespace Guard
---------------
This feature detects pid namespace escape via kernel exploits.
The current public method to bypass namespace is hijack init_nsproxy
to current process:
  switch_task_namespaces_p(current, init_nsproxy_p);
  commit_creds(prepare_kernel_cred(0));

Rop stack pivot
--------------
- user process stack can't be is mmap area.
- check kernel stack range at each system call ret.
  the rsp pointer can point below __PAGE_OFFSET.

Slub harden
-----------
- redzone/poison randomization.
- double free enhance.
  old slub can only detect continuous double free bugs.
  kfree(obj1)
  kfree(obj1)

  hksp can detect no continuous double/multi free bugs.
  kfree(obj1)
  kfree(obj2)
  kfree(obj1)

  or

  kfree(obj1)
  kfree(obj2)
  kfree(obj3)
  kfree(obj1)
- clear the next object address information when using kmalloc function.

Proc info leak
--------------
Protect important file with no read access for non root user.
set /proc/{modules,keys,key-users},
/proc/sys/kernel/{panic,panic_on_oops,dmesg_restrict,kptr_restrict,keys},
/proc/sys/vm/{mmap_min_addr} as 0640.

Aslr hardended
--------------
User stack aslr enhanced.
Old user process's stack is between 0-1G on 64bit.
the actually random range is 0-2^24.
we introduce STACK_RND_BITS to control the range dynamically.

echo "24" > /proc/sys/vm/stack_rnd_bits

we also randomize the space between elf_info and environ.
And randomize the space between stack and elf_info.

Ptrace hardened
---------------
Disallow attach to non child process.
This can prevent process memory inject via ptrace.

Sm*p hardened
-------------
Check smap&smep when return from kernel space via a syscall,
this can detect some kernel exploit code to bypass smap & smep
feature via rop attack technology.

Raw socket enhance
------------------
Enhance raw socket for ipv4 protocol.
- TCP data cannot be sent over raw sockets.
  echo 1 > /proc/sys/net/ipv4/raw_tcp_disabled
- UDP datagrams with an invalid source address cannot be sent
  over raw sockets. The IP source address for any outgoing UDP
  datagram must exist on a network interface or the datagram is
  dropped. This change was made to limit the ability of malicious
  code to create distributed denial-of-service attacks and limits
  the ability to send spoofed packets (TCP/IP packets with a forged
  source IP address).
  echo 1 > /proc/sys/net/ipv4/raw_udp_verify
- A call to the bind function with a raw socket for the IPPROTO_TCP
  protocol is not allowed.
  echo 1 > /proc/sys/net/ipv4/raw_bind_disabled

Kernel self guard
-----------------
Ksguard is an anti rootkit tool on kernel level.
Currently it can detect 4 types of kernel rootkits,
These are the most popluar rootkits type on unix world.

- keyboard notifer rootkits.
- netfilter hooks rootkits.
- tty sniffer rootkits and other DKOM(direct kernel object modify) rootkits.
- system call table hijack rootkits.

Install:
/sbin/insmod /lib/modules/5.6.7/kernel/security/ksguard/ksguard.ko

Feature:
Detect keyboard notifer rootkits:
echo "1" > /proc/ksguard/state

Detect netfilter hooks rootkits:
echo "2" > /proc/ksguard/state

Detect tty sniffer rootkits:
echo "3" > /proc/ksguard/state

Detect syscall table pointer:
echo "4" > /proc/ksguard/state

Arbitrary code guard
--------------------
we extended the libc personality() to support:
- mmap can't memory with PROT_WRITE|PROT_EXEC.
- mprtect can't change PROT_WRITE to PROT_EXEC.

Code integrity guard
--------------------
To support certificate for user process execve.
it can prevent some internet explorer to load
third party so librarys.

Hide symbol
-----------
Hide symbols from /proc/kallsyms.

--000000000000eadc2905a541d1ca
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><div dir=3D"ltr"><div>hi:</div><div>=C2=
=A0 =C2=A0 This is a new kernel harden project called hksp(huawei kernel se=
lf protection),=C2=A0 hope some of the mitigation ideas may help you, thank=
s.</div><div>=C2=A0 =C2=A0 patch:=C2=A0<a href=3D"https://github.com/clouds=
ec/hksp">https://github.com/cloudsec/hksp</a></div><div><br></div><div><spa=
n style=3D"text-align:left;color:rgb(36,41,46);text-transform:none;text-ind=
ent:0px;letter-spacing:normal;font-family:SFMono-Regular,Consolas,Liberatio=
n Mono,Menlo,monospace;font-size:12px;font-style:normal;font-variant:normal=
;font-weight:400;text-decoration:none;word-spacing:0px;display:inline;white=
-space:pre-wrap;float:none;background-color:rgb(255,255,255)">=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
<br>Huawei kernel self protection<br>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D<br><br>Cred guard<br>--=
--------<br>- random cred&#39;s magic.<br>=C2=A0 most kernel exploit try to=
 find some offsets in struct cred,<br>=C2=A0 but it depends on CONFIG_DEBUG=
_CREDENTIALS, then need to compute<br>=C2=A0 the right offset by that kerne=
l config, so mostly the exploit code<br>=C2=A0 is something like that:<br>=
=C2=A0 if (tmp0 =3D=3D 0x43736564 || tmp0 =3D=3D 0x44656144)<br>=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 i +=3D 4;<br>- detect shellcode like:<br>=
=C2=A0 commit_creds(prepare_kernel_cred(0));<br>=C2=A0 the common kernel co=
de is never write like that.<br><br>Namespace Guard<br>---------------<br>T=
his feature detects pid namespace escape via kernel exploits.<br>The curren=
t public method to bypass namespace is hijack init_nsproxy<br>to current pr=
ocess:<br>=C2=A0 switch_task_namespaces_p(current, init_nsproxy_p);<br>=C2=
=A0 commit_creds(prepare_kernel_cred(0)); <br><br>Rop stack pivot<br>------=
--------<br>- user process stack can&#39;t be is mmap area.<br>- check kern=
el stack range at each system call ret.<br>=C2=A0 the rsp pointer can point=
 below __PAGE_OFFSET.<br><br>Slub harden<br>-----------<br>- redzone/poison=
 randomization.<br>- double free enhance.<br>=C2=A0 old slub can only detec=
t continuous double free bugs.<br>=C2=A0 kfree(obj1)<br>=C2=A0 kfree(obj1)<=
br><br>=C2=A0 hksp can detect no continuous double/multi free bugs.<br>=C2=
=A0 kfree(obj1)<br>=C2=A0 kfree(obj2)<br>=C2=A0 kfree(obj1)<br><br>=C2=A0 o=
r<br><br>=C2=A0 kfree(obj1)<br>=C2=A0 kfree(obj2)<br>=C2=A0 kfree(obj3)<br>=
=C2=A0 kfree(obj1)<br>- clear the next object address information when usin=
g kmalloc function.<br> <br>Proc info leak<br>--------------<br>Protect imp=
ortant file with no read access for non root user.<br>set /proc/{modules,ke=
ys,key-users},<br>/proc/sys/kernel/{panic,panic_on_oops,dmesg_restrict,kptr=
_restrict,keys},<br>/proc/sys/vm/{mmap_min_addr} as 0640.<br><br>Aslr harde=
nded<br>--------------<br>User stack aslr enhanced.<br>Old user process&#39=
;s stack is between 0-1G on 64bit.<br>the actually random range is 0-2^24.<=
br>we introduce STACK_RND_BITS to control the range dynamically.<br><br>ech=
o &quot;24&quot; &gt; /proc/sys/vm/stack_rnd_bits<br><br>we also randomize =
the space between elf_info and environ.<br>And randomize the space between =
stack and elf_info.<br><br>Ptrace hardened<br>---------------<br>Disallow a=
ttach to non child process.<br>This can prevent process memory inject via p=
trace.<br><br>Sm*p hardened<br>-------------<br>Check smap&amp;smep when re=
turn from kernel space via a syscall,<br>this can detect some kernel exploi=
t code to bypass smap &amp; smep<br>feature via rop attack technology.<br><=
br>Raw socket enhance<br>------------------<br>Enhance raw socket for ipv4 =
protocol.<br>- TCP data cannot be sent over raw sockets.<br>=C2=A0 echo 1 &=
gt; /proc/sys/net/ipv4/raw_tcp_disabled<br>- UDP datagrams with an invalid =
source address cannot be sent<br>=C2=A0 over raw sockets. The IP source add=
ress for any outgoing UDP<br>=C2=A0 datagram must exist on a network interf=
ace or the datagram is<br>=C2=A0 dropped. This change was made to limit the=
 ability of malicious<br>=C2=A0 code to create distributed denial-of-servic=
e attacks and limits<br>=C2=A0 the ability to send spoofed packets (TCP/IP =
packets with a forged<br>=C2=A0 source IP address).<br>=C2=A0 echo 1 &gt; /=
proc/sys/net/ipv4/raw_udp_verify<br>- A call to the bind function with a ra=
w socket for the IPPROTO_TCP<br>=C2=A0 protocol is not allowed.<br>=C2=A0 e=
cho 1 &gt; /proc/sys/net/ipv4/raw_bind_disabled<br><br>Kernel self guard<br=
>-----------------<br>Ksguard is an anti rootkit tool on kernel level.<br>C=
urrently it can detect 4 types of kernel rootkits,<br>These are the most po=
pluar rootkits type on unix world.<br><br>- keyboard notifer rootkits.<br>-=
 netfilter hooks rootkits.<br>- tty sniffer rootkits and other DKOM(direct =
kernel object modify) rootkits.<br>- system call table hijack rootkits.<br>=
<br>Install:<br>/sbin/insmod /lib/modules/5.6.7/kernel/security/ksguard/ksg=
uard.ko<br><br>Feature:<br>Detect keyboard notifer rootkits:<br>echo &quot;=
1&quot; &gt; /proc/ksguard/state<br><br>Detect netfilter hooks rootkits:<br=
>echo &quot;2&quot; &gt; /proc/ksguard/state<br><br>Detect tty sniffer root=
kits:<br>echo &quot;3&quot; &gt; /proc/ksguard/state<br><br>Detect syscall =
table pointer:<br>echo &quot;4&quot; &gt; /proc/ksguard/state<br><br>Arbitr=
ary code guard<br>--------------------<br>we extended the libc personality(=
) to support:<br>- mmap can&#39;t memory with PROT_WRITE|PROT_EXEC.<br>- mp=
rtect can&#39;t change PROT_WRITE to PROT_EXEC.<br><br>Code integrity guard=
<br>--------------------<br>To support certificate for user process execve.=
<br>it can prevent some internet explorer to load<br>third party so library=
s.<br><br>Hide symbol<br>-----------<br>Hide symbols from /proc/kallsyms.<b=
r></span><b></b><i></i><u></u><sub></sub><sup></sup><strike></strike><br></=
div></div></div></div>

--000000000000eadc2905a541d1ca--
