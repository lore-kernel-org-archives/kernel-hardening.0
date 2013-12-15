Reply-To: kernel-hardening@lists.openwall.com
From: Djalal Harouni <tixxdz@opendz.org>
Date: Sun, 15 Dec 2013 19:57:12 +0100
Message-Id: <1387133834-31966-1-git-send-email-tixxdz@opendz.org>
Subject: [kernel-hardening] [Resend] [PATCH 0/2] procfs: make /proc/*/{stack,syscall,pagemap} 0400
To: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Oleg Nesterov <oleg@redhat.com>, Andy Lutomirski <luto@amacapital.net>
Cc: Djalal Harouni <tixxdz@opendz.org>
List-ID: <kernel-hardening.lists.openwall.com>

The following patches make /proc/*/{stack,syscall,personality,pagemap}
0400.

These files contain sensitive information that can be used by an
unprivileged process to leak address space and bypass ASLR.


This is a resend, the original discussion:
https://lkml.org/lkml/2013/8/26/354

Ended by confirming this, and Kees Cook Acked the first patch.

Kees Cook also confirmed the security exposure here:
https://lkml.org/lkml/2013/8/28/564


So these patches only restore the original 0400 mode that will make
the VFS able to block unprivileged processes from getting file
descriptors on arbitrary privileged
/proc/*/{stack,syscall,personality,pagemap} files.


>From the first discussion no one picked the patches, so I included them
in the "procfs: protect /proc/*/* entries with file->f_cred" series:
https://lkml.org/lkml/2013/10/1/371

However, that attempt failed to have a general aggreemnt, so I'm
resending again but _only_ those two patches.

At least we have a VFS protection for now.


Djalal Harouni (2):
 procfs: make /proc/*/{stack,syscall,personality} 0400
 procfs: make /proc/*/pagemap 0400

 fs/proc/base.c | 16 ++++++++--------
 1 file changed, 8 insertions(+), 8 deletions(-)
