Reply-To: kernel-hardening@lists.openwall.com
Date: Sat, 11 Feb 2012 17:31:46 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20120211133146.GA19489@openwall.com>
References: <20120210020658.GA17709@dztty> <20120210143616.GA6100@albatros> <20120211092050.GA18669@openwall.com> <20120211102105.GA18464@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120211102105.GA18464@albatros>
Subject: Re: [kernel-hardening] procfs: infoleaks and DAC permissions
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Feb 11, 2012 at 02:21:06PM +0400, Vasiliy Kulikov wrote:
> On Sat, Feb 11, 2012 at 13:20 +0400, Solar Designer wrote:
> > I did not look into this closely, but my current understanding is that
> > apparently glibc reads the process' own proc files only, and restricting
> > their perms to 0400 breaks this if the process changes euid/fsuid during
> > its runtime.  Right?
> 
> Yes, AFAICS, it looks whether a specific memory area is RW.  But looking
> at "grep -r /proc/self/ glibc-sources/" output I can say /proc/self/maps
> is not the only file usage which might be broken by open() restricting.

Yes, and not all pathnames are constant - there's also
"/proc/self/task/%u/comm".

Alexander
