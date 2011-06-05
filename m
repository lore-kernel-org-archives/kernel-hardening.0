Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 5 Jun 2011 22:47:06 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110605184706.GA9107@openwall.com>
References: <20110603191153.GB514@openwall.com> <20110605183620.GB5859@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110605183620.GB5859@albatros>
Subject: Re: [kernel-hardening] procfs mount options
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jun 05, 2011 at 10:36:20PM +0400, Vasiliy Kulikov wrote:
> On Fri, Jun 03, 2011 at 23:11 +0400, Solar Designer wrote:
> > Indeed, we could set some of these perms with chmod post-mount, but as
> > discussed this has drawbacks.  So ideally our preferred configuration
> > (which will be the default on Owl) should be achievable with mount
> > options alone.
> 
> What if implement mode=XXX option to alter root directory permissions
> only, like tmpfs?  Then all non-pid files may be chmod'ed without any
> race due to distro-specific policy and then "chmod a+rx /proc" to allow
> nonroot users to see procfs files.

This makes sense to me, although other mount options that you
implemented appear to be sufficient to implement the desired default
policy for Owl.

Alexander
