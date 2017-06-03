Date: Sat, 3 Jun 2017 17:59:20 +0200
From: Greg KH <greg@kroah.com>
Message-ID: <20170603155920.GA25740@kroah.com>
References: <20170603055351.16080-1-matt@nmatt.com>
 <20170603154707.GA19161@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20170603154707.GA19161@openwall.com>
Subject: Re: [kernel-hardening] [PATCH v1 1/1] Add Trusted Path Execution as
 a stackable LSM
To: Solar Designer <solar@openwall.com>
Cc: Matt Brown <matt@nmatt.com>, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Jun 03, 2017 at 05:47:07PM +0200, Solar Designer wrote:
> On Sat, Jun 03, 2017 at 01:53:51AM -0400, Matt Brown wrote:
> > This patch was modified from Brad Spengler's Trusted Path Execution (TPE)
> > feature in Grsecurity and also incorporates logging ideas from
> > cormander's tpe-lkm.
> > 
> > Modifications from the Grsecurity implementation of TPE were made to
> > turn it into a stackable LSM using the existing LSM hook bprm_set_creds.
> > Also, denial messages were improved by including the full path of the
> > disallowed program. (This idea was taken from cormander's tpe-lkm)
> > 
> > Trusted Path Execution is not a new idea:
> > 
> > http://phrack.org/issues/52/6.html#article
> 
> FWIW, I think this is mostly a misfeature, which I deliberately didn't
> merge into -ow patches back then.

I agree with this :)

> > This option enables Trusted Path Execution. TPE blocks *untrusted*
> > users from executing files that meet the following conditions:
> > 
> > * file is not in a root-owned directory
> > * file is writable by a user other than root
> > 
> > NOTE: root is never restricted by TPE
> 
> > Threat Models:
> > 
> > 1. Attacker on system executing exploit on system vulnerability
> > 
> > *  If attacker uses a binary as a part of their system exploit, TPE can
> >    frustrate their efforts
> > 
> > *  Issues:
> >    *  Can be bypassed by interpreted languages such as python. You can run
> >       malicious code by doing: python -c 'evil code'
> 
> Yes, and not only that: a local attacker may also bypass TPE by what
> would have been non-security bugs in many other programs - e.g., a
> buffer overflow by a command-line argument in any of the allowed
> programs suddenly becomes security-relevant.
> 
> A variation of your threat model 1, which makes more sense to me than
> what's traditionally implied, is when the attacker does not yet use an
> interactive shell.  TPE can in fact frustrate automated remote exploits
> that don't specifically target (nor support) TPE-enabled systems.

But for those systems, and this feature as well, can't a "simple"
apparmor policy do the exact same thing?  Also, I'm sure the SELinux can
do this as well, but I don't know the config language there as well.

So I think this is already a feature that is supported, it just takes a
bit more configuration work on the admin.

thanks,

greg k-h
