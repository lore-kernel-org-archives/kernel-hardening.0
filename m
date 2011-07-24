Reply-To: kernel-hardening@lists.openwall.com
Sender: Vasiliy Kulikov <segooon@gmail.com>
Date: Sun, 24 Jul 2011 22:55:21 +0400
From: Vasiliy Kulikov <segoon@openwall.com>
Message-ID: <20110724185521.GA2974@albatros>
References: <20110604200948.GA5850@shinshilla>
 <20110604205955.GA5972@openwall.com>
 <20110605182430.GA5789@albatros>
 <20110605192641.GA9240@openwall.com>
 <20110605194746.GA6484@albatros>
 <20110605201025.GA9541@openwall.com>
 <20110606180806.GA3986@albatros>
 <20110606183358.GA14711@openwall.com>
 <20110608172307.GA3380@albatros>
 <20110612023916.GC14976@openwall.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110612023916.GC14976@openwall.com>
Subject: Re: [kernel-hardening] [RFC v2] procfs mount options
To: kernel-hardening@lists.openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

Hi,

A small follow-up of my current work.

I'm implementing the scheme I've proposed on LKML.  Instead of on/off
semantics a mask of allowed files is passed as a mount option.  Like
this:

    mount -o tgid_allowed=.;cmdline;mounts;smaps /proc

All files not enumerated in tgid_allowed= will be restricted to
processes being able to ptrace the task.  Files enumerated in
tgid_allowed= are not additionally restricted and classic POSIX
permission checking rules are applied here.  So, it's impossible to
_relax_ procfs permissions with my scheme.

";" is used instead of "," as a comma is already used as options
separator.

Besides tgid_allowed= there will be attr_allowed= and tid_allowed= to
enumerated files in appropriate subdirectories.

As a "side effect" it will effectively fix all holes of poor permission
checking of setuid binaries (including check and execve() race) without
massive code refactoring.  (All future procfs files are already
protected too ;-))


Currently I have a working implementation of per-files restriction, but
without mount option parsing.  I'll post the code when I have a working
implementation of at least parsing and handling tgid_allowed=XXX.  Also
there is a (minor, I hope) issue with /proc/PID/maps handling, where
the ptrace check is too restrictive.

TODO: net restriction, privileged monitoring gid.

Thanks,

-- 
Vasiliy Kulikov
http://www.openwall.com - bringing security into open computing environments
