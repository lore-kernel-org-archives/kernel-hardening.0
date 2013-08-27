Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 27 Aug 2013 18:24:06 +0100
From: Djalal Harouni <tixxdz@opendz.org>
Message-ID: <20130827172406.GA2664@dztty>
References: <1377534240-13227-1-git-send-email-tixxdz@opendz.org>
 <871u5gqtw3.fsf@xmission.com>
 <20130826172054.GE27005@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130826172054.GE27005@ZenIV.linux.org.uk>
Subject: [kernel-hardening] Re: [PATCH 1/2] procfs: restore 0400 permissions on
 /proc/*/{syscall,stack,personality}
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi Al,

On Mon, Aug 26, 2013 at 06:20:55PM +0100, Al Viro wrote:
> On Mon, Aug 26, 2013 at 09:49:48AM -0700, Eric W. Biederman wrote:
> 
> > How does changing the permissions to S_IRUSR prevent someone from
> > opening the file before, and reading the file after a suid exec?
> > 
> > > This patch restores the old mode which was 0400
> > 
> > Which seems to add no security whatsoever and obscure the fact that
> > anyone who cares can read the file so what is the point?
> 
> Two words: "security sclerosis".  Both patches NAKed, of course.
These particular tissues "are being hardened", no cure for them


More seriously, Al your commit a9712bc12c40c172e393f85 closes the races
during read() ok, but can you please share some light why the permission
mode was changed ?

1)
The commit log states that all these files are "rw-r--r--" which was not
correct, they were "r--------" before that commit.

2)
The commit log says also:
"if you open a file before the target does suid-root exec, you'll be still
able to access it." so you do the task is tracable check at read()

But what if you open a file of a privileged target or a target that does
suid-root exec later, and pass the fd to a suid-root exec to read() from
it later, you will still pass that tracable check.

And currently a non-privileged process can get an fd on all these
/proc/*/stack files even root owned ones.

So why not restore the old behaviour and block a process from getting an
fd on /proc/*/stack files that belong to other processes?


The original thread that added the /proc/*/stack feature:
https://lkml.org/lkml/2008/11/7/109

They noted that it should be under 0400 permissions

So why remove that, or why not restore the old safe behaviour ?


Hope to get a response

Thanks Al

-- 
Djalal Harouni
http://opendz.org
