Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 16 Jan 2017 15:24:25 +0000
From: Mark Rutland <mark.rutland@arm.com>
Message-ID: <20170116152425.GG5908@leverpostej>
References: <20170113220256.GA57663@beast>
 <5879F762.32059.37092152@pageexec.freemail.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5879F762.32059.37092152@pageexec.freemail.hu>
Subject: [kernel-hardening] Re: [PATCH] gcc-plugins: Add structleak for more stack initialization
To: PaX Team <pageexec@freemail.hu>
Cc: kernel-hardening@lists.openwall.com, Kees Cook <keescook@chromium.org>, Emese Revfy <re.emese@gmail.com>, "AKASHI, Takahiro" <takahiro.akashi@linaro.org>, park jinbum <jinb.park7@gmail.com>, Daniel Micay <danielmicay@gmail.com>, linux-kernel@vger.kernel.org, spender@grsecurity.net
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

On Sat, Jan 14, 2017 at 11:03:14AM +0100, PaX Team wrote:
> On 13 Jan 2017 at 14:02, Kees Cook wrote:
> 
> > +config GCC_PLUGIN_STRUCTLEAK_VERBOSE
> > +	bool "Report initialized variables"
> > +	depends on GCC_PLUGIN_STRUCTLEAK
> > +	depends on !COMPILE_TEST
> > +	help
> > +	  This option will cause a warning to be printed each time the
> > +	  structleak plugin finds a variable it thinks needs to be
> > +	  initialized. Since not all existing initializers are detected
> > +	  by the plugin, this can produce false positive warnings.
> 
> there are no false positives, a variable either has a constructor or it does not ;)

... or it has no constructor, but is clobbered by a memset before it is
possibly copied. ;)

For example:

arch/arm64/kernel/fpsimd.c: In function 'do_fpsimd_exc':
arch/arm64/kernel/fpsimd.c:106:12: note: userspace variable will be forcibly initialized
  siginfo_t info;

... where the code looks like:

void do_fpsimd_exc(unsigned int esr, struct pt_regs *regs)
{
	siginfo_t info;
	unsigned int si_code = 0;

	if (esr & FPEXC_IOF)
		si_code = FPE_FLTINV;
	else if (esr & FPEXC_DZF)
		si_code = FPE_FLTDIV;
	else if (esr & FPEXC_OFF)
		si_code = FPE_FLTOVF;
	else if (esr & FPEXC_UFF)
		si_code = FPE_FLTUND;
	else if (esr & FPEXC_IXF)
		si_code = FPE_FLTRES;

	memset(&info, 0, sizeof(info));
	info.si_signo = SIGFPE;
	info.si_code = si_code;
	info.si_addr = (void __user *)instruction_pointer(regs);

	send_sig_info(SIGFPE, &info, current);
}

... so it's clear to a human that info is initialised prior to use,
though not by an explicit field initializer.

> > +/* unused C type flag in all versions 4.5-6 */
> > +#define TYPE_USERSPACE(TYPE) TYPE_LANG_FLAG_5(TYPE)
> 
> FYI, this is a sort of abuse/hack of tree flags and should not be implemented this
> way in the upstream kernel as it's a finite resource and needs careful verification
> against all supported gcc versions (these flags are meant for language fronteds, i
> kinda got lucky to have a few of them unusued but it's not a robust future-proof
> approach). instead an attribute should be used to mark these types. whether that
> can/should be __user itself is a good question since that's another hack where the
> plugin 'hijacks' a sparse address space atttribute (for which gcc 4.6+ has its own
> facilities and that the checker gcc plugin makes use of thus it's not compatible
> with structleak as is).

To me, it seems that the __user annotation can only be an indicator of
an issue by chance. We have structures with __user pointers in structs
that will never be copied to userspace, and conversely we have structs
that don't contain a __user field, but will be copied to userspace.

Maybe it happens that structs in more complex systems are more likely to
contain some __user pointer. Was that part of the rationale?

I wonder if there's any analysis we can do of data passing into
copy_to_user() and friends. I guess we can't follow the data flow across
compilation units, but we might be able to follow it well enough if we
added a new attribute that described whether data was to be copied to
userspace.

Thanks,
Mark.
