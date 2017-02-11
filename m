MIME-Version: 1.0
In-Reply-To: <a43631c9-e170-ebfe-8b3a-f6d98f469f99@giassa.net>
References: <CANEHqc0zV9Ppj3Ny2GrV=f2grA5XiPOtxEmkZ9XaMxJmDvk-tw@mail.gmail.com>
 <CAG4AFWbVm+6a2GO0iPa6r84bP1jNfL6Rph4a1HDj6cDt-8y2Fw@mail.gmail.com> <a43631c9-e170-ebfe-8b3a-f6d98f469f99@giassa.net>
From: Jidong Xiao <jidong.xiao@gmail.com>
Date: Fri, 10 Feb 2017 20:43:32 -0700
Message-ID: <CAG4AFWagW_dzVRd8qsmUOaCOLBmjDNr=5DX7dFA0yFJ2pOjERw@mail.gmail.com>
Content-Type: multipart/alternative; boundary=f403045fbcdab44f840548390449
Subject: [kernel-hardening] Re: Introduction + new project: "rootkit detection using virtualization".
To: Matthew Giassa <matthew@giassa.net>
Cc: kernel-hardening@lists.openwall.com, KVM <kvm@vger.kernel.org>, Rik van Riel <riel@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

--f403045fbcdab44f840548390449
Content-Type: text/plain; charset=UTF-8

Thanks Matthew. So if I understand correctly, even though many people have
proposed similar solutions, none of them have actually contributed their
code (of their solution) into Qemu/KVM. To make it "real" (i.e., as a part
of Qemu/KVM code) is your goal, right? That sounds interesting!

-Jidong

On Fri, Feb 10, 2017 at 8:21 PM, Matthew Giassa <matthew@giassa.net> wrote:

> On 2017-02-10 03:18 PM, Jidong Xiao wrote:
>
>> Sorry, I have to resend this again, as the original two emails were
>> blocked because of the url.
>>
>> "Rootkit detection using virtualization" has been widely studied for a
>> decade. Is the approach you are going to use different from all of these
>> existing ones:
>>
>> "Survey: Virtual Machine Introspection Based System Monitoring and
>> Malware Detection Techniques" - by Haofu Liao at University of Rochester.
>>
>> -Jidong
>>
>
> On 2017-02-10 05:37 PM, Rik van Riel wrote:
> >
> > One of the things that Matthew can do is build on
> > the read-only memory protections in the kernel, and
> > have the hypervisor enforce that the memory the kernel
> > marks as read-only is never written from inside the
> > virtual machine, until the next reboot.
> >
> > That seems like it might be a useful place to start,
> > since it would immediately make the other read-only
> > protections that people are working on much harder to
> > get around, at least inside virtual machines.
> >
>
>
> My initial plan was to start with what Rik proposed, and focus on
> additional memory protections. With respect to long-term plans, a lot of my
> work/research so far has been focused on implementing a system similar to
> that presented by Payne et al (ie: Lares).
>
> -Matthew Giassa
>

--f403045fbcdab44f840548390449
Content-Type: text/html; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">Thanks Matthew. So if I understand correctly, even though =
many people have proposed similar solutions, none of them have actually con=
tributed their code (of their solution) into Qemu/KVM. To make it &quot;rea=
l&quot; (i.e., as a part of Qemu/KVM code) is your goal, right? That sounds=
 interesting!<div><br></div><div>-Jidong</div></div><div class=3D"gmail_ext=
ra"><br><div class=3D"gmail_quote">On Fri, Feb 10, 2017 at 8:21 PM, Matthew=
 Giassa <span dir=3D"ltr">&lt;<a href=3D"mailto:matthew@giassa.net" target=
=3D"_blank">matthew@giassa.net</a>&gt;</span> wrote:<br><blockquote class=
=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1px #ccc solid;padd=
ing-left:1ex"><span class=3D"">On 2017-02-10 03:18 PM, Jidong Xiao wrote:<b=
r>
<blockquote class=3D"gmail_quote" style=3D"margin:0 0 0 .8ex;border-left:1p=
x #ccc solid;padding-left:1ex">
Sorry, I have to resend this again, as the original two emails were<br>
blocked because of the url.<br>
<br>
&quot;Rootkit detection using virtualization&quot; has been widely studied =
for a<br>
decade. Is the approach you are going to use different from all of these<br=
>
existing ones:<br>
<br>
&quot;Survey: Virtual Machine Introspection Based System Monitoring and<br>
Malware Detection Techniques&quot; - by Haofu Liao at University of Rochest=
er.<br>
<br>
-Jidong<br>
</blockquote>
<br></span><span class=3D"">
On 2017-02-10 05:37 PM, Rik van Riel wrote:<br>
&gt;<br>
&gt; One of the things that Matthew can do is build on<br>
&gt; the read-only memory protections in the kernel, and<br>
&gt; have the hypervisor enforce that the memory the kernel<br>
&gt; marks as read-only is never written from inside the<br>
&gt; virtual machine, until the next reboot.<br>
&gt;<br>
&gt; That seems like it might be a useful place to start,<br>
&gt; since it would immediately make the other read-only<br>
&gt; protections that people are working on much harder to<br>
&gt; get around, at least inside virtual machines.<br>
&gt;<br>
<br>
<br></span>
My initial plan was to start with what Rik proposed, and focus on additiona=
l memory protections. With respect to long-term plans, a lot of my work/res=
earch so far has been focused on implementing a system similar to that pres=
ented by Payne et al (ie: Lares).<span class=3D"HOEnZb"><font color=3D"#888=
888"><br>
<br>
-Matthew Giassa<br>
</font></span></blockquote></div><br></div>

--f403045fbcdab44f840548390449--
