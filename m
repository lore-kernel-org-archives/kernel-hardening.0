Date: Mon, 13 Feb 2017 08:41:15 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
Message-ID: <20170213084115.GA16815@srcf.ucam.org>
References: <CANEHqc0zV9Ppj3Ny2GrV=f2grA5XiPOtxEmkZ9XaMxJmDvk-tw@mail.gmail.com>
 <CAGXu5jJXqY=KGHtrCQ3yLGVFd7K6Akk6B8VbWyZHGfRerYeV0A@mail.gmail.com>
 <1486777021.2096.36.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1486777021.2096.36.camel@redhat.com>
Subject: Re: [kernel-hardening] Introduction + new project: "rootkit
 detection using virtualization".
To: Rik van Riel <riel@redhat.com>
Cc: Kees Cook <keescook@chromium.org>, Matthew Giassa <matthew@giassa.net>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, KVM <kvm@vger.kernel.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 10, 2017 at 08:37:01PM -0500, Rik van Riel wrote:
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

I agree that this is valuable, but it feels like doing so probably 
involves designing a consistent mechanism for lightweight 
kernel→hypervisor calls - the existing vfio framework seems heavier than 
necessary for this kind of thing. Going further probably involves having 
a good way for syscalls to call into the hypervisor, but again finding a 
generic solution that doesn't add too much overhead seems like a good 
plan. My implementation of this was very special cased and didn't 
attempt to do anything in a generic way, so I'm definitely not a good 
model!

-- 
Matthew Garrett | mjg59@srcf.ucam.org
