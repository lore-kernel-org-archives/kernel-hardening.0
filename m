Reply-To: kernel-hardening@lists.openwall.com
Date: Tue, 19 Jan 2016 12:57:18 -0500
From: Theodore Ts'o <tytso@mit.edu>
Message-ID: <20160119175718.GA6872@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20160119124917.6058019b@pc1>
 <20160119112812.GA10818@mwanda>
Subject: Re: [kernel-hardening] 2015 kernel CVEs
To: kernel-hardening@lists.openwall.com
Cc: linux-kernel@vger.kernel.org
List-ID: <kernel-hardening.lists.openwall.com>

On Tue, Jan 19, 2016 at 02:28:12PM +0300, Dan Carpenter wrote:
> There was only a coupls CVEs that looks like they came from a filesystem
> fuzzer where you create a corrupt filesystems and then try use them.
> There was only one that might have come from a USB fuzzer.  We probably
> should be testing those things better.

On Tue, Jan 19, 2016 at 12:49:17PM +0100, Hanno Böck wrote:
> I tried that, but it didn't lead to any results in the kernel [1].
> What I did:
> * Use filesystem checking tools (fsck) and fuzz them with afl
> * Use the queue created by afl and try to mount these with a
>   kasan-enabled kernel
> 
> My conclusion was that the filesystem code in the kernel is relatively
> robust (at least robust enough for this trivial fuzzing).
> But it led to a number of bugs discovered in filesystem fsck tools.

An engineer at Red Hat did a pretty exhaustive set of file system
fuzzing some 5 years or so ago (plus or minus; I'm a little fuzzy on
the dates).  At the time he found a number of problems in ext4 and
other file systems, and those got fixed fairly promptly.  (It was
great; he gave us sample file systems to reproduce the bug, so it was
pretty straightforward to find and fix the problems found during that
effort.)

The ext4 related 2015 CVE's were all due to code that went in more
recently, and partially in response to that, Darrick Wong contributed
ext4-specific fuzzers to xfstess and to e2fsprogs.  I think he found
at least one or two ext4 bug that way, although I don't remember if
they got CVE's assigned to them.

Darrick's work, plus the relatively disciplined regression test suite
development policy in e2fsprogs is probably why Hanno didn't find any
such issues in e2fsprogs, although he did seem to find bugs in many of
the others file systems.

If I recall correctly Darrick had talked about trying to make a
filesystem-generic fuzzer for xfstests, but I'm not sure what happened
to that idea.  It looks like he also did provide a set of fuzzing
tests in xfstests, though.

So while I wouldn't want to discourage people from spending more time
in doing file system fuzz tests (I really *love* it when people find
and report bugs to me :-), I suspect the reason why we aren't finding
as many file system related CVE's is that it's well trodden ground,
since it's a pretty easy / obvious place to start probing for
weaknesses.  (And it's much easier than finding data races, for
example.)

If people do what to invest more in hardening file systems, I would
recommend automating the file system fuzz testers and then trying to
get the upstream file system developers to run them.

Cheers,

						- Ted
