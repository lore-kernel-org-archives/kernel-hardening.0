Date: Thu, 22 Feb 2018 11:13:46 +0000
From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: Hello world! Student interested in getting involved.
Message-ID: <20180222111346.pvqfk46ufeop5xe6@lakrids.cambridge.arm.com>
References: <CAAGnT3YJGf=eixt2+O_XsHiJZFP+CSO9A0a4qc-NKHRf=4y0sw@mail.gmail.com>
 <CAGXu5jJBmKiDnhV26kEZyCf+TGWnpMOvSjiYaUr1U6z0FLPJHg@mail.gmail.com>
 <CAKv+Gu_SxHCekoCoOFTOLFbN0besY+BRj+AzUYk88xK=zsZKBg@mail.gmail.com>
 <CAAGnT3ZwmJ7GtNZwSqW7sa2G59-3RvRzyTnqCYiB3ABiqxzpOQ@mail.gmail.com>
 <CAGXu5j+rXRSWKRnEV4qC4PfAZQ+AUmx9DLWLseZv4-U=wR3JzQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+rXRSWKRnEV4qC4PfAZQ+AUmx9DLWLseZv4-U=wR3JzQ@mail.gmail.com>
To: Kees Cook <keescook@chromium.org>
Cc: Ahmed Soliman <ahmedsoliman0x666@gmail.com>, Ard Biesheuvel <ard.biesheuvel@linaro.org>, Rik van Riel <riel@redhat.com>, KVM <kvm@vger.kernel.org>, Kernel Hardening <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Feb 21, 2018 at 01:44:27PM -0800, Kees Cook wrote:
> On Sat, Feb 17, 2018 at 7:22 AM, Ahmed Soliman
> <ahmedsoliman0x666@gmail.com> wrote:
> > well in this case I tried searching and researching more and I found
> > the idea for Rootkit blocking using KVM virtualization, it is
> > described here:
> > https://kernelnewbies.org/KernelProjects/VirtRootkitBlocker
> 
> I think it's good to experiment with kernel hardening via hypervisors.
> There isn't any particular direction defined for this approach, with
> lots of different things getting tried (e.g. Samsung KNOX). One
> problem with the hypervisor-control of memory protections is things
> like kprobes, modules, etc, that need to do dynamic rewriting of
> kernel text.

FWIW, a while back, we had an intern prototype some stage-2 W^X
protections for KVM guests on arm64. For kprobes, modules, and other
things requiring text modification, we locked those down late in the
boot process, which seemed like a reasonable tradeoff.

One big issue was static keys, since those need to be flipped
occasionally. We modified those to have two patchable branches rather
than one, so that we could fall back to a slow path that read a variable
when text modification was disabled.

We didn't end up posting those patches because there were a number of
open questions about the hypervisor ABI (e.g. how we could discover that
the hypervisor provided this feature). For arm64, we'll need to do some
FW standards work for that -- I'm not sure what the deal is for x86.

Thanks,
Mark.
