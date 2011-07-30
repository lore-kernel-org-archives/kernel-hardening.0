Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sat, 30 Jul 2011 22:20:02 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110730182002.GA4128@albatros>
References: <20110723162703.GA11631@openwall.com>
 <20110729090053.GA7274@albatros>
 <20110729173037.GA12284@openwall.com>
 <20110729180614.GB2623@albatros>
 <20110729224201.GA14029@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110729224201.GA14029@openwall.com>
Subject: [kernel-hardening] BINFMT_ELF_AOUT (was: -ow features)
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Solar,

On Sat, Jul 30, 2011 at 02:42 +0400, Solar Designer wrote:
> > like STRICT_DEVMEM?
> 
> I'm not sure why you mention this one as an example.

Because it guards some doubtful feature, which is considered harmful for
the generic system.

>  I think the
> CONFIG_BINFMT_ELF_AOUT name may be used, and this option will thus look
> (and work) similar to other CONFIG_BINFMT_* options.
> 
> > Looks like a good plan - kernel developers don't
> > like to support legacy stuff.  If it is moved to a config option, then
> > in some years it could be even fully removed (if I understand the AOUT
> > significance).
> 
> Right.  This stuff has been obsolete for 15+ years, at least for native
> Linux binaries.

Looks like it was almost fully removed in 2.6.25:

http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=d20894a23708c2af75966534f8e4dedb46d48db2

The only untouched part is load_elf_library().  I think I can simply
remove it in the proposed patch as full a.out removal from ELF format
was scheduled in 2.6.25.

Thanks,

-- 
Vasiliy
