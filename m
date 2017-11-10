MIME-Version: 1.0
In-Reply-To: <1510244046-3256-3-git-send-email-tixxdz@gmail.com>
References: <1510244046-3256-1-git-send-email-tixxdz@gmail.com> <1510244046-3256-3-git-send-email-tixxdz@gmail.com>
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Fri, 10 Nov 2017 12:31:36 +0200
Message-ID: <CACVxJT8NPnoH+FiXUyyb5Ehjo=8MYhJvwWWWKi5WE7gmhtf_4A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Subject: [kernel-hardening] Re: [PATCH RFC v3 2/7] proc: move /proc/{self|thread-self} dentries
 to proc_fs_info
To: Djalal Harouni <tixxdz@gmail.com>
Cc: Kees Cook <keescook@chromium.org>, Alexey Gladkov <gladkov.alexey@gmail.com>, Andy Lutomirski <luto@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-hardening@lists.openwall.com, linux-security-module@vger.kernel.org, linux-api@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Alexander Viro <viro@zeniv.linux.org.uk>, Akinobu Mita <akinobu.mita@gmail.com>, me@tobin.cc, Oleg Nesterov <oleg@redhat.com>, Jeff Layton <jlayton@poochiereds.net>, Ingo Molnar <mingo@kernel.org>, ebiederm@xmission.com, Linus Torvalds <torvalds@linux-foundation.org>, Daniel Micay <danielmicay@gmail.com>, Jonathan Corbet <corbet@lwn.net>, bfields@fieldses.org, Stephen Rothwell <sfr@canb.auug.org.au>, solar@openwall.com
List-ID: <kernel-hardening.lists.openwall.com>

On 11/9/17, Djalal Harouni <tixxdz@gmail.com> wrote:

>  struct proc_fs_info {
>  	struct pid_namespace *pid_ns;
> +	struct dentry *proc_self; /* For /proc/self/ */
> +	struct dentry *proc_thread_self; /* For /proc/thread-self/ */

These are redundant comments.
