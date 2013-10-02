Reply-To: kernel-hardening@lists.openwall.com
MIME-Version: 1.0
Sender: keescook@google.com
In-Reply-To: <CALCETrUcg4o5QeGMP1rRAzJSfjwS=qD3DsDWV3=fPJQOA3xkKw@mail.gmail.com>
References: <1380659178-28605-1-git-send-email-tixxdz@opendz.org>
	<524B7999.60806@amacapital.net>
	<20131002143759.GA2966@dztty>
	<CALCETrUcg4o5QeGMP1rRAzJSfjwS=qD3DsDWV3=fPJQOA3xkKw@mail.gmail.com>
Date: Wed, 2 Oct 2013 10:48:55 -0700
Message-ID: <CAGXu5j+APTTSKh_xvgpzV3wNYseQxafbKqQ3NyvUe50aGOOBGg@mail.gmail.com>
From: Kees Cook <keescook@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1
Subject: [kernel-hardening] Re: [PATCH v2 0/9] procfs: protect /proc/<pid>/* files with file->f_cred
To: Andy Lutomirski <luto@amacapital.net>
Cc: Djalal Harouni <tixxdz@opendz.org>, "Eric W. Biederman" <ebiederm@xmission.com>, Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ingo Molnar <mingo@kernel.org>, "Serge E. Hallyn" <serge.hallyn@ubuntu.com>, Cyrill Gorcunov <gorcunov@openvz.org>, David Rientjes <rientjes@google.com>, LKML <linux-kernel@vger.kernel.org>, Linux FS Devel <linux-fsdevel@vger.kernel.org>, "kernel-hardening@lists.openwall.com" <kernel-hardening@lists.openwall.com>, Djalal Harouni <tixxdz@gmail.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Wed, Oct 2, 2013 at 9:51 AM, Andy Lutomirski <luto@amacapital.net> wrote:
> On Wed, Oct 2, 2013 at 3:37 PM, Djalal Harouni <tixxdz@opendz.org> wrote:
>> On Tue, Oct 01, 2013 at 06:40:41PM -0700, Andy Lutomirski wrote:
>>> On 10/01/2013 01:26 PM, Djalal Harouni wrote:
>>> > /proc/<pid>/* entries varies at runtime, appropriate permission checks
>>> > need to happen during each system call.
>>> >
>>> > Currently some of these sensitive entries are protected by performing
>>> > the ptrace_may_access() check. However even with that the /proc file
>>> > descriptors can be passed to a more privileged process
>>> > (e.g. a suid-exec) which will pass the classic ptrace_may_access()
>>> > check. In general the ->open() call will be issued by an unprivileged
>>> > process while the ->read(),->write() calls by a more privileged one.
>>> >
>>> > Example of these files are:
>>> > /proc/*/syscall, /proc/*/stack etc.
>>> >
>>> > And any open(/proc/self/*) then suid-exec to read()/write() /proc/self/*
>>> >
>>> >
>>> > These files are protected during read() by the ptrace_may_access(),
>>> > however the file descriptor can be passed to a suid-exec which can be
>>> > used to read data and bypass ASLR. Of course this was discussed several
>>> > times on LKML.
>>>
>>> Can you elaborate on what it is that you're fixing?  That is, can you
>>> give a concrete example of what process opens what file and passes the
>>> fd to what process?
>> Yes, the references were already given in this email:
>> https://lkml.org/lkml/2013/8/31/209
>>
>> This has been discussed several times on lkml:
>> https://lkml.org/lkml/2013/8/28/544
>>
>> https://lkml.org/lkml/2013/8/28/564 (check Kees's references)
>>
>>
>>> I'm having trouble following your description.
>> Process open a /proc file and pass the fd to a more privilaged process
>> that will pass the ptrace_may_access() check, while the original process
>> that opened that file should fail at the ptrace_may_access()
>
> So we're talking about two kinds of attacks, right?

Correct.

> Type 1: Unprivileged process does something like open("/proc/1/maps",
> O_RDONLY) and then passes the resulting fd to something privileged.

... and then leaks contents back to unprivileged process.

> Type 2: Unprivileged process does something like
> open("/proc/self/maps", O_RDONLY) and then forks.  The parent calls
> execve on something privileged.

... and then parent snoops on file contents for the privileged child.

(Type 2 is solved currently, IIUC. Type 1 could be reduced in scope by
changing these file modes back to 0400.)

> Can we really not get away with fixing type 1 by preventing these
> files from being opened in the first place and type 2 by revoking all
> of these fds when a privilege-changing exec happens?

Type 1 can be done via exec as well. Instead of using a priv exec to
read an arbitrary process, read it could read its own.

I think revoking the fd would be great. Does that mechanism exist?

-Kees

-- 
Kees Cook
Chrome OS Security
