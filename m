Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 30 Jul 2011 02:42:01 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110729224201.GA14029@openwall.com>
References: <20110723162703.GA11631@openwall.com> <20110729090053.GA7274@albatros> <20110729173037.GA12284@openwall.com> <20110729180614.GB2623@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110729180614.GB2623@albatros>
Subject: Re: [kernel-hardening] -ow features
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy,

On Fri, Jul 29, 2011 at 10:06:14PM +0400, Vasiliy Kulikov wrote:
> On Fri, Jul 29, 2011 at 21:30 +0400, Solar Designer wrote:
> > In -ow, there's also CONFIG_BINFMT_ELF_AOUT.  When it is not enabled -
> > and by default it is not - uselib(2) is disabled (returns -ENOSYS) and
> > parts of binfmt_elf.c responsible for loading a.out libraries for ELF
> > binaries are also disabled (truly ancient stuff).  We need something
> > like this for 3.x and RHEL6 kernels too.
> > 
> > Maybe the CONFIG_BINFMT_ELF_AOUT option may be accepted upstream on the
> > grounds that it's similar to other CONFIG_BINFMT_* options?
> 
> Do you propose to move all ELF_AOUT code to a configurable option, just

Yes.

> like STRICT_DEVMEM?

I'm not sure why you mention this one as an example.  I think the
CONFIG_BINFMT_ELF_AOUT name may be used, and this option will thus look
(and work) similar to other CONFIG_BINFMT_* options.

> Looks like a good plan - kernel developers don't
> like to support legacy stuff.  If it is moved to a config option, then
> in some years it could be even fully removed (if I understand the AOUT
> significance).

Right.  This stuff has been obsolete for 15+ years, at least for native
Linux binaries.

Alexander
