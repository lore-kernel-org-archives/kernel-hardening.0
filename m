MIME-Version: 1.0
In-Reply-To: <2C5142675EC1274EAB6230F72F8DC95F414F4217@ORSMSX116.amr.corp.intel.com>
References: <CANEHqc0zV9Ppj3Ny2GrV=f2grA5XiPOtxEmkZ9XaMxJmDvk-tw@mail.gmail.com>
 <CAG4AFWbVm+6a2GO0iPa6r84bP1jNfL6Rph4a1HDj6cDt-8y2Fw@mail.gmail.com>
 <a43631c9-e170-ebfe-8b3a-f6d98f469f99@giassa.net> <CAG4AFWagW_dzVRd8qsmUOaCOLBmjDNr=5DX7dFA0yFJ2pOjERw@mail.gmail.com>
 <CANEHqc0bi6wnPOLWx_fDd9xDXN=8xEw7ZF4Be=SnKtoLbBizkg@mail.gmail.com>
 <CABayD+eeq+8yzdTQ9GsUkMuUagWNQqaKqdVJikHAnPorobDjzQ@mail.gmail.com>
 <70a9cb32-471e-9827-fae6-cd46a40c87b1@giassa.net> <2C5142675EC1274EAB6230F72F8DC95F414F4217@ORSMSX116.amr.corp.intel.com>
From: Matthew Giassa <matthew@giassa.net>
Date: Thu, 16 Feb 2017 17:16:19 -0800
Message-ID: <CANEHqc3AjpvKYxOo0dOM6huE+ZgoZRkx8Q+SOpQQ9y3-Y9qryA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Subject: [kernel-hardening] Re: Introduction + new project: "rootkit detection using virtualization".
To: "Grandhi, Sainath" <sainath.grandhi@intel.com>
Cc: Steve Rutherford <srutherford@google.com>, Jidong Xiao <jidong.xiao@gmail.com>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, KVM <kvm@vger.kernel.org>, Rik van Riel <riel@redhat.com>, "Nakajima, Jun" <jun.nakajima@intel.com>
List-ID: <kernel-hardening.lists.openwall.com>

Thank you for this, Sainath. Is this module of yours already in
mainline KVM, or elsewhere in a separate repo?

Cheers!

On Wed, Feb 15, 2017 at 10:31 PM, Grandhi, Sainath
<sainath.grandhi@intel.com> wrote:
> Hi Matthew,
> We have been working on a Kernel Hardening project. Please find slides at=
 http://events.linuxfoundation.org/sites/events/files/slides/Kernel%20Prote=
ction-Nakajima.pdf . We presented this idea in KVM Forum 2016. The idea is =
to protect CPU/platform resources and kernel managed resources (IDT, kernel=
 page tables etc.) during execution of a VM. This approach is extended to b=
aremetal/host OS by switching the execution of host OS into guest mode and =
monitoring the host OS with a very thin hypervisor, probably kvm module ext=
ension. Currently we have a PoC, contained in kvm module, for switching the=
 host OS into guest mode. We are open for collaboration and feedback.
>
> Thanks
> -Sainath
>> -----Original Message-----
>> From: kvm-owner@vger.kernel.org [mailto:kvm-owner@vger.kernel.org] On
>> Behalf Of Matthew Giassa
>> Sent: Tuesday, February 14, 2017 7:32 PM
>> To: Steve Rutherford <srutherford@google.com>
>> Cc: Jidong Xiao <jidong.xiao@gmail.com>; kernel-
>> hardening@lists.openwall.com; KVM <kvm@vger.kernel.org>; Rik van Riel
>> <riel@redhat.com>
>> Subject: Re: Introduction + new project: "rootkit detection using
>> virtualization".
>>
>> On 2017-02-14 01:25 PM, Steve Rutherford wrote:
>> > On Tue, Feb 14, 2017 at 10:06 AM, Matthew Giassa <matthew@giassa.net>
>> wrote:
>> >> Hi Jidong,
>> >>
>> >> You are correct on all the points noted above:My goal is to develop a
>> >> production-ready, non-academic implementation of such a tool. I'm in
>> >> it for the long haul.
>> > Is your goal for this to work on all architectures, or are you
>> > planning to focus on Intel-x86 (or AMD-x86, or ARM, or...)?
>> >>
>> >> On Fri, Feb 10, 2017 at 7:43 PM, Jidong Xiao <jidong.xiao@gmail.com>
>> wrote:
>> >>> Thanks Matthew. So if I understand correctly, even though many
>> >>> people have proposed similar solutions, none of them have actually
>> >>> contributed their code (of their solution) into Qemu/KVM. To make it
>> >>> "real" (i.e., as a part of Qemu/KVM code) is your goal, right? That =
sounds
>> interesting!
>> >>>
>> >>> -Jidong
>> >>>
>> >>> On Fri, Feb 10, 2017 at 8:21 PM, Matthew Giassa <matthew@giassa.net>
>> wrote:
>> >>>>
>> >>>> On 2017-02-10 03:18 PM, Jidong Xiao wrote:
>> >>>>>
>> >>>>> Sorry, I have to resend this again, as the original two emails
>> >>>>> were blocked because of the url.
>> >>>>>
>> >>>>> "Rootkit detection using virtualization" has been widely studied
>> >>>>> for a decade. Is the approach you are going to use different from
>> >>>>> all of these existing ones:
>> >>>>>
>> >>>>> "Survey: Virtual Machine Introspection Based System Monitoring and
>> >>>>> Malware Detection Techniques" - by Haofu Liao at University of
>> Rochester.
>> >>>>>
>> >>>>> -Jidong
>> >>>>
>> >>>>
>> >>>> On 2017-02-10 05:37 PM, Rik van Riel wrote:
>> >>>>>
>> >>>>> One of the things that Matthew can do is build on the read-only
>> >>>>> memory protections in the kernel, and have the hypervisor enforce
>> >>>>> that the memory the kernel marks as read-only is never written
>> >>>>> from inside the virtual machine, until the next reboot.
>> >>>>>
>> >>>>> That seems like it might be a useful place to start, since it
>> >>>>> would immediately make the other read-only protections that people
>> >>>>> are working on much harder to get around, at least inside virtual
>> >>>>> machines.
>> >>>>>
>> >>>>
>> >>>>
>> >>>> My initial plan was to start with what Rik proposed, and focus on
>> >>>> additional memory protections. With respect to long-term plans, a
>> >>>> lot of my work/research so far has been focused on implementing a
>> >>>> system similar to that presented by Payne et al (ie: Lares).
>> >>>>
>> >>>> -Matthew Giassa
>> >>>
>> >>>
>> >>
>> >>
>> >>
>> >> --
>> >>
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> >> Matthew Giassa, MASc, BASc, EIT
>> >> Principal Developer; Security and Embedded Systems Specialist
>> >> linkedin: https://ca.linkedin.com/in/giassa
>> >> e-mail:   matthew@giassa.net
>> >> website:  www.giassa.net
>>
>> My initial aim is x86/x64 targets, unless there are additional resources=
 I can
>> tap into for expanding to ARM. If I can get a working prototype up and r=
unning
>> and into "staging", then expanding to ARM architecture would be viable.
>>
>



--=20
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
Matthew Giassa, MASc, BASc, EIT
Principal Developer; Security and Embedded Systems Specialist
linkedin: https://ca.linkedin.com/in/giassa
e-mail:   matthew@giassa.net
website:  www.giassa.net
