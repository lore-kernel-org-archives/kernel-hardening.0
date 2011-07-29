Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Fri, 29 Jul 2011 22:06:14 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110729180614.GB2623@albatros>
References: <20110723162703.GA11631@openwall.com>
 <20110729090053.GA7274@albatros>
 <20110729173037.GA12284@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110729173037.GA12284@openwall.com>
Subject: Re: [kernel-hardening] -ow features
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

On Fri, Jul 29, 2011 at 21:30 +0400, Solar Designer wrote:
> > HARDEN_VM86
> > 
> > The code similar to -ow patch is ready, but I don't know how it should
> > be implemented relative to LSM/seccomp/etc.  It looks like a small
> > feature, which is not consistent with current upstream security
> > architecture.  I've described the problem here:
> > 
> > http://www.openwall.com/lists/kernel-hardening/2011/06/19/2
> > 
> > Without the major change of the configuration mechanism it's impossible
> > to get it applied.
> 
> In -ow, there's also CONFIG_BINFMT_ELF_AOUT.  When it is not enabled -
> and by default it is not - uselib(2) is disabled (returns -ENOSYS) and
> parts of binfmt_elf.c responsible for loading a.out libraries for ELF
> binaries are also disabled (truly ancient stuff).  We need something
> like this for 3.x and RHEL6 kernels too.
> 
> Maybe the CONFIG_BINFMT_ELF_AOUT option may be accepted upstream on the
> grounds that it's similar to other CONFIG_BINFMT_* options?

Do you propose to move all ELF_AOUT code to a configurable option, just
like STRICT_DEVMEM?  Looks like a good plan - kernel developers don't
like to support legacy stuff.  If it is moved to a config option, then
in some years it could be even fully removed (if I understand the AOUT
significance).

-- 
Vasiliy
