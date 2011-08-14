Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 14 Aug 2011 13:50:10 +0400
From: Solar Designer <solar@openwall.com>
Message-ID: <20110814095010.GA14443@openwall.com>
References: <20110810142609.GA31434@openwall.com> <20110810150257.GA12198@albatros> <20110810154059.GA31860@openwall.com> <20110810162101.GA2833@albatros> <20110810164225.GA32177@openwall.com> <20110812120747.GA14598@albatros> <20110812122343.GA7859@openwall.com> <20110813151220.GA8388@albatros> <20110813151947.GA12495@openwall.com> <20110813165502.GA9328@albatros>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110813165502.GA9328@albatros>
Subject: Re: [kernel-hardening] 32/64 bitness restriction for pid namespace
To: kernel-hardening@lists.openwall.com
Cc: Chris Evans <scarybeasts@gmail.com>, djm@mindrot.org
List-ID: <kernel-hardening.lists.openwall.com>

Vasiliy,

On Sat, Aug 13, 2011 at 08:55:02PM +0400, Vasiliy Kulikov wrote:
> Some thoughts about prctl() approach.

Here's a further thought:

The feature makes sense not only for pid namespaces, but also for some
daemons, and especially for their privsep child processes - regardless
of whether they make use of namespaces (vsftpd) or not (openssh).

So maybe the restriction should apply to a process tree rather than to a
namespace?  Sure, in some cases it could be bypassed via ptrace(), but
the intended uses would be either in containers (separate pid namespace)
or in daemons' privsep child processes, which are hopefully running as a
pseudo-user dedicated to the daemon - so can't ptrace() anything else
because of uid mismatch, and can't ptrace() other instances because of
their dumpable flag having been reset on setuid().

Specifically, the prctl() could set your two proposed flag bits
affecting the following execve(), but it could also set a third bit,
which, when set, would immediately lock the current process to its
current bitness (or to current ABI in general) and would also lock
execve()'d binaries in the same way (although in practice such
processes will tend to be chrooted to /var/empty).

So we have three bits:

bit 0 - lock next execve() to 32-bit
bit 1 - lock next execve() to 64-bit
bit 2 - lock current process and execve() to current bitness/ABI

Specific bit combinations are interpreted as follows:

0 - no locking (current behavior)
1 - lock next execve() to 32-bit, fail it if not 32-bit ELF
2 - lock next execve() to 64-bit, fail it if not 64-bit ELF
3 - lock the next execve()'d process to its actual bitness
4 - lock current process and execve() to current bitness
5 - lock current process to current bitness, but execve() to 32-bit ELF
6 - lock current process to current bitness, but execve() to 64-bit ELF
7 - lock current process to current bitness, but next execve() to its actual bitness

5 to 7 are probably not very useful, but are defined for consistency.

Maybe when bit 2 is set, it should also disable ptrace() for the current
process (so that it can't ptrace() other processes even of matching uid).

How does this sound to you?

Concern/to-do: need to figure out how x32 and other ABIs fit into this.

Alexander
