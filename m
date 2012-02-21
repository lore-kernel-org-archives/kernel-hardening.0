Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 21 Feb 2012 17:34:12 +0100
From: Djalal Harouni <tixxdz@opendz.org>
Message-ID: <20120221163412.GB12919@dztty>
References: <20120210020658.GA17709@dztty>
 <20120210143616.GA6100@albatros>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120210143616.GA6100@albatros>
Subject: Re: [kernel-hardening] procfs: infoleaks and DAC permissions
To: kernel-hardening@lists.openwall.com
Cc: Kees Cook <keescook@chromium.org>, "Jason A. Donenfeld" <Jason@zx2c4.com>, Solar Designer <solar@openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Fri, Feb 10, 2012 at 06:36:17PM +0400, Vasiliy Kulikov wrote:
> On Fri, Feb 10, 2012 at 03:06 +0100, Djalal Harouni wrote:
> > A partial fix for this (2):
> > Procfs 'hidepid=' mount option which can be used to restrict access to
> > arbitrary /proc/<pid>/ files, Vasiliy commit [3], congrats.
> > But if the procfs 'gid=' mount option is used then it can give permissions
> > back to read these files if the user is part of the 'gid' group. IOW this
> > will just restore the previous vulnerable situation.
> 
> It is even weaker - you could trick setuid $SPID to open /proc/$PID/maps,
> do exec(setuid_app) as $PID and read setuid_app's maps as $SPID.
Just want to say that I got your point:

I was refering to (2), but your response about 'hidepid' and how to play
with it is more related to (1) setuid self-read and keeping fd opened. The
(ugly) patch I sent will block it.

Spender's patch will do the job.

Note: that trick can give an extra lseek() to the attacker on
/proc/$PID/maps... that will be reflected on the executed setuid_app.


-- 
tixxdz
http://opendz.org
