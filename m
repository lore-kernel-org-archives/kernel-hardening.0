Reply-To: kernel-hardening@lists.openwall.com
Message-ID: <524B7999.60806@amacapital.net>
Date: Tue, 01 Oct 2013 18:40:41 -0700
From: Andy Lutomirski <luto@amacapital.net>
MIME-Version: 1.0
References: <1380659178-28605-1-git-send-email-tixxdz@opendz.org>
In-Reply-To: <1380659178-28605-1-git-send-email-tixxdz@opendz.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Subject: [kernel-hardening] Re: [PATCH v2 0/9] procfs: protect /proc/<pid>/* files with file->f_cred
To: Djalal Harouni <tixxdz@opendz.org>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, Kees Cook <keescook@chromium.org>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, David Rientjes <rientjes@google.com>, LKML <linux-kernel@vger.kernel.org>, linux-fsdevel@vger.kernel.org, kernel-hardening@lists.openwall.com, tixxdz@gmail.com
List-ID: <kernel-hardening.lists.openwall.com>

On 10/01/2013 01:26 PM, Djalal Harouni wrote:
> /proc/<pid>/* entries varies at runtime, appropriate permission checks
> need to happen during each system call.
> 
> Currently some of these sensitive entries are protected by performing
> the ptrace_may_access() check. However even with that the /proc file
> descriptors can be passed to a more privileged process
> (e.g. a suid-exec) which will pass the classic ptrace_may_access()
> check. In general the ->open() call will be issued by an unprivileged
> process while the ->read(),->write() calls by a more privileged one.
> 
> Example of these files are:
> /proc/*/syscall, /proc/*/stack etc.
> 
> And any open(/proc/self/*) then suid-exec to read()/write() /proc/self/*
> 
> 
> These files are protected during read() by the ptrace_may_access(),
> however the file descriptor can be passed to a suid-exec which can be
> used to read data and bypass ASLR. Of course this was discussed several
> times on LKML.

Can you elaborate on what it is that you're fixing?  That is, can you
give a concrete example of what process opens what file and passes the
fd to what process?

I'm having trouble following your description.

--Andy
