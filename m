Reply-To: kernel-hardening@lists.openwall.com
Date: Mon, 6 Jun 2011 22:33:58 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110606183358.GA14711@openwall.com>
References: <20110603191153.GB514@openwall.com> <20110604054758.GA4063@albatros> <20110604132054.GC2583@openwall.com> <20110604200948.GA5850@shinshilla> <20110604205955.GA5972@openwall.com> <20110605182430.GA5789@albatros> <20110605192641.GA9240@openwall.com> <20110605194746.GA6484@albatros> <20110605201025.GA9541@openwall.com> <20110606180806.GA3986@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110606180806.GA3986@albatros>
Subject: Re: [kernel-hardening] [RFC v1] procfs mount options
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Mon, Jun 06, 2011 at 10:08:06PM +0400, Vasiliy Kulikov wrote:
> On Mon, Jun 06, 2011 at 00:10 +0400, Solar Designer wrote:
> > > Process A with UID=1000 opens /proc/123/, while 123 has UID=1000.
> > > 
> > > 123 exec's setuid binary, /proc/123/ becomes unaccessible to A.
> > > 
> > > However, A still keeps the directory opened and may read its contents.
> > 
> > Oh, this is a valid concern.  Please research this.  Perhaps there
> > should be a may-ptrace check (or maybe more than one).
> 
> This is similar to CVE-2011-1020:
> 
> https://lkml.org/lkml/2011/2/7/368
> http://seclists.org/fulldisclosure/2011/Jan/421
> 
> The proposed solution for separate procfs files is implementing
> additional runtime checks (besides POSIX perms),

Right.  IIRC, the approach with selectively adding may-ptrace checks to
sensitive proc files dates back to Linux 2.0.  Apparently, some newer
entries such as auxv were not covered by it (there's no /proc/PID/auxv
on 2.4).

> however, it probably doesn't scale for the whole PID directory.
> 
> Will try to invent some simple way to deal with it.

Maybe have a may-ptrace check automatically applied to all entries that
are not world-readable?

...Here's a trickier attack: open a sensitive /proc/PID/something file
on fd 0, invoke a SUID/SGID/fscap'ed program.  Depending on that
program's functionality, it might read its stdin and it might report
what it read from there (e.g., quote it in an error message complaining
about invalid input data).  I don't recall if this has been dealt with
in any way or not.

While these are good to research and fix, I am concerned about the scope
creep.  We might prefer to get a basic procfs mount options patch in
first, then propose these enhancements.

Thanks,

Alexander
