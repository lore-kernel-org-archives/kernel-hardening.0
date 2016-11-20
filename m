Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
In-Reply-To: <af8a6c3c-08b9-a354-d984-2428fdeebb8f@gmail.com>
References: <bf475a29-58cc-7b87-0821-9d23f01851b3@gmail.com>
 <CAJcbSZFq_r+bpzyU3VVdukHW3SXsD7EPHkobh7anPVvBgfXtqA@mail.gmail.com> <af8a6c3c-08b9-a354-d984-2428fdeebb8f@gmail.com>
From: Thomas Garnier <thgarnie@google.com>
Date: Sun, 20 Nov 2016 08:49:53 -0800
Message-ID: <CAJcbSZH2H2rd8f8Mg2NBxfTUdSWLyU_KrZbdZ=imKZNTjJjGSQ@mail.gmail.com>
Content-Type: multipart/alternative; boundary=001a113fc0ee13872c0541be54db
Subject: Re: [kernel-hardening] get NULL pointer dereferences or #GP fault to
 infomation leakage
To: Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

--001a113fc0ee13872c0541be54db
Content-Type: text/plain; charset=UTF-8

I agree that restricting access / filtering dmesg or equivalents is a good
thing.

An oops highlights that something went wrong and the OS should not continue
in this state. If you allow oops then an attacker might bruteforce KASLR
offsets for the kernel base, have multiple attempts at an heap overflow or
against a stack cookie. Many mitigations rely on the fact that the attacker
have only one attempt.

Taking your example on NULL pointer deref. It can be a simple pointer not
checked for NULL or a corrupted object. Not panicing leaves more room for
an attacker to reliably exploit a vulnerability.

Btw, Kees wrote this list of recommended settings:
http://kernsec.org/wiki/index.php/Kernel_Self_Protection_
Project#Recommended_settings

On Sat, Nov 19, 2016 at 6:12 PM, zerons <zeronsaxm@gmail.com> wrote:

> If kernel panic on oops, then NULL pointer deref and others may cause a
> DoS.
> Maybe restrict user access to dmesg and other log files so that
> unprivileged
> users couldn't read log messages, or something like /proc/kallsyms(output
> 0000
> if no permission). Then those faults stll be useless.
>
> On 11/20/2016 12:36 AM, Thomas Garnier wrote:
> > It is an issue because having KASLR enable without panic on oops is not
> > really useful. Same apply to other mitigations that rely on randomness.
> >
> > On Sat, Nov 19, 2016 at 3:50 AM, zerons <zeronsaxm@gmail.com> wrote:
> >
> >> I wonder if this could be an issue.
> >>
> >> Test on Ubuntu 16.04 with linux kernel 4.4.x, x86_64.
> >>
> >> When a NULL-pointer-deref or a #GP fault
> >> (e.g: access to 0xdead0000-xxxxxxxx) happens in kernel space,
> >> it seems that the kernel would kill the current process, then
> >> output the Oops message or "general protection fault" message.
> >>
> >> So we can get these messages via `dmesg` or reading the /var/log/...
> >>
> >> I think this may be a way to bypass the KASLR, could it be?
> >>
> >
> >
> >
>



-- 
Thomas

--001a113fc0ee13872c0541be54db
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">I agree that restricting access / filtering dmesg or equiv=
alents is a good thing.<div><br></div><div>An oops highlights that somethin=
g went wrong and the OS should not continue in this state. If you allow oop=
s then an attacker might bruteforce KASLR offsets for the kernel base, have=
 multiple attempts at an heap overflow or against a stack cookie. Many miti=
gations rely on the fact that the attacker have only one attempt.</div><div=
><br></div><div>Taking your example on NULL pointer deref. It can be a simp=
le pointer not checked for NULL or a corrupted object. Not panicing leaves =
more room for an attacker to reliably exploit a vulnerability.</div><div><b=
r></div><div>Btw, Kees wrote this list of recommended settings:=C2=A0<a hre=
f=3D"http://kernsec.org/wiki/index.php/Kernel_Self_Protection_Project#Recom=
mended_settings" rel=3D"noreferrer" target=3D"_blank" style=3D"font-size:12=
.8px">http://kernsec.org/wiki/index.<wbr>php/Kernel_Self_Protection_<wbr>Pr=
oject#Recommended_settings</a></div></div><div class=3D"gmail_extra"><br><d=
iv class=3D"gmail_quote">On Sat, Nov 19, 2016 at 6:12 PM, zerons <span dir=
=3D"ltr">&lt;<a href=3D"mailto:zeronsaxm@gmail.com" target=3D"_blank">zeron=
saxm@gmail.com</a>&gt;</span> wrote:<br><blockquote class=3D"gmail_quote" s=
tyle=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padding-left:1ex">If k=
ernel panic on oops, then NULL pointer deref and others may cause a DoS.<br=
>
Maybe restrict user access to dmesg and other log files so that unprivilege=
d<br>
users couldn&#39;t read log messages, or something like /proc/kallsyms(outp=
ut 0000<br>
if no permission). Then those faults stll be useless.<br>
<div class=3D"HOEnZb"><div class=3D"h5"><br>
On 11/20/2016 12:36 AM, Thomas Garnier wrote:<br>
&gt; It is an issue because having KASLR enable without panic on oops is no=
t<br>
&gt; really useful. Same apply to other mitigations that rely on randomness=
.<br>
&gt;<br>
&gt; On Sat, Nov 19, 2016 at 3:50 AM, zerons &lt;<a href=3D"mailto:zeronsax=
m@gmail.com">zeronsaxm@gmail.com</a>&gt; wrote:<br>
&gt;<br>
&gt;&gt; I wonder if this could be an issue.<br>
&gt;&gt;<br>
&gt;&gt; Test on Ubuntu 16.04 with linux kernel 4.4.x, x86_64.<br>
&gt;&gt;<br>
&gt;&gt; When a NULL-pointer-deref or a #GP fault<br>
&gt;&gt; (e.g: access to 0xdead0000-xxxxxxxx) happens in kernel space,<br>
&gt;&gt; it seems that the kernel would kill the current process, then<br>
&gt;&gt; output the Oops message or &quot;general protection fault&quot; me=
ssage.<br>
&gt;&gt;<br>
&gt;&gt; So we can get these messages via `dmesg` or reading the /var/log/.=
..<br>
&gt;&gt;<br>
&gt;&gt; I think this may be a way to bypass the KASLR, could it be?<br>
&gt;&gt;<br>
&gt;<br>
&gt;<br>
&gt;<br>
</div></div></blockquote></div><br><br clear=3D"all"><div><br></div>-- <br>=
<div class=3D"gmail_signature" data-smartmail=3D"gmail_signature">Thomas</d=
iv>
</div>

--001a113fc0ee13872c0541be54db--
