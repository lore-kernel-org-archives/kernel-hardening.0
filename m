Reply-To: kernel-hardening@lists.openwall.com
Date: Sun, 11 Mar 2012 09:46:02 +0100
From: Djalal Harouni <tixxdz@opendz.org>
Message-ID: <20120311084602.GC4310@dztty>
References: <1331421919-15499-1-git-send-email-tixxdz@opendz.org>
 <CA+55aFwdOgt=C52APPyvnAitcWNbzu-uXRi43m4bLS85oDgtqA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwdOgt=C52APPyvnAitcWNbzu-uXRi43m4bLS85oDgtqA@mail.gmail.com>
Subject: [kernel-hardening] Re: [PATCH 0/9] proc: protect /proc/<pid>/* files across execve
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, Andrew Morton <akpm@linux-foundation.org>, Al Viro <viro@zeniv.linux.org.uk>, Alexey Dobriyan <adobriyan@gmail.com>, "Eric W. Biederman" <ebiederm@xmission.com>, Vasiliy Kulikov <segoon@openwall.com>, Kees Cook <keescook@chromium.org>, Solar Designer <solar@openwall.com>, WANG Cong <xiyou.wangcong@gmail.com>, James Morris <james.l.morris@oracle.com>, Oleg Nesterov <oleg@redhat.com>, linux-security-module@vger.kernel.org, linux-fsdevel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <gregkh@linuxfoundation.org>, Ingo Molnar <mingo@elte.hu>, Stephen Wilson <wilsons@start.ca>, "Jason A. Donenfeld" <Jason@zx2c4.com>
List-ID: <kernel-hardening.lists.openwall.com>

On Sat, Mar 10, 2012 at 04:01:09PM -0800, Linus Torvalds wrote:
> I would in general suggest strongly against using exec_id for anything
> that involves files. It isn't designed for that, it's designed for the
> whole "check the parent exec_id" thing for ptrace, where that whole
> "pass things around to another process" approach doesn't work.
Yes exec_id for files can seem strange, but here we are speaking about
virtual files that are related to the image of the process being run,
these files are in reality just some portion of the process memory.


Linus please check the patch:
[PATCH 9/9] proc: improve and clean up /proc/<pid>/mem protection

I have explained why the current protection is not the best solution. The
oom killer will kill other processes including getty,klogd,... even root
owned ssh.

-- 
tixxdz
http://opendz.org
