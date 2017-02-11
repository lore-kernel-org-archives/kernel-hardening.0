References: <CANEHqc0zV9Ppj3Ny2GrV=f2grA5XiPOtxEmkZ9XaMxJmDvk-tw@mail.gmail.com>
 <CAG4AFWbVm+6a2GO0iPa6r84bP1jNfL6Rph4a1HDj6cDt-8y2Fw@mail.gmail.com>
From: Matthew Giassa <matthew@giassa.net>
Message-ID: <a43631c9-e170-ebfe-8b3a-f6d98f469f99@giassa.net>
Date: Fri, 10 Feb 2017 19:21:45 -0800
MIME-Version: 1.0
In-Reply-To: <CAG4AFWbVm+6a2GO0iPa6r84bP1jNfL6Rph4a1HDj6cDt-8y2Fw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: Introduction + new project: "rootkit detection using
 virtualization".
To: Jidong Xiao <jidong.xiao@gmail.com>
Cc: kernel-hardening@lists.openwall.com, KVM <kvm@vger.kernel.org>, Rik van Riel <riel@redhat.com>
List-ID: <kernel-hardening.lists.openwall.com>

On 2017-02-10 03:18 PM, Jidong Xiao wrote:
> Sorry, I have to resend this again, as the original two emails were
> blocked because of the url.
>
> "Rootkit detection using virtualization" has been widely studied for a
> decade. Is the approach you are going to use different from all of these
> existing ones:
>
> "Survey: Virtual Machine Introspection Based System Monitoring and
> Malware Detection Techniques" - by Haofu Liao at University of Rochester.
>
> -Jidong

On 2017-02-10 05:37 PM, Rik van Riel wrote:
 >
 > One of the things that Matthew can do is build on
 > the read-only memory protections in the kernel, and
 > have the hypervisor enforce that the memory the kernel
 > marks as read-only is never written from inside the
 > virtual machine, until the next reboot.
 >
 > That seems like it might be a useful place to start,
 > since it would immediately make the other read-only
 > protections that people are working on much harder to
 > get around, at least inside virtual machines.
 >


My initial plan was to start with what Rik proposed, and focus on 
additional memory protections. With respect to long-term plans, a lot of 
my work/research so far has been focused on implementing a system 
similar to that presented by Payne et al (ie: Lares).

-Matthew Giassa
