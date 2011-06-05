Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 5 Jun 2011 23:44:40 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110605194440.GA9413@openwall.com>
References: <20110605182830.GB5789@albatros> <20110605183027.GA5859@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110605183027.GA5859@albatros>
Subject: Re: [kernel-hardening] [RFC v1] debugfs mount options
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sun, Jun 05, 2011 at 10:30:27PM +0400, Vasiliy Kulikov wrote:
> On Sun, Jun 05, 2011 at 22:28 +0400, Vasiliy Kulikov wrote:
> > While implementing it, I realized that it is probably more usefull to
> > implement it as 2 sysctls and CONFIG_DEBUGFS_* options - a lot of
> > debugfs files are created at the boot time, so it makes sense to change
> > these setting at the compile time and not to bother with chmod'ing
> > already created files.
> 
> The same for configfs.  However, I'm hesitating to mention sysfs as it
> will be divided into well defined per-namespace parts in the future and
> global sysfs umask would be confusing.

I can't really comment on this.

However, please note that some Linux distros running in containers will
happen to mount sysfs, which with OpenVZ provides some very limited
functionality (just to make those distros happy).  Perhaps whatever you
implement will need to be consistent/compatible with that.

Alexander
