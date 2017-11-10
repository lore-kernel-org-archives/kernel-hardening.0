Date: Fri, 10 Nov 2017 13:56:18 +1100 (AEDT)
From: James Morris <james.l.morris@oracle.com>
In-Reply-To: <1510244046-3256-7-git-send-email-tixxdz@gmail.com>
Message-ID: <alpine.LFD.2.20.1711101356010.8844@localhost>
References: <1510244046-3256-1-git-send-email-tixxdz@gmail.com> <1510244046-3256-7-git-send-email-tixxdz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Subject: [kernel-hardening] Re: [PATCH RFC v3 6/7] proc: support new 'pids=all|ptraceable' mount
 option
To: Djalal Harouni <tixxdz@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, Alexey Gladkov <gladkov.alexey@gmail.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Akinobu Mita <akinobu.mita@gmail.com>, me@tobin.cc, Oleg Nesterov <oleg@redhat.com>, Jeff Layton <jlayton@poochiereds.net>, Ingo Molnar <mingo@kernel.org>, Alexey Dobriyan <adobriyan@gmail.com>, ebiederm@xmission.com, Linus Torvalds <torvalds@linux-foundation.org>, Daniel Micay <danielmicay@gmail.com>, Jonathan Corbet <corbet@lwn.net>, bfields@fieldses.org, Stephen Rothwell <sfr@canb.auug.org.au>, solar@openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On Thu, 9 Nov 2017, Djalal Harouni wrote:

> This patch introduces the new 'pids' mount option, as it was discussed
> and suggested by Andy Lutomirski [1].
> 
> * If 'pids=' is passed without 'newinstance' then it has no effect.
> 
> * If 'newinstance,pids=all' then all processes will be shown in proc.
> 
> * If 'newinstance,pids=ptraceable' then only ptraceable processes will be
> shown.
> 
> * 'pids=' takes precendence over 'hidepid=' since 'hidepid=' can be
>   ignored if "gid=" was set and caller has the "gid=" set in its groups.
>   We want to guarantee that LSM have a security path there that can not
>   be disabled with "gid=".
> 
> This allows to support lightweight sandboxes in Embedded Linux.
> 
> Later Yama LSM can be updated to check that processes are able only
> able to see their children inside /proc/, allowing to support more tight
> cases.
> 
> [1] https://lkml.org/lkml/2017/4/26/646
> 
> Cc: Kees Cook <keescook@chromium.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Suggested-by: Andy Lutomirski <luto@kernel.org>
> Signed-off-by: Alexey Gladkov <gladkov.alexey@gmail.com>
> Signed-off-by: Djalal Harouni <tixxdz@gmail.com>


Reviewed-by: James Morris <james.l.morris@oracle.com>


-- 
James Morris
<james.l.morris@oracle.com>
