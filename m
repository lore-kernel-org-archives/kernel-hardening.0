Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 12 Dec 2015 12:40:20 +0100
From: Heiko Carstens <heiko.carstens@de.ibm.com>
Message-ID: <20151212114020.GB3848@osiris>
References: <20151209172101.GA70633@davidb.org>
 <CAGXu5j+0oBHdS7vTQp_0ubuwvUftosYZCx8RJPXh7v7eYQncEQ@mail.gmail.com>
 <1449770155.8579.2.camel@gmail.com>
 <CAGXu5jK7LcS9M4NBZr3q8RVQss6GKQ-ifxhOTCMTAGZv3hF02A@mail.gmail.com>
 <1449774477.8579.4.camel@gmail.com>
 <CAGXu5j+OhUjRZSfCoFZeAY23-rzGDQ_6cU886BNSr3PCzQ60Hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5j+OhUjRZSfCoFZeAY23-rzGDQ_6cU886BNSr3PCzQ60Hw@mail.gmail.com>
Subject: Re: [kernel-hardening] Self Introduction
To: Kees Cook <keescook@chromium.org>
Cc: "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Catalin Marinas <catalin.marinas@arm.com>, PaX Team <pageexec@freemail.hu>, Michael Ellerman <mpe@ellerman.id.au>, Ralf Baechle <ralf@linux-mips.org>
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, Dec 10, 2015 at 11:23:34AM -0800, Kees Cook wrote:
> On Thu, Dec 10, 2015 at 11:07 AM, Daniel Micay <danielmicay@gmail.com> wrote:
> >> Yeah. PCID was Sandybridge and later?
> >
> > Yeah, that's right. And it defaults to the strong PCID implementation,
> > but there's also a weaker but significantly faster PCID-based one.
> 
> Is there anyone from Intel on the list? I would love to see UDEREF
> ported to upstream on x86 (and the non PCID version too). No one has
> stepped up to work on it yet.
> 
> As for non-ARM and non-x86, IIRC s/390 has always had PAN, and I'd
> love to update the matrix for powerpc and MIPS.
> 
> http://kernsec.org/wiki/index.php/Exploit_Methods/Userspace_data_usage

The statement for s390 is correct: we always had PAN in use. It's a
hardware feature simply called "Address Spaces".

The way we use it in Linux on s390 makes is impossible to access user space
contents from kernel space without special instructions.
