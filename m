MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CAAGnT3ZwmJ7GtNZwSqW7sa2G59-3RvRzyTnqCYiB3ABiqxzpOQ@mail.gmail.com>
References: <CAAGnT3YJGf=eixt2+O_XsHiJZFP+CSO9A0a4qc-NKHRf=4y0sw@mail.gmail.com>
 <CAGXu5jJBmKiDnhV26kEZyCf+TGWnpMOvSjiYaUr1U6z0FLPJHg@mail.gmail.com>
 <CAKv+Gu_SxHCekoCoOFTOLFbN0besY+BRj+AzUYk88xK=zsZKBg@mail.gmail.com> <CAAGnT3ZwmJ7GtNZwSqW7sa2G59-3RvRzyTnqCYiB3ABiqxzpOQ@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Date: Wed, 21 Feb 2018 13:44:27 -0800
Message-ID: <CAGXu5j+rXRSWKRnEV4qC4PfAZQ+AUmx9DLWLseZv4-U=wR3JzQ@mail.gmail.com>
Subject: Re: Hello world! Student interested in getting involved.
Content-Type: text/plain; charset="UTF-8"
To: Ahmed Soliman <ahmedsoliman0x666@gmail.com>
Cc: Ard Biesheuvel <ard.biesheuvel@linaro.org>, Rik van Riel <riel@redhat.com>, KVM <kvm@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Feb 17, 2018 at 7:22 AM, Ahmed Soliman
<ahmedsoliman0x666@gmail.com> wrote:
> well in this case I tried searching and researching more and I found
> the idea for Rootkit blocking using KVM virtualization, it is
> described here:
> https://kernelnewbies.org/KernelProjects/VirtRootkitBlocker

I think it's good to experiment with kernel hardening via hypervisors.
There isn't any particular direction defined for this approach, with
lots of different things getting tried (e.g. Samsung KNOX). One
problem with the hypervisor-control of memory protections is things
like kprobes, modules, etc, that need to do dynamic rewriting of
kernel text.

> I CCed to riel
> It took me a while to re-learn how to setup kernel developing
> environment, via buildroot for generating qemu
> images for paravirtualized OS debugging, and learning about mm and KVM (WIP).
> I am not sure if this is the right place but I think anti rootkits can
> be good hardening technique, I made sure
> that no one is working on this (no patches anywhere), and my
> team-mates are happy with the idea so I hope we are
> ready to start. Just in case anyone tries to drift me off the idea, I
> do like it enough so I already talked to my professor
> and my team-mates about it. I just wanted to know which tree should I
> be working on, should it be the kernel hardening
> tree or the tree used for kvm or memory management.

I would develop against Linus's latest release tag (e.g. currently
v4.15), unless you have some overwhelming reason to base on a
subsystem tree.

-Kees

-- 
Kees Cook
Pixel Security
